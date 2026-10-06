-- HomeSpace: 1.000 tin đăng mẫu cho thử nghiệm tìm kiếm AI
-- Chạy trên homespace_core bằng pgAdmin (Query Tool).
-- Chỉ dành cho local/dev. Phân bổ theo 225 địa điểm / 34 tỉnh-thành từ featured-locations.json.
-- Mỗi địa điểm có 4-5 tin, đủ cả HOUSE, APARTMENT và ROOM; không xóa tin ngoài bộ seed.
-- Chỉ cần chạy file này sau khi migration, bootstrap ADMIN và catalog của listing service đã sẵn sàng.
-- Không cần chạy file sửa bổ sung. ID được tạo xác định, các bản ghi được upsert.
-- Tin thuộc tài khoản bootstrap username=homespace (role ADMIN trong DB local hiện tại).
-- Ảnh: dùng đúng 3 object S3 do người dùng cung cấp; cả 3 ảnh được gắn vào mỗi tin.
-- Địa chỉ/đường và liên hệ với địa điểm nổi bật là dữ liệu giả lập, không xác nhận tọa độ/khoảng cách thật.

BEGIN;

CREATE TEMP TABLE hs_seed_config ON COMMIT DROP AS
SELECT u.id AS owner_id
FROM users u
JOIN roles r ON r.id = u.role_id
WHERE u.active IS TRUE AND upper(r.name) = 'ADMIN'
  AND lower(u.username) = 'homespace'
LIMIT 1;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM hs_seed_config) THEN
        RAISE EXCEPTION 'Không tìm thấy users.active=true có role ADMIN. Hãy seed tài khoản trước khi chạy.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM amenities WHERE active IS TRUE)
       OR NOT EXISTS (SELECT 1 FROM furnishing_items WHERE active IS TRUE) THEN
        RAISE EXCEPTION 'Thiếu catalog amenities/furnishing_items. Hãy khởi động listing service để seed catalog trước.';
    END IF;
END $$;

