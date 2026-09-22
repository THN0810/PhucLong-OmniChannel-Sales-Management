-- Tạo database
CREATE DATABASE QLBanHangPhucLong;
GO

USE QLBanHangPhucLong;
GO
DROP TABLE IF EXISTS 
    CTPhieuGiaoHang,
    PhieuGiaoHang,
    CTPX,
    PhieuXuat,
    CTHoaDon,
    HoaDon,
    CTPhieuDatHang,
    PhieuDatHang,
    NganHang,
    TheThanhVien,
    KhachHang,
    LoaiKH,
    TonKho,
    BienDongGia,
    CTChuongTrinhKM,
    CTKhuyenMai,
    SanPham,
    LoaiSP,
    NhomSP,
    DonViTinh,
    PhanQuyen,
    TaiKhoanNV,
    DoiTuong,
    LoaiDoiTuong,
    Quyen,
    LoaiQuyen,
    Kho,
    NhanVien,
    PhongBan,
    VaiTroHeThong,
    ChucVu,
    ChiNhanh;
GO
------------------------------------------------------------
-- TẠO DATABASE
------------------------------------------------------------
CREATE DATABASE QLBanHangPhucLong;
GO

USE QLBanHangPhucLong;
GO

CREATE TABLE ChiNhanh (
    MaCN     NVARCHAR(10)   NOT NULL,
    TenCN    NVARCHAR(100)  NOT NULL,
    SDT_CN   CHAR(10)       NULL,
    Email_CN NVARCHAR(255)  NULL,
    CONSTRAINT PK_ChiNhanh PRIMARY KEY (MaCN)
);
GO

CREATE TABLE PhongBan (
    MaPB     NVARCHAR(10)   NOT NULL,
    MaCN     NVARCHAR(10)   NOT NULL,  
    TenPB    NVARCHAR(50)   NOT NULL,
    SDT_PB   CHAR(10)       NULL,
    Email_PB NVARCHAR(255)  NULL,
    CONSTRAINT PK_PhongBan PRIMARY KEY (MaPB),
    CONSTRAINT FK_PhongBan_ChiNhanh
        FOREIGN KEY (MaCN) REFERENCES ChiNhanh(MaCN)
);
GO

CREATE TABLE ChucVu (
    MaCV  NVARCHAR(10)   NOT NULL,
    TenCV NVARCHAR(100)  NOT NULL,
    CONSTRAINT PK_ChucVu PRIMARY KEY (MaCV)
);
GO

CREATE TABLE NhanVien (
    MaNV     NVARCHAR(10)   NOT NULL,
    MaPB     NVARCHAR(10)   NOT NULL,
    MaCV     NVARCHAR(10)   NOT NULL,
    TenNV    NVARCHAR(50)   NOT NULL,
    SDTNV    CHAR(10)       NULL,
    EmailNV  NVARCHAR(200)  NULL,
    CONSTRAINT PK_NhanVien PRIMARY KEY (MaNV),
    CONSTRAINT FK_NhanVien_PhongBan
        FOREIGN KEY (MaPB) REFERENCES PhongBan(MaPB),
    CONSTRAINT FK_NhanVien_ChucVu
        FOREIGN KEY (MaCV) REFERENCES ChucVu(MaCV)
);
GO

CREATE TABLE DonViTinh (
    MaDVT   NVARCHAR(10)   NOT NULL,
    TenDVT  NVARCHAR(100)  NOT NULL,
    MoTaDVT NVARCHAR(100)  NULL,
    CONSTRAINT PK_DonViTinh PRIMARY KEY (MaDVT)
);
GO

CREATE TABLE NhomSP (
    MaNhomSP  NVARCHAR(10)  NOT NULL,
    TenNhomSP NVARCHAR(50)  NOT NULL,
    CONSTRAINT PK_NhomSP PRIMARY KEY (MaNhomSP)
);
GO

CREATE TABLE LoaiSP (
    MaLoaiSP  NVARCHAR(10)  NOT NULL,
    MaNhomSP  NVARCHAR(10)  NOT NULL,
    TenLoaiSP NVARCHAR(50)  NOT NULL,
    CONSTRAINT PK_LoaiSP PRIMARY KEY (MaLoaiSP),
    CONSTRAINT FK_LoaiSP_NhomSP
        FOREIGN KEY (MaNhomSP) REFERENCES NhomSP(MaNhomSP)
);
GO


CREATE TABLE SanPham (
    MaSP     NVARCHAR(10)   NOT NULL,
    MaLoaiSP NVARCHAR(10)   NOT NULL,
    MaDVT    NVARCHAR(10)   NOT NULL,
    TenSP    NVARCHAR(50)   NOT NULL,
    MoTaSP   NVARCHAR(100)  NULL,
    CONSTRAINT PK_SanPham PRIMARY KEY (MaSP),
    CONSTRAINT FK_SanPham_LoaiSP
        FOREIGN KEY (MaLoaiSP) REFERENCES LoaiSP(MaLoaiSP),
    CONSTRAINT FK_SanPham_DonViTinh
        FOREIGN KEY (MaDVT) REFERENCES DonViTinh(MaDVT)
);
GO

CREATE TABLE Kho (
    MaKho     NVARCHAR(10)   NOT NULL,
    MaCN      NVARCHAR(10)   NOT NULL,
    TenKho    NVARCHAR(100)  NOT NULL,
    DiaChiKho NVARCHAR(255)  NULL,
    SDT_Kho   NVARCHAR(12)   NULL,
    Email_Kho NVARCHAR(255)  NULL,
    CONSTRAINT PK_Kho PRIMARY KEY (MaKho),
    CONSTRAINT FK_Kho_ChiNhanh
        FOREIGN KEY (MaCN) REFERENCES ChiNhanh(MaCN)
);
GO

CREATE TABLE TonKho (
    MaKho        NVARCHAR(10)  NOT NULL,
    MaSP         NVARCHAR(10)  NOT NULL,
    ThangTK      INT           NOT NULL,
    NamTK        INT           NOT NULL,
    TonDK        INT           NOT NULL,
    TriGiaTonDK  INT           NOT NULL,
    XuatTK       INT           NOT NULL,
    TriGiaXuatTK INT           NOT NULL,
    TonCK        INT           NOT NULL,
    TriGiaTonCK  INT           NOT NULL,
    CONSTRAINT PK_TonKho PRIMARY KEY (MaKho, MaSP, ThangTK, NamTK),
    CONSTRAINT FK_TonKho_Kho
        FOREIGN KEY (MaKho) REFERENCES Kho(MaKho),
    CONSTRAINT FK_TonKho_SanPham
        FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
    -- Tồn kho theo kỳ không phát sinh giá trị âm
    CONSTRAINT CK_TonKho_NonNegative
        CHECK (
            TonDK >= 0 AND XuatTK >= 0 AND TonCK >= 0
            AND TriGiaTonDK >= 0 AND TriGiaXuatTK >= 0 AND TriGiaTonCK >= 0 )
);
GO

GO

CREATE TABLE BienDongGia (
    MaSP        NVARCHAR(10)  NOT NULL,
    NgayCapNhat DATE          NOT NULL,
    GiaBan      DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_BienDongGia PRIMARY KEY (MaSP, NgayCapNhat),
    CONSTRAINT FK_BienDongGia_SanPham
        FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
    CONSTRAINT CK_BDG_GiaBan_NonNegative
        CHECK (GiaBan >= 0)
);
GO



CREATE TABLE CTKhuyenMai (
    MaCT     NVARCHAR(10)   NOT NULL,
    TenCT    NVARCHAR(50)   NOT NULL,
    NgayBDKM DATE           NOT NULL,
    NgayKTKM DATE           NOT NULL,
    LyDoKM   NVARCHAR(100)  NULL,

    CONSTRAINT PK_CTKhuyenMai PRIMARY KEY (MaCT),
    CONSTRAINT CK_CTKM_DateRange
        CHECK (NgayKTKM >= NgayBDKM)
);
GO

CREATE TABLE CTChuongTrinhKM (
    MaCT         NVARCHAR(10)   NOT NULL,
    MaSP         NVARCHAR(10)   NOT NULL,
    TyLePhamTram FLOAT          NULL,
    GiamTheoSP   NVARCHAR(50)   NULL,
    GhiChuKM     NVARCHAR(100)  NULL,

    CONSTRAINT PK_CTChuongTrinhKM PRIMARY KEY (MaCT, MaSP),
    CONSTRAINT FK_CTCTKM_CTKhuyenMai
        FOREIGN KEY (MaCT) REFERENCES CTKhuyenMai(MaCT),
    CONSTRAINT FK_CTCTKM_SanPham
        FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
    CONSTRAINT CK_CTCTKM_OneDiscountType
        CHECK (
            (TyLePhamTram IS NOT NULL AND GiamTheoSP IS NULL)
         OR (TyLePhamTram IS NULL AND GiamTheoSP IS NOT NULL)
        )
);
GO

CREATE TABLE LoaiKH (
    MaLoaiKH  NVARCHAR(10)        NOT NULL,
    TenLoaiKH NVARCHAR(50)   NOT NULL,
    CONSTRAINT PK_LoaiKH PRIMARY KEY (MaLoaiKH)
);
GO


CREATE TABLE KhachHang (
    MaKH       NVARCHAR(10)        NOT NULL,
    MaLoaiKH   NVARCHAR(10)        NOT NULL,
    TenKH      NVARCHAR(50)   NOT NULL,
    NgaySinhKH DATE           NULL,
    SDTKH      INT            NULL,
    DiaChiKH   NVARCHAR(50)   NULL,
    EmailKH      NVARCHAR(100)   NULL,
    CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH),
    CONSTRAINT FK_KhachHang_LoaiKH
        FOREIGN KEY (MaLoaiKH) REFERENCES LoaiKH(MaLoaiKH)
);
GO

CREATE TABLE TheThanhVien (
    SoThe          NVARCHAR(10)       NOT NULL,
    MaKH           NVARCHAR(10)        NOT NULL,
    LoaiThe        NVARCHAR(50)   NOT NULL,
    NgayBD         DATE           NOT NULL,
    NgayHH         DATE           NULL,
    DTLHienCo      INT            NOT NULL,
    DiemDaQuyDoi   INT            NOT NULL,
    TongDTL        INT            NOT NULL,
    NgayHetHanDiem DATE           NULL,
    GhiChuThe      NVARCHAR(100)  NULL,
    TrangThaiThe   NVARCHAR(100)  NULL,
    CONSTRAINT PK_TheThanhVien PRIMARY KEY (SoThe),
    CONSTRAINT FK_TheThanhVien_KhachHang
        FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);
GO


CREATE TABLE NganHang (
    SoTKNH  NVARCHAR(10)   NOT NULL,
    MaKH    NVARCHAR(10)        NOT NULL,
    TenNH   NVARCHAR(255)  NOT NULL,
	ChuTK   NVARCHAR(255) NOT NULL,
    QuocGia NVARCHAR(100)  NULL,
    CONSTRAINT PK_NganHang PRIMARY KEY (SoTKNH),
    CONSTRAINT FK_NganHang_KhachHang
        FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);
GO

CREATE TABLE PhieuDatHang (
    MaPhieuDH         NVARCHAR(10)   NOT NULL,
    MaKH              NVARCHAR(10)   NULL,
    SoThe             NVARCHAR(10)   NULL,
    MaNV              NVARCHAR(10)   NOT NULL,
    NgayDatHang       DATETIME       NOT NULL,
    HinhThucThanhToan NVARCHAR(100)  NULL,
    NgayTT            DATETIME       NULL,
    DiaChiGiao        NVARCHAR(255)  NULL,
    GhiChuDatHang     NVARCHAR(255)  NULL,
    KhuyenMai         DECIMAL(10,2)  NULL,
    TriGiaDH          DECIMAL(10,2)  NOT NULL,

    CONSTRAINT PK_PhieuDatHang PRIMARY KEY (MaPhieuDH),
    CONSTRAINT FK_PDH_KhachHang
        FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    CONSTRAINT FK_PDH_TheThanhVien
        FOREIGN KEY (SoThe) REFERENCES TheThanhVien(SoThe),
    CONSTRAINT FK_PDH_NhanVien
        FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    -- Đơn hàng – thẻ thành viên:
    -- Nếu MaKH = NULL (khách vãng lai) thì SoThe = NULL
    CONSTRAINT CK_PDH_KH_Vanglai
        CHECK (NOT (MaKH IS NULL AND SoThe IS NOT NULL)),
    CONSTRAINT CK_PDH_HinhThucThanhToan
        CHECK (
            HinhThucThanhToan IS NULL OR
            HinhThucThanhToan IN (N'QR', N'Thẻ', N'Tiền mặt', N'Chuyển khoản', N'Nội bộ')
        )
);
GO

GO


CREATE TABLE CTPhieuDatHang (
    MaPhieuDH   NVARCHAR(10)   NOT NULL,
    MaSP        NVARCHAR(10)   NOT NULL,
    SoLuongDH   INT            NOT NULL,
    DonGiaDH    DECIMAL(10,2)  NOT NULL,
    ThanhTienDH DECIMAL(10,2)  NOT NULL,

    CONSTRAINT PK_CTPhieuDatHang PRIMARY KEY (MaPhieuDH, MaSP),
    CONSTRAINT FK_CTPDH_PhieuDatHang
        FOREIGN KEY (MaPhieuDH) REFERENCES PhieuDatHang(MaPhieuDH),
    CONSTRAINT FK_CTPDH_SanPham
        FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
    CONSTRAINT CK_CTPDH_SoLuongDH_GT0
        CHECK (SoLuongDH > 0)
);
GO
CREATE TABLE HoaDon (
    SoHD              NVARCHAR(10)   NOT NULL,
    MaPhieuDH         NVARCHAR(10)   NULL,
    MaKH              NVARCHAR(10)   NULL,
    SoThe             NVARCHAR(10)   NULL,
    MaNV              NVARCHAR(10)   NOT NULL,
    NgayLapHD         DATE           NOT NULL,
    MaSoThue          NVARCHAR(20)   NULL,
    TriGiaTruocThue   DECIMAL(10,2)  NOT NULL,
    TriGiaSauThue     DECIMAL(10,2)  NOT NULL,
    PhuongThucTT      NVARCHAR(50)   NULL,
    TrangThaiHD       NVARCHAR(100)  NULL,

    CONSTRAINT PK_HoaDon PRIMARY KEY (SoHD),
    CONSTRAINT FK_HoaDon_PDH
        FOREIGN KEY (MaPhieuDH) REFERENCES PhieuDatHang(MaPhieuDH),
    CONSTRAINT FK_HoaDon_KhachHang
        FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    CONSTRAINT FK_HoaDon_TheThanhVien
        FOREIGN KEY (SoThe) REFERENCES TheThanhVien(SoThe),
    CONSTRAINT FK_HoaDon_NhanVien
        FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    CONSTRAINT CK_HD_TrangThaiHD
        CHECK (
            TrangThaiHD IS NULL OR
            TrangThaiHD IN (N'Đã thanh toán', N'Chưa thanh toán', N'Đã hủy')
        )
);
GO


CREATE TABLE CTHoaDon (
    SoHD        NVARCHAR(10)   NOT NULL,
    MaSP        NVARCHAR(10)   NOT NULL,
    SoLuongHD   INT            NOT NULL,
    DonGiaHD    DECIMAL(10,2)  NOT NULL,
    ThanhTienHD DECIMAL(10,2)  NOT NULL,
    CONSTRAINT PK_CTHoaDon PRIMARY KEY (SoHD, MaSP),
    CONSTRAINT FK_CTHD_HoaDon
        FOREIGN KEY (SoHD) REFERENCES HoaDon(SoHD),
    CONSTRAINT FK_CTHD_SanPham
        FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);
GO

CREATE TABLE PhieuXuat (
    MaPX      NVARCHAR(10)   NOT NULL,
    MaKho     NVARCHAR(10)   NOT NULL,
    SoHD      NVARCHAR(10)   NULL,
    NgayLapPX DATE           NOT NULL,
    TriGiaPX  DECIMAL(10,2)  NOT NULL,
    CONSTRAINT PK_PhieuXuat PRIMARY KEY (MaPX),
    CONSTRAINT FK_PX_Kho
        FOREIGN KEY (MaKho) REFERENCES Kho(MaKho),
    CONSTRAINT FK_PX_HoaDon
        FOREIGN KEY (SoHD) REFERENCES HoaDon(SoHD)
);
GO

CREATE TABLE CTPX (
    MaPX        NVARCHAR(10)   NOT NULL,
    MaSP        NVARCHAR(10)   NOT NULL,
    SoLuongXuat INT            NOT NULL,
    DonGiaXuat  DECIMAL(10,2)  NOT NULL,
    ThanhTienPX DECIMAL(10,2)  NOT NULL,
    CONSTRAINT PK_CTPX PRIMARY KEY (MaPX, MaSP),
    CONSTRAINT FK_CTPX_PhieuXuat
        FOREIGN KEY (MaPX) REFERENCES PhieuXuat(MaPX),
    CONSTRAINT FK_CTPX_SanPham
        FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);
GO

CREATE TABLE PhieuGiaoHang (
    MaPGH          NVARCHAR(10)   NOT NULL,
    MaPhieuDH      NVARCHAR(10)   NULL,
    SoHD           NVARCHAR(10)   NULL,
    NgayGiao       DATE           NOT NULL,
    DiaChiGiaoHang NVARCHAR(255)  NOT NULL,
    NguoiNhan      NVARCHAR(100)  NOT NULL,
    SDTNhan        CHAR(10)       NOT NULL,
    PhiShip        DECIMAL(10,2)  NOT NULL,
    HinhThucGiao   NVARCHAR(100)  NULL,
    TrangThaiGiao  NVARCHAR(100)  NULL,
    CONSTRAINT PK_PhieuGiaoHang PRIMARY KEY (MaPGH),
    CONSTRAINT FK_PGH_PhieuDatHang
        FOREIGN KEY (MaPhieuDH) REFERENCES PhieuDatHang(MaPhieuDH),
    CONSTRAINT FK_PGH_HoaDon
        FOREIGN KEY (SoHD) REFERENCES HoaDon(SoHD)
);
GO


CREATE TABLE CTPhieuGiaoHang (
    MaPGH          NVARCHAR(10)   NOT NULL,
    MaSP           NVARCHAR(10)   NOT NULL,
    SoLuongGiao    INT            NOT NULL,
    GhiChuPGH NVARCHAR(255)  NULL,
    CONSTRAINT PK_CTPhieuGiaoHang PRIMARY KEY (MaPGH, MaSP),
    CONSTRAINT FK_CTPGH_PhieuGiaoHang
        FOREIGN KEY (MaPGH) REFERENCES PhieuGiaoHang(MaPGH),
    CONSTRAINT FK_CTPGH_SanPham
        FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);
GO

CREATE TABLE VaiTroHeThong (
    MaVT  NVARCHAR(10)   NOT NULL,
    TenVT NVARCHAR(100)  NOT NULL,
    CONSTRAINT PK_VaiTroHeThong PRIMARY KEY (MaVT)
);
GO

CREATE TABLE QuyDinhNghiepVu (
    MaQD          NVARCHAR(10)   NOT NULL,   -- Mã quy định
    TenQD         NVARCHAR(200)  NOT NULL,   -- Tên ngắn gọn
    NoiDungQD     NVARCHAR(1000) NOT NULL,   -- Nội dung chi tiết
    LoaiQuyTrinh  NVARCHAR(100)  NULL,       -- Nhóm: Ca làm việc, Bán hàng, CSKH...
    DoiTuongApDung NVARCHAR(100) NULL,       -- Đối tượng: Thu ngân, NV bán hàng,...
    CaApDung      NVARCHAR(100)  NULL,       -- Ca sáng/chiều/toàn bộ,...
    NgayHieuLuc   DATE           NOT NULL,   -- Ngày bắt đầu hiệu lực
    TrangThaiQD   NVARCHAR(50)   NULL,       -- Đang áp dụng / Ngưng áp dụng
    GhiChuQD      NVARCHAR(255)  NULL,       -- Ghi chú khác
    CONSTRAINT PK_QuyDinhQuyTrinh PRIMARY KEY (MaQD)
);

CREATE TABLE TaiKhoanNV (
    MaTK        NVARCHAR(10)   NOT NULL,
    MaNV        NVARCHAR(10)   NOT NULL,
    MaVT        NVARCHAR(10)   NOT NULL,
    TenDangNhap NVARCHAR(255)  NOT NULL,
    MatKhau     NVARCHAR(255)  NOT NULL,

    CONSTRAINT PK_TaiKhoanNV PRIMARY KEY (MaTK),
    CONSTRAINT UQ_TaiKhoanNV_TenDangNhap UNIQUE (TenDangNhap),
    CONSTRAINT UQ_TaiKhoanNV_MaNV        UNIQUE (MaNV),

    CONSTRAINT FK_TaiKhoanNV_NhanVien
        FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    CONSTRAINT FK_TaiKhoanNV_VaiTro
        FOREIGN KEY (MaVT) REFERENCES VaiTroHeThong(MaVT)
);
GO


CREATE TABLE LoaiDoiTuong (
    MaLDT  NVARCHAR(10)   NOT NULL,
    TenLDT NVARCHAR(100)  NOT NULL,
    CONSTRAINT PK_LoaiDoiTuong PRIMARY KEY (MaLDT)
);
GO

CREATE TABLE DoiTuong (
    MaDT   NVARCHAR(10)   NOT NULL,
    MaLDT  NVARCHAR(10)   NOT NULL,
    TenDT  NVARCHAR(100)  NOT NULL,
    CONSTRAINT PK_DoiTuong PRIMARY KEY (MaDT),
    CONSTRAINT FK_DoiTuong_LoaiDoiTuong
        FOREIGN KEY (MaLDT) REFERENCES LoaiDoiTuong(MaLDT)
);
GO

CREATE TABLE LoaiQuyen (
    MaLQ      NVARCHAR(10)   NOT NULL,
    LoaiQuyen NVARCHAR(100)  NOT NULL,
    CONSTRAINT PK_LoaiQuyen PRIMARY KEY (MaLQ)
);
GO

CREATE TABLE Quyen (
    MaQuyen  NVARCHAR(10)   NOT NULL,
    MaLQ     NVARCHAR(10)   NOT NULL,
    TenQuyen NVARCHAR(100)  NOT NULL,
    CONSTRAINT PK_Quyen PRIMARY KEY (MaQuyen),
    CONSTRAINT FK_Quyen_LoaiQuyen
        FOREIGN KEY (MaLQ) REFERENCES LoaiQuyen(MaLQ)
);
GO


