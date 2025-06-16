-- 护理管理测试数据
-- 执行前请确保已有基础数据（用户、楼栋、房间、床位、客户等）

USE nursing_center;

-- 1. 插入护理级别数据
INSERT INTO `care_level` (`id`, `level_name`, `level_code`, `description`, `status`, `create_time`, `update_time`) VALUES
(1, '一级护理', 'LEVEL_1', '适用于完全自理的老人，提供基础的生活护理和健康监测服务', 1, NOW(), NOW()),
(2, '二级护理', 'LEVEL_2', '适用于部分自理的老人，提供日常生活协助和专业护理服务', 1, NOW(), NOW()),
(3, '三级护理', 'LEVEL_3', '适用于不能自理的老人，提供全面的生活护理和医疗护理服务', 1, NOW(), NOW()),
(4, '特级护理', 'LEVEL_SPECIAL', '适用于重度失能老人，提供24小时专业护理和医疗监护服务', 1, NOW(), NOW());

-- 2. 插入护理项目数据
INSERT INTO `care_item` (`id`, `item_code`, `item_name`, `price`, `execute_cycle`, `execute_times`, `description`, `status`, `create_time`, `update_time`) VALUES
-- 日常护理项目
(1, 'DAILY_001', '日常生活护理', 50.00, 1, 1, '协助老人进行日常生活护理，包括洗漱、更衣、整理等', 1, NOW(), NOW()),
(2, 'DAILY_002', '协助进餐', 30.00, 1, 3, '协助老人进餐，确保营养摄入充足', 1, NOW(), NOW()),
(3, 'DAILY_003', '协助如厕', 25.00, 1, 1, '协助老人如厕，保持个人卫生', 1, NOW(), NOW()),
(4, 'DAILY_004', '床铺整理', 20.00, 1, 1, '整理床铺，保持居住环境整洁', 1, NOW(), NOW()),
(5, 'DAILY_005', '洗澡护理', 80.00, 2, 1, '协助老人洗澡，保持身体清洁', 1, NOW(), NOW()),

-- 医疗护理项目
(6, 'MEDICAL_001', '血压测量', 15.00, 1, 2, '定期测量血压，监测健康状况', 1, NOW(), NOW()),
(7, 'MEDICAL_002', '血糖监测', 20.00, 1, 3, '监测血糖水平，预防糖尿病并发症', 1, NOW(), NOW()),
(8, 'MEDICAL_003', '用药指导', 25.00, 1, 1, '指导老人正确用药，确保用药安全', 1, NOW(), NOW()),
(9, 'MEDICAL_004', '伤口护理', 60.00, 1, 1, '专业伤口护理，促进愈合', 1, NOW(), NOW()),
(10, 'MEDICAL_005', '输液护理', 100.00, 1, 1, '静脉输液护理，确保输液安全', 1, NOW(), NOW()),

-- 康复护理项目
(11, 'REHAB_001', '功能训练', 80.00, 1, 1, '进行功能性康复训练，提高生活自理能力', 1, NOW(), NOW()),
(12, 'REHAB_002', '物理治疗', 120.00, 1, 1, '专业物理治疗，改善身体功能', 1, NOW(), NOW()),
(13, 'REHAB_003', '认知训练', 100.00, 2, 1, '认知功能训练，延缓认知衰退', 1, NOW(), NOW()),
(14, 'REHAB_004', '语言训练', 90.00, 1, 1, '语言功能康复训练', 1, NOW(), NOW()),

-- 心理护理项目
(15, 'PSYCH_001', '心理疏导', 100.00, 3, 1, '专业心理疏导，关注老人心理健康', 1, NOW(), NOW()),
(16, 'PSYCH_002', '陪伴聊天', 40.00, 1, 1, '陪伴老人聊天，缓解孤独感', 1, NOW(), NOW()),
(17, 'PSYCH_003', '娱乐活动', 60.00, 2, 1, '组织参与娱乐活动，丰富精神生活', 1, NOW(), NOW()),

