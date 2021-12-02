-------------------------CAU1 PROCEDURE INSERT BANG KHACHHANG---------------------------------
CREATE OR ALTER PROCEDURE Insert_KhachHang @p_CCCDorVisa int, @p_ho nvarchar(20), @p_tenLot nvarchar(20),@p_Ten nvarchar(20),@p_ngaySinh Date,@p_gioiTinh nvarchar(10),@p_taiKhoan varchar(20),@p_matKhau varchar(20)
AS
BEGIN
	DECLARE @c_CCCDorVisa INT;
	SELECT @c_CCCDorVisa = COUNT(*)
	FROM KhachHang
	WHERE CCCDorVisa = @p_CCCDorVisa
	IF @c_CCCDorVisa>0 
	BEGIN
		RAISERROR('CCCD or Visa has already exists',1,1)
		RETURN
	END
	IF @p_ho=''
	BEGIN
		RAISERROR('Ho is not allowed to be blanked',1,1)
		RETURN
	END
	IF @p_ho LIKE '%[^a-zA-Z]%'
	BEGIN
		RAISERROR('Ho is not allowed to have other character beside the alphabet and their capital',1,1)
		RETURN
	END
	IF @p_tenLot<>''
	BEGIN
		IF @p_tenLot LIKE '%[^a-zA-Z ]%'
		BEGIN
			RAISERROR('Ten lot is not allowed to have other character beside the alphabet and their capital',1,1)
			RETURN
		END
	END
	IF @p_Ten=''
	BEGIN
		RAISERROR('Ten is not allowed to be blanked',1,1)
		RETURN
	END
	IF @p_Ten LIKE '%[^a-zA-Z]%'
	BEGIN
		RAISERROR('Ten is not allowed to have other character beside the alphabet and their capital',1,1)
		RETURN
	END
	DECLARE @c_taiKhoan INT;
	SELECT @c_taiKhoan = COUNT(*)
	FROM KhachHang
	WHERE taiKhoan=@p_taiKhoan
	IF @p_taiKhoan LIKE '%'+' '+'%'
	BEGIN
		RAISERROR('Tai khoan is not allowed to have space',1,1)
		RETURN
	END
	IF @c_taiKhoan>0
	BEGIN
		RAISERROR('Tai Khoan has already exists',1,1)
		RETURN
	END
	IF @p_matKhau NOT LIKE '%[%$#@!]%' OR @p_matKhau NOT LIKE '%[A-Z]%' OR @p_matKhau NOT LIKE '%[a-z]%' OR @p_matKhau NOT LIKE '%[0-9]%' OR LEN(@p_matKhau)<8
	BEGIN
		RAISERROR('Password needs special characters, capital characters, number characters and numbers and has length between 8 and 20',1,1)
		RETURN
	END
	IF @p_matKhau LIKE '%'+' '+'%'
	BEGIN
		RAISERROR('Password is not allowed to have space',1,1)
		RETURN
	END
	IF @p_gioiTinh <> 'Nam' AND @p_gioiTinh <> 'Nu'
	BEGIN
		RAISERROR('Gender is only allowed to be Nam or Nu',1,1)
		RETURN
	END
	INSERT INTO KhachHang (CCCDorVisa,ho,tenLot,Ten,ngaySinh,gioiTinh,taiKhoan,matKhau)
	VALUES (@p_CCCDorVisa,@p_ho,@p_tenLot,@p_Ten,@p_ngaySinh,@p_gioiTinh,@p_taiKhoan,@p_matKhau)
END
-------------------CAU2 TRIGGER UPDATE LOAI KHACH HANG---------------------------
CREATE OR ALTER TRIGGER Update_loaiKhachHang ON KhachHang FOR UPDATE
AS
BEGIN
	DECLARE @p_soDonDaDat INT,@p_maKhachHang uniqueidentifier, @p_loaiKhachHang nvarchar(20)
	SELECT @p_soDonDaDat=soDonDaDat FROM INSERTED
	SELECT @p_maKhachHang=maKhachHang FROM INSERTED
	IF @p_soDonDaDat<20
	BEGIN
		SET @P_loaiKhachHang='Dong'
	END
	ELSE IF @p_soDonDaDat<50
	BEGIN
		SET @p_loaiKhachHang='Bac'
	END
	ELSE IF @p_soDonDaDat<100
	BEGIN
		SET @p_loaiKhachHang='Vang'
	END
	ELSE IF @p_soDonDaDat<200
	BEGIN
		SET @p_loaiKhachHang='Kim Cuong'
	END
	ELSE IF @p_soDonDaDat<500
	BEGIN
		SET @p_loaiKhachHang='Bach Kim'
	END
	ELSE
	BEGIN
		SET @p_loaiKhachHang='Than Thiet'
	END
	UPDATE KhachHang
	SET loaiKhachHang=@p_loaiKhachHang
	WHERE maKhachHang=@p_maKhachHang
END
---------------------CAU2 TRIGGER INSERT MA KHUYEN MAI CHO KHACH HANG-------------------------
CREATE OR ALTER TRIGGER Insert_MaKhuyenMai ON KhachHang FOR UPDATE
AS
BEGIN
	DECLARE @p_soDonDaDat INT;
	SELECT @p_soDonDaDat=soDonDaDat FROM INSERTED;
	IF @p_soDonDaDat=20 OR @p_soDonDaDat=50 OR @p_soDonDaDat=100 OR @p_soDonDaDat=200 OR @p_soDonDaDat=500
	BEGIN
		DECLARE @p_maKhachHang uniqueidentifier;
		SELECT @p_maKhachHang=maKhachHang FROM INSERTED
		INSERT INTO MaKhuyenMai (discount,dieuKienApDung,ngayHetHan,moTa,maKhachHangSoHuu)
			VALUES (0.5,'Dung trong 10 ngay',DATEADD(DAY,10,GETDATE()),'Qua tang thang hang khach hang',@p_maKhachHang)
	END