CREATE TABLE PhanQuyen (
    MaVT              NVARCHAR(10)   NOT NULL,
    MaDT              NVARCHAR(10)   NOT NULL,
    MaQuyen           NVARCHAR(10)   NOT NULL,
    NgayCapQuyen      DATE           NULL,
    GhiChuPhanQuyen   NVARCHAR(255)  NULL,
    TrangThaiPhanQuyen NVARCHAR(255) NULL,
    CONSTRAINT PK_PhanQuyen PRIMARY KEY (MaVT, MaDT, MaQuyen),
    CONSTRAINT FK_PhanQuyen_VaiTro
        FOREIGN KEY (MaVT) REFERENCES VaiTroHeThong(MaVT),
    CONSTRAINT FK_PhanQuyen_DoiTuong
        FOREIGN KEY (MaDT) REFERENCES DoiTuong(MaDT),
    CONSTRAINT FK_PhanQuyen_Quyen
        FOREIGN KEY (MaQuyen) REFERENCES Quyen(MaQuyen)
);
go

USE QLBanHangPhucLong;
GO

INSERT INTO ChiNhanh (MaCN, TenCN, SDT_CN, Email_CN) VALUES
(N'CN01', N'Trụ sở chính Phúc Long',     '0901000001', N'hq@phuclong.vn'),
(N'CN02', N'Phúc Long Đồng Khởi',        '0901000002', N'cn02@phuclong.vn'),
(N'CN03', N'Phúc Long Landmark 81',      '0901000003', N'cn03@phuclong.vn'),
(N'CN04', N'Phúc Long Aeon Tân Phú',     '0901000004', N'cn04@phuclong.vn'),
(N'CN05', N'Phúc Long Crescent Mall',    '0901000005', N'cn05@phuclong.vn'),
(N'CN06', N'Phúc Long Gigamall',         '0901000006', N'cn06@phuclong.vn'),
(N'CN07', N'Phúc Long Vạn Hạnh',         '0901000007', N'cn07@phuclong.vn'),
(N'CN08', N'Phúc Long Đà Nẵng',          '0901000008', N'cn08@phuclong.vn'),
(N'CN09', N'Phúc Long Lotte Hà Nội',     '0901000009', N'cn09@phuclong.vn'),
(N'CN10', N'Phúc Long Hải Phòng',        '0901000010', N'cn10@phuclong.vn');
GO

INSERT INTO PhongBan (MaPB, MaCN, TenPB, SDT_PB, Email_PB) VALUES
-- CN01 - Trụ sở
(N'PB01', N'CN01', N'Kế toán - Trụ sở',   '0901100001', N'ketoan_hq@phuclong.vn'),
(N'PB02', N'CN01', N'CSKH - Trụ sở',      '0901100002', N'cskh_hq@phuclong.vn'),
(N'PB03', N'CN01', N'Marketing - Trụ sở', '0901100003', N'mkt_hq@phuclong.vn'),
-- CN02 - Đồng Khởi
(N'PB04', N'CN02', N'Bán hàng - Đồng Khởi', '0901200001', N'bh_cn02@phuclong.vn'),
(N'PB05', N'CN02', N'Thu ngân - Đồng Khởi', '0901200002', N'tn_cn02@phuclong.vn'),
(N'PB06', N'CN02', N'Kho - Đồng Khởi',      '0901200003', N'kho_cn02@phuclong.vn'),
-- CN03 - Landmark 81
(N'PB07', N'CN03', N'Bán hàng - Landmark',  '0901300001', N'bh_cn03@phuclong.vn'),
(N'PB08', N'CN03', N'Thu ngân - Landmark',  '0901300002', N'tn_cn03@phuclong.vn'),
(N'PB09', N'CN03', N'Kho - Landmark',       '0901300003', N'kho_cn03@phuclong.vn'),
-- CN04 - Aeon Tân Phú
(N'PB10', N'CN04', N'Bán hàng - Aeon Tân Phú', '0901400001', N'bh_cn04@phuclong.vn'),
(N'PB11', N'CN04', N'Thu ngân - Aeon Tân Phú', '0901400002', N'tn_cn04@phuclong.vn'),
(N'PB12', N'CN04', N'Kho - Aeon Tân Phú',      '0901400003', N'kho_cn04@phuclong.vn'),
-- CN05 - Crescent
(N'PB13', N'CN05', N'Bán hàng - Crescent', '0901500001', N'bh_cn05@phuclong.vn'),
(N'PB14', N'CN05', N'Thu ngân - Crescent', '0901500002', N'tn_cn05@phuclong.vn'),
(N'PB15', N'CN05', N'Kho - Crescent',      '0901500003', N'kho_cn05@phuclong.vn'),
-- CN06 - Gigamall
(N'PB16', N'CN06', N'Bán hàng - Gigamall', '0901600001', N'bh_cn06@phuclong.vn'),
(N'PB17', N'CN06', N'Thu ngân - Gigamall', '0901600002', N'tn_cn06@phuclong.vn'),
(N'PB18', N'CN06', N'Kho - Gigamall',      '0901600003', N'kho_cn06@phuclong.vn'),
-- CN07 - Vạn Hạnh
(N'PB19', N'CN07', N'Bán hàng - Vạn Hạnh', '0901700001', N'bh_cn07@phuclong.vn'),
(N'PB20', N'CN07', N'Thu ngân - Vạn Hạnh', '0901700002', N'tn_cn07@phuclong.vn'),
-- CN08 - Đà Nẵng
(N'PB21', N'CN08', N'Bán hàng - Đà Nẵng',  '0901800001', N'bh_cn08@phuclong.vn'),
(N'PB22', N'CN08', N'Thu ngân - Đà Nẵng',  '0901800002', N'tn_cn08@phuclong.vn'),
(N'PB23', N'CN08', N'Kho - Đà Nẵng',       '0901800003', N'kho_cn08@phuclong.vn'),
-- CN09 - Lotte Hà Nội
(N'PB24', N'CN09', N'Bán hàng - Lotte HN', '0901900001', N'bh_cn09@phuclong.vn'),
(N'PB25', N'CN09', N'Thu ngân - Lotte HN', '0901900002', N'tn_cn09@phuclong.vn'),
(N'PB26', N'CN09', N'Kho - Lotte HN',      '0901900003', N'kho_cn09@phuclong.vn'),
-- CN10 - Hải Phòng
(N'PB27', N'CN10', N'Bán hàng - Hải Phòng','0902000001', N'bh_cn10@phuclong.vn'),
(N'PB28', N'CN10', N'Thu ngân - Hải Phòng','0902000002', N'tn_cn10@phuclong.vn');
GO


INSERT INTO ChucVu (MaCV, TenCV) VALUES
(N'CV001', N'Quản trị hệ thống'),
(N'CV002', N'Quản lý chi nhánh'),
(N'CV003', N'Quản lý bán hàng'),
(N'CV004', N'Thu ngân'),
(N'CV005', N'Nhân viên bán hàng'),
(N'CV006', N'Chăm sóc khách hàng'),
(N'CV007', N'Nhân viên kho'),
(N'CV008', N'Quản lý kho'),
(N'CV009', N'Marketing'),
(N'CV010', N'Kế toán');
GO


INSERT INTO NhanVien (MaNV, MaPB, MaCV, TenNV, SDTNV, EmailNV) VALUES
-- Trụ sở CN01
(N'NV001', N'PB01', N'CV001', N'Nguyễn Minh Quân', '0910000001', N'pl_admin@phuclong.vn'),
(N'NV015', N'PB01', N'CV010', N'Ngô Đức Thịnh',    '0910000015', N'ketoan_hq@phuclong.vn'),
(N'NV010', N'PB02', N'CV006', N'Nguyễn Thúy Vy',   '0910000010', N'cskh01_hq@phuclong.vn'),
(N'NV011', N'PB02', N'CV006', N'Đặng Mỹ Linh',     '0910000011', N'cskh02_hq@phuclong.vn'),
(N'NV017', N'PB03', N'CV009', N'Bùi Thị Hồng',     '0910000017', N'mkt01_hq@phuclong.vn'),
(N'NV016', N'PB03', N'CV009', N'Nguyễn Thị Lan',   '0910000016', N'mkt02_hq@phuclong.vn'),
-- CN02 Đồng Khởi
(N'NV002', N'PB04', N'CV002', N'Lê Thị Thu Trang', '0910000002', N'manager_cn02@phuclong.vn'),
(N'NV004', N'PB04', N'CV003', N'Hoàng Trần An',    '0910000004', N'qlsales_cn02@phuclong.vn'),
(N'NV005', N'PB05', N'CV004', N'Trần Ngọc Hân',    '0910000005', N'tn_cn02@phuclong.vn'),
(N'NV006', N'PB06', N'CV007', N'Ngô Thị Mỹ Linh',  '0910000006', N'kho_cn02@phuclong.vn'),
(N'NV007', N'PB04', N'CV005', N'Phạm Anh Tuấn',    '0910000007', N'sales_cn02@phuclong.vn'),
-- CN03 Landmark
(N'NV003', N'PB07', N'CV002', N'Phan Quốc Đạt',    '0910000003', N'manager_cn03@phuclong.vn'),
(N'NV008', N'PB08', N'CV004', N'Đỗ Hoàng Nam',     '0910000008', N'tn_cn03@phuclong.vn'),
(N'NV009', N'PB09', N'CV007', N'Nguyễn Văn Thái',  '0910000009', N'kho_cn03@phuclong.vn'),
(N'NV018', N'PB09', N'CV008', N'Võ Quốc Huy',      '0910000018', N'qlkho_cn03@phuclong.vn'),
(N'NV012', N'PB07', N'CV005', N'Lại Minh Phúc',    '0910000012', N'sales_cn03@phuclong.vn'),
-- CN04 Aeon Tân Phú
(N'NV013', N'PB10', N'CV005', N'Trương Anh Khoa',  '0910000013', N'sales_cn04@phuclong.vn'),
(N'NV014', N'PB11', N'CV004', N'Đinh Thị Hằng',    '0910000014', N'tn_cn04@phuclong.vn'),
-- CN05 Crescent
(N'NV019', N'PB13', N'CV005', N'Trần Anh Đào',     '0910000019', N'sales_cn05@phuclong.vn'),
(N'NV020', N'PB14', N'CV004', N'Phùng Hồng Mai',   '0910000020', N'tn_cn05@phuclong.vn'),
(N'NV021', N'PB15', N'CV007', N'Lê Thùy Dung',     '0910000021', N'kho_cn05@phuclong.vn'),
-- CN09 Lotte HN
(N'NV022', N'PB24', N'CV002', N'Nguyễn Hải Yến',   '0910000022', N'manager_cn09@phuclong.vn'),
(N'NV023', N'PB25', N'CV004', N'Phạm Thu Hiền',    '0910000023', N'tn_cn09@phuclong.vn'),
(N'NV024', N'PB26', N'CV007', N'Ngô Gia Bảo',      '0910000024', N'kho_cn09@phuclong.vn');
GO

INSERT INTO DonViTinh (MaDVT, TenDVT, MoTaDVT) VALUES
(N'DVT01', N'Ly',    N'Đồ uống pha chế'),
(N'DVT02', N'Chai',  N'Đồ uống đóng chai'),
(N'DVT03', N'Lon',   N'Đồ uống đóng lon'),
(N'DVT04', N'Phần',  N'Topping, bánh, món kèm'),
(N'DVT05', N'Cái',   N'Ly/bình/merchandise'),
(N'DVT06', N'Hộp',   N'Đóng hộp'),
(N'DVT07', N'Gói',   N'Đóng gói'),
(N'DVT08', N'Set',   N'Bộ quà tặng'),
(N'DVT09', N'Combo', N'Combo bán/khuyến mãi');
GO

INSERT INTO NhomSP (MaNhomSP, TenNhomSP) VALUES
(N'NSP01', N'Trà'),
(N'NSP02', N'Cà phê'),
(N'NSP03', N'Sữa & Đá xay'),
(N'NSP04', N'Nước trái cây'),
(N'NSP05', N'Bánh ngọt'),
(N'NSP06', N'Topping'),
(N'NSP07', N'Sản phẩm đóng gói'),
(N'NSP08', N'Dụng cụ & Vật tư');
GO

INSERT INTO LoaiSP (MaLoaiSP, MaNhomSP, TenLoaiSP) VALUES
(N'LSP01', N'NSP01', N'Trà sữa'),
(N'LSP02', N'NSP01', N'Trà trái cây'),
(N'LSP03', N'NSP01', N'Trà truyền thống'),
(N'LSP04', N'NSP02', N'Cà phê Việt Nam'),
(N'LSP05', N'NSP02', N'Cà phê máy'),
(N'LSP06', N'NSP03', N'Đá xay'),
(N'LSP07', N'NSP03', N'Sữa tươi'),
(N'LSP08', N'NSP04', N'Nước ép'),
(N'LSP09', N'NSP04', N'Sinh tố'),
(N'LSP10', N'NSP05', N'Bánh kem'),
(N'LSP11', N'NSP05', N'Bánh mì - Pastry'),
(N'LSP12', N'NSP06', N'Trân châu'),
(N'LSP13', N'NSP06', N'Thạch & Kem'),
(N'LSP14', N'NSP07', N'Cà phê gói'),
(N'LSP15', N'NSP07', N'Trà gói'),
(N'LSP16', N'NSP07', N'Ly/bình bán lẻ'),
(N'LSP17', N'NSP08', N'Ly - Nắp - Ống hút'),
(N'LSP18', N'NSP08', N'Nguyên liệu pha chế');
GO
INSERT INTO SanPham (MaSP, MaLoaiSP, MaDVT, TenSP, MoTaSP) VALUES
-- Trà sữa
(N'SP001', N'LSP01', N'DVT01',   N'Trà sữa truyền thống',      N'Size tiêu chuẩn'),
(N'SP002', N'LSP01', N'DVT01',   N'Trà sữa ô long',           N'Hương ô long dịu'),
(N'SP003', N'LSP01', N'DVT01',   N'Trà sữa matcha',           N'Vị matcha béo'),
(N'SP004', N'LSP01', N'DVT01',   N'Trà sữa socola',           N'Cacao/socola'),
-- Trà trái cây
(N'SP005', N'LSP02', N'DVT01',   N'Trà đào',                  N'Đào miếng'),
(N'SP006', N'LSP02', N'DVT01',   N'Trà vải',                  N'Vải tươi/đóng hộp'),
(N'SP007', N'LSP02', N'DVT01',   N'Trà chanh dây',            N'Chua ngọt'),
(N'SP008', N'LSP02', N'DVT01',   N'Trà dâu',                  N'Hương dâu'),
-- Trà truyền thống
(N'SP009', N'LSP03', N'DVT01',   N'Trà sen vàng',             N'Nổi bật hạt sen'),
(N'SP010', N'LSP03', N'DVT01',   N'Trà xanh',                 N'Thanh nhẹ'),
-- Cà phê
(N'SP011', N'LSP04', N'DVT01',   N'Cà phê sữa đá',            N'Phong cách Việt'),
(N'SP012', N'LSP04', N'DVT01',   N'Bạc xỉu',                  N'Nhiều sữa'),
(N'SP013', N'LSP05', N'DVT01',   N'Americano',                N'Cà phê máy'),
(N'SP014', N'LSP05', N'DVT01',   N'Latte',                    N'Sữa tươi'),
-- Đá xay / sữa tươi
(N'SP015', N'LSP06', N'DVT01',   N'Matcha đá xay',            N'Blend đá'),
(N'SP016', N'LSP06', N'DVT01',   N'Socola đá xay',            N'Blend cacao'),
(N'SP017', N'LSP07', N'DVT01',   N'Sữa tươi trân châu đường đen', N'Hot trend'),
-- Bánh
(N'SP018', N'LSP10', N'DVT05',   N'Bánh kem mini',            N'Phần nhỏ'),
(N'SP019', N'LSP11', N'DVT05',   N'Bánh croissant',           N'Bơ thơm'),
(N'SP020', N'LSP11', N'DVT05',   N'Bánh mì sandwich',         N'Ăn nhanh'),
-- Topping
(N'SP021', N'LSP12', N'DVT04',   N'Trân châu đen',            N'Topping thêm'),
(N'SP022', N'LSP12', N'DVT04',   N'Trân châu trắng',          N'Topping thêm'),
(N'SP023', N'LSP13', N'DVT04',   N'Thạch phô mai',            N'Topping thêm'),
-- Đóng gói
(N'SP024', N'LSP14', N'DVT07',   N'Cà phê rang xay 250g',     N'Gói 250g'),
(N'SP025', N'LSP15', N'DVT07',   N'Trà ô long 100g',          N'Gói 100g'),
-- Ly/bình bán lẻ
(N'SP026', N'LSP16', N'DVT05',   N'Bình giữ nhiệt Phúc Long', N'Hàng merchandise'),
(N'SP027', N'LSP16', N'DVT05',   N'Ly nhựa Phúc Long',        N'Hàng merchandise');
GO

INSERT INTO Kho (MaKho, MaCN, TenKho, DiaChiKho, SDT_Kho, Email_Kho) VALUES
(N'KHO01', N'CN01', N'Kho Trung Tâm Miền Nam', N'TP.HCM', N'0900000001', N'kho.mn@phuclong.vn'),
(N'KHO02', N'CN02', N'Kho Trung Tâm Miền Bắc', N'Hà Nội', N'0900000002', N'kho.mb@phuclong.vn'),
(N'KHO03', N'CN03', N'Kho Khu Vực Đông',      N'Thủ Đức', N'0900000003', N'kho.dong@phuclong.vn'),
(N'KHO04', N'CN04', N'Kho Khu Vực Tây',       N'Bình Tân', N'0900000004', N'kho.tay@phuclong.vn'),
(N'KHO05', N'CN05', N'Kho Khu Vực Nam',       N'Nhà Bè', N'0900000005', N'kho.nam@phuclong.vn'),
(N'KHO06', N'CN06', N'Kho Khu Vực Bắc 1',     N'Cầu Giấy', N'0900000006', N'kho.bac1@phuclong.vn'),
(N'KHO07', N'CN07', N'Kho Khu Vực Bắc 2',     N'Long Biên', N'0900000007', N'kho.bac2@phuclong.vn'),
(N'KHO08', N'CN08', N'Kho Bánh & Topping',    N'TP.HCM', N'0900000008', N'kho.banh@phuclong.vn');
GO

INSERT INTO TonKho
(MaKho, MaSP, ThangTK, NamTK, TonDK, TriGiaTonDK, XuatTK, TriGiaXuatTK, TonCK, TriGiaTonCK)
VALUES
-- KHO01 - miền Nam
(N'KHO01', N'SP001', 11, 2025, 1200, 36000000, 800, 24000000, 400, 12000000),
(N'KHO01', N'SP011', 11, 2025,  900, 27000000, 600, 18000000, 300,  9000000),
(N'KHO01', N'SP017', 11, 2025,  700, 24500000, 500, 17500000, 200,  7000000),
(N'KHO01', N'SP021', 11, 2025, 1500,  9000000, 900,  5400000, 600,  3600000),
-- KHO03 - khu vực Đông
(N'KHO03', N'SP002', 11, 2025,  800, 24800000, 500, 15500000, 300,  9300000),
(N'KHO03', N'SP005', 11, 2025,  600, 18000000, 350, 10500000, 250,  7500000),
(N'KHO03', N'SP012', 11, 2025,  650, 19500000, 400, 12000000, 250,  7500000),
-- KHO04 - khu vực Tây
(N'KHO04', N'SP003', 11, 2025,  500, 16500000, 260,  8580000, 240,  7920000),
(N'KHO04', N'SP006', 11, 2025,  520, 15600000, 300,  9000000, 220,  6600000),
(N'KHO04', N'SP015', 11, 2025,  450, 15750000, 280,  9800000, 170,  5950000),
-- KHO08 - kho bánh & topping
(N'KHO08', N'SP018', 11, 2025,  220,  8800000, 140,  5600000,  80,  3200000),
(N'KHO08', N'SP019', 11, 2025,  300,  7500000, 180,  4500000, 120,  3000000),
(N'KHO08', N'SP020', 11, 2025,  260,  5200000, 160,  3200000, 100,  2000000),
(N'KHO08', N'SP022', 11, 2025,  900,  5400000, 500,  3000000, 400,  2400000),
(N'KHO08', N'SP023', 11, 2025,  650,  4550000, 380,  2660000, 270,  1890000),
-- KHO02 - miền Bắc 
(N'KHO02', N'SP001', 11, 2025,  700, 21000000, 420, 12600000, 280,  8400000),
(N'KHO02', N'SP011', 11, 2025,  500, 15000000, 320,  9600000, 180,  5400000);
GO

