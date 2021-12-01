 
 
 --***************************CAU 1 PROCEDURE INSERT BANG NHAN VIEN***************************--
 
 ---------------------SOLUTION---------------------------------

CREATE OR ALTER PROCEDURE insertNhanVien
@ho nvarchar(20),@tenLot nvarchar(20) ='',@ten nvarchar(20), @luong decimal,
@taiKhoan nvarchar(50)='', @matKhau nvarchar(50) ='',@loaiNhanVien nvarchar(20)='',
@chiSoUyTin decimal(2,1)=5.0,@ngaySinh Date
AS
	IF(@chiSoUyTin>5 OR @chiSoUyTin<1)
	BEGIN 
		RAISERROR('Chi so uy tin phai la so nam trong khoang tu 1 den 5',16,1);
		RETURN;
	END

	IF(@luong < 0)
	BEGIN
		RAISERROR('Luong phai la so duong',16,1);
		RETURN;
	END

    IF(LEN(@matkhau)<8)
    BEGIN
    	RAISERROR('Mat khau phai tu 8 ky tu tro len',16,1);
    	RETURN
    END

    IF(@ho LIKE '%[^a-zA-Z]%')
    BEGIN
    	RAISERROR('Ho chi duoc chua cac ky tu Alphabet',16,1);
    	RETURN
    END

    IF(@ten LIKE '%[^a-zA-Z]%')
    BEGIN
    	RAISERROR('Ten chi duoc chua cac ky tu Alphabet',16,1);
    	RETURN
    END

    IF(DATEDIFF(year,@ngaySinh,GETDATE())<18)
    BEGIN
    	RAISERROR('Nhan vien phai tren 18 tuoi',16,1);
    	RETURN
    END

    IF(@taiKhoan IN ((SELECT taikhoan FROM NhanVien UNION SELECT taiKhoan FROM NhaHang) UNION SELECT taiKhoan FROM KhachHang))
    BEGIN
    	RAISERROR('Tai khoan trung, xin thu lai bang ten khac',16,1);
    	RETURN
    END

    INSERT INTO NhanVien (ho, tenLot,ten,luong, taiKhoan,matKhau,loaiNhanVien,chiSoUyTin,ngaySinh)
    VALUES (@ho,@tenLot,@ten,@luong, @taiKhoan,@matKhau,@loaiNhanVien,@chiSoUyTin,@ngaySinh)

GO
----------------------KIEM TRA THU TUC INSERT----------------------
EXEC insertNhanVien @ho='Luong',@ten='Phi&',@luong='6200000', @taiKhoan='luongphi123',@matKhau='123456789'
,@loaiNhanVien='quan ly',@ngaySinh='1999-10-08'

EXEC insertNhanVien @ho='Luong',@ten='Phi',@luong='6200000', @taiKhoan='luongphi123',@matKhau='123456789'
,@loaiNhanVien='quan ly',@ngaySinh='1999-07-11'
GO





--*******************************Cau 2 TRIGGER*******************************************--


--Trigger 1: Trigger sau khi insert hay update nhân viên vào bảng nhân viên, nếu trường loại nhân viên 
--(field loaiNhanVien) được insert vào hay được up-date thành quản lý hoặc tổng đài viên, 
--trigger sẽ fire và tự động insert thêm mã nhân viên vào hai bảng quản lý và tổng đài viên tương 
--ứng (chỉ insert khi chưa có mã nhân viên đó trong hai bảng này). Khi một nhân viên nghĩ làm ở công ty, 
--để lưu trữ dữ liệu của các nhân viên cũ cùng với các hoạt động của nhân viên đó trên các bảng, nên thay vì 
--xóa ta thêm trường isActive vào relation nhân viên, dùng trigger tự động set biến này bằng 0 khi ta xóa nhân viên 
--đi. Biến này default sẽ là 1.

 ---------------------SOLUTION---------------------------------

CREATE TRIGGER updateNhanVien ON NhanVien 
FOR INSERT, UPDATE
AS
   DECLARE @type  nvarchar(20);
   DECLARE @id uniqueidentifier;
   SELECT @type=loaiNhanVien,@id=maNhanVien FROM inserted;
   IF (lower(@type)='quan ly' AND @id NOT IN (SELECT maNhanVien FROM QuanLi))
   BEGIN
    	INSERT INTO QuanLi (maNhanVien) VALUES (@id)
   END
   ELSE IF (lower(@type)='tong dai vien' AND @id NOT IN (SELECT maNhanVien FROM TongDaiVien))
   BEGIN
    	INSERT INTO tongDaiVien (maNhanVien) VALUES (@id)
   END
    
GO

ALTER TABLE NhanVien
ADD isActive BIT DEFAULT 1;

