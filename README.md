# Phuc Long Omni-Channel Sales & Loyalty Management System
**Academic Business Analysis & SQL Server Database Design Case Study**

> **Executive Reports:**
> 
> [View BA Project Report (PDF)](./01-Business-Analysis/BA_Report.pdf)
> [View Database Design Report (PDF)](./02-Database-Design/DB_Report.pdf)
> 
> **Database Scripts:** [Explore SQL Source Code](./02-Database-Design/)
> 
> **Academic Institution:** University of Finance - Marketing (UFM), Ho Chi Minh City  
> **Coursework Synthesis:** Business Analysis & Database Management Systems (SQL Server)  
> **Author:** Trinh Hoang Ngan (Management Information Systems)  
> **Case Enterprise:** Phuc Long Heritage JSC (Phuc Long Coffee & Tea)  
> **Core Focus:** Requirements Analysis (BRD, BPMN, DFD, RTM) & SQL Server Database Design (T-SQL, Triggers, Views, SPs, RBAC Security).

---

##  Executive Summary
Executive Summary
This portfolio case study combines two academic projects developed around a **hypothetical omnichannel sales scenario** for Phuc Long Coffee & Tea. 

> ** Academic Disclaimer (Business Assumption):** *This project is a conceptual simulation based on business assumptions and common retail industry pain points. It does not reflect an internal audit of Phuc Long's actual proprietary systems. The operational bottlenecks addressed—such as disconnected POS and online channels (silos), manual data reconciliation, and fragmented loyalty tracking—are hypothetical problems constructed specifically to demonstrate problem-solving capabilities in systems analysis.*

Although both projects share this conceptual business domain, they were developed with different scopes and objectives:
*   **Business Analysis Project:** Focused on customer-facing sales activities across POS, mobile app, and third-party delivery platforms, with emphasis on requirements analysis, business process modeling, and data flow analysis to resolve the assumed omnichannel silos.
*   **SQL Server Database Project:** Extended the business context into a broader operational database scope covering organizational structure, employees, branches, products, inventory, customers, sales, billing, and database access control.

---

##  1. Requirements Analysis & Process Modeling (BABOK Concepts)

### 1.1 Business Architecture & Problem Definition
*   **AS-IS State Analysis:** Identified potential bottlenecks where POS at physical stores, Mobile App, and third-party delivery platforms operate in silos, requiring manual Excel exports for revenue reconciliation and creating inconsistent loyalty tracking across channels.
*   **Proposed TO-BE Architecture:** Designed a conceptual Order Processing model to support transaction integration across sales channels, inventory synchronization, order status tracking, and unified customer loyalty management.

### 1.2 Analysis & Study Techniques Applied
*   **BACCM (Business Analysis Core Concept Model):** Evaluated Need, Stakeholders, Change, Solution, Value, and Context for the proposed transformation.
*   **SWOT Analysis:** Analyzed business strengths, potential weaknesses, and technology-related considerations within the proposed omnichannel scenario.
*   **Analysis Techniques:** Applied document analysis based on publicly available business information and retail process references, along with simulated stakeholder interviews to identify potential business needs.
*   **Customer Journey Map (CJM):** Mapped potential pain points across in-store ordering vs. third-party food delivery apps.

### 1.3 Requirements Artifacts (BRD & RTM)
*   **6 Functional Requirements (FR-01 to FR-06):** Proposed requirements covering centralized order ingestion, order status tracking, cross-channel loyalty calculation, partner API data structures, executive analytics dashboard, and automated financial report generation.
*   **7 Non-Functional Requirements (NFR-01 to NFR-07):** Proposed system targets including order processing response time ≤ 3s, near real-time data sync targets, 24/7 availability targets (≤ 30 mins downtime/month), dashboard query response ≤ 2s, Defined Database Backup Strategy, Scalability requirements for peak hours, and unified UI/UX design guidelines.
*   **Requirement Traceability Matrix (RTM):** Mapped requirements (FRs/NFRs) to business goals, process swimlanes, and test verification criteria.

### 1.4 Process & Data Modeling
*   **BPMN 2.0 Diagrams:** Modeled AS-IS Offline, AS-IS Online, and the proposed TO-BE Omnichannel Workflow.
*   **Data Flow Diagrams (DFD):** Built Context Level DFD, Level 0 DFD, and Level 1 DFDs.
*   **Data Dictionary (D1 – D13):** Defined data structures for POS Data (D1), Online Orders (D2), Invoices (D3), Loyalty Profiles (D4), Delivery Records (D5), Partner API Logs (D9), Order ID Mapping (D10), Store KPIs (D11), and Low-Stock Alerts (D12).

![BPMN TO-BE Workflow](./docs/images/phuclong-bpmn-tobe.png)
> 📸 **Image 01:** TO-BE BPMN 2.0 Process Model unifying POS, App, and Partner API workflows.
> 🔍 **Process Design:** [View High-Res BPMN Diagram](./01-Business-Analysis/)

---

##  2. Key Project Outcomes

| Academic Project | Key Deliverables & Responsibilities |
| :--- | :--- |
| **Business Analysis Project** | • Identified and documented 6 Functional & 7 Non-Functional Requirements across the analyzed sales scope.<br>• Modeled AS-IS & TO-BE workflows using BPMN 2.0, BFD, and DFD (Context, Level 0, Level 1 with 13 Data Stores).<br>• Applied BACCM and prepared a Business Requirements Document (BRD) and Requirement Traceability Matrix (RTM). |
| **Database Management Systems Project** | • Designed a relational database schema with 34 physical tables in SQL Server across the broader operational scope.<br>• Implemented 3 Core Business Triggers and automated audit logging for selected data modifications.<br>• Configured Role-Based Access Control (RBAC) across 8 system roles and implemented user provisioning procedures. |

