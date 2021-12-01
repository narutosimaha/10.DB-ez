--câu1--
--Insert Chi tiết đơn món ăn
GO
CREATE PROCEDURE insertChiTietDonMonAn
@a_maDonMonAn int,@a_maMonAn INT,@a_soLuong INT, @a_apDungUuDai BIT,@a_donGiaMon INT,
@a_donGiaUuDai INT
AS
	IF(@a_soLuong<1)
		BEGIN
			RAISERROR('Số lượng món phải lớn hơn 0',16,1);
			RETURN
		END
	IF(@a_donGiaUuDai>@a_donGiaMon)
		BEGIN
			RAISERROR('Giá ưu đãi không được lớn hơn giá gốc',16,1);
			RETURN
		END
	INSERT INTO ChiTietDonMonAn(maDonMonAn,maMonAn,soLuong,apDungUuDai,donGiaMon,donGiaUuDai)
	VALUES (@a_maDonMonAn,@a_maMonAn,@a_soLuong,@a_apDungUuDai,@a_donGiaMon,@a_donGiaUuDai)
GO
EXEC insertChiTietDonMonAn @a_maDonMonAn=1,@a_maMonAn=4,@a_soLuong=1,@a_apDungUuDai=0,@a_donGiaMon=50000,@a_donGiaUuDai=50000
GO


--câu2a--
--Bảng đơn vận chuyển: tự động cập nhật loại khách hàng, số đơn đã đặt khi insert và delete vào bảng khách hàng.
--Insert
CREATE TRIGGER InsertDonVanChuyenTrigger ON DonVanChuyen
FOR  INSERT
AS
BEGIN
	DECLARE @sodon INT;
	DECLARE @maKhachHang uniqueidentifier;
	SELECT @sodon = count(*) from DonVanChuyen D,inserted I
	where D.maKhachHang=I.maKhachHang
	SELECT @maKhachHang=maKhachHang from inserted
	IF (@sodon <5) 
	BEGIN
		update KhachHang
		set loaiKhachHang = 'Dong',soDonDaDat=soDonDaDat+1
		where maKhachHang= @maKhachHang
	END;
	IF (@sodon >=5 and @sodon<10) 
	BEGIN
		update KhachHang
		set loaiKhachHang = 'Bac',soDonDaDat=soDonDaDat+1
		where maKhachHang= @maKhachHang
	END;
	IF (@sodon >=10 and @sodon<20) 
	BEGIN
		update KhachHang
		set loaiKhachHang = 'vang',soDonDaDat=soDonDaDat+1
		where maKhachHang= @maKhachHang
	END;
	IF (@sodon >=20) 
	BEGIN
		update KhachHang
		set loaiKhachHang = 'kimcuong',soDonDaDat=soDonDaDat+1
		where maKhachHang= @maKhachHang
	END;
END;
GO

--Delete
CREATE TRIGGER DeleteDonVanChuyen ON DonVanChuyen
FOR  DELETE
AS
BEGIN
	DECLARE @sodon INT;
	DECLARE @maKhachHang uniqueidentifier;
	SELECT @sodon = count(*) from DonVanChuyen D,deleted L
	where D.maKhachHang=L.maKhachHang
	SELECT @maKhachHang=maKhachHang from deleted
	IF (@sodon <5) 
	BEGIN
		update KhachHang
		set loaiKhachHang = 'Dong', soDonDaDat=soDonDaDat-1
		where maKhachHang= @maKhachHang
	END;
	IF (@sodon >=5 and @sodon<10) 
	BEGIN
		update KhachHang
		set loaiKhachHang = 'Bac',soDonDaDat=soDonDaDat-1
		where maKhachHang= @maKhachHang
	END;
	IF (@sodon >=10 and @sodon<20) 
	BEGIN
		update KhachHang
		set loaiKhachHang = 'vang',soDonDaDat=soDonDaDat-1
		where maKhachHang= @maKhachHang
	END;
	IF (@sodon >=20) 
	BEGIN
		update KhachHang
		set loaiKhachHang = 'kimcuong',soDonDaDat=soDonDaDat-1
		where maKhachHang= @maKhachHang
	END;
