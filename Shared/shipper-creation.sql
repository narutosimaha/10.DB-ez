CREATE DATABASE Shipper
go
use Shipper;

go
--Hien
create table NhanVien(
maNhanVien uniqueidentifier Not null DEFAULT newid(),   
ho nvarchar(20) not null,
tenLot nvarchar(20) default '',
ten nvarchar(20) not null,
ngayVaoLam date default GETDATE(),
luong decimal default 0,
taiKhoan nvarchar(50) unique,
matKhau nvarchar(50),
loaiNhanVien nvarchar(20),
chiSoUyTin decimal(2,1) default 5 check(chiSoUyTin>0 AND chiSoUyTin<6),
isActive bit default 1,
ngaySinh date,
primary key (maNhanVien)
);
create table QuanLi(
maNhanVien uniqueidentifier PRIMARY KEY not null
)
create table TongDaiVien(
maNhanVien uniqueidentifier PRIMARY KEY not null
)

create table Shipper(
maNhanVien uniqueidentifier PRIMARY KEY not null,
trangThai bit default 1,
rating decimal(2,1) check (rating>=1 AND rating<=5) default 5,
soGPLX nvarchar(50) not null,
bienKiemSoat nvarchar(20) not null
)

create table DanhGiaShipper(
maShipper uniqueidentifier,
maKhachHang uniqueidentifier,
ngayDanhGia datetime default GETDATE(),
rating int not null check (rating>=1 AND rating<=5),
moTa nvarchar(300),
primary key(maShipper,maKhachHang,ngayDanhGia)
)

create table DanhGiaNhaHang(
maNhaHang int,
maKhachHang uniqueidentifier,
ngayDanhGia datetime default GETDATE(),
moTa nvarchar(300),
rating int not null check (rating>=1 AND rating<=5),
primary key (maNhaHang,maKhachHang,ngayDanhGia)
)


create table SDTNhaHang(
maNhaHang int,
soDienThoai char(11),
primary key(maNhaHang,soDienThoai)
)

create table NhanVienChiNhanh(
maNhanVien uniqueidentifier PRIMARY KEY,
maDonVi int not null
)

--ThÆ°Æ¡ng

CREATE TABLE DonVanChuyen(
maDon int identity(1,1) primary key,
diaChiGiaoHang nvarchar(100),
thoiGianGiaoHang datetime,
thoiGianNhan datetime,
maTrangThaiDonHang int,
tienShip int default 0,
maPhuongThucThanhToan int,
maKhachHang uniqueidentifier,
);

CREATE TABLE TrangThaiDon(
maTrangThai int identity(1,1) primary key,
trangThai nvarchar(30) unique not null
);

CREATE TABLE PhuongThucThanhToan(
maPhuongThuc int identity(1,1) primary key,
phuongThucThanhToan nvarchar(30) unique not null
);

CREATE TABLE PhuongTien(
bienKiemSoat nvarchar(20) primary key,
loaiPhuongTien nvarchar(50),
hinhAnhXe varchar(255),
giayPhepSoHuuXe varchar(255),
);

CREATE TABLE DonGiaoHangGiup(
maDon int primary key,
tenNguoiNhan nvarchar(50),
soDienThoaiNguoiNhan nvarchar(50) not null,
diaChiNhan nvarchar(100) not null,
chiTietChoGiao nvarchar(255),
dichVuDonHang nvarchar(255),
dichVuThem nvarchar(255),
ghiChuChoShipper nvarchar(255),
tongKhoiLuong float,
);

CREATE TABLE DonMonAn(
maDon int primary key,
tongTienMon float,
);

CREATE TABLE NhanGiaoHang_DVC_PT_SP(
maDon int primary key,
maShipper uniqueidentifier not null,
bienKiemSoatXeGiao nvarchar(20),
);

--Ä�á»‹nh

CREATE TABLE KhachHang(
	maKhachHang uniqueidentifier default newid(),
	CCCDorVisa int unique,
	ho nvarchar(20) not null,
	tenLot nvarchar(20) default '',
	Ten nvarchar(20) not null,
	ngaySinh Date CHECK (DATEDIFF(year, ngaySinh ,GETDATE())>12),
	gioiTinh nvarchar(10) default 'Nam',
	taiKhoan varchar(20) unique,
	matKhau varchar(20),
	diaChi varchar(50),
	ngayThamGia DateTime default GETDATE(),
	loaiKhachHang varchar(20),
	soDonBiHuyDoKhachHang int default 0,
	soDonDaDat int default 0,
	primary key (maKhachHang)
);
CREATE TABLE ChiNhanh(
		maDonVi int identity(1,1) Primary Key,
		maSoThue int,
		tenChiNhanh nvarchar(50),
		diaChi nvarchar(50),
		maNVQuanLy uniqueidentifier,
		maChiNhanhCha int,
);

CREATE TABLE DonKhieuNai(
	maDonKhieuNai int identity(1,1) primary key,
	noiDung nvarchar(500),
	maQuanLyKiemDuyet uniqueidentifier,
	vanDe nvarchar(50) not null,
);

