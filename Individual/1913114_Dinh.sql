-------------------CAU1 PROCEDURE INSERT BẢNG DonVanChuyen--------------------------
GO
CREATE OR ALTER PROCEDURE insertDonVanChuyen
    @diaChiGiaoHang nvarchar (50), @thoiGianGiaoHang datetime, @thoiGianNhan datetime, @maTrangThaiDonHang int, @tienShip int, @maPhuongThucThanhToan int, @maKhachHang uniqueidentifier
    AS
    	DECLARE @count bit=0;
    	DECLARE @ma varchar(50);
    	DECLARE @maT int=0;
    	DECLARE @maP int=0;
    	SET @ma= @maKhachHang;
    	DECLARE @CountKhachHang int =0;
    	SELECT @CountKhachHang = COUNT(*)
    	FROM KhachHang
    	WHERE maKhachHang = @maKhachHang
    	SELECT @maT=COUNT(*)
    	FROM TrangThaiDon
    	WHERE @maTrangThaiDonHang=maTrangThai
    	SELECT @maP=COUNT(*)
    	FROM PhuongThucThanhToan
    	WHERE @maPhuongThucThanhToan=maPhuongThuc
    	IF (@CountKhachHang=0)
    		BEGIN
    			SET @count=1;
    			RAISERROR('Khong ton tai khach hang trong he thong co ma so khach hang: %s.',16,1, @ma);
    		END
    	IF (@thoiGianGiaoHang >= @thoiGianNhan)
    		BEGIN
    			SET @count=1;
    			RAISERROR('Thoi gian nhan hang phai lon hon thoi gian giao hang.',16,1);
    		END
    	IF (@thoiGianGiaoHang<GETDATE())
    		BEGIN
    			SET @count=1;
    			RAISERROR('Thoi gian giao hang phai lon hon hoac bang thoi gian hien tai.',16,1);
    		END
    	IF (@thoiGianNhan <= GETDATE())
    		BEGIN
    			SET @count=1;
    			RAISERROR('Thoi gian nhan hang phai lon hon thoi gian hien tai.',16,1);
    		END
    	IF(@maT=0)
    	    BEGIN
    			SET @count=1;
    			RAISERROR('Khong ton tai ma trang thai don hang trong he thong co ma trang thai don hang: %i.',16,1, @maTrangThaiDonHang);
    		END
    	IF (@tienShip <0)
    		BEGIN
    			SET @count=1;
    			RAISERROR('Tien ship phai la so khong am.',16,1);
    		END
    	IF(@maP=0)
    	    BEGIN
    			SET @count=1;
    			RAISERROR('Khong ton tai ma phuong thuc thanh toan trong he thong co ma phuong thuc thanh toan: %i.',16,1,@maPhuongThucThanhToan);
    		END
    	IF @diaChiGiaoHang=''
    		BEGIN
    		    SET @count=1;
    			RAISERROR('Khong cho phep de trong dia chi giao hang.',16,1);
    		END
    	IF @count=1
    		BEGIN
    			RETURN;
    		END
    	INSERT INTO DonVanChuyen (diaChiGiaoHang,thoiGianGiaoHang,thoiGianNhan,maTrangThaiDonHang,tienShip,maPhuongThucThanhToan,maKhachHang)
    	VALUES (@diaChiGiaoHang,@thoiGianGiaoHang, @thoiGianNhan, @maTrangThaiDonHang, @tienShip, @maPhuongThucThanhToan, @maKhachHang)
GO
--test
   EXEC insertDonVanChuyen @diaChiGiaoHang="Phu Yen", @thoiGianGiaoHang='2021-11-28 15:00',
		@thoiGianNhan='2021-11-29 15:00', @maTrangThaiDonHang=1, @tienShip='30000', @maPhuongThucThanhToan=2,
		@maKhachHang='D5301A05-CE35-4F81-8EBC-93980D39DAB6'
   EXEC insertDonVanChuyen @diaChiGiaoHang="Phu Yen", @thoiGianGiaoHang='2021-11-30 15:00',
		@thoiGianNhan='2021-12-1 15:00', @maTrangThaiDonHang=1, @tienShip='30000', @maPhuongThucThanhToan=2,
		@maKhachHang='00EF302E-E8BA-465A-BFA9-1576979DF3FB'
GO

