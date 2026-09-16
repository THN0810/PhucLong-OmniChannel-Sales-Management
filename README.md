#  Phúc Long Omnichannel Sales &amp; Loyalty Management System

## Academic Business Analysis (BABOK) &amp; SQL Server Database Engineering Case Study

&gt; **Academic Institution:** University of Finance - Marketing (UFM), Ho Chi Minh City  
&gt; **Coursework Project:** Business Analysis &amp; Database Management Systems (SQL Server)  
&gt; **Author:** Trịnh Hoàng Ngân (Management Information Systems)  
&gt; **Target Enterprise:** Phúc Long Heritage JSC (Phúc Long Coffee &amp; Tea)  
&gt; **Core Focus:** End-to-End Business Analysis (BRD, BPMN, DFD, RTM) &amp; Advanced SQL Server Engineering (T-SQL, Triggers, Views, SPs, RBAC Security).

---

## 📌 Executive Summary

Phúc Long Coffee &amp; Tea is one of Vietnam's leading F&amp;B retail chains. However, as sales expanded across physical POS, proprietary mobile apps, and third-party food delivery platforms (GrabFood, ShopeeFood), the company faced severe operational challenges due to **fragmented systems and manual data reconciliation**.

This case study delivers a comprehensive, enterprise-grade solution comprising two core phases:

1. **Business Analysis (BA):** Formulating an **Omnichannel Order Management System (OMS)** and a **360° Loyalty Program** using BABOK-aligned techniques.
2. **Database Engineering (SQL Server):** Designing and implementing the complete relational database architecture (`QLBanHangPhucLong`) with automated business rule triggers, audit logging, and Role-Based Access Control (RBAC).

\--Image of: --Phuc Long Omnichannel System Architecture

&gt; 📸 **Image Placeholder 01:** *Chèn hình ảnh Sơ đồ Kiến trúc Hệ thống tổng quan (Omnichannel System Architecture Diagram) thể hiện kết nối giữa POS, Mobile App, GrabFood/ShopeeFood và OMS Central Database.*

---

## 🎯 1\. Business Analysis &amp; Requirements Engineering (BABOK Framework)

### 1.1 Business Architecture &amp; Problem Definition

* **AS-IS State:** POS at stores, Mobile App, and Food Delivery partners operate in silos. Daily revenue reconciliation relies heavily on manual Excel exports. Online orders cannot earn loyalty points, leading to customer dissatisfaction.
* **TO-BE Solution:** Centralized Order Management System (OMS) ingesting real-time transactions via 2-way APIs, synchronizing inventory, updating real-time Order Tracking, and driving unified customer loyalty across all touchpoints.

### 1.2 Elicitation &amp; Analysis Techniques Applied

* **BACCM (Business Analysis Core Concept Model):** Evaluated Need, Stakeholders, Change, Solution, Value, and Context.
* **SWOT Analysis:** Assessed brand equity vs. technical debt and partner API dependencies.
* **Requirement Elicitation:** Conducted interviews with POS staff and managers, on-site observation, document analysis of store SOPs, a 60-minute cross-departmental workshop, and a survey of 30 active customers.
* **Customer Journey Map (CJM):** Mapped pain points across offline ordering vs. food delivery apps.

\--Image of: --Customer Journey Map

&gt; 📸 **Image Placeholder 02:** *Chèn hình ảnh Bản đồ Hành trình Khách hàng (Customer Journey Map - CJM) phân tích trải nghiệm và pain-points khi mua hàng tại cửa hàng vs. qua ứng dụng giao hàng.*

### 1.3 Requirements Artifacts (BRD &amp; RTM)

* **25 Functional Requirements (FR-01 to FR-25):** Centralized OMS order ingestion, real-time Order Tracking, multi-channel Loyalty point calculation/redemption, 2-way partner API sync, real-time BI Dashboard, automated financial reports.
* **7 Non-Functional Requirements (NFR-01 to NFR-07):** Order response time $\\le$ 3s, real-time data sync, 24/7 stability with downtime $\\le$ 30 mins/month, BI Dashboard query response $\\le$ 2s, daily automated backups with 2-hour RTO, 30% seasonal surge scalability, and unified UI/UX design.
* **Requirement Traceability Matrix (RTM):** Traced all FRs/NFRs to business goals, stakeholder sources, BPMN swimlanes, and test verification criteria.

