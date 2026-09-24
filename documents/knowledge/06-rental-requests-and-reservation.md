---
document_id: hs-knowledge-rental-request
title: Yêu cầu thuê và quy trình giữ chỗ
audience: [tenant, landlord]
visibility: public
status: draft
version: 0.1.0
locale: vi-VN
last_reviewed: null
---

# Yêu cầu thuê và quy trình giữ chỗ

## Gửi yêu cầu thuê

Sau khi xem tin và trao đổi các điều kiện, người thuê có thể gửi yêu cầu thuê qua ứng dụng nếu tin và tài khoản đủ điều kiện. Chủ nhà xem yêu cầu rồi chấp nhận hoặc từ chối trong hệ thống. Người thuê có thể hủy yêu cầu khi trạng thái hiện tại cho phép.

## Khi chủ nhà chấp nhận

Việc chấp nhận có thể làm tin chuyển sang trạng thái giữ chỗ trong một khoảng thời gian được cấu hình và khởi tạo bước thanh toán ban đầu. Các yêu cầu khác cho cùng bất động sản có thể bị đóng khi một yêu cầu được chấp nhận. Hệ thống là nguồn xác thực cuối cùng về trạng thái, thời hạn và bước tiếp theo.

Người dùng cần xem kỹ số tiền, mục đích thanh toán và hướng dẫn trên màn hình trước khi chuyển khoản. Yêu cầu thuê chưa đồng nghĩa với hợp đồng đã có hiệu lực hoặc quyền sở hữu/thuê đã hoàn tất.

## Khi yêu cầu hết hạn hoặc bị hủy

Nếu thời hạn giữ chỗ kết thúc hoặc yêu cầu bị hủy, tình trạng bất động sản và khoản tiền liên quan phải được kiểm tra bằng dữ liệu giao dịch hiện hành. AI không được dựa vào tài liệu này để khẳng định một khoản tiền đã được hoàn hay một yêu cầu cụ thể còn hiệu lực.

> Mốc giữ chỗ mặc định hiện được cấu hình khoảng 60 phút trong môi trường đã rà soát; giá trị có thể thay đổi theo cấu hình. Không trả lời một thời hạn cụ thể nếu chưa xác nhận cấu hình production.