GO    
-- Trigger for deleting
CREATE TRIGGER deleteNhanVien ON NhanVien 
INSTEAD OF DELETE
AS
   DECLARE @id uniqueidentifier;
   SELECT @id=maNhanVien FROM deleted;
   UPDATE NhanVien SET isActive=0 WHERE maNhanVien=@id

GO
-------------------------Test trigger 1------------------------------
--Them quan ly Luong Son Ba 
INSERT INTO NhanVien(ho,tenLot,ten,ngayVaoLam,luong,taiKhoan,matKhau,loaiNhanVien,chiSoUyTin) 
VALUES ( 'Luong','Son','Ba','2017-08-22',6200000,'sonba123','123456789','Tong dai vien', 4.3)
    
--Update quan ly Quang thanh tong dai vien
UPDATE NhanVien SET loaiNhanVien='Tong dai vien' 
WHERE ten='Quang'
    
--Delete quan ly Quang
DELETE FROM NhanVien WHERE ho like 'Quang';

GO




--Trigger 2: Tự động tăng lương , và giảm lương cho tổng đài viên tùy theo số lần tư vấn khách hàng. Cụ thê:
--  – Tăng lên 5% lương cho cứ mỗi 3 lần phục vụ khách hàng của tổng đài viên. Tức sau mỗi cột mốc: 
-- 3 lần, 6 lần 9 lần,...
--  – Giảm lương tương ứng khi xóa đi record liên quan đến tổng đài viên trong bảng tổng đài viên tư vấn 
-- khách hàng. (bảng TuVanGiaiDap). Tức sau mỗi cột mốc dưới 3 lần, dưới 6 lần, dưới 9 lần,...


 ---------------------SOLUTION---------------------------------

-- Trigger insert tang luong cho Tong dai vien tu van hon 3 nguoi    
CREATE OR ALTER TRIGGER tangLuongTuVan ON TuVanGiaiDap
AFTER INSERT
AS 
	DECLARE @count INT;
	DECLARE @idTongDai uniqueidentifier;
	SELECT @idTongDai=maTongDaiVien FROM inserted;
	SELECT @count=COUNT(*) FROM TuVanGiaiDap WHERE maTongDaiVien=@idTongDai;
	IF(@count%3=0)
	BEGIN
		UPDATE NhanVien set luong=luong*1.05 WHERE maNhanVien=@idTongDai
	END
GO
    
-- Trigger update tang luong cho Tong dai vien tu van hon 3 nguoi
CREATE OR ALTER TRIGGER tangLuongTuVanUpdate ON TuVanGiaiDap
AFTER UPDATE
AS 
	DECLARE @count INT;
	DECLARE @idTongDai uniqueidentifier;
	SELECT @idTongDai=maTongDaiVien FROM inserted;
	IF (UPDATE(maTongDaiVien))
	BEGIN
		SELECT @count=COUNT(*) FROM TuVanGiaiDap WHERE maTongDaiVien=@idTongDai;
		IF(@count%3=0)
		BEGIN
			UPDATE NhanVien set luong=luong*1.05 WHERE maNhanVien=@idTongDai;
		END
	END

GO
    
-- Trigger delete giam luong tong dai vien tu van duoi 3 nguoi.
CREATE OR ALTER TRIGGER giamLuongTuVan ON TuVanGiaiDap
AFTER DELETE
AS 
	DECLARE @count INT;
	DECLARE @idTongDai uniqueidentifier;
	SELECT @idTongDai=maTongDaiVien FROM deleted;
	IF(EXISTS (SELECT maTongDaiVien FROM TuVanGiaiDap WHERE maTongDaiVien=@idTongDai))
	BEGIN
		SELECT @count=COUNT(*) FROM TuVanGiaiDap WHERE maTongDaiVien=@idTongDai;
		IF(@count%3=2)
			BEGIN
				UPDATE NhanVien set luong=luong*0.95 WHERE maNhanVien=@idTongDai;
			END
	END

GO

---------------------Kiem tra trigger 2----------------------------
INSERT INTO TuVanGiaiDap(maTongDaiVien,maKhachHang,record,vanDe) VALUES
('5DC7ECA3-CB2A-48C8-832B-02285839C528','1B313134-292A-40BA-9A1E-2A6F12A3BFD8','record1.mv','Tu van dich vu'),
('5DC7ECA3-CB2A-48C8-832B-02285839C528','EFE678D1-6E3F-4C52-9901-2AEF0278A75B','record2.mv','Tu van dich vu'),
('5DC7ECA3-CB2A-48C8-832B-02285839C528','E6F01568-46C5-4434-9F63-6ECB195FF581','record3.mv',N'Tu van dich vu')
    