-- 专业护理项目
(18, 'PROF_001', '鼻饲护理', 80.00, 1, 3, '鼻饲管护理，确保营养供给', 1, NOW(), NOW()),
(19, 'PROF_002', '导尿护理', 70.00, 1, 2, '导尿管护理，预防感染', 1, NOW(), NOW()),
(20, 'PROF_003', '翻身护理', 40.00, 1, 6, '定期翻身，预防压疮', 1, NOW(), NOW());

-- 3. 插入护理级别项目关联数据
INSERT INTO `care_level_item` (`care_level_id`, `care_item_id`, `create_time`, `update_time`) VALUES
-- 一级护理项目
(1, 1, NOW(), NOW()),  -- 日常生活护理
(1, 2, NOW(), NOW()),  -- 协助进餐
(1, 4, NOW(), NOW()),  -- 床铺整理
(1, 6, NOW(), NOW()),  -- 血压测量
(1, 16, NOW(), NOW()), -- 陪伴聊天

-- 二级护理项目
(2, 1, NOW(), NOW()),  -- 日常生活护理
(2, 2, NOW(), NOW()),  -- 协助进餐
(2, 3, NOW(), NOW()),  -- 协助如厕
(2, 4, NOW(), NOW()),  -- 床铺整理
(2, 5, NOW(), NOW()),  -- 洗澡护理
(2, 6, NOW(), NOW()),  -- 血压测量
(2, 7, NOW(), NOW()),  -- 血糖监测
(2, 8, NOW(), NOW()),  -- 用药指导
(2, 11, NOW(), NOW()), -- 功能训练
(2, 16, NOW(), NOW()), -- 陪伴聊天

-- 三级护理项目
(3, 1, NOW(), NOW()),  -- 日常生活护理
(3, 2, NOW(), NOW()),  -- 协助进餐
(3, 3, NOW(), NOW()),  -- 协助如厕
(3, 4, NOW(), NOW()),  -- 床铺整理
(3, 5, NOW(), NOW()),  -- 洗澡护理
(3, 6, NOW(), NOW()),  -- 血压测量
(3, 7, NOW(), NOW()),  -- 血糖监测
(3, 8, NOW(), NOW()),  -- 用药指导
(3, 9, NOW(), NOW()),  -- 伤口护理
(3, 11, NOW(), NOW()), -- 功能训练
(3, 12, NOW(), NOW()), -- 物理治疗
(3, 15, NOW(), NOW()), -- 心理疏导
(3, 16, NOW(), NOW()), -- 陪伴聊天
(3, 20, NOW(), NOW()), -- 翻身护理

-- 特级护理项目
(4, 1, NOW(), NOW()),  -- 日常生活护理
(4, 2, NOW(), NOW()),  -- 协助进餐
(4, 3, NOW(), NOW()),  -- 协助如厕
(4, 4, NOW(), NOW()),  -- 床铺整理
(4, 5, NOW(), NOW()),  -- 洗澡护理
(4, 6, NOW(), NOW()),  -- 血压测量
(4, 7, NOW(), NOW()),  -- 血糖监测
(4, 8, NOW(), NOW()),  -- 用药指导
(4, 9, NOW(), NOW()),  -- 伤口护理
(4, 10, NOW(), NOW()), -- 输液护理
(4, 11, NOW(), NOW()), -- 功能训练
(4, 12, NOW(), NOW()), -- 物理治疗
(4, 13, NOW(), NOW()), -- 认知训练
(4, 15, NOW(), NOW()), -- 心理疏导
(4, 16, NOW(), NOW()), -- 陪伴聊天
(4, 18, NOW(), NOW()), -- 鼻饲护理
(4, 19, NOW(), NOW()), -- 导尿护理
(4, 20, NOW(), NOW()); -- 翻身护理

-- 4. 为已有客户分配护理级别和护理服务
-- 先查询客户数据，然后为前几个客户分配护理级别
UPDATE `customer` SET `care_level_id` = 1 WHERE `id` = 9; -- 张三 - 一级护理
UPDATE `customer` SET `care_level_id` = 2 WHERE `id` = 10; -- 李四 - 二级护理
UPDATE `customer` SET `care_level_id` = 3 WHERE `id` = 11; -- 王五 - 三级护理
UPDATE `customer` SET `care_level_id` = 2 WHERE `id` = 12; -- 赵六 - 二级护理
UPDATE `customer` SET `care_level_id` = 1 WHERE `id` = 13; -- 钱七 - 一级护理