---

##  3. Relational Database Architecture (QLBanHangPhucLong)

### 3.1 Database Overview
### 3.1 Database Overview
*   **Database Engine:** Microsoft SQL Server 2022
*   **Database Name:** `QLBanHangPhucLong`
*   **Schema Scale:** 34 physical tables (including `AuditLog`) structured across 6 core operational domains:

|  Operational Domain |  Tables Included |
| :--- | :--- |
|  **Org & Personnel** | `ChiNhanh`, `PhongBan`, `ChucVu`, `NhanVien`, `TaiKhoan`, `VaiTro` |
|  **Catalog & Pricing** | `DonViTinh`, `NhomSP`, `LoaiSP`, `SanPham`, `BienDongG` |
|  **Inventory & Warehs** | `Kho`, `TonKho`, `PhieuXuat`, `CTPX` |
|  **Customer & Loyalty** | `LoaiKH`, `KhachHang`, `TheThanhV`, `NganHang` |
|  **Sales & Billing** | `PhieuDat`, `CTPhieuDat`, `HoaDon`, `CTHoaDon`, `PhieuGiao`, `CTPGH` |
|  **Security & Audit** | `AuditLog` |

![Physical ERD Diagram](./docs/images/phuclong-physical-erd.png)
> 📸 **Image 02:** Physical ERD Diagram mapping 34 tables in SQL Server 3NF.
> 💾 **Code Inspection:** [View Master T-SQL Scripts](./02-Database-Design/QLBanHangPhucLong.sql)

---

##  4. Database Implementation

### 4.1 Database Indexing
Implemented Non-Clustered Indexes on high-frequency query targets (`KhachHang`, `PhieuDatHang`, `CTHoaDon`).

### 4.2 Views for Reporting & Analytics
*   **Simple Views:** Customer Master and Employee Contact directories.
*   **Complex Analytical Views:** Monthly aggregated revenue views (pre-tax/post-tax) and monthly top-selling product rankings.

### 4.3 Stored Procedures & Business Logic
Implemented database stored procedures to encapsulate core operational workflows, including customer onboarding, order ingestion, loyalty card validation, dynamic order valuation, invoice generation, and delivery quantity controls.

---

##  5. Business Rules, Audit Logging & Role-Based Access Control (RBAC)

### 5.1 Automated Business Rule Triggers
*   `tgr_TheThanhVien_KhongChongLanThoiGian`: Prevents overlapping effective date ranges for loyalty cards belonging to the same customer.
*   `tgr_TheThanhVien_MotTheHoatDong`: Enforces business constraint restricting each customer to a maximum of 1 active card.
*   `tgr_CTPDH_CapNhatTriGiaDH`: Automatically recalculates order totals whenever line items are updated.

### 5.2 Audit Log System
*   Created a central `AuditLog` table capturing system username, DML action type (INSERT, UPDATE, DELETE), and execution timestamps.
*   Deployed automated logging triggers across core operational tables to capture data modifications into the central audit trail.

### 5.3 Role-Based Access Control (RBAC)
Configured 8 System Roles mapping organizational responsibilities to database access scopes:
*   **ROLE_ADMIN (System Administrator):** System configuration and user account management.
*   **ROLE_QLCN (Branch Manager):** Store operations, sales monitoring, and inventory oversight.
*   **ROLE_THUNGAN (POS Cashier):** Order creation, payment processing, and invoice issuance.
*   **ROLE_BANHANG (Sales Staff):** In-store order intake and promotions lookup.
*   **ROLE_CSKH (Customer Care):** Customer profiles and loyalty program management.
*   **ROLE_KHO (Warehouse Staff):** Stock tracking, inventory receipts, and issue slips.
*   **ROLE_MARKETING (Marketing Officer):** Promotions, campaigns, and price policy management.
*   **ROLE_KETOAN (Accountant):** Financial reconciliation, invoice audits, and sales reporting.

*Note: Implemented stored procedures to support user account and role management.*

---

##  6. Repository Layout

| Directory / File Path | Asset Type | Description & Repository Contents |
| :--- | :--- | :--- |
| `README.md` | Master Documentation | Project overview, BA deliverables, process models & database architecture. |
| `01-Business-Analysis/` | BA Requirements | BRD document, BPMN process models, 2-level DFDs, and Requirement Traceability Matrix (RTM). |
| `02-Database-Design/` | SQL Database | Relational ERD model, database schema initialization, stored procedures, triggers, and RBAC scripts. |

## AI-Assisted Development

AI tools were used as supporting tools during parts of the project, particularly for SQL implementation, debugging, and documentation refinement. The business analysis scope, process models, database structure, and final project outputs were reviewed and adapted by the author.

---

##  7. Potential Enhancements
To build upon the current system design and database implementation, several practical enhancements are identified for future iteration:
*   **Store Staff Mobile Interface:** A mobile-responsive web interface to assist store staff with real-time stock lookups and order verification.
*   **Automated Customer Communications:** Integration with email or Zalo OA messaging gateways to send digital receipts and order status notifications.
*   **Multi-Store & Regional Depot Expansion:** Database schema extension to support multi-depot logistics and inter-branch inventory transfers.
*   **Enhanced Reporting Templates:** Formatted management reporting templates (Excel/PDF) to streamline monthly financial reconciliation.

---

##  Academic Attribution
This project was developed as a case study for the Business Analysis and SQL Server Database Management System courses at the University of Finance - Marketing (UFM) under the academic guidance of ThS. Trương Đình Hải Thụy and ThS. Trần Minh Tùng.
