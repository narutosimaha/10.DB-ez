---------------------INSERT Nhân Viên---------------------
INSERT INTO NhanVien(ho,tenLot,ten,ngayVaoLam,luong,taiKhoan,matKhau,loaiNhanVien,chiSoUyTin) 
VALUES ( 'Tran','Luong','Vu','2015-10-30',5300000,'tranvu123','123456789','Quan ly', 4.3), 
( 'Luu','Cong','Dinh','2016-07-12',6800000,'congdinh123','123456789','Shipper', 4.5),
( 'Nguyen','Le','Hien','2010-08-20',7200000,'lehien123','123456789','Tong dai vien', 4.0),
( 'Nguyen','Van','Thuong','2015-01-15',6300000,'vanthuong123','123456789','Quan ly', 4.6),
( 'Nguyen','Quoc','Thai','2018-12-17',5800000,'quocthai123','123456789','Shipper', 4.3),
( 'Vo','Huu','Luan','2013-09-10',8200000,'huuluan123','123456789','Tong dai vien', 4.7),
( 'Nguyen','Cong','Tri','2015-05-31',3900000,'congtri123','123456789','Shipper', 3.5),
( 'Nguyen','Anh','Van','2009-05-11',4700000,'anhvan123','123456789','Shipper',3.8),
( 'Vo','Hai','Nhat','2017-09-12',3500000,'hainhat123','123456789','Shipper', 4.3),
( 'Nguyen','Tran Hai','Cong','2015-02-19',5600000,'haicong123','123456789','Quan ly', 3.9),
( 'Nguyen','Le','Khang','2017-12-21',4630000,'lekhang123','123456789','Quan ly', 4.2),
( 'Tran','Le','Minh','2016-11-23',7720000,'leminh123','123456789','Quan ly', 4.8),
( 'Dinh','Vinh','Phuoc','2016-08-09',5700000,'vinhphuoc123','123456789','Quan ly', 4.3),
( 'Tran','Huu','Huan','2014-07-12',6300000,'huuhuan123','123456789','Tong dai vien', 4.1),
( 'Le','Tan','Truong','2018-03-15',9100000,'tantruong123','123456789','Tong dai vien', 4.5),
( 'Cao','Thanh','Bang','2017-12-11',5900000,'thanhbang123','123456789','Tong dai vien', 4.7),
( 'Nguyen','Van Tan','Loc','2016-05-17',6200000,'tanloc123','123456789','Tong dai vien', 4.4)


---------------------INSERT Khách Hàng---------------------
INSERT INTO KhachHang(CCCDorVisa,ho,tenLot,Ten,ngaySinh,gioiTinh,taiKhoan,matKhau,
diaChi,ngayThamGia,loaiKhachHang) 
VALUES (12344321,'Luong','Thi','Xuong','2001-07-11','Nu','xuongthi123','123456789'
,'Phu Yen','2013-05-14','Ca nhan'), 
(23455432,'Hua','Kim','Tuyen','1998-02-13','Nu','kimtuyen123','123456789'
,'TPHCM','2015-11-03','Ca nhan'), 
(34566543,'Tran','','Nam','2002-10-21','Nam','namTran123','123456789'
,'Khanh Hoa','2014-05-28','Tu nhan'), 
(45677654,'Luong','Minh','Anh','1999-06-12','Nu','minhAnh123','123456789'
,'Phu Yen','2016-10-07','Ca nhan'), 
(56788765,'Nguyen','Thanh','Dat','2001-01-29','Nam','datthanh123','123456789'
,'Phu Yen','2009-12-09','Doanh nghiep'), 
(67899876,'Cao','Luong Xuan','Hai','1998-06-09','Nam','caohai123','123456789'
,'Khanh Hoa','2011-06-18','Ca nhan'), 
(78900987,'Tran','Kim','Chi','1998-08-18','Nu','chitran123','123456789'
,'Khanh Hoa','2017-04-19','Tu nhan'), 
(89011098,'Tran','Van','Kim','1977-11-23','Nam','trankim123','123456789'
,'Khanh Hoa','2011-07-18','Ca nhan'), 
(90122109,'Nguyen','Kim','Anh','1989-08-28','Nu','kimanh123','123456789'
,'TPHCM','2016-03-14','Ca nhan'), 
(01233210,'Vo','Kim','Bang','1999-03-16','Nam','kimbang123','123456789'
,'TPHCM','2011-02-07','Ca nhan')


---------------------INSERT Phương Tiện Giao Hàng Của Shipper---------------------
INSERT INTO PhuongTien(bienKiemSoat,loaiPhuongTien) VALUES 
('12344321','Xe may'),
('23455432','Xe may'),
('34566543','Xe may'),
('45677654','Xe may'),
('56788765','Xe may'),
('67899876','Xe may'),
('78900987','Xe tai'),
('89011098','Xe ban tai'),
('90122109','Xe ban tai'),
('01233210','Xe tai')


