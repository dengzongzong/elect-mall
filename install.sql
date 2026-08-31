-- ============================================================
-- 电子元器件商城 (mall_db) 完整数据库安装脚本
-- 包含：建库、建表、初始数据、示例数据
-- 使用：mysql -u root -p < install.sql
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `mall_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `mall_db`;

-- ============================================================
-- 表结构
-- ============================================================

-- 管理员用户表
CREATE TABLE IF NOT EXISTS `admin_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码(bcrypt加密)',
  `nickname` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '昵称',
  `role` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT 'ADMIN' COMMENT '角色：ADMIN-管理员',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-正常 0-禁用',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员用户表';

-- 属性字段定义表
CREATE TABLE IF NOT EXISTS `attr_field_def` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字段ID',
  `category_id` bigint NOT NULL COMMENT '所属分类ID',
  `field_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段名(英文)',
  `field_label` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段标签(中文)',
  `field_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'string' COMMENT '字段类型：string/number/select',
  `options` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '选项值(select类型时用逗号分隔)',
  `is_search` tinyint DEFAULT '0' COMMENT '是否可搜索：1-是 0-否',
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='属性字段定义表';

-- BOM清单明细表
CREATE TABLE IF NOT EXISTS `bom_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `bom_id` bigint NOT NULL COMMENT 'BOM记录ID',
  `part_no` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '产品型号',
  `quantity` int DEFAULT NULL COMMENT '数量',
  `match_status` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '匹配状态',
  `product_id` bigint DEFAULT NULL COMMENT '匹配产品ID',
  `price` decimal(12,4) DEFAULT NULL COMMENT '单价',
  `subtotal` decimal(12,4) DEFAULT NULL COMMENT '小计金额',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BOM清单明细表';

-- BOM清单记录表
CREATE TABLE IF NOT EXISTS `bom_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `match_count` int DEFAULT '0' COMMENT '匹配数量',
  `total_count` int DEFAULT '0' COMMENT '总物料数',
  `total_amount` decimal(12,2) DEFAULT NULL COMMENT '总金额',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BOM清单记录表';

-- 品牌表
CREATE TABLE IF NOT EXISTS `brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '品牌ID',
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '品牌名称',
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '品牌Logo URL',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '品牌描述',
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-启用 0-禁用',
  `is_cooperate` tinyint DEFAULT '0' COMMENT '是否合作品牌：1-是 0-否',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='品牌表';

-- 电容属性表
CREATE TABLE IF NOT EXISTS `capacitor_attr` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `capacitance` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电容值',
  `tolerance` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '容差',
  `voltage_rating` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '额定电压',
  `package` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封装',
  `material` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '材质',
  `temperature_range` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '温度范围',
  PRIMARY KEY (`id`),
  KEY `idx_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='电容属性表';

-- 购物车表
CREATE TABLE IF NOT EXISTS `cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `quantity` int DEFAULT '1' COMMENT '数量',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车表';

-- 分类表 (含 description 富文本字段)
CREATE TABLE IF NOT EXISTS `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint DEFAULT NULL COMMENT '父分类ID',
  `attr_table` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '属性表名',
  `prefix` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '编号前缀',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '分类详情(富文本)',
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

-- 合作品牌展示表
CREATE TABLE IF NOT EXISTS `cooperate_brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `brand_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '品牌名称',
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '品牌Logo URL',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '品牌描述',
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-显示 0-隐藏',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  `show_image` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '展示大图',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='合作品牌展示表';

-- 数据手册表
CREATE TABLE IF NOT EXISTS `datasheet` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  `sub_category` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '子分类',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `pdf_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'PDF文件URL',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据手册表';

-- 收藏表
CREATE TABLE IF NOT EXISTS `favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收藏表';

-- 意见反馈表
CREATE TABLE IF NOT EXISTS `feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `type` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '反馈类型：建议/投诉',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '反馈标题',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '反馈内容',
  `contact` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系方式',
  `reply` text COLLATE utf8mb4_unicode_ci COMMENT '管理员回复',
  `status` tinyint DEFAULT '0' COMMENT '处理状态：0-待处理 1-已处理',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='意见反馈表';

-- 滤波器属性表
CREATE TABLE IF NOT EXISTS `filter_attr` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `type` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '滤波器类型',
  `frequency` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '频率',
  `insertion_loss` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '插入损耗',
  `package` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封装',
  `operating_temp` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '工作温度',
  PRIMARY KEY (`id`),
  KEY `idx_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='滤波器属性表';

