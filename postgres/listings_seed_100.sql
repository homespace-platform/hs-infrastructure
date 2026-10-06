-- HomeSpace: 100 tin đăng mẫu cho thử nghiệm tìm kiếm AI
-- Chạy trên homespace_core bằng pgAdmin (Query Tool).
-- Chỉ dành cho local/dev. Tạo 34 HOUSE, 33 APARTMENT, 33 ROOM; không xóa dữ liệu hiện có.
-- Chạy lại an toàn: ID được tạo xác định theo mã seed, các bản ghi được upsert.
-- Tin thuộc tài khoản bootstrap username=homespace (role ADMIN trong DB local hiện tại).
-- Ảnh: dùng đúng 3 object S3 do người dùng cung cấp; cả 3 ảnh được gắn vào mỗi tin.

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

CREATE TEMP TABLE hs_seed_rows ON COMMIT DROP AS
WITH numbered AS (
    SELECT n,
           CASE n % 3 WHEN 1 THEN 'HOUSE' WHEN 2 THEN 'APARTMENT' ELSE 'ROOM' END AS category,
           (ARRAY['Thành phố Hồ Chí Minh','Thành phố Hà Nội','Thành phố Đà Nẵng','Thành phố Đồng Nai'])[(n % 4) + 1] AS province_name,
           (ARRAY['79','01','48','75'])[(n % 4) + 1] AS province_code,
           (ARRAY[
              'Phường Bến Thành','Phường Tân Định','Phường Thảo Điền','Phường Bình Thạnh',
              'Phường Cầu Giấy','Phường Tây Hồ','Phường Hai Bà Trưng','Phường Hà Đông',
              'Phường Hải Châu','Phường Sơn Trà','Phường Ngũ Hành Sơn','Phường Thanh Khê',
              'Phường Biên Hòa','Phường Long Khánh','Phường Trấn Biên','Phường Tam Hiệp'
           ])[(n % 16) + 1] AS ward_name,
           (ARRAY[
              'đường Nguyễn Trãi','đường Lê Văn Sỹ','đường Phan Xích Long','đường Võ Oanh',
              'đường Nguyễn Văn Cừ','đường Hoàng Diệu','đường Trần Hưng Đạo','đường Phạm Văn Đồng',
              'đường Điện Biên Phủ','đường Nguyễn Thị Minh Khai'
           ])[(n % 10) + 1] AS street_name,
           (ARRAY['Gần công viên và tuyến xe buýt','Khu dân cư yên tĩnh, tiện đi làm','Gần chợ, siêu thị và trường học','Hẻm rộng, khu vực an ninh','Kết nối nhanh đến trung tâm'])[(n % 5) + 1] AS selling_point
    FROM generate_series(1,100) AS n
), props AS (
    SELECT *,
           CASE category
             WHEN 'HOUSE' THEN format('Nhà nguyên căn %s tại %s',
                   (ARRAY['thoáng sáng','có sân để xe','3 tầng tiện nghi','hẻm xe hơi','full nội thất'])[(n % 5)+1], ward_name)
             WHEN 'APARTMENT' THEN format('Căn hộ %s tại %s',
                   (ARRAY['1 phòng ngủ view thành phố','2 phòng ngủ ban công thoáng','đầy đủ nội thất','cao tầng yên tĩnh','gần tiện ích'])[(n % 5)+1], ward_name)
             ELSE format('Phòng trọ %s tại %s',
                   (ARRAY['có gác sáng thoáng','khép kín full nội thất','cửa sổ lớn','có ban công riêng','giá tốt gần tiện ích'])[(n % 5)+1], ward_name)
           END AS title,
           (CASE category
             WHEN 'HOUSE' THEN 'Cho thuê nhà nguyên căn phù hợp gia đình hoặc nhóm đi làm. '
             WHEN 'APARTMENT' THEN 'Cho thuê căn hộ riêng tư, bố trí hợp lý, phù hợp cá nhân hoặc gia đình nhỏ. '
             ELSE 'Cho thuê phòng riêng, sạch sẽ, phù hợp sinh viên hoặc người đi làm. '
           END) || selling_point || '. ' ||
           'Khu vực thuận tiện sinh hoạt, có thể hẹn xem nhà trước. Giá và các khoản phí được ghi rõ trong tin; vui lòng liên hệ chủ nhà để xác nhận lịch trống và điều kiện thuê.' AS description,
           CASE category WHEN 'HOUSE' THEN 65 + (n % 9) * 12 + (n % 7) * 0.5
                        WHEN 'APARTMENT' THEN 35 + (n % 8) * 7 + (n % 5) * 0.5
                        ELSE 16 + (n % 8) * 3 + (n % 3) * 0.5 END::numeric(12,2) AS area_m2,
           CASE category WHEN 'HOUSE' THEN 9000000 + (n % 8) * 1750000
                        WHEN 'APARTMENT' THEN 5500000 + (n % 9) * 1250000
                        ELSE 1800000 + (n % 8) * 350000 END::numeric(18,2) AS price_amount,
           (current_date + (n % 90)) AS available_from,
           CASE WHEN n % 6 = 0 THEN 'FIXED_AMOUNT' ELSE 'MONTH_COUNT' END AS deposit_type,
           CASE WHEN n % 6 = 0 THEN (CASE category WHEN 'HOUSE' THEN 9000000 WHEN 'APARTMENT' THEN 6000000 ELSE 2500000 END)::numeric(18,2) END AS deposit_amount,
           CASE WHEN n % 6 = 0 THEN NULL ELSE (1 + n % 2) END AS deposit_months,
           CASE category WHEN 'HOUSE' THEN 'MONTH' WHEN 'APARTMENT' THEN 'MONTH'
                ELSE CASE WHEN n % 4 = 0 THEN 'PERSON_MONTH' ELSE 'ROOM_MONTH' END END AS price_unit,
           (CASE WHEN n % 4 = 0 THEN 6 WHEN n % 4 = 1 THEN 12 WHEN n % 4 = 2 THEN 3 ELSE 9 END) AS min_lease_months
    FROM numbered
)
SELECT p.*, c.owner_id,
       md5('homespace-ai-listing-seed-v1-' || p.n::text)::uuid AS listing_id,
       (ARRAY['Lầu 1','Lầu 2','Tầng trệt','Lầu 3','Tầng 5','Tầng 8','Tầng 12'])[(n % 7)+1] AS floor_label,
       ('P' || lpad((100 + (n % 900))::text, 3, '0')) AS room_code,
       (ARRAY['Hồ bơi','Phòng gym','Công viên nội khu','Khu sinh hoạt chung','Sân chơi trẻ em'])[(n % 5)+1] AS extra_amenity