-- Featured locations are embedded so this is a single pgAdmin-ready file.
CREATE TEMP TABLE hs_seed_places ON COMMIT DROP AS
WITH place_source AS (
    SELECT p.key AS province_code, p.value->>'name' AS province_short_name,
           loc.location_label, loc.location_order
    FROM jsonb_each($hs_featured_locations$
{
  "01": {
    "code": "01",
    "name": "Hà Nội",
    "locations": [
      "ĐH Quốc gia Hà Nội · Cầu Giấy",
      "ĐH Bách khoa Hà Nội",
      "Mỹ Đình",
      "Cầu Giấy",
      "Hà Đông",
      "Thanh Xuân",
      "Hồ Hoàn Kiếm"
    ]
  },
  "04": {
    "code": "04",
    "name": "Cao Bằng",
    "locations": [
      "Trung tâm Cao Bằng",
      "Bệnh viện Đa khoa tỉnh Cao Bằng",
      "Khu vực Sông Bằng",
      "Thác Bản Giốc",
      "Trùng Khánh"
    ]
  },
  "08": {
    "code": "08",
    "name": "Tuyên Quang",
    "locations": [
      "Trung tâm Tuyên Quang",
      "ĐH Tân Trào",
      "Khu công nghiệp Long Bình An",
      "Trung tâm Hà Giang",
      "Đồng Văn",
      "Mèo Vạc"
    ]
  },
  "11": {
    "code": "11",
    "name": "Điện Biên",
    "locations": [
      "Trung tâm Điện Biên Phủ",
      "ĐH Điện Biên",
      "Bến xe Điện Biên",
      "Mường Thanh",
      "Sân bay Điện Biên"
    ]
  },
  "12": {
    "code": "12",
    "name": "Lai Châu",
    "locations": [
      "Trung tâm Lai Châu",
      "Bệnh viện Đa khoa Lai Châu",
      "Quảng trường Nhân dân",
      "Tam Đường",
      "Khu vực Tân Phong"
    ]
  },
  "14": {
    "code": "14",
    "name": "Sơn La",
    "locations": [
      "Trung tâm Sơn La",
      "ĐH Tây Bắc",
      "Bệnh viện Đa khoa Sơn La",
      "Mộc Châu",
      "Mai Sơn"
    ]
  },
  "15": {
    "code": "15",
    "name": "Lào Cai",
    "locations": [
      "Trung tâm Lào Cai",
      "Ga Lào Cai",
      "ĐH Thái Nguyên – Phân hiệu Lào Cai",
      "Sa Pa",
      "Trung tâm Yên Bái",
      "Nghĩa Lộ"
    ]
  },
  "19": {
    "code": "19",
    "name": "Thái Nguyên",
    "locations": [
      "ĐH Thái Nguyên",
      "ĐH Công nghiệp Thái Nguyên",
      "KCN Yên Bình",
      "Samsung Thái Nguyên",
      "Trung tâm Thái Nguyên",
      "Trung tâm Bắc Kạn"
    ]
  },
  "20": {
    "code": "20",
    "name": "Lạng Sơn",
    "locations": [
      "Trung tâm Lạng Sơn",
      "Chợ Đông Kinh",
      "Ga Đồng Đăng",
      "Cửa khẩu Hữu Nghị",
      "KCN Hữu Lũng"
    ]
  },
  "22": {
    "code": "22",
    "name": "Quảng Ninh",
    "locations": [
      "Hạ Long",
      "Bãi Cháy",
      "Hòn Gai",
      "ĐH Hạ Long",
      "Cẩm Phả",
      "Uông Bí",
      "KCN Quảng Yên"
    ]
  },
  "24": {
    "code": "24",
    "name": "Bắc Ninh",
    "locations": [
      "Trung tâm Bắc Ninh",
      "ĐH Kinh Bắc",
      "KCN VSIP Bắc Ninh",
      "KCN Yên Phong",
      "KCN Quế Võ",
      "Trung tâm Bắc Giang",
      "KCN Quang Châu"
    ]
  },
  "25": {
    "code": "25",
    "name": "Phú Thọ",
    "locations": [
      "Việt Trì",
      "ĐH Hùng Vương",
      "KCN Thụy Vân",
      "Trung tâm Vĩnh Yên",
      "KCN Khai Quang",
      "Trung tâm Hòa Bình",
      "KCN Lương Sơn"
    ]
  },
  "31": {
    "code": "31",
    "name": "Hải Phòng",
    "locations": [
      "Trung tâm Hải Phòng",
      "ĐH Hàng Hải Việt Nam",
      "ĐH Hải Phòng",
      "Lê Chân",
      "KCN Tràng Duệ",
      "VSIP Hải Phòng",
      "Trung tâm Hải Dương"
    ]
  },
  "33": {
    "code": "33",
    "name": "Hưng Yên",
    "locations": [
      "Trung tâm Hưng Yên",
      "Văn Giang",
      "Ecopark",
      "KCN Thăng Long II",
      "KCN Phố Nối",
      "Trung tâm Thái Bình",
      "ĐH Y Dược Thái Bình"
    ]
  },
  "37": {
    "code": "37",
    "name": "Ninh Bình",
    "locations": [
      "Trung tâm Ninh Bình",
      "ĐH Hoa Lư",
      "Tam Điệp",
      "Trung tâm Nam Định",
      "ĐH Điều dưỡng Nam Định",
      "Phủ Lý",
      "KCN Đồng Văn"
    ]
  },
  "38": {
    "code": "38",
    "name": "Thanh Hóa",
    "locations": [
      "Trung tâm Thanh Hóa",
      "ĐH Hồng Đức",
      "ĐH Văn hóa Thể thao và Du lịch Thanh Hóa",
      "KCN Lễ Môn",
      "Nghi Sơn",
      "Sầm Sơn"
    ]
  },
  "40": {
    "code": "40",
    "name": "Nghệ An",
    "locations": [
      "Trung tâm Vinh",
      "ĐH Vinh",
      "ĐH Y khoa Vinh",
      "Bến xe Vinh",
      "KCN VSIP Nghệ An",
      "Cửa Lò"
    ]
  },
  "42": {
    "code": "42",
    "name": "Hà Tĩnh",
    "locations": [
      "Trung tâm Hà Tĩnh",
      "ĐH Hà Tĩnh",
      "KCN Vũng Áng",
      "Kỳ Anh",
      "Hồng Lĩnh",
      "Bệnh viện Đa khoa Hà Tĩnh"
    ]
  },
  "44": {
    "code": "44",
    "name": "Quảng Trị",
    "locations": [
      "Đông Hà",
      "KCN Nam Đông Hà",
      "Lao Bảo",
      "Trung tâm Đồng Hới",
      "ĐH Quảng Bình",
      "Phong Nha"
    ]
  },
  "46": {
    "code": "46",
    "name": "Huế",
    "locations": [
      "ĐH Huế",
      "Bệnh viện Trung ương Huế",
      "Trung tâm Huế",
      "An Cựu",
      "Phú Bài",
      "KCN Phú Bài",
      "Đại Nội Huế"
    ]
  },
  "48": {
    "code": "48",
    "name": "Đà Nẵng",
    "locations": [
      "ĐH Bách khoa Đà Nẵng",
      "ĐH Kinh tế Đà Nẵng",
      "Hải Châu",
      "Ngũ Hành Sơn",
      "Liên Chiểu",
      "Hòa Khánh",
      "Hội An",
      "Tam Kỳ"
    ]
  },
  "51": {
    "code": "51",
    "name": "Quảng Ngãi",
    "locations": [
      "Trung tâm Quảng Ngãi",
      "ĐH Phạm Văn Đồng",
      "KCN VSIP Quảng Ngãi",
      "Dung Quất",
      "Trung tâm Kon Tum",
      "ĐH Đà Nẵng – Phân hiệu Kon Tum"
    ]
  },
  "52": {
    "code": "52",
    "name": "Gia Lai",
    "locations": [
      "Pleiku",
      "ĐH Nông Lâm TP.HCM – Phân hiệu Gia Lai",
      "KCN Trà Đa",
      "Quy Nhơn",
      "ĐH Quy Nhơn",
      "KCN Phú Tài",
      "Nhơn Hội"
    ]
  },
  "56": {
    "code": "56",
    "name": "Khánh Hòa",
    "locations": [
      "Nha Trang",
      "ĐH Nha Trang",
      "ĐH Khánh Hòa",
      "Cam Ranh",
      "KCN Suối Dầu",
      "Phan Rang",
      "KCN Du Long"
    ]
  },
  "66": {
    "code": "66",
    "name": "Đắk Lắk",
    "locations": [
      "Buôn Ma Thuột",
      "ĐH Tây Nguyên",
      "Bệnh viện Vùng Tây Nguyên",
      "KCN Hòa Phú",
      "Tuy Hòa",
      "ĐH Phú Yên",
      "KCN Hòa Hiệp"
    ]
  },
  "68": {
    "code": "68",
    "name": "Lâm Đồng",
    "locations": [
      "Đà Lạt",
      "ĐH Đà Lạt",
      "Bảo Lộc",
      "KCN Lộc Sơn",
      "Phan Thiết",
      "ĐH Phan Thiết",
      "Gia Nghĩa",
      "KCN Tâm Thắng"
    ]
  },
  "75": {
    "code": "75",
    "name": "Đồng Nai",
    "locations": [
      "Biên Hòa",
      "ĐH Lạc Hồng",
      "KCN Amata",
      "KCN Long Thành",
      "Sân bay Long Thành",
      "Đồng Xoài",
      "KCN Becamex Bình Phước",
      "Chơn Thành"
    ]
  },
  "79": {
    "code": "79",
    "name": "Hồ Chí Minh",
    "locations": [
      "ĐH Quốc gia TP.HCM · Thủ Đức",
      "ĐH Công nghiệp TP.HCM (IUH) · Gò Vấp",
      "ĐH Bách khoa TP.HCM",
      "Chợ Bến Thành",
      "Landmark 81",
      "Thủ Đức",
      "Thủ Dầu Một",
      "VSIP Bình Dương",
      "Vũng Tàu",
      "Phú Mỹ"
    ]
  },
  "80": {
    "code": "80",
    "name": "Tây Ninh",
    "locations": [
      "Trung tâm Tây Ninh",
      "KCN Phước Đông",
      "KCN Trảng Bàng",
      "Long An/Tân An",
      "ĐH Kinh tế Công nghiệp Long An",
      "KCN Long Hậu",
      "KCN Đức Hòa"
    ]
  },
  "82": {
    "code": "82",
    "name": "Đồng Tháp",
    "locations": [
      "Cao Lãnh",
      "ĐH Đồng Tháp",
      "Sa Đéc",
      "KCN Sa Đéc",
      "Mỹ Tho",
      "ĐH Tiền Giang",
      "KCN Tân Hương"
    ]
  },
  "86": {
    "code": "86",
    "name": "Vĩnh Long",
    "locations": [
      "Trung tâm Vĩnh Long",
      "ĐH Cửu Long",
      "ĐH Sư phạm Kỹ thuật Vĩnh Long",
      "Bến Tre",
      "Trà Vinh",
      "ĐH Trà Vinh",
      "KCN Long Đức"
    ]
  },
  "91": {
    "code": "91",
    "name": "An Giang",
    "locations": [
      "Long Xuyên",
      "ĐH An Giang",
      "Châu Đốc",
      "Rạch Giá",
      "ĐH Kiên Giang",
      "Phú Quốc",
      "Hà Tiên"
    ]
  },
  "92": {
    "code": "92",
    "name": "Cần Thơ",
    "locations": [
      "ĐH Cần Thơ",
      "ĐH Y Dược Cần Thơ",
      "Ninh Kiều",
      "Cái Răng",
      "KCN Trà Nóc",
      "Vị Thanh",
      "Sóc Trăng"
    ]
  },
  "96": {
    "code": "96",
    "name": "Cà Mau",
    "locations": [
      "Trung tâm Cà Mau",
      "ĐH Bình Dương – Phân hiệu Cà Mau",
      "KCN Khánh An",
      "Bạc Liêu",
      "ĐH Bạc Liêu",
      "Nhà máy Điện khí Cà Mau"
    ]
  }
}
$hs_featured_locations$::jsonb) AS p
    CROSS JOIN LATERAL jsonb_array_elements_text(p.value->'locations')
        WITH ORDINALITY AS loc(location_label, location_order)
)
SELECT row_number() OVER (ORDER BY province_code, location_order)::int AS place_id,
       province_code,
       CASE WHEN province_code IN ('01','31','46','48','79','92')
            THEN 'Thành phố ' ELSE 'Tỉnh ' END || province_short_name AS province_name,
       location_label,
       CASE
         WHEN province_code='79' AND location_label ILIKE '%Gò Vấp%' THEN 'Phường Gò Vấp'
         WHEN province_code='79' AND location_label ILIKE '%Bến Thành%' THEN 'Phường Bến Thành'
         WHEN province_code='79' AND location_label ILIKE '%Landmark 81%' THEN 'Phường Bình Thạnh'
         WHEN province_code='79' AND location_label ILIKE '%Thủ Đức%' THEN 'Phường Thủ Đức'
         WHEN province_code='79' AND location_label ILIKE '%Bách khoa%' THEN 'Phường Diên Hồng'
         WHEN province_code='01' AND location_label ILIKE '%Cầu Giấy%' THEN 'Phường Cầu Giấy'
         WHEN province_code='01' AND location_label ILIKE '%Bách khoa%' THEN 'Phường Bạch Mai'
         WHEN province_code='01' AND location_label ILIKE '%Mỹ Đình%' THEN 'Phường Mỹ Đình'
         WHEN province_code='01' AND location_label ILIKE '%Hà Đông%' THEN 'Phường Hà Đông'
         WHEN province_code='01' AND location_label ILIKE '%Thanh Xuân%' THEN 'Phường Thanh Xuân'
         WHEN province_code='01' AND location_label ILIKE '%Hoàn Kiếm%' THEN 'Phường Hoàn Kiếm'
         WHEN location_label LIKE '% · %' THEN 'Khu vực ' || split_part(location_label, ' · ', 2)
         WHEN location_label LIKE 'Trung tâm %' THEN 'Khu vực ' || substring(location_label from 12)
         ELSE 'Khu vực ' || location_label
       END AS ward_name