END;
GO

--Update
--Khi update Đơn vận chuyển nếu trạng thái đơn đổi thành 'bi khach hang huy' thì xóa cột đó trong đơn vận chuyển
-- và tự động cập nhật số đơn đã hủy trong bảng khách hàng.
CREATE TRIGGER UpdateDonVanChuyen on DonVanChuyen
FOR UPDATE
AS
BEGIN
	DECLARE @trangThai int
	DECLARE @makhachhang uniqueidentifier
	DECLARE @maDon int
	select @trangThai=maTrangThaiDonHang,@makhachhang=maKhachHang,@maDon=maDon from inserted
	IF(@trangThai=1)
	BEGIN
	update KhachHang
	set soDonBiHuyDoKhachHang=soDonBiHuyDoKhachHang+1
	where maKhachHang=@makhachhang
	delete from DonVanChuyen  where maDon=@maDon
	END;
END;
GO

--cau2b
-- Bảng mã khuyến mãi: Khi insert,update mã khuyến mãi ngày hết hạn không được nhỏ hơn thời gian hiện tại.
-- Insert+Update
CREATE TRIGGER InsertMaKhuyenMai ON MaKhuyenMai
FOR  INSERT,UPDATE
AS
BEGIN
	DECLARE @ngayHetHan datetime;
	select @ngayHetHan = ngayHetHan from inserted
	if (@ngayHetHan<GETDATE())
	BEGIN
		RAISERROR ('Ngay Khong Hop Le', 16, 1);
		ROLLBACK; 
	END;
END;
GO

--Delete
-- Khi delete không được delete mã khuyến mãi đang sử dụng trong bảng đơn khuyến mãi.
CREATE TRIGGER DeleteMaKhuyenMai ON MaKhuyenMai
INSTEAD OF DELETE  
AS
BEGIN
	DECLARE @maSoKhuyenMai int
	select @maSoKhuyenMai = maKhuyenMai from deleted
	IF(@maSoKhuyenMai in (SELECT maKhuyenMai FROM DonKhuyenMai))
	BEGIN
		RAISERROR ('Khong the xoa ma khuyen mai', 16, 1);
		RETURN;
	END;
	ELSE
	BEGIN
		DELETE FROM MaKhuyenMai
		WHERE maKhuyenMai=@maSoKhuyenMai
	END;
END;
GO

--câu3a
--Procedure tìm tất cả mã khuyến mãi của khách hàng có cmnd là tham số vào
CREATE PROCEDURE timKhachHangUuDai @cmnd int
AS
	SELECT K.ho+' '+K.tenLot+' '+K.Ten as Fullname,M.discount,M.dieuKienApDung,M.moTa,M.ngayHetHan
	FROM KhachHang K,MaKhuyenMai M
	WHERE K.maKhachHang=M.maKhachHangSoHuu and K.CCCDorVisa=@cmnd
	order by M.discount ASC
GO
EXEC timKhachHangUuDai 221481759
GO

--câu3b
--Tìm các nhà hàng có rating > <giá trị truyền vào> 
--và in ra tổng số món ăn có giá < <giá trị truyền vào> lọc thứ tự giảm dần của tổng số món ăn
CREATE PROCEDURE TimNhaHangBinhDan @rating float, @dongia int
AS
	SELECT N.tenNhaHang,N.rating ,count(*) AS TongSoMonAn
	FROM NhaHang N,MonAn M
	WHERE N.maNhaHang=M.maNhaHangOffer and M.donGia<=@dongia
	GROUP BY N.tenNhaHang,N.rating
	HAVING N.rating>=@rating
	ORDER BY TongSoMonAn DESC
GO
EXEC TimNhaHangBinhDan 4,20000
GO