---------------------INSERT Nhà Hàng---------------------
INSERT INTO NhaHang(tenNhaHang,diaChi,maSoGPKD,taikhoan,matkhau,hoChuNhaHang,tenLotChuNhaHang,
tenChuNhaHang,trangThaiNhaHang,rating) VALUES 
('Vinh Phuc','TPHCM','12344321','vinhphuc321','123456789','Tran','Vinh','Phuc',1,4.7),
('Thien Ha','TPHCM','23455432','thienha321','123456789','Vu','Kim','Ha',1,4.3),
('Bay Linh','Khanh Hoa','34566543','baylinh321','123456789','Nguyen','Minh','Hoang',1,4.5),
('Tu Le','Khanh Hoa','45677654','tule321','123456789','Vo','Trung','Hieu',1,3.9),
('Son Nam','Khanh Hoa','56788765','namson321','123456789','Nguyen','Thai','Son',1,4.3),
('Hau Phuoc','Phu Yen','67899876','hauphuoc321','123456789','Bui','Hau','Phuoc',1,4.1),
('Van Xuan','TPHCM','78900987','vanxuan321','123456789','Trong','Xuan','Van',1,4.6),
('Anh Sao','Phu Yen','89011098','saoanh321','123456789','Tran','Cao','Anh',0,3.4),
('Phan Tien','Phu Yen','90122109','phantien321','123456789','Phan','Thanh','Tien',1,4.8),
('The Han','TPHCM','01233210','thehan321','123456789','Nguyen','The','Han',1,4.5)


---------------------INSERT Món Ăn---------------------
INSERT INTO MonAn(tenMonAn,donGia,moTa,maNhaHangOffer)
VALUES (N'Phở bò',32000,N'Có bao gồm tái, nạm, gân va sụn',1),
(N'Cơm đùi gà',30000,N'Bao gồm đùi gà luộc và một chén canh',1),
(N'Mì xào thịt bò',35000,N'Mì hàn quốc và thịt tẩm mắm ớt',1),
(N'Cơm chân trâu',25000,N'Nhiều loại rau củ quả, thêm xúc xích và lạp xưởng',6),
(N'Cơm cá chiên',30000,N'Cá hồng chiên giòn, tẩm gia vị đặc biệt',6),
(N'Bún thịt nướng',25000,N'Đặc sản phú yên',6),
(N'Gà quay',70000,N'Phần nữa con',5),
(N'Lòng heo nướng',30000,'',5),
(N'Phần cơm thêm',5000,'',5),
(N'Cút nướng',25000,'',5),
(N'Cơm sườn',35000,N'Cơm sườn phủ thêm nước tương cực mlem',2),
(N'Cơm ba rọi',25000,N'Thịt ba rọi cắt lát nướng',2),
(N'Bún riêu cua',25000,'',3),
(N'Bún cá Nha Trang',25000,N'Đặc sản Nha Trang',3),
(N'Bánh xèo',30000,N'Gồm 3 cái, có tôm thịt trộn thập cẩm',3),
(N'Lẩu chay',70000,N'Phân 3 người, kèm nước chao',4),
(N'Lẩu kim chi',30000,N'Phần một người, bao gồm các loại nấm,xúc xích và kim chi',4),
(N'Mì Quảng Sài Gòn',33000,'',9),
(N'Lẩu mực',35000,N'Mực tươi rất ngon',10),
(N'Gà xào xả ớt',29000,'',7)


---------------------INSERT Ưu Đãi---------------------
INSERT INTO UuDai(maNhaHang,maMonAn,tenUuDai,discount,moTa,ngayHetHan)
VALUES
(1,1,N'Giỗ tổ Hùng Vương',0.3,'','2021-12-15'),
(1,2,N'Giảm giá cho các bạn tên Hùng',0.5,'','2021-12-07'),
(6,4,N'Nhân dịp Nô-en',0.25,'','2021-12-24'),
(6,6,N'Ngày sinh chủ nhà hàng',0.3,'','2021-12-01'),
(5,8,N'Love day',0.333,N'Giảm giá cho cặp đôi','2021-11-15'),
(5,9,N'Best Short',0.7,N'Giảm giá cho các bạn thấp hơn 1m55','2022-01-23'),
(2,11,N'Only English',0.5,N'Giảm giá cho các bạn Ielts 7.0','2021-12-22'),
(3,14,N'No Iphone',0.2,N'Bất cứ ai không có iphone đều được giảm ','2021-11-26'),
(4,16,N'Guitar Knowledge',0.65,N'Giảm giá cực lớn cho các bạn buổi diễn guitar tại quán','2021-12-30'),
(9,18,N'Impairment Pleasure',1.00,N'Giảm 100% cho người khuyết tật','2022-01-30'),
(10,19,N'God Bless',0.5,N'Guamr nữa giá cho người theo đạo thiên chúa','2021-12-26'),
(7,20,N'Happy Mother',0.35,N'Giảm giá cho các chị em nội trợ','2021-12-15')