FROM place_source;

CREATE TEMP TABLE hs_seed_rows ON COMMIT DROP AS
WITH place_count AS (
    SELECT count(*)::int AS total FROM hs_seed_places
), numbered AS (
    SELECT n, p.*, ((n-1) / pc.total)::int AS place_round,
           CASE ((p.place_id + ((n-1) / pc.total)::int) % 3)
             WHEN 0 THEN 'HOUSE' WHEN 1 THEN 'APARTMENT' ELSE 'ROOM'
           END AS category,
           get_byte(decode(md5('hs-seed-price-' || n::text), 'hex'), 0) AS price_var,
           get_byte(decode(md5('hs-seed-area-' || n::text), 'hex'), 0) AS area_var,
           get_byte(decode(md5('hs-seed-extra-' || n::text), 'hex'), 0) AS extra_var,
           (ARRAY['Gần tuyến giao thông chính','Khu vực thuận tiện đi học và đi làm',
                  'Không gian sống yên tĩnh','Dễ tiếp cận chợ và dịch vụ thiết yếu',
                  'Có thể hẹn xem nhà vào nhiều khung giờ',
                  'Phù hợp người thuê ưu tiên tiện ích xung quanh'])[(n % 6)+1] AS selling_point
    FROM generate_series(1,1000) AS n
    CROSS JOIN place_count pc
    JOIN hs_seed_places p ON p.place_id = ((n-1) % pc.total) + 1
), props AS (
    SELECT *,
           CASE category
             WHEN 'HOUSE' THEN format('Nhà nguyên căn %s khu vực %s · HS%s',
                   (ARRAY['có sân để xe','hẻm rộng','nhiều phòng ngủ','có sân thượng',
                          'nội thất cơ bản','phù hợp gia đình'])[(extra_var % 6)+1], location_label, lpad(n::text,4,'0'))
             WHEN 'APARTMENT' THEN format('Căn hộ %s khu vực %s · HS%s',
                   (ARRAY['ban công thoáng','view nội khu','gần tiện ích','cao tầng',
                          'nội thất mới','phù hợp gia đình nhỏ'])[(extra_var % 6)+1], location_label, lpad(n::text,4,'0'))
             ELSE format('Phòng trọ %s khu vực %s · HS%s',
                   (ARRAY['có gác','cửa sổ thoáng','có ban công','giá hợp lý',
                          'bếp riêng','giờ giấc linh hoạt'])[(extra_var % 6)+1], location_label, lpad(n::text,4,'0'))
           END AS title,
           (CASE category
             WHEN 'HOUSE' THEN 'Nhà nguyên căn phù hợp gia đình hoặc nhóm đi làm. '
             WHEN 'APARTMENT' THEN 'Căn hộ riêng tư với không gian sinh hoạt độc lập. '
             ELSE 'Phòng trọ phù hợp sinh viên hoặc người đi làm. '
           END) || selling_point || '. Địa điểm tham chiếu: ' || location_label ||
           ', ' || province_name || '. ' ||
           CASE WHEN location_label LIKE 'ĐH %' OR location_label LIKE '% · %'
                THEN 'Tên tìm kiếm mở rộng: ' || replace(location_label, 'ĐH ', 'Đại học ') || '. '
                WHEN location_label LIKE 'KCN %'
                THEN 'Tên tìm kiếm mở rộng: ' || replace(location_label, 'KCN ', 'Khu công nghiệp ') || '. '
                ELSE '' END ||
           (ARRAY['Có thể trao đổi thêm về thời điểm bàn giao.',
                  'Các khoản phí và điều kiện thuê được ghi theo từng mục.',
                  'Nên đặt lịch xem để kiểm tra không gian thực tế.',
                  'Vui lòng xác nhận địa chỉ và khoảng cách thực tế với chủ nhà.'])[(extra_var % 4)+1]
           AS description,
           CASE category WHEN 'HOUSE' THEN 65 + area_var % 150 + (n % 4) * 0.5
                         WHEN 'APARTMENT' THEN 30 + area_var % 95 + (n % 4) * 0.5
                         ELSE 15 + area_var % 30 + (n % 4) * 0.5 END::numeric(12,2) AS area_m2,
           CASE category
             WHEN 'HOUSE' THEN 7000000 + (price_var % 130) * 200000
             WHEN 'APARTMENT' THEN 4300000 + (price_var % 115) * 150000
             ELSE 1400000 + (price_var % 95) * 40000
           END::numeric(18,2) AS price_amount,
           current_date + (extra_var % 75) AS available_from,
           CASE WHEN n % 5 = 0 THEN 'FIXED_AMOUNT' ELSE 'MONTH_COUNT' END AS deposit_type,
           CASE WHEN n % 5 = 0 THEN
             (CASE category WHEN 'HOUSE' THEN 6000000 + (n % 8)*1000000
                            WHEN 'APARTMENT' THEN 4000000 + (n % 6)*750000
                            ELSE 1500000 + (n % 7)*250000 END)::numeric(18,2)
           END AS deposit_amount,
           CASE WHEN n % 5 = 0 THEN NULL ELSE 1 + (n % 3) END AS deposit_months,
           CASE WHEN category='ROOM' AND n % 11 = 0 THEN 'PERSON_MONTH'
                WHEN category='ROOM' THEN 'ROOM_MONTH' ELSE 'MONTH' END AS price_unit,
           (ARRAY[1,3,6,12])[(extra_var % 4)+1] AS min_lease_months,
           CASE WHEN n % 7 = 0 THEN 'NONE'
                WHEN n % 3 = 0 THEN 'PAID' ELSE 'FREE' END AS room_parking_policy,
           CASE WHEN n % 7 = 0 THEN 0 ELSE 1 + (n % 3) END AS room_max_vehicles,
           (n % 4 = 0) AS house_has_garage
    FROM numbered
)
SELECT p.*, c.owner_id,
       md5('homespace-ai-listing-seed-v1-' || p.n::text)::uuid AS listing_id,
       ('P' || lpad(n::text, 4, '0')) AS room_code,
       (ARRAY['Góc đọc sách','Sân phơi chung','Không gian làm việc',
              'Khu để xe có mái che','Ban công đón gió','Sảnh sinh hoạt chung',
              'Khu vực cây xanh','Tủ nhận hàng'])[(extra_var % 8)+1] AS extra_amenity
