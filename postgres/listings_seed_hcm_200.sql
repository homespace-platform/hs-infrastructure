-- HomeSpace: 200 tin đăng mẫu tại Thành phố Hồ Chí Minh cho thử nghiệm tìm kiếm AI.
-- Chạy trên homespace_core bằng pgAdmin (Query Tool).
-- Chỉ dành cho local/dev. 168 phường/xã/đặc khu trong postman/location/hochiminh.txt
-- đều có ít nhất một tin; 32 địa bàn đầu có thêm tin. Nguồn không chứa quận/huyện.
-- Chỉ tạo 200 tin mới trên database sạch; không xóa bộ seed cũ nếu đã chạy trước đó.
-- Chỉ cần chạy file này sau khi migration, bootstrap ADMIN và catalog của listing service đã sẵn sàng.
-- Không cần chạy file sửa bổ sung. ID được tạo xác định, các bản ghi được upsert.
-- Tin thuộc tài khoản bootstrap username=homespace (role ADMIN trong DB local hiện tại).
-- Ảnh: dùng đúng 3 object S3 do người dùng cung cấp; cả 3 ảnh được gắn vào mỗi tin.
-- Mã/tên tỉnh và phường/xã/đặc khu lấy nguyên nguồn; số nhà/tên đường là dữ liệu giả lập,
-- KHÔNG phải địa chỉ đã xác minh hoặc tọa độ thật.

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

-- BEGIN HCM LOCATION DATA: generated from postman/location/hochiminh.txt
-- The source has wards/communes/special zones, not district-level objects.
CREATE TEMP TABLE hs_seed_places ON COMMIT DROP AS
SELECT p.place_id, '79'::text AS province_code,
       'Thành phố Hồ Chí Minh'::text AS province_name,
       p.ward_code, p.ward_name, p.place_type,
       p.ward_name AS location_label