---------------------INSERT Số điện thoại nhà hàng---------------------
INSERT INTO SDTNhaHang(maNhaHang,soDienThoai)
VALUES
(1,'01234567891'),
(2,'02345678912'),
(3,'03456789123'),
(4,'04567891234'),
(5,'05678912345'),
(6,'06789123456'),
(7,'07891234567'),
(8,'08912345678'),
(9,'09123456789'),
(10,'01122334455'),
(3,'02233445568'),
(1,'09323456789'),
(6,'01122381455')


---------------------INSERT Đơn Vận Chuyển---------------------
--**NOTE: maKhachHang là trường guid random, khi insert phải đổi thành những mã tương ứng của trường mã khách hàng 
--trong table Khách Hàng. Tương tự, các table còn lại có trường là kiểu dữ liệu guid cũng vậy

INSERT INTO DonVanChuyen(diaChiGiaoHang, thoiGianGiaoHang,thoiGianNhan, trangThaiDonHang,tienShip,
phuongThucThanhToan,maKhachHang) VALUES
(N'Ninh Hòa','2021-11-20 15:46:11','2021-11-20 16:05:12', 1, 9100,2,'E59CCDD7-7ACD-47FC-8740-9E4E8709EFCC'),
(N'Ninh Hòa','2021-11-28 10:27:36',NULL, 5, 42000,3,'E59CCDD7-7ACD-47FC-8740-9E4E8709EFCC'),
(N'Đại Lãnh','2021-01-16 13:22:50',NULL, 3, 13000,2,'7736DC86-CD02-4F6C-8FEC-A7133C118075'),
(N'Đại Lãnh','2021-04-15 8:17:58','2021-04-15 8:33:12', 1, 21000,4,'7736DC86-CD02-4F6C-8FEC-A7133C118075'),
(N'Tuy Hòa','2021-12-01 06:39:18',NULL, 4,34000,4,'E2E11940-28CD-48E5-ADD9-B588A5BBC6E2'),
(N'Tuy Hòa','2021-05-28 05:07:23','2021-05-28 05:30:23', 1,17500,3,'E2E11940-28CD-48E5-ADD9-B588A5BBC6E2'),
(N'Vũng Rô','2021-04-19 17:31:09','2021-04-19 18:30:22', 1, 12000,1,'6C8DC47B-83BD-4E07-BCBD-CBA37F03AF5E'),
(N'Vũng Rô','2021-09-11',NULL, 3, 18000,1,'6C8DC47B-83BD-4E07-BCBD-CBA37F03AF5E'),
(N'Đông Hòa','2021-11-29 8:07:31',NULL, 4, 23000,3,'DA586943-8AE6-4FD8-9CBE-EB2D06EA83F3'),
(N'Đông Hòa','2021-06-10 17:07:31','2021-06-19 14:032:15', 1, 47000,4,'DA586943-8AE6-4FD8-9CBE-EB2D06EA83F3'),
(N'Quận Bình Tân','2021-11-05 06:11:35','2021-11-18 09:05:44', 1, 16000,2,'BFF13AD4-7F4B-42E6-9D0B-EBAAACE6FDB1'),
(N'Quận Bình Tân','2021-11-26 14:23:55',NULL, 5, 35000,1,'BFF13AD4-7F4B-42E6-9D0B-EBAAACE6FDB1'),