FROM props p CROSS JOIN hs_seed_config c;

-- Khi nâng từ bản seed 100 tin, ID cũ có thể đổi loại hình/chính sách gửi xe.
-- Chỉ dọn chi tiết lỗi thời gắn với chính những ID seed này; không đụng tin thật.
DELETE FROM listing_house_details d USING hs_seed_rows s
WHERE d.listing_id=s.listing_id::text AND s.category<>'HOUSE';
DELETE FROM listing_apartment_details d USING hs_seed_rows s
WHERE d.listing_id=s.listing_id::text AND s.category<>'APARTMENT';
DELETE FROM listing_room_details d USING hs_seed_rows s
WHERE d.listing_id=s.listing_id::text AND s.category<>'ROOM';
DELETE FROM listing_charges c USING hs_seed_rows s
WHERE c.listing_id=s.listing_id::text AND (
    (c.charge_type='MOTORBIKE_PARKING' AND s.category='ROOM'
        AND s.room_parking_policy='NONE')
    OR (c.charge_type='CAR_PARKING' AND
        (s.category='ROOM' OR (s.category='HOUSE' AND NOT s.house_has_garage)
         OR (s.category='APARTMENT' AND s.n % 5 <> 0)))
);

-- Listing core: publication is set directly to PUBLISHED so public search/AI can retrieve these records.
INSERT INTO listings (
    id, owner_id, branch_id, title, description, category, status, status_reason,
    status_changed_at, status_changed_by, submitted_at, published_at, expires_at,
    version, available_from, area_m2, price_amount, currency, price_unit, negotiable,
    deposit_type, deposit_amount, deposit_months, payment_cycle, minimum_lease_months,
    management_fee_included, vat_included, max_motorbike_count, max_car_count,
    view_count, active, created_at, updated_at, created_by, updated_by
)
SELECT listing_id::text, owner_id, NULL, title, description, category, 'PUBLISHED', 'Seed dữ liệu thử nghiệm AI',
       now(), owner_id, now(), now(), now() + interval '180 days', 0, available_from,
       area_m2, price_amount, 'VND', price_unit, (n % 3 = 0), deposit_type, deposit_amount,
       deposit_months, 'MONTHLY', min_lease_months, (category='ROOM' OR n % 4 = 0), (n % 13 = 0),
       CASE WHEN category = 'ROOM' THEN room_max_vehicles ELSE 1 + (n % 4) END,
       CASE WHEN category = 'HOUSE' AND house_has_garage THEN 1 + (n % 2)
            WHEN category = 'APARTMENT' AND n % 5 = 0 THEN 1 ELSE 0 END,
       0, true, now() - (n || ' hours')::interval, now(), owner_id, owner_id
FROM hs_seed_rows
ON CONFLICT (id) DO UPDATE SET
    owner_id=excluded.owner_id, title=excluded.title, description=excluded.description,
    category=excluded.category, status='PUBLISHED', published_at=now(),
    expires_at=now() + interval '180 days', available_from=excluded.available_from,
    area_m2=excluded.area_m2, price_amount=excluded.price_amount, currency=excluded.currency,
    price_unit=excluded.price_unit, negotiable=excluded.negotiable, deposit_type=excluded.deposit_type,
    deposit_amount=excluded.deposit_amount, deposit_months=excluded.deposit_months,
    payment_cycle=excluded.payment_cycle, minimum_lease_months=excluded.minimum_lease_months,
    management_fee_included=excluded.management_fee_included, vat_included=excluded.vat_included,
    max_motorbike_count=excluded.max_motorbike_count, max_car_count=excluded.max_car_count,
    active=true, updated_at=now(), updated_by=excluded.updated_by;

-- Address/location fields. Codes are stable seed identifiers; names/full_address are for search text.
INSERT INTO addresses (
    id, user_id, listing_id, branch_id, province_code, province_name, ward_code, ward_name,
    street_line, full_address, active, created_at, updated_at, created_by, updated_by
)
SELECT md5('homespace-ai-listing-seed-v1-address-' || n::text)::uuid::text,
       NULL, listing_id::text, NULL, province_code, province_name,
       province_code || '-SEED-' || lpad(n::text,4,'0'), ward_name,
       ((n % 99) + 1)::text || ' Đường nội khu ' || (1 + extra_var % 20)::text,
       ((n % 99) + 1)::text || ' Đường nội khu ' || (1 + extra_var % 20)::text ||
       ', ' || ward_name || ', khu vực ' || location_label || ', ' || province_name,
       true, now(), now(), owner_id, owner_id