### 1.4 Process &amp; Data Modeling

#### 1.4.1 Business Process Modeling (BPMN 2.0)

* **AS-IS Offline &amp; Online Workflows:** Modeled current manual order flow and delivery partner dispatching.
* **TO-BE Omnichannel Workflow:** Modeled automated OMS order routing, real-time stock allocation, and cross-channel loyalty processing.

\--Image of: --BPMN AS-IS Workflows

&gt; 📸 **Image Placeholder 03:** *Chèn hình ảnh Sơ đồ BPMN 2.0 Quy trình Hiện trạng (AS-IS Workflow) tại cửa hàng và ứng dụng đối tác.*

\--Image of: --BPMN TO-BE Omnichannel Workflow

&gt; 📸 **Image Placeholder 04:** *Chèn hình ảnh Sơ đồ BPMN 2.0 Quy trình Cải tiến (TO-BE Omnichannel OMS Workflow) thể hiện các làn xử lý tự động (Automated Swimlanes).*

#### 1.4.2 Data Flow Diagrams (DFD)

* **DFD Context Level:** Defined global system boundary between Customer, POS Staff, Delivery Partners, and Management.
* **DFD Level 0:** Decomposed core processes: Sales Management, Inventory Sync, Loyalty Processing, and Reporting.
* **DFD Level 1:** Detailed process breakdown down to individual data stores (D1 – D13).

\--Image of: --DFD Context Level Diagram

&gt; 📸 **Image Placeholder 05:** *Chèn hình ảnh Sơ đồ Luồng Dữ liệu (DFD) Mức Ngữ cảnh (Context Level Diagram).*

\--Image of: --DFD Level 0 Diagram

&gt; 📸 **Image Placeholder 06:** *Chèn hình ảnh Sơ đồ Luồng Dữ liệu (DFD) Mức 0 (Level 0 Diagram).*

\--Image of: --DFD Level 1 Diagram

&gt; 📸 **Image Placeholder 07:** *Chèn hình ảnh Sơ đồ Luồng Dữ liệu (DFD) Mức 1 (Level 1 Diagram) thể hiện sự tương tác với các kho dữ liệu D1 - D13.*

#### 1.4.3 Data Dictionary (D1 – D13)

Defined schema structures for POS Data (D1), Online Orders (D2), Invoices (D3), Loyalty Profiles (D4), Delivery Records (D5), Partner API Logs (D9), Order ID Mapping (D10), Store KPIs (D11), and Low-Stock Alerts (D12).

---

## 🗄️ 2\. Relational Database Architecture (`QLBanHangPhucLong`)

### 2.1 Database Overview

* **Database Engine:** Microsoft SQL Server 2022
* **Database Name:** `QLBanHangPhucLong`
* **Schema Scale:** **34 Physical Tables** (33 Operational &amp; Entity Tables + 1 System AuditLog Table) structured in 3NF across 7 core domains:  
  1. **Organization &amp; Staff:** `ChiNhanh`, `PhongBan`, `ChucVu`, `NhanVien`, `TaiKhoanNV`, `QuyDinhNghiepVu`.
  2. **Product Catalog &amp; Pricing:** `DonViTinh`, `NhomSP`, `LoaiSP`, `SanPham`, `BienDongGia`.
  3. **Promotions:** `CTKhuyenMai`, `CTChuongTrinhKM`.
  4. **Inventory &amp; Warehouse:** `Kho`, `TonKho`, `PhieuXuat`, `CTPX`.
  5. **Customer &amp; Loyalty:** `LoaiKH`, `KhachHang`, `TheThanhVien`, `NganHang`.
  6. **Sales, Invoicing &amp; Delivery:** `PhieuDatHang`, `CTPhieuDatHang`, `HoaDon`, `CTHoaDon`, `PhieuGiaoHang`, `CTPhieuGiaoHang`.
  7. **RBAC Security &amp; System Audit:** `VaiTroHeThong`, `LoaiDoiTuong`, `DoiTuong`, `LoaiQuyen`, `Quyen`, `PhanQuyen`, `AuditLog`.

\--Image of: --Physical ERD Schema

&gt; 📸 **Image Placeholder 08:** *Chèn hình ảnh Sơ đồ Thực thể Liên kết Vật lý (Physical Entity Relationship Diagram - ERD) thể hiện đầy đủ quan hệ giữa 34 bảng trong SQL Server.*

