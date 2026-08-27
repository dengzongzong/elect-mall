-- ============================================================
-- 电子元器件商城 - CRMEB扩展表
-- 说明：为CRMEB系统添加电子元器件专用功能表
-- 包括：BOM配单、询价单、数据手册、合作伙伴申请、合作品牌
-- 前缀：eb_mall_ (遵循CRMEB eb_前缀规范)
-- ============================================================

-- --------------------------------------------------------
-- 1. 合作品牌表 (eb_mall_cooperate_brand)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `eb_mall_cooperate_brand`;
CREATE TABLE `eb_mall_cooperate_brand` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌名称',
  `logo` varchar(255) NOT NULL DEFAULT '' COMMENT '品牌Logo',
  `description` text COMMENT '品牌描述',
  `website` varchar(255) NOT NULL DEFAULT '' COMMENT '官方网站',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：1-显示 0-隐藏',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int(10) NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合作品牌表';

-- --------------------------------------------------------
-- 2. 合作伙伴申请表 (eb_mall_partner_apply)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `eb_mall_partner_apply`;
CREATE TABLE `eb_mall_partner_apply` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int(10) NOT NULL DEFAULT '0' COMMENT '用户UID',
  `company` varchar(200) NOT NULL DEFAULT '' COMMENT '公司名称',
  `contact` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '邮箱',
  `remark` text COMMENT '备注说明',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态：0-待审核 1-已通过 2-已拒绝',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int(10) NOT NULL DEFAULT '0' COMMENT '申请时间',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '处理时间',
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合作伙伴申请表';

-- --------------------------------------------------------
-- 3. 询价单主表 (eb_mall_inquiry)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `eb_mall_inquiry`;
CREATE TABLE `eb_mall_inquiry` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int(10) NOT NULL DEFAULT '0' COMMENT '用户UID',
  `inquiry_no` varchar(32) NOT NULL DEFAULT '' COMMENT '询价单号',
  `contact` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人',
  `phone` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '邮箱',
  `company` varchar(200) NOT NULL DEFAULT '' COMMENT '公司名称',
  `remark` text COMMENT '备注',
  `total_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '预估总价',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态：0-待报价 1-已报价 2-已成交 3-已过期',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`),
  KEY `idx_inquiry_no` (`inquiry_no`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='询价单主表';

-- --------------------------------------------------------
-- 4. 询价单明细表 (eb_mall_inquiry_item)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `eb_mall_inquiry_item`;
CREATE TABLE `eb_mall_inquiry_item` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `inquiry_id` int(10) NOT NULL DEFAULT '0' COMMENT '询价单ID',
  `product_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `product_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `product_image` varchar(255) NOT NULL DEFAULT '' COMMENT '商品图片',
  `part_no` varchar(100) NOT NULL DEFAULT '' COMMENT '型号/料号',
  `brand` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌',
  `package` varchar(100) NOT NULL DEFAULT '' COMMENT '封装',
  `quantity` int(10) NOT NULL DEFAULT '1' COMMENT '数量',
  `unit_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
  `remark` text COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_inquiry_id` (`inquiry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='询价单明细表';

-- --------------------------------------------------------
-- 5. BOM配单记录表 (eb_mall_bom_record)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `eb_mall_bom_record`;
CREATE TABLE `eb_mall_bom_record` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int(10) NOT NULL DEFAULT '0' COMMENT '用户UID',
  `bom_no` varchar(32) NOT NULL DEFAULT '' COMMENT 'BOM单号',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT 'BOM标题',
  `total_items` int(10) NOT NULL DEFAULT '0' COMMENT '总物料数',
  `total_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总价',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态：0-待处理 1-已完成 2-已过期',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`),
  KEY `idx_bom_no` (`bom_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='BOM配单记录表';

-- --------------------------------------------------------
-- 6. BOM配单明细表 (eb_mall_bom_item)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `eb_mall_bom_item`;
CREATE TABLE `eb_mall_bom_item` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `bom_id` int(10) NOT NULL DEFAULT '0' COMMENT 'BOM记录ID',
  `product_id` int(10) NOT NULL DEFAULT '0' COMMENT '商品ID',
  `part_no` varchar(100) NOT NULL DEFAULT '' COMMENT '型号/料号',
  `brand` varchar(100) NOT NULL DEFAULT '' COMMENT '品牌',
  `package` varchar(100) NOT NULL DEFAULT '' COMMENT '封装',
  `description` varchar(500) NOT NULL DEFAULT '' COMMENT '描述',
  `quantity` int(10) NOT NULL DEFAULT '1' COMMENT '数量',
  `unit_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '单价',
  `total_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '小计',
  `remark` text COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_bom_id` (`bom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='BOM配单明细表';

-- --------------------------------------------------------
-- 7. 数据手册表 (eb_mall_datasheet)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `eb_mall_datasheet`;
CREATE TABLE `eb_mall_datasheet` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `product_id` int(10) NOT NULL DEFAULT '0' COMMENT '关联商品ID',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `file_url` varchar(500) NOT NULL DEFAULT '' COMMENT '文件地址',
  `file_size` int(10) NOT NULL DEFAULT '0' COMMENT '文件大小(字节)',
  `file_type` varchar(20) NOT NULL DEFAULT '' COMMENT '文件类型(pdf, zip等)',
  `download_count` int(10) NOT NULL DEFAULT '0' COMMENT '下载次数',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：1-显示 0-隐藏',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int(10) NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据手册表';

-- --------------------------------------------------------
-- 8. 用户管理-物料号收藏表 (eb_mall_user_part_no)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `eb_mall_user_part_no`;
CREATE TABLE `eb_mall_user_part_no` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `uid` int(10) NOT NULL DEFAULT '0' COMMENT '用户UID',
  `part_no` varchar(100) NOT NULL DEFAULT '' COMMENT '物料号',
  `product_id` int(10) NOT NULL DEFAULT '0' COMMENT '关联商品ID',
  `note` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `add_time` int(10) NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`),
  KEY `idx_part_no` (`part_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户物料号收藏表';