---
document_id: hs-knowledge-search
title: Tìm kiếm và xem tin cho thuê
audience: [tenant, public]
visibility: public
status: draft
version: 0.1.0
locale: vi-VN
last_reviewed: null
---

# Tìm kiếm và xem tin cho thuê

Người thuê có thể duyệt danh sách tin công khai, mở trang chi tiết và sử dụng bộ lọc đang có trên giao diện, chẳng hạn khu vực, loại hình, khoảng giá hoặc tiêu chí tiện ích nếu bộ lọc đó được hiển thị.

Khi so sánh tin, nên xem toàn bộ mô tả, giá thuê, phí dịch vụ, tiện ích, ảnh, khu vực và điều kiện xem nhà. Nội dung do chủ nhà cung cấp cần được xác minh trực tiếp trước khi giao dịch.

Chatbox có thể giúp diễn đạt nhu cầu tìm kiếm thành bộ lọc hoặc giải thích thông tin chung. Danh sách tin phù hợp, giá hiện tại, tình trạng còn trống và thứ tự kết quả phải lấy từ API tìm kiếm; không được tạo tin, giá hoặc tình trạng còn phòng bằng cách truy xuất RAG.

Nếu kết quả không phù hợp, hãy thử nới lỏng khoảng giá, khu vực hoặc tiêu chí tiện ích. Không gửi dữ liệu nhạy cảm vào ô tìm kiếm.

> Tên bộ lọc và thuật toán sắp xếp thay đổi theo giao diện/API; chỉ mô tả các lựa chọn đang được bật trên môi trường tương ứng.