--câu4a
--Cuối năm công ty sẽ trích một khoản tiền để làm quà cho các nhà hàng đã hợp tác với công ty. Số tiền này tính bằng cách:
-- +Nếu tổng số đơn của nhà hàng <10 nhà hàng sẽ không được quà.
-- +Nếu tổng số đơn của nhà hàng từ 10-19 sẽ được quà có giá trị bằng tổng số tiền đơn món ăn thu được từ nhà hàng * 0.01
-- +Nếu tổng số đơn của nhà hàng từ 20-29 sẽ được quà có giá trị bằng tổng số tiền đơn món ăn thu được từ nhà hàng * 0.02
-- +Nếu tổng số đơn của nhà hàng từ 30 trở lên sẽ được quà có giá trị bằng tổng số tiền đơn món ăn thu được từ nhà hàng * 0.05
--Viết hàm có tham số là mã nhà hàng và trả về số tiền nhà hàng được thưởng.
CREATE FUNCTION tinhTienThuong (@maNhaHang int)
RETURNS float
AS
BEGIN
	DECLARE @tongTienTra int 
	DECLARE @tongSoDon int
	DECLARE @tongtien int
	SELECT @tongSoDon=COUNT(*),@tongtien=SUM(D.tongTienMon)
	FROM MonAn M, ChiTietDonMonAn C, DonMonAn D
	WHERE M.maNhaHangOffer=@maNhaHang and M.maMonAn=C.maMonAn and D.maDon=C.maDonMonAn
	IF(@tongSoDon<10)
	BEGIN
		SET @tongTienTra=@tongtien*0
	END;
	ELSE IF(@tongSoDon>=10 and @tongSoDon <20)
	BEGIN
		SET @tongTienTra=@tongtien*0.01
	END;
	ELSE IF (@tongSoDon>=20 and @tongSoDon<30)
	BEGIN
		SET @tongTienTra=@tongtien*0.02
	END;
	ELSE IF(@tongSoDon>=30)
	BEGIN
		SET @tongTienTra=@tongtien*0.05
	END;
	RETURN @tongtientra
END;
GO
SELECT dbo.tinhTienThuong(1)
GO

--câu4b
--Cuối năm công ty sẽ thưởng Tết cho các shipper có thành tích tốt được khách hàng đánh giá nhiều lần 5 sao
-- +Shipper có từ 5->9 lần được 5 sao thưởng 500000
-- +Shipper có từ 10->19 lần được 5 sao thưởng 1000000
-- +Shipper có từ 20 lần được 5 sao trở lên thưởng 2000000
-- Viết hàm có tham số là chi nhánh cần lập danh sách và trả về danh sách các shipper được thưởng trong chi nhánh đó.
CREATE FUNCTION ShipperDuocThuong (@idChiNhanh as int)
returns @ShipperUuTu table(MaShipper uniqueidentifier,IdChiNhanh INT,TienThuong INT)
BEGIN
	DECLARE ShipperCursor CURSOR 
	FOR SELECT S.maNhanVien,COUNT(*) as soLanRating
		FROM SHIPPER S,DanhGiaShipper D,NhanVien N,NhanVienChiNhanh A
		WHERE S.maNhanVien=D.maShipper and S.maNhanVien=N.maNhanVien and N.maNhanVien = A.maNhanVien and A.maDonVi=1 and D.rating=5
		GROUP BY s.maNhanVien
	DECLARE @maShipper uniqueidentifier
	DECLARE @tienthuong int
	SET @tienthuong=0
	DECLARE @soLanRating int 
	OPEN ShipperCursor
	FETCH NEXT FROM ShipperCursor
	INTO @maShipper,@soLanRating 
	WHILE(@@FETCH_STATUS=0)
	BEGIN
		IF(@soLanRating>=5 and @soLanRating<10)
			SET @tienthuong=500000
		ELSE IF(@soLanRating>=10 and @soLanRating<20)
			SET @tienthuong=1000000
		ELSE IF(@soLanRating>=20)
			SET @tienthuong=2000000
		Insert into @ShipperUuTu(MaShipper,IdChiNhanh,TienThuong) values (@maShipper,@idChiNhanh,@tienthuong)
		FETCH NEXT FROM ShipperCursor
		INTO @maShipper,@soLanRating
	END;
	CLOSE ShipperCursor;
	DEALLOCATE ShipperCursor;
	RETURN
END;
GO
SELECT * from ShipperDuocThuong(1)
GO

