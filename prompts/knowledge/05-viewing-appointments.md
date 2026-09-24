---
document_id: hs-knowledge-appointments
title: Đặt và quản lý lịch xem nhà
audience: [tenant, landlord]
visibility: public
status: draft
version: 0.1.0
locale: vi-VN
last_reviewed: null
---

# Đặt và quản lý lịch xem nhà

Người thuê chọn tin đăng, xem các khung giờ còn khả dụng và gửi yêu cầu đặt lịch. Chủ nhà có thể xử lý yêu cầu bằng các thao tác được cung cấp, ví dụ chấp nhận, từ chối hoặc đề xuất thời gian khác. Người dùng theo dõi kết quả và lịch hiện tại trong ứng dụng.

## Thay đổi hoặc hủy lịch

Nếu cần đổi hoặc hủy, hãy sử dụng thao tác tương ứng trên lịch hẹn và kiểm tra trạng thái sau khi gửi. Việc đặt lịch chỉ được xác nhận khi hệ thống hiển thị kết quả tương ứng; không coi một lời đề nghị qua chat là lịch đã được xác nhận.

Một lịch có thể tự kết thúc hoặc bị cập nhật nếu tin đăng thay đổi trạng thái. Trạng thái và thời gian cụ thể của lịch hẹn là dữ liệu realtime, cần truy vấn API theo quyền của người dùng.

Trước buổi xem, hai bên nên xác nhận lại thời gian và địa điểm bằng kênh liên lạc phù hợp. Không chuyển tiền chỉ để “giữ lịch” trừ khi có quy trình thanh toán chính thức được hiển thị trên HomeSpace.

> Thời hạn hủy, thời gian tự hết hạn và chính sách vắng mặt cần được product owner xác nhận trước khi công bố.
