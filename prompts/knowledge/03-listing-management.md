---
document_id: hs-knowledge-listing-management
title: Hướng dẫn tạo và quản lý tin đăng
audience: [landlord]
visibility: public
status: draft
version: 0.1.0
locale: vi-VN
last_reviewed: null
---

# Hướng dẫn tạo và quản lý tin đăng

## Tạo tin

Chủ nhà tạo tin bằng cách chọn loại hình được hệ thống hỗ trợ, nhập thông tin bất động sản, giá thuê, tiện ích và các khoản phí, thêm hình ảnh phù hợp, sau đó gửi tin để xử lý theo luồng trên ứng dụng. Các loại hình đang được hỗ trợ cần được đọc từ danh mục hiện hành; không tự khẳng định những loại hình không xuất hiện trong biểu mẫu.

Hãy mô tả chính xác địa chỉ, diện tích, giá, tiện ích, tình trạng nội thất, khoản phí phát sinh và điều kiện xem nhà. Chỉ tải lên hình ảnh mà bạn có quyền sử dụng và không chứa thông tin cá nhân của người khác.

## Trạng thái tin

Tin có thể ở các trạng thái như bản nháp, chờ duyệt, đã đăng, đã đặt chỗ/đang xử lý yêu cầu thuê, đã cho thuê, hết hạn, bị từ chối, bị ẩn hoặc cần xử lý vi phạm. Tên trạng thái và thao tác khả dụng phụ thuộc vào trạng thái thực tế của tin.

Nếu tin bị từ chối hoặc ẩn, hãy đọc lý do hiển thị trong ứng dụng, sửa nội dung liên quan và gửi lại nếu luồng cho phép. AI chỉ được giải thích hướng dẫn chung; lý do và trạng thái của tin cụ thể phải lấy từ API.

## Quản lý sau khi đăng

Chủ nhà nên cập nhật tin khi giá, tình trạng phòng, tiện ích hoặc khả năng xem nhà thay đổi. Khi bất động sản không còn cho thuê, hãy cập nhật trạng thái theo chức năng hiện có để tránh người thuê tiếp tục gửi yêu cầu.

> Các trường bắt buộc, giới hạn ảnh, thời hạn tin và quy tắc sửa tin cần được đồng bộ với validation của API trước khi tài liệu được duyệt.