FROM hs_seed_rows
ON CONFLICT (listing_id) DO UPDATE SET
    province_code=excluded.province_code, province_name=excluded.province_name,
    ward_code=excluded.ward_code, ward_name=excluded.ward_name,
    street_line=excluded.street_line, full_address=excluded.full_address,
    active=true, updated_at=now(), updated_by=excluded.updated_by;

-- HOUSE-specific fields.
INSERT INTO listing_house_details (
    listing_id, land_area_m2, frontage_width_m, length_m, access_road_width_m, frontage_count,
    total_floors, bedroom_count, bathroom_count, living_room_count, kitchen_count, has_rooftop,
    has_garage, access_type, max_occupants, max_vehicles, furnishing_status, legal_status,
    rental_scope_description, rented_floor_from, rented_floor_to
)
SELECT listing_id::text, area_m2 + 8 + (n % 4) * 3, 4 + (n % 4) * 0.5, 14 + (n % 7),
       3 + (n % 5) * 0.5, 1 + (n % 2), 2 + (n % 4), 2 + (n % 4), 1 + (n % 3),
       1 + (n % 2), 1, n % 3 = 0, house_has_garage,
       CASE WHEN n % 3 = 0 THEN 'HẺM XE HƠI' ELSE 'ĐƯỜNG NỘI BỘ' END,
       3 + (n % 5), 1 + (n % 4),
       CASE n % 4 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' ELSE 'UNFURNISHED' END,
       CASE n % 3 WHEN 0 THEN 'Sổ hồng riêng' WHEN 1 THEN 'Giấy tờ hợp lệ, trao đổi khi xem nhà' ELSE 'Hợp đồng sở hữu được cung cấp khi xem nhà' END,
       CASE WHEN n % 4 = 0 THEN 'Cho thuê toàn bộ nhà'
            ELSE format('Cho thuê từ tầng 2 đến tầng %s', 2 + (n % 4)) END,
       CASE WHEN n % 4 = 0 THEN 1 ELSE 2 END, 2 + (n % 4)
FROM hs_seed_rows WHERE category='HOUSE'
ON CONFLICT (listing_id) DO UPDATE SET land_area_m2=excluded.land_area_m2,
    frontage_width_m=excluded.frontage_width_m, length_m=excluded.length_m,
    access_road_width_m=excluded.access_road_width_m, frontage_count=excluded.frontage_count,
    total_floors=excluded.total_floors, bedroom_count=excluded.bedroom_count,
    bathroom_count=excluded.bathroom_count, living_room_count=excluded.living_room_count,
    kitchen_count=excluded.kitchen_count, has_rooftop=excluded.has_rooftop,
    has_garage=excluded.has_garage, access_type=excluded.access_type,
    max_occupants=excluded.max_occupants, max_vehicles=excluded.max_vehicles,
    furnishing_status=excluded.furnishing_status, legal_status=excluded.legal_status,
    rental_scope_description=excluded.rental_scope_description,
    rented_floor_from=excluded.rented_floor_from, rented_floor_to=excluded.rented_floor_to;

-- APARTMENT-specific fields.
INSERT INTO listing_apartment_details (
    listing_id, project_name, building_block, unit_code, floor_number, building_total_floors,
    bedroom_count, bathroom_count, living_room_count, kitchen_count, furnishing_status,
    main_door_direction, balcony_direction, view_description, max_occupants, legal_status
)
SELECT listing_id::text,
       'Tòa căn hộ khu vực ' || location_label,
       (ARRAY['Block A','Block B','Tháp 1','Tháp 2','Block C','Tòa Đông','Tòa Tây'])[(n % 7)+1],
       'A' || (100 + n)::text, 2 + (n % 20), 25 + (n % 20),
       1 + (n % 3), 1 + (n % 2), CASE WHEN n % 7 = 0 THEN 0 ELSE 1 END, 1,
       CASE n % 5 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' WHEN 3 THEN 'LUXURY' ELSE 'UNFURNISHED' END,
       (ARRAY['Đông','Tây','Nam','Bắc'])[(n % 4)+1],
       (ARRAY['Đông Nam','Đông Bắc','Tây Nam','Tây Bắc'])[(n % 4)+1],
       (ARRAY['View thành phố','View cây xanh','View sân nội khu','View quảng trường',
              'View nội khu yên tĩnh','View thoáng không bị chắn'])[(n % 6)+1],
       2 * (1 + (n % 3)), CASE WHEN n % 2 = 0 THEN 'Sổ hồng' ELSE 'Hợp đồng mua bán' END
FROM hs_seed_rows WHERE category='APARTMENT'
ON CONFLICT (listing_id) DO UPDATE SET project_name=excluded.project_name,
    building_block=excluded.building_block, unit_code=excluded.unit_code,
    floor_number=excluded.floor_number, building_total_floors=excluded.building_total_floors,
    bedroom_count=excluded.bedroom_count, bathroom_count=excluded.bathroom_count,
    living_room_count=excluded.living_room_count, kitchen_count=excluded.kitchen_count,
    furnishing_status=excluded.furnishing_status, main_door_direction=excluded.main_door_direction,
    balcony_direction=excluded.balcony_direction, view_description=excluded.view_description,
    max_occupants=excluded.max_occupants, legal_status=excluded.legal_status;

-- ROOM-specific fields.
INSERT INTO listing_room_details (
    listing_id, room_code, floor_number, restroom_type, kitchen_type, has_window,
    balcony_type, has_balcony, has_mezzanine, furnishing_status, access_type,
    access_hours_type, electric_meter_type, water_meter_type, max_occupants,
    max_vehicles, parking_policy
)
SELECT listing_id::text, room_code, n % 5,
       CASE WHEN n % 4 = 0 THEN 'SHARED' ELSE 'PRIVATE' END,
       CASE n % 3 WHEN 0 THEN 'PRIVATE' WHEN 1 THEN 'SHARED' ELSE 'NONE' END,
       n % 5 <> 0, CASE WHEN n % 4 = 0 THEN 'SHARED' WHEN n % 4 = 1 THEN 'NONE' ELSE 'PRIVATE' END,
       n % 4 <> 1, n % 3 = 0,
       CASE n % 4 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' ELSE 'UNFURNISHED' END,
       CASE WHEN n % 5 = 0 THEN 'SHARED' ELSE 'PRIVATE' END,
       CASE WHEN n % 6 = 0 THEN 'CURFEW' ELSE 'FLEXIBLE' END,
       CASE WHEN n % 3 = 0 THEN 'SHARED' ELSE 'PRIVATE' END,
       CASE WHEN n % 4 = 0 THEN 'SHARED' ELSE 'PRIVATE' END,
       1 + (n % 3), room_max_vehicles, room_parking_policy