CREATE TABLE MaKhuyenMai(
	maKhuyenMai int identity(1,1) primary key,
	discount float check(discount>=0 AND discount<=1), --0->1
	dieuKienApDung nvarchar(200),
	ngayHetHan DateTime,
	moTa nvarchar(200),
	maKhachHangSoHuu uniqueidentifier,
);

CREATE TABLE SdtKhachHang(
	maKhachHang uniqueidentifier ,
	SDT char(11),
	primary key (SDT,maKhachHang)
);

--VÅ©

CREATE TABLE KhieuNai(
	maDonKhieuNai INT PRIMARY KEY,
	maTongDaiVien uniqueidentifier NOT NULL,
	maKhachHang uniqueidentifier NOT NULL,
)
CREATE TABLE ChiTietDonMonAn (
	maDonMonAn INT,
	maMonAn INT,
	soLuong INT DEFAULT 1,
	apDungUuDai BIT DEFAULT 0,
	donGiaMon INT,
	donGiaUuDai INT,
	PRIMARY KEY (maDonMonAn,maMonAn)
)
CREATE TABLE DonKhuyenMai(
	maKhuyenMai INT PRIMARY KEY,
	maDon INT NOT NULL,
)
CREATE TABLE QuyTrachNhiem(
	maNhanVien uniqueidentifier,
	maDonKhieuNai INT,
	maQuanLy uniqueidentifier NOT NULL,
	PRIMARY KEY (maNhanVien,maDonKhieuNai)
)

--ThÃ¡i

CREATE TABLE MonAn (
	maMonAn		int identity(1,1) Primary Key,
	tenMonAn	nvarchar(50) not null,
	donGia		int not null,
	moTa		nvarchar(300),
	maNhaHangOffer	int not null,	
);
CREATE TABLE NhaHang (
	maNhaHang	int identity(1,1) Primary Key,
	tenNhaHang	nvarchar(50) not null,
	diaChi		nvarchar(50) not null,
	maSoGPKD	nvarchar(50),
	taiKhoan	nvarchar(50) unique,
	matKhau		nvarchar(50),
	hoChuNhaHang	nvarchar(50),
	tenLotChuNhaHang nvarchar(50),
	tenChuNhaHang	nvarchar(40),
	trangThaiNhaHang bit default 1,
	rating		decimal(2,1),
);
CREATE TABLE HangVanChuyen (
	maDonGiaoGiup	int,
	maHang		int,
	moTa		nvarchar(300),
	tongKhoiLuong	int,
	LoaiHang	nvarchar(20),
	CONSTRAINT pk_HangVanChuyen primary key (maHang,maDonGiaoGiup)
);
CREATE TABLE UuDai (
	maNhaHang	int,
	maMonAn		int,
	tenUuDai	nvarchar(200),
	discount	decimal(3,2) check(discount>=0 and discount <=1),  -- 0.00->1.00
	moTa		nvarchar(300),
	ngayHetHan	DateTime,
	CONSTRAINT pk_UuDai primary key (maMonAn,tenUuDai)
);
CREATE TABLE TuVanGiaiDap (
	maTongDaiVien	uniqueidentifier,
	maKhachHang uniqueidentifier,
	record		nvarchar(100),
	vanDe		nvarchar(50),
	CONSTRAINT pk_TuVanGiaiDap primary key (maTongDaiVien,maKhachHang,record)
)
--Alter hien
alter table QuanLi  ADD constraint fk_maQuanLi foreign key (maNhanVien) references NhanVien(maNhanVien)
alter table TongDaiVien ADD constraint fk_maTongDai foreign key (maNhanVien) references NhanVien(maNhanVien)
alter table Shipper ADD constraint fk_maShipper foreign key (maNhanVien) references NhanVien(maNhanVien)
alter table Shipper ADD constraint fk_bienKiemSoat foreign key (bienKiemSoat) references PhuongTien(bienKiemSoat)
alter table DanhGiaShipper ADD constraint fk_maShipperD foreign key (maShipper) references Shipper(maNhanVien)
alter table DanhGiaShipper ADD constraint fk_maKhachHang foreign key (maKhachHang) references KhachHang(maKhachHang)
alter table DanhGiaNhaHang ADD constraint fk_maKhachHangN foreign key(maKhachHang) references KhachHang(maKhachHang)
alter table DanhGiaNhaHang ADD constraint fk_maNhaHang foreign key(maNhaHang) references NhaHang(maNhaHang)
alter table SDTNhaHang ADD constraint fk_maNhaHangN foreign key(maNhaHang) references NhaHang(maNhaHang)
alter table NhanVienChiNhanh add constraint fk_maNhanVienChiNhanh foreign key(maNhanVien) references NhanVien(maNhanVien)
alter table NhanVienChiNhanh add constraint fk_maDonVi foreign key(maDonVi) references ChiNhanh(maDonVi)

--Alter VÅ©
ALTER TABLE KhieuNai
ADD  FOREIGN KEY (maDonKhieuNai) REFERENCES DonKhieuNai(maDonKhieuNai)

