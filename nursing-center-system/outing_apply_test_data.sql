-- 东软颐养中心管理系统 - 外出申请测试数据
-- 为客户杨秀兰（ID: 12）生成护工申请的外出申请记录

USE nursing_center;



-- 2. 生成外出申请记录
-- 客户信息：杨秀兰，77岁，女性，客户ID: 12，身份证: 110101194801010012，居住在102室3号床
INSERT INTO outing_apply (
    customer_id,
    applicant_id,
    outing_reason,
    outing_date,
    expected_return_date,
    apply_status,
    create_time
) VALUES (
    12,                                      -- 客户ID：杨秀兰
    @health_manager_id,                      -- 申请人ID：健康管家（护工）
    '陪同杨秀兰老人前往北京市海淀区人民医院进行定期体检，预约时间为上午9:00。老人身体状况良好，能够正常出行，预计下午3点前返回养老院。由护工张护士全程陪同，确保老人安全。紧急联系人：杨小凤（13800138012）。',  -- 外出原因
    '2025-06-10 08:30:00',                   -- 外出时间：明天上午8:30
    '2025-06-10 15:00:00',                   -- 预计回院时间：明天下午3:00
    'SUBMITTED',                             -- 申请状态：已提交
    NOW()                                    -- 创建时间：当前时间
);

-- 3. 验证数据生成结果
SELECT '=== 外出申请记录生成完成 ===' as info;

-- 查询刚创建的外出申请记录
SELECT 
    oa.id as 申请ID,
    oa.customer_id as 客户ID,
    c.customer_name as 客户姓名,
    c.age as 年龄,
    c.gender as 性别,
    oa.applicant_id as 申请人ID,
    su.real_name as 申请人姓名,
    su.role as 申请人角色,
    oa.outing_reason as 外出原因,
    oa.outing_date as 外出时间,
    oa.expected_return_date as 预计回院时间,
    oa.actual_return_date as 实际回院时间,
    oa.apply_status as 申请状态,
    oa.create_time as 创建时间
FROM outing_apply oa
INNER JOIN customer c ON oa.customer_id = c.id
LEFT JOIN sys_user su ON oa.applicant_id = su.id
WHERE oa.customer_id = 12 
ORDER BY oa.create_time DESC
LIMIT 1;

-- 查询客户基本信息确认
SELECT 
    c.id as 客户ID,
    c.customer_name as 客户姓名,
    c.age as 年龄,
    c.gender as 性别,
    c.id_card as 身份证号,
    c.status as 客户状态,
    CASE c.status 
        WHEN 1 THEN '已入住' 
        WHEN 0 THEN '待入住' 
        ELSE '其他' 
    END as 状态说明,
    CONCAT(b.building_name, '-', r.room_no, '-', bed.bed_no) as 床位信息
FROM customer c
LEFT JOIN bed bed ON c.bed_id = bed.id
LEFT JOIN room r ON bed.room_id = r.id  
LEFT JOIN building b ON r.building_id = b.id
WHERE c.id = 12;

-- 查询健康管家信息
SELECT 
    su.id as 管家ID,
    su.username as 用户名,
    su.real_name as 真实姓名,
    su.phone as 联系电话,
    su.role as 角色,
    CASE su.status 
        WHEN 1 THEN '启用' 
        WHEN 0 THEN '禁用' 
        ELSE '未知' 
    END as 状态
FROM sys_user su 
WHERE su.username = 'nurse002' AND su.role = 'HEALTH_MANAGER';