---------------------INSERT Mã Khuyến Mãi---------------------
INSERT INTO MaKhuyenMai(discount,dieuKienApDung,ngayHetHan,moTa,maKhachHangSoHuu) VALUES
(0.5,N'Cho khách hàng là nữ','2021-11-26','Chúc các chị em phụ nữ một ngày thật hạnh phúc !', '1B313134-292A-40BA-9A1E-2A6F12A3BFD8'),
(0.5,N'Cho khách hàng là nữ','2021-11-26','Chúc các chị em phụ nữ một ngày thật hạnh phúc !', 'EFE678D1-6E3F-4C52-9901-2AEF0278A75B'),
(0.5,N'Cho khách hàng là nữ','2021-11-26','Chúc các chị em phụ nữ một ngày thật hạnh phúc !', 'E6F01568-46C5-4434-9F63-6ECB195FF581'),
(0.333,N'Cho các bạn giới tính thứ 3','2021-12-02','Ngày lễ không phân biệt giới tính.', 'BFF13AD4-7F4B-42E6-9D0B-EBAAACE6FDB1'),
(0.333,N'Cho các bạn giới tính thứ 3','2021-12-02','Ngày lễ không phân biệt giới tính.', '6C8DC47B-83BD-4E07-BCBD-CBA37F03AF5E'),
(0.25,N'Cho các bạn độc thân','2021-12-14','FA vui FA khỏe :v', 'E2E11940-28CD-48E5-ADD9-B588A5BBC6E2'),
(0.25,N'Cho các bạn độc thân','2021-12-14','FA vui FA khỏe :v', 'E59CCDD7-7ACD-47FC-8740-9E4E8709EFCC'),
(0.67,N'Thanh toán bằng momo','2021-12-30','Ưu đãi khi thanh toán bằng Momo', '552D5FC2-9907-4F7E-9173-9B4E2D21B6AB'),
(0.67,N'Thanh toán bằng momo','2021-12-30','Ưu đãi khi thanh toán bằng Momo', '7736DC86-CD02-4F6C-8FEC-A7133C118075'),
(0.67,N'Thanh toán bằng momo','2021-12-30','Ưu đãi khi thanh toán bằng Momo', '6C8DC47B-83BD-4E07-BCBD-CBA37F03AF5E'),
(0.67,N'Thanh toán bằng momo','2021-12-30','Ưu đãi khi thanh toán bằng Momo', 'E59CCDD7-7ACD-47FC-8740-9E4E8709EFCC'),
(0.33,N'Khách hàng đặt 2 đơn trở lên','2021-11-26','Mua sắm thả ga không lo hết xiền', 'EFE678D1-6E3F-4C52-9901-2AEF0278A75B'),
(0.33,N'Khách hàng đặt 2 đơn trở lên','2021-11-26','Mua sắm thả ga không lo hết xiền', '7736DC86-CD02-4F6C-8FEC-A7133C118075'),
(0.33,N'Khách hàng đặt 2 đơn trở lên','2021-11-26','Mua sắm thả ga không lo hết xiền', 'E2E11940-28CD-48E5-ADD9-B588A5BBC6E2')

GO

---------------------PROCEDURE INSERT Tạo Đơn Món Ăn---------------------
CREATE OR ALTER PROCEDURE taoDonMonAn
AS
	DECLARE @count int
	SET @count=4;
	WHILE(@count<15)
	BEGIN
		INSERT INTO DonMonAn(maDon) VALUES (@count);
		SET @count=@count+1
	END
GO
EXEC taoDonMonAn

GO

---------------------INSERT Đơn Giao Hàng Giúp---------------------
INSERT INTO DonGiaoHangGiup(maDon,tenNguoiNhan,soDienThoaiNguoiNhan,diaChiNhan,chiTietChoGiao,dichVuDonHang
,tongKhoiLuong) VALUES
(1,N'Quốc Khánh','0967231231',N'12 đường Nguyễn Trãi Quận 10 TPHCM',N'Đối diện quán cơm bà Tân',N'Dễ vỡ',15),
(2,N'Văn Hùng','03238473831',N'21 đường Quân Sư Quận 8 TPHCM',N'Nhà sát hẻm',N'Bình thường',8),
(3,N'Thu Thơ','0317978891',N'104 đường Thi Sách Nha Trang',N'Gần sân thi đấu',N'Dễ vỡ',11),
(15,N'Xuân Tín','0387991372',N'95 đường Phú Quốc Ninh Hòa',N'Sát bên cây xăng',N'Bình thường',28),
(16,N'Hoàn Duyên','0129387482',N'35 đường Ngô Bá Quát Tuy Hòa',N'Gần đường sắt xe lửa',N'Dễ vỡ',5),
(17,N'Thu Trang','0967232331',N'22 đường Trần Quốc Sư Đông Hòa',N'Gần Thế giới di động',N'Vip',4),
(18,N'Kim Liên','0967683931',N'15 Bà Triệu Vạn Ninh',N'Đối diện quán trà sữa Rex Fox','Bình thường',6)


---------------------INSERT Đơn Khuyến Mãi---------------------
GO
INSERT INTO DonKhuyenMai(maKhuyenMai,maDon) VALUES
(1,2),(2,3),(12,4),(7,7),(11,8),(9,9),(5,14),(10,14),(6,12),(14,12)


---------------------UPDATE thêm trường đã dùng chưa trong table Mã Khuyến Mãi---------------------
UPDATE MaKhuyenMai SET daDungChua=0
WHERE maKhuyenMai not in (1,2,12,7,11,9,5,10,6,14)

GO
---------------------INSERT bảng trạng thái đơn và phương thức thanh toán---------------------
INSERT INTO TrangThaiDon(trangThai) VALUES (N'Đã giao'),(N'Đã hủy'),(N'Giao không thành công'),(N'Đang giao')
,(N'Đang ở kho')
INSERT INTO PhuongThucThanhToan(phuongThucThanhToan) VALUES (N'Momo'),(N'Tiền mặt'),(N'Tín dụng ngân hàng'),(N'AirPay')