FROM props p CROSS JOIN hs_seed_config c;

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
       now(), owner_id, now(), now(), now() + interval '180 days', 0, current_date + (n % 4),
       area_m2, price_amount, 'VND', price_unit, (n % 3 = 0), deposit_type, deposit_amount,
       deposit_months, 'MONTHLY', min_lease_months, (n % 2 = 0), false,
       CASE WHEN category = 'ROOM' THEN 1 + (n % 3) ELSE 1 + (n % 4) END,
       CASE WHEN category = 'HOUSE' AND n % 4 = 0 THEN 1 ELSE 0 END,
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
       province_code || '-SEED-' || lpad(n::text,3,'0'), ward_name,
       ((n % 99) + 1)::text || ' ' || street_name,
       ((n % 99) + 1)::text || ' ' || street_name || ', ' || ward_name || ', ' || province_name,
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
       1 + (n % 2), 1, n % 3 = 0, n % 4 = 0,
       CASE WHEN n % 3 = 0 THEN 'HẺM XE HƠI' ELSE 'ĐƯỜNG NỘI BỘ' END,
       3 + (n % 5), 1 + (n % 2),
       CASE n % 4 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' ELSE 'UNFURNISHED' END,
       CASE WHEN n % 3 = 0 THEN 'Sổ hồng riêng' ELSE 'Giấy tờ hợp lệ, trao đổi khi xem nhà' END,
       'Cho thuê toàn bộ nhà; có thể trao đổi thời điểm bàn giao.', 1, 2 + (n % 4)
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
       (ARRAY['Vinhomes Central Park','Masteri Thảo Điền','Sunrise City','The Gold View','City Garden','Flora Novia'])[(n % 6)+1],
       (ARRAY['Block A','Block B','Tháp 1','Tháp 2','Block C'])[(n % 5)+1],
       'A' || (100 + n)::text, 2 + (n % 25), 18 + (n % 22), 1 + (n % 3), 1 + (n % 2), 1, 1,
       CASE n % 5 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' WHEN 3 THEN 'LUXURY' ELSE 'UNFURNISHED' END,
       (ARRAY['Đông','Tây','Nam','Bắc'])[(n % 4)+1],
       (ARRAY['Đông Nam','Đông Bắc','Tây Nam','Tây Bắc'])[(n % 4)+1],
       (ARRAY['View thành phố','View công viên','View hồ bơi nội khu','View sông','View nội khu yên tĩnh'])[(n % 5)+1],
       2 + (n % 4), CASE WHEN n % 2 = 0 THEN 'Sổ hồng' ELSE 'Hợp đồng mua bán' END
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
       1 + (n % 3), n % 3,
       CASE WHEN n % 5 = 0 THEN 'PAID' WHEN n % 5 = 1 THEN 'NONE' ELSE 'FREE' END
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
      ('ELECTRICITY','PER_KWH',(3000 + (s.n % 6)*250)::numeric,'kWh',false,NULL::text,1),
      ('WATER','PER_M3',(15000 + (s.n % 5)*1500)::numeric,'m³',false,NULL::text,2),
      ('MANAGEMENT','PER_MONTH',(CASE WHEN s.category='ROOM' THEN 0 ELSE 150000 + (s.n % 5)*50000 END)::numeric,'tháng',s.category='ROOM',NULL::text,3),
      ('INTERNET','PER_MONTH',(CASE WHEN s.n % 4=0 THEN 0 ELSE 80000 + (s.n % 4)*20000 END)::numeric,'tháng',s.n % 4=0,NULL::text,4),
      ('SERVICE_OR_GARBAGE','PER_PERSON_MONTH',(20000 + (s.n % 5)*10000)::numeric,'người/tháng',false,NULL::text,5),
      ('MOTORBIKE_PARKING','PER_VEHICLE_MONTH',(CASE WHEN s.category='HOUSE' THEN 0 ELSE 80000 + (s.n % 4)*20000 END)::numeric,'xe/tháng',s.category='HOUSE',NULL::text,6),
      ('CAR_PARKING','PER_VEHICLE_MONTH',(CASE WHEN s.category='APARTMENT' THEN 500000 + (s.n % 4)*100000 ELSE 0 END)::numeric,'xe/tháng',s.category<>'APARTMENT',NULL::text,7)
    ) AS v(charge_type,billing_method,amount,unit,included,custom_name,sort_order)
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
       'WIFI', 'ELEVATOR', 'SECURITY_24_7', 'CAMERA',
       CASE WHEN s.category IN ('HOUSE','APARTMENT') THEN 'AIR_CONDITIONER' ELSE 'PETS_ALLOWED' END,
       CASE WHEN s.category='APARTMENT' THEN 'SWIMMING_POOL' ELSE 'PETS_ALLOWED' END
    ]) AS chosen(code)
    JOIN amenities a ON a.code=chosen.code AND a.active IS TRUE
    JOIN amenity_categories ac ON ac.amenity_id=a.id AND ac.category=s.category
)
INSERT INTO listing_amenities (listing_id, amenity_id)
SELECT DISTINCT listing_id::text, a.id
FROM amenity_seed x JOIN amenities a ON a.code=x.code
ON CONFLICT DO NOTHING;

