# BỘ ĐẶC TẢ VÀ PROMPT TẠO MẪU HỢP ĐỒNG HOMESPACE (SCHEMA V3)

Tài liệu này là đặc tả chuẩn hóa (Contract Schema V3) để tạo ba mẫu hợp đồng Word (.docx) cho nền tảng HomeSpace. Mỗi mẫu gắn liền với một loại bất động sản cụ thể và sử dụng công nghệ tạo tài liệu [poi-tl](https://github.com/Sayi/poi-tl).

> **LƯU Ý PHÁP LÝ QUAN TRỌNG:**
> Các mẫu hợp đồng và prompt trong tài liệu này được thiết kế để chuẩn hóa luồng nghiệp vụ giao dịch bất động sản trực tuyến. Tài liệu **không** tuyên bố là "được chứng nhận bởi luật sư" hoặc thay thế tư vấn pháp lý chính thức. Đặc biệt, điều khoản chấm dứt do quá hạn 5 ngày và ghi nhận toàn bộ cọc cho chủ nhà phải được luật sư rà soát với [Điều 172 Luật Nhà ở 2023](https://vbpl.moj.gov.vn/hanam/Pages/vbpq-toanvan.aspx?ItemID=169032&Keyword=) và tình huống thực tế trước khi đưa vào Production; prompt không được khẳng định điều khoản này mặc nhiên đủ căn cứ cưỡng chế thu hồi nhà.

---

## I. QUY ƯỚC CHUNG VÀ QUY TẮC BẤT BIẾN

### 1. Phạm vi ba mẫu hợp đồng
Hệ thống sử dụng đúng 3 mẫu hợp đồng chuẩn:
1. **Hợp đồng thuê nhà nguyên căn** (`HOUSE`): Dành cho nhà riêng lẻ, nhà phố, biệt thự.
2. **Hợp đồng thuê căn hộ chung cư** (`APARTMENT`): Dành cho căn hộ trong chung cư hoặc tòa nhà phức hợp.
3. **Hợp đồng thuê phòng trọ** (`ROOM`): Dành cho phòng trọ trong dãy trọ hoặc căn hộ dịch vụ chia phòng.

Tên file xuất ra bắt buộc:
- `HomeSpace_01_Hop_Dong_Thue_Nha_Nguyen_Can.docx`
- `HomeSpace_02_Hop_Dong_Thue_Can_Ho_Chung_Cu.docx`
- `HomeSpace_03_Hop_Dong_Thue_Phong_Tro.docx`

### 2. Quy tắc về Chi nhánh (PropertyBranch) - TUYỆT ĐỐI KHÔNG ĐƯA VÀO HỢP ĐỒNG
- Listing có thể thuộc một chi nhánh hoặc là tài sản độc lập. Chi nhánh chỉ là nguồn dữ liệu nội bộ.
- **NGHIÊM CẤM** đưa các thông tin sau vào văn bản hợp đồng:
  - `branchId`, mã chi nhánh, tên chi nhánh (ví dụ: "Chi nhánh A", "Tòa nhà Parkview").
  - Tổng số căn của chi nhánh, tổng sức chứa bãi xe của chi nhánh.
  - Không tạo placeholder dạng `{{property.branchName}}` hay tương tự.
- Dữ liệu địa chỉ, tiện ích, nội quy phải được giải quyết thành giá trị thực tế của tài sản bàn giao.

### 3. Quy tắc về Chuyển khoản trực tiếp giữa Chủ nhà và Người thuê
- HomeSpace KHÔNG phải ví điện tử, KHÔNG phải cổng thanh toán, KHÔNG nhận tiền, KHÔNG giữ tiền và KHÔNG tự động xác nhận giao dịch ngân hàng.
- Tiền luôn chuyển trực tiếp giữa hai bên:
  - Người thuê $\rightarrow$ tài khoản ngân hàng chủ nhà (tiền thuê, tiền cọc, chi phí).
  - Chủ nhà $\rightarrow$ tài khoản ngân hàng người thuê khi hoàn cọc/hoàn tiền.
- Hợp đồng ghi rõ tài khoản ngân hàng của cả hai bên theo snapshot giao dịch tại thời điểm xác nhận:
  - **Bên A (Nhận thanh toán):** Chủ tài khoản: `{{landlord.bankAccountHolder}}`, Số tài khoản: `{{landlord.bankAccountNumber}}`, Ngân hàng: `{{landlord.bankName}}`.
  - **Bên B (Nhận hoàn trả/hoàn cọc):** Chủ tài khoản: `{{tenant.bankAccountHolder}}`, Số tài khoản: `{{tenant.bankAccountNumber}}`, Ngân hàng: `{{tenant.bankName}}`.
- Bắt buộc đưa đầy đủ 7 điều khoản pháp lý về chuyển khoản trực tiếp vào hợp đồng:
  1. **Phương thức thanh toán:** "Bên B thanh toán tiền thuê, tiền đặt cọc và các khoản phải trả khác bằng hình thức chuyển khoản trực tiếp vào tài khoản do Bên A chỉ định trong Hợp đồng này hoặc tài khoản thay thế được hai bên xác nhận bằng văn bản hoặc thông điệp dữ liệu."
  2. **Vai trò HomeSpace:** "HomeSpace cung cấp công cụ tính toán khoản phải trả, tạo thông tin VietQR, lưu trữ yêu cầu thanh toán và ghi nhận trạng thái do các bên khai báo. HomeSpace không nhận tiền, không giữ tiền, không chuyển tiền thay các bên và không thay thế ngân hàng xác nhận việc ghi Có hoặc ghi Nợ trên tài khoản."
  3. **Xác nhận hai chiều:** "Một khoản thanh toán được ghi nhận hoàn tất trên HomeSpace sau khi Bên B khai báo đã thực hiện chuyển khoản và Bên A xác nhận đã nhận đủ số tiền tương ứng. Việc ghi nhận này được lập trên cơ sở xác nhận của các bên và không phải là xác nhận giao dịch do ngân hàng phát hành."
  4. **Trách nhiệm kiểm tra:** "Bên B có trách nhiệm kiểm tra tên chủ tài khoản, số tài khoản, ngân hàng thụ hưởng, số tiền và nội dung chuyển khoản trước khi thực hiện. Bên A có trách nhiệm kiểm tra tài khoản nhận và xác nhận trung thực trạng thái nhận tiền."
  5. **Sai lệch/tranh chấp:** "Trường hợp thông tin khai báo giữa các bên không thống nhất, khoản thanh toán được chuyển sang trạng thái chờ đối soát. Các bên có trách nhiệm cung cấp chứng từ ngân hàng và phối hợp xác minh; HomeSpace chỉ lưu trữ thông tin, chứng từ và lịch sử xác nhận do các bên cung cấp."
  6. **Thay đổi tài khoản:** "Mọi thay đổi tài khoản nhận thanh toán hoặc tài khoản nhận hoàn trả chỉ có hiệu lực đối với nghĩa vụ phát sinh sau khi bên còn lại đã nhận được và xác nhận thông báo thay đổi. Việc thay đổi tài khoản trên hồ sơ HomeSpace không tự động sửa đổi phiên bản hợp đồng đang có hiệu lực."
  7. **Hoàn cọc:** "Khi chấm dứt hoặc hết hạn hợp đồng, sau khi hai bên hoàn tất bàn giao và quyết toán, Bên A chuyển khoản số tiền cọc còn phải hoàn trực tiếp vào tài khoản nhận hoàn trả của Bên B ghi trong Hợp đồng hoặc tài khoản khác được hai bên xác nhận. Việc hoàn cọc được ghi nhận hoàn tất sau khi Bên A khai báo đã chuyển và Bên B xác nhận đã nhận đủ tiền."

### 4. Quy tắc về Tiện ích dùng chung và Thú cưng
- **Tiện ích dùng chung**: Không được diễn đạt thành cam kết vận hành liên tục tuyệt đối. Phải ghi rõ nguyên tắc:
  > *"Đối với tiện ích dùng chung (nếu có), Bên B được quyền sử dụng các tiện ích chung theo nội quy, khung giờ và tình trạng vận hành của đơn vị quản lý."*
- **Nuôi thú cưng (`PETS_ALLOWED`)**: Thể hiện quyền nuôi, điều kiện tuân thủ nội quy, Bên B chịu hoàn toàn trách nhiệm về vệ sinh, tiếng ồn và bồi thường thiệt hại. Không tự bịa thêm phụ phí, giống loài hay tiền cọc thú cưng khi hệ thống chưa có dữ liệu.

### 5. Quy tắc phân biệt Tiện ích (Amenities) và Thiết bị/Nội thất (Equipments)
- Máy lạnh, máy giặt, tủ lạnh, máy nước nóng, giường, tủ, bàn ghế... được xếp vào Bảng tài sản bàn giao (`#equipmentTable`).
- Bảng tiện ích (`#amenitiesTable`) chỉ phản ánh quyền sử dụng không gian và dịch vụ đi kèm (Wifi, thang máy, bảo vệ, hồ bơi, giờ giấc tự do...).

### 6. Quy tắc kỹ thuật tạo file Word (Tránh lỗi poi-tl)
- Tất cả placeholder phải nằm trọn vẹn trong **một Word run**. Nếu gõ trong Word bị ngắt định dạng, hãy xóa và gõ lại liền mạch hoặc dán dạng Plain Text.
- Không dùng dấu chấm thủ công (ví dụ: `Họ tên: ....................`).
- Không tạo placeholder ngoài danh mục 63 trường được hỗ trợ.

### 7. Quy tắc hóa đơn hàng tháng, quá hạn và chấm dứt — áp dụng cho cả ba mẫu
- `{{contract.signingDate}}` là **ngày ký**; `{{lease.startDateText}}` là **ngày bắt đầu kỳ thuê/chu kỳ hóa đơn**. Không tự coi hai ngày này là một; nếu nghiệp vụ muốn trùng ngày thì phải nhập cùng ngày ở dữ liệu nguồn. Kỳ thuê chạy từ ngày bắt đầu đến trước cùng ngày tháng kế tiếp; ngày cuối in tại `{{lease.endDateText}}` là ngày cuối cùng của toàn thời hạn thuê.
- Khoản thanh toán ban đầu gồm tiền thuê kỳ đầu và tiền cọc (nếu có). Không ghi rằng phí điện, nước và dịch vụ cuối kỳ đã được thanh toán nếu bảng xác nhận ban đầu không thể hiện. Từ hóa đơn cuối kỳ đầu tiên trở đi: quyết toán phí cố định/điện/nước/phát sinh của kỳ vừa kết thúc **và tiền thuê của kỳ kế tiếp**, nếu kỳ kế tiếp còn nằm trong thời hạn hợp đồng. Kỳ cuối chỉ quyết toán chi phí, không thu tiền thuê vượt thời hạn. Không thu lại tiền thuê kỳ đầu đã trả ban đầu.
- Hạn thanh toán phải dùng nguyên văn `{{rent.paymentDueDay}}` (backend hiện tính chậm nhất 23:59 ngày thứ 4 sau khi kết thúc từng kỳ thuê, theo giờ Việt Nam). **Không** hard-code “ngày 01”, “ngày 05 hằng tháng” hoặc suy từ ngày ký. Chủ nhà có thể chốt chỉ số và phát hành hóa đơn ngay khi dữ liệu kỳ đã đầy đủ; người thuê được xem và thanh toán ngay. Không viết rằng người thuê bắt buộc đợi job tự phát hành lúc 10:00.
- Chỉ số điện/nước cuối kỳ và khoản phát sinh theo sử dụng thực tế được quyết toán trên hóa đơn; đơn giá và cách tính lấy từ `{{#chargesTable}}`. Không cộng số ước tính vào khoản thanh toán ban đầu. Phí gửi xe phụ thuộc số xe đăng ký và biểu phí trong bảng; không tự bịa mức phí.
- Phí chậm thanh toán có thể **không áp dụng**, **một lần** hoặc **mỗi ngày trễ** theo cấu hình chủ nhà đã chốt trước khi ký. Số tiền/cách tính và ngày bắt đầu tính thực tế do backend nối vào `{{contract.specialTerms}}`; không viết cứng “100.000 đ/ngày”, tiền thuê một ngày, số ngày ân hạn hoặc một trần phạt tự nghĩ ra. Phí được ghi riêng trên hóa đơn quá hạn; khi người thuê báo chuyển khoản thì tạm dừng cập nhật để đối soát.
- Từ 00:00 **ngày quá hạn thứ 5** theo giờ Việt Nam, HomeSpace mở lựa chọn cho chủ nhà, **không tự động** chấm dứt: (1) cho chuyển công nợ và phí phạt đã chốt sang hóa đơn kỳ tiếp theo nếu còn kỳ; phí phạt của khoản chuyển dừng tăng và khoản cũ chỉ được cộng **một lần**; hoặc (2) đề nghị hai bên chấm dứt sớm. Nếu người thuê đồng ý, chủ nhà xác nhận đã nhận lại phòng và tài sản rồi mới hoàn tất. Nếu người thuê từ chối, hợp đồng vẫn hiệu lực, tin đăng chưa mở lại, cọc chưa chuyển chủ; chủ nhà có thể rút đề nghị hoặc thực hiện nhánh chấm dứt theo điều khoản **đã nằm trong bản ký**, sau khi thông báo và thực tế nhận lại phòng/chìa khóa/tài sản. Chỉ khi hoàn tất bàn giao hệ thống mới đổi trạng thái hợp đồng, cọc và tin đăng. Công nợ chưa thanh toán vẫn được theo dõi riêng; HomeSpace không tự thu tiền hoặc cưỡng chế thu hồi.
- `{{contract.specialTerms}}` là **một khối duy nhất** gồm điều khoản quá hạn/chấm dứt lưu trong revision và điều khoản phí chậm trả do backend sinh từ cấu hình. Đặt placeholder này **đúng một lần** trong Điều xử lý vi phạm/chấm dứt của mỗi DOCX; không đặt thêm ở Điều thú cưng/nội quy, không sao chép nguyên văn điều khoản này lần hai, không tách hoặc tự thay thế bằng `{{...}}` khác. Nếu người soạn sửa/xóa câu điều khoản 5 ngày ở bản nháp, backend sẽ không cho dùng nhánh chấm dứt theo điều khoản đó.
- `{{rent.amountNumber}}` đã có đơn vị `/tháng`; `{{deposit.amountNumber}}` và các tổng tiền đã có `VNĐ`. Không nối thêm `VNĐ/tháng` hoặc `VNĐ` phía sau placeholder khiến hợp đồng bị lặp đơn vị.
- Các nội dung chấm dứt sau 5 ngày và ghi nhận toàn bộ cọc cho chủ nhà là điều khoản sản phẩm cần rà soát pháp lý trước khi dùng thực tế; **không khẳng định** chỉ cần hai bên ký là có thể tự cưỡng chế lấy lại nhà. Luật Nhà ở 2023 có quy định riêng về căn cứ đơn phương chấm dứt do không trả tiền thuê. Chuyên gia pháp lý cần đối chiếu Điều 172, nghĩa vụ thông báo và chứng cứ bàn giao trước khi phát hành bản chính thức.

### 8. Quy chuẩn trình bày chuyên nghiệp và tương thích luồng ký SMARTCA
- Khổ giấy A4 dọc; lề trái/phải 2,5 cm, lề trên 3 cm, lề dưới 2,5 cm. Đặt Header/Footer cách mép giấy 1,25 cm để phần đầu trang không chạm Quốc hiệu.
- Header chạy trang chỉ là dòng nhận diện nhỏ, màu xám nhạt, cỡ 8–9 pt, căn phải và nằm trong vùng Header của Word. Không đặt Quốc hiệu, tiêu ngữ hoặc tên hợp đồng trong Header. Nội dung đầu trang phải bắt đầu thấp hơn Header tối thiểu 1 cm.
- Trình bày Quốc hiệu và tiêu ngữ ở đầu phần thân trang thứ nhất, căn giữa. Dành khoảng cách sau tiêu ngữ 10–12 pt; sau đó mới đến tên hợp đồng. Tên hợp đồng viết hoa, đậm, căn giữa, cỡ 16 pt; dòng số hợp đồng/ngày ký cỡ 11–12 pt và có khoảng cách rõ ràng với phần căn cứ pháp lý.
- Toàn văn dùng Times New Roman; thân bài 12 pt, giãn dòng 1,15, căn đều hai lề; khoảng cách sau đoạn 4 pt. Tiêu đề điều khoản 13 pt đậm, cách đoạn trước 8 pt và sau 4 pt. Không giảm cỡ chữ dưới 10 pt để ép nội dung vừa trang.
- Tạo khoảng cách bằng thiết lập Paragraph/Line Spacing, không chèn nhiều dòng trống, nhiều dấu cách hoặc Tab để căn chỉnh. Không dùng căn đều kiểu Distributed, hộp văn bản, cột, hình/shape trang trí hoặc bảng lồng để dàn trang.
- Giữ tiêu đề điều khoản đi cùng đoạn nội dung kế tiếp; không ngắt hàng bảng giữa hai trang nếu Word cho phép, lặp lại hàng tiêu đề của bảng khi bảng sang trang. Các bảng động phải có độ rộng cột hợp lý, nội dung không tràn lề.
- Không chèn ngắt trang tùy tiện giữa các điều, không để một tiêu đề đứng lẻ ở cuối trang, không tạo trang trắng hoặc một trang cuối chỉ có vài dòng. Tự kiểm tra bố cục sau khi xuất DOCX/PDF.
- **Quy tắc ký SMARTCA:** Backend HomeSpace hiện tự nối một trang ký A4 vào cuối PDF khi dùng chế độ `SMARTCA`; backend tự đặt vùng ký tại tọa độ cố định trên trang cuối, không tìm theo placeholder/văn bản trong DOCX. Vì vậy **không tạo mục “Chữ ký các bên”, không tạo trang ký, khung ký, dòng chấm ký hoặc placeholder chữ ký trong DOCX**. Kết thúc mẫu sau điều khoản hiệu lực. Không tự thêm trang ký vì sẽ tạo trang ký trùng trong PDF.
- Không thay đổi tên, cú pháp hoặc cách viết placeholder; mỗi placeholder vẫn phải nằm trọn trong một Word run để poi-tl thay thế chính xác.

---

## II. DANH MỤC 63 MÃ TRƯỜNG VÀ BẢNG ĐỘNG ĐƯỢC HỖ TRỢ (SCHEMA V3)

### 1. Nhóm Pháp lý & Hợp đồng
| Mã trường | Bắt buộc | Mô tả & Ý nghĩa |
|---|:---:|---|
| `{{contract.number}}` | Có | Số hợp đồng theo định dạng hệ thống (ví dụ: `HDT-2026-00123`) |
| `{{contract.signingDate}}` | Có | Ngày ký hợp đồng (định dạng `dd/MM/yyyy`) |
| `{{contract.signingCity}}` | Không | Tỉnh/thành phố nơi xác lập hợp đồng |
| `{{contract.schemaVersion}}` | Không | Phiên bản schema dữ liệu hợp đồng (`3`) |
| `{{contract.revisionNumber}}` | Không | Số hiệu bản sửa đổi hiện tại (`1, 2, ...`) |
| `{{contract.specialTerms}}` | Không | Điều khoản quá hạn/chấm dứt của revision cộng điều khoản phí chậm trả theo cấu hình; dùng đúng một lần trong Điều xử lý vi phạm/chấm dứt |

### 2. Nhóm Bên A (Chủ nhà / Landlord)
| Mã trường | Bắt buộc | Mô tả & Ý nghĩa |
|---|:---:|---|
| `{{landlord.fullName}}` | Có | Họ và tên chủ nhà |
| `{{landlord.idNumber}}` | Không | Số CCCD/Hộ chiếu của chủ nhà |
| `{{landlord.permanentAddress}}` | Không | Nơi thường trú của chủ nhà |
| `{{landlord.phone}}` | Có | Số điện thoại liên hệ của chủ nhà |
| `{{landlord.email}}` | Không | Email của chủ nhà |
| `{{landlord.bankAccountHolder}}` | Không | Tên chủ tài khoản nhận thanh toán của Bên A |
| `{{landlord.bankAccountNumber}}` | Không | Số tài khoản nhận thanh toán của Bên A |
| `{{landlord.bankName}}` | Không | Tên ngân hàng nhận thanh toán của Bên A |

### 3. Nhóm Bên B (Người thuê / Tenant)
| Mã trường | Bắt buộc | Mô tả & Ý nghĩa |
|---|:---:|---|
| `{{tenant.fullName}}` | Có | Họ và tên người thuê đại diện |
| `{{tenant.idNumber}}` | Không | Số CCCD/Hộ chiếu người thuê |
| `{{tenant.permanentAddress}}` | Không | Nơi thường trú người thuê |
| `{{tenant.phone}}` | Có | Số điện thoại liên hệ |
| `{{tenant.email}}` | Không | Email người thuê |
| `{{tenant.occupantCount}}` | Có | Số lượng người cư trú đăng ký chính thức |
| `{{tenant.motorbikeCount}}` | Không | Số lượng xe máy đăng ký gửi |
| `{{tenant.carCount}}` | Không | Số lượng ô tô đăng ký gửi |
| `{{tenant.bankAccountHolder}}` | Không | Tên chủ tài khoản nhận hoàn cọc của Bên B |
| `{{tenant.bankAccountNumber}}` | Không | Số tài khoản nhận hoàn cọc của Bên B |
| `{{tenant.bankName}}` | Không | Tên ngân hàng nhận hoàn cọc của Bên B |

### 4. Nhóm Bất động sản (Property)
| Mã trường | Bắt buộc | Mô tả & Ý nghĩa |
|---|:---:|---|
| `{{property.fullAddress}}` | Có | Địa chỉ đầy đủ của bất động sản |
| `{{property.areaText}}` | Có | Diện tích sử dụng (ví dụ: `45 m²`) |
| `{{property.propertyType}}` | Có | Loại hình bất động sản bằng tiếng Việt |
| `{{property.unitNumber}}` | Căn hộ & Phòng | Số căn hộ hoặc số phòng (ví dụ: `Căn hộ A-12.04` hoặc `Phòng 302`) |
| `{{property.floor}}` | Không | Tầng của căn hộ/phòng hoặc số tầng nhà nguyên căn |
| `{{property.listingCode}}` | Không | Mã định danh tin đăng đối chiếu nội bộ |
| `{{property.rentalScope}}` | Không | Phạm vi cho thuê (Toàn bộ / Tầng thuê / Phòng riêng) |
| `{{property.maxOccupants}}` | Không | Số người tối đa cho phép theo nội quy |
| `{{property.maxVehicles}}` | Không | Số xe tối đa cho phép |

### 5. Nhóm Thời hạn thuê (Lease)
| Mã trường | Bắt buộc | Mô tả & Ý nghĩa |
|---|:---:|---|
| `{{lease.startDateText}}` | Có | Ngày bắt đầu tính tiền thuê (`dd/MM/yyyy`) |
| `{{lease.endDateText}}` | Có | Ngày kết thúc thời hạn thuê (`dd/MM/yyyy`) |
| `{{lease.durationMonths}}` | Có | Thời hạn thuê tính bằng tháng (ví dụ: `12`) |
| `{{lease.durationText}}` | Có | Thời hạn bằng chữ và số (ví dụ: `12 tháng`) |
| `{{lease.handoverDateText}}` | Không | Ngày bàn giao thực tế bất động sản |

### 6. Nhóm Giá thuê & Thanh toán (Rent)
| Mã trường | Bắt buộc | Mô tả & Ý nghĩa |
|---|:---:|---|
| `{{rent.amountNumber}}` | Có | Giá thuê hàng tháng bằng số định dạng vi-VN (ví dụ: `8.500.000 VNĐ`) |
| `{{rent.amountWords}}` | Có | Giá thuê hàng tháng bằng chữ |
| `{{rent.paymentCycle}}` | Có | Chu kỳ thanh toán (Hàng tháng / 3 tháng / ...) |
| `{{rent.paymentDueDay}}` | Có | Hạn thanh toán theo từng kỳ thuê; backend hiện trả mô tả “chậm nhất 23:59 ngày thứ 4 sau khi kết thúc mỗi kỳ thuê; hạn cụ thể ghi trên hóa đơn” |
| `{{rent.paymentMethod}}` | Không | Phương thức thanh toán: Chuyển khoản trực tiếp ngân hàng |

### 7. Nhóm Tiền đặt cọc (Deposit)
| Mã trường | Bắt buộc | Mô tả & Ý nghĩa |
|---|:---:|---|
| `{{deposit.amountNumber}}` | Có | Tiền đặt cọc bằng số định dạng vi-VN |
| `{{deposit.amountWords}}` | Có | Tiền đặt cọc bằng chữ |
| `{{deposit.description}}` | Không | Quy tắc hoàn cọc thông thường; đọc cùng điều khoản vi phạm/chấm dứt trong `{{contract.specialTerms}}`, không tuyên bố cọc luôn được hoàn toàn bộ |

### 8. Nhóm Thanh toán ban đầu (Initial Payment - Schema V3)
| Mã trường | Bắt buộc | Mô tả & Ý nghĩa |
|---|:---:|---|
| `{{payment.initial.status}}` | Không | Trạng thái xác nhận (Đã xác nhận) |
| `{{payment.initial.payerReportedAt}}` | Không | Thời điểm Bên B khai báo chuyển khoản |
| `{{payment.initial.payeeConfirmedAt}}` | Không | Thời điểm Bên A xác nhận đã nhận đủ |
| `{{payment.initial.confirmedAt}}` | Không | Thời điểm hoàn tất xác nhận hai chiều |
| `{{payment.initial.transferReference}}` | Không | Mã nội dung chuyển khoản VietQR duy nhất |
| `{{payment.initial.bankTransactionReference}}` | Không | Mã tham chiếu giao dịch ngân hàng khai báo |
| `{{payment.initial.totalAmount}}` | Không | Tổng số tiền ban đầu đã thanh toán (VNĐ) |
| `{{payment.initial.paidAt}}` | Không | Thời điểm hoàn tất (tương thích V2) |
| `{{payment.initial.transactionCode}}` | Không | Mã giao dịch đối chiếu (tương thích V2) |

### 9. Nhóm Chỉ số bàn giao (Meters - Tùy chọn)
| Mã trường | Bắt buộc | Mô tả & Ý nghĩa |
|---|:---:|---|
| `{{meters.electricityInitial}}` | Không | Chỉ số công tơ điện lúc bàn giao |
| `{{meters.waterInitial}}` | Không | Chỉ số đồng hồ nước lúc bàn giao |

### 10. Danh mục Bảng động (Dynamic Tables)
| Cú pháp bảng | Bắt buộc | Cấu trúc cột |
|---|:---:|---|
| `{{#chargesTable}}` | Có | `STT` \| `Khoản phí` \| `Mức phí / Đơn giá` \| `Đơn vị tính` \| `Ghi chú / Điều kiện` |
| `{{#equipmentTable}}` | Không | `STT` \| `Tên tài sản / Thiết bị` \| `Số lượng` \| `Hiện trạng` \| `Ghi chú` |
| `{{#propertyFeaturesTable}}` | Không | `Đặc điểm` \| `Giá trị` |
| `{{#amenitiesTable}}` | Không | `STT` \| `Tiện ích / Quyền sử dụng` \| `Phạm vi` \| `Chi phí` \| `Điều kiện / Ghi chú` |
| `{{#initialPaymentTable}}` | Không | `Khoản thanh toán` \| `Số tiền` \| `Trạng thái / Chi tiết xác nhận` |

---

## III. HƯỚNG DẪN KIỂM TRA FILE WORD SAU KHI TẠO
1. Mở file Word, bật hiển thị Field Codes (`Alt + F9`) để đảm bảo không có mã trường bị lỗi tách ký tự (word run splitting).
2. Không để sót placeholder rác không có trong danh mục 63 trường trên.
3. Các bảng động `{{#chargesTable}}`, `{{#equipmentTable}}`, `{{#propertyFeaturesTable}}`, `{{#amenitiesTable}}`, `{{#initialPaymentTable}}` phải giữ nguyên ký tự `#` ở đầu tên bảng.
4. Đảm bảo file được lưu đúng định dạng Word 2007+ (.docx).
5. Mở/xuất xem toàn bộ trang để kiểm tra khoảng cách giữa Header với Quốc hiệu, khoảng cách tiêu đề, lề, bảng và lỗi tiêu đề/đoạn bị tách không đẹp.
6. DOCX mẫu không có trang ký. Khi hợp đồng chạy ở chế độ SMARTCA, backend sẽ tự nối đúng một trang ký riêng vào PDF; không thêm trang ký thứ hai vào mẫu.
7. Kiểm tra `{{contract.specialTerms}}` xuất hiện đúng một lần trong Điều xử lý vi phạm/chấm dứt; không lặp đơn vị sau `{{rent.amountNumber}}` hoặc `{{deposit.amountNumber}}`, không ghi cố định ngày 05 hằng tháng.

---

## IV. BA PROMPT HOÀN CHỈNH CHO CHATGPT (COPY & PASTE)

---

### PROMPT 1: HỢP ĐỒNG THUÊ NHÀ NGUYÊN CĂN

```markdown
BỐI CẢNH VÀ VAI TRÒ:
Bạn là chuyên gia soạn thảo hợp đồng bất động sản tại Việt Nam cho nền tảng HomeSpace. HomeSpace sử dụng thư viện poi-tl để tự động điền các placeholder dạng {{variable}} và bảng động dạng {{#table}} vào file Word (.docx).

NHIỆM VỤ:
Soạn toàn văn file Word mẫu "HỢP ĐỒNG THUÊ NHÀ NGUYÊN CĂN" (dành cho nhà phố, nhà riêng lẻ, biệt thự) theo chuẩn Schema V3. Văn bản phải chặt chẽ, trang trọng, minh bạch về tài khoản ngân hàng hai bên, cơ chế chuyển khoản trực tiếp, bảo vệ toàn vẹn kiến trúc nhà, an toàn PCCC, an ninh trật tự và quy định cư trú.

TÊN FILE WORD ĐẦU RA BẮT BUỘC:
HomeSpace_01_Hop_Dong_Thue_Nha_Nguyen_Can.docx

QUY CHUẨN DÀN TRANG BẮT BUỘC:
Tạo DOCX khổ A4 dọc, lề trái/phải 2,5 cm, lề trên 3 cm, lề dưới 2,5 cm; Header/Footer cách mép giấy 1,25 cm. Header chỉ là dòng nhận diện nhỏ 8–9 pt màu xám nhạt căn phải, nằm trong vùng Header; Quốc hiệu, tiêu ngữ và tên hợp đồng phải nằm trong phần thân trang, có khoảng cách thoáng, không được sát/chạm Header. Dùng Times New Roman; thân bài 12 pt, giãn dòng 1,15, căn đều hai lề, sau đoạn 4 pt; tiêu đề điều khoản 13 pt đậm (trước 8 pt, sau 4 pt); tên hợp đồng 16 pt đậm căn giữa. Dùng Paragraph Spacing thay cho dòng trống/Tab/dấu cách để tạo khoảng cách; không để tiêu đề đứng lẻ, bảng tràn lề, trang trắng hoặc trang cuối chỉ có vài dòng. Tự kiểm tra bố cục DOCX/PDF sau khi tạo.

QUY TẮC TRANG KÝ SMARTCA (BẮT BUỘC):
Trong chế độ SMARTCA, backend HomeSpace tự nối một trang ký A4 vào cuối PDF và đặt vùng ký ở tọa độ cố định trên trang cuối; backend không dò placeholder hay đoạn chữ ký trong DOCX. Vì vậy không tạo phần “Chữ ký các bên”, không tạo khung/dòng ký/placeholder chữ ký và không ngắt trang dành riêng cho chữ ký trong DOCX. Kết thúc mẫu ngay sau điều khoản hiệu lực để tránh có hai trang ký. Không thay đổi bất kỳ placeholder hoặc bảng động Schema V3 nào.

I. CĂN CỨ PHÁP LÝ
- Bộ luật Dân sự số 91/2015/QH13;
- Luật Nhà ở số 27/2023/QH15;
- Luật Giao dịch điện tử số 20/2023/QH15;
- Luật Cư trú số 68/2020/QH14;
- Luật Phòng cháy, chữa cháy và cứu nạn, cứu hộ số 55/2024/QH15;
- Luật Kinh doanh bất động sản số 29/2023/QH15 (trong phạm vi áp dụng).

II. QUY TẮC BẮT BUỘC VỀ DỮ LIỆU
1. Chỉ sử dụng các placeholder trong danh mục 63 trường được hỗ trợ:
   - Hợp đồng: {{contract.number}}, {{contract.signingDate}}, {{contract.signingCity}}, {{contract.schemaVersion}}, {{contract.revisionNumber}}, {{contract.specialTerms}}
   - Bên A: {{landlord.fullName}}, {{landlord.idNumber}}, {{landlord.permanentAddress}}, {{landlord.phone}}, {{landlord.email}}, {{landlord.bankAccountHolder}}, {{landlord.bankAccountNumber}}, {{landlord.bankName}}
   - Bên B: {{tenant.fullName}}, {{tenant.idNumber}}, {{tenant.permanentAddress}}, {{tenant.phone}}, {{tenant.email}}, {{tenant.occupantCount}}, {{tenant.motorbikeCount}}, {{tenant.carCount}}, {{tenant.bankAccountHolder}}, {{tenant.bankAccountNumber}}, {{tenant.bankName}}
   - Bất động sản: {{property.fullAddress}}, {{property.areaText}}, {{property.propertyType}}, {{property.floor}}, {{property.listingCode}}, {{property.rentalScope}}, {{property.maxOccupants}}, {{property.maxVehicles}}
   - Thời hạn thuê: {{lease.startDateText}}, {{lease.endDateText}}, {{lease.durationMonths}}, {{lease.durationText}}, {{lease.handoverDateText}}
   - Giá thuê & Cọc: {{rent.amountNumber}}, {{rent.amountWords}}, {{rent.paymentCycle}}, {{rent.paymentDueDay}}, {{rent.paymentMethod}}, {{deposit.amountNumber}}, {{deposit.amountWords}}, {{deposit.description}}
   - Thanh toán ban đầu: {{payment.initial.status}}, {{payment.initial.payerReportedAt}}, {{payment.initial.payeeConfirmedAt}}, {{payment.initial.confirmedAt}}, {{payment.initial.transferReference}}, {{payment.initial.bankTransactionReference}}, {{payment.initial.totalAmount}}
   - Chỉ số bàn giao: {{meters.electricityInitial}}, {{meters.waterInitial}}
   - Bảng động: {{#chargesTable}}, {{#equipmentTable}}, {{#propertyFeaturesTable}}, {{#amenitiesTable}}, {{#initialPaymentTable}}
2. TUYỆT ĐỐI KHÔNG đưa branchId, tên chi nhánh, mã chi nhánh vào văn bản.
3. Không tự tạo thêm placeholder mới. Không dùng dấu chấm thủ công (....).
4. Thanh toán chuyển khoản trực tiếp: Tiền thuê, tiền cọc và hoàn cọc được chuyển khoản trực tiếp giữa tài khoản ngân hàng của Bên A và Bên B.
 5. Ghi nhận rõ đầy đủ 7 điều khoản chuyển khoản trực tiếp:
   - Phương thức thanh toán trực tiếp vào tài khoản Bên A.
   - Vai trò HomeSpace: Chỉ tính toán khoản phải trả, tạo thông tin VietQR, lưu trữ chứng từ và ghi nhận trạng thái xác nhận; không nhận tiền, không giữ tiền, không chuyển tiền thay các bên.
   - Xác nhận hai chiều: Bên B báo chuyển, Bên A xác nhận đã nhận đủ.
   - Trách nhiệm kiểm tra thông tin tài khoản trước khi chuyển.
   - Xử lý sai lệch, tranh chấp và phối hợp cung cấp sao kê/biên lai ngân hàng.
   - Thay đổi tài khoản ngân hàng phải thông báo và xác nhận trước.
   - Hoàn cọc trực tiếp vào tài khoản Bên B sau khi quyết toán và bàn giao.
6. Luồng hóa đơn hàng tháng: phân biệt ngày ký `{{contract.signingDate}}` với ngày bắt đầu kỳ thuê `{{lease.startDateText}}`; tiền ban đầu là thuê kỳ đầu + cọc, hóa đơn cuối kỳ quyết toán phí của kỳ vừa qua và thu tiền phòng kỳ sau nếu còn thời hạn. Dùng đúng `{{rent.paymentDueDay}}`, không cố định ngày 05. Người thuê được trả ngay sau khi chủ nhà phát hành hóa đơn; phí điện/nước tính theo chỉ số thực tế và `{{#chargesTable}}`.
7. Quá hạn: phí một lần/mỗi ngày/không áp dụng và mức tiền chỉ lấy từ `{{contract.specialTerms}}`, không tự bịa số. Từ 00:00 ngày quá hạn thứ 5, chủ nhà có thể chuyển nợ sang kỳ sau hoặc đề nghị chấm dứt; khi người thuê từ chối, hợp đồng vẫn hiệu lực và chủ nhà có thể rút đề nghị hoặc xử lý theo đúng điều khoản đã ký. Không tự chấm dứt, giữ cọc hay đăng lại nhà trước khi chủ nhà xác nhận đã thông báo và thực tế nhận lại nhà/chìa khóa/tài sản. Đặt `{{contract.specialTerms}}` đúng một lần ở Điều 9, không lặp ở Điều 8. Nội dung 5 ngày/giữ cọc cần rà soát pháp lý trước khi dùng thật.

III. CẤU TRÚC ĐIỀU KHOẢN CHI TIẾT
1. QUỐC HIỆU - TIÊU NGỮ - TÊN HỢP ĐỒNG: HỢP ĐỒNG THUÊ NHÀ NGUYÊN CĂN
   Số: {{contract.number}} - Ngày ký: {{contract.signingDate}} tại {{contract.signingCity}}.
2. CĂN CỨ PHÁP LÝ (Như mục I).
3. THÔNG TIN CÁC BÊN:
   - BÊN CHO THUÊ (BÊN A): {{landlord.fullName}}, CCCD: {{landlord.idNumber}}, Thường trú: {{landlord.permanentAddress}}, Điện thoại: {{landlord.phone}}, Email: {{landlord.email}}.
     Tài khoản nhận thanh toán: Chủ tài khoản: {{landlord.bankAccountHolder}} - Số tài khoản: {{landlord.bankAccountNumber}} - Ngân hàng: {{landlord.bankName}}.
   - BÊN THUÊ (BÊN B): {{tenant.fullName}}, CCCD: {{tenant.idNumber}}, Thường trú: {{tenant.permanentAddress}}, Điện thoại: {{tenant.phone}}, Email: {{tenant.email}}, Số người ở: {{tenant.occupantCount}}, Xe máy: {{tenant.motorbikeCount}}, Ô tô: {{tenant.carCount}}.
     Tài khoản nhận hoàn trả: Chủ tài khoản: {{tenant.bankAccountHolder}} - Số tài khoản: {{tenant.bankAccountNumber}} - Ngân hàng: {{tenant.bankName}}.
4. ĐIỀU 1: ĐỐI TƯỢNG VÀ PHẠM VI CHO THUÊ
   - Bên A đồng ý cho Bên B thuê toàn bộ căn nhà tại địa chỉ: {{property.fullAddress}}.
   - Diện tích: {{property.areaText}}; Kết cấu/Số tầng: {{property.floor}}; Phạm vi thuê: {{property.rentalScope}}; Mã tin: {{property.listingCode}}.
   - Bảng thông số đặc điểm căn nhà:
     {{#propertyFeaturesTable}}
   - Mục đích thuê: Dùng để ở và sinh hoạt hợp pháp, không sử dụng vào mục đích vi phạm pháp luật.
5. ĐIỀU 2: THỜI HẠN THUÊ VÀ BÀN GIAO
   - Thời hạn thuê: {{lease.durationText}} ({{lease.durationMonths}} tháng), từ ngày {{lease.startDateText}} đến ngày {{lease.endDateText}}.
   - Ngày bàn giao: {{lease.handoverDateText}}.
   - Bàn giao chỉ số công tơ điện ban đầu: {{meters.electricityInitial}}; nước ban đầu: {{meters.waterInitial}} (nếu chưa có sẽ lập tại Biên bản bàn giao khi nhận nhà).
6. ĐIỀU 3: GIÁ THUÊ, TIỀN CỌC VÀ PHƯƠNG THỨC CHUYỂN KHOẢN TRỰC TIẾP
   - Giá thuê: {{rent.amountNumber}} (Bằng chữ: {{rent.amountWords}}).
   - Chu kỳ thanh toán: {{rent.paymentCycle}}; Hạn thanh toán định kỳ: {{rent.paymentDueDay}}.
   - Phương thức thanh toán: {{rent.paymentMethod}}.
   - Tiền đặt cọc: {{deposit.amountNumber}} (Bằng chữ: {{deposit.amountWords}}).
   - Điều kiện hoàn trả/khấu trừ cọc: {{deposit.description}}.
   - Khoản ban đầu gồm tiền thuê kỳ đầu và cọc; không thu lại tiền thuê kỳ đầu trong hóa đơn quyết toán kỳ đầu. Mỗi hóa đơn cuối kỳ gồm dịch vụ/điện/nước/phát sinh của kỳ vừa qua và tiền thuê kỳ sau nếu còn kỳ thuê; kỳ cuối không thu tiền thuê ngoài thời hạn. Hạn cụ thể theo {{rent.paymentDueDay}} và hóa đơn, không mặc định ngày 05 hằng tháng.
   - Quy định chi tiết về chuyển khoản trực tiếp và vai trò HomeSpace:
     + Bên B thanh toán tiền thuê, tiền đặt cọc và các khoản phải trả khác bằng hình thức chuyển khoản trực tiếp vào tài khoản do Bên A chỉ định trong Hợp đồng này.
     + HomeSpace cung cấp công cụ tính toán khoản phải trả, tạo thông tin VietQR, lưu trữ yêu cầu thanh toán và ghi nhận trạng thái do các bên khai báo. HomeSpace không nhận tiền, không giữ tiền, không chuyển tiền thay các bên và không thay thế ngân hàng xác nhận việc ghi Có hoặc ghi Nợ trên tài khoản.
     + Một khoản thanh toán được ghi nhận hoàn tất trên HomeSpace sau khi Bên B khai báo đã thực hiện chuyển khoản và Bên A xác nhận đã nhận đủ số tiền tương ứng.
     + Bên B có trách nhiệm kiểm tra tên chủ tài khoản, số tài khoản, ngân hàng thụ hưởng, số tiền và nội dung chuyển khoản trước khi thực hiện. Bên A có trách nhiệm kiểm tra tài khoản nhận và xác nhận trung thực trạng thái nhận tiền.
     + Trường hợp thông tin khai báo giữa các bên không thống nhất, khoản thanh toán được chuyển sang trạng thái chờ đối soát. Các bên có trách nhiệm cung cấp chứng từ ngân hàng và phối hợp xác minh; HomeSpace chỉ lưu trữ thông tin, chứng từ và lịch sử xác nhận do các bên cung cấp.
     + Mọi thay đổi tài khoản nhận thanh toán hoặc nhận hoàn trả chỉ có hiệu lực đối với nghĩa vụ phát sinh sau khi bên còn lại đã nhận được và xác nhận thông báo thay đổi.
     + Khi chấm dứt hoặc hết hạn hợp đồng, sau khi hai bên hoàn tất bàn giao và quyết toán, Bên A chuyển khoản số tiền cọc còn phải hoàn trực tiếp vào tài khoản nhận hoàn trả của Bên B ghi trong Hợp đồng này.
   - Bảng ghi nhận thanh toán ban đầu đã được hai bên xác nhận:
     {{#initialPaymentTable}}
     Mã nội dung chuyển khoản: {{payment.initial.transferReference}}, Bên B khai báo chuyển: {{payment.initial.payerReportedAt}}, Bên A xác nhận nhận: {{payment.initial.payeeConfirmedAt}}, Trạng thái xác nhận: {{payment.initial.status}}.
7. ĐIỀU 4: CÁC KHOẢN CHI PHÍ KHÁC VÀ DỊCH VỤ
   - Bảng chi phí định kỳ và dịch vụ đi kèm:
     {{#chargesTable}}
   - Bảng tiện ích và quyền sử dụng dịch vụ:
     {{#amenitiesTable}}
8. ĐIỀU 5: TÀI SẢN VÀ THIẾT BỊ BÀN GIAO
   - Danh mục trang thiết bị, nội thất gắn liền căn nhà:
     {{#equipmentTable}}
   - Bên B có trách nhiệm bảo quản nguyên vẹn, không tự ý thay đổi kết cấu chịu lực, không đục phá tường, cơi nới nếu chưa có sự đồng ý bằng văn bản của Bên A.
9. ĐIỀU 6: QUYỀN VÀ NGHĨA VỤ CỦA BÊN A
   - Bàn giao nhà và thiết bị đúng hạn; bảo đảm quyền sử dụng độc lập, hợp pháp cho Bên B.
   - Cung cấp tài khoản ngân hàng chính xác để nhận thanh toán; kiểm tra và xác nhận kịp thời khi nhận được tiền.
   - Hướng dẫn thủ tục đăng ký tạm trú theo Luật Cư trú; bảo trì kết cấu căn nhà theo thỏa thuận.
10. ĐIỀU 7: QUYỀN VÀ NGHĨA VỤ CỦA BÊN B
    - Sử dụng đúng số lượng người cư trú ({{tenant.occupantCount}} người), đúng số lượng phương tiện đăng ký ({{tenant.motorbikeCount}} xe máy, {{tenant.carCount}} ô tô).
    - Chấp hành tuyệt đối các quy định an toàn PCCC theo Luật PCCC 2024, an ninh trật tự địa phương.
    - Chuyển khoản tiền thuê và chi phí đầy đủ, đúng hạn vào tài khoản ngân hàng của Bên A.
11. ĐIỀU 8: ĐIỀU KHOẢN ĐẶC THÙ VỀ THÚ CƯNG VÀ NỘI QUY
    - Quy định về nuôi thú cưng (nếu được phép theo Bảng tiện ích): Bên B cam kết giữ vệ sinh, đảm bảo an toàn, không gây tiếng ồn ảnh hưởng xung quanh và bồi thường 100% nếu gây thiệt hại.
    - Không đặt điều khoản phí chậm trả/chấm dứt ở Điều này; nội dung đó nằm ở Điều 9.
12. ĐIỀU 9: CHẤM DỨT HỢP ĐỒNG VÀ GIẢI QUYẾT TRANH CHẤP
    - Quy định thông báo trước khi chấm dứt hợp đồng; hoàn trả nhà và quyết toán số cọc còn phải hoàn bằng chuyển khoản trực tiếp.
    - Nếu hóa đơn quá hạn, phí chậm thanh toán (nếu có) chỉ tính theo mức và cách tính đã ghi trong điều khoản được điền; không ghi số cố định khác. Từ ngày quá hạn thứ 5, chủ nhà có thể cho chuyển nợ sang kỳ tiếp theo hoặc đề nghị hai bên chấm dứt. Nếu người thuê từ chối, đề nghị có thể được rút; trường hợp xử lý chấm dứt theo điều khoản đã ký cần thông báo và thực tế nhận lại nhà, chìa khóa, tài sản trước khi mở lại tin đăng. Tiền cọc/công nợ được ghi nhận theo điều khoản ký và đối chiếu bàn giao, không phải HomeSpace tự giữ tiền.
    - Toàn văn điều khoản quá hạn, phí chậm trả và phương án chấm dứt đã được backend chốt: {{contract.specialTerms}}
    - Trường hợp bất khả kháng; giải quyết tranh chấp thông qua thương lượng hoặc Tòa án có thẩm quyền.
13. ĐIỀU 10: GIAO KẾT ĐIỆN TỬ VÀ HIỆU LỰC
    - Hợp đồng được giao kết điện tử/xác nhận thông qua nền tảng HomeSpace phù hợp Luật Giao dịch điện tử.
    - Phiên bản schema: {{contract.schemaVersion}}, Số hiệu bản sửa đổi: {{contract.revisionNumber}}.
    - Hợp đồng có hiệu lực kể từ thời điểm hai bên hoàn tất xác nhận/ký điện tử.
```

---

### PROMPT 2: HỢP ĐỒNG THUÊ CĂN HỘ CHUNG CƯ

```markdown
BỐI CẢNH VÀ VAI TRÒ:
Bạn là chuyên gia soạn thảo hợp đồng bất động sản tại Việt Nam cho nền tảng HomeSpace. HomeSpace sử dụng thư viện poi-tl để tự động điền các placeholder dạng {{variable}} và bảng động dạng {{#table}} vào file Word (.docx).

NHIỆM VỤ:
Soạn toàn văn file Word mẫu "HỢP ĐỒNG THUÊ CĂN HỘ CHUNG CƯ" (dành cho căn hộ trong tòa nhà chung cư/khu phức hợp) theo chuẩn Schema V3. Văn bản phải chặt chẽ, chuyên nghiệp, thể hiện rõ tài khoản ngân hàng hai bên, thanh toán chuyển khoản trực tiếp, tuân thủ quy chế quản lý nhà chung cư, quy định PCCC nhà cao tầng, thẻ cư dân, phí quản lý tòa nhà và các dịch vụ dùng chung.

TÊN FILE WORD ĐẦU RA BẮT BUỘC:
HomeSpace_02_Hop_Dong_Thue_Can_Ho_Chung_Cu.docx

QUY CHUẨN DÀN TRANG BẮT BUỘC:
Tạo DOCX khổ A4 dọc, lề trái/phải 2,5 cm, lề trên 3 cm, lề dưới 2,5 cm; Header/Footer cách mép giấy 1,25 cm. Header chỉ là dòng nhận diện nhỏ 8–9 pt màu xám nhạt căn phải, nằm trong vùng Header; Quốc hiệu, tiêu ngữ và tên hợp đồng phải nằm trong phần thân trang, có khoảng cách thoáng, không được sát/chạm Header. Dùng Times New Roman; thân bài 12 pt, giãn dòng 1,15, căn đều hai lề, sau đoạn 4 pt; tiêu đề điều khoản 13 pt đậm (trước 8 pt, sau 4 pt); tên hợp đồng 16 pt đậm căn giữa. Dùng Paragraph Spacing thay cho dòng trống/Tab/dấu cách để tạo khoảng cách; không để tiêu đề đứng lẻ, bảng tràn lề, trang trắng hoặc trang cuối chỉ có vài dòng. Tự kiểm tra bố cục DOCX/PDF sau khi tạo.

QUY TẮC TRANG KÝ SMARTCA (BẮT BUỘC):
Trong chế độ SMARTCA, backend HomeSpace tự nối một trang ký A4 vào cuối PDF và đặt vùng ký ở tọa độ cố định trên trang cuối; backend không dò placeholder hay đoạn chữ ký trong DOCX. Vì vậy không tạo phần “Chữ ký các bên”, không tạo khung/dòng ký/placeholder chữ ký và không ngắt trang dành riêng cho chữ ký trong DOCX. Kết thúc mẫu ngay sau điều khoản hiệu lực để tránh có hai trang ký. Không thay đổi bất kỳ placeholder hoặc bảng động Schema V3 nào.

I. CĂN CỨ PHÁP LÝ
- Bộ luật Dân sự số 91/2015/QH13;
- Luật Nhà ở số 27/2023/QH15 và quy chế quản lý, sử dụng nhà chung cư hiện hành;
- Luật Giao dịch điện tử số 20/2023/QH15;
- Luật Cư trú số 68/2020/QH14;
- Luật Phòng cháy, chữa cháy và cứu nạn, cứu hộ số 55/2024/QH15;
- Luật Kinh doanh bất động sản số 29/2023/QH15 (trong phạm vi áp dụng).

II. QUY TẮC BẮT BUỘC VỀ DỮ LIỆU
1. Chỉ sử dụng các placeholder trong danh mục 63 trường được hỗ trợ:
   - Hợp đồng: {{contract.number}}, {{contract.signingDate}}, {{contract.signingCity}}, {{contract.schemaVersion}}, {{contract.revisionNumber}}, {{contract.specialTerms}}
   - Bên A: {{landlord.fullName}}, {{landlord.idNumber}}, {{landlord.permanentAddress}}, {{landlord.phone}}, {{landlord.email}}, {{landlord.bankAccountHolder}}, {{landlord.bankAccountNumber}}, {{landlord.bankName}}
   - Bên B: {{tenant.fullName}}, {{tenant.idNumber}}, {{tenant.permanentAddress}}, {{tenant.phone}}, {{tenant.email}}, {{tenant.occupantCount}}, {{tenant.motorbikeCount}}, {{tenant.carCount}}, {{tenant.bankAccountHolder}}, {{tenant.bankAccountNumber}}, {{tenant.bankName}}
   - Bất động sản: {{property.fullAddress}}, {{property.areaText}}, {{property.propertyType}}, {{property.unitNumber}}, {{property.floor}}, {{property.listingCode}}, {{property.rentalScope}}, {{property.maxOccupants}}, {{property.maxVehicles}}
   - Thời hạn thuê: {{lease.startDateText}}, {{lease.endDateText}}, {{lease.durationMonths}}, {{lease.durationText}}, {{lease.handoverDateText}}
   - Giá thuê & Cọc: {{rent.amountNumber}}, {{rent.amountWords}}, {{rent.paymentCycle}}, {{rent.paymentDueDay}}, {{rent.paymentMethod}}, {{deposit.amountNumber}}, {{deposit.amountWords}}, {{deposit.description}}
   - Thanh toán ban đầu: {{payment.initial.status}}, {{payment.initial.payerReportedAt}}, {{payment.initial.payeeConfirmedAt}}, {{payment.initial.confirmedAt}}, {{payment.initial.transferReference}}, {{payment.initial.bankTransactionReference}}, {{payment.initial.totalAmount}}
   - Chỉ số bàn giao: {{meters.electricityInitial}}, {{meters.waterInitial}}
   - Bảng động: {{#chargesTable}}, {{#equipmentTable}}, {{#propertyFeaturesTable}}, {{#amenitiesTable}}, {{#initialPaymentTable}}
2. TUYỆT ĐỐI KHÔNG đưa branchId, tên chi nhánh, mã chi nhánh vào văn bản.
3. Không tự tạo thêm placeholder mới. Không dùng dấu chấm thủ công (....).
4. Thanh toán chuyển khoản trực tiếp: Tiền thuê và tiền cọc chuyển khoản trực tiếp vào tài khoản ngân hàng Bên A.
5. Ghi nhận rõ đầy đủ 7 điều khoản chuyển khoản trực tiếp:
   - Phương thức thanh toán trực tiếp vào tài khoản Bên A.
   - Vai trò HomeSpace: Công cụ tính toán khoản phải trả, tạo VietQR, lưu trữ chứng từ và trạng thái khai báo; không nhận, không giữ, không chuyển tiền thay các bên.
   - Xác nhận hai chiều: Bên B khai báo chuyển khoản, Bên A xác nhận nhận đủ tiền.
   - Trách nhiệm kiểm tra thông tin chuyển khoản của hai bên.
   - Xử lý sai lệch, tranh chấp và cung cấp chứng từ ngân hàng.
   - Thay đổi tài khoản ngân hàng phải thông báo và xác nhận trước.
   - Hoàn cọc chuyển khoản trực tiếp vào tài khoản Bên B sau bàn giao và quyết toán.
 6. Nguyên tắc tiện ích chung: "Đối với tiện ích dùng chung (hồ bơi, phòng gym, thang máy nếu có), Bên B được quyền sử dụng theo nội quy, khung giờ và tình trạng vận hành của Ban Quản lý tòa nhà, không cấu thành cam kết vận hành liên tục tuyệt đối."
7. Luồng hóa đơn và quá hạn: `{{contract.signingDate}}` khác `{{lease.startDateText}}`; tiền ban đầu là thuê kỳ đầu + cọc. Hóa đơn cuối kỳ quyết toán phí dịch vụ, gửi xe, điện/nước thực dùng của kỳ vừa qua và thu tiền thuê kỳ sau nếu còn kỳ; kỳ cuối không thu thêm tiền phòng ngoài hợp đồng. Dùng `{{rent.paymentDueDay}}`, không mặc định ngày 05; khi chủ nhà chốt số và phát hành, người thuê có thể xem/trả ngay. Phí chậm trả chỉ theo mức/cách tính nằm trong `{{contract.specialTerms}}`, không tự đặt con số. Từ 00:00 ngày quá hạn thứ 5, chủ nhà có thể chuyển nợ sang kỳ sau hoặc đề nghị chấm dứt. Nếu người thuê từ chối, hợp đồng vẫn hiệu lực, chủ nhà có thể rút đề nghị hoặc xử lý theo điều khoản ký sau khi thông báo và nhận lại căn hộ, thẻ cư dân, chìa khóa, tài sản. Không tự đổi cọc/trạng thái căn hộ khi chưa bàn giao; rà soát pháp lý điều khoản 5 ngày/giữ cọc trước khi dùng thật. Đặt `{{contract.specialTerms}}` đúng một lần ở Điều 9.

III. CẤU TRÚC ĐIỀU KHOẢN CHI TIẾT
1. QUỐC HIỆU - TIÊU NGỮ - TÊN HỢP ĐỒNG: HỢP ĐỒNG THUÊ CĂN HỘ CHUNG CƯ
   Số: {{contract.number}} - Ngày ký: {{contract.signingDate}} tại {{contract.signingCity}}.
2. CĂN CỨ PHÁP LÝ (Như mục I).
3. THÔNG TIN CÁC BÊN:
   - BÊN CHO THUÊ (BÊN A): {{landlord.fullName}}, CCCD: {{landlord.idNumber}}, Thường trú: {{landlord.permanentAddress}}, Điện thoại: {{landlord.phone}}, Email: {{landlord.email}}.
     Tài khoản nhận thanh toán: Chủ tài khoản: {{landlord.bankAccountHolder}} - Số tài khoản: {{landlord.bankAccountNumber}} - Ngân hàng: {{landlord.bankName}}.
   - BÊN THUÊ (BÊN B): {{tenant.fullName}}, CCCD: {{tenant.idNumber}}, Thường trú: {{tenant.permanentAddress}}, Điện thoại: {{tenant.phone}}, Email: {{tenant.email}}, Số người cư trú: {{tenant.occupantCount}}, Xe máy đăng ký: {{tenant.motorbikeCount}}, Ô tô đăng ký: {{tenant.carCount}}.
     Tài khoản nhận hoàn trả: Chủ tài khoản: {{tenant.bankAccountHolder}} - Số tài khoản: {{tenant.bankAccountNumber}} - Ngân hàng: {{tenant.bankName}}.
4. ĐIỀU 1: ĐỐI TƯỢNG VÀ ĐẶC ĐIỂM CĂN HỘ CHO THUÊ
   - Bên A cho Bên B thuê căn hộ: {{property.unitNumber}}, tọa lạc tại tầng {{property.floor}}, thuộc địa chỉ: {{property.fullAddress}}.
   - Diện tích căn hộ: {{property.areaText}}; Phạm vi thuê: {{property.rentalScope}}; Mã tin đăng: {{property.listingCode}}.
   - Bảng thông số chi tiết của căn hộ:
     {{#propertyFeaturesTable}}
   - Mục đích sử dụng: Dùng để ở và sinh hoạt hợp pháp của hộ gia đình/cá nhân cư trú.
5. ĐIỀU 2: THỜI HẠN THUÊ VÀ BÀN GIAO CĂN HỘ
   - Thời hạn thuê: {{lease.durationText}} ({{lease.durationMonths}} tháng), từ ngày {{lease.startDateText}} đến ngày {{lease.endDateText}}.
   - Ngày bàn giao: {{lease.handoverDateText}}.
   - Chỉ số điện ban đầu: {{meters.electricityInitial}}; nước ban đầu: {{meters.waterInitial}} (hoặc lập tại Biên bản bàn giao khi nhận bàn giao căn hộ).
6. ĐIỀU 3: GIÁ THUÊ, TIỀN CỌC VÀ CHUYỂN KHOẢN TRỰC TIẾP
   - Giá thuê căn hộ: {{rent.amountNumber}} (Bằng chữ: {{rent.amountWords}}).
   - Chu kỳ thanh toán: {{rent.paymentCycle}}; Hạn thanh toán định kỳ: {{rent.paymentDueDay}}.
   - Phương thức thanh toán: {{rent.paymentMethod}}.
   - Tiền đặt cọc: {{deposit.amountNumber}} (Bằng chữ: {{deposit.amountWords}}).
   - Điều kiện hoàn cọc: {{deposit.description}}.
   - Khoản ban đầu gồm thuê kỳ đầu và cọc; không thu lại tiền thuê kỳ đầu ở hóa đơn quyết toán kỳ đầu. Hóa đơn sau thu phí quản lý/gửi xe/điện/nước kỳ vừa qua và tiền phòng kỳ tới nếu còn thời hạn. Hạn theo {{rent.paymentDueDay}} và hóa đơn, không theo ngày 05 cố định.
   - Điều khoản chuyển khoản trực tiếp và vai trò HomeSpace:
     + Bên B thanh toán bằng hình thức chuyển khoản trực tiếp vào tài khoản ngân hàng Bên A chỉ định trong Hợp đồng này.
     + HomeSpace cung cấp công cụ tính toán khoản phải trả, tạo VietQR, lưu trữ yêu cầu thanh toán và ghi nhận trạng thái do các bên khai báo; HomeSpace không nhận tiền, không giữ tiền, không chuyển tiền thay các bên.
     + Khoản thanh toán hoàn tất trên HomeSpace khi Bên B khai báo chuyển khoản và Bên A xác nhận đã nhận đủ tiền.
     + Hai bên tự chịu trách nhiệm kiểm tra thông tin tài khoản ngân hàng trước khi giao dịch.
     + Trường hợp sai lệch, hai bên phối hợp cung cấp chứng từ ngân hàng để đối soát.
     + Mọi thay đổi tài khoản nhận thanh toán phải được bên kia xác nhận trước khi áp dụng.
     + Hoàn cọc trực tiếp vào tài khoản nhận hoàn trả của Bên B sau quyết toán.
   - Bảng ghi nhận thanh toán ban đầu đã được hai bên xác nhận:
     {{#initialPaymentTable}}
     Mã nội dung chuyển khoản: {{payment.initial.transferReference}}, Bên B khai báo chuyển: {{payment.initial.payerReportedAt}}, Bên A xác nhận nhận: {{payment.initial.payeeConfirmedAt}}, Trạng thái xác nhận: {{payment.initial.status}}.
7. ĐIỀU 4: PHÍ QUẢN LÝ, GỬI XE, ĐIỆN NƯỚC VÀ DỊCH VỤ CHUNG CƯ
   - Bảng phí quản lý tòa nhà, gửi xe máy/ô tô và các chi phí sinh hoạt:
     {{#chargesTable}}
   - Bảng tiện ích chung cư và quyền sử dụng dịch vụ:
     {{#amenitiesTable}}
8. ĐIỀU 5: DANH MỤC TRANG THIẾT BỊ, NỘI THẤT BÀN GIAO
   - Chi tiết danh mục nội thất, máy móc gắn liền căn hộ:
     {{#equipmentTable}}
   - Bên B có trách nhiệm giữ gìn nội thất, không tự ý can thiệp hệ thống phòng cháy tự động (đầu phun sprinkler, đầu báo khói).
9. ĐIỀU 6: QUYỀN VÀ NGHĨA VỤ CỦA BÊN A
   - Bàn giao căn hộ, thẻ thang máy, chìa khóa/mật mã cửa đúng thỏa thuận.
   - Cung cấp tài khoản ngân hàng thụ hưởng chính xác; xác nhận kịp thời khi nhận được tiền chuyển khoản.
   - Hỗ trợ đăng ký định mức điện nước và thủ tục tạm trú cho Bên B với Ban Quản lý và Công an địa phương.
10. ĐIỀU 7: QUYỀN VÀ NGHĨA VỤ CỦA BÊN B
    - Chấp hành nghiêm chỉnh Nội quy tòa nhà chung cư, quy chế cư dân, quy định gửi xe.
    - Cư trú đúng số lượng: {{tenant.occupantCount}} người; gửi xe đúng số lượng: {{tenant.motorbikeCount}} xe máy, {{tenant.carCount}} ô tô.
    - Chuyển khoản tiền thuê và các chi phí đúng hạn vào tài khoản ngân hàng của Bên A.
11. ĐIỀU 8: ĐIỀU KHOẢN VỀ VẬT NUÔI VÀ NỘI QUY
    - Quy định vật nuôi: Chỉ được nuôi thú cưng nếu Nội quy chung cư và Bảng tiện ích cho phép; Bên B chịu hoàn toàn trách nhiệm vệ sinh, an toàn.
    - Không đặt điều khoản phí chậm trả/chấm dứt ở Điều này; nội dung đó nằm ở Điều 9.
12. ĐIỀU 9: CHẤM DỨT HỢP ĐỒNG VÀ XỬ LÝ VI PHẠM
    - Thông báo trước khi kết thúc hợp đồng; bàn giao lại thẻ cư dân, chìa khóa, hiện trạng căn hộ và chuyển khoản trực tiếp số cọc còn phải hoàn sau quyết toán.
    - Phí chậm trả theo điều khoản đã ký và hiển thị riêng trên hóa đơn; không bịa mức tiền. Từ ngày quá hạn thứ 5, chủ nhà có thể cho chuyển nợ sang kỳ tiếp theo hoặc đề nghị chấm dứt. Nếu người thuê từ chối, đề nghị có thể được rút; nhánh chấm dứt theo điều khoản đã ký chỉ hoàn tất khi đã thông báo và thực tế nhận lại căn hộ, thẻ/chìa khóa, tài sản. Khi đó cọc và công nợ được ghi nhận theo điều khoản ký; HomeSpace không tự chiếm hữu hay cưỡng chế căn hộ.
    - Toàn văn điều khoản quá hạn, phí chậm trả và phương án chấm dứt đã được backend chốt: {{contract.specialTerms}}
13. ĐIỀU 10: GIAO KẾT ĐIỆN TỬ VÀ HIỆU LỰC
    - Hợp đồng được giao kết điện tử qua nền tảng HomeSpace theo Luật Giao dịch điện tử.
    - Phiên bản schema: {{contract.schemaVersion}}, Số hiệu bản sửa đổi: {{contract.revisionNumber}}.
    - Hợp đồng có hiệu lực sau khi hai bên hoàn tất xác nhận điện tử.
```

---

### PROMPT 3: HỢP ĐỒNG THUÊ PHÒNG TRỌ

```markdown
BỐI CẢNH VÀ VAI TRÒ:
Bạn là chuyên gia soạn thảo hợp đồng bất động sản tại Việt Nam cho nền tảng HomeSpace. HomeSpace sử dụng thư viện poi-tl để tự động điền các placeholder dạng {{variable}} và bảng động dạng {{#table}} vào file Word (.docx).

NHIỆM VỤ:
Soạn toàn văn file Word mẫu "HỢP ĐỒNG THUÊ PHÒNG TRỌ" (dành cho phòng trọ trong dãy trọ, nhà nhiều phòng cho thuê hoặc căn hộ dịch vụ chia phòng) theo chuẩn Schema V3. Văn bản phải rõ ràng, thiết thực, ghi rõ tài khoản ngân hàng hai bên, chuyển khoản trực tiếp, tập trung vào an ninh trật tự, giờ giấc ra vào, PCCC (đặc biệt là sạc xe điện và thiết bị đun nấu), đăng ký tạm trú và chia sẻ không gian chung.

TÊN FILE WORD ĐẦU RA BẮT BUỘC:
HomeSpace_03_Hop_Dong_Thue_Phong_Tro.docx

QUY CHUẨN DÀN TRANG BẮT BUỘC:
Tạo DOCX khổ A4 dọc, lề trái/phải 2,5 cm, lề trên 3 cm, lề dưới 2,5 cm; Header/Footer cách mép giấy 1,25 cm. Header chỉ là dòng nhận diện nhỏ 8–9 pt màu xám nhạt căn phải, nằm trong vùng Header; Quốc hiệu, tiêu ngữ và tên hợp đồng phải nằm trong phần thân trang, có khoảng cách thoáng, không được sát/chạm Header. Dùng Times New Roman; thân bài 12 pt, giãn dòng 1,15, căn đều hai lề, sau đoạn 4 pt; tiêu đề điều khoản 13 pt đậm (trước 8 pt, sau 4 pt); tên hợp đồng 16 pt đậm căn giữa. Dùng Paragraph Spacing thay cho dòng trống/Tab/dấu cách để tạo khoảng cách; không để tiêu đề đứng lẻ, bảng tràn lề, trang trắng hoặc trang cuối chỉ có vài dòng. Tự kiểm tra bố cục DOCX/PDF sau khi tạo.

QUY TẮC TRANG KÝ SMARTCA (BẮT BUỘC):
Trong chế độ SMARTCA, backend HomeSpace tự nối một trang ký A4 vào cuối PDF và đặt vùng ký ở tọa độ cố định trên trang cuối; backend không dò placeholder hay đoạn chữ ký trong DOCX. Vì vậy không tạo phần “Chữ ký các bên”, không tạo khung/dòng ký/placeholder chữ ký và không ngắt trang dành riêng cho chữ ký trong DOCX. Kết thúc mẫu ngay sau điều khoản hiệu lực để tránh có hai trang ký. Không thay đổi bất kỳ placeholder hoặc bảng động Schema V3 nào.

I. CĂN CỨ PHÁP LÝ
- Bộ luật Dân sự số 91/2015/QH13;
- Luật Nhà ở số 27/2023/QH15 và quy định về quản lý nhà ở nhiều phòng cho thuê;
- Luật Giao dịch điện tử số 20/2023/QH15;
- Luật Cư trú số 68/2020/QH14;
- Luật Phòng cháy, chữa cháy và cứu nạn, cứu hộ số 55/2024/QH15 (quy định về nhà trọ và lối thoát nạn khẩn cấp);
- Luật Kinh doanh bất động sản số 29/2023/QH15 (trong phạm vi áp dụng).

II. QUY TẮC BẮT BUỘC VỀ DỮ LIỆU
1. Chỉ sử dụng các placeholder trong danh mục 63 trường được hỗ trợ:
   - Hợp đồng: {{contract.number}}, {{contract.signingDate}}, {{contract.signingCity}}, {{contract.schemaVersion}}, {{contract.revisionNumber}}, {{contract.specialTerms}}
   - Bên A: {{landlord.fullName}}, {{landlord.idNumber}}, {{landlord.permanentAddress}}, {{landlord.phone}}, {{landlord.email}}, {{landlord.bankAccountHolder}}, {{landlord.bankAccountNumber}}, {{landlord.bankName}}
   - Bên B: {{tenant.fullName}}, {{tenant.idNumber}}, {{tenant.permanentAddress}}, {{tenant.phone}}, {{tenant.email}}, {{tenant.occupantCount}}, {{tenant.motorbikeCount}}, {{tenant.carCount}}, {{tenant.bankAccountHolder}}, {{tenant.bankAccountNumber}}, {{tenant.bankName}}
   - Bất động sản: {{property.fullAddress}}, {{property.areaText}}, {{property.propertyType}}, {{property.unitNumber}}, {{property.floor}}, {{property.listingCode}}, {{property.rentalScope}}, {{property.maxOccupants}}, {{property.maxVehicles}}
   - Thời hạn thuê: {{lease.startDateText}}, {{lease.endDateText}}, {{lease.durationMonths}}, {{lease.durationText}}, {{lease.handoverDateText}}
   - Giá thuê & Cọc: {{rent.amountNumber}}, {{rent.amountWords}}, {{rent.paymentCycle}}, {{rent.paymentDueDay}}, {{rent.paymentMethod}}, {{deposit.amountNumber}}, {{deposit.amountWords}}, {{deposit.description}}
   - Thanh toán ban đầu: {{payment.initial.status}}, {{payment.initial.payerReportedAt}}, {{payment.initial.payeeConfirmedAt}}, {{payment.initial.confirmedAt}}, {{payment.initial.transferReference}}, {{payment.initial.bankTransactionReference}}, {{payment.initial.totalAmount}}
   - Chỉ số bàn giao: {{meters.electricityInitial}}, {{meters.waterInitial}}
   - Bảng động: {{#chargesTable}}, {{#equipmentTable}}, {{#propertyFeaturesTable}}, {{#amenitiesTable}}, {{#initialPaymentTable}}
2. TUYỆT ĐỐI KHÔNG đưa branchId, tên chi nhánh, mã chi nhánh vào văn bản.
3. Không tự tạo thêm placeholder mới. Không dùng dấu chấm thủ công (....).
4. Thanh toán chuyển khoản trực tiếp: Tiền thuê phòng, tiền cọc và hoàn cọc chuyển khoản trực tiếp giữa tài khoản ngân hàng của Bên A và Bên B.
5. Ghi nhận rõ đầy đủ 7 điều khoản chuyển khoản trực tiếp:
   - Phương thức thanh toán chuyển khoản trực tiếp vào tài khoản ngân hàng Bên A.
   - Vai trò HomeSpace: Công cụ tính toán khoản phải trả, tạo thông tin VietQR, lưu trữ chứng từ và trạng thái khai báo; không nhận, không giữ, không chuyển tiền thay hai bên.
   - Xác nhận hai chiều: Bên B báo chuyển khoản, Bên A xác nhận nhận đủ tiền.
   - Hai bên tự kiểm tra thông tin tài khoản thụ hưởng trước khi chuyển tiền.
   - Sai lệch thông tin thì phối hợp cung cấp chứng từ ngân hàng để đối soát.
   - Thay đổi tài khoản nhận tiền phải thông báo và xác nhận trước bằng văn bản/thông điệp dữ liệu.
   - Hoàn cọc chuyển khoản trực tiếp vào tài khoản Bên B sau bàn giao và quyết toán.
 6. Nguyên tắc tiện ích chung: "Đối với tiện ích dùng chung (khu giặt phơi, nhà để xe, lối đi chung nếu có), Bên B được quyền sử dụng theo nội quy nhà trọ, khung giờ và tình trạng vận hành thực tế, không cấu thành cam kết vận hành liên tục tuyệt đối."
7. Luồng hóa đơn và quá hạn: `{{contract.signingDate}}` là ngày ký, `{{lease.startDateText}}` là ngày đầu kỳ thuê. Khoản ban đầu chỉ gồm tiền phòng kỳ đầu và cọc nếu có. Hóa đơn cuối kỳ quyết toán dịch vụ, gửi xe, điện/nước thực dùng của kỳ vừa qua và thu tiền phòng kỳ sau nếu còn thời hạn; kỳ cuối chỉ quyết toán phí. Dùng đúng `{{rent.paymentDueDay}}`, không ghi “ngày 01” hoặc “ngày 05” cố định. Khi chủ nhà chốt chỉ số/phát hành, người thuê được xem và thanh toán ngay. Phí chậm trả một lần/mỗi ngày/không áp dụng chỉ theo `{{contract.specialTerms}}`, không tự suy bằng giá thuê một ngày. Từ 00:00 ngày quá hạn thứ 5, chủ nhà có thể chuyển nợ sang kỳ sau hoặc đề nghị hai bên chấm dứt; nếu người thuê từ chối, hợp đồng vẫn hiệu lực, chủ nhà có thể rút đề nghị hoặc xử lý theo điều khoản đã ký sau khi thông báo và thực tế nhận lại phòng, chìa khóa, tài sản. Cọc/tin đăng không tự đổi trước bàn giao. Nội dung 5 ngày/giữ cọc phải được rà soát pháp lý trước khi dùng thật. Đặt `{{contract.specialTerms}}` đúng một lần ở Điều 9.

III. CẤU TRÚC ĐIỀU KHOẢN CHI TIẾT
1. QUỐC HIỆU - TIÊU NGỮ - TÊN HỢP ĐỒNG: HỢP ĐỒNG THUÊ PHÒNG TRỌ
   Số: {{contract.number}} - Ngày ký: {{contract.signingDate}} tại {{contract.signingCity}}.
2. CĂN CỨ PHÁP LÝ (Như mục I).
3. THÔNG TIN CÁC BÊN:
   - BÊN CHO THUÊ (BÊN A): {{landlord.fullName}}, CCCD: {{landlord.idNumber}}, Thường trú: {{landlord.permanentAddress}}, Điện thoại: {{landlord.phone}}, Email: {{landlord.email}}.
     Tài khoản nhận thanh toán: Chủ tài khoản: {{landlord.bankAccountHolder}} - Số tài khoản: {{landlord.bankAccountNumber}} - Ngân hàng: {{landlord.bankName}}.
   - BÊN THUÊ (BÊN B): {{tenant.fullName}}, CCCD: {{tenant.idNumber}}, Thường trú: {{tenant.permanentAddress}}, Điện thoại: {{tenant.phone}}, Email: {{tenant.email}}, Số người cư trú: {{tenant.occupantCount}}, Xe máy đăng ký: {{tenant.motorbikeCount}}, Ô tô: {{tenant.carCount}}.
     Tài khoản nhận hoàn trả: Chủ tài khoản: {{tenant.bankAccountHolder}} - Số tài khoản: {{tenant.bankAccountNumber}} - Ngân hàng: {{tenant.bankName}}.
4. ĐIỀU 1: ĐỐI TƯỢNG VÀ ĐẶC ĐIỂM PHÒNG TRỌ
   - Bên A cho Bên B thuê phòng số: {{property.unitNumber}}, tại tầng {{property.floor}}, thuộc địa chỉ: {{property.fullAddress}}.
   - Diện tích phòng: {{property.areaText}}; Phạm vi thuê: {{property.rentalScope}}; Mã tin đăng: {{property.listingCode}}.
   - Bảng đặc điểm kỹ thuật và tiện nghi phòng:
     {{#propertyFeaturesTable}}
   - Mục đích sử dụng: Để ở và sinh hoạt cá nhân, tuyệt đối không sử dụng làm kho chứa hàng nguy hiểm hoặc địa điểm hoạt động trái pháp luật.
5. ĐIỀU 2: THỜI HẠN THUÊ VÀ NHẬN PHÒNG
   - Thời hạn thuê: {{lease.durationText}} ({{lease.durationMonths}} tháng), từ ngày {{lease.startDateText}} đến ngày {{lease.endDateText}}.
   - Ngày bàn giao nhận phòng: {{lease.handoverDateText}}.
   - Chỉ số công tơ điện lúc nhận phòng: {{meters.electricityInitial}}; chỉ số đồng hồ nước: {{meters.waterInitial}} (nếu dùng đồng hồ riêng, hoặc cập nhật tại Biên bản bàn giao nhận phòng).
6. ĐIỀU 3: TIỀN THUÊ PHÒNG, ĐẶT CỌC VÀ CHUYỂN KHOẢN TRỰC TIẾP
   - Tiền thuê phòng: {{rent.amountNumber}} (Bằng chữ: {{rent.amountWords}}).
   - Chu kỳ thanh toán: {{rent.paymentCycle}}; Hạn thanh toán định kỳ: {{rent.paymentDueDay}}.
   - Phương thức thanh toán: {{rent.paymentMethod}}.
   - Tiền đặt cọc: {{deposit.amountNumber}} (Bằng chữ: {{deposit.amountWords}}).
   - Điều kiện hoàn cọc: {{deposit.description}}.
   - Tiền ban đầu là thuê kỳ đầu và cọc; hóa đơn cuối kỳ đầu không thu lại tiền phòng đã trả. Những kỳ tiếp theo thu phí cố định, gửi xe, điện/nước thực dùng và tiền phòng kỳ kế nếu còn thời hạn. Hạn theo {{rent.paymentDueDay}} và từng hóa đơn.
   - Điều khoản chuyển khoản trực tiếp và vai trò HomeSpace:
     + Bên B thanh toán bằng hình thức chuyển khoản trực tiếp vào tài khoản ngân hàng của Bên A chỉ định trong Hợp đồng này.
     + HomeSpace cung cấp công cụ tính toán khoản phải trả, tạo thông tin VietQR, lưu trữ yêu cầu thanh toán và ghi nhận trạng thái do các bên khai báo. HomeSpace không nhận tiền, không giữ tiền, không chuyển tiền thay các bên.
     + Khoản thanh toán hoàn tất trên HomeSpace khi Bên B khai báo chuyển khoản và Bên A xác nhận đã nhận đủ tiền.
     + Hai bên tự chịu trách nhiệm kiểm tra thông tin tài khoản ngân hàng trước khi giao dịch.
     + Trường hợp có sai lệch thông tin, hai bên phối hợp cung cấp chứng từ ngân hàng để xác minh.
     + Mọi thay đổi tài khoản nhận thanh toán hoặc nhận hoàn trả phải được thông báo và xác nhận trước.
     + Khi hết hạn hợp đồng hoặc chấm dứt hợp đồng, sau khi hoàn tất bàn giao phòng và quyết toán, Bên A chuyển khoản tiền cọc còn lại trực tiếp vào tài khoản Bên B ghi trong Hợp đồng này.
   - Bảng ghi nhận thanh toán ban đầu đã được hai bên xác nhận:
     {{#initialPaymentTable}}
     Mã nội dung chuyển khoản: {{payment.initial.transferReference}}, Bên B khai báo chuyển: {{payment.initial.payerReportedAt}}, Bên A xác nhận nhận: {{payment.initial.payeeConfirmedAt}}, Trạng thái xác nhận: {{payment.initial.status}}.
7. ĐIỀU 4: CÁC KHOẢN PHÍ DỊCH VỤ, ĐIỆN, NƯỚC VÀ GỬI XE
   - Bảng đơn giá điện, nước, internet, rác, vệ sinh và gửi xe:
     {{#chargesTable}}
   - Bảng tiện ích và quyền sử dụng không gian chung:
     {{#amenitiesTable}}
8. ĐIỀU 5: TRANG THIẾT BỊ VÀ NỘI THẤT TRONG PHÒNG
   - Danh mục thiết bị bàn giao trong phòng:
     {{#equipmentTable}}
   - Bên B có trách nhiệm sử dụng đúng tính năng, giữ gìn vệ sinh và đền bù nếu làm hư hỏng, mất mát.
9. ĐIỀU 6: QUYỀN VÀ NGHĨA VỤ CỦA BÊN A
   - Giao phòng và tiện nghi đúng hiện trạng thỏa thuận.
   - Cung cấp tài khoản ngân hàng chính xác; kiểm tra và xác nhận kịp thời khi nhận được tiền.
   - Đăng ký tạm trú cho Bên B theo đúng quy định Luật Cư trú; đảm bảo an ninh khu trọ và bảo trì hệ thống cấp thoát nước, điện tổng.
10. ĐIỀU 7: QUYỀN VÀ NGHĨA VỤ CỦA BÊN B (NỘI QUY VÀ AN TOÀN PCCC)
    - Cư trú đúng số người đăng ký: {{tenant.occupantCount}} người; giữ đúng số lượng xe: {{tenant.motorbikeCount}} xe máy. Khách ở qua đêm phải báo trước với Bên A và đăng ký theo quy định.
    - TUÂN THỦ NGHIÊM NGẶT PCCC: Không sạc pin/ắc quy xe điện qua đêm không có người trông coi; không đun nấu bằng bếp gas mini không bảo đảm an toàn; không che chắn hành lang, cầu thang thoát nạn.
    - Chuyển khoản tiền thuê và chi phí đầy đủ, đúng hạn vào tài khoản ngân hàng của Bên A.
    - Giữ gìn an ninh trật tự, không mở nhạc lớn sau 22h00; giữ vệ sinh khu vực chung (sân phơi, nhà xe, hành lang).
11. ĐIỀU 8: QUY ĐỊNH VỀ VẬT NUÔI VÀ NỘI QUY
    - Quy định vật nuôi: Chỉ được nuôi nếu khu trọ cho phép (thể hiện tại Bảng tiện ích); Bên B chịu trách nhiệm giữ gìn vệ sinh và không gây ồn ào.
    - Không đặt điều khoản phí chậm trả/chấm dứt ở Điều này; nội dung đó nằm ở Điều 9.
12. ĐIỀU 9: CHẤM DỨT HỢP ĐỒNG VÀ HOÀN TRẢ PHÒNG
    - Bên B muốn trả phòng trước hạn phải báo trước tối thiểu theo thỏa thuận, dọn dẹp sạch sẽ và bàn giao lại chìa khóa, hiện trạng phòng.
    - Quyết toán và chuyển khoản số cọc còn phải hoàn trực tiếp vào tài khoản ngân hàng của Bên B.
    - Phí chậm trả chỉ theo điều khoản ký, hiển thị riêng trên hóa đơn. Từ ngày quá hạn thứ 5, chủ nhà có thể cho chuyển nợ sang kỳ tiếp theo hoặc đề nghị hai bên chấm dứt; nếu người thuê từ chối thì hợp đồng vẫn hiệu lực, chủ nhà có thể rút đề nghị hoặc xử lý theo điều khoản ký sau khi thông báo và thực tế nhận lại phòng/chìa khóa/tài sản. Cọc và công nợ theo điều khoản ký và bàn giao, không phải HomeSpace tự giữ hay cưỡng chế phòng.
    - Toàn văn điều khoản quá hạn, phí chậm trả và phương án chấm dứt đã được backend chốt: {{contract.specialTerms}}
13. ĐIỀU 10: GIAO KẾT ĐIỆN TỬ VÀ HIỆU LỰC
    - Hợp đồng được giao kết điện tử qua nền tảng HomeSpace theo Luật Giao dịch điện tử.
    - Phiên bản schema: {{contract.schemaVersion}}, Số hiệu bản sửa đổi: {{contract.revisionNumber}}.
    - Hợp đồng có hiệu lực sau khi hai bên hoàn tất xác nhận điện tử.
```
