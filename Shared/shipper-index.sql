
------------------------------INDEXING--------------------------
-- Trần Lương Vũ 1915991

-- PROCEDURE USING CREATED INDEX
CREATE OR ALTER PROCEDURE thongTinUuDai
@idMonAn int
AS
	SELECT M.tenMonAn,M.donGia , M.donGia*(1-U.discount) as giaDaUuDai,U.tenUuDai,U.discount,U.moTa,U.ngayHetHan
	FROM MonAn M JOIN UuDai U ON (M.maMonAn=U.maMonAn)
	WHERE M.maMonAn=@idMonAn
	ORDER BY discount DESC

-- EXECUTION COMMAND
EXEC thongtinUuDai 6

GO

-- CREATE INDEX
CREATE NONCLUSTERED INDEX indexUuDai
ON UuDai(maMonAn)
INCLUDE(tenUuDai,discount,moTa,ngayHetHan)

-- DROP INDEX
DROP INDEX indexUuDai ON UuDai

GO


-- Lưu Công Định 1913433

-- PROCEDURE USING CREATED INDEX
CREATE OR ALTER PROCEDURE selectMonAnThuocNhaHang
@diachi nvarchar(50)
AS
	SELECT  N.tenNhaHang,M.tenMonAn,N.maNhaHang,M.maMonAn, M.image
	FROM NhaHang as N, MonAn as M
	WHERE N.maNhaHang=M.maNhaHangOffer AND lower(N.diaChi)=lower(@diachi)
	ORDER BY N.tenNhaHang,M.tenMonAn

-- EXECUTION COMMAND
EXEC selectMonAnThuocNhaHang @diachi='Phu Yen'

GO

-- CREATE INDEX
CREATE NONCLUSTERED INDEX  diaChiMonAn
ON MonAn(maNhaHangOffer)
INCLUDE (maMonAn,tenMonAn,image)

-- DROP INDEX
DROP INDEX diaChiMonAn on MonAn

GO






-- Nguyễn Lê Hiên 1913315
-- PROCEDURE USING CREATED INDEX
CREATE OR ALTER PROCEDURE timKhachHangUuDai @cmnd int
AS
	SELECT K.ho+' '+K.tenLot+' '+K.Ten as Fullname,M.discount,M.dieuKienApDung,M.moTa,M.ngayHetHan
	FROM KhachHang K,MaKhuyenMai M
	WHERE K.maKhachHang=M.maKhachHangSoHuu and K.CCCDorVisa=@cmnd
	order by M.discount ASC
GO

-- EXECUTION COMMAND
EXEC timKhachHangUuDai @cmnd=12344321

GO


-- CREATE INDEX
CREATE NONCLUSTERED INDEX  indexKhuyenMaiKhachHang
ON MaKhuyenMai(maKhachHangSoHuu)
INCLUDE (discount,dieuKienApDung,moTa,ngayHetHan)

-- DROP INDEX
DROP INDEX indexKhuyenMaiKhachHang on MaKhuyenMai


GO



--Nguyễn Văn Thương 1915439

-- PROCEDURE USING CREATED INDEX
CREATE OR ALTER PROCEDURE DanhsachShipperChiNhanhX
@maDonVi int
AS
	SELECT C.ho+' '+C.tenLot +' '+C.ten as HovaTen,C.loaiNhanVien , C.luong , C.ngayVaoLam
	FROM NhanVienChiNhanh A, Shipper B, NhanVien C
	WHERE A.maNhanVien=B.maNhanVien and B.maNhanVien=C.maNhanVien and A.maDonVi=@maDonVi
	ORDER by  C.ngayVaoLam DESC;


-- EXECUTION COMMAND
EXEC DanhsachShipperChiNhanhX 1;

-- CREATE INDEX

CREATE NONCLUSTERED INDEX indexMaShipper
ON Shipper(maNhanVien)

--NOTE:Bảng NhanVienChiNhanh không cần tạo thêm index vì đã có index trên primary key MaNhanVien.
-- DROP INDEX
DROP INDEX indexMaShipper ON Shipper

GO