INSERT INTO BienDongGia (MaSP, NgayCapNhat, GiaBan) VALUES
(N'SP001', '2025-10-01', 32000),
(N'SP001', '2025-11-01', 34000),
(N'SP002', '2025-10-01', 35000),
(N'SP002', '2025-11-01', 37000),
(N'SP003', '2025-10-01', 39000),
(N'SP003', '2025-11-01', 41000),
(N'SP004', '2025-10-01', 36000),
(N'SP004', '2025-11-01', 38000),
(N'SP005', '2025-10-01', 32000),
(N'SP005', '2025-11-01', 34000),
(N'SP006', '2025-10-01', 33000),
(N'SP006', '2025-11-01', 35000),
(N'SP007', '2025-10-01', 34000),
(N'SP007', '2025-11-01', 36000),
(N'SP008', '2025-10-01', 34000),
(N'SP008', '2025-11-01', 36000),
(N'SP009', '2025-10-01', 38000),
(N'SP009', '2025-11-01', 40000),
(N'SP010', '2025-10-01', 30000),
(N'SP010', '2025-11-01', 32000),
(N'SP011', '2025-10-01', 29000),
(N'SP011', '2025-11-01', 31000),
(N'SP012', '2025-10-01', 30000),
(N'SP012', '2025-11-01', 32000),
(N'SP013', '2025-10-01', 35000),
(N'SP013', '2025-11-01', 37000),
(N'SP014', '2025-10-01', 42000),
(N'SP014', '2025-11-01', 44000),
(N'SP026', '2025-10-01', 149000),
(N'SP027', '2025-10-01', 59000);
GO
INSERT INTO CTKhuyenMai (MaCT, TenCT, NgayBDKM, NgayKTKM, LyDoKM) VALUES
(N'CT001', N'Khai trương chi nhánh mới', '2025-09-01', '2025-09-15', N'Ưu đãi khai trương'),
(N'CT002', N'Siêu hội trà sữa', '2025-10-05', '2025-10-12', N'Tăng doanh số nhóm trà sữa'),
(N'CT003', N'Tuần lễ trà trái cây', '2025-10-20', '2025-10-27', N'Đẩy hàng seasonal'),
(N'CT004', N'Combo cà phê buổi sáng','2025-11-01', '2025-11-30', N'Khuyến khích mua sáng'),
(N'CT005', N'Happy Weekend',  '2025-11-08', '2025-12-08', N'Kích cầu cuối tuần'),
(N'CT006', N'Tri ân thành viên', '2025-11-15', '2025-12-15', N'Chăm sóc KH thân thiết');
GO
INSERT INTO CTChuongTrinhKM (MaCT, MaSP, TyLePhamTram, GiamTheoSP, GhiChuKM) VALUES
-- CT002: Trà sữa
(N'CT002', N'SP001', 10, NULL,N'Giảm 10%'),
(N'CT002', N'SP002', 10, NULL, N'Giảm 10%'),
(N'CT002', N'SP003', 10, NULL,  N'Giảm 10%'),
(N'CT002', N'SP004', 10, NULL,  N'Giảm 10%'),
-- CT003: Trà trái cây
(N'CT003', N'SP005', 15, NULL, N'Giảm 15%'),
(N'CT003', N'SP006', 15, NULL, N'Giảm 15%'),
(N'CT003', N'SP007', 15, NULL,N'Giảm 15%'),
(N'CT003', N'SP008', 15, NULL,N'Giảm 15%'),
-- CT004: Cà phê sáng (giảm theo số tiền - dạng text)
(N'CT004', N'SP011', NULL, N'5000', N'Giảm 5k mỗi ly'),
(N'CT004', N'SP012', NULL, N'5000',N'Giảm 5k mỗi ly'),
(N'CT004', N'SP013', NULL, N'7000',N'Giảm 7k mỗi ly'),
(N'CT004', N'SP014', NULL, N'7000', N'Giảm 7k mỗi ly'),
-- CT005: Happy Weekend (đa nhóm)
(N'CT005', N'SP009', 10, NULL,N'Giảm 10%'),
(N'CT005', N'SP010', 10, NULL,N'Giảm 10%'),
(N'CT005', N'SP015', 12, NULL,N'Giảm 12%'),
(N'CT005', N'SP016', 12, NULL,N'Giảm 12%'),
(N'CT005', N'SP018', NULL, N'8000',N'Giảm 8k bánh'),
-- CT006: Tri ân thành viên
(N'CT006', N'SP021', 20, NULL,N'Topping giảm 20%'),
(N'CT006', N'SP022', 20, NULL,N'Topping giảm 20%'),
(N'CT006', N'SP023', 20, NULL,N'Topping giảm 20%');
GO
INSERT INTO LoaiKH (MaLoaiKH, TenLoaiKH) VALUES
(N'LKH01', N'Khách vãng lai'),
(N'LKH02', N'Khách thành viên'),
(N'LKH03', N'Khách doanh nghiệp'),
(N'LKH04', N'Khách nội bộ');
GO
INSERT INTO KhachHang (MaKH, MaLoaiKH, TenKH, NgaySinhKH, SDTKH, DiaChiKH, EmailKH) VALUES
(N'KH001', N'LKH01', N'Nguyễn Minh An',   '1999-02-10', '0912345678', N'Q1, TP.HCM',  N'an1@gmail.com'),
(N'KH002', N'LKH02', N'Trần Thu Hà',      '2000-08-21', '0913245679', N'Q3, TP.HCM',  N'ha2@gmail.com'),
(N'KH003', N'LKH02', N'Lê Quốc Bảo',      '1998-11-05', '0914345680', N'Q7, TP.HCM',  N'bao3@gmail.com'),
(N'KH004', N'LKH01', N'Phạm Ngọc Mai',    '2001-01-14', '0915445681', N'Q10, TP.HCM', N'mai4@gmail.com'),
(N'KH005', N'LKH02', N'Võ Thành Đạt',    '1997-06-30','0916545682', N'Q5, TP.HCM',  N'dat5@gmail.com'),
(N'KH006', N'LKH01', N'Nguyễn Tuấn Kiệt', '1996-03-12', '0917645683', N'Thủ Đức',     N'kiet6@gmail.com'),
(N'KH007', N'LKH02', N'Đặng Mỹ Linh',     '2002-09-09', '0918745684', N'Bình Thạnh',  N'linh7@gmail.com'),
(N'KH008', N'LKH01', N'Bùi Quốc Huy',     '1995-12-22','0919845685', N'Gò Vấp',      N'huy8@gmail.com'),
(N'KH009', N'LKH02', N'Phan Gia Hân',     '2000-04-18', '0911245686', N'Tân Phú',     N'han9@gmail.com'),
(N'KH010', N'LKH01', N'Hoàng Đức Long',   '1994-07-07', '0910345687', N'Bình Tân',    N'long10@gmail.com'),
(N'KH011', N'LKH03', N'Cty ABC Foods',  NULL, '0909445688', N'Q1, TP.HCM',  N'contact@abcfoods.vn'),
(N'KH012', N'LKH03', N'Cty Green Office', NULL,  '0908545689', N'Q2, TP.HCM',  N'sales@greenoffice.vn'),
(N'KH013', N'LKH04', N'NV Nội Bộ 01', NULL,  '0907645690', N'Kho tổng',    N'internal01@pl.vn'),
(N'KH014', N'LKH04', N'NV Nội Bộ 02',     NULL,'0906745691', N'Văn phòng',   N'internal02@pl.vn'),
(N'KH015', N'LKH02', N'Ngô Thảo Vy', '2001-10-01','0905845692', N'Q6, TP.HCM',  N'vy15@gmail.com'),
(N'KH016', N'LKH01', N'Đỗ Hữu Phước','1999-05-23', '0904945693', N'Q8, TP.HCM',  N'phuoc16@gmail.com'),
(N'KH017', N'LKH02', N'Tạ Minh Khôi', '1998-02-02', '0903145694', N'Q11, TP.HCM', N'khoi17@gmail.com'),
(N'KH018', N'LKH01', N'Phùng Anh Thư','2002-12-12', '0902245695', N'Q12, TP.HCM', N'thu18@gmail.com'),
(N'KH019', N'LKH02', N'Nguyễn Hải Yến','1997-09-27', '0901345696', N'Phú Nhuận',   N'yen19@gmail.com'),
(N'KH020', N'LKH01', N'Lý Hoàng Nam', '1996-01-09', '0900445697', N'Tân Bình',    N'nam20@gmail.com');
GO
INSERT INTO TheThanhVien
(SoThe, MaKH, LoaiThe, NgayBD, NgayHH, DTLHienCo, DiemDaQuyDoi, TongDTL, NgayHetHanDiem, GhiChuThe, TrangThaiThe)
VALUES
-- Các thẻ đầu năm: đặt hết hạn + hết hiệu lực
(N'ST001', N'KH002', N'Silver',   '2025-01-10', '2025-05-31', 120,  30,  2500000, '2025-12-31', NULL, N'Hết hiệu lực'),
(N'ST002', N'KH003', N'Gold',     '2025-02-05', '2025-06-14', 340,  80,  8200000, '2025-12-31', NULL, N'Hết hiệu lực'),
(N'ST003', N'KH005', N'Silver',   '2025-02-20', '2025-06-30',  90,  10,  1800000, '2025-12-31', NULL, N'Hết hiệu lực'),
(N'ST004', N'KH007', N'Gold',     '2025-03-01', '2025-07-19', 410, 120,  9800000, '2025-12-31', NULL, N'Hết hiệu lực'),
(N'ST005', N'KH009', N'Silver',   '2025-03-18', '2025-08-04', 150,  20,  3000000, '2025-12-31', NULL, N'Hết hiệu lực'),
(N'ST006', N'KH015', N'Silver',   '2025-04-02', '2025-08-21', 110,  15,  2100000, '2025-12-31', NULL, N'Hết hiệu lực'),
(N'ST007', N'KH017', N'Gold',     '2025-04-25', '2025-08-31', 500, 160, 12000000, '2025-12-31', NULL, N'Hết hiệu lực'),
(N'ST008', N'KH019', N'Silver',   '2025-05-10', '2025-09-14',  70,   5,  1500000, '2025-12-31', NULL, N'Hết hiệu lực'),
-- Các thẻ mới/đang dùng: Hoạt động
(N'ST009', N'KH002', N'Gold',     '2025-06-01', NULL, 220,  40,  5200000, '2025-12-31', N'Nâng hạng giữa năm', N'Hoạt động'),
(N'ST010', N'KH003', N'Platinum', '2025-06-15', NULL, 900, 200, 25000000, '2025-12-31', NULL, N'Hoạt động'),

(N'ST011', N'KH005', N'Gold',     '2025-07-01', NULL, 260,  60,  6500000, '2025-12-31', NULL, N'Hoạt động'),
(N'ST012', N'KH007', N'Platinum', '2025-07-20', NULL, 1200,300, 32000000, '2025-12-31', NULL, N'Hoạt động'),
(N'ST013', N'KH009', N'Gold',     '2025-08-05', NULL, 330,  90,  8700000, '2025-12-31', NULL, N'Hoạt động'),
(N'ST014', N'KH015', N'Gold',     '2025-08-22', NULL, 290,  70,  7300000, '2025-12-31', NULL, N'Hoạt động'),
(N'ST015', N'KH017', N'Platinum', '2025-09-01', NULL, 1500,400, 40000000, '2025-12-31', NULL, N'Hoạt động'),
(N'ST016', N'KH019', N'Gold',     '2025-09-15', NULL, 310,  60,  7800000, '2025-12-31', NULL, N'Hoạt động'),
(N'ST017', N'KH020', N'Silver',   '2025-10-01', NULL,  60,   0,  1200000, '2025-12-31', NULL, N'Hoạt động'),
(N'ST018', N'KH018', N'Silver',   '2025-10-10', NULL,  85,  10,  1700000, '2025-12-31', NULL, N'Hoạt động'),
(N'ST019', N'KH016', N'Silver',   '2025-10-18', NULL,  95,  20,  1900000, '2025-12-31', NULL, N'Hoạt động'),
(N'ST020', N'KH014', N'Silver',   '2025-11-01', NULL,  40,   0,   800000, '2025-12-31', N'Nhân sự nội bộ', N'Hoạt động');
GO

INSERT INTO NganHang (SoTKNH, MaKH, TenNH, ChuTK, QuocGia) VALUES
(N'NH001', N'KH002', N'Vietcombank',        N'TRAN THU HA',        N'VIET NAM'),
(N'NH002', N'KH003', N'BIDV',               N'LE QUOC BAO',        N'VIET NAM'),
(N'NH003', N'KH005', N'ACB',                N'VO THANH DAT',      N'VIET NAM'),
(N'NH004', N'KH007', N'Techcombank',        N'DANG MY LINH',      N'VIET NAM'),
(N'NH005', N'KH009', N'VPBank',             N'PHAN GIA HAN',      N'VIET NAM'),
(N'NH006', N'KH015', N'MB Bank',            N'NGO THAO VY',       N'VIET NAM'),
(N'NH007', N'KH017', N'Sacombank',          N'TA MINH KHOI',      N'VIET NAM'),
(N'NH008', N'KH019', N'HSBC',               N'NGUYEN HAI YEN',    N'VIET NAM'),
(N'NH009', N'KH011', N'VietinBank',         N'CTY ABC FOODS',     N'VIET NAM'),
(N'NH010', N'KH012', N'Standard Chartered', N'CTY GREEN OFFICE', N'VIET NAM');
GO

INSERT INTO PhieuDatHang
(MaPhieuDH, MaKH, SoThe, MaNV, NgayDatHang, HinhThucThanhToan, NgayTT, DiaChiGiao, GhiChuDatHang, KhuyenMai, TriGiaDH)
VALUES
(N'PDH001', N'KH002', N'ST009', N'NV001', '2025-11-01 08:15:00', N'QR',  '2025-11-01 08:16:00', N'Q3, TP.HCM', NULL, 0,    102000),
(N'PDH002', N'KH003', N'ST010', N'NV002', '2025-11-01 09:05:00', N'Thẻ', '2025-11-01 09:06:00', N'Q7, TP.HCM', NULL, 5000, 145000),
(N'PDH003', N'KH005', N'ST011', N'NV003', '2025-11-02 10:20:00', N'Tiền mặt', '2025-11-02 10:25:00', N'Q5, TP.HCM', NULL, 0,  78000),
(N'PDH004', N'KH007', N'ST012', N'NV004', '2025-11-02 14:40:00', N'QR',  '2025-11-02 14:41:00', N'Bình Thạnh', NULL, 10000, 210000),
(N'PDH005', N'KH009', N'ST013', N'NV005', '2025-11-03 16:10:00', N'QR',  '2025-11-03 16:12:00', N'Tân Phú',    NULL, 0,   96000),
(N'PDH006', N'KH015', N'ST014', N'NV001', '2025-11-04 08:30:00', N'Thẻ', '2025-11-04 08:31:00', N'Q6, TP.HCM', NULL, 0,   125000),
(N'PDH007', N'KH017', N'ST015', N'NV002', '2025-11-04 12:00:00', N'QR',  '2025-11-04 12:02:00', N'Q11, TP.HCM', NULL, 12000, 198000),
(N'PDH008', N'KH019', N'ST016', N'NV003', '2025-11-05 18:20:00', N'Tiền mặt', '2025-11-05 18:25:00', N'Phú Nhuận', NULL, 0,  69000),
(N'PDH009', NULL,     NULL,     N'NV004', '2025-11-06 19:10:00', N'QR',  '2025-11-06 19:11:00', N'Giao nhanh', N'Khách vãng lai', 0,  88000),
(N'PDH010', NULL,     NULL,     N'NV005', '2025-11-06 20:05:00', N'Tiền mặt', '2025-11-06 20:10:00', NULL, N'Mang đi', 0,  56000),
(N'PDH011', N'KH020', N'ST017', N'NV001', '2025-11-07 07:50:00', N'QR',  '2025-11-07 07:51:00', N'Tân Bình', NULL, 0,  74000),
(N'PDH012', N'KH018', N'ST018', N'NV002', '2025-11-07 09:25:00', N'Thẻ', '2025-11-07 09:26:00', N'Q12, TP.HCM', NULL, 5000, 132000),
(N'PDH013', N'KH016', N'ST019', N'NV003', '2025-11-08 11:30:00', N'QR',  '2025-11-08 11:32:00', N'Q8, TP.HCM', NULL, 0,  99000),
(N'PDH014', N'KH014', N'ST020', N'NV004', '2025-11-09 15:15:00', N'Nội bộ', '2025-11-09 15:16:00', N'Văn phòng', N'Đơn nội bộ', 0,  45000),
(N'PDH015', N'KH011', NULL,     N'NV005', '2025-11-10 10:10:00', N'Chuyển khoản', '2025-11-10 10:20:00', N'Q1, TP.HCM', N'Đơn công ty', 0,  520000),
(N'PDH016', N'KH012', NULL,     N'NV001', '2025-11-10 16:45:00', N'Chuyển khoản', '2025-11-10 16:55:00', N'Q2, TP.HCM', N'Đơn công ty', 0,  410000),
(N'PDH017', N'KH002', N'ST009', N'NV002', '2025-11-11 13:00:00', N'QR',  '2025-11-11 13:02:00', N'Q3, TP.HCM', NULL, 8000, 175000),
(N'PDH018', N'KH003', N'ST010', N'NV003', '2025-11-12 17:35:00', N'Thẻ', '2025-11-12 17:36:00', N'Q7, TP.HCM', NULL, 0,  230000),
(N'PDH019', N'KH009', N'ST013', N'NV004', '2025-11-13 19:40:00', N'QR',  '2025-11-13 19:41:00', N'Tân Phú', NULL, 10000, 205000),
(N'PDH020', N'KH015', N'ST014', N'NV005', '2025-11-14 08:10:00', N'QR',  '2025-11-14 08:11:00', N'Q6, TP.HCM', NULL, 0,  118000);
GO
INSERT INTO CTPhieuDatHang (MaPhieuDH, MaSP, SoLuongDH, DonGiaDH, ThanhTienDH) VALUES
(N'PDH001', N'SP011', 1, 31000, 31000),
(N'PDH001', N'SP018', 1, 71000, 71000),
(N'PDH002', N'SP001', 2, 34000, 68000),
(N'PDH002', N'SP018', 1, 77000, 77000),
(N'PDH003', N'SP012', 1, 32000, 32000),
(N'PDH003', N'SP010', 1, 32000, 32000),
(N'PDH003', N'SP023', 1, 14000, 14000),
(N'PDH004', N'SP002', 2, 37000, 74000),
(N'PDH004', N'SP005', 2, 34000, 68000),
(N'PDH004', N'SP018', 1, 68000, 68000),
(N'PDH005', N'SP006', 1, 35000, 35000),
(N'PDH005', N'SP007', 1, 36000, 36000),
(N'PDH005', N'SP022', 1, 25000, 25000),
(N'PDH006', N'SP013', 1, 37000, 37000),
(N'PDH006', N'SP014', 1, 88000, 88000),
(N'PDH007', N'SP003', 2, 41000, 82000),
(N'PDH007', N'SP021', 1, 116000, 116000),
(N'PDH008', N'SP010', 1, 32000, 32000),
(N'PDH008', N'SP015', 1, 37000, 37000),
(N'PDH009', N'SP001', 1, 34000, 34000),
(N'PDH009', N'SP018', 1, 54000, 54000),
(N'PDH010', N'SP012', 1, 32000, 32000),
(N'PDH010', N'SP023', 1, 24000, 24000),
(N'PDH011', N'SP011', 1, 31000, 31000),
(N'PDH012', N'SP005', 2, 34000, 68000),
(N'PDH012', N'SP021', 1, 64000, 64000),
(N'PDH013', N'SP006', 1, 35000, 35000),
(N'PDH013', N'SP018', 1, 64000, 64000),
(N'PDH014', N'SP010', 1, 32000, 32000),
(N'PDH014', N'SP023', 1, 13000, 13000),
(N'PDH015', N'SP001', 5, 34000, 170000),
(N'PDH015', N'SP005', 5, 34000, 170000),
(N'PDH015', N'SP018', 3, 60000, 180000),
(N'PDH016', N'SP002', 4, 37000, 148000),
(N'PDH016', N'SP006', 4, 35000, 140000),
(N'PDH016', N'SP018', 2, 61000, 122000),
(N'PDH017', N'SP009', 2, 40000, 80000),
(N'PDH017', N'SP021', 1, 95000, 95000),
(N'PDH018', N'SP003', 2, 41000, 82000),
(N'PDH018', N'SP018', 1, 148000, 148000),
(N'PDH019', N'SP007', 2, 36000, 72000),
(N'PDH019', N'SP008', 2, 36000, 72000),
(N'PDH019', N'SP018', 1, 61000, 61000),
(N'PDH020', N'SP011', 1, 31000, 31000),
(N'PDH020', N'SP018', 1, 87000, 87000);
GO

GO
INSERT INTO HoaDon
(SoHD, MaPhieuDH, MaKH, SoThe, MaNV, NgayLapHD, MaSoThue, TriGiaTruocThue, TriGiaSauThue, PhuongThucTT, TrangThaiHD)
VALUES
(N'HD001', N'PDH001', N'KH002', N'ST009', N'NV001', '2025-11-01', NULL, 102000, 102000, N'QR', N'Đã thanh toán'),
(N'HD002', N'PDH002', N'KH003', N'ST010', N'NV002', '2025-11-01', NULL, 145000, 145000, N'Thẻ', N'Đã thanh toán'),
(N'HD003', N'PDH003', N'KH005', N'ST011', N'NV003', '2025-11-02', NULL,  78000,  78000, N'Tiền mặt', N'Đã thanh toán'),
(N'HD004', N'PDH004', N'KH007', N'ST012', N'NV004', '2025-11-02', NULL, 210000, 210000, N'QR', N'Đã thanh toán'),
(N'HD005', N'PDH005', N'KH009', N'ST013', N'NV005', '2025-11-03', NULL,  96000,  96000, N'QR', N'Đã thanh toán'),
(N'HD006', N'PDH006', N'KH015', N'ST014', N'NV001', '2025-11-04', NULL, 125000, 125000, N'Thẻ', N'Đã thanh toán'),
(N'HD007', N'PDH007', N'KH017', N'ST015', N'NV002', '2025-11-04', NULL, 198000, 198000, N'QR', N'Đã thanh toán'),
(N'HD008', N'PDH008', N'KH019', N'ST016', N'NV003', '2025-11-05', NULL,  69000,  69000, N'Tiền mặt', N'Đã thanh toán'),
(N'HD009', N'PDH009', NULL,     NULL,     N'NV004', '2025-11-06', NULL,  88000,  88000, N'QR', N'Đã thanh toán'),
(N'HD010', N'PDH010', NULL,     NULL,     N'NV005', '2025-11-06', NULL,  56000,  56000, N'Tiền mặt', N'Đã thanh toán'),
(N'HD011', N'PDH011', N'KH020', N'ST017', N'NV001', '2025-11-07', NULL,  74000,  74000, N'QR', N'Đã thanh toán'),
(N'HD012', N'PDH012', N'KH018', N'ST018', N'NV002', '2025-11-07', NULL, 132000, 132000, N'Thẻ', N'Đã thanh toán'),
(N'HD013', N'PDH013', N'KH016', N'ST019', N'NV003', '2025-11-08', NULL,  99000,  99000, N'QR', N'Đã thanh toán'),
(N'HD014', N'PDH014', N'KH014', N'ST020', N'NV004', '2025-11-09', NULL,  45000,  45000, N'Nội bộ', N'Đã thanh toán'),
(N'HD015', N'PDH015', N'KH011', NULL,     N'NV005', '2025-11-10', N'0312345678', 520000, 520000, N'Chuyển khoản', N'Đã thanh toán'),
(N'HD016', N'PDH016', N'KH012', NULL,     N'NV001', '2025-11-10', N'0312349999', 410000, 410000, N'Chuyển khoản', N'Đã thanh toán'),
(N'HD017', N'PDH017', N'KH002', N'ST009', N'NV002', '2025-11-11', NULL, 175000, 175000, N'QR', N'Đã thanh toán'),
(N'HD018', N'PDH018', N'KH003', N'ST010', N'NV003', '2025-11-12', NULL, 230000, 230000, N'Thẻ', N'Đã thanh toán'),
(N'HD019', N'PDH019', N'KH009', N'ST013', N'NV004', '2025-11-13', NULL, 205000, 205000, N'QR', N'Đã thanh toán'),
(N'HD020', N'PDH020', N'KH015', N'ST014', N'NV005', '2025-11-14', NULL, 118000, 118000, N'QR', N'Đã thanh toán');
GO
INSERT INTO CTHoaDon (SoHD, MaSP, SoLuongHD, DonGiaHD, ThanhTienHD) VALUES
(N'HD001', N'SP011', 1, 31000, 31000), (N'HD001', N'SP018', 1, 71000, 71000),
(N'HD002', N'SP001', 2, 34000, 68000), (N'HD002', N'SP018', 1, 77000, 77000),
(N'HD003', N'SP012', 1, 32000, 32000),
(N'HD003', N'SP010', 1, 32000, 32000), (N'HD003', N'SP023', 1, 14000, 14000),
(N'HD004', N'SP002', 2, 37000, 74000),
(N'HD004', N'SP005', 2, 34000, 68000), (N'HD004', N'SP018', 1, 68000, 68000),
(N'HD005', N'SP006', 1, 35000, 35000),
(N'HD005', N'SP007', 1, 36000, 36000), (N'HD005', N'SP022', 1, 25000, 25000),
(N'HD006', N'SP013', 1, 37000, 37000), (N'HD006', N'SP014', 1, 88000, 88000),
(N'HD007', N'SP003', 2, 41000, 82000), (N'HD007', N'SP021', 1, 116000, 116000),
(N'HD008', N'SP010', 1, 32000, 32000), (N'HD008', N'SP015', 1, 37000, 37000),
(N'HD009', N'SP001', 1, 34000, 34000), (N'HD009', N'SP018', 1, 54000, 54000),
(N'HD010', N'SP012', 1, 32000, 32000), (N'HD010', N'SP023', 1, 24000, 24000),
(N'HD011', N'SP011', 1, 31000, 31000), (N'HD011', N'SP022', 1, 43000, 43000),
(N'HD012', N'SP005', 2, 34000, 68000), (N'HD012', N'SP021', 1, 64000, 64000),
(N'HD013', N'SP006', 1, 35000, 35000), (N'HD013', N'SP018', 1, 64000, 64000),
(N'HD014', N'SP010', 1, 32000, 32000), (N'HD014', N'SP023', 1, 13000, 13000),
(N'HD015', N'SP001', 5, 34000, 170000), (N'HD015', N'SP005', 5, 34000, 170000),
(N'HD015', N'SP018', 3, 60000, 180000),
(N'HD016', N'SP002', 4, 37000, 148000),
(N'HD016', N'SP006', 4, 35000, 140000), 
(N'HD016', N'SP018', 2, 61000, 122000),
(N'HD017', N'SP009', 2, 40000, 80000), (N'HD017', N'SP021', 1, 95000, 95000),
(N'HD018', N'SP003', 2, 41000, 82000),
(N'HD018', N'SP018', 1, 148000, 148000), 
(N'HD019', N'SP007', 2, 36000, 72000),
(N'HD019', N'SP008', 2, 36000, 72000), (N'HD019', N'SP018', 1, 61000, 61000),
(N'HD020', N'SP011', 1, 31000, 31000), (N'HD020', N'SP018', 1, 87000, 87000);
GO