DELETE FROM TuVanGiaiDap WHERE maKhachHang='E6F01568-46C5-4434-9F63-6ECB195FF581'


GO




--******************CAU 3 PROCEDURE CONTAINS QUERY STATEMENT*****************--

-- Thủ tục a: PROCEDURE hiển thị các thông tin ưu đãi của nhà hàng đối với món ăn X trong đơn hàng. 
--(tham số là id món ăn kiểu dữ liệu interger). Thủ tục này liên quan đến hai bảng món ăn (MonAn) và ưu đãi (UuDai).

 ---------------------SOLUTION---------------------------------

CREATE OR ALTER PROCEDURE thongTinUuDai
@idMonAn int
AS
	SELECT M.tenMonAn,M.donGia , M.donGia*(1-U.discount) as giaDaUuDai,U.tenUuDai,U.discount,U.moTa,U.ngayHetHan
	FROM MonAn M JOIN UuDai U ON (M.maMonAn=U.maMonAn)
	WHERE M.maMonAn=@idMonAn
	ORDER BY discount DESC


GO
------------------- TEST PROCEDURE A--------------------
EXEC thongtinUuDai 1

GO



-- Thủ tục b:PROCEDURE hiển thị các khách hàng có số đơn đặt cao nhất ở địa chỉ X.Và sắp xếp các khách 
-- hàng theo thứ tự tăng dần số tiền ship thu được từ khách hàng.(tham số là địa chỉ nhà hàng kiểu dữ 
-- liệu varchar). Thủ tục này có liên quan đến hai bảng khách hàng (KhachHang) và đơn vận chuyển 
-- (DonVanChuyen) (Hình 14).

 ---------------------SOLUTION---------------------------------
CREATE OR ALTER PROCEDURE khachHangSop
@diaChi varchar(50)
AS
	SELECT K.maKhachHang,K.Ho,K.tenLot ,K.Ten,K.diaChi,COUNT(*) as SoDon,SUM(D.tienShip) as TongTien
	FROM KhachHang K, DonVanChuyen D
	WHERE K.maKhachHang=D.maKhachHang AND D.tienShip IS NOT NULL AND LOWER(K.diaChi)=LOWER(@diaChi)
	GROUP BY K.maKhachHang, K.diaChi,K.Ho,K.tenLot ,K.Ten
	HAVING COUNT(*) IN (SELECT MAX(T.SoDon) as soDonMax
						FROM (SELECT COUNT(*) as SoDon
							  FROM KhachHang K, DonVanChuyen D
							  WHERE K.maKhachHang=D.maKhachHang AND D.tienShip IS NOT NULL 
							        AND LOWER(K.diaChi)=LOWER(@diaChi)
							  GROUP BY K.maKhachHang) T)
	ORDER BY SUM(D.tienShip) ASC

GO
------------------- TEST PROCEDURE B--------------------
EXEC khachHangSop 'pHu YEN'

GO


--**********************CAU 4 FUNCTION***********************--

--	Hàm 1:Nhân viên tổng đài viên ở chi nhánh X được thưởng tiền theo số lần tư vấn với khách hàng, ai tư vấn 
--hơn 10 lần được thưởng 4tr, hơn 5 lần được thẳng 2.5 tr, hơn 3 lần được thưởng 2 tr. Tính tổng số tiền cần để 
--thưởng cho nhân viên của chi nhánh X.

 ------------------------SOLUTION---------------------------------
CREATE OR ALTER FUNCTION thuongLuongTuVan (@brandID as INT)
RETURNS  @tienThuong TABLE(
	maChiNhanh INT,
	tongTien INT default 0
)
AS
BEGIN
	DECLARE tuVanCursor CURSOR 
	FOR SELECT COUNT(*) as soLan
		FROM TuVanGiaiDap T,NhanVienChiNhanh N
		WHERE T.maTongDaiVien=N.maNhanVien AND N.maDonVi=@brandID
		GROUP BY maTongDaiVien

	DECLARE @tongTien INT
	SET @tongTien =0;

	DECLARE  @soLan INT;
	
	OPEN tuVanCursor
	FETCH NEXT FROM tuVanCursor
	INTO @soLan

	WHILE (@@FETCH_STATUS=0)
	BEGIN
		IF(@soLan>10)
			SET @tongTien=@tongTien+4000000;
		ELSE IF (@soLan>5)
			SET @tongTien=@tongTien+2500000;
		ELSE IF (@soLan>3)
			SET @tongTien=@tongTien+2000000;
		FETCH NEXT FROM tuVanCursor
		INTO @soLan
	END
	INSERT INTO @tienThuong(maChiNhanh,tongTien) VALUES (@brandID,@tongTien)
	CLOSE tuVanCursor;
	DEALLOCATE tuVanCursor;
	RETURN 
