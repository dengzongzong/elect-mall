-- ============================================================
-- 电子元器件商城 MySQL 8.0 完整初始化脚本
-- 说明：创建数据库、表结构、索引、初始数据及演示数据
-- 日期：2026-08-26
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS mall_db
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE mall_db;

-- ============================================================
-- 1. 分类表 (category)
-- ============================================================
DROP TABLE IF EXISTS category;
CREATE TABLE category (
    id          BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '分类ID',
    name        VARCHAR(64)     NOT NULL                 COMMENT '分类名称',
    parent_id   BIGINT          DEFAULT NULL             COMMENT '父分类ID',
    attr_table  VARCHAR(64)     DEFAULT NULL             COMMENT '属性表名',
    prefix      VARCHAR(16)     DEFAULT NULL             COMMENT '编号前缀',
    sort        INT             DEFAULT 0                COMMENT '排序',
    status      TINYINT         DEFAULT 1                COMMENT '状态：1-启用 0-禁用',
    created_at  DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at  DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted     TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

-- 初始分类数据
INSERT INTO category (id, name, parent_id, attr_table, prefix, sort, status, created_at, updated_at)
VALUES
    (1, '电容/电阻',        NULL, 'capacitor_attr', 'CR', 1, 1, NOW(), NOW()),
    (2, '电感/变压器/磁性元件', NULL, 'inductor_attr',  'LM', 2, 1, NOW(), NOW()),
    (3, '滤波器/晶振',       NULL, 'filter_attr',    'FC', 3, 1, NOW(), NOW());

-- ============================================================
-- 2. 属性字段定义表 (attr_field_def)
-- ============================================================
DROP TABLE IF EXISTS attr_field_def;
CREATE TABLE attr_field_def (
    id          BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '字段ID',
    category_id BIGINT          NOT NULL                 COMMENT '所属分类ID',
    field_name  VARCHAR(64)     NOT NULL                 COMMENT '字段名(英文)',
    field_label VARCHAR(64)     NOT NULL                 COMMENT '字段标签(中文)',
    field_type  VARCHAR(16)     NOT NULL DEFAULT 'string' COMMENT '字段类型：string/number/select',
    options     VARCHAR(255)    DEFAULT NULL             COMMENT '选项值(select类型时用逗号分隔)',
    is_search   TINYINT         DEFAULT 0                COMMENT '是否可搜索：1-是 0-否',
    sort        INT             DEFAULT 0                COMMENT '排序',
    status      TINYINT         DEFAULT 1                COMMENT '状态：1-启用 0-禁用',
    created_at  DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at  DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted     TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    KEY idx_category (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='属性字段定义表';

-- ============================================================
-- 3. 品牌表 (brand)
-- ============================================================
DROP TABLE IF EXISTS brand;
CREATE TABLE brand (
    id           BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '品牌ID',
    name         VARCHAR(64)     NOT NULL                 COMMENT '品牌名称',
    logo         VARCHAR(255)    DEFAULT NULL             COMMENT '品牌Logo URL',
    description  TEXT            DEFAULT NULL             COMMENT '品牌描述',
    sort         INT             DEFAULT 0                COMMENT '排序',
    status       TINYINT         DEFAULT 1                COMMENT '状态：1-启用 0-禁用',
    is_cooperate TINYINT         DEFAULT 0                COMMENT '是否合作品牌：1-是 0-否',
    created_at   DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at   DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted      TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='品牌表';

-- 初始品牌数据
INSERT INTO brand (id, name, sort, status, created_at, updated_at) VALUES
    (1, '三星',   1, 1, NOW(), NOW()),
    (2, '村田',   2, 1, NOW(), NOW()),
    (3, 'TDK',    3, 1, NOW(), NOW()),
    (4, '国巨',   4, 1, NOW(), NOW()),
    (5, '华新科', 5, 1, NOW(), NOW());

-- ============================================================
-- 4. 产品表 (product)
-- ============================================================
DROP TABLE IF EXISTS product;
CREATE TABLE product (
    id            BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '产品ID',
    category_id   BIGINT          NOT NULL                 COMMENT '分类ID',
    brand_id      BIGINT          DEFAULT NULL             COMMENT '品牌ID',
    part_no       VARCHAR(64)     NOT NULL                 COMMENT '产品型号/料号',
    name          VARCHAR(255)    DEFAULT NULL             COMMENT '产品名称',
    description   TEXT            DEFAULT NULL             COMMENT '产品描述',
    stock         INT             DEFAULT 0                COMMENT '库存数量',
    price         DECIMAL(12,4)   DEFAULT NULL             COMMENT '单价',
    min_order     INT             DEFAULT 1                COMMENT '最小起订量',
    weight        DECIMAL(10,4)   DEFAULT NULL             COMMENT '重量(kg)',
    unit          VARCHAR(16)     DEFAULT NULL             COMMENT '单位',
    datasheet_url VARCHAR(255)    DEFAULT NULL             COMMENT '数据手册URL',
    image_url     VARCHAR(255)    DEFAULT NULL             COMMENT '产品图片URL',
    status        TINYINT         DEFAULT 1                COMMENT '状态：1-上架 0-下架',
    created_at    DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at    DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted       TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_part_no (part_no),
    KEY idx_category (category_id),
    KEY idx_part_no (part_no),
    KEY idx_brand (brand_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品表';

-- ============================================================
-- 5. 电容属性表 (capacitor_attr)
-- ============================================================
DROP TABLE IF EXISTS capacitor_attr;
CREATE TABLE capacitor_attr (
    id                BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    product_id        BIGINT          NOT NULL                 COMMENT '产品ID',
    capacitance       VARCHAR(64)     DEFAULT NULL             COMMENT '电容值',
    tolerance         VARCHAR(32)     DEFAULT NULL             COMMENT '容差',
    voltage_rating    VARCHAR(32)     DEFAULT NULL             COMMENT '额定电压',
    package           VARCHAR(32)     DEFAULT NULL             COMMENT '封装',
    material          VARCHAR(64)     DEFAULT NULL             COMMENT '材质',
    temperature_range VARCHAR(64)     DEFAULT NULL             COMMENT '温度范围',
    PRIMARY KEY (id),
    KEY idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='电容属性表';

-- ============================================================
-- 6. 电感属性表 (inductor_attr)
-- ============================================================
DROP TABLE IF EXISTS inductor_attr;
CREATE TABLE inductor_attr (
    id             BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    product_id     BIGINT          NOT NULL                 COMMENT '产品ID',
    inductance     VARCHAR(64)     DEFAULT NULL             COMMENT '电感值',
    rated_current  VARCHAR(32)     DEFAULT NULL             COMMENT '额定电流',
    dc_resistance  VARCHAR(32)     DEFAULT NULL             COMMENT '直流电阻',
    package        VARCHAR(32)     DEFAULT NULL             COMMENT '封装',
    type           VARCHAR(32)     DEFAULT NULL             COMMENT '类型',
    PRIMARY KEY (id),
    KEY idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='电感属性表';

-- ============================================================
-- 7. 滤波器属性表 (filter_attr)
-- ============================================================
DROP TABLE IF EXISTS filter_attr;
CREATE TABLE filter_attr (
    id             BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    product_id     BIGINT          NOT NULL                 COMMENT '产品ID',
    type           VARCHAR(64)     DEFAULT NULL             COMMENT '滤波器类型',
    frequency      VARCHAR(64)     DEFAULT NULL             COMMENT '频率',
    insertion_loss VARCHAR(32)     DEFAULT NULL             COMMENT '插入损耗',
    package        VARCHAR(32)     DEFAULT NULL             COMMENT '封装',
    operating_temp VARCHAR(64)     DEFAULT NULL             COMMENT '工作温度',
    PRIMARY KEY (id),
    KEY idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='滤波器属性表';

-- ============================================================
-- 8. 订单表 (order) —— 使用反引号避免与关键字冲突
-- ============================================================
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
    id               BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '订单ID',
    order_no         VARCHAR(32)     NOT NULL                 COMMENT '订单编号',
    user_id          BIGINT          DEFAULT NULL             COMMENT '用户ID',
    total_amount     DECIMAL(12,2)   DEFAULT NULL             COMMENT '订单总金额',
    status           VARCHAR(16)     DEFAULT NULL             COMMENT '订单状态：待审核/待付款/待发货/待收货/已完成/已取消',
    payment_method   VARCHAR(16)     DEFAULT NULL             COMMENT '支付方式',
    transfer_voucher VARCHAR(255)    DEFAULT NULL             COMMENT '转账凭证URL',
    receiver_name    VARCHAR(64)     DEFAULT NULL             COMMENT '收货人姓名',
    receiver_phone   VARCHAR(20)     DEFAULT NULL             COMMENT '收货人电话',
    receiver_address VARCHAR(255)    DEFAULT NULL             COMMENT '收货地址',
    remark           VARCHAR(500)    DEFAULT NULL             COMMENT '订单备注',
    created_at       DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at       DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted          TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_no (order_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- ============================================================
-- 9. 订单明细表 (order_item)
-- ============================================================
DROP TABLE IF EXISTS order_item;
CREATE TABLE order_item (
    id           BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    order_id     BIGINT          DEFAULT NULL             COMMENT '订单ID',
    product_id   BIGINT          DEFAULT NULL             COMMENT '产品ID',
    part_no      VARCHAR(64)     DEFAULT NULL             COMMENT '产品型号',
    product_name VARCHAR(255)    DEFAULT NULL             COMMENT '产品名称',
    quantity     INT             DEFAULT NULL             COMMENT '数量',
    price        DECIMAL(12,4)   DEFAULT NULL             COMMENT '单价',
    subtotal     DECIMAL(12,4)   DEFAULT NULL             COMMENT '小计金额',
    created_at   DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at   DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted      TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单明细表';

-- ============================================================
-- 10. 购物车表 (cart)
-- ============================================================
DROP TABLE IF EXISTS cart;
CREATE TABLE cart (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    user_id    BIGINT          NOT NULL                 COMMENT '用户ID',
    product_id BIGINT          NOT NULL                 COMMENT '产品ID',
    quantity   INT             DEFAULT 1                COMMENT '数量',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车表';

-- ============================================================
-- 11. 支付记录表 (pay_record)
-- ============================================================
DROP TABLE IF EXISTS pay_record;
CREATE TABLE pay_record (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    pay_no     VARCHAR(64)     NOT NULL                 COMMENT '支付编号',
    order_id   BIGINT          DEFAULT NULL             COMMENT '订单ID',
    order_no   VARCHAR(32)     DEFAULT NULL             COMMENT '订单编号',
    amount     DECIMAL(12,2)   DEFAULT NULL             COMMENT '支付金额',
    method     VARCHAR(16)     DEFAULT NULL             COMMENT '支付方式',
    status     VARCHAR(16)     DEFAULT NULL             COMMENT '支付状态',
    pay_time   DATETIME        DEFAULT NULL             COMMENT '支付时间',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_pay_no (pay_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付记录表';

-- ============================================================
-- 12. 用户表 (user)
-- ============================================================
DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '用户ID',
    phone      VARCHAR(20)     DEFAULT NULL             COMMENT '手机号',
    openid     VARCHAR(64)     DEFAULT NULL             COMMENT '微信openid',
    nickname   VARCHAR(64)     DEFAULT NULL             COMMENT '昵称',
    avatar     VARCHAR(255)    DEFAULT NULL             COMMENT '头像URL',
    balance    DECIMAL(12,2)   DEFAULT 0.00             COMMENT '账户余额',
    status     TINYINT         DEFAULT 1                COMMENT '状态：1-正常 0-禁用',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ============================================================
-- 13. 用户地址表 (user_address)
-- ============================================================
DROP TABLE IF EXISTS user_address;
CREATE TABLE user_address (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    user_id    BIGINT          NOT NULL                 COMMENT '用户ID',
    name       VARCHAR(64)     DEFAULT NULL             COMMENT '收货人姓名',
    phone      VARCHAR(20)     DEFAULT NULL             COMMENT '收货人电话',
    province   VARCHAR(32)     DEFAULT NULL             COMMENT '省份',
    city       VARCHAR(32)     DEFAULT NULL             COMMENT '城市',
    district   VARCHAR(32)     DEFAULT NULL             COMMENT '区县',
    detail     VARCHAR(255)    DEFAULT NULL             COMMENT '详细地址',
    is_default TINYINT         DEFAULT 0                COMMENT '是否默认地址：1-是 0-否',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户地址表';

-- ============================================================
-- 14. 用户余额变动记录表 (user_balance_log)
-- ============================================================
DROP TABLE IF EXISTS user_balance_log;
CREATE TABLE user_balance_log (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    user_id    BIGINT          NOT NULL                 COMMENT '用户ID',
    amount     DECIMAL(12,2)   DEFAULT NULL             COMMENT '变动金额(正数收入/负数支出)',
    type       VARCHAR(16)     DEFAULT NULL             COMMENT '变动类型',
    remark     VARCHAR(255)    DEFAULT NULL             COMMENT '备注',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户余额变动记录表';

-- ============================================================
-- 15. 收藏表 (favorite)
-- ============================================================
DROP TABLE IF EXISTS favorite;
CREATE TABLE favorite (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    user_id    BIGINT          NOT NULL                 COMMENT '用户ID',
    product_id BIGINT          NOT NULL                 COMMENT '产品ID',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收藏表';

-- ============================================================
-- 16. 管理员用户表 (admin_user)
-- ============================================================
DROP TABLE IF EXISTS admin_user;
CREATE TABLE admin_user (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    username   VARCHAR(32)     NOT NULL                 COMMENT '用户名',
    password   VARCHAR(128)    NOT NULL                 COMMENT '密码(bcrypt加密)',
    nickname   VARCHAR(64)     DEFAULT NULL             COMMENT '昵称',
    role       VARCHAR(16)     DEFAULT 'ADMIN'          COMMENT '角色：ADMIN-管理员',
    status     TINYINT         DEFAULT 1                COMMENT '状态：1-正常 0-禁用',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员用户表';

-- 初始管理员数据（密码：admin123，bcrypt hash）
INSERT INTO admin_user (username, password, nickname, role, status, created_at, updated_at) VALUES
    ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '系统管理员', 'ADMIN', 1, NOW(), NOW());

-- ============================================================
-- 17. BOM清单记录表 (bom_record)
-- ============================================================
DROP TABLE IF EXISTS bom_record;
CREATE TABLE bom_record (
    id           BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    user_id      BIGINT          DEFAULT NULL             COMMENT '用户ID',
    match_count  INT             DEFAULT 0                COMMENT '匹配数量',
    total_count  INT             DEFAULT 0                COMMENT '总物料数',
    total_amount DECIMAL(12,2)   DEFAULT NULL             COMMENT '总金额',
    status       VARCHAR(16)     DEFAULT NULL             COMMENT '状态',
    created_at   DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at   DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted      TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BOM清单记录表';

-- ============================================================
-- 18. BOM清单明细表 (bom_item)
-- ============================================================
DROP TABLE IF EXISTS bom_item;
CREATE TABLE bom_item (
    id           BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    bom_id       BIGINT          NOT NULL                 COMMENT 'BOM记录ID',
    part_no      VARCHAR(64)     DEFAULT NULL             COMMENT '产品型号',
    quantity     INT             DEFAULT NULL             COMMENT '数量',
    match_status VARCHAR(16)     DEFAULT NULL             COMMENT '匹配状态',
    product_id   BIGINT          DEFAULT NULL             COMMENT '匹配产品ID',
    price        DECIMAL(12,4)   DEFAULT NULL             COMMENT '单价',
    subtotal     DECIMAL(12,4)   DEFAULT NULL             COMMENT '小计金额',
    created_at   DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at   DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted      TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BOM清单明细表';

-- ============================================================
-- 19. 询价单表 (inquiry)
-- ============================================================
DROP TABLE IF EXISTS inquiry;
CREATE TABLE inquiry (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    inquiry_no VARCHAR(32)     NOT NULL                 COMMENT '询价单编号',
    user_id    BIGINT          DEFAULT NULL             COMMENT '用户ID',
    contact    VARCHAR(64)     DEFAULT NULL             COMMENT '联系人',
    phone      VARCHAR(20)     DEFAULT NULL             COMMENT '联系电话',
    remark     VARCHAR(500)    DEFAULT NULL             COMMENT '备注',
    status     VARCHAR(16)     DEFAULT NULL             COMMENT '状态',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_inquiry_no (inquiry_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='询价单表';

-- ============================================================
-- 20. 询价单明细表 (inquiry_item)
-- ============================================================
DROP TABLE IF EXISTS inquiry_item;
CREATE TABLE inquiry_item (
    id           BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    inquiry_id   BIGINT          NOT NULL                 COMMENT '询价单ID',
    product_id   BIGINT          DEFAULT NULL             COMMENT '产品ID',
    part_no      VARCHAR(64)     DEFAULT NULL             COMMENT '产品型号',
    quantity     INT             DEFAULT NULL             COMMENT '数量',
    target_price DECIMAL(12,4)   DEFAULT NULL             COMMENT '目标单价',
    created_at   DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at   DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted      TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='询价单明细表';

-- ============================================================
-- 21. 资讯/新闻表 (news)
-- ============================================================
DROP TABLE IF EXISTS news;
CREATE TABLE news (
    id            BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    title         VARCHAR(255)    NOT NULL                 COMMENT '标题',
    content       TEXT            DEFAULT NULL             COMMENT '内容',
    image         VARCHAR(255)    DEFAULT NULL             COMMENT '封面图片URL',
    like_count    INT             DEFAULT 0                COMMENT '点赞数',
    favorite_count INT            DEFAULT 0                COMMENT '收藏数',
    status        TINYINT         DEFAULT 1                COMMENT '状态：1-发布 0-草稿',
    created_at    DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at    DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted       TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资讯/新闻表';

-- ============================================================
-- 22. 资讯点赞表 (news_like)
-- ============================================================
DROP TABLE IF EXISTS news_like;
CREATE TABLE news_like (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    user_id    BIGINT          NOT NULL                 COMMENT '用户ID',
    news_id    BIGINT          NOT NULL                 COMMENT '资讯ID',
    type       VARCHAR(16)     DEFAULT NULL             COMMENT '类型：like-点赞 favorite-收藏',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资讯点赞表';

-- ============================================================
-- 23. 数据手册表 (datasheet)
-- ============================================================
DROP TABLE IF EXISTS datasheet;
CREATE TABLE datasheet (
    id            BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    category_id   BIGINT          DEFAULT NULL             COMMENT '分类ID',
    sub_category  VARCHAR(64)     DEFAULT NULL             COMMENT '子分类',
    title         VARCHAR(255)    NOT NULL                 COMMENT '标题',
    pdf_url       VARCHAR(255)    DEFAULT NULL             COMMENT 'PDF文件URL',
    created_at    DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at    DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted       TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据手册表';

-- ============================================================
-- 24. 站内消息表 (message)
-- ============================================================
DROP TABLE IF EXISTS message;
CREATE TABLE message (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    user_id    BIGINT          NOT NULL                 COMMENT '用户ID',
    title      VARCHAR(255)    DEFAULT NULL             COMMENT '消息标题',
    content    TEXT            DEFAULT NULL             COMMENT '消息内容',
    is_read    TINYINT         DEFAULT 0                COMMENT '是否已读：1-已读 0-未读',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='站内消息表';

-- ============================================================
-- 25. 意见反馈表 (feedback)
-- ============================================================
DROP TABLE IF EXISTS feedback;
CREATE TABLE feedback (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    user_id    BIGINT          NOT NULL                 COMMENT '用户ID',
    type       VARCHAR(16)     DEFAULT NULL             COMMENT '反馈类型：建议/投诉',
    content    TEXT            DEFAULT NULL             COMMENT '反馈内容',
    reply      TEXT            DEFAULT NULL             COMMENT '管理员回复',
    status     TINYINT         DEFAULT 0                COMMENT '处理状态：0-待处理 1-已处理',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='意见反馈表';

-- ============================================================
-- 26. 合作伙伴申请表 (partner_apply)
-- ============================================================
DROP TABLE IF EXISTS partner_apply;
CREATE TABLE partner_apply (
    id           BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    user_id      BIGINT          DEFAULT NULL             COMMENT '用户ID',
    company_name VARCHAR(128)    DEFAULT NULL             COMMENT '公司名称',
    category     VARCHAR(64)     DEFAULT NULL             COMMENT '合作品类',
    contact      VARCHAR(64)     DEFAULT NULL             COMMENT '联系人',
    phone        VARCHAR(20)     DEFAULT NULL             COMMENT '联系电话',
    remark       VARCHAR(500)    DEFAULT NULL             COMMENT '备注',
    status       VARCHAR(16)     DEFAULT NULL             COMMENT '状态：待审核/已通过/已拒绝',
    created_at   DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at   DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted      TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='合作伙伴申请表';

-- ============================================================
-- 27. 合作品牌展示表 (cooperate_brand)
-- ============================================================
DROP TABLE IF EXISTS cooperate_brand;
CREATE TABLE cooperate_brand (
    id          BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    brand_name  VARCHAR(64)     NOT NULL                 COMMENT '品牌名称',
    logo        VARCHAR(255)    DEFAULT NULL             COMMENT '品牌Logo URL',
    description TEXT            DEFAULT NULL             COMMENT '品牌描述',
    sort        INT             DEFAULT 0                COMMENT '排序',
    status      TINYINT         DEFAULT 1                COMMENT '状态：1-显示 0-隐藏',
    created_at  DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at  DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted     TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='合作品牌展示表';

-- ============================================================
-- 28. 短信通知配置表 (sms_config)
-- ============================================================
DROP TABLE IF EXISTS sms_config;
CREATE TABLE sms_config (
    id         BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    type       VARCHAR(32)     NOT NULL                 COMMENT '通知类型',
    enabled    TINYINT         DEFAULT 0                COMMENT '是否启用：1-启用 0-禁用',
    phones     VARCHAR(255)    DEFAULT NULL             COMMENT '接收手机号(多个用逗号分隔)',
    created_at DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted    TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信通知配置表';

-- 初始短信配置数据（全部未启用）
INSERT INTO sms_config (type, enabled, phones, created_at, updated_at) VALUES
    ('inquiry_notify',  0, NULL, NOW(), NOW()),
    ('order_notify',    0, NULL, NOW(), NOW()),
    ('register_notify', 0, NULL, NOW(), NOW());

-- ============================================================
-- 29. 系统配置表 (sys_config)
-- ============================================================
DROP TABLE IF EXISTS sys_config;
CREATE TABLE sys_config (
    id          BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    config_key  VARCHAR(64)     NOT NULL                 COMMENT '配置键',
    config_value VARCHAR(255)   DEFAULT NULL             COMMENT '配置值',
    created_at  DATETIME        NOT NULL                 COMMENT '创建时间',
    updated_at  DATETIME        NOT NULL                 COMMENT '更新时间',
    deleted     TINYINT(1)      DEFAULT 0                COMMENT '逻辑删除标记',
    PRIMARY KEY (id),
    UNIQUE KEY uk_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 初始系统配置数据
INSERT INTO sys_config (config_key, config_value, created_at, updated_at) VALUES
    ('service_qq',      '4008888888',   NOW(), NOW()),
    ('service_wechat',  '/uploads/wechat_qr.png', NOW(), NOW()),
    ('service_phone',   '400-888-8888', NOW(), NOW());

-- ============================================================
-- 演示数据：电容产品 (5条)
-- 分类ID=1 (电容/电阻), 品牌ID=1 (三星)
-- ============================================================
INSERT INTO product (id, category_id, brand_id, part_no, name, description, stock, price, min_order, unit, status, created_at, updated_at) VALUES
    (1, 1, 1, 'C0805C104K5RAC',  '0805 100nF 50V X7R 多层陶瓷电容',  '0805封装 100nF 50V X7R 多层陶瓷电容，适用于电源去耦和滤波应用',     10000, 0.0850, 100, 'pcs', 1, NOW(), NOW()),
    (2, 1, 1, 'C0603C100J5GAC',  '0603 10pF 50V C0G 多层陶瓷电容',  '0603封装 10pF 50V C0G 多层陶瓷电容，高稳定性适用于高频电路',       8000,  0.1200, 100, 'pcs', 1, NOW(), NOW()),
    (3, 1, 2, 'GRM155R71H104KE14','0402 100nF 50V X7R 村田陶瓷电容', '村田 0402 100nF 50V X7R 陶瓷电容，小型化设计适用于便携设备',        12000, 0.0950, 100, 'pcs', 1, NOW(), NOW()),
    (4, 1, 2, 'GRM21BR61E106KA73','0805 10uF 25V X5R 村田陶瓷电容',  '村田 0805 10uF 25V X5R 陶瓷电容，大容量适用于电源平滑电路',        5000,  0.3200, 50,  'pcs', 1, NOW(), NOW()),
    (5, 1, 4, 'CC0805KKX7R9BB105','0805 1uF 50V X7R 国巨陶瓷电容',   '国巨 0805 1uF 50V X7R 多层陶瓷电容，通用型适用于各类电子设备',      6000,  0.1500, 100, 'pcs', 1, NOW(), NOW());

-- 电容属性数据
INSERT INTO capacitor_attr (product_id, capacitance, tolerance, voltage_rating, package, material, temperature_range) VALUES
    (1, '100nF',  '10%',   '50V',  '0805', 'X7R', '-55°C ~ +125°C'),
    (2, '10pF',   '5%',    '50V',  '0603', 'C0G', '-55°C ~ +125°C'),
    (3, '100nF',  '10%',   '50V',  '0402', 'X7R', '-55°C ~ +125°C'),
    (4, '10uF',   '10%',   '25V',  '0805', 'X5R', '-55°C ~ +85°C'),
    (5, '1uF',    '10%',   '50V',  '0805', 'X7R', '-55°C ~ +125°C');