INSERT INTO PhieuXuat (MaPX, MaKho, SoHD, NgayLapPX, TriGiaPX) VALUES
(N'PX001', N'KHO01', N'HD001', '2025-11-01', 102000),
(N'PX002', N'KHO01', N'HD002', '2025-11-01', 145000),
(N'PX003', N'KHO02', N'HD003', '2025-11-02', 78000),
(N'PX004', N'KHO02', N'HD004', '2025-11-02', 210000),
(N'PX005', N'KHO03', N'HD005', '2025-11-03', 96000),
(N'PX006', N'KHO01', N'HD006', '2025-11-04', 125000),
(N'PX007', N'KHO03', N'HD007', '2025-11-04', 198000),
(N'PX008', N'KHO04', N'HD008', '2025-11-05', 69000),
(N'PX009', N'KHO04', N'HD009', '2025-11-06', 88000),
(N'PX010', N'KHO04', N'HD010', '2025-11-06', 56000),
(N'PX011', N'KHO02', N'HD011', '2025-11-07', 74000),
(N'PX012', N'KHO02', N'HD012', '2025-11-07', 132000),
(N'PX013', N'KHO05', N'HD013', '2025-11-08', 99000),
(N'PX014', N'KHO05', N'HD018', '2025-11-12', 230000),
(N'PX015', N'KHO03', N'HD020', '2025-11-14', 118000);
GO

INSERT INTO CTPX (MaPX, MaSP, SoLuongXuat, DonGiaXuat, ThanhTienPX) VALUES
(N'PX001', N'SP011', 1, 31000, 31000), (N'PX001', N'SP018', 1, 71000, 71000),
(N'PX002', N'SP001', 2, 34000, 68000), (N'PX002', N'SP018', 1, 77000, 77000),
(N'PX003', N'SP012', 1, 32000, 32000), (N'PX003', N'SP010', 1, 32000, 32000),
(N'PX003', N'SP023', 1, 14000, 14000), (N'PX004', N'SP002', 2, 37000, 74000),
(N'PX004', N'SP005', 2, 34000, 68000), (N'PX004', N'SP018', 1, 68000, 68000), 
(N'PX005', N'SP006', 1, 35000, 35000), (N'PX005', N'SP007', 1, 36000, 36000),
(N'PX005', N'SP022', 1, 25000, 25000),
(N'PX006', N'SP013', 1, 37000, 37000), (N'PX006', N'SP014', 1, 88000, 88000),
(N'PX007', N'SP003', 2, 41000, 82000), (N'PX007', N'SP021', 1, 116000, 116000),
(N'PX008', N'SP010', 1, 32000, 32000), (N'PX008', N'SP015', 1, 37000, 37000),
(N'PX009', N'SP001', 1, 34000, 34000), (N'PX009', N'SP018', 1, 54000, 54000),
(N'PX010', N'SP012', 1, 32000, 32000), (N'PX010', N'SP023', 1, 24000, 24000),
(N'PX011', N'SP011', 1, 31000, 31000), (N'PX011', N'SP022', 1, 43000, 43000),
(N'PX012', N'SP005', 2, 34000, 68000), (N'PX012', N'SP021', 1, 64000, 64000),
(N'PX013', N'SP006', 1, 35000, 35000), (N'PX013', N'SP018', 1, 64000, 64000),
(N'PX014', N'SP003', 2, 41000, 82000), (N'PX014', N'SP018', 1, 148000, 148000),
(N'PX015', N'SP011', 1, 31000, 31000), (N'PX015', N'SP018', 1, 87000, 87000);
GO

INSERT INTO PhieuGiaoHang
(MaPGH, MaPhieuDH, SoHD, NgayGiao, DiaChiGiaoHang, NguoiNhan, SDTNhan, PhiShip, HinhThucGiao, TrangThaiGiao)
VALUES
(N'PGH001', N'PDH001', N'HD001', '2025-11-01', N'Q3, TP.HCM', N'Nguyễn An',  '0901000001', 15000, N'Giao nhanh', N'Đã giao'),
(N'PGH002', N'PDH002', N'HD002', '2025-11-01', N'Q7, TP.HCM', N'Trần Bình',  '0901000002', 18000, N'Giao tiêu chuẩn', N'Đã giao'),
(N'PGH003', N'PDH004', N'HD004', '2025-11-02', N'Bình Thạnh', N'Lê Chi',     '0901000003', 20000, N'Giao nhanh', N'Đã giao'),
(N'PGH004', N'PDH005', N'HD005', '2025-11-03', N'Tân Phú',    N'Phạm Duy',   '0901000004', 17000, N'Giao tiêu chuẩn', N'Đã giao'),
(N'PGH005', N'PDH006', N'HD006', '2025-11-04', N'Q6, TP.HCM', N'Võ Em',      '0901000005', 15000, N'Giao nhanh', N'Đã giao'),
(N'PGH006', N'PDH007', N'HD007', '2025-11-04', N'Q11, TP.HCM',N'Đặng Giang', '0901000006', 22000, N'Giao nhanh', N'Đã giao'),
(N'PGH007', N'PDH008', N'HD008', '2025-11-05', N'Phú Nhuận',  N'Hoàng Hạnh', '0901000007', 16000, N'Giao tiêu chuẩn', N'Đã giao'),
(N'PGH008', N'PDH011', N'HD011', '2025-11-07', N'Tân Bình',   N'Bùi Khang',  '0901000008', 15000, N'Giao nhanh', N'Đã giao'),
(N'PGH009', N'PDH012', N'HD012', '2025-11-07', N'Q12, TP.HCM',N'Ngô Lan',    '0901000009', 18000, N'Giao tiêu chuẩn', N'Đã giao'),
(N'PGH010', N'PDH013', N'HD013', '2025-11-08', N'Q8, TP.HCM', N'Tạ Minh',    '0901000010', 17000, N'Giao nhanh', N'Đã giao'),
(N'PGH011', N'PDH018', N'HD018', '2025-11-12', N'Q7, TP.HCM', N'Phan Ngọc',  '0901000011', 20000, N'Giao nhanh', N'Đã giao'),
(N'PGH012', N'PDH020', N'HD020', '2025-11-14', N'Q6, TP.HCM', N'Đỗ Oanh',    '0901000012', 15000, N'Giao tiêu chuẩn', N'Đã giao');
GO
INSERT INTO CTPhieuGiaoHang (MaPGH, MaSP, SoLuongGiao, GhiChuPGH) VALUES
-- PGH001 - PDH001
(N'PGH001', N'SP011', 1, NULL), (N'PGH001', N'SP018', 1, NULL),
-- PGH002 - PDH002
(N'PGH002', N'SP001', 2, NULL), (N'PGH002', N'SP018', 1, NULL),
-- PGH003 - PDH004
(N'PGH003', N'SP002', 2, NULL), (N'PGH003', N'SP005', 2, NULL),
(N'PGH003', N'SP018', 1, NULL),
-- PGH004 - PDH005
(N'PGH004', N'SP006', 1, NULL), (N'PGH004', N'SP007', 1, NULL),
(N'PGH004', N'SP022', 1, NULL),
-- PGH005 - PDH006
(N'PGH005', N'SP013', 1, NULL), (N'PGH005', N'SP014', 1, NULL),
-- PGH006 - PDH007
(N'PGH006', N'SP003', 2, NULL), (N'PGH006', N'SP021', 1, NULL),
-- PGH007 - PDH008
(N'PGH007', N'SP010', 1, NULL), (N'PGH007', N'SP015', 1, NULL),
-- PGH008 - PDH011
(N'PGH008', N'SP011', 1, NULL),
-- PGH009 - PDH012
(N'PGH009', N'SP005', 2, NULL),
(N'PGH009', N'SP021', 1, NULL),
-- PGH010 - PDH013
(N'PGH010', N'SP006', 1, NULL), (N'PGH010', N'SP018', 1, NULL),
-- PGH011 - PDH018
(N'PGH011', N'SP003', 2, NULL), (N'PGH011', N'SP018', 1, NULL),
-- PGH012 - PDH020
(N'PGH012', N'SP011', 1, NULL), (N'PGH012', N'SP018', 1, NULL);
GO
INSERT INTO QuyDinhNghiepVu (MaQD, TenQD, NoiDungQD, LoaiQuyTrinh, DoiTuongApDung, CaApDung, NgayHieuLuc, TrangThaiQD, GhiChuQD)
VALUES
-- 1. Ca sáng
(N'QD001', N'Ca sáng cửa hàng', N'Ca sáng làm việc từ 06:30 đến 14:30. Nhân viên phải có mặt trước giờ vào ca tối thiểu 15 phút để chuẩn bị quầy, kiểm tra nguyên liệu và đồng phục.',
 N'Ca làm việc', N'Nhân viên bán hàng, Thu ngân, Barista', N'Ca sáng', '2025-01-01', N'Đang áp dụng', NULL),
-- 2. Ca chiều
(N'QD002', N'Ca chiều cửa hàng', N'Ca chiều làm việc từ 14:00 đến 22:00. Nhân viên ca chiều có trách nhiệm dọn dẹp, kiểm kê và bàn giao cho quản lý sau khi đóng quầy.',
 N'Ca làm việc', N'Nhân viên bán hàng, Thu ngân, Barista', N'Ca chiều', '2025-01-01', N'Đang áp dụng', NULL),
-- 3. Ca part-time
(N'QD003', N'Ca làm việc bán thời gian', N'Mỗi ca part-time tối thiểu 4 giờ liên tục. Sắp ca phải đảm bảo không trùng với giờ cao điểm mà thiếu nhân sự (11:00–13:00 và 19:00–21:00).',
 N'Ca làm việc', N'Nhân viên part-time', N'Ca linh hoạt', '2025-01-01', N'Đang áp dụng', NULL),
-- 4. Nghỉ giữa ca
(N'QD004', N'Thời gian nghỉ giữa ca', N'Nhân viên làm ca đủ 8 giờ được nghỉ 30 phút giữa ca, sắp xếp luân phiên để không ảnh hưởng phục vụ khách.',
 N'Ca làm việc', N'Tất cả nhân viên cửa hàng', N'Ca sáng, Ca chiều', '2025-01-01', N'Đang áp dụng', NULL),
-- 5. Chốt đơn giao trong ngày
(N'QD005', N'Thời hạn chốt đơn giao trong ngày', N'Các đơn đặt giao hàng trong ngày phải được xác nhận trước 20:00. Đơn xác nhận sau 20:00 sẽ được chuyển sang giao ngày hôm sau.',
 N'Bán hàng & Giao hàng', N'Nhân viên bán hàng online, Thu ngân', N'Toàn bộ ca', '2025-01-01', N'Đang áp dụng', NULL),
-- 6. Quy trình mở ca
(N'QD006', N'Quy trình mở ca thu ngân', N'Trước khi mở ca, thu ngân phải kiểm kê tiền quỹ đầu ca, kiểm tra máy POS, máy in hóa đơn và báo cáo ngay cho quản lý nếu có chênh lệch.',
 N'Bán hàng tại quầy', N'Thu ngân', N'Ca sáng, Ca chiều', '2025-01-01', N'Đang áp dụng', NULL),
-- 7. Quy trình đóng ca
(N'QD007', N'Quy trình đóng ca cuối ngày', N'Sau khi kết thúc ca cuối cùng, thu ngân và quản lý đối chiếu tổng doanh thu trên hệ thống với tiền mặt, kiểm tra hóa đơn hủy, note rõ nguyên nhân chênh lệch (nếu có).',
 N'Bán hàng tại quầy', N'Thu ngân, Quản lý cửa hàng', N'Ca chiều', '2025-01-01', N'Đang áp dụng', NULL),
-- 8. Xử lý khiếu nại khách hàng
(N'QD008', N'Thời gian xử lý khiếu nại khách hàng', N'Mọi phản ánh của khách hàng phải được tiếp nhận và phản hồi ban đầu trong vòng 24 giờ, xử lý dứt điểm chậm nhất 03 ngày làm việc.',
 N'Chăm sóc khách hàng', N'CSKH, Quản lý cửa hàng', N'Toàn bộ ca', '2025-01-01', N'Đang áp dụng', NULL),
-- 9. Sử dụng thẻ thành viên khi thanh toán
(N'QD009', N'Quy định sử dụng thẻ thành viên', N'Khách hàng phải xuất trình thẻ thành viên hoặc cung cấp số điện thoại tích điểm trước khi thu ngân hoàn tất hóa đơn thanh toán.',
 N'Chương trình thành viên', N'Thu ngân, Nhân viên bán hàng', N'Toàn bộ ca', '2025-01-01', N'Đang áp dụng', NULL),
 -- 10. Đào tạo nhân viên mới
(N'QD010', N'Đào tạo nhân viên mới', N'Nhân viên mới phải trải qua tối thiểu 03 ca đào tạo kèm cặp (on-job training) trước khi được phân công đứng quầy độc lập.',
 N'Nhân sự & Đào tạo', N'Nhân viên mới, Quản lý cửa hàng', N'Toàn bộ ca','2025-01-01', N'Đang áp dụng', N'Áp dụng cho cả full-time và part-time.');
GO

GO

INSERT INTO VaiTroHeThong (MaVT, TenVT) VALUES
(N'VT001', N'Quản trị hệ thống'),
(N'VT002', N'Quản lý chi nhánh'),
(N'VT003', N'Thu ngân'),
(N'VT004', N'Nhân viên bán hàng'),
(N'VT005', N'Chăm sóc khách hàng'),
(N'VT006', N'Nhân viên kho'),
(N'VT007', N'Marketing'),
(N'VT008', N'Kế toán nội bộ');
GO

INSERT INTO TaiKhoanNV (MaTK, MaNV, MaVT, TenDangNhap, MatKhau) VALUES
-- VT001 - Quản trị hệ thống
('TK001', 'NV001', N'VT001', 'pl_admin_01',     'PL@2025_AD'),
-- VT002 - Quản lý chi nhánh
('TK002', 'NV002', N'VT002', 'pl_qlcn_01',      'PL@2025_MN1'),
('TK003', 'NV003', N'VT002', 'pl_qlcn_02',      'PL@2025_MN2'),
-- VT003 - Thu ngân
('TK005', 'NV005', N'VT003', 'pl_thungan_01',  'PL@2025_CA1'),
('TK006', 'NV006', N'VT003', 'pl_thungan_02',  'PL@2025_CA2'),
('TK019', 'NV019', N'VT003', 'pl_thungan_03',  'PL@2025_CA3'),
-- VT004 - Nhân viên bán hàng
('TK004', 'NV004', N'VT004', 'pl_sales_ql_01', 'PL@2025_SM1'),
('TK007', 'NV007', N'VT004', 'pl_sales_01',    'PL@2025_S1'),
('TK008', 'NV008', N'VT004', 'pl_sales_02',    'PL@2025_S2'),
('TK009', 'NV009', N'VT004', 'pl_sales_03',    'PL@2025_S3'),
('TK018', 'NV018', N'VT004', 'pl_sales_04',    'PL@2025_S4'),
-- VT005 - Chăm sóc khách hàng
('TK010', 'NV010', N'VT005', 'pl_cskh_01',     'PL@2025_CS1'),
('TK011', 'NV011', N'VT005', 'pl_cskh_02',     'PL@2025_CS2'),
-- VT006 - Nhân viên kho
('TK012', 'NV012', N'VT006', 'pl_kho_hcm_01',  'PL@2025_KH1'),
('TK013', 'NV013', N'VT006', 'pl_kho_hn_01',   'PL@2025_KH2'),
('TK014', 'NV014', N'VT006', 'pl_qlkho_01',    'PL@2025_KHM'),
('TK020', 'NV020', N'VT006', 'pl_kho_dn_01',   'PL@2025_KH3'),
-- VT007 - Marketing
('TK015', 'NV015', N'VT007', 'pl_mkt_01',      'PL@2025_MK1'),
('TK016', 'NV016', N'VT007', 'pl_mkt_02',      'PL@2025_MK2'),
-- VT008 - Kế toán nội bộ
('TK017', 'NV017', N'VT008', 'pl_ketoan_01',   'PL@2025_AC1');
GO

INSERT INTO LoaiDoiTuong (MaLDT, TenLDT) VALUES
(N'LDT01', N'Hệ thống - nhân sự'),
(N'LDT02', N'Danh mục sản phẩm'),
(N'LDT03', N'Kho - tồn'),
(N'LDT04', N'Bán hàng'),
(N'LDT05', N'Khách hàng - thành viên'),
(N'LDT06', N'Khuyến mãi');
GO

INSERT INTO DoiTuong (MaDT, MaLDT, TenDT) VALUES
-- Hệ thống - nhân sự
(N'DT001', N'LDT01', N'ChiNhanh'),
(N'DT002', N'LDT01', N'PhongBan'),
(N'DT003', N'LDT01', N'ChucVu'),
(N'DT004', N'LDT01', N'NhanVien'),
(N'DT005', N'LDT01', N'VaiTroHeThong'),
(N'DT006', N'LDT01', N'TaiKhoanNV'),
(N'DT007', N'LDT01', N'PhanQuyen'),
-- Danh mục sản phẩm
(N'DT101', N'LDT02', N'DonViTinh'),
(N'DT102', N'LDT02', N'NhomSP'),
(N'DT103', N'LDT02', N'LoaiSP'),
(N'DT104', N'LDT02', N'SanPham'),
(N'DT105', N'LDT02', N'BienDongGia'),
-- Kho - tồn
(N'DT201', N'LDT03', N'Kho'),
(N'DT202', N'LDT03', N'TonKho'),
(N'DT203', N'LDT03', N'PhieuXuat'),
(N'DT204', N'LDT03', N'CTPX'),
-- Bán hàng
(N'DT301', N'LDT04', N'PhieuDatHang'),
(N'DT302', N'LDT04', N'CTPhieuDatHang'),
(N'DT303', N'LDT04', N'HoaDon'),
(N'DT304', N'LDT04', N'CTHoaDon'),
(N'DT305', N'LDT04', N'PhieuGiaoHang'),
(N'DT306', N'LDT04', N'CTPhieuGiaoHang'),
-- Khách hàng - thành viên
(N'DT401', N'LDT05', N'LoaiKH'),
(N'DT402', N'LDT05', N'KhachHang'),
(N'DT403', N'LDT05', N'TheThanhVien'),
(N'DT404', N'LDT05', N'NganHang'),
-- Khuyến mãi
(N'DT501', N'LDT06', N'CTKhuyenMai'),
(N'DT502', N'LDT06', N'CTChuongTrinhKM');
GO

GO
INSERT INTO LoaiQuyen (MaLQ, LoaiQuyen) VALUES
(N'LQ001', N'Quyền xem'),
(N'LQ002', N'Quyền thêm'),
(N'LQ003', N'Quyền sửa'),
(N'LQ004', N'Quyền xóa'),
(N'LQ005', N'Quyền duyệt'),
(N'LQ006', N'Quyền báo cáo');
GO

---TẠO QUYỀN CỤ THỂ THEO ĐỐI TƯỢNG

;WITH Verb AS (
    SELECT 
        MaLQ,
        Verb = CASE MaLQ
            WHEN 'LQ001' THEN N'Xem'
            WHEN 'LQ002' THEN N'Thêm'
            WHEN 'LQ003' THEN N'Sửa'
            WHEN 'LQ004' THEN N'Xóa'
            WHEN 'LQ005' THEN N'Duyệt'
            WHEN 'LQ006' THEN N'Báo cáo'
        END
    FROM LoaiQuyen
)
INSERT INTO Quyen (MaQuyen, MaLQ, TenQuyen)
SELECT
    CONCAT('Q', RIGHT(DT.MaDT, 3), RIGHT(V.MaLQ, 3)) AS MaQuyen,
    V.MaLQ,
    CONCAT(V.Verb, N' ', DT.TenDT) AS TenQuyen