FROM hs_seed_rows WHERE category='ROOM'
ON CONFLICT (listing_id) DO UPDATE SET room_code=excluded.room_code,
    floor_number=excluded.floor_number, restroom_type=excluded.restroom_type,
    kitchen_type=excluded.kitchen_type, has_window=excluded.has_window,
    balcony_type=excluded.balcony_type, has_balcony=excluded.has_balcony,
    has_mezzanine=excluded.has_mezzanine, furnishing_status=excluded.furnishing_status,
    access_type=excluded.access_type, access_hours_type=excluded.access_hours_type,
    electric_meter_type=excluded.electric_meter_type, water_meter_type=excluded.water_meter_type,
    max_occupants=excluded.max_occupants, max_vehicles=excluded.max_vehicles,
    parking_policy=excluded.parking_policy;

-- Monthly charges: electricity, water, management, internet, garbage/service, and parking.
WITH charge_seed AS (
    SELECT s.*, v.charge_type, v.billing_method, v.amount, v.unit, v.included, v.custom_name, v.sort_order
    FROM hs_seed_rows s
    CROSS JOIN LATERAL (VALUES
      ('ELECTRICITY','PER_KWH',(2800 + (s.price_var % 11)*125)::numeric,'kWh',false,NULL::text,1),
      ('WATER','PER_M3',(12000 + (s.area_var % 13)*750)::numeric,'m³',false,NULL::text,2),
      ('MANAGEMENT','PER_MONTH',(CASE WHEN s.category='ROOM' OR s.n % 4=0 THEN 0
           ELSE 100000 + (s.extra_var % 9)*35000 END)::numeric,'tháng',
           s.category='ROOM' OR s.n % 4=0,NULL::text,3),
      ('INTERNET','PER_MONTH',(CASE WHEN s.n % 6=0 THEN 0 ELSE 60000 + (s.price_var % 8)*15000 END)::numeric,
           'tháng',s.n % 6=0,NULL::text,4),
      ('SERVICE_OR_GARBAGE','PER_PERSON_MONTH',(CASE WHEN s.n % 11=0 THEN 0
           ELSE 15000 + (s.area_var % 9)*5000 END)::numeric,'người/tháng',s.n % 11=0,NULL::text,5),
      ('MOTORBIKE_PARKING','PER_VEHICLE_MONTH',(CASE
           WHEN s.category='HOUSE' OR (s.category='ROOM' AND s.room_parking_policy='FREE')
                OR (s.category='APARTMENT' AND s.n % 4=0) THEN 0
           ELSE 50000 + (s.extra_var % 10)*10000 END)::numeric,'xe/tháng',
           s.category='HOUSE' OR (s.category='ROOM' AND s.room_parking_policy='FREE')
                OR (s.category='APARTMENT' AND s.n % 4=0),NULL::text,6),
      ('CAR_PARKING','PER_VEHICLE_MONTH',(CASE WHEN s.category='APARTMENT'
           THEN 350000 + (s.price_var % 9)*75000 ELSE 0 END)::numeric,
           'xe/tháng',s.category='HOUSE',NULL::text,7)
    ) AS v(charge_type,billing_method,amount,unit,included,custom_name,sort_order)
    WHERE NOT (s.category='ROOM' AND s.room_parking_policy='NONE'
               AND v.charge_type='MOTORBIKE_PARKING')
      AND NOT (v.charge_type='CAR_PARKING' AND
               (s.category='ROOM' OR (s.category='HOUSE' AND NOT s.house_has_garage)
                OR (s.category='APARTMENT' AND s.n % 5 <> 0)))
)
INSERT INTO listing_charges (
    id, listing_id, charge_type, billing_method, amount, currency, unit, included_in_rent,
    custom_name, description, sort_order, active, created_at, updated_at, created_by, updated_by
)
SELECT md5('homespace-ai-listing-seed-v1-charge-' || n::text || '-' || sort_order::text)::uuid::text,
       listing_id::text, charge_type, billing_method, amount, 'VND', unit, included,
       custom_name, CASE charge_type
         WHEN 'ELECTRICITY' THEN 'Tính theo đồng hồ điện và đơn giá ghi trong hợp đồng.'
         WHEN 'WATER' THEN 'Tính theo đồng hồ nước và đơn giá ghi trong hợp đồng.'
         ELSE 'Khoản phí tham khảo mỗi tháng; xác nhận với chủ nhà khi xem.' END,
       sort_order, true, now(), now(), owner_id, owner_id
FROM charge_seed
ON CONFLICT (id) DO UPDATE SET charge_type=excluded.charge_type,
    billing_method=excluded.billing_method, amount=excluded.amount, currency=excluded.currency,
    unit=excluded.unit, included_in_rent=excluded.included_in_rent,
    custom_name=excluded.custom_name, description=excluded.description,
    sort_order=excluded.sort_order, active=true, updated_at=now(), updated_by=excluded.updated_by;

-- Amenities chosen from the live catalog, constrained to categories supported by each amenity.
WITH amenity_seed AS (
    SELECT s.*, a.code
    FROM hs_seed_rows s
    CROSS JOIN LATERAL unnest(ARRAY[
       'WIFI','AIR_CONDITIONER','WATER_HEATER','REFRIGERATOR','WASHING_MACHINE',
       'ELEVATOR','PARKING','SECURITY_24_7','CAMERA','PETS_ALLOWED',
       'SWIMMING_POOL','GYM'
    ]) AS chosen(code)
    JOIN amenities a ON a.code=chosen.code AND a.active IS TRUE
    JOIN amenity_categories ac ON ac.amenity_id=a.id AND ac.category=s.category
    WHERE CASE chosen.code
      WHEN 'WIFI' THEN s.n % 11 <> 0
      WHEN 'AIR_CONDITIONER' THEN s.n % 3 <> 0
      WHEN 'WATER_HEATER' THEN s.n % 4 <> 0
      WHEN 'REFRIGERATOR' THEN s.n % 5 <> 0
      WHEN 'WASHING_MACHINE' THEN s.n % 6 = 0
      WHEN 'ELEVATOR' THEN s.category='APARTMENT' OR s.n % 5 = 0
      WHEN 'PARKING' THEN s.n % 4 <> 0
      WHEN 'SECURITY_24_7' THEN s.n % 3 = 0
      WHEN 'CAMERA' THEN s.n % 4 = 0
      WHEN 'PETS_ALLOWED' THEN s.n % 4 = 1
      WHEN 'SWIMMING_POOL' THEN s.n % 13 = 0
      WHEN 'GYM' THEN s.n % 7 = 0
      ELSE false END
)
INSERT INTO listing_amenities (listing_id, amenity_id)
SELECT DISTINCT listing_id::text, a.id
FROM amenity_seed x JOIN amenities a ON a.code=x.code
ON CONFLICT DO NOTHING;