ALTER TABLE KhieuNai
ADD FOREIGN KEY (maTongDaiVien) REFERENCES TongDaiVien(maNhanVien)

ALTER TABLE KhieuNai
ADD FOREIGN KEY (maKhachHang) REFERENCES KhachHang(maKhachHang)

ALTER TABLE ChiTietDonMonAn
ADD FOREIGN KEY (maDonMonAn) REFERENCES DonMonAn(maDon)

ALTER TABLE ChiTietDonMonAn
ADD FOREIGN KEY (maMonAn) REFERENCES MonAn(maMonAn)

ALTER TABLE DonKhuyenMai
ADD FOREIGN KEY (maKhuyenMai) REFERENCES MaKhuyenMai(maKhuyenMai)

ALTER TABLE DonKhuyenMai
ADD FOREIGN KEY (maDon) REFERENCES DonVanChuyen(maDon)

ALTER TABLE QuyTrachNhiem
ADD FOREIGN KEY (maNhanVien) REFERENCES NhanVien(maNhanVien)

ALTER TABLE QuyTrachNhiem
ADD FOREIGN KEY (maDonKhieuNai) REFERENCES DonKhieuNai(maDonKhieuNai)

ALTER TABLE QuyTrachNhiem
ADD FOREIGN KEY (maQuanLy) REFERENCES QuanLi(maNhanVien)
--alter Ä�á»‹nh
ALTER TABLE ChiNhanh
	ADD CONSTRAINT FK_ChiNhanhChiNhanh foreign key (maChiNhanhCha) references ChiNhanh (maDonVi)
ALTER TABLE ChiNhanh
	ADD CONSTRAINT FK_ChiNhanhQuanLi foreign key (maNVQuanLy) references QuanLi (maNhanVien)
ALTER TABLE DonKhieuNai
	ADD CONSTRAINT FK_DonKhieuNaiQuanLi foreign key (maQuanLyKiemDuyet) references QuanLi (maNhanVien)
ALTER TABLE MaKhuyenMai
	ADD CONSTRAINT FK_MaKhuyenMaiKhachHang foreign key (maKhachHangSoHuu) references KhachHang (maKhachHang)
ALTER TABLE SdtKhachHang
	ADD CONSTRAINT FK_SdtKhachHangKhachHang foreign key (maKhachHang) references KhachHang (maKhachHang)
--Alter ThÃ¡i
ALTER TABLE MonAn
	ADD CONSTRAINT FK_MonAnidNhaHangOffer foreign key (maNhaHangOffer) references NhaHang (maNhaHang)
ALTER TABLE HangVanChuyen
	ADD CONSTRAINT FK_HangVanChuyenidDonGiaoGiup foreign key (maDonGiaoGiup) references DonGiaoHangGiup (maDon)
ALTER TABLE UuDai
	ADD CONSTRAINT FK_UuDaiidNhaHang foreign key (maNhaHang) references NhaHang (maNhaHang)
ALTER TABLE UuDai
	ADD CONSTRAINT FK_UuDaiidMonAn foreign key (maMonAn) references MonAn (maMonAn)
ALTER TABLE TuVanGiaiDap
	ADD CONSTRAINT FK_TuVanGiaiDapmaTongDaiVien foreign key (maTongDaiVien) references TongDaiVien (maNhanVien)
ALTER TABLE TuVanGiaiDap
	ADD CONSTRAINT FK_TuVanGiaiDapmaKhachHang foreign key (maKhachHang) references KhachHang (maKhachHang)

--alter ThÆ°Æ¡ng
Alter table DonGiaoHangGiup
	Add CONSTRAINT fk_idDonGiaoHangGiup foreign key (maDon) references DonVanChuyen(maDon);
Alter table DonMonAn
	Add CONSTRAINT fk_idDonMonAn foreign key (maDon) references DonVanChuyen(maDon);
Alter table NhanGiaoHang_DVC_PT_SP
	Add CONSTRAINT fk_bienKiemSoatt foreign key (bienKiemSoatXeGiao) references PhuongTien(bienKiemSoat);
Alter table NhanGiaoHang_DVC_PT_SP
	Add CONSTRAINT fk_idDon foreign key (maDon) references DonVanChuyen(maDon);
Alter table NhanGiaoHang_DVC_PT_SP
	Add CONSTRAINT fk_maShipperr foreign key (maShipper) references Shipper(maNhanVien);
Alter table DonVanChuyen
	Add  foreign key (maPhuongThucThanhToan) references PhuongThucThanhToan(maPhuongThuc);
Alter table DonVanChuyen
	Add  foreign key (maTrangThaiDonHang) references TrangThaiDon(maTrangThai);


--bá»• sung thuá»™c tÃ­nh: ThÆ°Æ¡ng
ALTER TABLE ChiNhanh
	ADD soLuongNhanVien int DEFAULT 0;
ALTER TABLE ChiNhanh
	ADD ngayQLyBatDauLamViec date default GETDATE();
