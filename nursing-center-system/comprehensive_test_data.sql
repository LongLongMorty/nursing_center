-- 东软颐养中心管理系统 - 综合测试数据生成脚本
-- 包含客户数据和床位使用记录，用于测试完整的入住登记功能

USE nursing_center;



-- 4. 生成更多客户数据，包括已入住和待入住的客户
INSERT INTO customer (customer_name, age, gender, id_card, birth_date, blood_type, guardian_name, guardian_phone, customer_type, status, remarks) VALUES
-- 已入住客户 (status = 1)
('陈建国', 78, 'MALE', '110101194601010009', '1946-01-01', 'A', '陈小军', '13800138009', 'SELF_CARE', 1, '已入住101室1号床'),
('刘淑华', 73, 'FEMALE', '110101195101010010', '1951-01-01', 'B', '刘小亮', '13800138010', 'CARE', 1, '已入住101室2号床'),
('黄志明', 80, 'MALE', '110101194401010011', '1944-01-01', 'O', '黄小龙', '13800138011', 'SELF_CARE', 1, '已入住102室1号床'),
('杨秀兰', 76, 'FEMALE', '110101194801010012', '1948-01-01', 'AB', '杨小凤', '13800138012', 'CARE', 1, '已入住102室3号床'),
('马永强', 82, 'MALE', '110101194201010013', '1942-01-01', 'A', '马小东', '13800138013', 'SELF_CARE', 1, '已入住103室2号床'),
('郭美丽', 69, 'FEMALE', '110101195501010014', '1955-01-01', 'B', '郭小帅', '13800138014', 'CARE', 1, '已入住201室1号床'),
('林建华', 75, 'MALE', '110101194901010015', '1949-01-01', 'O', '林小斌', '13800138015', 'SELF_CARE', 1, '已入住201室4号床'),
('何丽娟', 81, 'FEMALE', '110101194301010016', '1943-01-01', 'A', '何小峰', '13800138016', 'CARE', 1, '已入住202室2号床'),
('高德福', 77, 'MALE', '110101194701010017', '1947-01-01', 'AB', '高小云', '13800138017', 'SELF_CARE', 1, '已入住301室1号床'),
('朱桂花', 74, 'FEMALE', '110101195001010018', '1950-01-01', 'B', '朱小虎', '13800138018', 'CARE', 1, '已入住301室3号床'),
('谢志强', 79, 'MALE', '110101194501010019', '1945-01-01', 'O', '谢小鹏', '13800138019', 'SELF_CARE', 1, '已入住302室1号床'),
('邓玉兰', 72, 'FEMALE', '110101195201010020', '1952-01-01', 'A', '邓小磊', '13800138020', 'CARE', 1, '已入住401室2号床'),

-- 待入住客户 (status = 0) - 原有的8个客户保持不变
('冯建军', 83, 'MALE', '110101194101010021', '1941-01-01', 'AB', '冯小超', '13800138021', 'SELF_CARE', 0, '待入住'),
('曾秀英', 70, 'FEMALE', '110101195401010022', '1954-01-01', 'B', '曾小杰', '13800138022', 'CARE', 0, '待入住'),
('彭志华', 76, 'MALE', '110101194801010023', '1948-01-01', 'O', '彭小伟', '13800138023', 'SELF_CARE', 0, '待入住'),
('袁丽萍', 68, 'FEMALE', '110101195601010024', '1956-01-01', 'A', '袁小刚', '13800138024', 'CARE', 0, '待入住'),
('苏建明', 85, 'MALE', '110101193901010025', '1939-01-01', 'B', '苏小波', '13800138025', 'SELF_CARE', 0, '待入住'),
('韩秀珍', 73, 'FEMALE', '110101195101010026', '1951-01-01', 'O', '韩小飞', '13800138026', 'CARE', 0, '待入住'),
('邱志刚', 78, 'MALE', '110101194601010027', '1946-01-01', 'AB', '邱小勇', '13800138027', 'SELF_CARE', 0, '待入住'),
('罗玉华', 71, 'FEMALE', '110101195301010028', '1953-01-01', 'A', '罗小明', '13800138028', 'CARE', 0, '待入住');

-- 5. 生成床位使用记录 (bed_usage表)
-- 为已入住的客户分配床位，并设置床位状态为OCCUPIED

-- 获取已入住客户的ID和对应的床位ID
SET @customer1_id = (SELECT id FROM customer WHERE customer_name = '陈建国');
SET @customer2_id = (SELECT id FROM customer WHERE customer_name = '刘淑华');
SET @customer3_id = (SELECT id FROM customer WHERE customer_name = '黄志明');
SET @customer4_id = (SELECT id FROM customer WHERE customer_name = '杨秀兰');
SET @customer5_id = (SELECT id FROM customer WHERE customer_name = '马永强');
SET @customer6_id = (SELECT id FROM customer WHERE customer_name = '郭美丽');
SET @customer7_id = (SELECT id FROM customer WHERE customer_name = '林建华');
SET @customer8_id = (SELECT id FROM customer WHERE customer_name = '何丽娟');
SET @customer9_id = (SELECT id FROM customer WHERE customer_name = '高德福');
SET @customer10_id = (SELECT id FROM customer WHERE customer_name = '朱桂花');
SET @customer11_id = (SELECT id FROM customer WHERE customer_name = '谢志强');
SET @customer12_id = (SELECT id FROM customer WHERE customer_name = '邓玉兰');