-- Furnishing inventory snapshots for all furnished listings.
WITH furnishing_seed AS (
    SELECT s.*, fi.code, fi.id AS furnishing_item_id,
           CASE fi.code WHEN 'BED' THEN 1 WHEN 'WARDROBE' THEN 2 WHEN 'AIR_CONDITIONER' THEN 3 ELSE 4 END AS sort_order,
           CASE WHEN s.n % 7=0 THEN 'BRAND_NEW' WHEN s.n % 3=0 THEN 'NORMAL' ELSE 'GOOD' END AS handover_condition
    FROM hs_seed_rows s
    JOIN LATERAL unnest(ARRAY['BED','WARDROBE','AIR_CONDITIONER','WATER_HEATER']) chosen(code) ON true
    JOIN furnishing_items fi ON fi.code=chosen.code AND fi.active IS TRUE
    JOIN furnishing_item_categories fic ON fic.furnishing_item_id=fi.id AND fic.category=s.category
    WHERE CASE s.category
       WHEN 'HOUSE' THEN (CASE s.n % 4 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' ELSE 'UNFURNISHED' END) <> 'UNFURNISHED'
       WHEN 'APARTMENT' THEN (CASE s.n % 5 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' WHEN 3 THEN 'LUXURY' ELSE 'UNFURNISHED' END) <> 'UNFURNISHED'
       ELSE (CASE s.n % 4 WHEN 0 THEN 'FULLY_FURNISHED' WHEN 1 THEN 'BASIC' WHEN 2 THEN 'PARTIALLY_FURNISHED' ELSE 'UNFURNISHED' END) <> 'UNFURNISHED'
    END
)
INSERT INTO listing_furnishing_assets (
    id, listing_id, furnishing_item_id, item_code, asset_name, quantity,
    handover_condition, condition_note, sort_order
)
SELECT md5('homespace-ai-listing-seed-v1-furnishing-' || fs.n::text || '-' || fs.code)::uuid::text,
       listing_id::text, furnishing_item_id, fs.code, fi.name, 1,
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
SELECT category, status, count(*) AS listing_count
FROM listings
WHERE id IN (SELECT listing_id::text FROM hs_seed_rows)
GROUP BY category, status
ORDER BY category;

COMMIT;