-- 电感属性表
CREATE TABLE IF NOT EXISTS `inductor_attr` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `inductance` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电感值',
  `rated_current` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '额定电流',
  `dc_resistance` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '直流电阻',
  `package` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封装',
  `type` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`id`),
  KEY `idx_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='电感属性表';

-- 询价单表
CREATE TABLE IF NOT EXISTS `inquiry` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `inquiry_no` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '询价单编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `contact` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_inquiry_no` (`inquiry_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='询价单表';

-- 询价单明细表
CREATE TABLE IF NOT EXISTS `inquiry_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `inquiry_id` bigint NOT NULL COMMENT '询价单ID',
  `product_id` bigint DEFAULT NULL COMMENT '产品ID',
  `part_no` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '产品型号',
  `quantity` int DEFAULT NULL COMMENT '数量',
  `target_price` decimal(12,4) DEFAULT NULL COMMENT '目标单价',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='询价单明细表';

-- 站内消息表
CREATE TABLE IF NOT EXISTS `message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '消息标题',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '消息内容',
  `is_read` tinyint DEFAULT '0' COMMENT '是否已读：1-已读 0-未读',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='站内消息表';

-- 资讯/新闻表
CREATE TABLE IF NOT EXISTS `news` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图片URL',
  `like_count` int DEFAULT '0' COMMENT '点赞数',
  `favorite_count` int DEFAULT '0' COMMENT '收藏数',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-发布 0-草稿',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资讯/新闻表';

-- 资讯点赞表
CREATE TABLE IF NOT EXISTS `news_like` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `news_id` bigint NOT NULL COMMENT '资讯ID',
  `type` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '类型：like-点赞 favorite-收藏',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资讯点赞表';

-- 订单表
CREATE TABLE IF NOT EXISTS `order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `total_amount` decimal(12,2) DEFAULT NULL COMMENT '订单总金额',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单状态：待审核/待付款/待发货/待收货/已完成/已取消',
  `payment_method` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '支付方式',
  `transfer_voucher` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '转账凭证URL',
  `receiver_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收货人电话',
  `receiver_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收货地址',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单备注',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- 订单明细表
CREATE TABLE IF NOT EXISTS `order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `product_id` bigint DEFAULT NULL COMMENT '产品ID',
  `part_no` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '产品型号',
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '产品名称',
  `quantity` int DEFAULT NULL COMMENT '数量',
  `price` decimal(12,4) DEFAULT NULL COMMENT '单价',
  `subtotal` decimal(12,4) DEFAULT NULL COMMENT '小计金额',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单明细表';

-- 合作伙伴申请表
CREATE TABLE IF NOT EXISTS `partner_apply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `company_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '公司名称',
  `category` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '合作品类',
  `contact` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态：待审核/已通过/已拒绝',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='合作伙伴申请表';

-- 支付记录表
CREATE TABLE IF NOT EXISTS `pay_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pay_no` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '支付编号',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `order_no` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单编号',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '支付金额',
  `method` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '支付方式',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '支付状态',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pay_no` (`pay_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付记录表';

-- 产品表
CREATE TABLE IF NOT EXISTS `product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '产品ID',
  `category_id` bigint DEFAULT NULL,
  `brand_id` bigint DEFAULT NULL COMMENT '品牌ID',
  `part_no` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '产品型号/料号',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '产品名称',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '产品描述',
  `stock` int DEFAULT '0' COMMENT '库存数量',
  `price` decimal(12,4) DEFAULT NULL COMMENT '单价',
  `tier_prices` longtext DEFAULT NULL COMMENT '阶梯价 JSON：[{"min_qty":100,"price":0.0387}]',
  `min_order` int DEFAULT '1' COMMENT '最小起订量',
  `weight` decimal(10,4) DEFAULT NULL COMMENT '重量(kg)',
  `specs` longtext DEFAULT NULL COMMENT '规格参数 JSON（封装、功率、偏差、电阻、电压等）',
  `unit` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `datasheet_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '数据手册URL',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '产品图片URL',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-上架 0-下架',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_part_no` (`part_no`),
  KEY `idx_category` (`category_id`),
  KEY `idx_part_no` (`part_no`),
  KEY `idx_brand` (`brand_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品表';

-- 短信通知配置表
CREATE TABLE IF NOT EXISTS `sms_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知类型',
  `enabled` tinyint DEFAULT '0' COMMENT '是否启用：1-启用 0-禁用',
  `phones` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '接收手机号(多个用逗号分隔)',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信通知配置表';

-- 系统配置表
CREATE TABLE IF NOT EXISTS `sys_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `config_key` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `config_value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '配置值',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 首页轮播图表
CREATE TABLE IF NOT EXISTS `carousel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `image_url` varchar(500) NOT NULL COMMENT '图片URL',
  `link` varchar(500) NOT NULL COMMENT '跳转链接',
  `color` varchar(64) DEFAULT NULL COMMENT '背景渐变',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='首页轮播图';

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `openid` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微信openid',
  `nickname` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '昵称',
  `email` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像URL',
  `balance` decimal(12,2) DEFAULT '0.00' COMMENT '账户余额',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-正常 0-禁用',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 用户常用型号表
CREATE TABLE IF NOT EXISTS `user_part_no` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `part_no` varchar(100) NOT NULL COMMENT '物料号',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户常用型号表';

-- 首页区块配置表
CREATE TABLE IF NOT EXISTS `home_block` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `block_key` varchar(32) NOT NULL COMMENT '区块：side_ad侧边广告 / feature卖点',
  `title` varchar(100) DEFAULT NULL COMMENT '标题',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `tag` varchar(32) DEFAULT NULL COMMENT '角标',
  `tag_bg` varchar(32) DEFAULT NULL COMMENT '角标颜色',
  `link` varchar(255) DEFAULT NULL COMMENT '跳转链接',
  `bg` varchar(255) DEFAULT NULL COMMENT '背景渐变',
  `icon` varchar(32) DEFAULT NULL COMMENT '图标名',
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_block` (`block_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='首页区块配置';

-- 用户地址表
CREATE TABLE IF NOT EXISTS `user_address` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收货人姓名',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '收货人电话',
  `province` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '省份',
  `city` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '城市',
  `district` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '区县',
  `detail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '详细地址',
  `is_default` tinyint DEFAULT '0' COMMENT '是否默认地址：1-是 0-否',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户地址表';

-- 用户余额变动记录表
CREATE TABLE IF NOT EXISTS `user_balance_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `amount` decimal(12,2) DEFAULT NULL COMMENT '变动金额(正数收入/负数支出)',
  `type` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '变动类型',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户余额变动记录表';


-- ============================================================
-- 初始数据
-- ============================================================

-- 默认管理员账号 (密码: admin123)
INSERT INTO `admin_user` (`id`, `username`, `password`, `nickname`, `role`, `status`, `created_at`, `updated_at`, `deleted`)
VALUES (1, 'admin', '$2a$10$BpP5PtYCa0oRji6.lNeSoeHNYrs4xrAcuM4zM2.7xxP1WvM3bZqYe', '系统管理员', 'ADMIN', 1, NOW(), NOW(), 0);

-- 系统配置
INSERT INTO `sys_config` (`id`, `config_key`, `config_value`, `created_at`, `updated_at`, `deleted`)
VALUES (1, 'site_name', '时运商城', NOW(), NOW(), 0);
INSERT INTO `sys_config` (`id`, `config_key`, `config_value`, `created_at`, `updated_at`, `deleted`)
VALUES (2, 'site_keywords', '电子元器件,商城', NOW(), NOW(), 0);
INSERT INTO `sys_config` (`id`, `config_key`, `config_value`, `created_at`, `updated_at`, `deleted`)
VALUES (3, 'site_description', '电子元器件一站式采购平台', NOW(), NOW(), 0);

-- 短信通知配置
INSERT INTO `sms_config` (`id`, `type`, `enabled`, `phones`, `created_at`, `updated_at`, `deleted`)
VALUES (1, 'order', 0, '', NOW(), NOW(), 0);
INSERT INTO `sms_config` (`id`, `type`, `enabled`, `phones`, `created_at`, `updated_at`, `deleted`)
VALUES (2, 'inquiry', 0, '', NOW(), NOW(), 0);
INSERT INTO `sms_config` (`id`, `type`, `enabled`, `phones`, `created_at`, `updated_at`, `deleted`)
VALUES (3, 'feedback', 0, '', NOW(), NOW(), 0);

-- ============================================================
-- 分类数据 (3个一级分类，每个含子分类)
-- ============================================================
INSERT INTO `category` (`id`, `name`, `parent_id`, `attr_table`, `prefix`, `description`, `sort`, `status`, `created_at`, `updated_at`)
VALUES
    (1, '电容/电阻', NULL, 'capacitor_attr', 'CR', NULL, 1, 1, NOW(), NOW()),
    (2, '电感/变压器/磁性元件', NULL, 'inductor_attr', 'LM', NULL, 2, 1, NOW(), NOW()),
    (3, '滤波器/晶振', NULL, 'filter_attr', 'FC', NULL, 3, 1, NOW(), NOW());

-- ============================================================
-- 品牌数据 (35个品牌)
-- ============================================================
INSERT INTO `brand` (`id`, `name`, `logo`, `description`, `sort`, `status`, `is_cooperate`, `created_at`, `updated_at`) VALUES
(1, 'TDK', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/tdk-logo.png', 'TDK株式会社，全球领先的电子元器件制造商，产品涵盖电感、电容、磁珠、传感器等', 1, 1, 1, NOW(), NOW()),
(2, '国巨 (YAGEO)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/yageo-logo.png?v=0219', '国巨集团，全球最大的被动元件制造商之一，主要产品包括电阻、电容、电感等', 2, 1, 1, NOW(), NOW()),
(3, '基美 (KEMET)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/kemet-logo.png', '基美公司，全球领先的电容制造商，产品涵盖钽电容、陶瓷电容、薄膜电容等', 3, 1, 1, NOW(), NOW()),
(4, '威世 (VISHAY)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/vishay-logo.png', '威世科技，全球最大的分立半导体和被动元件制造商之一', 4, 1, 1, NOW(), NOW()),
(5, '京瓷 (Kyocera)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/kyocera-logo.png', '京瓷株式会社，全球领先的电子元器件和陶瓷制造商', 5, 1, 1, NOW(), NOW()),
(6, '松下 (Panasonic)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/panasonic-logo.png', '松下电器，全球知名电子制造商，产品涵盖电容、电阻、继电器、连接器等', 6, 1, 1, NOW(), NOW()),
(7, '罗姆 (ROHM)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/rohm-logo.png', '罗姆半导体，全球知名的半导体厂商，产品涵盖IC、分立器件、LED、传感器等', 7, 1, 1, NOW(), NOW()),
(8, '泰科 (TE Connectivity)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/te-logo.png?0124', '泰科电子，全球最大的连接器制造商之一，产品涵盖连接器、传感器、继电器等', 8, 1, 1, NOW(), NOW()),
(9, '太阳诱电 (TAIYO YUDEN)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/taiyo-logo.png', '太阳诱电株式会社，全球领先的被动元件制造商，产品涵盖电容、电感、铁氧体等', 9, 1, 1, NOW(), NOW()),
(10, 'NDK', 'https://uploadcdn.oneyac.com/attachments/page/brand/detail/ndk/logo.jpg', '日本电波工业株式会社，全球领先的石英晶体谐振器制造商', 10, 1, 1, NOW(), NOW()),
(11, '万国半导体 (AOS)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/aos-logo.png', '万国半导体，全球领先的功率半导体供应商，产品涵盖MOSFET、IGBT、电源IC等', 11, 1, 1, NOW(), NOW()),
(12, '安世 (Nexperia)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/nexperia-logo.png', '安世半导体，全球领先的分立器件、逻辑器件和MOSFET制造商', 12, 1, 1, NOW(), NOW()),
(13, 'JST', 'https://uploadcdn.oneyac.com/upload/brand/1766480551070_9375.png', '日本压着端子制造株式会社，全球领先的连接器制造商', 13, 1, 1, NOW(), NOW()),
(14, '特瑞仕 (TOREX)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/torex-logo.png', '特瑞仕半导体，专注于电源管理IC和模拟半导体的日本厂商', 14, 1, 1, NOW(), NOW()),
(15, '丽智 (LIZ)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/liz-logo.png', '丽智电子，专业的被动元件制造商，产品涵盖电阻、陶瓷电容等', 15, 1, 1, NOW(), NOW()),
(16, '台庆 (TAI-TECH)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/taitech-logo.png', '台庆科技，专业的电感器和被动元件制造商', 16, 1, 1, NOW(), NOW()),
(17, '乐山无线电 (LRC)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/lrc-logo.png', '乐山无线电股份有限公司，专业的半导体分立器件制造商', 17, 1, 1, NOW(), NOW()),
(18, '大毅', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/dayi-logo.png', '大毅科技，全球领先的芯片电阻制造商', 18, 1, 1, NOW(), NOW()),
(19, '旺诠 (RALEC)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/ralec-logo.png', '旺诠科技，专业的芯片电阻和排阻制造商', 19, 1, 1, NOW(), NOW()),
(20, '强茂 (PANJIT)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/panjit-logo.png', '强茂股份有限公司，专业的半导体整流器件制造商', 20, 1, 1, NOW(), NOW()),
(21, '奇力新 (CHILISIN)', 'https://uploadcdn.oneyac.com/upload/brand/1575355420527_9936.png', '奇力新电子，全球领先的电感器和磁性元件制造商', 21, 1, 1, NOW(), NOW()),
(22, '三星电机 (SEMCO)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/semco-logo.png', '三星电机，全球领先的电子元器件制造商，产品涵盖MLCC、电感、模块等', 22, 1, 1, NOW(), NOW()),
(23, '华新科技', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/walsin-logo.png', '华新科技股份有限公司，专业的被动元件制造商，产品涵盖电阻、电容、电感等', 23, 1, 1, NOW(), NOW()),
(24, '进工业 (SUSUMU)', 'https://uploadcdn.oneyac.com/upload/brand/1543368184948_9008.jpg', '进工业株式会社，全球领先的高精度电阻制造商', 24, 1, 1, NOW(), NOW()),
(25, '捷捷微电子', 'https://uploadcdn.oneyac.com/upload/brand/1562298366871_3486.jpg', '捷捷微电子，专业的功率半导体器件制造商', 25, 1, 1, NOW(), NOW()),
(26, '村田 (Murata)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/murata-logo.png', '村田制作所，全球最大的陶瓷电容制造商，产品涵盖电容、电感、滤波器、传感器等', 26, 1, 1, NOW(), NOW()),
(27, '加高 (H.ELE.)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/hele-logo.png', '加高电子，专业的石英晶体谐振器和振荡器制造商', 27, 1, 1, NOW(), NOW()),
(28, '大真空 (KDS)', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/kds-logo.png', '大真空株式会社，全球领先的石英晶体器件制造商', 28, 1, 1, NOW(), NOW()),
(29, '君耀电子', 'https://uploadcdn.oneyac.com/attachments/page/brand/logos/brightking-logo.png', '君耀电子，专业的电路保护元件制造商，产品涵盖TVS、ESD、MOV等', 29, 1, 1, NOW(), NOW()),
(30, '科山芯创', 'https://uploadcdn.oneyac.com/upload/brand/1677136300252_2159.png', '科山芯创，专业的模拟集成电路设计公司', 30, 1, 1, NOW(), NOW()),
(31, '科达嘉', 'https://uploadcdn.oneyac.com/upload/brand/1608109458372_1524.jpg', '科达嘉电子，专业的电感器制造商', 31, 1, 1, NOW(), NOW()),
(32, '天二科技', 'https://uploadcdn.oneyac.com/upload/brand/1577775583524_8697.png', '天二科技，专业的芯片电阻和被动元件制造商', 32, 1, 1, NOW(), NOW()),
(33, '赛卓电子', 'https://uploadcdn.oneyac.com/upload/brand/1644371136697_4166.png', '赛卓电子，专业的传感器芯片和解决方案提供商', 33, 1, 1, NOW(), NOW()),
(34, '友台半导体', 'https://uploadcdn.oneyac.com/upload/brand/1640745897025_3069.jpg', '友台半导体，专业的电源管理IC和模拟器件制造商', 34, 1, 1, NOW(), NOW()),
(35, '杰发科技', 'https://uploadcdn.oneyac.com/upload/brand/1695630616770_7369.png', '杰发科技，专业的汽车电子芯片和解决方案提供商', 35, 1, 1, NOW(), NOW());

-- ============================================================
-- 产品数据 (5个示例产品)
-- ============================================================
INSERT INTO `product` (`id`, `category_id`, `brand_id`, `part_no`, `name`, `description`, `stock`, `price`, `min_order`, `unit`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 26, 'GRM155R71H104KE14D', '村田 100nF ±10% 50V X7R 0402 MLCC', '村田制作所 GRM系列多层陶瓷电容，0402封装，100nF，±10%，50V，X7R介质', 5000, 0.0350, 100, 'pcs', 1, NOW(), NOW()),
(2, 1, 26, 'GRM188R60J106KE47D', '村田 10uF ±10% 6.3V X5R 0603 MLCC', '村田制作所 GRM系列多层陶瓷电容，0603封装，10uF，±10%，6.3V，X5R介质', 3000, 0.1200, 50, 'pcs', 1, NOW(), NOW()),
(3, 1, 2, 'CC0402KRX7R9BB104', '国巨 100nF ±10% 50V X7R 0402 MLCC', '国巨 CC系列多层陶瓷电容，0402封装，100nF，±10%，50V，X7R介质', 8000, 0.0280, 100, 'pcs', 1, NOW(), NOW()),
(4, 1, 1, 'C1608X5R1A106M080AC', 'TDK 10uF ±20% 10V X5R 0603 MLCC', 'TDK C系列多层陶瓷电容，0603封装，10uF，±20%，10V，X5R介质', 4000, 0.0980, 50, 'pcs', 1, NOW(), NOW()),
(5, 1, 6, 'EEE1CA101WP', '松下 100uF 16V 铝电解电容 SMD', '松下EEE系列铝电解电容，SMD封装，100uF，16V，105°C，3000小时寿命', 2000, 0.3500, 20, 'pcs', 1, NOW(), NOW());

-- 电容属性
INSERT INTO `capacitor_attr` (`product_id`, `capacitance`, `tolerance`, `voltage_rating`, `package`, `material`, `temperature_range`) VALUES
(1, '100nF', '±10%', '50V', '0402', 'X7R', '-55°C ~ +125°C'),
(2, '10uF', '±10%', '6.3V', '0603', 'X5R', '-55°C ~ +85°C'),
(3, '100nF', '±10%', '50V', '0402', 'X7R', '-55°C ~ +125°C'),
(4, '10uF', '±20%', '10V', '0603', 'X5R', '-55°C ~ +85°C'),
(5, '100uF', '±20%', '16V', 'SMD', '铝电解', '-40°C ~ +105°C');

-- ============================================================
-- 合作品牌（授权分销商）数据
-- ============================================================
INSERT INTO `cooperate_brand` (`id`, `brand_name`, `logo`, `show_image`, `description`, `sort`, `status`, `created_at`, `updated_at`) VALUES
(1, '厦门信和达电子有限公司',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-logo-1.jpg',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-show-1.jpg',
 '厦门信和达电子有限公司成立于2000年，专业从事电子元器件代理销售业务，已先后取得TDK、YAGEO、Panasonic、KEMET、Chilisin、TAI-TECH、KDS、H.ELE、TOREX、LRC、PTTC、ATO、ISND等公司的销售代理权。\n\n应用领域：手机、液晶电视、智能穿戴、无人机、新能源汽车、新能源逆变等行业',
 1, 1, NOW(), NOW()),
(2, '富昌电子（Future Electronics）',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-logo-2.jpg',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-show-2.jpg',
 '富昌电子成立于1968年，是全球领先的电子元器件分销商，业务遍布全球40多个国家，为客户提供优质的服务，开发高效、完善的全球供应链解决方案。\n\n应用领域：充电桩、电源驱动、BMS、电源、手表、医疗设备、汽车电子、LED照明、工业电子设备等行业',
 2, 1, NOW(), NOW()),
(3, 'TME（Transfer Multisort Elektronik）',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-logo-3.png',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-show-3.jpg',
 'TME是电子元器件、电器元件、车间设备及工业自动化产品全球最大的分销商之一，在波兰总部和其他国家的子公司现有员工近800人，为140个国家的数万企业服务。\n\n应用领域：电子元器件、电器元件、车间设备、工业自动化产品',
 3, 1, NOW(), NOW());

-- ============================================================
-- 新闻资讯数据 (10条)
-- ============================================================
INSERT INTO `news` (`id`, `title`, `content`, `image`, `like_count`, `favorite_count`, `status`, `created_at`, `updated_at`) VALUES
(1, 'CBW系列叠层片式铁氧体大电流磁珠',
'风华高科（FH）旗下CBW系列叠层片式铁氧体大电流磁珠产品，专为满足通信设备、计算机、液晶电视等电气设备的电源线及大电流信号线噪声抑制需求而设计。该系列产品覆盖从0603~4532等多种公制尺寸（对应英制0201~1812），阻抗范围横跨0~3000Ω，额定电流最高可达6.0A。\n\n**产品特性：**\n- **高阻抗、低DCR：** 宽频有效抑制EMI/RFI，直流电阻最低仅0.02Ω，显著降低功耗。\n- **超大电流承载：** 最大额定电流6.0A，满足电源线及大电流信号线的高功率噪声抑制需求。\n- **片式无引线结构：** 符合EIA标准，支持SMT自动贴装，兼容回流焊和波峰焊，简化生产。\n- **高可靠性：** 工作温度-55~125℃，耐温、耐湿、抗振动，阻抗变化率＜±30%，确保恶劣环境稳定运行。\n\n**产品应用：** 广泛应用于通信设备、计算机、液晶电视、笔记本电脑、硬盘驱动器、打印机、游戏机、数码相机及汽车电子等设备的电源滤波和干扰抑制场景。',
'https://uploadcdn.oneyac.com/attachments/2024/06/20/1718870880880_8321.jpg', 12, 5, 1, '2026-08-21 15:00:00', NOW()),

(2, 'CCTC 车规级多层片式陶瓷电容器(MLCC)',
'潮州三环（集团）股份有限公司（CCTC）成立于1970年，是国内领先的电子陶瓷元件制造商。针对新能源汽车及汽车电子市场的快速增长，三环集团推出了覆盖0201至2220全尺寸规格的车规级MLCC系列产品，电容值范围0.1pF～47uF。该系列产品已通过AEC-Q200车规认证及IATF 16949质量管理体系认证。\n\n**产品特性：**\n- **AEC-Q200车规认证：** 全系列产品严格遵循AEC-Q200被动元件车规认证标准，通过1000小时高温高湿负载测试。\n- **宽温域稳定工作：** 支持COG（-55℃～125℃）、X7R/X7S/X7T（-55℃～125℃）等多介质类型。\n- **高抗机械强度：** 抗弯强度达200兆帕以上，端电极结合强度测试中可承受17.7N推力。\n- **小型化与高容化突破：** 介质层厚度已突破1微米，堆叠层数超1000层，体积较传统产品缩小50%。\n\n**产品应用：** 新能源汽车电源系统、电机驱动系统、信息娱乐与智能座舱、动力电池管理系统（BMS）、智能驾驶与ADAS、车身控制模块。',
'https://uploadcdn.oneyac.com/attachments/2024/06/12/1718165440888_8521.png', 25, 8, 1, '2026-08-15 11:00:00', NOW()),

(3, '风华高科RH系列抗硫化厚膜片式固定电阻器',
'专为高污染、恶劣环境设计，能够有效解决因硫化腐蚀导致的电阻失效问题。风华高科RH系列抗硫化厚膜片式固定电阻器采用先进的抗硫化工艺，在含硫气体环境中仍能保持稳定的电阻值和工作性能。\n\n**产品特性：**\n- 优异的抗硫化性能，适用于恶劣环境\n- 厚膜结构，可靠性高\n- 宽阻值范围，满足多种应用需求\n- 符合RoHS标准，环保无铅\n\n**产品应用：** 工业控制、汽车电子、通信设备、电力系统等对可靠性要求高的场景。',
'https://uploadcdn.oneyac.com/attachments/2024/06/05/1717567575300_4955.jpg', 38, 12, 1, '2026-08-07 10:00:00', NOW()),

(4, '安森美(onsemi) CAT24C256 高可靠性I2C串行EEPROM',
'256 Kb串行CMOS EEPROM，高可靠性、宽电压、高速I2C。安森美CAT24C256是一款256 Kb串行CMOS EEPROM，内部组织为32768 x 8位，支持I2C总线接口，工作电压范围1.7V至5.5V。\n\n**产品特性：**\n- 256 Kb存储容量，32768 x 8位组织\n- I2C总线接口，高速传输\n- 宽工作电压范围：1.7V至5.5V\n- 低功耗设计，待机电流极低\n- 高可靠性，擦写次数达100万次\n\n**产品应用：** 物联网设备、工业控制、汽车电子、消费电子等需要非易失性存储的场景。',
'https://uploadcdn.oneyac.com/attachments/2024/05/28/1716883675000_8545.jpg', 45, 15, 1, '2026-08-01 09:00:00', NOW()),

(5, 'TDK YFF-P系列3端子馈通电容（馈通滤波器）',
'面向电源线应用的高性能紧凑型EMC元件。TDK YFF-P系列3端子馈通电容（馈通滤波器）专为电源线应用设计，提供高性能EMC滤波解决方案。\n\n**产品特性：**\n- 紧凑型设计，节省PCB空间\n- 高插入损耗，优异的EMI抑制性能\n- 宽频率范围内保持稳定性能\n- 适合SMT自动贴装\n\n**产品应用：** 电源线滤波、EMI抑制、消费电子、通信设备、工业电子等。',
'https://uploadcdn.oneyac.com/attachments/2024/05/20/1716189075000_1935.jpg', 30, 10, 1, '2026-07-24 14:00:00', NOW()),

(6, '新洁能NCE 12V~200V N沟道沟槽型功率MOSFET',
'采用先进工艺与精细化器件结构设计，系列覆盖12V至200V全电压等级。新洁能NCE系列N沟道沟槽型功率MOSFET采用先进的沟槽工艺技术，实现低导通电阻和快速开关性能。\n\n**产品特性：**\n- 电压范围：12V~200V，覆盖全电压等级\n- 低导通电阻，降低导通损耗\n- 快速开关性能，提升系统效率\n- 先进的沟槽工艺，可靠性高\n- 多种封装形式可选\n\n**产品应用：** 电源管理、DC-DC转换器、电池保护、电机驱动、LED照明等。',
'https://uploadcdn.oneyac.com/attachments/2024/05/12/1715490255000_5175.jpg', 18, 6, 1, '2026-07-18 11:00:00', NOW()),

(7, 'Uni-Ohm(厚声) 厚膜贴片电阻',
'阻值范围涵盖0.01Ω～10MΩ，兼具小型化、轻量化和高可靠性。Uni-Ohm(厚声)厚膜贴片电阻系列产品覆盖广泛阻值范围，满足各类电子产品的设计需求。\n\n**产品特性：**\n- 阻值范围：0.01Ω～10MΩ\n- 小型化设计，节省PCB空间\n- 高可靠性，长期稳定性好\n- 多种封装尺寸可选（0201~2512）\n- 功率范围广泛\n\n**产品应用：** 消费电子、通信设备、工业控制、汽车电子、电源管理等。',
'https://uploadcdn.oneyac.com/attachments/2024/05/05/1714885475000_9457.jpg', 22, 7, 1, '2026-07-10 10:00:00', NOW()),

(8, 'JST PUD系列2.0mm双排压接式线对板连接器',
'2.0mm间距线对板连接器，兼具高可靠性与优异操作性的可断开式连接器。JST PUD系列连接器采用2.0mm间距双排设计，提供可靠的电气连接和机械锁定。\n\n**产品特性：**\n- 2.0mm双排间距设计\n- 压接式连接，可靠性高\n- 机械锁定结构，防止意外脱落\n- 支持自动贴装，提高生产效率\n- 多种引脚数可选\n\n**产品应用：** 家用电器、办公设备、工业设备、汽车电子等需要可靠线对板连接的场景。',
'https://uploadcdn.oneyac.com/attachments/2024/04/25/1714025775000_6935.jpg', 15, 4, 1, '2026-07-03 09:00:00', NOW()),

(9, 'TAIYO YUDEN 车规级多层陶瓷电容 (MLCC)',
'车规级软端子MLCC，符合AEC-Q200标准，低ESR，高抗弯曲能力。TAIYO YUDEN(太阳诱电)车规级MLCC系列产品专为汽车电子应用设计，提供卓越的可靠性和性能。\n\n**产品特性：**\n- AEC-Q200车规认证\n- 软端子设计，高抗弯曲能力\n- 低ESR，降低功率损耗\n- 宽温域工作范围\n- 高可靠性，长寿命设计\n\n**产品应用：** 汽车电子、ADAS系统、车载信息娱乐系统、动力系统等。',
'https://uploadcdn.oneyac.com/attachments/2024/04/15/1713153075000_6146.jpg', 28, 9, 1, '2026-06-23 14:00:00', NOW()),

(10, 'KYOCERA AVX CM系列多层陶瓷电容 (MLCC)',
'CM系列通用MLCC陶瓷贴片电容，电容范围广，多尺寸、电介质可选。KYOCERA AVX(京瓷)CM系列MLCC提供广泛的产品选择，满足各类电子设计需求。\n\n**产品特性：**\n- 电容范围广，多种容值可选\n- 多尺寸封装（0201~2220）\n- 多电介质类型（COG、X7R、X5R等）\n- 高可靠性，长期稳定性好\n- 无铅，符合RoHS标准\n\n**产品应用：** 消费电子、通信设备、工业控制、汽车电子、医疗电子等通用应用场景。',
'https://uploadcdn.oneyac.com/attachments/2024/04/08/1712548800000_1234.jpg', 20, 6, 1, '2026-06-17 10:00:00', NOW());