-- Trần Quốc Thái
CREATE OR ALTER PROCEDURE Tim_NhanVien 
@type nvarchar(10)
AS
	IF (lower(@type) ='quan ly')
	BEGIN
		SELECT Q.maNhanVien as MaNhanVien, N.ho, N.tenLot, N.ten
		FROM NhanVien N, QuanLi Q
		WHERE N.maNhanVien=Q.maNhanVien
		ORDER BY N.ten ASC
	END
	ELSE IF (lower(@type)= 'tong dai vien')
	BEGIN
		SELECT T.maNhanVien as MaNhanVien, N.ho, N.tenLot, N.ten
		FROM NhanVien N, TongDaiVien T
		WHERE N.maNhanVien=T.maNhanVien
		ORDER BY N.ten ASC
	END

-- EXECUTION COMMAND
EXEC Tim_NhanVien @type='QuAn Ly'

-- MSSQL đã tự động tạo clustered index cho primary key.















-- THIS IS JUST THE ULITIES USING FOR CHECK IF THE CODE EXECUTE CORRECTLY LIKE EXPECTED. PLEASE DON'T BOTHER IT.

-------------------------------TIM FOREIGNKEY CHUA INDEX-------------------------------------------
 
CREATE TABLE #TempForeignKeys (TableName varchar(100), ForeignKeyName varchar(100) , ObjectID int)
INSERT INTO #TempForeignKeys 
SELECT OBJ.NAME, ForKey.NAME, ForKey .[object_id] 
FROM sys.foreign_keys ForKey
INNER JOIN sys.objects OBJ
ON OBJ.[object_id] = ForKey.[parent_object_id]
WHERE OBJ.is_ms_shipped = 0
 

SELECT * FROM sys.foreign_key_columns

SELECT * FROM #TempForeignKeys

CREATE TABLE #TempIndexedFK (ObjectID int)
INSERT INTO #TempIndexedFK  
SELECT ObjectID      
FROM sys.foreign_key_columns ForKeyCol
JOIN sys.index_columns IDXCol
ON ForKeyCol.parent_object_id = IDXCol.[object_id]
JOIN #TempForeignKeys FK
ON  ForKeyCol.constraint_object_id = FK.ObjectID
WHERE ForKeyCol.parent_column_id = IDXCol.column_id 

SELECT * FROM #TempForeignKeys K WHERE NOT EXISTS (SELECT * FROM #TempIndexedFK H where K.ObjectID=H.ObjectID ) AND
K.TableName='MonAn'


-------------------------------TIM CAC INDEX CUA MOT BANG NAO DO------------------------------------------


SELECT obj.name as ObjectName, obj.object_id,  ind.name, ind.type_desc,ind.index_id,col.column_id
FROM sys.index_columns col,sys.objects obj, sys.indexes ind
WHERE obj.object_id= ind.object_id AND obj.is_ms_shipped=0 AND obj.object_id=col.object_id 
AND ind.index_id=col.index_id AND obj.name='NhanVienChiNhanh'



---------------------------------KIEM TRA DO HIEU QUA INDEX---------------------------------------------

SELECT *
FROM sys.dm_db_index_usage_stats

GO
SELECT DISTINCT OBJECT_NAME(sis.OBJECT_ID) TableName, si.name AS IndexName, sc.Name AS ColumnName,
sic.Index_ID, sis.user_seeks, sis.user_scans, sis.user_lookups, sis.user_updates
FROM sys.dm_db_index_usage_stats sis
INNER JOIN sys.indexes si ON sis.OBJECT_ID = si.OBJECT_ID AND sis.Index_ID = si.Index_ID
INNER JOIN sys.index_columns sic ON sis.OBJECT_ID = sic.OBJECT_ID AND sic.Index_ID = si.Index_ID
INNER JOIN sys.columns sc ON sis.OBJECT_ID = sc.OBJECT_ID AND sic.Column_ID = sc.Column_ID
WHERE sis.Database_ID = DB_ID('Shipper') AND sis.OBJECT_ID = OBJECT_ID('dbo.UuDai');
GO

select index_id, name from sys.indexes where object_id = OBJECT_ID('dbo.NhanVien')

 