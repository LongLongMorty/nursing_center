-- 东软颐养中心管理系统测试数据生成脚本
-- 生成房间和床位数据（5层楼，每层6个房间，每个房间4个床位）

USE nursing_center;

-- 清空相关表数据（保留sys_user和building表）
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE customer;
TRUNCATE TABLE bed_usage;
TRUNCATE TABLE bed;
TRUNCATE TABLE room;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. 生成房间数据
-- 假设building_id = 1 (606号楼)
INSERT INTO room (building_id, room_no, room_name, floor_no, bed_count, room_type, status) VALUES
-- 1楼房间 (101-106)
(1, '101', '101室', 1, 4, 'STANDARD', 1),
(1, '102', '102室', 1, 4, 'STANDARD', 1),
(1, '103', '103室', 1, 4, 'STANDARD', 1),
(1, '104', '104室', 1, 4, 'STANDARD', 1),
(1, '105', '105室', 1, 4, 'STANDARD', 1),
(1, '106', '106室', 1, 4, 'STANDARD', 1),

-- 2楼房间 (201-206)
(1, '201', '201室', 2, 4, 'STANDARD', 1),
(1, '202', '202室', 2, 4, 'STANDARD', 1),
(1, '203', '203室', 2, 4, 'STANDARD', 1),
(1, '204', '204室', 2, 4, 'STANDARD', 1),
(1, '205', '205室', 2, 4, 'STANDARD', 1),
(1, '206', '206室', 2, 4, 'STANDARD', 1),

-- 3楼房间 (301-306)
(1, '301', '301室', 3, 4, 'STANDARD', 1),
(1, '302', '302室', 3, 4, 'STANDARD', 1),
(1, '303', '303室', 3, 4, 'STANDARD', 1),
(1, '304', '304室', 3, 4, 'STANDARD', 1),
(1, '305', '305室', 3, 4, 'STANDARD', 1),
(1, '306', '306室', 3, 4, 'STANDARD', 1),

-- 4楼房间 (401-406)
(1, '401', '401室', 4, 4, 'STANDARD', 1),
(1, '402', '402室', 4, 4, 'STANDARD', 1),
(1, '403', '403室', 4, 4, 'STANDARD', 1),
(1, '404', '404室', 4, 4, 'STANDARD', 1),
(1, '405', '405室', 4, 4, 'STANDARD', 1),
(1, '406', '406室', 4, 4, 'STANDARD', 1),

-- 5楼房间 (501-506)
(1, '501', '501室', 5, 4, 'STANDARD', 1),
(1, '502', '502室', 5, 4, 'STANDARD', 1),
(1, '503', '503室', 5, 4, 'STANDARD', 1),
(1, '504', '504室', 5, 4, 'STANDARD', 1),
(1, '505', '505室', 5, 4, 'STANDARD', 1),
(1, '506', '506室', 5, 4, 'STANDARD', 1);

-- 2. 生成床位数据
-- 为每个房间生成4个床位（床位号：1号床、2号床、3号床、4号床）

-- 获取房间ID并为每个房间创建床位
INSERT INTO bed (room_id, bed_no, bed_type, bed_status, status)
SELECT 
    r.id as room_id,
    CONCAT(bed_nums.bed_no, '号床') as bed_no,
    'STANDARD' as bed_type,
    'AVAILABLE' as bed_status,
    1 as status
FROM room r
CROSS JOIN (
    SELECT '1' as bed_no UNION ALL
    SELECT '2' as bed_no UNION ALL  
    SELECT '3' as bed_no UNION ALL
    SELECT '4' as bed_no
) bed_nums
WHERE r.building_id = 1
ORDER BY r.floor_no, r.room_no, bed_nums.bed_no;

-- 3. 生成一些测试客户数据（可选）
INSERT INTO customer (customer_name, age, gender, id_card, birth_date, blood_type, guardian_name, guardian_phone, customer_type, status) VALUES
('张三', 75, 'MALE', '110101194901010001', '1949-01-01', 'A', '张小明', '13800138001', 'SELF_CARE', 0),
('李四', 68, 'FEMALE', '110101195601010002', '1956-01-01', 'B', '李小红', '13800138002', 'CARE', 0),
('王五', 82, 'MALE', '110101194201010003', '1942-01-01', 'O', '王小华', '13800138003', 'SELF_CARE', 0),
('赵六', 79, 'FEMALE', '110101194501010004', '1945-01-01', 'AB', '赵小美', '13800138004', 'CARE', 0),
('钱七', 71, 'MALE', '110101195301010005', '1953-01-01', 'A', '钱小强', '13800138005', 'SELF_CARE', 0),
('孙八', 66, 'FEMALE', '110101195801010006', '1958-01-01', 'B', '孙小丽', '13800138006', 'CARE', 0),
('周九', 84, 'MALE', '110101194001010007', '1940-01-01', 'O', '周小刚', '13800138007', 'SELF_CARE', 0),
('吴十', 77, 'FEMALE', '110101194701010008', '1947-01-01', 'A', '吴小芳', '13800138008', 'CARE', 0);

-- 查询验证数据
SELECT '房间数据统计' as info;
SELECT 
    floor_no as 楼层,
    COUNT(*) as 房间数量
FROM room 
WHERE building_id = 1 
GROUP BY floor_no 
ORDER BY floor_no;

SELECT '床位数据统计' as info;
SELECT 
    r.floor_no as 楼层,
    COUNT(b.id) as 床位数量
FROM room r 
LEFT JOIN bed b ON r.id = b.room_id 
WHERE r.building_id = 1 
GROUP BY r.floor_no 
ORDER BY r.floor_no;

SELECT '总计统计' as info;
SELECT 
    (SELECT COUNT(*) FROM room WHERE building_id = 1) as 总房间数,
    (SELECT COUNT(*) FROM bed b JOIN room r ON b.room_id = r.id WHERE r.building_id = 1) as 总床位数,
    (SELECT COUNT(*) FROM customer WHERE status = 0) as 待入住客户数;
