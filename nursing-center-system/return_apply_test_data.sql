-- 为客户杨秀兰（ID: 5）生成回院申请测试数据
-- 该客户已有外出申请（ID: 12）且状态为已审批通过的外出状态

USE nursing_center;

-- 插入回院申请记录
INSERT INTO return_apply (
    customer_id,              -- 客户ID：杨秀兰
    outing_apply_id,          -- 关联的外出申请ID
    applicant_id,             -- 申请人ID（健康管家）
    return_reason,            -- 回院事由
    requested_return_date,    -- 申请回院时间
    apply_status,             -- 申请状态
    create_time               -- 创建时间
) VALUES (
    12,                        -- 客户ID：杨秀兰
    2,                       -- 外出申请ID
    5,                        -- 申请人ID：健康管家（假设为2号用户）
    '老人体检结束，身体状况良好，各项检查指标正常。现申请老人按计划回院。老人情绪稳定，能够正常行走，预计今日下午15:30回到养老院。已通知家属杨小凤，请安排接院准备工作。',  -- 回院事由
    '2025-06-10 15:30:00',    -- 申请回院时间
    'SUBMITTED',              -- 申请状态：已提交
    NOW()                     -- 创建时间：当前时间
);

-- 查询验证数据
SELECT 
    ra.id as 回院申请ID,
    ra.customer_id as 客户ID,
    c.customer_name as 客户姓名,
    ra.outing_apply_id as 外出申请ID,
    ra.applicant_id as 申请人ID,
    su.real_name as 申请人姓名,
    ra.return_reason as 回院事由,
    ra.requested_return_date as 申请回院时间,
    ra.actual_return_date as 实际回院时间,
    ra.apply_status as 申请状态,
    CASE ra.apply_status
        WHEN 'SUBMITTED' THEN '已提交'
        WHEN 'APPROVED' THEN '审批通过'
        WHEN 'REJECTED' THEN '审批拒绝'
        ELSE ra.apply_status
    END as 申请状态说明,
    ra.create_time as 创建时间,
    -- 关联的外出申请信息
    oa.outing_reason as 外出原因,
    oa.outing_date as 外出时间,
    oa.expected_return_date as 预计回院时间,
    oa.apply_status as 外出申请状态
FROM return_apply ra
INNER JOIN customer c ON ra.customer_id = c.id
LEFT JOIN sys_user su ON ra.applicant_id = su.id
LEFT JOIN outing_apply oa ON ra.outing_apply_id = oa.id
WHERE ra.customer_id = 5
ORDER BY ra.create_time DESC;

-- 查询客户当前状态
SELECT 
    c.id as 客户ID,
    c.customer_name as 客户姓名,
    c.status as 客户状态,
    CASE c.status 
        WHEN 1 THEN '在住' 
        WHEN 0 THEN '已退住' 
        ELSE '其他' 
    END as 状态说明,
    b.bed_status as 床位状态,
    CASE b.bed_status
        WHEN 'AVAILABLE' THEN '空闲'
        WHEN 'OCCUPIED' THEN '有人'
        WHEN 'OUT' THEN '外出'
        ELSE b.bed_status
    END as 床位状态说明,
    CONCAT(bu.building_name, '-', r.room_no, '-', b.bed_no) as 床位信息
FROM customer c
LEFT JOIN bed b ON c.bed_id = b.id
LEFT JOIN room r ON b.room_id = r.id  
LEFT JOIN building bu ON r.building_id = bu.id
WHERE c.id = 5;

SELECT '=== 回院申请记录生成完成 ===' as info;