END

GO

------------------- TEST FUNCTION 1 --------------------
INSERT INTO NhanVienChiNhanh(maNhanVien,maDonVi) VALUES
('D678D259-21A7-48F1-9C9D-D909C339DB96',1),
('7A1617D3-D191-4E70-AEDF-A014C8319FD0',1)


INSERT INTO TuVanGiaiDap(maTongDaiVien,maKhachHang,record,vanDe) VALUES
('D678D259-21A7-48F1-9C9D-D909C339DB96','1B313134-292A-40BA-9A1E-2A6F12A3BFD8','record1.mv',N'Tư vấn về dịch vụ' ),
('D678D259-21A7-48F1-9C9D-D909C339DB96','1B313134-292A-40BA-9A1E-2A6F12A3BFD8','record2.mv',N'Tư vấn về dịch vụ' ),
('D678D259-21A7-48F1-9C9D-D909C339DB96','1B313134-292A-40BA-9A1E-2A6F12A3BFD8','record3.mv',N'Tư vấn về dịch vụ' ),
('D678D259-21A7-48F1-9C9D-D909C339DB96','1B313134-292A-40BA-9A1E-2A6F12A3BFD8','record4.mv',N'Tư vấn về dịch vụ' ),
('D678D259-21A7-48F1-9C9D-D909C339DB96','1B313134-292A-40BA-9A1E-2A6F12A3BFD8','record5.mv',N'Tư vấn về dịch vụ' ),
('D678D259-21A7-48F1-9C9D-D909C339DB96','1B313134-292A-40BA-9A1E-2A6F12A3BFD8','record6.mv',N'Tư vấn về dịch vụ' ),
('7A1617D3-D191-4E70-AEDF-A014C8319FD0','EFE678D1-6E3F-4C52-9901-2AEF0278A75B','record1.mv',N'Tư vấn về dịch vụ'),
('7A1617D3-D191-4E70-AEDF-A014C8319FD0','EFE678D1-6E3F-4C52-9901-2AEF0278A75B','record2.mv',N'Tư vấn về dịch vụ'),
('7A1617D3-D191-4E70-AEDF-A014C8319FD0','EFE678D1-6E3F-4C52-9901-2AEF0278A75B','record3.mv',N'Tư vấn về dịch vụ'),
('7A1617D3-D191-4E70-AEDF-A014C8319FD0','EFE678D1-6E3F-4C52-9901-2AEF0278A75B','record4.mv',N'Tư vấn về dịch vụ')

SELECT * FROM dbo.thuongLuongTuVan(1)


GO


--Hàm 2:Trong một ngày lễ, công ty quyết định tặng hàng loạt mã discount 20% cho các khách hàng thân thiết 
--của mình , là khách hàng có ngày tham gia bé hơn ngày tháng năm X. Mã này sẽ được tặng dựa theo số tiền 
--ship thu được từ khách hàng. Số tiền này nếu lớn hơn 100 nghìn thì được tặng 3 mã. Hơn 50 nghìn được tặng 
--2 mã. Tính tổng số mã discount 20% mà công ty phải tặng cho khách hàng thân thiết.

 ------------------------SOLUTION---------------------------------
CREATE OR ALTER FUNCTION tangUuDai (@dateTime as Date)
RETURNS INT
AS
BEGIN
	DECLARE uuDaiCursor CURSOR 
	FOR  SELECT SUM(D.tienShip) as tienThuDuoc
		 FROM DonVanChuyen D,KhachHang K
		 WHERE D.maKhachHang=K.maKhachHang AND K.ngayThamGia<@dateTime AND D.tienShip IS NOT NULL
		 GROUP BY K.maKhachHang

	DECLARE @tongTheUuDai INT
	SET @tongTheUuDai =0;

	DECLARE  @tienThuDuoc INT;
	
	OPEN uuDaiCursor
	FETCH NEXT FROM uuDaiCursor
	INTO @tienThuDuoc

	WHILE (@@FETCH_STATUS=0)
	BEGIN
		IF(@tienThuDuoc>100000)
			SET @tongTheUuDai=@tongTheUuDai+3;
		ELSE IF (@tienThuDuoc>50000)
			SET @tongTheUuDai=@tongTheUuDai+2;
		FETCH NEXT FROM uuDaiCursor
		INTO @tienThuDuoc
	END
	
	CLOSE uuDaiCursor;
	DEALLOCATE uuDaiCursor;
	RETURN @tongTheUuDai
END


GO

------------------- TEST FUNCTION 2 --------------------
SELECT *
from DonVanChuyen

SELECT dbo.tangUuDai('2020-01-01') as phieuUuDai