-- 5. 插入客户护理服务数据
INSERT INTO `customer_care` (`customer_id`, `care_item_id`, `purchase_date`, `purchase_quantity`, `used_quantity`, `remaining_quantity`, `expire_date`, `service_status`, `create_time`, `update_time`) VALUES
-- 客户1的护理服务
(9, 1, '2024-01-01', 30, 15, 15, '2024-01-31', 'NORMAL', NOW(), NOW()),  -- 日常生活护理
(9, 2, '2024-01-01', 90, 45, 45, '2024-01-31', 'NORMAL', NOW(), NOW()),  -- 协助进餐
(9, 6, '2024-01-01', 60, 30, 30, '2024-01-31', 'NORMAL', NOW(), NOW()),  -- 血压测量

-- 客户2的护理服务
(10, 1, '2024-01-01', 30, 12, 18, '2024-01-31', 'NORMAL', NOW(), NOW()),  -- 日常生活护理
(10, 2, '2024-01-01', 90, 36, 54, '2024-01-31', 'NORMAL', NOW(), NOW()),  -- 协助进餐
(10, 5, '2024-01-01', 15, 6, 9, '2024-01-31', 'NORMAL', NOW(), NOW()),   -- 洗澡护理
(10, 7, '2024-01-01', 90, 36, 54, '2024-01-31', 'NORMAL', NOW(), NOW()),  -- 血糖监测
(10, 11, '2024-01-01', 30, 12, 18, '2024-01-31', 'NORMAL', NOW(), NOW()), -- 功能训练

-- 客户3的护理服务
(11, 1, '2024-01-01', 30, 10, 20, '2024-01-31', 'NORMAL', NOW(), NOW()),  -- 日常生活护理
(11, 2, '2024-01-01', 90, 30, 60, '2024-01-31', 'NORMAL', NOW(), NOW()),  -- 协助进餐
(11, 3, '2024-01-01', 30, 10, 20, '2024-01-31', 'NORMAL', NOW(), NOW()),  -- 协助如厕
(11, 5, '2024-01-01', 15, 5, 10, '2024-01-31', 'NORMAL', NOW(), NOW()),   -- 洗澡护理
(11, 9, '2024-01-01', 10, 3, 7, '2024-01-31', 'NORMAL', NOW(), NOW()),   -- 伤口护理
(11, 12, '2024-01-01', 30, 10, 20, '2024-01-31', 'NORMAL', NOW(), NOW()), -- 物理治疗
(11, 20, '2024-01-01', 180, 60, 120, '2024-01-31', 'NORMAL', NOW(), NOW()); -- 翻身护理

-- 6. 插入护理记录数据
INSERT INTO `care_record` (`customer_id`, `care_item_id`, `health_manager_id`, `care_time`, `care_quantity`, `care_content`, `remark`, `create_time`, `update_time`) VALUES
-- 最近一周的护理记录
-- 2024-01-15的记录
(9, 1, 1, '2024-01-15 09:30:00', 1, '协助张三完成晨间护理，包括洗漱、更衣等。老人配合度较好，身体状况稳定。', '老人心情愉快，建议继续现有护理方案', NOW(), NOW()),
(9, 2, 1, '2024-01-15 12:00:00', 1, '协助张三午餐，食欲良好，进食正常。', '建议增加蔬菜摄入', NOW(), NOW()),
(9, 6, 1, '2024-01-15 14:00:00', 1, '测量血压：130/85mmHg，数值正常。', '血压稳定，继续观察', NOW(), NOW()),

