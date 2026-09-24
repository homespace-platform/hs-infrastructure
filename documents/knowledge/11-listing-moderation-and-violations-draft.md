---
document_id: hs-policy-moderation
title: Chính sách kiểm duyệt tin và xử lý vi phạm (bản đề xuất)
audience: [tenant, landlord, admin]
visibility: public
status: draft
version: 0.1.0
locale: vi-VN
last_reviewed: null
---

# Chính sách kiểm duyệt tin và xử lý vi phạm — Bản đề xuất

> **BẢN NHÁP PHÁT TRIỂN — CHƯA BAN HÀNH.** Các nhóm vi phạm và biện pháp bên dưới chỉ là khung để thiết kế sản phẩm. Mức xử lý, thời hạn, tiêu chuẩn chứng cứ và cơ chế khiếu nại phải được HomeSpace phê duyệt.

## Nguyên tắc đề xuất

Quy trình kiểm duyệt nên áp dụng tiêu chí nhất quán, lưu lý do xử lý và cho phép người đăng biết bước tiếp theo. Biện pháp nên tương ứng với mức độ và tính lặp lại của hành vi; trường hợp khẩn cấp có thể cần giới hạn nội dung trong khi xem xét.

## Nhóm nội dung cần xem xét

- Thông tin giá, địa chỉ, diện tích hoặc tiện ích có dấu hiệu sai lệch.
- Hình ảnh không đại diện cho bất động sản, không có quyền sử dụng hoặc chứa thông tin nhạy cảm của bên thứ ba.
- Bất động sản không có quyền cho thuê hoặc nội dung mạo danh.
- Tin trùng lặp, hết khả năng cho thuê nhưng không cập nhật, hoặc dùng nội dung để dẫn dụ chuyển tiền ngoài thông tin thỏa thuận.
- Nội dung phân biệt đối xử, đe dọa, lừa đảo, spam hoặc vi phạm quyền của người khác.

## Biện pháp xử lý đề xuất

Yêu cầu chỉnh sửa; từ chối hoặc ẩn tin; hạn chế một chức năng; chuyển hồ sơ cho admin xem xét thêm. Không tự khẳng định tài khoản đã bị khóa hay một tin cụ thể đang vi phạm nếu chưa truy vấn dữ liệu và quyết định kiểm duyệt thực tế.

## Khiếu nại

Người đăng có thể gửi yêu cầu xem xét lại kèm mã tin và thông tin giải thích qua kênh hỗ trợ. Cần ban hành thời hạn tiếp nhận, cấp xem xét, loại chứng cứ và thời hạn phản hồi trước khi thông báo như cam kết.

## Hướng dẫn cho Agent

Giải thích tiêu chí chung bằng ngôn ngữ trung lập; không phán xét người dùng. Với câu hỏi về một quyết định cụ thể, truy vấn trạng thái/lý do qua API được phân quyền hoặc chuyển admin. Tài liệu vận hành chi tiết cho admin phải đặt ở tài liệu có `visibility: admin` riêng.