FROM (VALUES
    (1, '25747', 'Phường Thủ Dầu Một', 'ward'),
    (2, '25750', 'Phường Phú Lợi', 'ward'),
    (3, '25760', 'Phường Bình Dương', 'ward'),
    (4, '25768', 'Phường Phú An', 'ward'),
    (5, '25771', 'Phường Chánh Hiệp', 'ward'),
    (6, '25777', 'Xã Dầu Tiếng', 'commune'),
    (7, '25780', 'Xã Minh Thạnh', 'commune'),
    (8, '25792', 'Xã Long Hoà', 'commune'),
    (9, '25807', 'Xã Thanh An', 'commune'),
    (10, '25813', 'Phường Bến Cát', 'ward'),
    (11, '25819', 'Xã Trừ Văn Thố', 'commune'),
    (12, '25822', 'Xã Bàu Bàng', 'commune'),
    (13, '25837', 'Phường Chánh Phú Hoà', 'ward'),
    (14, '25840', 'Phường Long Nguyên', 'ward'),
    (15, '25843', 'Phường Tây Nam', 'ward'),
    (16, '25846', 'Phường Thới Hoà', 'ward'),
    (17, '25849', 'Phường Hoà Lợi', 'ward'),
    (18, '25858', 'Xã Phú Giáo', 'commune'),
    (19, '25864', 'Xã Phước Thành', 'commune'),
    (20, '25867', 'Xã An Long', 'commune'),
    (21, '25882', 'Xã Phước Hoà', 'commune'),
    (22, '25888', 'Phường Tân Uyên', 'ward'),
    (23, '25891', 'Phường Tân Khánh', 'ward'),
    (24, '25906', 'Xã Bắc Tân Uyên', 'commune'),
    (25, '25909', 'Xã Thường Tân', 'commune'),
    (26, '25912', 'Phường Vĩnh Tân', 'ward'),
    (27, '25915', 'Phường Bình Cơ', 'ward'),
    (28, '25920', 'Phường Tân Hiệp', 'ward'),
    (29, '25942', 'Phường Dĩ An', 'ward'),
    (30, '25945', 'Phường Tân Đông Hiệp', 'ward'),
    (31, '25951', 'Phường Đông Hoà', 'ward'),
    (32, '25966', 'Phường Lái Thiêu', 'ward'),
    (33, '25969', 'Phường Thuận Giao', 'ward'),
    (34, '25975', 'Phường An Phú', 'ward'),
    (35, '25978', 'Phường Thuận An', 'ward'),
    (36, '25987', 'Phường Bình Hoà', 'ward'),
    (37, '26506', 'Phường Vũng Tàu', 'ward'),
    (38, '26526', 'Phường Tam Thắng', 'ward'),
    (39, '26536', 'Phường Rạch Dừa', 'ward'),
    (40, '26542', 'Phường Phước Thắng', 'ward'),
    (41, '26545', 'Xã Long Sơn', 'commune'),
    (42, '26560', 'Phường Bà Rịa', 'ward'),
    (43, '26566', 'Phường Long Hương', 'ward'),
    (44, '26572', 'Phường Tam Long', 'ward'),
    (45, '26575', 'Xã Ngãi Giao', 'commune'),
    (46, '26584', 'Xã Xuân Sơn', 'commune'),
    (47, '26590', 'Xã Bình Giã', 'commune'),
    (48, '26596', 'Xã Châu Đức', 'commune'),
    (49, '26608', 'Xã Kim Long', 'commune'),
    (50, '26617', 'Xã Nghĩa Thành', 'commune'),
    (51, '26620', 'Xã Hồ Tràm', 'commune'),
    (52, '26632', 'Xã Xuyên Mộc', 'commune'),
    (53, '26638', 'Xã Bàu Lâm', 'commune'),
    (54, '26641', 'Xã Hoà Hội', 'commune'),
    (55, '26647', 'Xã Hoà Hiệp', 'commune'),
    (56, '26656', 'Xã Bình Châu', 'commune'),
    (57, '26659', 'Xã Long Điền', 'commune'),
    (58, '26662', 'Xã Long Hải', 'commune'),
    (59, '26680', 'Xã Đất Đỏ', 'commune'),
    (60, '26686', 'Xã Phước Hải', 'commune'),
    (61, '26704', 'Phường Phú Mỹ', 'ward'),
    (62, '26710', 'Phường Tân Hải', 'ward'),
    (63, '26713', 'Phường Tân Phước', 'ward'),
    (64, '26725', 'Phường Tân Thành', 'ward'),
    (65, '26728', 'Xã Châu Pha', 'commune'),
    (66, '26732', 'Đặc khu Côn Đảo', 'special_zone'),
    (67, '26737', 'Phường Tân Định', 'ward'),
    (68, '26740', 'Phường Sài Gòn', 'ward'),
    (69, '26743', 'Phường Bến Thành', 'ward'),
    (70, '26758', 'Phường Cầu Ông Lãnh', 'ward'),
    (71, '26767', 'Phường An Phú Đông', 'ward'),
    (72, '26773', 'Phường Thới An', 'ward'),
    (73, '26782', 'Phường Tân Thới Hiệp', 'ward'),
    (74, '26785', 'Phường Trung Mỹ Tây', 'ward'),
    (75, '26791', 'Phường Đông Hưng Thuận', 'ward'),
    (76, '26800', 'Phường Linh Xuân', 'ward'),
    (77, '26803', 'Phường Tam Bình', 'ward'),
    (78, '26809', 'Phường Hiệp Bình', 'ward'),
    (79, '26824', 'Phường Thủ Đức', 'ward'),
    (80, '26833', 'Phường Long Bình', 'ward'),
    (81, '26842', 'Phường Tăng Nhơn Phú', 'ward'),
    (82, '26848', 'Phường Phước Long', 'ward'),
    (83, '26857', 'Phường Long Phước', 'ward'),
    (84, '26860', 'Phường Long Trường', 'ward'),
    (85, '26876', 'Phường An Nhơn', 'ward'),
    (86, '26878', 'Phường An Hội Đông', 'ward'),
    (87, '26882', 'Phường An Hội Tây', 'ward'),
    (88, '26884', 'Phường Gò Vấp', 'ward'),
    (89, '26890', 'Phường Hạnh Thông', 'ward'),
    (90, '26898', 'Phường Thông Tây Hội', 'ward'),
    (91, '26905', 'Phường Bình Lợi Trung', 'ward'),
    (92, '26911', 'Phường Bình Quới', 'ward'),
    (93, '26929', 'Phường Bình Thạnh', 'ward'),
    (94, '26944', 'Phường Gia Định', 'ward'),
    (95, '26956', 'Phường Thạnh Mỹ Tây', 'ward'),
    (96, '26968', 'Phường Tân Sơn Nhất', 'ward'),
    (97, '26977', 'Phường Tân Sơn Hoà', 'ward'),
    (98, '26983', 'Phường Bảy Hiền', 'ward'),
    (99, '26995', 'Phường Tân Hoà', 'ward'),
    (100, '27004', 'Phường Tân Bình', 'ward'),
    (101, '27007', 'Phường Tân Sơn', 'ward'),
    (102, '27013', 'Phường Tây Thạnh', 'ward'),
    (103, '27019', 'Phường Tân Sơn Nhì', 'ward'),
    (104, '27022', 'Phường Phú Thọ Hoà', 'ward'),
    (105, '27028', 'Phường Phú Thạnh', 'ward'),
    (106, '27031', 'Phường Tân Phú', 'ward'),
    (107, '27043', 'Phường Đức Nhuận', 'ward'),
    (108, '27058', 'Phường Cầu Kiệu', 'ward'),
    (109, '27073', 'Phường Phú Nhuận', 'ward'),
    (110, '27094', 'Phường An Khánh', 'ward'),
    (111, '27097', 'Phường Bình Trưng', 'ward'),
    (112, '27112', 'Phường Cát Lái', 'ward'),
    (113, '27139', 'Phường Xuân Hoà', 'ward'),
    (114, '27142', 'Phường Nhiêu Lộc', 'ward'),
    (115, '27154', 'Phường Bàn Cờ', 'ward'),
    (116, '27163', 'Phường Hoà Hưng', 'ward'),
    (117, '27169', 'Phường Diên Hồng', 'ward'),
    (118, '27190', 'Phường Vườn Lài', 'ward'),
    (119, '27211', 'Phường Hoà Bình', 'ward'),
    (120, '27226', 'Phường Phú Thọ', 'ward'),
    (121, '27232', 'Phường Bình Thới', 'ward'),
    (122, '27238', 'Phường Minh Phụng', 'ward'),
    (123, '27259', 'Phường Xóm Chiếu', 'ward'),
    (124, '27265', 'Phường Khánh Hội', 'ward'),
    (125, '27286', 'Phường Vĩnh Hội', 'ward'),
    (126, '27301', 'Phường Chợ Quán', 'ward'),
    (127, '27316', 'Phường An Đông', 'ward'),
    (128, '27343', 'Phường Chợ Lớn', 'ward'),
    (129, '27349', 'Phường Phú Lâm', 'ward'),
    (130, '27364', 'Phường Bình Phú', 'ward'),
    (131, '27367', 'Phường Bình Tây', 'ward'),
    (132, '27373', 'Phường Bình Tiên', 'ward'),
    (133, '27418', 'Phường Chánh Hưng', 'ward'),
    (134, '27424', 'Phường Bình Đông', 'ward'),
    (135, '27427', 'Phường Phú Định', 'ward'),
    (136, '27439', 'Phường Bình Hưng Hoà', 'ward'),
    (137, '27442', 'Phường Bình Tân', 'ward'),
    (138, '27448', 'Phường Bình Trị Đông', 'ward'),
    (139, '27457', 'Phường Tân Tạo', 'ward'),
    (140, '27460', 'Phường An Lạc', 'ward'),
    (141, '27475', 'Phường Tân Hưng', 'ward'),
    (142, '27478', 'Phường Tân Thuận', 'ward'),
    (143, '27484', 'Phường Phú Thuận', 'ward'),
    (144, '27487', 'Phường Tân Mỹ', 'ward'),
    (145, '27496', 'Xã Tân An Hội', 'commune'),
    (146, '27508', 'Xã An Nhơn Tây', 'commune'),
    (147, '27511', 'Xã Nhuận Đức', 'commune'),
    (148, '27526', 'Xã Thái Mỹ', 'commune'),
    (149, '27541', 'Xã Phú Hoà Đông', 'commune'),
    (150, '27544', 'Xã Bình Mỹ', 'commune'),
    (151, '27553', 'Xã Củ Chi', 'commune'),
    (152, '27559', 'Xã Hóc Môn', 'commune'),
    (153, '27568', 'Xã Đông Thạnh', 'commune'),
    (154, '27577', 'Xã Xuân Thới Sơn', 'commune'),
    (155, '27592', 'Xã Bà Điểm', 'commune'),
    (156, '27595', 'Xã Tân Nhựt', 'commune'),
    (157, '27601', 'Xã Vĩnh Lộc', 'commune'),
    (158, '27604', 'Xã Tân Vĩnh Lộc', 'commune'),
    (159, '27610', 'Xã Bình Lợi', 'commune'),
    (160, '27619', 'Xã Bình Hưng', 'commune'),
    (161, '27628', 'Xã Hưng Long', 'commune'),
    (162, '27637', 'Xã Bình Chánh', 'commune'),
    (163, '27655', 'Xã Nhà Bè', 'commune'),
    (164, '27658', 'Xã Hiệp Phước', 'commune'),
    (165, '27664', 'Xã Cần Giờ', 'commune'),
    (166, '27667', 'Xã Bình Khánh', 'commune'),
    (167, '27673', 'Xã An Thới Đông', 'commune'),
    (168, '27676', 'Xã Thạnh An', 'commune')
) AS p(place_id, ward_code, ward_name, place_type);
-- END HCM LOCATION DATA

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
           (ARRAY['Không gian được bố trí gọn gàng','Thông tin giá và phí được tách riêng',
                  'Có thể trao đổi ngày nhận nhà','Có nhiều khung giờ hẹn xem',
                  'Điều kiện thuê được ghi rõ trong tin',
                  'Có thể xem chi tiết trang thiết bị bàn giao'])[(n % 6)+1] AS selling_point
    FROM generate_series(1,200) AS n
    CROSS JOIN place_count pc
    JOIN hs_seed_places p ON p.place_id = ((n-1) % pc.total) + 1
), props AS (
    SELECT *,
           CASE category
             WHEN 'HOUSE' THEN format('Cho thuê nhà nguyên căn %s phòng ngủ%s tại %s',
                   2 + n % 4, CASE WHEN n % 4 = 0 THEN ', có gara' ELSE '' END, ward_name)
             WHEN 'APARTMENT' THEN format('Cho thuê căn hộ %s phòng ngủ, ban công %s tại %s',
                   1 + n % 3, (ARRAY['hướng Đông Nam','hướng Đông Bắc','hướng Tây Nam','hướng Tây Bắc'])[(n % 4)+1], ward_name)
             ELSE format('Cho thuê phòng trọ %s tại %s',
                   CASE WHEN n % 3 = 0 THEN 'có gác lửng'
                        WHEN n % 4 <> 1 THEN 'có ban công'
                        WHEN n % 5 <> 0 THEN 'có cửa sổ'
                        ELSE 'thông tin chi phí rõ ràng' END, ward_name)
           END AS title,
           (CASE category
             WHEN 'HOUSE' THEN 'Nhà nguyên căn phù hợp gia đình hoặc nhóm đi làm. '
             WHEN 'APARTMENT' THEN 'Căn hộ riêng tư với không gian sinh hoạt độc lập. '
             ELSE 'Phòng trọ phù hợp sinh viên hoặc người đi làm. '
           END) || selling_point || '. Khu vực hành chính: ' || ward_name ||
           ', ' || province_name || '. ' ||
           (ARRAY['Có thể trao đổi thêm về thời điểm bàn giao.',
                  'Các khoản phí và điều kiện thuê được ghi theo từng mục.',
                  'Nên đặt lịch xem để kiểm tra không gian thực tế.',
                  'Số nhà và đường là dữ liệu mẫu, không dùng để định vị thực tế.'])[(extra_var % 4)+1]
           AS description,
           CASE category WHEN 'HOUSE' THEN 65 + area_var % 150 + (n % 4) * 0.5
                         WHEN 'APARTMENT' THEN 30 + area_var % 95 + (n % 4) * 0.5
                         ELSE 15 + area_var % 30 + (n % 4) * 0.5 END::numeric(12,2) AS area_m2,
           CASE category
             WHEN 'HOUSE' THEN 7000000 + (n % 4) * 2000000 + (price_var % 100) * 180000
             WHEN 'APARTMENT' THEN 4500000 + (n % 3) * 1800000 + (price_var % 100) * 110000
             WHEN 'ROOM' THEN CASE WHEN n % 11 = 0
                   THEN 900000 + (price_var % 45) * 30000
                   ELSE 1400000 + (price_var % 95) * 40000 END
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
       md5('homespace-hcm-200-listing-v2-' || p.n::text)::uuid AS listing_id,
       ('P' || lpad(n::text, 4, '0')) AS room_code,
       (ARRAY['Góc đọc sách','Sân phơi chung','Không gian làm việc',
              'Khu để xe có mái che','Ban công đón gió','Sảnh sinh hoạt chung',
              'Khu vực cây xanh','Tủ nhận hàng'])[(extra_var % 8)+1] AS extra_amenity
FROM props p CROSS JOIN hs_seed_config c;

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

-- Mã và tên địa bàn khớp chính xác nguồn location. Số nhà/đường chỉ là dữ liệu mẫu.
INSERT INTO addresses (
    id, user_id, listing_id, branch_id, province_code, province_name, ward_code, ward_name,
    street_line, full_address, active, created_at, updated_at, created_by, updated_by
)
SELECT md5('homespace-hcm-200-address-v2-' || n::text)::uuid::text,
       NULL, listing_id::text, NULL, province_code, province_name,
       ward_code, ward_name,
       format('%s/%s đường %s', 10 + n % 180, 1 + extra_var % 45,
              (ARRAY['Nguyễn Trãi','Lê Lợi','Hùng Vương','Trần Hưng Đạo',
                     'Phan Đình Phùng','Nguyễn Văn Trỗi','Hai Bà Trưng','Lê Văn Việt',
                     'Cách Mạng Tháng Tám','Điện Biên Phủ','Nguyễn Thị Minh Khai',
                     'Phạm Văn Đồng'])[(n % 12)+1]),
       format('%s/%s đường %s, %s, %s', 10 + n % 180, 1 + extra_var % 45,
              (ARRAY['Nguyễn Trãi','Lê Lợi','Hùng Vương','Trần Hưng Đạo',
                     'Phan Đình Phùng','Nguyễn Văn Trỗi','Hai Bà Trưng','Lê Văn Việt',
                     'Cách Mạng Tháng Tám','Điện Biên Phủ','Nguyễn Thị Minh Khai',
                     'Phạm Văn Đồng'])[(n % 12)+1], ward_name, province_name),
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
       2 * (2 + (n % 4)), 1 + (n % 4),
       CASE n % 4 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' ELSE 'UNFURNISHED' END,
       CASE n % 3 WHEN 0 THEN 'Sổ hồng riêng' WHEN 1 THEN 'Giấy tờ hợp lệ, trao đổi khi xem nhà' ELSE 'Hợp đồng sở hữu được cung cấp khi xem nhà' END,
       'Cho thuê toàn bộ nhà', 1, 2 + (n % 4)
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
       'Tòa căn hộ tại ' || ward_name,
       (ARRAY['Block A','Block B','Tháp 1','Tháp 2','Block C','Tòa Đông','Tòa Tây'])[(n % 7)+1],
       'A' || (100 + n)::text, 2 + (n % 20), 25 + (n % 20),
       1 + (n % 3), 1 + (n % 2), 1, 1,
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
SELECT md5('homespace-hcm-200-v2-charge-' || n::text || '-' || sort_order::text)::uuid::text,
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
      WHEN 'PARKING' THEN s.category <> 'ROOM' OR s.room_parking_policy <> 'NONE'
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
SELECT md5('homespace-hcm-200-v2-furnishing-' || fs.n::text || '-' || fs.code)::uuid::text,
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
SELECT md5('homespace-hcm-200-v2-custom-' || n::text)::uuid::text,
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
           md5('homespace-hcm-200-v2-media-' || s.n::text || '-' || m.media_order::text)::uuid::text AS media_id
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
           md5('homespace-hcm-200-v2-media-' || s.n::text || '-' || m.media_order::text)::uuid::text AS media_id
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
    IF (SELECT count(*) FROM hs_seed_places) <> 168
       OR (SELECT count(DISTINCT ward_code) FROM hs_seed_places) <> 168
       OR EXISTS (SELECT 1 FROM hs_seed_places WHERE province_code <> '79') THEN
        RAISE EXCEPTION 'Nguồn TP.HCM phải có 168 mã phường/xã/đặc khu duy nhất';
    END IF;
    IF (SELECT count(*) FROM hs_seed_rows) <> 200 THEN
        RAISE EXCEPTION 'Seed phải tạo đúng 200 tin đăng';
    END IF;
    IF EXISTS (
        SELECT 1 FROM hs_seed_places p
        LEFT JOIN hs_seed_rows s ON s.place_id=p.place_id
        GROUP BY p.place_id HAVING count(s.n) NOT BETWEEN 1 AND 2
    ) THEN
        RAISE EXCEPTION 'Mỗi phường/xã/đặc khu phải có 1-2 tin';
    END IF;
    IF (SELECT count(DISTINCT category) FROM hs_seed_rows) <> 3 THEN
        RAISE EXCEPTION 'Seed phải bao gồm đủ HOUSE, APARTMENT, ROOM';
    END IF;
    IF (
        SELECT count(*) FROM listings l
        JOIN hs_seed_rows s ON s.listing_id::text=l.id
        WHERE l.active IS TRUE AND l.status='PUBLISHED'
    ) <> 200 OR (
        SELECT count(*) FROM addresses a
        JOIN hs_seed_rows s ON s.listing_id::text=a.listing_id
        WHERE a.active IS TRUE
    ) <> 200 THEN
        RAISE EXCEPTION 'Seed chưa tạo đủ 200 tin và địa chỉ đang hoạt động';
    END IF;
    IF EXISTS (
        SELECT 1 FROM hs_seed_rows s
        JOIN addresses a ON a.listing_id=s.listing_id::text
        WHERE a.province_code<>s.province_code OR a.province_name<>s.province_name
           OR a.ward_code<>s.ward_code OR a.ward_name<>s.ward_name
           OR a.full_address NOT LIKE '%' || s.ward_name || ', ' || s.province_name
           OR s.title NOT LIKE '%' || s.ward_name || '%'
    ) THEN
        RAISE EXCEPTION 'Tiêu đề/địa chỉ seed không khớp mã và tên địa bàn TP.HCM';
    END IF;
    IF EXISTS (
        SELECT 1 FROM hs_seed_rows s
        JOIN listings l ON l.id=s.listing_id::text
        WHERE l.price_amount<=0 OR l.area_m2<=0
           OR (l.category='ROOM' AND l.price_unit NOT IN ('ROOM_MONTH','PERSON_MONTH'))
           OR (l.category<>'ROOM' AND l.price_unit<>'MONTH')
           OR (l.max_motorbike_count=0 AND l.category<>'ROOM')
    ) THEN
        RAISE EXCEPTION 'Giá, diện tích, đơn vị giá hoặc sức chứa xe không hợp lý';
    END IF;
    IF EXISTS (
        SELECT 1 FROM hs_seed_rows s
        LEFT JOIN listing_room_details r ON r.listing_id=s.listing_id::text AND s.category='ROOM'
        LEFT JOIN listing_house_details h ON h.listing_id=s.listing_id::text AND s.category='HOUSE'
        LEFT JOIN listing_apartment_details ap ON ap.listing_id=s.listing_id::text AND s.category='APARTMENT'
        WHERE (s.category='ROOM' AND (r.listing_id IS NULL OR r.max_occupants < 1
                       OR r.has_balcony <> (r.balcony_type <> 'NONE')))
           OR (s.category='HOUSE' AND (h.listing_id IS NULL OR h.max_occupants < 1
                       OR h.rented_floor_from <> 1 OR h.rented_floor_to <> h.total_floors))
           OR (s.category='APARTMENT' AND (ap.listing_id IS NULL OR ap.max_occupants < 1
                       OR ap.floor_number > ap.building_total_floors))
    ) THEN
        RAISE EXCEPTION 'Chi tiết loại hình hoặc sức chứa không hợp lệ';
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
       count(DISTINCT ward_code) AS ward_count,
       count(*) AS seeded_listing_count
FROM hs_seed_rows;

COMMIT;
