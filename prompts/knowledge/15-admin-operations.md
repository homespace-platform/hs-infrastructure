---
document_id: hs-knowledge-admin-operations
title: Hướng dẫn vận hành dành cho admin
audience: [admin]
visibility: admin
status: draft
version: 0.1.0
locale: vi-VN
last_reviewed: null
---

# Hướng dẫn vận hành dành cho admin

> **TÀI LIỆU NỘI BỘ — CHỈ DÀNH CHO ADMIN ĐƯỢC PHÂN QUYỀN.** Không truy xuất hoặc trích dẫn tài liệu này trong hội thoại người thuê/chủ nhà.

## Phạm vi vận hành đã có trong hệ thống

Admin portal hiện có các luồng quản lý người dùng và quyền, duyệt tin đăng, quản lý nội dung tin tức và quản lý mẫu/quy trình hợp đồng. Quyền thao tác cụ thể phụ thuộc role và authorities được Gateway xác minh.

## Nguyên tắc xử lý

- Mở đúng hồ sơ qua giao diện admin và kiểm tra trạng thái hiện tại trước khi thao tác.
- Ghi rõ căn cứ và lý do khi duyệt, từ chối, ẩn hoặc thay đổi nội dung.
- Chỉ thao tác trong phạm vi quyền được cấp; không chia sẻ dữ liệu người dùng ra ngoài mục đích hỗ trợ/vận hành.
- Với tranh chấp thanh toán, khiếu nại, yêu cầu dữ liệu cá nhân hoặc trường hợp nghi ngờ gian lận, chuyển đúng đầu mối có thẩm quyền theo runbook đã ban hành.
- Không xem câu trả lời của AI là quyết định kiểm duyệt hay bằng chứng; admin chịu trách nhiệm kiểm tra dữ kiện từ hệ thống.

## Nội dung cần bổ sung

Quy trình kiểm duyệt chi tiết, ma trận quyền, lý do xử lý chuẩn, quy trình khiếu nại, escalation contact, SLA nội bộ, xử lý sự cố và audit log cần được đội vận hành cung cấp. Không đưa bí mật, mật khẩu, token, khóa ký hoặc dữ liệu cá nhân mẫu vào tài liệu RAG.

> Khi triển khai retrieval, bắt buộc lọc `visibility: admin` theo quyền người dùng trước khi tìm kiếm/trả context cho model. Không chỉ dựa vào prompt để ngăn lộ nội dung.