(10, 1, 2, '2024-01-15 08:45:00', 1, '协助李四进行日常护理，老人行动不便，需要较多协助。', '建议增加康复训练频次', NOW(), NOW()),
(10, 7, 2, '2024-01-15 11:00:00', 1, '测量血糖：6.8mmol/L，数值正常。', '血糖控制良好', NOW(), NOW()),
(10, 11, 2, '2024-01-15 15:30:00', 1, '进行下肢功能训练30分钟，老人配合度一般。', '训练过程中老人略感疲劳，建议适当调整强度', NOW(), NOW()),

(11, 20, 3, '2024-01-15 10:00:00', 1, '为王五进行翻身护理，检查皮肤状况。', '皮肤完整性良好，无压疮征象', NOW(), NOW()),
(11, 2, 3, '2024-01-15 12:30:00', 1, '协助王五午餐，需要协助咀嚼和吞咽。', '进食缓慢，需要耐心协助', NOW(), NOW()),
(11, 9, 3, '2024-01-15 16:00:00', 1, '更换左腿伤口敷料，伤口愈合良好。', '伤口无感染征象，继续现有护理方案', NOW(), NOW()),

-- 2024-01-14的记录
(9, 1, 1, '2024-01-14 09:15:00', 1, '协助张三晨间护理，老人精神状态良好。', '', NOW(), NOW()),
(9, 2, 1, '2024-01-14 18:30:00', 1, '协助张三晚餐，食欲良好。', '', NOW(), NOW()),

(10, 5, 2, '2024-01-14 10:30:00', 1, '协助李四洗澡，水温适宜，老人感觉舒适。', '洗澡后精神状态有所改善', NOW(), NOW()),
(10, 8, 2, '2024-01-14 20:00:00', 1, '指导李四晚间用药，确保按时按量服用。', '老人记忆力有所下降，需要反复提醒', NOW(), NOW()),

(11, 1, 3, '2024-01-14 08:30:00', 1, '协助王五晨间护理，需要全程协助。', '', NOW(), NOW()),
(11, 12, 3, '2024-01-14 14:30:00', 1, '进行物理治疗，主要针对上肢功能恢复。', '治疗过程配合良好，有轻微改善', NOW(), NOW()),

-- 2024-01-13的记录
(9, 6, 1, '2024-01-13 09:00:00', 1, '测量血压：125/80mmHg，数值正常。', '', NOW(), NOW()),
(10, 7, 2, '2024-01-13 17:00:00', 1, '测量血糖：7.2mmol/L，略高于正常值。', '建议调整饮食结构', NOW(), NOW()),
(11, 15, 3, '2024-01-13 15:00:00', 1, '进行心理疏导，老人情绪有所低落。', '老人表达了对家人的思念，需要更多关注', NOW(), NOW());

-- 7. 更新护理服务使用情况
-- 这里可以根据护理记录更新客户护理服务的使用数量
-- UPDATE customer_care SET used_quantity = used_quantity + 1 WHERE customer_id = 1 AND care_item_id = 1;
-- (实际使用中应该通过触发器或应用程序逻辑来自动更新)

-- 查询验证数据
SELECT '=== 护理级别 ===' AS info;
SELECT * FROM care_level;

SELECT '=== 护理项目 ===' AS info;
SELECT * FROM care_item LIMIT 10;

SELECT '=== 护理级别项目关联 ===' AS info;
SELECT cl.level_name, ci.item_name 
FROM care_level_item cli
JOIN care_level cl ON cli.care_level_id = cl.id
JOIN care_item ci ON cli.care_item_id = ci.id
ORDER BY cl.id, ci.id
LIMIT 20;

SELECT '=== 客户护理设置 ===' AS info;
SELECT c.customer_name, cl.level_name
FROM customer c
LEFT JOIN care_level cl ON c.care_level_id = cl.id
WHERE c.care_level_id IS NOT NULL
LIMIT 5;

SELECT '=== 护理记录统计 ===' AS info;
SELECT 
    c.customer_name,
    ci.item_name,
    COUNT(*) as record_count,
    DATE(MAX(cr.care_time)) as last_care_date
FROM care_record cr
JOIN customer c ON cr.customer_id = c.id
JOIN care_item ci ON cr.care_item_id = ci.id
GROUP BY c.customer_name, ci.item_name
ORDER BY c.customer_name, record_count DESC;