FROM DoiTuong DT
CROSS JOIN Verb V
WHERE NOT EXISTS (
    SELECT 1
    FROM Quyen Q
    WHERE Q.MaQuyen = CONCAT('Q', RIGHT(DT.MaDT, 3), RIGHT(V.MaLQ, 3))
);
GO
---PHÂN QUYỀN CHO TỪNG VAI TRÒ----
/*=========================================
= VT001 - QUẢN TRỊ HỆ THỐNG: TOÀN QUYỀN
=========================================*/

;WITH AllPerm AS (
    SELECT 
        DT.MaDT,
        LQ.MaLQ,
        MaQuyen = CONCAT('Q', RIGHT(DT.MaDT, 3), RIGHT(LQ.MaLQ, 3))
    FROM DoiTuong DT
    CROSS JOIN LoaiQuyen LQ
)
INSERT INTO PhanQuyen
(MaVT, MaDT, MaQuyen, NgayCapQuyen, GhiChuPhanQuyen, TrangThaiPhanQuyen)
SELECT
    'VT001', AP.MaDT, AP.MaQuyen, '2025-11-01',
    N'Toàn quyền hệ thống', N'Hoạt động'
FROM AllPerm AP
JOIN Quyen Q ON Q.MaQuyen = AP.MaQuyen
WHERE NOT EXISTS (
    SELECT 1 FROM PhanQuyen P
    WHERE P.MaVT = 'VT001' AND P.MaDT = AP.MaDT AND P.MaQuyen = AP.MaQuyen
);
GO
DECLARE @MaVT NVARCHAR(10) = 'VT001';
SELECT 
    VT.MaVT,
    VT.TenVT,
    DT.MaDT,
    DT.TenDT,
    LQ.LoaiQuyen,
    Q.TenQuyen,
    PQ.TrangThaiPhanQuyen
FROM PhanQuyen PQ
JOIN VaiTroHeThong VT ON VT.MaVT = PQ.MaVT
JOIN DoiTuong DT ON DT.MaDT = PQ.MaDT
JOIN Quyen Q ON Q.MaQuyen = PQ.MaQuyen
JOIN LoaiQuyen LQ ON LQ.MaLQ = Q.MaLQ
WHERE PQ.MaVT = @MaVT
ORDER BY DT.MaDT, LQ.MaLQ;

GO
/*=========================================
= VT002 - QUẢN LÝ CHI NHÁNH
=========================================*/

;WITH RoleDT AS (
    SELECT MaDT FROM (VALUES
        ('DT301'), ('DT302'), ('DT303'), ('DT304'), ('DT305'), ('DT306'),
        ('DT201'), ('DT202'), ('DT203'), ('DT204'),
        ('DT401'), ('DT402'), ('DT403'), ('DT404'),
        ('DT501'), ('DT502')
    ) d(MaDT)
),
RoleLQ AS (
    SELECT MaLQ FROM (VALUES
        ('LQ001'), ('LQ002'), ('LQ003'), ('LQ005'), ('LQ006')
    ) l(MaLQ)
),
GrantList AS (
    SELECT 
        'VT002' AS MaVT,
        d.MaDT,
        l.MaLQ,
        MaQuyen = CONCAT('Q', RIGHT(d.MaDT, 3), RIGHT(l.MaLQ, 3))
    FROM RoleDT d
    CROSS JOIN RoleLQ l
)
INSERT INTO PhanQuyen
(MaVT, MaDT, MaQuyen, NgayCapQuyen, GhiChuPhanQuyen, TrangThaiPhanQuyen)
SELECT
    G.MaVT, G.MaDT, G.MaQuyen, '2025-11-01',
    N'Quyền quản lý chi nhánh', N'Hoạt động'
FROM GrantList G
JOIN Quyen Q ON Q.MaQuyen = G.MaQuyen
WHERE NOT EXISTS (
    SELECT 1 FROM PhanQuyen P
    WHERE P.MaVT = G.MaVT AND P.MaDT = G.MaDT AND P.MaQuyen = G.MaQuyen
);
GO
---Kiểm tra các quyền được phân cho vai trò 2
DECLARE @MaVT NVARCHAR(10) = 'VT002';
SELECT 
    VT.MaVT,
    VT.TenVT,
    DT.MaDT,
    DT.TenDT,
    LQ.LoaiQuyen,
    Q.TenQuyen,
    PQ.TrangThaiPhanQuyen
FROM PhanQuyen PQ
JOIN VaiTroHeThong VT ON VT.MaVT = PQ.MaVT
JOIN DoiTuong DT ON DT.MaDT = PQ.MaDT
JOIN Quyen Q ON Q.MaQuyen = PQ.MaQuyen
JOIN LoaiQuyen LQ ON LQ.MaLQ = Q.MaLQ
WHERE PQ.MaVT = @MaVT
ORDER BY DT.MaDT, LQ.MaLQ;

/*=========================================
= VT003 - THU NGÂN
=========================================*/

;WITH RoleDT AS (
    SELECT MaDT FROM (VALUES
        ('DT301'), ('DT302'), ('DT303'), ('DT304'),
        ('DT402'), ('DT403')
    ) d(MaDT)
),
RoleLQ AS (
    SELECT MaLQ FROM (VALUES ('LQ001'), ('LQ002')) l(MaLQ)
),
GrantList AS (
    SELECT 
        'VT003' AS MaVT,
        d.MaDT,
        l.MaLQ,
        MaQuyen = CONCAT('Q', RIGHT(d.MaDT, 3), RIGHT(l.MaLQ, 3))
    FROM RoleDT d
    CROSS JOIN RoleLQ l
)
INSERT INTO PhanQuyen
(MaVT, MaDT, MaQuyen, NgayCapQuyen, GhiChuPhanQuyen, TrangThaiPhanQuyen)
SELECT
    G.MaVT, G.MaDT, G.MaQuyen, '2025-11-01',
    N'Quyền thu ngân', N'Hoạt động'
FROM GrantList G
JOIN Quyen Q ON Q.MaQuyen = G.MaQuyen
WHERE NOT EXISTS (
    SELECT 1 FROM PhanQuyen P
    WHERE P.MaVT = G.MaVT AND P.MaDT = G.MaDT AND P.MaQuyen = G.MaQuyen
);
GO
DECLARE @MaVT NVARCHAR(10) = 'VT003';
SELECT 
    VT.MaVT,
    VT.TenVT,
    DT.MaDT,
    DT.TenDT,
    LQ.LoaiQuyen,
    Q.TenQuyen,
    PQ.TrangThaiPhanQuyen
FROM PhanQuyen PQ
JOIN VaiTroHeThong VT ON VT.MaVT = PQ.MaVT
JOIN DoiTuong DT ON DT.MaDT = PQ.MaDT
JOIN Quyen Q ON Q.MaQuyen = PQ.MaQuyen
JOIN LoaiQuyen LQ ON LQ.MaLQ = Q.MaLQ
WHERE PQ.MaVT = @MaVT
ORDER BY DT.MaDT, LQ.MaLQ;

GO
/*=========================================
= VT004 - NHÂN VIÊN BÁN HÀNG
=========================================*/

;WITH RoleDT AS (
    SELECT MaDT FROM (VALUES
        ('DT301'), ('DT302'),
        ('DT501'), ('DT502')
    ) d(MaDT)
),
RoleLQ AS (
    SELECT MaLQ FROM (VALUES ('LQ001'), ('LQ002')) l(MaLQ)
),
GrantList AS (
    SELECT 
        'VT004' AS MaVT,
        d.MaDT,
        l.MaLQ,
        MaQuyen = CONCAT('Q', RIGHT(d.MaDT, 3), RIGHT(l.MaLQ, 3))
    FROM RoleDT d
    CROSS JOIN RoleLQ l
)
INSERT INTO PhanQuyen
(MaVT, MaDT, MaQuyen, NgayCapQuyen, GhiChuPhanQuyen, TrangThaiPhanQuyen)
SELECT
    G.MaVT, G.MaDT, G.MaQuyen, '2025-11-01',
    N'Quyền nhân viên bán hàng', N'Hoạt động'
FROM GrantList G
JOIN Quyen Q ON Q.MaQuyen = G.MaQuyen
WHERE NOT EXISTS (
    SELECT 1 FROM PhanQuyen P
    WHERE P.MaVT = G.MaVT AND P.MaDT = G.MaDT AND P.MaQuyen = G.MaQuyen
);
GO
DECLARE @MaVT NVARCHAR(10) = 'VT004';
SELECT 
    VT.MaVT,
    VT.TenVT,
    DT.MaDT,
    DT.TenDT,
    LQ.LoaiQuyen,
    Q.TenQuyen,
    PQ.TrangThaiPhanQuyen
FROM PhanQuyen PQ
JOIN VaiTroHeThong VT ON VT.MaVT = PQ.MaVT
JOIN DoiTuong DT ON DT.MaDT = PQ.MaDT
JOIN Quyen Q ON Q.MaQuyen = PQ.MaQuyen
JOIN LoaiQuyen LQ ON LQ.MaLQ = Q.MaLQ
WHERE PQ.MaVT = @MaVT
ORDER BY DT.MaDT, LQ.MaLQ;

GO
/*=========================================
= VT005 - CHĂM SÓC KHÁCH HÀNG
=========================================*/

;WITH RoleDT AS (
    SELECT MaDT FROM (VALUES
        ('DT401'), ('DT402'), ('DT403'), ('DT404')
    ) d(MaDT)
),
RoleLQ AS (
    SELECT MaLQ FROM (VALUES ('LQ001'), ('LQ002'), ('LQ003'), ('LQ006')) l(MaLQ)
),
GrantList AS (
    SELECT 
        'VT005' AS MaVT,
        d.MaDT,
        l.MaLQ,
        MaQuyen = CONCAT('Q', RIGHT(d.MaDT, 3), RIGHT(l.MaLQ, 3))
    FROM RoleDT d
    CROSS JOIN RoleLQ l
)
INSERT INTO PhanQuyen
(MaVT, MaDT, MaQuyen, NgayCapQuyen, GhiChuPhanQuyen, TrangThaiPhanQuyen)
SELECT
    G.MaVT, G.MaDT, G.MaQuyen, '2025-11-01',
    N'Quyền CSKH', N'Hoạt động'
FROM GrantList G
JOIN Quyen Q ON Q.MaQuyen = G.MaQuyen
WHERE NOT EXISTS (
    SELECT 1 FROM PhanQuyen P
    WHERE P.MaVT = G.MaVT AND P.MaDT = G.MaDT AND P.MaQuyen = G.MaQuyen
);
GO
DECLARE @MaVT NVARCHAR(10) = 'VT005';
SELECT 
    VT.MaVT,
    VT.TenVT,
    DT.MaDT,
    DT.TenDT,
    LQ.LoaiQuyen,
    Q.TenQuyen,
    PQ.TrangThaiPhanQuyen
FROM PhanQuyen PQ
JOIN VaiTroHeThong VT ON VT.MaVT = PQ.MaVT
JOIN DoiTuong DT ON DT.MaDT = PQ.MaDT
JOIN Quyen Q ON Q.MaQuyen = PQ.MaQuyen
JOIN LoaiQuyen LQ ON LQ.MaLQ = Q.MaLQ
WHERE PQ.MaVT = @MaVT
ORDER BY DT.MaDT, LQ.MaLQ;

GO
/*=========================================
= VT006 - NHÂN VIÊN KHO
=========================================*/

;WITH RoleDT AS (
    SELECT MaDT FROM (VALUES ('DT201'), ('DT202'), ('DT203'), ('DT204')) d(MaDT)
),
RoleLQ AS (
    SELECT MaLQ FROM (VALUES ('LQ001'), ('LQ002')) l(MaLQ)
),
GrantList AS (
    SELECT 
        'VT006' AS MaVT,
        d.MaDT,
        l.MaLQ,
        MaQuyen = CONCAT('Q', RIGHT(d.MaDT, 3), RIGHT(l.MaLQ, 3))
    FROM RoleDT d
    CROSS JOIN RoleLQ l
)
INSERT INTO PhanQuyen
(MaVT, MaDT, MaQuyen, NgayCapQuyen, GhiChuPhanQuyen, TrangThaiPhanQuyen)
SELECT
    G.MaVT, G.MaDT, G.MaQuyen, '2025-11-01',
    N'Quyền nhân viên kho', N'Hoạt động'
FROM GrantList G
JOIN Quyen Q ON Q.MaQuyen = G.MaQuyen
WHERE NOT EXISTS (
    SELECT 1 FROM PhanQuyen P
    WHERE P.MaVT = G.MaVT AND P.MaDT = G.MaDT AND P.MaQuyen = G.MaQuyen
);
GO
DECLARE @MaVT NVARCHAR(10) = 'VT006';
SELECT 
    VT.MaVT,
    VT.TenVT,
    DT.MaDT,
    DT.TenDT,
    LQ.LoaiQuyen,
    Q.TenQuyen,
    PQ.TrangThaiPhanQuyen
FROM PhanQuyen PQ
JOIN VaiTroHeThong VT ON VT.MaVT = PQ.MaVT
JOIN DoiTuong DT ON DT.MaDT = PQ.MaDT
JOIN Quyen Q ON Q.MaQuyen = PQ.MaQuyen
JOIN LoaiQuyen LQ ON LQ.MaLQ = Q.MaLQ
WHERE PQ.MaVT = @MaVT
ORDER BY DT.MaDT, LQ.MaLQ;

GO
/*=========================================
= VT007 - MARKETING
=========================================*/

;WITH RoleDT AS (
    SELECT MaDT FROM (VALUES ('DT501'), ('DT502')) d(MaDT)
),
RoleLQ AS (
    SELECT MaLQ FROM (VALUES ('LQ001'), ('LQ002'), ('LQ003'), ('LQ004'), ('LQ006')) l(MaLQ)
),
GrantList AS (
    SELECT 
        'VT007' AS MaVT,
        d.MaDT,
        l.MaLQ,
        MaQuyen = CONCAT('Q', RIGHT(d.MaDT, 3), RIGHT(l.MaLQ, 3))
    FROM RoleDT d
    CROSS JOIN RoleLQ l
)
INSERT INTO PhanQuyen
(MaVT, MaDT, MaQuyen, NgayCapQuyen, GhiChuPhanQuyen, TrangThaiPhanQuyen)
SELECT
    G.MaVT, G.MaDT, G.MaQuyen, '2025-11-01',
    N'Quyền marketing', N'Hoạt động'
FROM GrantList G
JOIN Quyen Q ON Q.MaQuyen = G.MaQuyen
WHERE NOT EXISTS (
    SELECT 1 FROM PhanQuyen P
    WHERE P.MaVT = G.MaVT AND P.MaDT = G.MaDT AND P.MaQuyen = G.MaQuyen
);
GO
DECLARE @MaVT NVARCHAR(10) = 'VT007';
SELECT 
    VT.MaVT,
    VT.TenVT,
    DT.MaDT,
    DT.TenDT,
    LQ.LoaiQuyen,
    Q.TenQuyen,
    PQ.TrangThaiPhanQuyen
FROM PhanQuyen PQ
JOIN VaiTroHeThong VT ON VT.MaVT = PQ.MaVT
JOIN DoiTuong DT ON DT.MaDT = PQ.MaDT
JOIN Quyen Q ON Q.MaQuyen = PQ.MaQuyen
JOIN LoaiQuyen LQ ON LQ.MaLQ = Q.MaLQ
WHERE PQ.MaVT = @MaVT
ORDER BY DT.MaDT, LQ.MaLQ;

GO

/*=========================================
= VT008 - KẾ TOÁN
=========================================*/

;WITH RoleDT AS (
    SELECT MaDT FROM (VALUES ('DT303'), ('DT304')) d(MaDT)
),
RoleLQ AS (
    SELECT MaLQ FROM (VALUES ('LQ001'), ('LQ006')) l(MaLQ)
),
GrantList AS (
    SELECT 
        'VT008' AS MaVT,
        d.MaDT,
        l.MaLQ,
        MaQuyen = CONCAT('Q', RIGHT(d.MaDT, 3), RIGHT(l.MaLQ, 3))
    FROM RoleDT d
    CROSS JOIN RoleLQ l
)
INSERT INTO PhanQuyen
(MaVT, MaDT, MaQuyen, NgayCapQuyen, GhiChuPhanQuyen, TrangThaiPhanQuyen)
SELECT
    G.MaVT, G.MaDT, G.MaQuyen, '2025-11-01',
    N'Quyền kế toán', N'Hoạt động'
FROM GrantList G
JOIN Quyen Q ON Q.MaQuyen = G.MaQuyen
WHERE NOT EXISTS (
    SELECT 1 FROM PhanQuyen P
    WHERE P.MaVT = G.MaVT AND P.MaDT = G.MaDT AND P.MaQuyen = G.MaQuyen
);
GO
DECLARE @MaVT NVARCHAR(10) = 'VT008';
SELECT 
    VT.MaVT,
    VT.TenVT,
    DT.MaDT,
    DT.TenDT,
    LQ.LoaiQuyen,
    Q.TenQuyen,
    PQ.TrangThaiPhanQuyen
FROM PhanQuyen PQ
JOIN VaiTroHeThong VT ON VT.MaVT = PQ.MaVT
JOIN DoiTuong DT ON DT.MaDT = PQ.MaDT
JOIN Quyen Q ON Q.MaQuyen = PQ.MaQuyen
JOIN LoaiQuyen LQ ON LQ.MaLQ = Q.MaLQ
WHERE PQ.MaVT = @MaVT
ORDER BY DT.MaDT, LQ.MaLQ;

GO
-------SYNONYM-------
/*===== 1) Tổ chức - nhân sự =====*/
CREATE SYNONYM CN FOR dbo.ChiNhanh;
GO
SELECT * FROM CN;
GO

CREATE SYNONYM PB FOR dbo.PhongBan;
GO
SELECT * FROM PB;
GO

CREATE SYNONYM CV FOR dbo.ChucVu;
GO
SELECT * FROM CV;
GO

CREATE SYNONYM NV FOR dbo.NhanVien;
GO

SELECT * FROM NV;
GO

/*===== 2) Danh mục sản phẩm - kho =====*/
CREATE SYNONYM DVT FOR dbo.DonViTinh;
GO
SELECT * FROM DVT;
GO

CREATE SYNONYM NSP FOR dbo.NhomSP;
GO
SELECT * FROM NSP;
GO

CREATE SYNONYM LSP FOR dbo.LoaiSP;
GO
SELECT * FROM LSP;
GO

CREATE SYNONYM SP FOR dbo.SanPham;
GO
SELECT * FROM SP;
GO

CREATE SYNONYM K FOR dbo.Kho;
GO
SELECT * FROM KHO;
GO

CREATE SYNONYM TKHO FOR dbo.TonKho;
GO
SELECT * FROM TKHO;
GO

CREATE SYNONYM BDG FOR dbo.BienDongGia;
GO
SELECT * FROM BDG;
GO
/*===== 3) Khuyến mãi =====*/
CREATE SYNONYM CTKM FOR dbo.CTKhuyenMai;
GO
SELECT * FROM CTKM;
GO

CREATE SYNONYM CTCTKM FOR dbo.CTChuongTrinhKM;
GO
SELECT * FROM CTCTKM;
GO
/*===== 4) Khách hàng - thẻ - ngân hàng =====*/
CREATE SYNONYM LKH FOR dbo.LoaiKH;
GO
SELECT * FROM LKH;
GO

CREATE SYNONYM KH FOR dbo.KhachHang;
GO
SELECT * FROM KH;
GO

CREATE SYNONYM TTV FOR dbo.TheThanhVien;
GO
SELECT * FROM TTV;
GO

CREATE SYNONYM NH FOR dbo.NganHang;
GO
SELECT * FROM NH;
GO

/*===== 5) Đặt hàng - hóa đơn - xuất - giao =====*/
CREATE SYNONYM PDH FOR dbo.PhieuDatHang;
GO
SELECT * FROM PDH;
GO

CREATE SYNONYM CTPDH FOR dbo.CTPhieuDatHang;
GO
SELECT * FROM CTPDH;
GO

CREATE SYNONYM HD FOR dbo.HoaDon;
GO
SELECT * FROM HD;
GO

CREATE SYNONYM CTHD FOR dbo.CTHoaDon;
GO
SELECT * FROM CTHD;
GO

CREATE SYNONYM PX FOR dbo.PhieuXuat;
GO
SELECT * FROM PX;
GO

CREATE SYNONYM PGH FOR dbo.PhieuGiaoHang;
GO
SELECT * FROM PGH;
GO

CREATE SYNONYM CTPGH FOR dbo.CTPhieuGiaoHang;
GO
SELECT * FROM CTPGH;
GO
/*===== 6) Phân quyền =====*/
CREATE SYNONYM VT FOR dbo.VaiTroHeThong;
GO
SELECT * FROM VT;
GO

CREATE SYNONYM TKNV FOR dbo.TaiKhoanNV;
GO
SELECT * FROM TKNV;
GO

CREATE SYNONYM LDT FOR dbo.LoaiDoiTuong;
GO
SELECT * FROM LDT;
GO

CREATE SYNONYM DT FOR dbo.DoiTuong;
GO
SELECT * FROM DT;
GO

CREATE SYNONYM LQ FOR dbo.LoaiQuyen;
GO
SELECT * FROM LQ;
GO

CREATE SYNONYM Q FOR dbo.Quyen;
GO
SELECT * FROM Q;
GO

CREATE SYNONYM PQ FOR dbo.PhanQuyen;
GO
SELECT * FROM PQ;
GO
---Dùng Synonym trong  insert, update,....
INSERT INTO PDH (MaPhieuDH, MaNV, NgayDatHang, TriGiaDH)
VALUES ('PDH999', 'NV001', GETDATE(), 0);

UPDATE SP
SET MoTaSP = N'Cập nhật mô tả'
WHERE MaSP = 'SP001';

DELETE FROM CTKM
WHERE MaCT = 'CT001';
--- Tạo synonym cho View để truy cập nhanh
GO
CREATE VIEW View_ThongTinNhanVien
AS
SELECT
    NV.MaNV,
    NV.TenNV,
    CV.TenCV AS ChucVu,
    PB.TenPB AS PhongBan,
    CN.TenCN AS ChiNhanh,
    NV.SDTNV,
    NV.EmailNV
FROM
    NhanVien NV
INNER JOIN
    ChucVu CV ON NV.MaCV = CV.MaCV
INNER JOIN
    PhongBan PB ON NV.MaPB = PB.MaPB
INNER JOIN
    ChiNhanh CN ON PB.MaCN = CN.MaCN
GO
CREATE SYNONYM View_NV
FOR View_ThongTinNhanVien;
GO
Select*from View_ThongTinNhanVien;
Select*from View_NV;
-- Xem danh sách synonym đã tạo trong database
SELECT name, base_object_name
FROM sys.synonyms
ORDER BY name;
Go
---Dùng synonym trong View 

