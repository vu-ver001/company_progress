# Company Progress Database

Đây là cơ sở dữ liệu **company_progress** dùng cho bài tập nhóm.  
CSDL này quản lý người dùng, dự án, công việc và báo cáo.

## 📌 Các bảng chính
- **NguoiDung**: Lưu thông tin user (Admin, PM, Employee, Director).  
- **DuAn**: Thông tin dự án (ngày bắt đầu, ngày kết thúc, trạng thái).  
- **ThanhVienDuAn**: Liên kết N-N giữa Người dùng và Dự án.  
- **CongViec**: Danh sách công việc, trạng thái, tiến độ (%).  
- **NhatKyCongViec**: Nhật ký cập nhật tiến độ công việc.  
- **BaoCao**: Báo cáo tiến độ, hiệu suất, tổng hợp.  

## 🚀 Hướng dẫn import CSDL vào MySQL Workbench
1. Mở **MySQL Workbench** → kết nối tới server MySQL.  
2. Chọn menu **Server → Data Import**.  
3. Chọn **Import from Self-Contained File** → duyệt chọn `company_progress.sql`.  
4. Ở mục **Default Target Schema** → chọn `company_progress` (hoặc tạo mới).  
5. Bấm **Start Import**.  

Sau khi import thành công, refresh Schemas → bạn sẽ thấy database `company_progress`.  

## 👥 Thành viên nhóm
- Điền danh sách thành viên nhóm tại đây (Tên + MSSV).
