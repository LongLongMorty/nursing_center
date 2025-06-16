-- 为刘淑华（客户ID: 10）生成退住申请记录
-- 客户信息：刘淑华，74岁，女，身份证：110101195101010010，健康管家ID: 4

INSERT INTO `checkout_apply` (
    `customer_id`,
    `applicant_id`, 
    `checkout_type`,
    `checkout_reason`,
    `checkout_date`,
    `apply_status`,
    `create_time`
) VALUES (
    10,                          -- 客户ID：刘淑华
    4,                           -- 申请人ID：健康管家ID
    'NORMAL',                    -- 退住类型：正常退住
    '老人家属要求转院至其他养老机构，希望能够就近照顾。老人身体状况良好，无重大疾病，可以正常办理退住手续。',  -- 退住原因
    '2025-06-15',               -- 退住时间：预计15天后
    'SUBMITTED',                -- 申请状态：已提交
    NOW()                       -- 创建时间：当前时间
);

-- 查询验证数据
SELECT 
    ca.id,
    ca.customer_id,
    c.customer_name,
    ca.applicant_id,
    su.real_name as applicant_name,
    ca.checkout_type,
    ca.checkout_reason,
    ca.checkout_date,
    ca.apply_status,
    ca.create_time
FROM checkout_apply ca
INNER JOIN customer c ON ca.customer_id = c.id
LEFT JOIN sys_user su ON ca.applicant_id = su.id
WHERE ca.customer_id = 10
ORDER BY ca.create_time DESC;