CREATE VIEW v_DonHang_Khach AS
SELECT PDH.MaPhieuDH, PDH.NgayDatHang, KH.TenKH
FROM PDH
LEFT JOIN KH ON PDH.MaKH = KH.MaKH;
go
-------INDEX---------
---Bật thang đo để so sánh
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO
---Tắt thang đo tốc độ xử lý
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
-- 1: Non-Clustered Index cho Email khách hàng
DROP INDEX IX_KhachHang_EmailKH ON KhachHang;
CREATE NONCLUSTERED INDEX IX_KhachHang_EmailKH
ON KhachHang (EmailKH);
GO
-- Kiểm thử
SELECT *
FROM KhachHang
WHERE EmailKH = N'bao3@gmail.com';

-- 2: Non-Clustered Index cho ngày đặt hàng
DROP INDEX IX_KhachHang_EmailKH ON KhachHang;
CREATE NONCLUSTERED INDEX IX_PhieuDatHang_NgayDatHang
ON PhieuDatHang (NgayDatHang)
INCLUDE (MaKH, SoThe, TriGiaDH, HinhThucThanhToan);
GO
-- Kiểm thử
SELECT MaPhieuDH, MaKH, NgayDatHang, TriGiaDH
FROM PhieuDatHang
WHERE NgayDatHang >= '2025-01-01'
  AND NgayDatHang <  '2025-11-08';
  --3: Non-Clustered Index cho chi tiết hóa đơn theo sản phẩm
CREATE NONCLUSTERED INDEX IX_CTHoaDon_MaSP
ON CTHoaDon (MaSP)
INCLUDE (SoLuongHD, ThanhTienHD);
GO
-- Kiểm thử
SELECT MaSP,
       SUM(SoLuongHD) AS TongSoLuong,
       SUM(ThanhTienHD) AS TongDoanhThu
FROM CTHoaDon
GROUP BY MaSP;
-------VIEW-------
GO
--Xem toàn bộ bảng khách hàng
CREATE VIEW vw_KhachHang
AS
SELECT
    MaKH, MaLoaiKH, TenKH, NgaySinhKH, SDTKH, DiaChiKH, EmailKH
FROM KhachHang;
GO
-- Kiểm thử
SELECT * FROM vw_KhachHang;
GO
---View xem thông tin liên hệ nhân viên
CREATE VIEW vw_NhanVien_LienHe
AS
SELECT
    MaNV,
    TenNV,
    SDTNV,
    EmailNV
FROM NhanVien;
GO
-- Kiểm thử
SELECT * FROM vw_NhanVien_LienHe
GO
--View xem hóa đơn + khách hàng
CREATE VIEW vw_HoaDon_ChiTiet
AS
SELECT
    HD.SoHD,
    HD.NgayLapHD,
    HD.MaPhieuDH,
    HD.MaKH,
    KH.TenKH,
    HD.SoThe,
    HD.MaNV,
    HD.PhuongThucTT,
    HD.TrangThaiHD,
    CT.MaSP,
    SP.TenSP,
    CT.SoLuongHD,
    CT.DonGiaHD,
    CT.ThanhTienHD
FROM HoaDon HD
JOIN CTHoaDon CT
    ON HD.SoHD = CT.SoHD
JOIN SanPham SP
    ON CT.MaSP = SP.MaSP
LEFT JOIN KhachHang KH
    ON HD.MaKH = KH.MaKH;
GO
-- Kiểm thử
SELECT TOP 20 * FROM vw_HoaDon_ChiTiet ORDER BY NgayLapHD DESC;
GO

---View tổng hợp doanh thu theo tháng
CREATE VIEW vw_DoanhThu_TheoThang
AS
SELECT
    YEAR(NgayLapHD) AS Nam,
    MONTH(NgayLapHD) AS Thang,
    COUNT(*) AS SoHoaDon,
    SUM(TriGiaTruocThue) AS TongTriGiaTruocThue,
    SUM(TriGiaSauThue) AS TongTriGiaSauThue
FROM HoaDon
GROUP BY YEAR(NgayLapHD), MONTH(NgayLapHD);
GO
-- Kiểm thử
SELECT * FROM vw_DoanhThu_TheoThang ORDER BY Nam DESC, Thang DESC;
GO

---View Top sản phẩm bán chạy theo tháng
CREATE VIEW vw_TopSanPham_BanChay_TheoThang
AS
SELECT
    YEAR(NgayLapHD) AS Nam,
    MONTH(NgayLapHD) AS Thang,
    MaSP,
    TenSP,
    SUM(SoLuongHD) AS TongSoLuongBan,
    SUM(ThanhTienHD) AS TongDoanhThuSP
FROM vw_HoaDon_ChiTiet
GROUP BY YEAR(NgayLapHD), MONTH(NgayLapHD), MaSP, TenSP;
GO
-- Kiểm thử
SELECT TOP 8 *
FROM vw_TopSanPham_BanChay_TheoThang
ORDER BY Nam DESC, Thang DESC, TongSoLuongBan DESC;
GO
-------FUNCTION--------
----HÀM TÍNH TUỔI KHÁCH HÀNG
CREATE OR ALTER FUNCTION dbo.fn_TuoiKhachHang
(
    @MaKH NVARCHAR(10)
)
RETURNS INT
AS
BEGIN
    DECLARE @NgaySinh DATE;

    SELECT @NgaySinh = NgaySinhKH
    FROM KhachHang
    WHERE MaKH = @MaKH;

    IF @NgaySinh IS NULL RETURN NULL;

    RETURN DATEDIFF(YEAR, @NgaySinh, GETDATE())
           - CASE 
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, @NgaySinh, GETDATE()), @NgaySinh) > GETDATE()
                THEN 1 ELSE 0
             END;
END;
GO
-- Kiểm thử
SELECT MaKH, TenKH, dbo.fn_TuoiKhachHang(MaKH) AS Tuoi
FROM KhachHang;
-----HÀM xem danh sách sản phẩm kèm giá hiện hành theo ngày --------
GO
CREATE OR ALTER FUNCTION dbo.fn_SanPham_KemGia
(
    @Ngay DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        sp.MaSP,
        sp.TenSP,
        sp.MaLoaiSP,
        sp.MaDVT,
        bg.GiaBan,
        bg.NgayCapNhat
    FROM SanPham sp
    OUTER APPLY (
        SELECT TOP 1 GiaBan, NgayCapNhat
        FROM BienDongGia
        WHERE MaSP = sp.MaSP
          AND NgayCapNhat <= @Ngay
        ORDER BY NgayCapNhat DESC
    ) bg
);
GO
-- Kiểm thử
SELECT * FROM dbo.fn_SanPham_KemGia(GETDATE());
--HÀM tra cứu tồn kho theo kì
GO
CREATE OR ALTER FUNCTION dbo.fn_TonKho_TheoKy
(
    @MaKho  NVARCHAR(10),
    @Thang  INT,
    @Nam    INT
)
RETURNS TABLE AS
RETURN
(
    SELECT 
        tk.MaKho,
        tk.MaSP,
        sp.TenSP,
        tk.ThangTK,
        tk.NamTK,
        tk.TonDK,
        tk.XuatTK,
        tk.TonCK,
        tk.TriGiaTonDK,
        tk.TriGiaXuatTK,
        tk.TriGiaTonCK
    FROM TonKho tk
    JOIN SanPham sp ON sp.MaSP = tk.MaSP
    WHERE tk.MaKho = @MaKho
      AND tk.ThangTK = @Thang
      AND tk.NamTK = @Nam
);
GO
-- Kiểm thử
SELECT * FROM dbo.fn_TonKho_TheoKy('KHO02', 11, 2025);
--HÀM cảnh cáo tồn kho thấp
GO
CREATE OR ALTER FUNCTION dbo.fn_CanhBao_TonThap
(
    @MaKho NVARCHAR(10),
    @Thang INT,
    @Nam   INT,
    @Nguong INT
)
RETURNS @Result TABLE
(
    MaKho NVARCHAR(10),
    MaSP  NVARCHAR(10),
    TenSP NVARCHAR(50),
    ThangTK INT,
    NamTK   INT,
    TonCK   INT
)
AS
BEGIN
    INSERT INTO @Result
    SELECT 
        tk.MaKho, tk.MaSP, sp.TenSP, tk.ThangTK, tk.NamTK, tk.TonCK
    FROM TonKho tk
    JOIN SanPham sp ON sp.MaSP = tk.MaSP
    WHERE tk.MaKho = @MaKho
      AND tk.ThangTK = @Thang
      AND tk.NamTK = @Nam
      AND tk.TonCK <= @Nguong;

    RETURN;
END;
GO
-- Kiểm thử
SELECT * FROM dbo.fn_CanhBao_TonThap('KHO08', 11, 2025, 200);
---HÀM tổng hợp mua hàng của khách hàng
GO
CREATE OR ALTER FUNCTION dbo.fn_TongHopMuaHang_KhachHang
(
    @TuNgay DATE,
    @DenNgay DATE
)
RETURNS @KQ TABLE
(
    MaKH NVARCHAR(10),
    TenKH NVARCHAR(50),
    SoHoaDon INT,
    TongChiTieu DECIMAL(18,2)
)
AS
BEGIN
    INSERT INTO @KQ (MaKH, TenKH, SoHoaDon, TongChiTieu)
    SELECT
        kh.MaKH, kh.TenKH,
        COUNT(hd.SoHD) AS SoHoaDon,
        SUM(hd.TriGiaSauThue) AS TongChiTieu
    FROM KhachHang kh
    JOIN HoaDon hd ON hd.MaKH = kh.MaKH
    WHERE hd.NgayLapHD >= @TuNgay
      AND hd.NgayLapHD <= @DenNgay
    GROUP BY kh.MaKH, kh.TenKH;

    RETURN;
END;
GO
-- Kiểm thử
SELECT * 
FROM dbo.fn_TongHopMuaHang_KhachHang('2025-01-01', '2025-12-31');
------THỦ TỤC-----
---Thêm khách hàng
GO
CREATE OR ALTER PROCEDURE dbo.sp_ThemKhachHang
    @MaKH       NVARCHAR(10),
    @MaLoaiKH   NVARCHAR(10),
    @TenKH      NVARCHAR(50),
    @NgaySinhKH DATE = NULL,
    @SDTKH      INT = NULL,
    @DiaChiKH   NVARCHAR(50) = NULL,
    @EmailKH    NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM KhachHang WHERE MaKH = @MaKH)
    BEGIN
        RAISERROR (N'Mã khách hàng đã tồn tại.', 16, 1);
        RETURN;
    END

    INSERT INTO KhachHang(MaKH, MaLoaiKH, TenKH, NgaySinhKH, SDTKH, DiaChiKH, EmailKH)
    VALUES (@MaKH, @MaLoaiKH, @TenKH, @NgaySinhKH, @SDTKH, @DiaChiKH, @EmailKH);
END
GO
EXEC dbo.sp_ThemKhachHang
    @MaKH = 'KH099',
    @MaLoaiKH = 'LKH01',
    @TenKH = N'Nguyễn An',
    @NgaySinhKH = '1999-10-10',
    @SDTKH = 901234567,
    @DiaChiKH = N'Q.1, TP.HCM',
    @EmailKH = 'an@gmail.com';

SELECT * FROM KhachHang WHERE MaKH = 'KH099';
----Thủ tục thêm pdh ktr ràng buộc
GO
CREATE OR ALTER PROCEDURE dbo.sp_ThemPhieuDatHang
    @MaPhieuDH NVARCHAR(10),
    @MaNV      NVARCHAR(10),
    @MaKH      NVARCHAR(10) = NULL,
    @SoThe     NVARCHAR(10) = NULL,
    @NgayDatHang DATETIME,
    @HinhThucThanhToan NVARCHAR(100) = NULL,
    @DiaChiGiao NVARCHAR(255) = NULL,
    @GhiChuDatHang NVARCHAR(255) = NULL,
    @KhuyenMai DECIMAL(10,2) = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM PhieuDatHang WHERE MaPhieuDH = @MaPhieuDH)
    BEGIN
        RAISERROR (N'Mã phiếu đặt hàng đã tồn tại.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNV = @MaNV)
    BEGIN
        RAISERROR (N'Không tìm thấy nhân viên lập phiếu.', 16, 1);
        RETURN;
    END
    -- Ràng buộc nghiệp vụ: khách vãng lai không gắn thẻ
    IF @MaKH IS NULL AND @SoThe IS NOT NULL
    BEGIN
        RAISERROR (N'Khách vãng lai không được gắn số thẻ.', 16, 1);
        RETURN;
    END
    INSERT INTO PhieuDatHang
    (MaPhieuDH, MaKH, SoThe, MaNV, NgayDatHang, HinhThucThanhToan, NgayTT, DiaChiGiao, GhiChuDatHang, KhuyenMai, TriGiaDH)
    VALUES
    (@MaPhieuDH, @MaKH, @SoThe, @MaNV, @NgayDatHang, @HinhThucThanhToan, NULL, @DiaChiGiao, @GhiChuDatHang, @KhuyenMai, 0);
END
GO
EXEC dbo.sp_ThemPhieuDatHang
    @MaPhieuDH = 'PDH098',
    @MaNV = 'NV001',
    @MaKH = 'KH003',
    @SoThe = 'ST010',
    @NgayDatHang = '2025-11-01',
    @HinhThucThanhToan = N'Tiền mặt',
    @DiaChiGiao = N'Q.1, TP.HCM',
    @KhuyenMai = 0;

SELECT * FROM PhieuDatHang WHERE MaPhieuDH = 'PDH098';
GO

----Thủ thục thêm CTPhieuDatHang
CREATE OR ALTER PROCEDURE dbo.sp_ThemCTPhieuDatHang
    @MaPhieuDH NVARCHAR(10),
    @MaSP      NVARCHAR(10),
    @SoLuongDH INT,
    @DonGiaDH  DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM PhieuDatHang WHERE MaPhieuDH = @MaPhieuDH)
    BEGIN
        RAISERROR (N'Không tìm thấy phiếu đặt hàng.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        RAISERROR (N'Không tìm thấy sản phẩm.', 16, 1);
        RETURN;
    END
    IF @SoLuongDH <= 0
    BEGIN
        RAISERROR (N'Số lượng đặt phải > 0.', 16, 1);
        RETURN;
    END
    IF @DonGiaDH < 0
    BEGIN
        RAISERROR (N'Đơn giá không hợp lệ.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM CTPhieuDatHang WHERE MaPhieuDH = @MaPhieuDH AND MaSP = @MaSP)
    BEGIN
        RAISERROR (N'Sản phẩm này đã có trong chi tiết phiếu đặt hàng.', 16, 1);
        RETURN;
    END
    INSERT INTO CTPhieuDatHang(MaPhieuDH, MaSP, SoLuongDH, DonGiaDH, ThanhTienDH)
    VALUES (@MaPhieuDH, @MaSP, @SoLuongDH, @DonGiaDH, @SoLuongDH * @DonGiaDH);
END
GO
EXEC dbo.sp_ThemCTPhieuDatHang
    @MaPhieuDH = N'PDH001',
    @MaSP = N'SP001',
    @SoLuongDH = 2,
    @DonGiaDH = 39000;
SELECT * FROM CTPhieuDatHang WHERE MaPhieuDH = 'PDH001';
GO
----Thủ tục cập nhật trị giá PDH
CREATE OR ALTER PROCEDURE dbo.sp_CapNhatTriGiaPhieuDatHang
    @MaPhieuDH NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM PhieuDatHang WHERE MaPhieuDH = @MaPhieuDH)
    BEGIN
        RAISERROR (N'Không tìm thấy phiếu đặt hàng để cập nhật trị giá.', 16, 1);
        RETURN;
    END

    DECLARE @Tong DECIMAL(10,2);

    SELECT @Tong = ISNULL(SUM(ThanhTienDH), 0)
    FROM CTPhieuDatHang
    WHERE MaPhieuDH = @MaPhieuDH;

    UPDATE PhieuDatHang
    SET TriGiaDH = @Tong
    WHERE MaPhieuDH = @MaPhieuDH;
END
GO

EXEC dbo.sp_CapNhatTriGiaPhieuDatHang @MaPhieuDH = 'PDH002';

SELECT MaPhieuDH, KhuyenMai, TriGiaDH
FROM PhieuDatHang
WHERE MaPhieuDH = 'PDH002';
GO
---Thủ tục tạo hóa đơn từ PDH
CREATE OR ALTER PROCEDURE dbo.sp_TaoHoaDonTuPhieuDatHang
    @SoHD        NVARCHAR(10),
    @MaPhieuDH   NVARCHAR(10),
    @MaNV        NVARCHAR(10),
    @NgayLapHD   DATE,
    @PhuongThucTT NVARCHAR(50) = NULL,
    @TrangThaiHD NVARCHAR(100) = N'Đã lập'
AS BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM HoaDon WHERE SoHD = @SoHD)
    BEGIN
        RAISERROR (N'Số hóa đơn đã tồn tại.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM PhieuDatHang WHERE MaPhieuDH = @MaPhieuDH)
    BEGIN
        RAISERROR (N'Không tìm thấy phiếu đặt hàng để lập hóa đơn.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNV = @MaNV)
    BEGIN
        RAISERROR (N'Không tìm thấy nhân viên lập hóa đơn.', 16, 1);
        RETURN;
    END
    DECLARE @MaKH NVARCHAR(10), @SoThe NVARCHAR(10);
    SELECT @MaKH = MaKH, @SoThe = SoThe
    FROM PhieuDatHang
    WHERE MaPhieuDH = @MaPhieuDH;
    DECLARE @TongTruocThue DECIMAL(10,2);
    SELECT @TongTruocThue = ISNULL(SUM(ThanhTienDH), 0)
    FROM CTPhieuDatHang
    WHERE MaPhieuDH = @MaPhieuDH;
    INSERT INTO HoaDon
    (SoHD, MaPhieuDH, MaKH, SoThe, MaNV, NgayLapHD, MaSoThue,
     TriGiaTruocThue, TriGiaSauThue, PhuongThucTT, TrangThaiHD)
    VALUES
    (@SoHD, @MaPhieuDH, @MaKH, @SoThe, @MaNV, @NgayLapHD, NULL,
     @TongTruocThue, @TongTruocThue, @PhuongThucTT, @TrangThaiHD);
END
GO
EXEC dbo.sp_TaoHoaDonTuPhieuDatHang
    @SoHD = 'HD099',
    @MaPhieuDH = 'PDH001',
    @MaNV = 'NV001',
    @NgayLapHD = '2025-11-01',
    @PhuongThucTT = N'Tiền mặt',
    @TrangThaiHD = N'Chưa thanh toán';

SELECT * FROM HoaDon WHERE SoHD = 'HD099';
GO
CREATE OR ALTER PROCEDURE dbo.sp_ThemCTPhieuGiaoHang_KiemSoatSoLuong
    @MaPGH        NVARCHAR(10),
    @MaSP         NVARCHAR(10),
    @SoLuongGiao  INT,
    @GhiChuPGH    NVARCHAR(255) = NULL
AS BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM PhieuGiaoHang WHERE MaPGH = @MaPGH)
    BEGIN
        RAISERROR (N'Không tìm thấy phiếu giao hàng.', 16, 1);
        RETURN; END
    IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        RAISERROR (N'Không tìm thấy sản phẩm.', 16, 1);
        RETURN; END
    IF @SoLuongGiao <= 0
    BEGIN
        RAISERROR (N'Số lượng giao phải > 0.', 16, 1);
        RETURN; END
    IF EXISTS (SELECT 1 FROM CTPhieuGiaoHang WHERE MaPGH = @MaPGH AND MaSP = @MaSP)
    BEGIN
        RAISERROR (N'Sản phẩm này đã có trong chi tiết phiếu giao hàng.', 16, 1);
        RETURN; END
    DECLARE @MaPhieuDH NVARCHAR(10);
    SELECT @MaPhieuDH = MaPhieuDH
    FROM PhieuGiaoHang
    WHERE MaPGH = @MaPGH;
    IF @MaPhieuDH IS NULL
    BEGIN
        RAISERROR (N'Phiếu giao hàng chưa gắn với phiếu đặt hàng.', 16, 1);
        RETURN; END
    DECLARE @SoLuongDat INT;
    SELECT @SoLuongDat = SoLuongDH
    FROM CTPhieuDatHang
    WHERE MaPhieuDH = @MaPhieuDH AND MaSP = @MaSP;
    IF @SoLuongDat IS NULL
    BEGIN
        RAISERROR (N'Sản phẩm này không tồn tại trong chi tiết phiếu đặt của đơn tương ứng.', 16, 1);
        RETURN; END
    DECLARE @DaGiao INT;
    SELECT @DaGiao = ISNULL(SUM(C.SoLuongGiao), 0)
    FROM CTPhieuGiaoHang C
    JOIN PhieuGiaoHang P ON P.MaPGH = C.MaPGH
    WHERE P.MaPhieuDH = @MaPhieuDH AND C.MaSP = @MaSP;
    IF (@DaGiao + @SoLuongGiao) > @SoLuongDat
    BEGIN
        RAISERROR (N'Số lượng giao (cộng dồn) vượt số lượng đặt của cùng đơn và sản phẩm.', 16, 1);
        RETURN; END
    INSERT INTO CTPhieuGiaoHang(MaPGH, MaSP, SoLuongGiao, GhiChuPGH)
    VALUES (@MaPGH, @MaSP, @SoLuongGiao, @GhiChuPGH);
END
GO
-- Giao 1 sản phẩm không vượt số lượng đặt
EXEC dbo.sp_ThemCTPhieuGiaoHang_KiemSoatSoLuong
    @MaPGH = 'PGH001',
    @MaSP = 'SP001',
    @SoLuongGiao = 1,
    @GhiChuPGH = N'Giao lần 1';

SELECT * FROM CTPhieuGiaoHang WHERE MaPGH = 'PGH001';
GO

GO
-------TRIGGER-------
--- --- R_LBLTT2 – Không chồng lấn hiệu lực thẻ theo khách hàng
go
CREATE TRIGGER tgr_TheThanhVien_KhongChongLanThoiGian
ON dbo.TheThanhVien
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra chồng lấn thời gian giữa thẻ mới/sửa với các thẻ khác của cùng MaKH
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.TheThanhVien t
             ON t.MaKH = i.MaKH
            AND t.SoThe <> i.SoThe
        WHERE 
            -- Điều kiện overlap:
            i.NgayBD <= ISNULL(t.NgayHH, '9999-12-31')
            AND ISNULL(i.NgayHH, '9999-12-31') >= t.NgayBD)
    BEGIN
        PRINT N'Thời gian thẻ mới không hợp lệ so với thẻ trước';
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
-- CỐ Ý vi phạm R_LBLTT2: tạo thẻ mới chồng lấn hiệu lực với ST009 của KH002
INSERT INTO TheThanhVien
(SoThe, MaKH, LoaiThe, NgayBD, NgayHH, DTLHienCo, DiemDaQuyDoi, TongDTL, NgayHetHanDiem, GhiChuThe, TrangThaiThe)
VALUES
(N'ST099', N'KH002', N'Gold','2025-08-01', NULL, 0, 0, 0, '2025-12-31', N'Test chồng lấn', N'Hoạt động'); 
 -- chồng lấn với ST009 (đang hiệu lực từ 2025-06-01)