-- Furnishing inventory snapshots for all furnished listings.
WITH furnishing_seed AS (
    SELECT s.*, fi.code, fi.id AS furnishing_item_id,
           row_number() OVER (PARTITION BY s.n ORDER BY fi.code)::int AS sort_order,
           CASE WHEN get_byte(decode(md5(s.n::text || fi.code), 'hex'), 0) % 9=0 THEN 'BRAND_NEW'
                WHEN get_byte(decode(md5(s.n::text || fi.code), 'hex'), 0) % 4=0 THEN 'NORMAL'
                ELSE 'GOOD' END AS handover_condition
    FROM hs_seed_rows s
    JOIN LATERAL unnest(ARRAY[
      'BED','WARDROBE','WORK_DESK','KITCHEN_SHELF','REFRIGERATOR',
      'WASHING_MACHINE','WATER_HEATER','CURTAIN','FAN','SOFA_SET',
      'DINING_SET','TV','KITCHEN_CABINET','COOKTOP','AIR_CONDITIONER','LIGHTING'
    ]) chosen(code) ON true
    JOIN furnishing_items fi ON fi.code=chosen.code AND fi.active IS TRUE
    JOIN furnishing_item_categories fic ON fic.furnishing_item_id=fi.id AND fic.category=s.category
    WHERE CASE s.category
       WHEN 'HOUSE' THEN (CASE s.n % 4 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' ELSE 'UNFURNISHED' END) <> 'UNFURNISHED'
       WHEN 'APARTMENT' THEN (CASE s.n % 5 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' WHEN 3 THEN 'LUXURY' ELSE 'UNFURNISHED' END) <> 'UNFURNISHED'
       ELSE (CASE s.n % 4 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' ELSE 'UNFURNISHED' END) <> 'UNFURNISHED'
    END
      AND (fi.code='BED' OR get_byte(decode(md5(s.n::text || fi.code), 'hex'), 0) % 3 = 0)
)
INSERT INTO listing_furnishing_assets (
    id, listing_id, furnishing_item_id, item_code, asset_name, quantity,
    handover_condition, condition_note, sort_order
)
SELECT md5('homespace-ai-listing-seed-v1-furnishing-' || fs.n::text || '-' || fs.code)::uuid::text,
       listing_id::text, furnishing_item_id, fs.code, fi.name,
       CASE WHEN fs.code IN ('CURTAIN','LIGHTING') THEN 1 + fs.n % 3 ELSE 1 END,
       handover_condition, 'Dữ liệu kiểm thử; tình trạng thực tế cần xác nhận khi bàn giao.', fs.sort_order
FROM furnishing_seed fs JOIN furnishing_items fi ON fi.id=fs.furnishing_item_id
ON CONFLICT (id) DO UPDATE SET furnishing_item_id=excluded.furnishing_item_id,
    item_code=excluded.item_code, asset_name=excluded.asset_name, quantity=excluded.quantity,
    handover_condition=excluded.handover_condition, condition_note=excluded.condition_note,
    sort_order=excluded.sort_order;

-- Custom amenity / free-text utility field from the form.
INSERT INTO listing_custom_amenities (id, listing_id, name)
SELECT md5('homespace-ai-listing-seed-v1-custom-' || n::text)::uuid::text,
       listing_id::text, extra_amenity
FROM hs_seed_rows
ON CONFLICT (id) DO UPDATE SET name=excluded.name;

-- Viewing availability: mix weekdays and morning/afternoon/evening slots.
INSERT INTO listing_viewing_days (listing_id, day_of_week)
SELECT listing_id::text, day_name
FROM hs_seed_rows s
CROSS JOIN LATERAL unnest(ARRAY['MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY']) AS d(day_name)
WHERE (get_byte(decode(md5(n::text || d.day_name), 'hex'), 0) % 3) <> 0
ON CONFLICT DO NOTHING;

INSERT INTO listing_viewing_slots (listing_id, viewing_slot)
SELECT listing_id::text, slot_name
FROM hs_seed_rows s
CROSS JOIN LATERAL unnest(ARRAY['MORNING','AFTERNOON','EVENING']) AS v(slot_name)
WHERE (get_byte(decode(md5(n::text || v.slot_name), 'hex'), 0) % 4) <> 0
ON CONFLICT DO NOTHING;

-- Three existing S3 images shared across the seed listings.
WITH media_seed AS (
    SELECT s.*, m.media_order, m.file_name, m.sample_url,
           md5('homespace-seed-s3-object-' || m.media_order::text)::uuid::text AS storage_id,
           md5('homespace-ai-listing-seed-v1-media-' || s.n::text || '-' || m.media_order::text)::uuid::text AS media_id
    FROM hs_seed_rows s
    CROSS JOIN (VALUES
      (1, '1ffbe426-4e8b-419e-95b1-a2f6b2308387.jpg', 'https://homespace-dev-files-v3.s3.ap-southeast-1.amazonaws.com/listing_image/8aeaf925-16d8-47d3-b377-c4fc83dafd56/1ffbe426-4e8b-419e-95b1-a2f6b2308387.jpg'),
      (2, 'ddc2b657-c112-48db-916e-f2fd754b77c2.jpg', 'https://homespace-dev-files-v3.s3.ap-southeast-1.amazonaws.com/listing_image/8aeaf925-16d8-47d3-b377-c4fc83dafd56/ddc2b657-c112-48db-916e-f2fd754b77c2.jpg'),
      (3, '2d808406-f5ca-470e-9ed9-2b85c3ba4366.jpg', 'https://homespace-dev-files-v3.s3.ap-southeast-1.amazonaws.com/listing_image/8aeaf925-16d8-47d3-b377-c4fc83dafd56/2d808406-f5ca-470e-9ed9-2b85c3ba4366.jpg')
    ) AS m(media_order, file_name, sample_url)
)
INSERT INTO storage_objects (
    id, original_name, object_key, bucket_name, content_type, size_bytes, checksum, extension,
    owner_id, reference_type, reference_id, purpose, visibility, status,
    active, created_at, updated_at, created_by, updated_by
)
SELECT storage_id, file_name,
       'listing_image/8aeaf925-16d8-47d3-b377-c4fc83dafd56/' || file_name, 'homespace-dev-files-v3',
       'image/jpeg', 1000000, md5(file_name), 'jpg', owner_id, NULL, NULL,
       'LISTING_IMAGE', 'PUBLIC', 'READY', true, now(), now(), owner_id, owner_id
FROM (SELECT DISTINCT storage_id, file_name, sample_url, owner_id, media_order FROM media_seed) media_seed
ON CONFLICT (id) DO UPDATE SET original_name=excluded.original_name,
    object_key=excluded.object_key, bucket_name=excluded.bucket_name, content_type=excluded.content_type,
    size_bytes=excluded.size_bytes, checksum=excluded.checksum, extension=excluded.extension,
    owner_id=excluded.owner_id, reference_type=excluded.reference_type,
    reference_id=excluded.reference_id, purpose=excluded.purpose,
    visibility=excluded.visibility, status='READY', active=true, updated_at=now(), updated_by=excluded.updated_by;

WITH media_seed AS (
    SELECT s.*, m.media_order, m.file_name, m.sample_url,
           md5('homespace-seed-s3-object-' || m.media_order::text)::uuid::text AS storage_id,
           md5('homespace-ai-listing-seed-v1-media-' || s.n::text || '-' || m.media_order::text)::uuid::text AS media_id
    FROM hs_seed_rows s
    CROSS JOIN (VALUES
      (1, '1ffbe426-4e8b-419e-95b1-a2f6b2308387.jpg', 'https://homespace-dev-files-v3.s3.ap-southeast-1.amazonaws.com/listing_image/8aeaf925-16d8-47d3-b377-c4fc83dafd56/1ffbe426-4e8b-419e-95b1-a2f6b2308387.jpg'),
      (2, 'ddc2b657-c112-48db-916e-f2fd754b77c2.jpg', 'https://homespace-dev-files-v3.s3.ap-southeast-1.amazonaws.com/listing_image/8aeaf925-16d8-47d3-b377-c4fc83dafd56/ddc2b657-c112-48db-916e-f2fd754b77c2.jpg'),
      (3, '2d808406-f5ca-470e-9ed9-2b85c3ba4366.jpg', 'https://homespace-dev-files-v3.s3.ap-southeast-1.amazonaws.com/listing_image/8aeaf925-16d8-47d3-b377-c4fc83dafd56/2d808406-f5ca-470e-9ed9-2b85c3ba4366.jpg')
    ) AS m(media_order, file_name, sample_url)
)
INSERT INTO listing_media (
    id, listing_id, storage_object_id, media_type, sort_order, is_cover, media_url,
    active, created_at, updated_at, created_by, updated_by
)
SELECT media_id, listing_id::text, storage_id, 'IMAGE', media_order - 1,
       media_order = 1, sample_url, true, now(), now(), owner_id, owner_id
FROM media_seed
ON CONFLICT (id) DO UPDATE SET listing_id=excluded.listing_id,
    storage_object_id=excluded.storage_object_id, media_type=excluded.media_type,
    sort_order=excluded.sort_order, is_cover=excluded.is_cover, media_url=excluded.media_url,
    active=true, updated_at=now(), updated_by=excluded.updated_by;

-- Quick summary before commit; the temp seed table is dropped by COMMIT.
DO $$
BEGIN
    IF (SELECT count(*) FROM hs_seed_places) <> 225
       OR (SELECT count(DISTINCT province_code) FROM hs_seed_places) <> 34 THEN
        RAISE EXCEPTION 'Danh sách địa điểm nổi bật phải có 225 địa điểm / 34 tỉnh-thành';
    END IF;
    IF (SELECT count(*) FROM hs_seed_rows) <> 1000 THEN
        RAISE EXCEPTION 'Seed phải tạo đúng 1.000 tin đăng';
    END IF;
    IF EXISTS (
        SELECT 1 FROM hs_seed_rows GROUP BY place_id
        HAVING count(*) NOT BETWEEN 4 AND 5 OR count(DISTINCT category) <> 3
    ) THEN
        RAISE EXCEPTION 'Mỗi địa điểm phải có 4-5 tin và đủ 3 loại hình';
    END IF;
    IF (
        SELECT count(*) FROM listings l
        JOIN hs_seed_rows s ON s.listing_id::text=l.id
        WHERE l.active IS TRUE AND l.status='PUBLISHED'
    ) <> 1000 OR (
        SELECT count(*) FROM addresses a
        JOIN hs_seed_rows s ON s.listing_id::text=a.listing_id
        WHERE a.active IS TRUE
    ) <> 1000 THEN
        RAISE EXCEPTION 'Seed chưa tạo đủ 1.000 tin và địa chỉ đang hoạt động';
    END IF;
    IF EXISTS (
        SELECT 1 FROM hs_seed_rows s
        JOIN addresses a ON a.listing_id=s.listing_id::text
        WHERE a.province_code<>s.province_code OR a.ward_name<>s.ward_name
           OR a.full_address NOT LIKE '%' || s.location_label || ', ' || s.province_name
           OR ltrim(s.title) NOT LIKE '%' || s.location_label || '%'
    ) THEN
        RAISE EXCEPTION 'Tiêu đề/địa chỉ seed không khớp địa điểm nổi bật';
    END IF;
    IF EXISTS (
        SELECT 1 FROM hs_seed_rows s
        JOIN listing_room_details r ON r.listing_id=s.listing_id::text
        JOIN listings l ON l.id=s.listing_id::text
        WHERE s.category='ROOM' AND (
            (r.parking_policy='NONE' AND r.max_vehicles<>0) OR
            (r.parking_policy IN ('FREE','PAID') AND r.max_vehicles<=0) OR
            l.max_motorbike_count<>r.max_vehicles
        )
    ) THEN
        RAISE EXCEPTION 'Số xe và chính sách gửi xe của phòng trọ không nhất quán';
    END IF;
    IF EXISTS (
        SELECT 1 FROM hs_seed_rows s
        JOIN listing_room_details r ON r.listing_id=s.listing_id::text
        LEFT JOIN listing_charges c ON c.listing_id=s.listing_id::text
            AND c.charge_type='MOTORBIKE_PARKING' AND c.active IS TRUE
        WHERE s.category='ROOM' AND (
            (r.parking_policy='NONE' AND c.id IS NOT NULL) OR
            (r.parking_policy='FREE' AND (c.id IS NULL OR NOT c.included_in_rent OR c.amount<>0)) OR
            (r.parking_policy='PAID' AND (c.id IS NULL OR c.included_in_rent OR c.amount<=0))
        )
    ) THEN
        RAISE EXCEPTION 'Phí gửi xe phòng trọ không khớp chính sách';
    END IF;
END $$;

SELECT category, status, count(*) AS listing_count
FROM listings WHERE id IN (SELECT listing_id::text FROM hs_seed_rows)
GROUP BY category, status ORDER BY category;

SELECT count(DISTINCT province_code) AS province_count,
       count(DISTINCT place_id) AS featured_place_count,
       count(*) AS seeded_listing_count
FROM hs_seed_rows;

COMMIT;