---

## ⚡ 3\. Advanced T-SQL Engineering &amp; Database Artifacts

### 3.1 Synonyms for Abstraction

Created 20+ Database Synonyms (e.g., `SP` for `SanPham`, `KH` for `KhachHang`, `PDH` for `PhieuDatHang`, `HD` for `HoaDon`, `PX` for `PhieuXuat`, `PGH` for `PhieuGiaoHang`) to simplify T-SQL script writing, speed up DML execution, and abstract underlying table names.

### 3.2 Performance Optimization (Indexing)

* Implemented Non-Clustered Indexes on high-frequency query targets:  
  * `IX_KhachHang_EmailKH` on `KhachHang(EmailKH)`
  * `IX_PhieuDatHang_NgayDatHang` on `PhieuDatHang(NgayDatHang)` with `INCLUDE (MaKH, SoThe, TriGiaDH)`
  * `IX_CTHoaDon_MaSP` on `CTHoaDon(MaSP)` with `INCLUDE (SoLuongHD, ThanhTienHD)`
* Measured execution plan impact using `SET STATISTICS TIME ON` and `SET STATISTICS IO ON`.

### 3.3 Views for Reporting &amp; Analytics

* **Simple Views:** `vw_KhachHang` (Customer Master), `vw_NhanVien_LienHe` (Employee Contacts).
* **Complex Analytical Views:**  
  * `vw_HoaDon_ChiTiet`: Joins Invoices, Line Items, Products, and Customer profiles.
  * `vw_DoanhThu_TheoThang`: Monthly aggregated revenue (Pre-tax and Post-tax).
  * `vw_TopSanPham_BanChay_TheoThang`: Monthly top-selling products by quantity and revenue.

### 3.4 User-Defined Functions (UDFs)

* **Scalar Function:** `dbo.fn_TuoiKhachHang(@MaKH)` – Calculates exact customer age.
* **Inline Table-Valued Functions (ITVF):**  
  * `dbo.fn_SanPham_KemGia(@Ngay)` – Retrieves active product prices as of a specific date using `OUTER APPLY`.
  * `dbo.fn_TonKho_TheoKy(@MaKho, @Thang, @Nam)` – Queries periodic inventory levels.
* **Multi-Statement Table-Valued Functions (MSTVF):**  
  * `dbo.fn_CanhBao_TonThap(@MaKho, @Thang, @Nam, @Nguong)` – Generates low-stock alerts when stock drops below threshold.
  * `dbo.fn_TongHopMuaHang_KhachHang(@TuNgay, @DenNgay)` – Aggregates customer spending and transaction counts.

### 3.5 Stored Procedures &amp; Business Logic

* **Order Ingestion &amp; Validation:** `sp_ThemKhachHang`, `sp_ThemPhieuDatHang` (enforces rule that guest orders cannot attach a loyalty card), `sp_ThemCTPhieuDatHang`.
* **Order Valuation &amp; Invoicing:** `sp_CapNhatTriGiaPhieuDatHang` (recalculates order totals dynamically), `sp_TaoHoaDonTuPhieuDatHang`.
* **Delivery Control:** `sp_ThemCTPhieuGiaoHang_KiemSoatSoLuong` – Strictly validates that cumulative delivered product quantities do not exceed ordered quantities.

---

## 🔒 4\. Business Rules, Audit Logging &amp; Role-Based Access Control (RBAC)

### 4.1 Automated Business Rule Triggers

* `tgr_TheThanhVien_KhongChongLanThoiGian`: Prevents overlapping effective date ranges for loyalty cards belonging to the same customer (`AFTER INSERT, UPDATE`).
* `tgr_TheThanhVien_MotTheHoatDong`: Enforces business constraint restricting each customer to a maximum of **1 active card** (`TrangThaiThe = N'Hoạt động'`).
* `tgr_CTPDH_CapNhatTriGiaDH`: Automatically recalculates and updates `PhieuDatHang.TriGiaDH` whenever order items are inserted, modified, or deleted.

### 4.2 Comprehensive Audit Log System

* Created a central `AuditLog` table capturing `UserName`, `Action` (INSERT/UPDATE/DELETE), and `TimeStamp`.
* Deployed **96 Automated Triggers** (3 triggers per table across all 32 database tables) to track all data mutations.
* Implemented `sp_XemAuditTheoUser` to query user activity history for security audits.