GO
--- R_LB2 – Một khách chỉ có tối đa 1 thẻ “Hoạt động”
CREATE TRIGGER tgr_TheThanhVien_MotTheHoatDong
ON dbo.TheThanhVien
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM dbo.TheThanhVien t
        WHERE t.MaKH IN (SELECT MaKH FROM inserted)
          AND t.TrangThaiThe = N'Hoạt động'
        GROUP BY t.MaKH
        HAVING COUNT(*) > 1
    )
    BEGIN
        PRINT N'Khách hàng đã có thẻ đang hoạt động';
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
-- CỐ Ý vi phạm R_LB2: KH003 đã có ST010 'Hoạt động'
-- Thẻ mới có thời gian KHÔNG chồng lấn để chỉ kích hoạt rule "1 thẻ hoạt động"
INSERT INTO TheThanhVien
(SoThe, MaKH, LoaiThe, NgayBD, NgayHH, DTLHienCo, DiemDaQuyDoi, TongDTL, NgayHetHanDiem, GhiChuThe, TrangThaiThe)
VALUES
(N'ST098', N'KH003', N'Silver', '2025-01-01', '2025-05-31',0, 0, 0, '2025-12-31', N'Test 2 thẻ hoạt động', N'Hoạt động');
 -- kết thúc trước khi ST010 bắt đầu (2025-06-15)
GO
----R_LBLQH1 – Đồng bộ Trị giá phiếu đặt hàng theo chi tiết
CREATE TRIGGER tgr_CTPDH_CapNhatTriGiaDH
ON dbo.CTPhieuDatHang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Affected AS (
        SELECT MaPhieuDH FROM inserted
        UNION
        SELECT MaPhieuDH FROM deleted
    )
    UPDATE p
    SET p.TriGiaDH = ISNULL(s.TongCT, 0)
    FROM dbo.PhieuDatHang p
    JOIN Affected a ON a.MaPhieuDH = p.MaPhieuDH
    OUTER APPLY (
        SELECT SUM(d.ThanhTienDH) AS TongCT
        FROM dbo.CTPhieuDatHang d
        WHERE d.MaPhieuDH = a.MaPhieuDH
    ) s;
END;
GO
-- Xem trị giá trước khi thêm chi tiết
SELECT MaPhieuDH, TriGiaDH
FROM PhieuDatHang
WHERE MaPhieuDH = N'PDH010';

-- Thêm 1 dòng chi tiết mới để trigger tự cập nhật tổng tiền
INSERT INTO CTPhieuDatHang (MaPhieuDH, MaSP, SoLuongDH, DonGiaDH, ThanhTienDH)
VALUES (N'PDH010', N'SP021', 1, 25000, 25000);

-- Xem trị giá sau khi thêm chi tiết
SELECT MaPhieuDH, TriGiaDH
FROM PhieuDatHang
WHERE MaPhieuDH = N'PDH010';

GO
GO
---R_LBLQH3 – Số lượng giao không vượt số lượng đặt
CREATE TRIGGER tgr_CTPGH_KhongVuotSoLuongDat
ON dbo.CTPhieuGiaoHang
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Nếu phiếu giao không gắn MaPhieuDH thì không thể đối chiếu
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.PhieuGiaoHang pgh ON pgh.MaPGH = i.MaPGH
        WHERE pgh.MaPhieuDH IS NULL
    )
    BEGIN
        PRINT N'Phiếu giao hàng chưa gắn mã phiếu đặt để đối chiếu số lượng';
        ROLLBACK TRANSACTION;
        RETURN;
    END
    -- Đối chiếu theo từng sản phẩm trong đơn đặt
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.PhieuGiaoHang pgh
             ON pgh.MaPGH = i.MaPGH
        JOIN dbo.CTPhieuDatHang d
             ON d.MaPhieuDH = pgh.MaPhieuDH
            AND d.MaSP = i.MaSP
        WHERE i.SoLuongGiao > d.SoLuongDH
    )
    BEGIN
        PRINT N'Số lượng giao vượt quá số lượng đặt';
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
-- 1) Tạo 1 phiếu giao mới để test (gắn với PDH002)
INSERT INTO PhieuGiaoHang
(MaPGH, MaPhieuDH, SoHD, NgayGiao, DiaChiGiaoHang, NguoiNhan, SDTNhan, PhiShip, HinhThucGiao, TrangThaiGiao)
VALUES
(N'PGH099', N'PDH002', N'HD002', '2025-11-20',
 N'Q7, TP.HCM', N'Test User', '0909999999', 15000, N'Giao nhanh', N'Đang giao');

-- 2) CỐ Ý vi phạm R_LBLQH3: giao vượt số lượng đặt
-- PDH002 đặt SP001 = 2 nhưng giao = 5
INSERT INTO CTPhieuGiaoHang (MaPGH, MaSP, SoLuongGiao, GhiChuPGH)
VALUES (N'PGH099', N'SP001', 5, N'Test giao vượt số lượng đặt');

--Ghi nhật ký hành động người dùng
--Bảng audit theo dõi
CREATE TABLE AuditLog (
AuditID INT IDENTITY(1,1) PRIMARY KEY,
UserName NVARCHAR(100),
Action NVARCHAR(200),
TimeStamp DATETIME DEFAULT GETDATE());
--Tạo các trigger cho từng bảng theo dõi hành động thay đổi bảng
GO
 ----  AUDIT - ChiNhanh
CREATE TRIGGER trg_LogDelete_ChiNhanh 
ON dbo.ChiNhanh
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on ChiNhanh', GETDATE());
END;
GO
CREATE TRIGGER trg_LogInsert_ChiNhanh
ON dbo.ChiNhanh
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on ChiNhanh', GETDATE());
END;
GO
CREATE TRIGGER trg_LogUpdate_ChiNhanh
ON dbo.ChiNhanh
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on ChiNhanh', GETDATE());
END;
GO

 ---  AUDIT - PhongBan

CREATE TRIGGER trg_LogDelete_PhongBan 
ON dbo.PhongBan
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on PhongBan', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_PhongBan
ON dbo.PhongBan
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on PhongBan', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_PhongBan
ON dbo.PhongBan
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on PhongBan', GETDATE());
END;
GO

  --- AUDIT - ChucVu

GO
CREATE TRIGGER trg_LogDelete_ChucVu 
ON dbo.ChucVu
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on ChucVu', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_ChucVu
ON dbo.ChucVu
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on ChucVu', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_ChucVu
ON dbo.ChucVu
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on ChucVu', GETDATE());
END;
Go
 ---  AUDIT - NhanVien
GO
CREATE TRIGGER trg_LogDelete_NhanVien 
ON dbo.NhanVien
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on NhanVien', GETDATE());
END;
GO
CREATE TRIGGER trg_LogInsert_NhanVien
ON dbo.NhanVien
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on NhanVien', GETDATE());
END;
GO
CREATE TRIGGER trg_LogUpdate_NhanVien
ON dbo.NhanVien
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on NhanVien', GETDATE());
END;
GO

  --- AUDIT - DonViTinh

CREATE TRIGGER trg_LogDelete_DonViTinh 
ON dbo.DonViTinh
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on DonViTinh', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_DonViTinh
ON dbo.DonViTinh
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on DonViTinh', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_DonViTinh
ON dbo.DonViTinh
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on DonViTinh', GETDATE());
END;
GO

 ---  AUDIT - NhomSP
CREATE TRIGGER trg_LogDelete_NhomSP 
ON dbo.NhomSP
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on NhomSP', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_NhomSP
ON dbo.NhomSP
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on NhomSP', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_NhomSP
ON dbo.NhomSP
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on NhomSP', GETDATE());
END;
GO

  --- AUDIT - LoaiSP

CREATE TRIGGER trg_LogDelete_LoaiSP 
ON dbo.LoaiSP
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on LoaiSP', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_LoaiSP
ON dbo.LoaiSP
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on LoaiSP', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_LoaiSP
ON dbo.LoaiSP
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on LoaiSP', GETDATE());
END;
GO
  --- AUDIT - SanPham
CREATE TRIGGER trg_LogDelete_SanPham 
ON dbo.SanPham
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on SanPham', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_SanPham
ON dbo.SanPham
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on SanPham', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_SanPham
ON dbo.SanPham
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on SanPham', GETDATE());
END;
GO
 ---  AUDIT - Kho
GO
CREATE TRIGGER trg_LogDelete_Kho 
ON dbo.Kho
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on Kho', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_Kho
ON dbo.Kho
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on Kho', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_Kho
ON dbo.Kho
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on Kho', GETDATE());
END;
GO
  --- AUDIT - TonKho
CREATE TRIGGER trg_LogDelete_TonKho 
ON dbo.TonKho
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on TonKho', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_TonKho
ON dbo.TonKho
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on TonKho', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_TonKho
ON dbo.TonKho
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on TonKho', GETDATE());
END;
GO
 ----  AUDIT - BienDongGia
CREATE TRIGGER trg_LogDelete_BienDongGia 
ON dbo.BienDongGia
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on BienDongGia', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_BienDongGia
ON dbo.BienDongGia
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on BienDongGia', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_BienDongGia
ON dbo.BienDongGia
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on BienDongGia', GETDATE());
END;
GO

  ---- AUDIT - CTKhuyenMai
CREATE TRIGGER trg_LogDelete_CTKhuyenMai 
ON dbo.CTKhuyenMai
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on CTKhuyenMai', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_CTKhuyenMai
ON dbo.CTKhuyenMai
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on CTKhuyenMai', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_CTKhuyenMai
ON dbo.CTKhuyenMai
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on CTKhuyenMai', GETDATE());
END;
GO

 ---  AUDIT - CTChuongTrinhKM
CREATE TRIGGER trg_LogDelete_CTChuongTrinhKM 
ON dbo.CTChuongTrinhKM
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on CTChuongTrinhKM', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_CTChuongTrinhKM
ON dbo.CTChuongTrinhKM
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on CTChuongTrinhKM', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_CTChuongTrinhKM
ON dbo.CTChuongTrinhKM
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on CTChuongTrinhKM', GETDATE());
END;
GO

 ---  AUDIT - LoaiKH
GO
CREATE TRIGGER trg_LogDelete_LoaiKH 
ON dbo.LoaiKH
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on LoaiKH', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_LoaiKH
ON dbo.LoaiKH
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on LoaiKH', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_LoaiKH
ON dbo.LoaiKH
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on LoaiKH', GETDATE());
END;
GO

 ---  AUDIT - KhachHang
CREATE TRIGGER trg_LogDelete_KhachHang 
ON dbo.KhachHang
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on KhachHang', GETDATE());
END;
GO
CREATE TRIGGER trg_LogInsert_KhachHang
ON dbo.KhachHang
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on KhachHang', GETDATE());
END;
GO
CREATE TRIGGER trg_LogUpdate_KhachHang
ON dbo.KhachHang
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on KhachHang', GETDATE());
END;
GO

 ---  AUDIT - TheThanhVien
CREATE TRIGGER trg_LogDelete_TheThanhVien 
ON dbo.TheThanhVien
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on TheThanhVien', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_TheThanhVien
ON dbo.TheThanhVien
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on TheThanhVien', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_TheThanhVien
ON dbo.TheThanhVien
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on TheThanhVien', GETDATE());
END;
GO
 ---  AUDIT - NganHang

CREATE TRIGGER trg_LogDelete_NganHang 
ON dbo.NganHang
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on NganHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_NganHang
ON dbo.NganHang
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on NganHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_NganHang
ON dbo.NganHang
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on NganHang', GETDATE());
END;
GO

 ---  AUDIT - PhieuDatHang

CREATE TRIGGER trg_LogDelete_PhieuDatHang 
ON dbo.PhieuDatHang
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on PhieuDatHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_PhieuDatHang
ON dbo.PhieuDatHang
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on PhieuDatHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_PhieuDatHang
ON dbo.PhieuDatHang
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on PhieuDatHang', GETDATE());
END;
GO
/* =========================
   AUDIT - CTPhieuDatHang
========================= */
GO
CREATE TRIGGER trg_LogDelete_CTPhieuDatHang 
ON dbo.CTPhieuDatHang
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on CTPhieuDatHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_CTPhieuDatHang
ON dbo.CTPhieuDatHang
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on CTPhieuDatHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_CTPhieuDatHang
ON dbo.CTPhieuDatHang
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on CTPhieuDatHang', GETDATE());
END;
GO


/* =========================
   AUDIT - HoaDon
========================= */
CREATE TRIGGER trg_LogDelete_HoaDon 
ON dbo.HoaDon
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on HoaDon', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_HoaDon
ON dbo.HoaDon
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on HoaDon', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_HoaDon
ON dbo.HoaDon
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on HoaDon', GETDATE());
END;
GO


/* =========================
   AUDIT - CTHoaDon
========================= */
CREATE TRIGGER trg_LogDelete_CTHoaDon 
ON dbo.CTHoaDon
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on CTHoaDon', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_CTHoaDon
ON dbo.CTHoaDon
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on CTHoaDon', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_CTHoaDon
ON dbo.CTHoaDon
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on CTHoaDon', GETDATE());
END;
GO


/* =========================
   AUDIT - PhieuXuat
========================= */
CREATE TRIGGER trg_LogDelete_PhieuXuat 
ON dbo.PhieuXuat
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on PhieuXuat', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_PhieuXuat
ON dbo.PhieuXuat
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on PhieuXuat', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_PhieuXuat
ON dbo.PhieuXuat
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on PhieuXuat', GETDATE());
END;
GO
   ---- AUDIT - CTPX
CREATE TRIGGER trg_LogDelete_CTPX 
ON dbo.CTPX
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on CTPX', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_CTPX
ON dbo.CTPX
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on CTPX', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_CTPX
ON dbo.CTPX
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on CTPX', GETDATE());
END;
GO
/* =========================
   AUDIT - PhieuGiaoHang
========================= */
GO
CREATE TRIGGER trg_LogDelete_PhieuGiaoHang 
ON dbo.PhieuGiaoHang
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on PhieuGiaoHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_PhieuGiaoHang
ON dbo.PhieuGiaoHang
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on PhieuGiaoHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_PhieuGiaoHang
ON dbo.PhieuGiaoHang
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on PhieuGiaoHang', GETDATE());
END;
GO


/* =========================
   AUDIT - CTPhieuGiaoHang
========================= */
GO
CREATE TRIGGER trg_LogDelete_CTPhieuGiaoHang 
ON dbo.CTPhieuGiaoHang
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on CTPhieuGiaoHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_CTPhieuGiaoHang
ON dbo.CTPhieuGiaoHang
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on CTPhieuGiaoHang', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_CTPhieuGiaoHang
ON dbo.CTPhieuGiaoHang
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on CTPhieuGiaoHang', GETDATE());
END;
GO


/* =========================
   AUDIT - VaiTroHeThong
========================= */
GO
CREATE TRIGGER trg_LogDelete_VaiTroHeThong 
ON dbo.VaiTroHeThong
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on VaiTroHeThong', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_VaiTroHeThong
ON dbo.VaiTroHeThong
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on VaiTroHeThong', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_VaiTroHeThong
ON dbo.VaiTroHeThong
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on VaiTroHeThong', GETDATE());
END;
GO


/* =========================
   AUDIT - TaiKhoanNV
========================= */
GO
CREATE TRIGGER trg_LogDelete_TaiKhoanNV 
ON dbo.TaiKhoanNV
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on TaiKhoanNV', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_TaiKhoanNV
ON dbo.TaiKhoanNV
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on TaiKhoanNV', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_TaiKhoanNV
ON dbo.TaiKhoanNV
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on TaiKhoanNV', GETDATE());
END;
GO


/* =========================
   AUDIT - LoaiDoiTuong
========================= */
GO
CREATE TRIGGER trg_LogDelete_LoaiDoiTuong 
ON dbo.LoaiDoiTuong
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on LoaiDoiTuong', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_LoaiDoiTuong
ON dbo.LoaiDoiTuong
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on LoaiDoiTuong', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_LoaiDoiTuong
ON dbo.LoaiDoiTuong
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on LoaiDoiTuong', GETDATE());
END;
GO


/* =========================
   AUDIT - DoiTuong
========================= */
GO
CREATE TRIGGER trg_LogDelete_DoiTuong 
ON dbo.DoiTuong
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on DoiTuong', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_DoiTuong
ON dbo.DoiTuong
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on DoiTuong', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_DoiTuong
ON dbo.DoiTuong
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on DoiTuong', GETDATE());
END;
GO


/* =========================
   AUDIT - LoaiQuyen
========================= */
GO
CREATE TRIGGER trg_LogDelete_LoaiQuyen 
ON dbo.LoaiQuyen
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on LoaiQuyen', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_LoaiQuyen
ON dbo.LoaiQuyen
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on LoaiQuyen', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_LoaiQuyen
ON dbo.LoaiQuyen
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on LoaiQuyen', GETDATE());
END;
GO


/* =========================
   AUDIT - Quyen
========================= */
GO
CREATE TRIGGER trg_LogDelete_Quyen 
ON dbo.Quyen
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on Quyen', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_Quyen
ON dbo.Quyen
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on Quyen', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_Quyen
ON dbo.Quyen
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on Quyen', GETDATE());
END;
GO


/* =========================
   AUDIT - PhanQuyen
========================= */
GO
CREATE TRIGGER trg_LogDelete_PhanQuyen 
ON dbo.PhanQuyen
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'DELETE on PhanQuyen', GETDATE());
END;
GO

CREATE TRIGGER trg_LogInsert_PhanQuyen
ON dbo.PhanQuyen
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'INSERT on PhanQuyen', GETDATE());
END;
GO

CREATE TRIGGER trg_LogUpdate_PhanQuyen
ON dbo.PhanQuyen
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditLog (UserName, Action, TimeStamp)
    VALUES (SYSTEM_USER, 'UPDATE on PhanQuyen', GETDATE());
END;
GO
----Xem 
 Select *from AuditLog;
 ---Thủ tục xem lịch sử hành vi của người dùng
 GO
CREATE PROCEDURE dbo.sp_XemAuditTheoUser
    @UserName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT AuditID, UserName, Action, TimeStamp
    FROM dbo.AuditLog
    WHERE UserName = @UserName
    ORDER BY TimeStamp DESC;
End;
EXEC dbo.sp_XemAuditTheoUser N'pl_admin_01';
GO
---------------------PHÂN QUYỀN----------------------
CREATE OR ALTER PROCEDURE dbo.sp_TaoLogin
    @LoginName  VARCHAR(50),      -- tên LOGIN trên server
    @Password   NVARCHAR(128)     -- mật khẩu LOGIN
AS
BEGIN
    -- Nếu login chưa tồn tại thì mới tạo
    IF NOT EXISTS (
        SELECT * FROM sys.server_principals
        WHERE name = @LoginName
    )
    BEGIN
        EXEC('CREATE LOGIN [' + @LoginName + ']
              WITH PASSWORD = ''' + @Password + ''',
                   CHECK_POLICY    = ON,
                   CHECK_EXPIRATION = ON,
                   DEFAULT_DATABASE = [QLBanHangPhucLong];');

        PRINT N'Đã tạo LOGIN ' + @LoginName;
    END
    ELSE
    BEGIN
        PRINT N'LOGIN ' + @LoginName + N' đã tồn tại.';
    END
END
---Quản lý hệ thống
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_admin_01',
    @Password  = N'PL@2025_AD';
GO
--- Quản lý chi nhánh
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_qlcn_01',
    @Password  = N'PL@2025_MN1';
GO
	--Thu ngân
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_thungan_01',
    @Password  = N'PL@2025_CA1';
GO
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_thungan_02',
    @Password  = N'PL@2025_CA2';
GO
--- Bán hàng
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_sales_02',
    @Password  = N'PL@2025_S2';
GO
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_sales_01',
    @Password  = N'PL@2025_S1';
GO
---CSKH
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_cskh_01',
    @Password  = N'PL@2025_CS1';
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_cskh_02',
    @Password  = N'PL@2025_CS2';
GO
---Kho
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_kho_hcm_01',
    @Password  = N'PL@2025_KH1';
GO
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_kho_hn_01',
    @Password  = N'PL@2025_KH2';
GO
---Marketing
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_mkt_01',
    @Password  = N'PL@2025_MK1';
GO
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_mkt_02',
    @Password  = N'PL@2025_MK2';
GO
---Kế toán
EXEC dbo.sp_TaoLogin 
    @LoginName = 'pl_ketoan_01',
    @Password  = N'PL@2025_AC1';
GO
-- Xem tất cả SQL LOGIN trên server
SELECT 
    name AS LoginName,
    type_desc,
    is_disabled,
    create_date,
    modify_date
FROM sys.server_principals
WHERE type_desc = 'SQL_LOGIN'
ORDER BY create_date DESC;
GO
-------MÃ HÓA MẬT KHẨU
---Hàm Mã hóa mật khẩu----
CREATE OR ALTER FUNCTION dbo.MaHoaMK (@matkhau NVARCHAR(128))
RETURNS VARBINARY(8000)
AS
BEGIN
    DECLARE @kq VARBINARY(8000);
    SET @kq = EncryptByPassPhrase(N'SQL Server', @matkhau);
    RETURN @kq;
END;
GO
--- Hàm Giải mã mật khẩu----
CREATE OR ALTER FUNCTION dbo.GiaiMaMK (@matkhau VARBINARY(8000))
RETURNS NVARCHAR(128)
AS
BEGIN
    DECLARE @kq NVARCHAR(128);
    SET @kq = CONVERT(NVARCHAR(128), DecryptByPassPhrase(N'SQL Server', @matkhau));
    RETURN @kq;
END;
GO
---Lưu mật khẩu đã mã hóa vào TaiKhoanNV từ login
CREATE OR ALTER PROCEDURE dbo.sp_LuuMK_TaiKhoanNV_TrucTiep
    @TenDangNhap NVARCHAR(255),
    @MatKhau NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    -- 1) Mã hóa mật khẩu
    DECLARE @MatKhauMaHoa VARBINARY(8000) = dbo.MaHoaMK(@MatKhau);
    -- 2) Chuyển sang chuỗi hex để lưu vào NVARCHAR
    DECLARE @Hex NVARCHAR(255) = CONVERT(NVARCHAR(255), @MatKhauMaHoa, 1);
    -- 3) Cập nhật vào bảng TaiKhoanNV
    IF EXISTS (SELECT 1 FROM dbo.TaiKhoanNV WHERE TenDangNhap = @TenDangNhap)
    BEGIN
        UPDATE dbo.TaiKhoanNV
        SET MatKhau = @Hex
        WHERE TenDangNhap = @TenDangNhap;
        PRINT N'Đã cập nhật mật khẩu dạng hex đã mã hóa.';
    END
    ELSE
    BEGIN
        PRINT N'Tên đăng nhập không tồn tại trong TaiKhoanNV.';
    END