-- 获取对应床位的ID
SET @bed_101_1 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '101' AND b.bed_no = '1号床');
SET @bed_101_2 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '101' AND b.bed_no = '2号床');
SET @bed_102_1 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '102' AND b.bed_no = '1号床');
SET @bed_102_3 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '102' AND b.bed_no = '3号床');
SET @bed_103_2 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '103' AND b.bed_no = '2号床');
SET @bed_201_1 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '201' AND b.bed_no = '1号床');
SET @bed_201_4 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '201' AND b.bed_no = '4号床');
SET @bed_202_2 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '202' AND b.bed_no = '2号床');
SET @bed_301_1 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '301' AND b.bed_no = '1号床');
SET @bed_301_3 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '301' AND b.bed_no = '3号床');
SET @bed_302_1 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '302' AND b.bed_no = '1号床');
SET @bed_401_2 = (SELECT b.id FROM bed b JOIN room r ON b.room_id = r.id WHERE r.room_no = '401' AND b.bed_no = '2号床');

-- 插入床位使用记录
INSERT INTO bed_usage (customer_id, bed_id, check_in_date, status, created_at, updated_at) VALUES
(@customer1_id, @bed_101_1, '2024-01-15', 1, NOW(), NOW()),
(@customer2_id, @bed_101_2, '2024-01-16', 1, NOW(), NOW()),
(@customer3_id, @bed_102_1, '2024-01-20', 1, NOW(), NOW()),
(@customer4_id, @bed_102_3, '2024-01-22', 1, NOW(), NOW()),
(@customer5_id, @bed_103_2, '2024-01-25', 1, NOW(), NOW()),
(@customer6_id, @bed_201_1, '2024-02-01', 1, NOW(), NOW()),
(@customer7_id, @bed_201_4, '2024-02-03', 1, NOW(), NOW()),
(@customer8_id, @bed_202_2, '2024-02-05', 1, NOW(), NOW()),
(@customer9_id, @bed_301_1, '2024-02-10', 1, NOW(), NOW()),
(@customer10_id, @bed_301_3, '2024-02-12', 1, NOW(), NOW()),
(@customer11_id, @bed_302_1, '2024-02-15', 1, NOW(), NOW()),
(@customer12_id, @bed_401_2, '2024-02-18', 1, NOW(), NOW());

-- 6. 更新已占用床位的状态为OCCUPIED
UPDATE bed SET bed_status = 'OCCUPIED' WHERE id IN (
    @bed_101_1, @bed_101_2, @bed_102_1, @bed_102_3, @bed_103_2, @bed_201_1,
    @bed_201_4, @bed_202_2, @bed_301_1, @bed_301_3, @bed_302_1, @bed_401_2
);

-- 7. 验证数据生成结果
SELECT '=== 数据生成完成，验证结果 ===' as info;

SELECT '客户数据统计' as info;
SELECT 
    customer_type as 客户类型,
    status as 状态,
    CASE status 
        WHEN 0 THEN '待入住' 
        WHEN 1 THEN '已入住' 
        ELSE '其他' 
    END as 状态说明,
    COUNT(*) as 数量
FROM customer 
GROUP BY customer_type, status 
ORDER BY customer_type, status;

SELECT '床位使用情况统计' as info;
SELECT 
    bed_status as 床位状态,
    CASE bed_status 
        WHEN 'AVAILABLE' THEN '可用' 
        WHEN 'OCCUPIED' THEN '已占用' 
        WHEN 'MAINTENANCE' THEN '维护中' 
        ELSE '其他' 
    END as 状态说明,
    COUNT(*) as 数量
FROM bed b 
JOIN room r ON b.room_id = r.id 
WHERE r.building_id = 1 
GROUP BY bed_status;

SELECT '楼层床位使用情况' as info;
SELECT 
    r.floor_no as 楼层,
    COUNT(b.id) as 总床位,
    SUM(CASE WHEN b.bed_status = 'OCCUPIED' THEN 1 ELSE 0 END) as 已占用,
    SUM(CASE WHEN b.bed_status = 'AVAILABLE' THEN 1 ELSE 0 END) as 可用床位
FROM room r 
LEFT JOIN bed b ON r.id = b.room_id 
WHERE r.building_id = 1 
GROUP BY r.floor_no 
ORDER BY r.floor_no;

SELECT '床位使用记录统计' as info;
SELECT 
    COUNT(*) as 使用记录数,
    COUNT(DISTINCT customer_id) as 已入住客户数,
    COUNT(DISTINCT bed_id) as 已使用床位数
FROM bed_usage 
WHERE status = 1;

-- 显示一些具体的床位使用示例
SELECT '具体床位使用示例' as info;
SELECT 
    c.customer_name as 客户姓名,
    c.customer_type as 客户类型,
    CONCAT(r.room_no, '-', b.bed_no) as 床位,
    bu.check_in_date as 入住日期,
    b.bed_status as 床位状态
FROM bed_usage bu
JOIN customer c ON bu.customer_id = c.id
JOIN bed b ON bu.bed_id = b.id
JOIN room r ON b.room_id = r.id
WHERE bu.status = 1
ORDER BY r.floor_no, r.room_no, b.bed_no
LIMIT 10;

SELECT 'SQL脚本执行完成！' as result;
