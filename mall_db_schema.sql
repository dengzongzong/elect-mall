-- 时运商城 (mall_db) 完整建表语句
-- 生成时间: 2026-08-27 13:18:26

CREATE DATABASE IF NOT EXISTS mall_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mall_db;

CREATE TABLE `admin_user` (
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

CREATE TABLE `attr_field_def` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2092873144717275139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='属性字段定义表';

CREATE TABLE `bom_item` (
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

CREATE TABLE `bom_record` (
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

CREATE TABLE `brand` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2092951225985282061 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='品牌表';

CREATE TABLE `capacitor_attr` (
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='电容属性表';

CREATE TABLE `cart` (
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

CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint DEFAULT NULL COMMENT '父分类ID',
  `attr_table` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '属性表名',
  `prefix` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '编号前缀',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '分类详情(富文本)' AFTER `prefix`,
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2092951330683498509 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

CREATE TABLE `cooperate_brand` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2092876522306383875 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='合作品牌展示表';

CREATE TABLE `datasheet` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  `sub_category` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '子分类',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `pdf_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'PDF文件URL',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2092873151226834947 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据手册表';

CREATE TABLE `favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收藏表';

CREATE TABLE `feedback` (
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

CREATE TABLE `filter_attr` (
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

CREATE TABLE `inductor_attr` (
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

CREATE TABLE `inquiry` (
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

CREATE TABLE `inquiry_item` (
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

CREATE TABLE `message` (
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

CREATE TABLE `news` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2092951474728480777 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资讯/新闻表';

CREATE TABLE `news_like` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `news_id` bigint NOT NULL COMMENT '资讯ID',
  `type` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '类型：like-点赞 favorite-收藏',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资讯点赞表';

CREATE TABLE `order` (
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

CREATE TABLE `order_item` (
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

CREATE TABLE `partner_apply` (
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

CREATE TABLE `pay_record` (
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

CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '产品ID',
  `category_id` bigint DEFAULT NULL,
  `brand_id` bigint DEFAULT NULL COMMENT '品牌ID',
  `part_no` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '产品型号/料号',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '产品名称',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '产品描述',
  `stock` int DEFAULT '0' COMMENT '库存数量',
  `price` decimal(12,4) DEFAULT NULL COMMENT '单价',
  `min_order` int DEFAULT '1' COMMENT '最小起订量',
  `weight` decimal(10,4) DEFAULT NULL COMMENT '重量(kg)',
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
) ENGINE=InnoDB AUTO_INCREMENT=2092951570329251850 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品表';

CREATE TABLE `sms_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知类型',
  `enabled` tinyint DEFAULT '0' COMMENT '是否启用：1-启用 0-禁用',
  `phones` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '接收手机号(多个用逗号分隔)',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='短信通知配置表';

CREATE TABLE `sys_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `config_key` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `config_value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '配置值',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

CREATE TABLE `user` (
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

CREATE TABLE `user_part_no` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `part_no` varchar(100) NOT NULL COMMENT '物料号',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户常用型号表';

CREATE TABLE `user_address` (
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

CREATE TABLE `user_balance_log` (
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


-- ============================================
-- 初始数据
-- ============================================

-- 默认管理员账号 (密码: admin123)
INSERT INTO admin_user (id, username, password, nickname, role, status, created_at, updated_at, deleted)
VALUES (1, 'admin', '$2a$10$BpP5PtYCa0oRji6.lNeSoeHNYrs4xrAcuM4zM2.7xxP1WvM3bZqYe', '系统管理员', 'ADMIN', 1, NOW(), NOW(), 0);

-- 系统配置
INSERT INTO sys_config (id, config_key, config_value, created_at, updated_at, deleted)
VALUES (1, 'site_name', '时运商城', NOW(), NOW(), 0);
INSERT INTO sys_config (id, config_key, config_value, created_at, updated_at, deleted)
VALUES (2, 'site_keywords', '电子元器件,商城', NOW(), NOW(), 0);
INSERT INTO sys_config (id, config_key, config_value, created_at, updated_at, deleted)
VALUES (3, 'site_description', '电子元器件一站式采购平台', NOW(), NOW(), 0);

-- 短信通知配置
INSERT INTO sms_config (id, type, enabled, phones, created_at, updated_at, deleted)
VALUES (1, 'order', 0, '', NOW(), NOW(), 0);
INSERT INTO sms_config (id, type, enabled, phones, created_at, updated_at, deleted)
VALUES (2, 'inquiry', 0, '', NOW(), NOW(), 0);
INSERT INTO sms_config (id, type, enabled, phones, created_at, updated_at, deleted)
VALUES (3, 'feedback', 0, '', NOW(), NOW(), 0);
