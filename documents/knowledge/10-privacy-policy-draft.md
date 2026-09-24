---
document_id: hs-policy-privacy
title: Chính sách quyền riêng tư HomeSpace (bản đề xuất)
audience: [tenant, landlord, public]
visibility: public
status: draft
version: 0.1.0
locale: vi-VN
last_reviewed: null
---

# Chính sách quyền riêng tư HomeSpace — Bản đề xuất

> **BẢN NHÁP PHÁT TRIỂN — CHƯA BAN HÀNH.** Đây là khung nội dung để phát triển và kiểm tra RAG, không phải thông báo xử lý dữ liệu chính thức. Cần đối chiếu luồng dữ liệu thực tế, nhà cung cấp và yêu cầu pháp lý trước khi công bố.

## 1. Dữ liệu có thể được xử lý

Tùy tính năng, hệ thống có thể xử lý thông tin tài khoản/hồ sơ, liên hệ, địa chỉ, giấy tờ xác minh, tin đăng, lịch hẹn, yêu cầu thuê, thanh toán, hợp đồng, tin nhắn, tệp đính kèm và dữ liệu kỹ thuật cần thiết để vận hành/bảo vệ dịch vụ.

## 2. Mục đích sử dụng

Đề xuất mục đích gồm tạo và bảo vệ tài khoản, cung cấp tính năng, kết nối người thuê với chủ nhà, xử lý yêu cầu, hỗ trợ giao dịch/hợp đồng, hỗ trợ khách hàng, ngăn chặn gian lận và duy trì an toàn hệ thống. Mỗi mục đích cần được ánh xạ với dữ liệu và căn cứ xử lý tương ứng.

## 3. Chia sẻ với nhà cung cấp

Một số chức năng có thể sử dụng nhà cung cấp hạ tầng hoặc tích hợp như xác minh danh tính, lưu trữ tệp, gửi OTP và ký điện tử. Cần công bố đúng nhà cung cấp, loại dữ liệu chia sẻ, vị trí xử lý và trách nhiệm của từng bên sau khi xác minh kiến trúc triển khai.

## 4. Lưu trữ, bảo mật và quyền của người dùng

Đề xuất công bố thời hạn lưu trữ theo từng nhóm dữ liệu, biện pháp bảo vệ, cách yêu cầu truy cập/chỉnh sửa/xóa hoặc rút lại lựa chọn khi áp dụng, cũng như kênh liên hệ về quyền riêng tư. Không hứa thời hạn lưu hay quyền xử lý cụ thể trước khi xác nhận khả năng của hệ thống và quy định áp dụng.

## 5. Dùng dữ liệu cho AI

Đề xuất: kho RAG dùng chung chỉ chứa tài liệu hệ thống đã được kiểm duyệt và không chứa hồ sơ cá nhân, giao dịch, chat riêng hoặc hợp đồng của người dùng. Câu hỏi về dữ liệu cá nhân cần gọi API nghiệp vụ có phân quyền. Nếu có xử lý tài liệu người dùng bằng AI, cần mô tả riêng mục đích, phạm vi truy cập, lưu trữ và cách xóa.

## 6. Mục cần xác nhận

Hoàn thiện danh mục dữ liệu thật; mục đích/căn cứ; bên nhận dữ liệu; lưu trữ và xóa; chuyển dữ liệu xuyên biên giới (nếu có); quyền của chủ thể dữ liệu; trẻ vị thành niên (nếu liên quan); cookie/analytics; xử lý sự cố; đầu mối phụ trách; phiên bản và ngày hiệu lực.