END
GO
---Kiểm tra lại đăng nhập được mã hóa chưa
CREATE OR ALTER PROCEDURE dbo.sp_KiemTraDangNhap_TaiKhoanNV_TrucTiep
    @TenDangNhap NVARCHAR(255),
    @MatKhauNhap NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    -- 1) Lấy mật khẩu dạng hex từ bảng
    DECLARE @Hex NVARCHAR(255);

    SELECT @Hex = MatKhau
    FROM dbo.TaiKhoanNV
    WHERE TenDangNhap = @TenDangNhap;
    IF @Hex IS NULL
    BEGIN
        PRINT N'Tài khoản không tồn tại hoặc chưa có mật khẩu mã hóa.';
        RETURN;
    END
-- 2) Đổi hex -> varbinary
DECLARE @Bin VARBINARY(8000) = CONVERT(VARBINARY(8000), @Hex, 1);
-- 3) Giải mã qua function cho đồng bộ
DECLARE @MatKhauGoc NVARCHAR(128) = dbo.GiaiMaMK(@Bin);
    -- 4) So sánh
    IF @MatKhauGoc = @MatKhauNhap
        PRINT N'Đăng nhập thành công.';
    ELSE
        PRINT N'Mật khẩu không đúng.';
END
GO
---Mã hóa hàng loạt mật khẩu của bảng TaiKhoanNV
CREATE OR ALTER PROCEDURE dbo.sp_MaHoaHangLoat_TaiKhoanNV
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TaiKhoanNV
    SET MatKhau = CONVERT(NVARCHAR(255), dbo.MaHoaMK(MatKhau), 1)
    WHERE MatKhau IS NOT NULL
      AND MatKhau NOT LIKE '0x%';
    PRINT N'Đã mã hóa hàng loạt mật khẩu trong TaiKhoanNV.';
END
GO
----Thực thi mã hóa hàng loạt
EXEC dbo.sp_MaHoaHangLoat_TaiKhoanNV;
GO

---Kiểm tra lại đăng nhập
EXEC dbo.sp_KiemTraDangNhap_TaiKhoanNV_TrucTiep
    @TenDangNhap = N'pl_cskh_02',
    @MatKhauNhap = N'PL@2025_CS2';
---Xem lại các mật khẩu đã được mã hóa
SELECT MaTK, TenDangNhap, MatKhau
FROM dbo.TaiKhoanNV;
GO
--- Giải mã 1 tài khoản để kiểm tra hoạt động mã hóa đúng không
SELECT TenDangNhap,
       dbo.GiaiMaMK(CONVERT(varbinary(8000), MatKhau, 1)) AS MatKhauGiaiMa
FROM TaiKhoanNV
WHERE TenDangNhap = 'pl_cskh_01';
GO
----TẠO USER ÁNH XẠ LOGIN-----
-- Tạo USER ánh xạ từ LOGIN nếu chưa tồn tại
CREATE OR ALTER PROCEDURE dbo.sp_TaoUser
    @UserName  SYSNAME,
    @LoginName SYSNAME
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.database_principals
        WHERE name = @UserName
    )
    BEGIN
        DECLARE @sqlCreateUser NVARCHAR(400);

        SET @sqlCreateUser = N'CREATE USER ' + QUOTENAME(@UserName)
                           + N' FOR LOGIN ' + QUOTENAME(@LoginName) + N';';

        EXEC(@sqlCreateUser);
        PRINT N'Đã tạo USER ' + @UserName + N' cho LOGIN ' + @LoginName;
    END
    ELSE
    BEGIN
        PRINT N'USER ' + @UserName + N' đã tồn tại trong database.';
    END
END
GO
-- Quản trị hệ thống
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_admin_01',
    @LoginName = N'pl_admin_01';
GO
-- Quản lý chi nhánh
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_qlcn_01',
    @LoginName = N'pl_qlcn_01';
GO
-- Thu ngân
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_thungan_01',
    @LoginName = N'pl_thungan_01';
GO
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_thungan_02',
    @LoginName = N'pl_thungan_02';
GO
-- Bán hàng
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_sales_ql_01',
    @LoginName = N'pl_sales_ql_01';
GO
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_sales_01',
    @LoginName = N'pl_sales_01';
GO
--CSKH
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_cskh_01',
    @LoginName = N'pl_cskh_01';
GO
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_cskh_02',
    @LoginName = N'pl_cskh_02';
GO
--Kho
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_kho_hcm_01',
    @LoginName = N'pl_kho_hcm_01';
Go
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_kho_hn_01',
    @LoginName = N'pl_kho_hn_01';
GO
-- Marketing
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_mkt_01',
    @LoginName = N'pl_mkt_01';
GO
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_mkt_02',
    @LoginName = N'pl_mkt_02';
GO
-- Kế toán
EXEC dbo.sp_TaoUser
    @UserName  = N'pl_ketoan_01',
    @LoginName = N'pl_ketoan_01';
GO
-- Danh sách user trong DB
SELECT name, type_desc
FROM sys.database_principals
WHERE type IN ('S','U') -- SQL user / Windows user
ORDER BY name;
GO
---Tạo nhóm người dùng-----
CREATE OR ALTER PROCEDURE dbo.sp_PhanQuyenChoRole
    @RoleName SYSNAME,       -- tên ROLE: ROLE_BANHANG, ROLE_KHO,...
    @TenBang  SYSNAME,       -- tên bảng: SanPham, PhieuDatHang,...
    @Quyen    NVARCHAR(100)  -- chuỗi quyền: 'SELECT', 'SELECT, INSERT', ...
AS
BEGIN
    SET NOCOUNT ON;
    -- 1) Nếu ROLE chưa tồn tại thì tạo mới
    IF NOT EXISTS (
        SELECT 1
        FROM sys.database_principals
        WHERE name = @RoleName AND type = 'R'
    )
    BEGIN
        DECLARE @sqlCreateRole NVARCHAR(MAX) =
            N'CREATE ROLE ' + QUOTENAME(@RoleName) + N';';
        EXEC(@sqlCreateRole);
        PRINT N'Đã tạo vai trò: ' + @RoleName;
    END
    ELSE
    BEGIN
        PRINT N'Vai trò ' + @RoleName + N' đã tồn tại.';
    END
    -- 2) Cấp quyền cho ROLE trên bảng chỉ định
    DECLARE @sqlGrant NVARCHAR(MAX);

    SET @sqlGrant = N'GRANT ' + @Quyen +
                    N' ON dbo.' + QUOTENAME(@TenBang) +
                    N' TO ' + QUOTENAME(@RoleName) + N';';
    PRINT @sqlGrant;
    EXEC(@sqlGrant);
END
GO
-- Gán toàn quyền database cho ROLE_ADMIN
-- Tạo ROLE_ADMIN (nếu chưa có) bằng thủ tục chung trên 1 bảng bất kỳ
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_ADMIN', N'ChiNhanh', N'SELECT';
GO
-- Gán toàn quyền database cho ROLE_ADMIN
EXEC sp_addrolemember N'db_owner', N'ROLE_ADMIN';
GO

---ROLE_QLCN
-- Bán hàng
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'PhieuDatHang',        N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'CTPhieuDatHang',      N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'HoaDon',              N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'CTHoaDon',            N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'PhieuGiaoHang',       N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'CTPhieuGiaoHang',     N'SELECT, INSERT, UPDATE';
-- Kho - tồn
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'Kho',                 N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'TonKho',              N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'PhieuXuat',           N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'CTPX',                N'SELECT, INSERT, UPDATE';
-- Khách hàng - thành viên
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'KhachHang',           N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'TheThanhVien',        N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'NganHang',            N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'LoaiKH',              N'SELECT';
-- Khuyến mãi/giá (quản lý được xem)
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'CTKhuyenMai',         N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'CTChuongTrinhKM',     N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'BienDongGia',         N'SELECT';
-- Danh mục
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'SanPham',             N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'LoaiSP',              N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'NhomSP',              N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_QLCN', N'DonViTinh',           N'SELECT';
GO
---ROLE_THUNGAN
-- Bán hàng
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'PhieuDatHang',    N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'CTPhieuDatHang',  N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'HoaDon',          N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'CTHoaDon',        N'SELECT, INSERT, UPDATE';
-- Dữ liệu hỗ trợ bán
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'KhachHang',       N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'TheThanhVien',    N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'SanPham',         N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'BienDongGia',     N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'CTKhuyenMai',     N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_THUNGAN', N'CTChuongTrinhKM', N'SELECT';
GO
----ROLE_BANHANG
-- Danh mục và khuyến mãi
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_BANHANG', N'SanPham',         N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_BANHANG', N'BienDongGia',     N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_BANHANG', N'CTKhuyenMai',     N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_BANHANG', N'CTChuongTrinhKM', N'SELECT';
-- Lập đơn
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_BANHANG', N'PhieuDatHang',    N'SELECT, INSERT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_BANHANG', N'CTPhieuDatHang',  N'SELECT, INSERT';
-- Thông tin khách
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_BANHANG', N'KhachHang',       N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_BANHANG', N'TheThanhVien',    N'SELECT';
GO
----ROLE_CSKH
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_CSKH', N'LoaiKH',        N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_CSKH', N'KhachHang',     N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_CSKH', N'TheThanhVien',  N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_CSKH', N'NganHang',      N'SELECT, INSERT, UPDATE';
-- Xem lịch sử mua
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_CSKH', N'PhieuDatHang',  N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_CSKH', N'HoaDon',        N'SELECT';
GO
----ROLE_KHO
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KHO', N'Kho',        N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KHO', N'TonKho',     N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KHO', N'PhieuXuat',  N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KHO', N'CTPX',       N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KHO', N'SanPham',    N'SELECT';
GO
---ROLE_MARKETING
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_MARKETING', N'CTKhuyenMai',     N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_MARKETING', N'CTChuongTrinhKM', N'SELECT, INSERT, UPDATE';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_MARKETING', N'BienDongGia',     N'SELECT, INSERT, UPDATE';

EXEC dbo.sp_PhanQuyenChoRole N'ROLE_MARKETING', N'SanPham',         N'SELECT';
GO
---ROLE_KETOAN
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KETOAN', N'HoaDon',          N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KETOAN', N'CTHoaDon',        N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KETOAN', N'PhieuDatHang',    N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KETOAN', N'CTPhieuDatHang',  N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KETOAN', N'KhachHang',       N'SELECT';
EXEC dbo.sp_PhanQuyenChoRole N'ROLE_KETOAN', N'TheThanhVien',    N'SELECT';
GO
----Xem lại role  vừa tạo
SELECT
    name AS RoleName,
    type_desc,
    create_date,
    modify_date
FROM sys.database_principals
WHERE type = 'R'
  AND name LIKE 'ROLE[_]%'
ORDER BY create_date DESC;
GO
--Xem phân quyền role
SELECT
    rp.name AS RoleName,
    perm.state_desc,
    perm.permission_name,
    obj.name AS ObjectName,
    obj.type_desc AS ObjectType
FROM sys.database_permissions perm
JOIN sys.database_principals rp
    ON perm.grantee_principal_id = rp.principal_id
LEFT JOIN sys.objects obj
    ON perm.major_id = obj.object_id
WHERE rp.type = 'R'
  AND rp.name LIKE 'ROLE[_]%'
ORDER BY rp.name, obj.name, perm.permission_name;
GO
--Gán người dùng vào role
CREATE OR ALTER PROCEDURE dbo.sp_ThemUserVaoRole
    @UserName SYSNAME,   -- tên USER trong database
    @RoleName SYSNAME    -- tên ROLE trong database
AS
BEGIN
    SET NOCOUNT ON;
    -- 1) Kiểm tra ROLE có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM sys.database_principals
        WHERE name = @RoleName AND type = 'R'
    )
    BEGIN
        PRINT N'ROLE ' + @RoleName + N' không tồn tại. Cần tạo ROLE trước khi gán user.';
        RETURN;
    END
    -- 2) Kiểm tra USER có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM sys.database_principals
        WHERE name = @UserName AND type IN ('S','U','G','E','X') 
)
    BEGIN
        PRINT N'USER ' + @UserName + N' không tồn tại trong database. Cần tạo USER trước khi gán role.';
        RETURN;
    END
    -- 3) Kiểm tra USER đã là member của ROLE chưa
    IF EXISTS (
        SELECT 1
        FROM sys.database_role_members drm
        JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
        JOIN sys.database_principals u ON drm.member_principal_id = u.principal_id
        WHERE r.name = @RoleName AND u.name = @UserName
    )
    BEGIN
        PRINT N'USER ' + @UserName + N' đã thuộc ROLE ' + @RoleName + N'.';
        RETURN;
    END
    -- 4) Thêm USER vào ROLE
    DECLARE @sql NVARCHAR(MAX) =
        N'ALTER ROLE ' + QUOTENAME(@RoleName) +
        N' ADD MEMBER ' + QUOTENAME(@UserName) + N';';
    PRINT @sql;
    EXEC(@sql);
    PRINT N'Đã thêm USER ' + @UserName + N' vào ROLE ' + @RoleName + N'.';
END
GO
----Role Admin
EXEC dbo.sp_ThemUserVaoRole 
    @UserName = N'pl_admin_01',
    @RoleName = N'ROLE_ADMIN';
GO
----Role QLCN
EXEC dbo.sp_ThemUserVaoRole 
    @UserName = N'pl_qlcn_01',
    @RoleName = N'ROLE_QLCN';
GO
----Role Thu Ngân
EXEC dbo.sp_ThemUserVaoRole N'pl_thungan_01', N'ROLE_THUNGAN';
EXEC dbo.sp_ThemUserVaoRole N'pl_thungan_02', N'ROLE_THUNGAN';
GO
----Role Bán hàng
EXEC dbo.sp_ThemUserVaoRole N'pl_sales_01', N'ROLE_BANHANG';
EXEC dbo.sp_ThemUserVaoRole N'pl_sales_02',    N'ROLE_BANHANG';
GO
----Role CSKH
EXEC dbo.sp_ThemUserVaoRole N'pl_cskh_01', N'ROLE_CSKH';
EXEC dbo.sp_ThemUserVaoRole N'pl_cskh_02', N'ROLE_CSKH';
GO
----Role Kho
EXEC dbo.sp_ThemUserVaoRole N'pl_kho_hcm_01', N'ROLE_KHO';
EXEC dbo.sp_ThemUserVaoRole N'pl_kho_hn_01',  N'ROLE_KHO';
GO
----Role Marketing
EXEC dbo.sp_ThemUserVaoRole N'pl_mkt_01', N'ROLE_MARKETING';
EXEC dbo.sp_ThemUserVaoRole N'pl_mkt_02', N'ROLE_MARKETING';
GO
----Role Kế toán
EXEC dbo.sp_ThemUserVaoRole N'pl_ketoan_01', N'ROLE_KETOAN';
GO
---Xem các user đã vào role nào
SELECT
    r.name AS RoleName,
    u.name AS UserName
FROM sys.database_role_members drm
JOIN sys.database_principals r
    ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals u
    ON drm.member_principal_id = u.principal_id
WHERE r.name LIKE 'ROLE[_]%'
ORDER BY r.name, u.name;
GO
---Thu hồi quyền của role
CREATE OR ALTER PROCEDURE dbo.sp_ThuHoiQuyenCuaRole
    @RoleName SYSNAME,        -- tên ROLE trong database
    @TenBang  SYSNAME,        -- tên bảng
    @Quyen    NVARCHAR(200)   -- 'SELECT' hoặc 'SELECT, INSERT',...
AS
BEGIN
    SET NOCOUNT ON;
    -- 1) Kiểm tra ROLE tồn tại
    IF NOT EXISTS (
        SELECT 1
        FROM sys.database_principals
        WHERE name = @RoleName AND type = 'R'
    )
    BEGIN
        PRINT N'ROLE ' + @RoleName + N' không tồn tại trong database.';
        RETURN;
    END
    -- 2) Kiểm tra bảng tồn tại
    IF OBJECT_ID(N'dbo.' + QUOTENAME(@TenBang), N'U') IS NULL
    BEGIN
        PRINT N'Bảng dbo.' + @TenBang + N' không tồn tại.';
        RETURN;
    END
    -- 3) Thu hồi quyền
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'REVOKE ' + @Quyen +
               N' ON dbo.' + QUOTENAME(@TenBang) +
               N' FROM ' + QUOTENAME(@RoleName) + N';';
    PRINT @sql;
    EXEC(@sql);
    PRINT N'Đã thu hồi quyền ' + @Quyen + N' trên ' + @TenBang +
          N' khỏi role ' + @RoleName + N'.';
END
GO
--Kiểm tra quyền trước khi thu hồi
DECLARE @RoleName SYSNAME = N'ROLE_MARKETING';
SELECT
    dp.name AS RoleName,
    o.name  AS TenBang,
    perm.permission_name,
    perm.state_desc
FROM sys.database_permissions perm
JOIN sys.database_principals dp
    ON perm.grantee_principal_id = dp.principal_id
JOIN sys.objects o
    ON perm.major_id = o.object_id
WHERE dp.name = @RoleName
  AND o.name IN (N'CTKhuyenMai', N'CTChuongTrinhKM', N'BienDongGia')
ORDER BY o.name, perm.permission_name;
GO
---Thu hồi quyền
EXEC dbo.sp_ThuHoiQuyenCuaRole N'ROLE_MARKETING', N'BienDongGia', N'INSERT, UPDATE';
GO
---Xem lại sau khi thu hồi
DECLARE @RoleName SYSNAME = N'ROLE_MARKETING';
SELECT
    dp.name AS RoleName,
    o.name  AS TenBang,
    perm.permission_name,
    perm.state_desc
FROM sys.database_permissions perm
JOIN sys.database_principals dp
    ON perm.grantee_principal_id = dp.principal_id
JOIN sys.objects o
    ON perm.major_id = o.object_id
WHERE dp.name = @RoleName
AND o.name IN (N'CTKhuyenMai', N'CTChuongTrinhKM', N'BienDongGia')
ORDER BY perm.permission_name;
GO
---Gỡ user khoải role
CREATE OR ALTER PROCEDURE dbo.sp_GoUserKhoiRole_VoHieuHoa
    @UserName SYSNAME        -- tên USER trong database QLBanHangPhucLong
AS
BEGIN
    SET NOCOUNT ON;
    -- 1. Kiểm tra user có tồn tại trong database hay không
    IF NOT EXISTS (
        SELECT 1 
        FROM sys.database_principals
        WHERE name = @UserName
          AND type IN ('S', 'U')  -- S = SQL user, U = Windows user
    )
    BEGIN
        PRINT N'USER ' + @UserName + N' không tồn tại trong database hiện tại.';
        RETURN;
    END
    PRINT N'Bắt đầu gỡ USER ' + @UserName + N' khỏi các ROLE trong database...';
    -- 2. Gỡ user khỏi tất cả các role đang là thành viên
    DECLARE @RoleName SYSNAME;
    DECLARE curRole CURSOR FAST_FORWARD FOR
        SELECT r.name
        FROM sys.database_role_members drm
        JOIN sys.database_principals r 
             ON drm.role_principal_id = r.principal_id
        JOIN sys.database_principals u 
             ON drm.member_principal_id = u.principal_id
        WHERE u.name = @UserName;
    OPEN curRole;
    FETCH NEXT FROM curRole INTO @RoleName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @sqlDrop NVARCHAR(400);
        -- ALTER ROLE [RoleName] DROP MEMBER [UserName]
        SET @sqlDrop = N'ALTER ROLE ' + QUOTENAME(@RoleName)
                     + N' DROP MEMBER ' + QUOTENAME(@UserName) + N';';
        PRINT @sqlDrop;
        EXEC(@sqlDrop);
        FETCH NEXT FROM curRole INTO @RoleName;
    END
    CLOSE curRole;
    DEALLOCATE curRole;
    PRINT N'Đã gỡ USER ' + @UserName + N' khỏi tất cả các ROLE trong database.';
    -- 3. Tìm LOGIN tương ứng và vô hiệu hóa (DISABLE)
    DECLARE @LoginName SYSNAME;

    SELECT TOP 1 @LoginName = sp.name
    FROM sys.server_principals sp
    JOIN sys.database_principals dp
         ON sp.sid = dp.sid
    WHERE dp.name = @UserName
      AND sp.type_desc = 'SQL_LOGIN';
    IF @LoginName IS NOT NULL
    BEGIN
        DECLARE @sqlDisableLogin NVARCHAR(400);
        -- ALTER LOGIN [LoginName] DISABLE;
        SET @sqlDisableLogin = N'ALTER LOGIN ' + QUOTENAME(@LoginName)
                             + N' DISABLE;';
        PRINT @sqlDisableLogin;
        EXEC(@sqlDisableLogin);
        PRINT N'Đã vô hiệu hóa LOGIN ' + @LoginName 
            + N' tương ứng với USER ' + @UserName + N'.';
    END
    ELSE
    BEGIN
        PRINT N'Không tìm thấy LOGIN SQL tương ứng với USER ' 
            + @UserName 
            + N' (có thể là user Windows hoặc dạng đặc biệt).';
    END
END
GO
---Xem user hiện tại trong role
DECLARE @UserName SYSNAME = N'pl_thungan_01';
SELECT 
    u.name  AS UserName,
    r.name  AS RoleName
FROM sys.database_role_members drm
JOIN sys.database_principals r
     ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals u
     ON drm.member_principal_id = u.principal_id
WHERE u.name = @UserName
ORDER BY r.name;
GO
--Thực thi
EXEC dbo.sp_GoUserKhoiRole_VoHieuHoa N'pl_thungan_01';
GO
---Xem lại còn trong role không
DECLARE @UserName SYSNAME = N'pl_thungan_01';
SELECT 
    u.name  AS UserName,
    r.name  AS RoleName
FROM sys.database_role_members drm
JOIN sys.database_principals r
     ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals u
     ON drm.member_principal_id = u.principal_id
WHERE u.name = @UserName
ORDER BY r.name;
GO
---Kiểm tra login disable chưa
SELECT 
    name        AS LoginName,
    type_desc,
    is_disabled,
    create_date,
    modify_date
FROM sys.server_principals
WHERE name = N'pl_thungan_01';
GO