--------------------------------CAU2 TRIGGER--------------------------
--------------trigger1----------------------
--Cập nhật tổng tiền đơn món khi insert delete update một món vào đơn chi tiết món ăn, và ko cho cập nhật sô lượng món ăn là âm
CREATE OR ALTER TRIGGER updateTongTienDonMonAnInsert ON ChiTietDonMonAn
FOR INSERT
AS
 DECLARE @maDon int;
 DECLARE @dongia int;
 DECLARE @soluong int;
 DECLARE @donGiaUuDai int;
 SELECT @maDon=maDonMonAn, @dongia=donGiaMon,@soluong=soLuong, @donGiaUuDai=donGiaUuDai FROM INSERTED;
 BEGIN
    UPDATE DonMonAn
	SET tongTienMon=0
	WHERE DonMonAn.maDon=@maDon AND tongTienMon IS NULL
	UPDATE DonMonAn
	SET tongTienMon=tongTienMon+(@donGiaUuDai*@soluong)
	WHERE DonMonAn.maDon=@maDon
 END
----test
 INSERT INTO ChiTietDonMonAn
  VALUES(6,3,3,0,35000,35000)

CREATE OR ALTER TRIGGER updateTongTienDonMonAnUpdate ON ChiTietDonMonAn
FOR UPDATE
AS
 DECLARE @maDon int;
 DECLARE @maMonAn int;
 DECLARE @dongia int;
 DECLARE @soluong int;
 DECLARE @donGiaUuDai int;
 DECLARE @dongiacu int;
 DECLARE @soluongcu int;
 DECLARE @donGiaUuDaicu int;
 SELECT  @maMonAn=maMonAn,@maDon=maDonMonAn, @dongia=donGiaMon,@soluong=soLuong, @donGiaUuDai=donGiaUuDai FROM INSERTED;
 SELECT  @dongiacu=donGiaMon,@soluongcu=soLuong, @donGiaUuDaicu=donGiaUuDai FROM DELETED;
 BEGIN
	IF(@soluong<0)
	BEGIN
		RAISERROR ('So luong mon khong duoc am.', 16, 1);
		ROLLBACK; 
		RETURN;
	END;
	UPDATE DonMonAn
	SET tongTienMon=tongTienMon-(@donGiaUuDaicu*@soluongcu)+(@donGiaUuDai*@soluong)
	WHERE DonMonAn.maDon=@maDon
	IF(@soluong<=0)
	DELETE FROM ChiTietDonMonAn
	WHERE @maDon=maDonMonAn AND @maMonAn=maMonAn
	DELETE FROM DonMonAn
	WHERE tongTienMon=0
 END
 ----test
 UPDATE ChiTietDonMonAn SET soLuong=6
  WHERE maDonMonAn=1044 and maMonAn=6

CREATE OR ALTER TRIGGER updateTongTienDonMonAnDelete ON ChiTietDonMonAn
FOR DELETE
AS
 DECLARE @maDon int;
 DECLARE @dongia int;
 DECLARE @soluong int;
 DECLARE @donGiaUuDai int;
 SELECT  @maDon=maDonMonAn, @dongia=donGiaMon,@soluong=soLuong, @donGiaUuDai=donGiaUuDai FROM DELETED;
 BEGIN
	UPDATE DonMonAn
	SET tongTienMon=tongTienMon-(@donGiaUuDai*@soluong)
	WHERE DonMonAn.maDon=@maDon
	DELETE FROM DonMonAn
	WHERE tongTienMon=0
 END
----test
DELETE FROM ChiTietDonMonAn WHERE maDonMonAn=1044 and maMonAn=6

--------------trigger2----------------------
--khi insert nhân viên, nhân viên phải trên 18 tuổi
CREATE OR ALTER TRIGGER insertNhanVien1 ON NhanVien
FOR INSERT
AS
 DECLARE @nam int;
 DECLARE @thang int;
 DECLARE @ngay int;
 DECLARE @ngaySinh DATETIME;
 SELECT @ngaySinh=ngaySinh FROM INSERTED;
 SELECT @nam=DATEDIFF(YEAR,@ngaySinh,GETDATE());
 SELECT @thang=DATEDIFF(MONTH,@ngaySinh,GETDATE());
 SELECT @ngay=DATEDIFF(DAY,@ngaySinh,GETDATE());
 IF(@nam<18 OR (@nam=18 AND @thang<216) OR (@nam=18 AND @thang=216 AND @ngay<6575))
 BEGIN
		RAISERROR ('Không cho phép nhân viên của công ty dưới 18 tuổi.', 16, 1);
		ROLLBACK; 
		RETURN;
 END
 ----test
 INSERT INTO NhanVien
 VALUES(newID(),'luu','cong','dinh','2021-11-23',2000,'luucongdinh8','Dinh@123','nhanvien',5,1,'2004-11-27')
 INSERT INTO NhanVien
 VALUES(newID(),'luu','cong','dinh','2021-11-23',2000,'luucongdinh8', 'Dinh@123','nhanvien',5,1,'2003-11-27')

