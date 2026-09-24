---
document_id: hs-knowledge-payments
title: Hướng dẫn thanh toán và xử lý sự cố
audience: [tenant, landlord]
visibility: public
status: draft
version: 0.1.0
locale: vi-VN
last_reviewed: null
---

# Hướng dẫn thanh toán và xử lý sự cố

HomeSpace hiện hỗ trợ luồng thanh toán chuyển khoản trực tiếp theo thông tin và hướng dẫn hiển thị cho từng yêu cầu thanh toán. Người dùng cần kiểm tra người nhận, số tiền, nội dung chuyển khoản và thời hạn trước khi thực hiện.

Sau khi chuyển tiền, người dùng có thể gửi minh chứng thanh toán qua ứng dụng nếu yêu cầu có hỗ trợ. Bên có trách nhiệm xác nhận sẽ kiểm tra chứng từ và cập nhật trạng thái trên hệ thống. Trạng thái thực tế của khoản thanh toán phải lấy từ API; RAG chỉ giải thích các bước chung.

## Nếu thanh toán có vấn đề

- Nếu đã chuyển tiền nhưng trạng thái chưa đổi, giữ lại chứng từ và kiểm tra lại sau thời gian xử lý được ứng dụng thông báo.
- Nếu nhập sai thông tin, chuyển sai số tiền hoặc giao dịch bị ngân hàng từ chối, liên hệ ngân hàng và kênh hỗ trợ HomeSpace; không tự gửi thêm tiền để “xác minh”.
- Nếu chứng từ bị từ chối, đọc lý do hiển thị, gửi lại chứng từ hợp lệ nếu thao tác được cho phép hoặc liên hệ hỗ trợ.
- Không đăng công khai ảnh chứng từ có số tài khoản, số dư hoặc dữ liệu cá nhân.

HomeSpace là nền tảng hỗ trợ luồng giao dịch, không phải ví điện tử theo thông tin triển khai hiện tại. Không khẳng định HomeSpace đang giữ tiền, đã hoàn tiền hoặc bảo đảm hoàn tiền nếu không có chính sách đã duyệt và dữ liệu giao dịch xác thực.

> Phí, hạn xử lý, quy trình hoàn/hủy và đầu mối giải quyết tranh chấp cần được product owner/finance xác nhận trước khi đưa vào câu trả lời chính thức.