\--Image of: --Audit Log Workflow

&gt; 📸 **Image Placeholder 09:** *Chèn hình ảnh Mô hình Hoạt động Audit Log (Audit Logging System Workflow) ghi nhận tác động dữ liệu qua 96 Triggers.*

### 4.3 Password Encryption &amp; Authentication

* Implemented custom passphrase encryption (`dbo.MaHoaMK`) and decryption (`dbo.GiaiMaMK`) routines using SQL Server's `EncryptByPassPhrase` and `DecryptByPassPhrase` converting binary hashes to hex representation (`NVARCHAR(255)`).
* Procedures `sp_LuuMK_TaiKhoanNV_TrucTiep` and `sp_KiemTraDangNhap_TaiKhoanNV_TrucTiep` handle secure credential storage and verification.

### 4.4 Granular Role-Based Access Control (RBAC)

Configured **8 System Roles** mapping organizational responsibilities to database permissions:

1. `ROLE_ADMIN`: Full Database Control (`db_owner`).
2. `ROLE_QLCN` (Branch Manager): `SELECT, INSERT, UPDATE` on sales, inventory, delivery, and customer tables.
3. `ROLE_THUNGAN` (Cashier): `SELECT, INSERT, UPDATE` on order and invoice processing.
4. `ROLE_BANHANG` (Sales Rep): `SELECT, INSERT` on orders and promotions lookup.
5. `ROLE_CSKH` (Customer Care): `SELECT, INSERT, UPDATE` on customer master and loyalty cards.
6. `ROLE_KHO` (Warehouse): `SELECT, INSERT, UPDATE` on stock levels and inventory issue slips.
7. `ROLE_MARKETING`: `SELECT, INSERT, UPDATE, DELETE` on promotions and price variations.
8. `ROLE_KETOAN` (Accountant): Read-only (`SELECT`) on invoices, orders, and financial reports.

Automated user lifecycle management via stored procedures: `sp_TaoLogin`, `sp_TaoUser`, `sp_PhanQuyenChoRole`, `sp_ThemUserVaoRole`, `sp_ThuHoiQuyenCuaRole`, and `sp_GoUserKhoiRole_VoHieuHoa` (safely revokes role memberships and disables server logins while preserving historical audit data).

\--Image of: --RBAC Permission Matrix

&gt; 📸 **Image Placeholder 10:** *Chèn hình ảnh Ma trận Phân quyền người dùng RBAC (Role-Based Access Control Security Matrix) cho 8 nhóm vai trò hệ thống.*

---

## 📂 5\. Repository Layout

```
PhucLong-Omnichannel-Sales-System/
├── README.md                              &lt;-- Project Overview &amp; Documentation
├── docs/                                  &lt;-- Visual Diagrams &amp; Image Assets
│   └── images/
│       ├── 01-omnichannel-architecture.png
│       ├── 02-customer-journey-map.png
│       ├── 03-bpmn-asis-workflows.png
│       ├── 04-bpmn-tobe-omnichannel.png
│       ├── 05-dfd-context-level.png
│       ├── 06-dfd-level-0.png
│       ├── 07-dfd-level-1.png
│       ├── 08-erd-physical-schema.png
│       ├── 09-audit-log-workflow.png
│       └── 10-rbac-security-matrix.png
├── 01-Business-Analysis/                  &lt;-- BABOK Requirements &amp; Modeling
│   ├── BRD_PhucLong_Sales_System.pdf      &lt;-- Business Requirement Document
│   ├── BPMN_AsIs_vs_ToBe.png              &lt;-- Business Process Models
│   ├── DFD_Context_Level0_Level1.png      &lt;-- Data Flow Diagrams
│   └── Requirement_Traceability_Matrix.xlsx
└── 02-Database-Design/                    &lt;-- SQL Server Database Implementation
    ├── ERD_Physical_Model.png             &lt;-- Relational ERD
    └── QLBanHangPhucLong_FullScript.sql   &lt;-- Unified Master T-SQL Script (Schema, Data, Views, SPs, Triggers, AuditLog &amp; RBAC)

```

---

## 🎓 Academic Attribution

This project was developed as a comprehensive case study for the **Business Analysis** and **SQL Server Database Management System** courses at the **University of Finance - Marketing (UFM)** under the academic guidance of **ThS. Trương Đình Hải Thụy** and **ThS. Trần Minh Tùng**.