--Cứ đầu tháng thì hệ thống sẽ update rating của shipper của nhân viên lại 2.5;
--Nếu tháng trước nhân viên shipper có rating >4 thì sẽ được tăng 5% lương, ngược lại nếu <1 thì sẽ trừ 5 % lương
CREATE OR ALTER TRIGGER updateShipper ON Shipper
FOR UPDATE
AS
 DECLARE @rating int;
 DECLARE @date int;
 SELECT @date=Day(GETDATE());
 DECLARE @id uniqueidentifier;
 SELECT @id=maNhanVien,@rating=rating FROM DELETED;
 IF(@rating>=4 AND @date=1 )
 BEGIN
		UPDATE NhanVien
		SET luong*=1.05
		WHERE @id=maNhanVien
 END
 IF(@rating<=1 AND @date=1)
 BEGIN
		UPDATE NhanVien
		SET luong*=0.95
		WHERE @id=maNhanVien
 END
--test
 UPDATE Shipper
 SET rating=2.5
 WHERE maNhanVien='1064E48F-D79A-4BC3-9CC2-39855638094B'

 --------------trigger3----------------------
--Khi xóa quản lý trên bản quản lý, thì sẽ set NULL loại nhân viên trên bản nhân viên, và set null nvQuanLi trên bản chi nhánh
CREATE OR ALTER TRIGGER deleteQuanLi ON QuanLi
INSTEAD OF DELETE
AS
	DECLARE @maNhanVien uniqueidentifier;
	SELECT @maNhanVien=maNhanVien FROM DELETED;
	BEGIN
		UPDATE NhanVien
		SET loaiNhanVien=NULL
		WHERE @maNhanVien=maNhanVien
		UPDATE ChiNhanh
		SET maNVQuanLy=NULL
		WHERE @maNhanVien=maNVQuanLy
		DELETE FROM QuanLi where maNhanVien =@maNhanVien
	END
--Test

select NV.ho +' '+ NV.tenLot +' '+ NV.ten as hoVaTen,NV.maNhanVien , C.maDonVi ,C.tenChiNhanh 
from QuanLi Q, NhanVien NV, ChiNhanh C
where Q.maNhanVien =NV.maNhanVien and Q.maNhanVien =C.maNVQuanLy and Q.maNhanVien ='8CA3C275-285D-4C46-9E28-4A11442F5E76'

DELETE FROM QuanLi where maNhanVien ='8CA3C275-285D-4C46-9E28-4A11442F5E76'

------------------------------CAU3 PROCEDURE--------------------------
--1--
--Lấy danh sách món ăn thuộc các nhà tại một địa điểm nào đó
CREATE OR ALTER  PROCEDURE selectMonAnThuocNhaHang
@diachi nvarchar(50)
AS
	SELECT  N.tenNhaHang,M.tenMonAn,N.maNhaHang,M.maMonAn,M.image,M.donGia,M.isActive 
	FROM NhaHang as N, MonAn as M
	WHERE N.maNhaHang=M.maNhaHangOffer AND N.diaChi=@diachi
	ORDER BY M.isActive DESC ,N.tenNhaHang,M.tenMonAn
EXEC selectMonAnThuocNhaHang @diachi='Phu Yen'

--2--
--Tính tổng số món ăn của các nhà hàng tại địa điểm nào đó
CREATE  OR ALTER PROCEDURE tongSoMonAnofNhaHang
@diachi1 nvarchar(50)
AS
	SELECT  N.tenNhaHang,Count(M.maMonAn) as tongSoMonAn
	FROM NhaHang as N, MonAn as M
	WHERE N.maNhaHang=M.maNhaHangOffer
	GROUP BY N.tenNhaHang,N.diaChi HAVING N.diaChi=@diachi1
	ORDER BY N.tenNhaHang
EXEC tongSoMonAnofNhaHang @diachi1='Phu Yen'