END
-------------------------CAU3 PROCEDURE TIM THONG TIN THEO LOAI-------------------------------
CREATE OR ALTER PROCEDURE Tim_ThongTinNhanVienTheoLoai @type nvarchar(20)
AS
BEGIN
	IF (lower(@type)<>'quan ly' AND lower(@type)<>'tong dai vien' AND lower(@type)<>'shipper')
	BEGIN
		RAISERROR('Khong ton tai loai nhan vien da nhap',1,1)
	END
	ELSE
	BEGIN
	SELECT ho as Ho,tenLot as TenLot,ten as Ten,ngayVaoLam as NgayVaoLam,luong as Luong,chiSoUyTin as ChiSoUyTin, T.maDonVi as MaChiNhanh, tenChiNhanh as TenChiNhanh,T.loaiNhanVien as ChucVu,T.isActive as Sate, T.taiKhoan as TaiKhoan 
	FROM (SELECT ho,tenLot,ten,ngayVaoLam,luong,chiSoUyTin, maDonVi,loaiNhanVien,taiKhoan,isActive
		FROM NhanVien C JOIN NhanVienChiNhanh N ON c.maNhanVien=N.maNhanVien)T JOIN ChiNhanh on T.maDonVi=ChiNhanh.maDonVi
	WHERE lower(T.loaiNhanVien)=lower(@type) 
	ORDER BY ChucVu, Ho, TenLot, Ten
	END
END
--------------CAU3 PROCEDURE TIM SO MA KHUYEN MAI SAP HET HAN THEO CCCD OR VISA---------------
CREATE OR ALTER PROCEDURE Tim_SoMaKhuyenMaiSapHetHan @p_CCCDorVisa int
AS
BEGIN
	SELECT T.maKhachHang as MaKhachHang, COUNT(*) AS SoKhuyenMaiSapHetHan
	FROM(
		SELECT maKhachHang
		FROM KhachHang
		WHERE CCCDorVisa=@p_CCCDorVisa) T JOIN MaKhuyenMai M ON T.maKhachHang=M.maKhachHangSoHuu
	GROUP BY T.maKhachHang, M.ngayHetHan
	HAVING DATEADD(DAY,-5,M.ngayHetHan)<GETDATE()
	ORDER BY T.MaKhachHang
END
--------------CAU4 FUNCTION TINH SO MA KHUYEN MAI CAN TANG CHO KHACH NU CO SO DON TU HUY TOI DA---------------
CREATE OR ALTER FUNCTION SoVoucherTangKhachNu (@sodon AS INT)
RETURNS INT
AS
BEGIN
	IF @sodon<=0
	BEGIN
		RETURN -1
	END
	DECLARE @maKhachHang uniqueidentifier,@soMaKhuyenMai INT;
	SET @soMaKhuyenMai=0;
	DECLARE Khachhang CURSOR
	FOR SELECT maKhachHang
	FROM KhachHang
	WHERE gioiTinh=N'Nữ'and soDonBiHuyDoKhachHang<@sodon
	OPEN Khachhang
	FETCH NEXT FROM Khachhang
	INTO @maKhachHang
	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @soMaKhuyenMai=@soMaKhuyenMai+1
		FETCH NEXT FROM Khachhang
		INTO @maKhachHang
	END
	CLOSE KhachHang
	DEALLOCATE KhachHang
	RETURN @soMaKhuyenMai
END
--------------CAU4 FUNCTION TINH SO MA KHUYEN MAI CAN TANG CHO KHACH CO NGAY SINH---------------
CREATE OR ALTER FUNCTION SoVoucherTangKhachCoNgaySinh (@sodon AS INT,@month AS INT, @day AS INT)
RETURNS INT
AS
BEGIN
	IF @sodon<=0
	BEGIN
		RETURN -1
	END
	IF @month<1 OR @month>12
	BEGIN
		RETURN -1
	END
	IF @month=1 OR @month=3 OR @month=3 OR @month=5 OR @month=7 OR @month=8 OR @month=10 OR @month=12
	BEGIN
		IF @day<1 OR @day>31
		RETURN -1
	END
	ELSE IF @month=4 OR @month=6 OR @month=9 OR @month=11
	BEGIN
		IF @day<1 OR @day>30
		RETURN -1
	END
	ELSE
	BEGIN
		IF @day<1 OR @day>29
		RETURN -1
	END
	DECLARE @maKhachHang uniqueidentifier,@soMaKhuyenMai INT;
	SET @soMaKhuyenMai=0;
	DECLARE Khachhang CURSOR
	FOR SELECT maKhachHang
	FROM KhachHang
	WHERE DAY(ngaySinh)=@day AND MONTH(ngaySinh)=@month
	OPEN Khachhang
	FETCH NEXT FROM Khachhang
	INTO @maKhachHang
	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @soMaKhuyenMai=@soMaKhuyenMai+1
		FETCH NEXT FROM Khachhang
		INTO @maKhachHang
	END
	CLOSE KhachHang
	DEALLOCATE KhachHang
	RETURN @soMaKhuyenMai
END