--------------------------------Câu 4 function--------------------------------
-- function1:
-- Để đánh giá chung thái độ, trách nhiệm của shipper, công ty cần thống kê lại tỉ lệ shipper có chỉ số rating lớn hơn x. Để tìm rating trung bình, từ đó
-- có những quyết định khen thưởng
Go
Create OR ALTER function RatioPrestige_TypeOfEmPloyeeShipper(@chiso as float(1))
Returns @TiLe table(
	TongsoShipper int,
	TileSpUp NUMERIC(3,2),
	TileSpDown NUMERIC(3,2)
)
As
Begin
	If(@chiso<0 or @chiso>5)
		Insert into @TiLe values(0,0,0);
	Else 
		Begin
			DECLARE ShipperList CURSOR 
				FOR SELECT DISTINCT E.maNhanVien, E.rating
					FROM Shipper E, NhanVien F
					WHERE E.maNhanVien=F.maNhanVien and F.isActive=1;

				Declare @maNV uniqueidentifier
				Declare @rating decimal(2,1)
				Declare @totalShipper float
				Set @totalShipper =0;
				Declare @totalUp float
				Set @totalUp =0
				Declare @TotalDown float
				Set @TotalDown=0;
				Declare @TisoDown float(2)
				Declare @TisoUp float(2)
				

				OPEN  ShipperList
				FETCH NEXT FROM ShipperList
				INTO @maNV,@rating
				WHILE(@@FETCH_STATUS=0)
				BEGIN
					Set @totalShipper =@totalShipper+1;
					If(@rating>=@chiso)
						Set @totalUp =@totalUp+1;
					Else Set @TotalDown =@TotalDown+1;
					FETCH NEXT FROM ShipperList
					INTO @maNV,@rating
				END;
				Set @TisoDown = (@TotalDown/@totalShipper);
				Set @TisoUp = (1-@TisoDown);
				
				CLOSE ShipperList;
				DEALLOCATE ShipperList;
	END
		Insert into @TiLe values(@totalShipper,CAST(@TisoUp AS NUMERIC(3,2)),CAST(@TisoDown AS NUMERIC(3,2)))
	RETURN;
end;
GO
select F.ten ,E.rating,F.loaiNhanVien 
FROM Shipper E, NhanVien F
WHERE E.maNhanVien=F.maNhanVien and F.isActive=1 
select * from RatioPrestige_TypeOfEmPloyeeShipper(4.4);

--function 2: Thống kê tỉ lệ các loại nhân viên của công ty để làm báo cáo chung về đội ngũ nhân sự đang làm việc của công ty.
GO
Create or alter function Ratio_TypeOfEmPloyee(@nameChiNhanh nvarchar(50))
Returns @TiLeNV table(
	TongsoNhanVien int,
	TongsoShipper int,
	TongsoTongDaiVien int,
	TongsoQuanLy int,
	TileQl NUMERIC(3,2),
	TileTDV NUMERIC(3,2),
	TileShipper NUMERIC(3,2)
)
As
Begin
			DECLARE NVList CURSOR 
				FOR SELECT DISTINCT N.maNhanVien, N.loaiNhanVien
					FROM NhanVien N, ChiNhanh C, NhanVienChiNhanh NC
					WHERE N.maNhanVien =NC.maNhanVien and C.maDonVi =NC.maDonVi  and N.isActive=1 and C.tenChiNhanh =@nameChiNhanh;

				Declare @maNV uniqueidentifier
				Declare @loaiNV nvarchar(20)
				Declare @totalNV int
				Set @totalNV =0;
				Declare @totalShipper int
				Set @totalShipper =0;
				Declare @totalTDV int
				Set @totalTDV =0;
				Declare @totalQL int
				Set @totalQL =0;
				
				Declare @TisoQL float(2)
				Declare @TisoTDV float(2)
				Declare @TisoSP float(2)
				

				OPEN  NVList
				FETCH NEXT FROM NVList
				INTO @maNV,@loaiNV
				WHILE(@@FETCH_STATUS=0)
				BEGIN
					Set @totalNV =@totalNV+1;
					If(@loaiNV ='Quan ly')
						Set @totalQL =@totalQL+1;
					IF(@loaiNV='Tong dai vien')
						set @totalTDV=@totalTDV+1;
					IF(@loaiNV='Shipper')
						set @totalShipper =@totalShipper+1;
					
					FETCH NEXT FROM NVList
					INTO  @maNV,@loaiNV
				END;
				Set @TisoQL = Cast((@totalQL)as float(2))/Cast((@totalNV) as float(2));
				Set @TisoTDV = Cast((@totalTDV)as float(2))/Cast((@totalNV) as float(2));
				Set @TisoSP = Cast((1-@TisoQL -@TisoTDV) as float(2));
				CLOSE NVList;
				DEALLOCATE NVList;
		Insert into @TiLeNV values(@totalNV,@totalShipper,@totalTDV,@totalQL,CAST(@TisoQL AS NUMERIC(3,2)),CAST(@TisoTDV AS NUMERIC(3,2)),CAST(@TisoSP AS NUMERIC(3,2)));
	RETURN;
end;
GO
select *
FROM NhanVien N, ChiNhanh C, NhanVienChiNhanh NC
WHERE N.maNhanVien =NC.maNhanVien and C.maDonVi =NC.maDonVi  and N.isActive=1 and C.tenChiNhanh='Tong cong ty';
select * from Ratio_TypeOfEmPloyee('Tong cong ty');
