-- MySQL dump 10.13  Distrib 8.4.3, for Win64 (x86_64)
--
-- Host: localhost    Database: mall_db
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_user`
--

DROP TABLE IF EXISTS `admin_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_user`
--

LOCK TABLES `admin_user` WRITE;
/*!40000 ALTER TABLE `admin_user` DISABLE KEYS */;
INSERT INTO `admin_user` VALUES (1,'admin','$2a$10$BpP5PtYCa0oRji6.lNeSoeHNYrs4xrAcuM4zM2.7xxP1WvM3bZqYe','系统管理员','ADMIN',1,'2026-08-27 13:47:57','2026-08-27 13:47:57',0);
/*!40000 ALTER TABLE `admin_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attr_field_def`
--

DROP TABLE IF EXISTS `attr_field_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attr_field_def`
--

LOCK TABLES `attr_field_def` WRITE;
/*!40000 ALTER TABLE `attr_field_def` DISABLE KEYS */;
INSERT INTO `attr_field_def` VALUES (2092873144700497922,1,'capacitance','容值','string',NULL,1,1,1,'2026-08-27 15:13:36','2026-08-27 15:13:36',0),(2092873144717275137,1,'voltage','耐压','string',NULL,1,2,1,'2026-08-27 15:13:36','2026-08-27 15:13:36',0),(2092873144717275138,1,'package','封装','select','0402,0603,0805,1206',1,3,1,'2026-08-27 15:13:36','2026-08-27 15:13:36',0);
/*!40000 ALTER TABLE `attr_field_def` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bom_item`
--

DROP TABLE IF EXISTS `bom_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bom_item`
--

LOCK TABLES `bom_item` WRITE;
/*!40000 ALTER TABLE `bom_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `bom_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bom_record`
--

DROP TABLE IF EXISTS `bom_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bom_record`
--

LOCK TABLES `bom_record` WRITE;
/*!40000 ALTER TABLE `bom_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `bom_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brand`
--

LOCK TABLES `brand` WRITE;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` VALUES (1,'TDK','https://uploadcdn.oneyac.com/attachments/page/brand/logos/tdk-logo.png','TDK株式会社，全球领先的电子元器件制造商，产品涵盖电感、电容、磁珠、传感器等',1,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(2,'国巨 (YAGEO)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/yageo-logo.png?v=0219','国巨集团，全球最大的被动元件制造商之一，主要产品包括电阻、电容、电感等',2,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(3,'基美 (KEMET)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/kemet-logo.png','基美公司，全球领先的电容制造商，产品涵盖钽电容、陶瓷电容、薄膜电容等',3,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(4,'威世 (VISHAY)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/vishay-logo.png','威世科技，全球最大的分立半导体和被动元件制造商之一',4,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(5,'京瓷 (Kyocera)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/kyocera-logo.png','京瓷株式会社，全球领先的电子元器件和陶瓷制造商',5,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(6,'松下 (Panasonic)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/panasonic-logo.png','松下电器，全球知名电子制造商，产品涵盖电容、电阻、继电器、连接器等',6,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(7,'罗姆 (ROHM)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/rohm-logo.png','罗姆半导体，全球知名的半导体厂商，产品涵盖IC、分立器件、LED、传感器等',7,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(8,'泰科 (TE Connectivity)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/te-logo.png?0124','泰科电子，全球最大的连接器制造商之一，产品涵盖连接器、传感器、继电器等',8,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(9,'太阳诱电 (TAIYO YUDEN)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/taiyo-logo.png','太阳诱电株式会社，全球领先的被动元件制造商，产品涵盖电容、电感、铁氧体等',9,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(10,'NDK','https://uploadcdn.oneyac.com/attachments/page/brand/detail/ndk/logo.jpg','日本电波工业株式会社，全球领先的石英晶体谐振器制造商',10,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(11,'万国半导体 (AOS)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/aos-logo.png','万国半导体，全球领先的功率半导体供应商，产品涵盖MOSFET、IGBT、电源IC等',11,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(12,'安世 (Nexperia)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/nexperia-logo.png','安世半导体，全球领先的分立器件、逻辑器件和MOSFET制造商',12,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(13,'JST','https://uploadcdn.oneyac.com/upload/brand/1766480551070_9375.png','日本压着端子制造株式会社，全球领先的连接器制造商',13,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(14,'特瑞仕 (TOREX)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/torex-logo.png','特瑞仕半导体，专注于电源管理IC和模拟半导体的日本厂商',14,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(15,'丽智 (LIZ)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/liz-logo.png','丽智电子，专业的被动元件制造商，产品涵盖电阻、陶瓷电容等',15,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(16,'台庆 (TAI-TECH)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/taitech-logo.png','台庆科技，专业的电感器和被动元件制造商',16,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(17,'乐山无线电 (LRC)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/lrc-logo.png','乐山无线电股份有限公司，专业的半导体分立器件制造商',17,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(18,'大毅','https://uploadcdn.oneyac.com/attachments/page/brand/logos/dayi-logo.png','大毅科技，全球领先的芯片电阻制造商',18,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(19,'旺诠 (RALEC)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/ralec-logo.png','旺诠科技，专业的芯片电阻和排阻制造商',19,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(20,'强茂 (PANJIT)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/panjit-logo.png','强茂股份有限公司，专业的半导体整流器件制造商',20,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(21,'奇力新 (CHILISIN)','https://uploadcdn.oneyac.com/upload/brand/1575355420527_9936.png','奇力新电子，全球领先的电感器和磁性元件制造商',21,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(22,'三星电机 (SEMCO)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/semco-logo.png','三星电机，全球领先的电子元器件制造商，产品涵盖MLCC、电感、模块等',22,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(23,'华新科技','https://uploadcdn.oneyac.com/attachments/page/brand/logos/walsin-logo.png','华新科技股份有限公司，专业的被动元件制造商，产品涵盖电阻、电容、电感等',23,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(24,'进工业 (SUSUMU)','https://uploadcdn.oneyac.com/upload/brand/1543368184948_9008.jpg','进工业株式会社，全球领先的高精度电阻制造商',24,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(25,'捷捷微电子','https://uploadcdn.oneyac.com/upload/brand/1562298366871_3486.jpg','捷捷微电子，专业的功率半导体器件制造商',25,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(26,'村田 (Murata)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/murata-logo.png','村田制作所，全球最大的陶瓷电容制造商，产品涵盖电容、电感、滤波器、传感器等',26,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(27,'加高 (H.ELE.)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/hele-logo.png','加高电子，专业的石英晶体谐振器和振荡器制造商',27,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(28,'大真空 (KDS)','https://uploadcdn.oneyac.com/attachments/page/brand/logos/kds-logo.png','大真空株式会社，全球领先的石英晶体器件制造商',28,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(29,'君耀电子','https://uploadcdn.oneyac.com/attachments/page/brand/logos/brightking-logo.png','君耀电子，专业的电路保护元件制造商，产品涵盖TVS、ESD、MOV等',29,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(30,'科山芯创','https://uploadcdn.oneyac.com/upload/brand/1677136300252_2159.png','科山芯创，专业的模拟集成电路设计公司',30,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(31,'科达嘉','https://uploadcdn.oneyac.com/upload/brand/1608109458372_1524.jpg','科达嘉电子，专业的电感器制造商',31,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(32,'天二科技','https://uploadcdn.oneyac.com/upload/brand/1577775583524_8697.png','天二科技，专业的芯片电阻和被动元件制造商',32,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(33,'赛卓电子','https://uploadcdn.oneyac.com/upload/brand/1644371136697_4166.png','赛卓电子，专业的传感器芯片和解决方案提供商',33,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(34,'友台半导体','https://uploadcdn.oneyac.com/upload/brand/1640745897025_3069.jpg','友台半导体，专业的电源管理IC和模拟器件制造商',34,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(35,'杰发科技','https://uploadcdn.oneyac.com/upload/brand/1695630616770_7369.png','杰发科技，专业的汽车电子芯片和解决方案提供商',35,1,1,'2026-08-27 14:01:36','2026-08-27 14:01:36',0),(2092951225985282051,'????_PW','https://test-brand.com/logo.png','??????',0,1,0,'2026-08-27 21:06:48','2026-08-27 21:06:48',1);
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `capacitor_attr`
--

DROP TABLE IF EXISTS `capacitor_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `capacitor_attr`
--

LOCK TABLES `capacitor_attr` WRITE;
/*!40000 ALTER TABLE `capacitor_attr` DISABLE KEYS */;
INSERT INTO `capacitor_attr` VALUES (1,1,'100nF','10%','50V','0805','X7R','-55°C ~ +125°C'),(2,2,'10pF','5%','50V','0603','C0G','-55°C ~ +125°C'),(3,3,'100nF','10%','50V','0402','X7R','-55°C ~ +125°C'),(4,4,'10uF','10%','25V','0805','X5R','-55°C ~ +85°C'),(5,5,'1uF','10%','50V','0805','X7R','-55°C ~ +125°C');
/*!40000 ALTER TABLE `capacitor_attr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carousel`
--

DROP TABLE IF EXISTS `carousel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carousel` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `image_url` varchar(500) NOT NULL DEFAULT '',
  `link` varchar(500) NOT NULL DEFAULT '',
  `sort` int NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carousel`
--

LOCK TABLES `carousel` WRITE;
/*!40000 ALTER TABLE `carousel` DISABLE KEYS */;
INSERT INTO `carousel` VALUES (1,'电子元器件一站式采购','','',0,1,'2026-08-28 14:24:49','2026-08-28 14:24:49'),(2,'新品上线 - 32位MCU','','',1,1,'2026-08-28 14:24:49','2026-08-28 14:24:49'),(3,'BOM配单服务','','',2,1,'2026-08-28 14:24:49','2026-08-28 14:24:49'),(4,'品牌专区特惠','','',3,1,'2026-08-28 14:24:49','2026-08-28 14:24:49'),(5,'新品首发 - 车规级器件','','',4,1,'2026-08-28 14:24:49','2026-08-28 14:24:49');
/*!40000 ALTER TABLE `carousel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `parent_id` bigint DEFAULT NULL COMMENT '父分类ID',
  `attr_table` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '属性表名',
  `prefix` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '编号前缀',
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2092951330683498724 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (2092951330683498614,'陶瓷贴片电容器',NULL,0,NULL,NULL,10,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498615,'电感器（线圈）',NULL,0,NULL,NULL,20,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498616,'EMI静噪滤波器',NULL,0,NULL,NULL,30,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498617,'片状铁氧体磁珠',NULL,0,NULL,NULL,40,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498618,'电源电路保护',NULL,0,NULL,NULL,50,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498619,'传感器·无线射频',NULL,0,NULL,NULL,60,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498620,'集成电路（IC）',NULL,0,NULL,NULL,70,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498621,'晶振晶体管',NULL,0,NULL,NULL,80,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498622,'二极管整流器',NULL,0,NULL,NULL,90,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498623,'muRata(村田)',NULL,2092951330683498614,NULL,NULL,10,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498624,'TDK',NULL,2092951330683498614,NULL,NULL,20,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498625,'Taiyo Yuden(太诱)',NULL,2092951330683498614,NULL,NULL,30,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498626,'Kyocera(京瓷)',NULL,2092951330683498614,NULL,NULL,40,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498627,'Walsin(华科)',NULL,2092951330683498614,NULL,NULL,50,1,'2026-08-28 13:39:03','2026-08-28 13:39:03',0),(2092951330683498628,'SAMSUNG(三星)',NULL,2092951330683498614,NULL,NULL,60,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498629,'Holy Stone(禾伸堂)',NULL,2092951330683498614,NULL,NULL,70,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498630,'PSA(信昌)',NULL,2092951330683498614,NULL,NULL,80,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498631,'Yageo(国巨)',NULL,2092951330683498614,NULL,NULL,90,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498632,'FH(风华)',NULL,2092951330683498614,NULL,NULL,100,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498633,'CCTC(三环)',NULL,2092951330683498614,NULL,NULL,110,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498634,'VIIYONG(微容)',NULL,2092951330683498614,NULL,NULL,120,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498635,'SAMWHA(三和)',NULL,2092951330683498614,NULL,NULL,130,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498636,'muRata(村田)',NULL,2092951330683498615,NULL,NULL,10,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498644,'TDK',NULL,2092951330683498615,NULL,NULL,20,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498645,'一般等级-高频电路用',NULL,2092951330683498644,NULL,NULL,10,1,'2026-08-28 13:39:04','2026-08-28 13:39:04',0),(2092951330683498646,'一般等级-去耦电路用',NULL,2092951330683498644,NULL,NULL,20,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498647,'一般等级-普通电路用',NULL,2092951330683498644,NULL,NULL,30,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498648,'一般等级-电源电路用',NULL,2092951330683498644,NULL,NULL,40,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498649,'车载等级-高频电路用',NULL,2092951330683498644,NULL,NULL,50,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498650,'车载等级-去耦电路用',NULL,2092951330683498644,NULL,NULL,60,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498651,'车载等级-普通电路用',NULL,2092951330683498644,NULL,NULL,70,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498652,'车载等级-电源电路用',NULL,2092951330683498644,NULL,NULL,80,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498653,'PoC用',NULL,2092951330683498644,NULL,NULL,90,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498654,'muRata(村田)',NULL,2092951330683498616,NULL,NULL,10,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498655,'噪音滤波器',NULL,2092951330683498654,NULL,NULL,10,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498656,'ESD陷波滤波器',NULL,2092951330683498654,NULL,NULL,20,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498657,'3端子滤波器',NULL,2092951330683498654,NULL,NULL,30,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498658,'共模扼流圈·滤波器',NULL,2092951330683498654,NULL,NULL,40,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498659,'低通滤波器',NULL,2092951330683498654,NULL,NULL,50,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498660,'双工器(Diplexer)',NULL,2092951330683498654,NULL,NULL,60,1,'2026-08-28 13:39:05','2026-08-28 13:39:05',0),(2092951330683498661,'三工器',NULL,2092951330683498654,NULL,NULL,70,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498662,'平衡器',NULL,2092951330683498654,NULL,NULL,80,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498663,'定向耦合器',NULL,2092951330683498654,NULL,NULL,90,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498664,'分配器/分线器',NULL,2092951330683498654,NULL,NULL,100,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498665,'贴片天线',NULL,2092951330683498654,NULL,NULL,110,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498666,'高频电路用电感器',NULL,2092951330683498654,NULL,NULL,120,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498667,'LC低通滤波器',NULL,2092951330683498654,NULL,NULL,130,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498668,'TDK',NULL,2092951330683498616,NULL,NULL,20,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498669,'噪音滤波器',NULL,2092951330683498668,NULL,NULL,10,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498670,'ESD陷波滤波器',NULL,2092951330683498668,NULL,NULL,20,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498671,'3端子滤波器',NULL,2092951330683498668,NULL,NULL,30,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498672,'共模扼流圈·滤波器',NULL,2092951330683498668,NULL,NULL,40,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498673,'低通滤波器',NULL,2092951330683498668,NULL,NULL,50,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498674,'双工器(Diplexer)',NULL,2092951330683498668,NULL,NULL,60,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498675,'三工器',NULL,2092951330683498668,NULL,NULL,70,1,'2026-08-28 13:39:06','2026-08-28 13:39:06',0),(2092951330683498676,'平衡器',NULL,2092951330683498668,NULL,NULL,80,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498677,'定向耦合器',NULL,2092951330683498668,NULL,NULL,90,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498678,'分配器/分线器',NULL,2092951330683498668,NULL,NULL,100,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498679,'贴片天线',NULL,2092951330683498668,NULL,NULL,110,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498680,'高频电路用电感器',NULL,2092951330683498668,NULL,NULL,120,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498681,'LC低通滤波器',NULL,2092951330683498668,NULL,NULL,130,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498682,'TDK',NULL,2092951330683498617,NULL,NULL,10,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498683,'贴片磁珠',NULL,2092951330683498682,NULL,NULL,10,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498684,'muRata(村田)',NULL,2092951330683498617,NULL,NULL,20,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498685,'磁珠',NULL,2092951330683498684,NULL,NULL,10,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498686,'muRata(村田)',NULL,2092951330683498618,NULL,NULL,10,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498687,'NTC热敏电阻',NULL,2092951330683498686,NULL,NULL,10,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498688,'PTC热敏电阻',NULL,2092951330683498686,NULL,NULL,20,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498689,'PRF系列/PTC热敏电阻',NULL,2092951330683498686,NULL,NULL,30,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498690,'PRG系列/PTC热敏电阻',NULL,2092951330683498686,NULL,NULL,40,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498691,'压敏电阻',NULL,2092951330683498686,NULL,NULL,50,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498692,'TDK',NULL,2092951330683498618,NULL,NULL,20,1,'2026-08-28 13:39:07','2026-08-28 13:39:07',0),(2092951330683498693,'NTC热敏电阻',NULL,2092951330683498692,NULL,NULL,10,1,'2026-08-28 13:39:08','2026-08-28 13:39:08',0),(2092951330683498694,'PTC热敏电阻',NULL,2092951330683498692,NULL,NULL,20,1,'2026-08-28 13:39:08','2026-08-28 13:39:08',0),(2092951330683498695,'PRF系列/PTC热敏电阻',NULL,2092951330683498692,NULL,NULL,30,1,'2026-08-28 13:39:08','2026-08-28 13:39:08',0),(2092951330683498696,'PRG系列/PTC热敏电阻',NULL,2092951330683498692,NULL,NULL,40,1,'2026-08-28 13:39:08','2026-08-28 13:39:08',0),(2092951330683498697,'压敏电阻',NULL,2092951330683498692,NULL,NULL,50,1,'2026-08-28 13:39:08','2026-08-28 13:39:08',0),(2092951330683498698,'muRata(村田)',NULL,2092951330683498619,NULL,NULL,10,1,'2026-08-28 13:39:08','2026-08-28 13:39:08',0),(2092951330683498699,'温度传感器(NTC)',NULL,2092951330683498698,NULL,NULL,10,1,'2026-08-28 13:39:08','2026-08-28 13:39:08',0),(2092951330683498700,'温度传感器(PTC)',NULL,2092951330683498698,NULL,NULL,20,1,'2026-08-28 13:39:08','2026-08-28 13:39:08',0);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cooperate_brand`
--

DROP TABLE IF EXISTS `cooperate_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cooperate_brand`
--

LOCK TABLES `cooperate_brand` WRITE;
/*!40000 ALTER TABLE `cooperate_brand` DISABLE KEYS */;
INSERT INTO `cooperate_brand` VALUES (1,'厦门信和达电子有限公司','https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-logo-1.jpg','厦门信和达电子有限公司成立于2000年，专业从事电子元器件代理销售业务，经过十几年的发展，已先后取得TDK、YAGEO（台湾国巨）、Panasonic、KEMET（美国基美）、Chilisin（台湾奇力新）、TAI-TECH（台湾台庆）、KDS（日本大真空）、H.ELE（台湾加高）、TOREX（日本特瑞仕）、LRC（乐山无线电）、PTTC（台湾聚鼎）、ATO（台湾荣创）、ISND等公司的销售代理权，我司代理的产品被广泛应用于各个电子行业。\n\n应用领域：手机、液晶电视、智能穿戴、无人机、新能源汽车、新能源逆变等行业',1,1,'2026-08-27 14:25:20','2026-08-27 14:25:20',0,'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-show-1.jpg'),(2,'富昌电子（Future Electronics）','https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-logo-2.jpg','富昌电子成立于1968年，是全球领先的电子元器件分销商，也是目前业界公认的最受尊敬和最具创新性的公司之一。富昌电子的总部设在蒙特利尔，经营业务遍布全球40多个国家，为客户提供优质的服务，开发高效、完善的全球供应链解决方案，在业界独具盛名。\n\n应用领域：充电桩、电源驱动、BMS、电源、手表、医疗设备、汽车电子、LED照明、工业电子设备等行业',2,1,'2026-08-27 14:25:20','2026-08-27 14:25:20',0,'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-show-2.jpg'),(3,'TME（Transfer Multisort Elektronik）','https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-logo-3.png','TME是电子元器件、电器元件、车间设备及工业自动化产品全球最大的分销商之一。公司在波兰总部和其他国家的子公司现有员工近800人。我们为140个国家的数万企业服务，每天发送5000个包裹。其中提供的250000种产品，大多数为电子元器件最重要的制造商的产品。\n\n应用领域：电子元器件、电器元件、车间设备、工业自动化产品',3,1,'2026-08-27 14:25:20','2026-08-27 14:25:20',0,'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-show-3.jpg'),(2092875594245337090,'API测试合作品牌_已更新','https://example.com/c.png','测试合作品牌',88,1,'2026-08-27 15:23:20','2026-08-27 15:27:02',0,''),(2092876522306383874,'API测试合作品牌','https://example.com/c.png','测试合作品牌',99,1,'2026-08-27 15:27:01','2026-08-27 15:27:01',0,'');
/*!40000 ALTER TABLE `cooperate_brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datasheet`
--

DROP TABLE IF EXISTS `datasheet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datasheet`
--

LOCK TABLES `datasheet` WRITE;
/*!40000 ALTER TABLE `datasheet` DISABLE KEYS */;
INSERT INTO `datasheet` VALUES (2092873151226834946,NULL,NULL,'API测试数据手册',NULL,'2026-08-27 15:13:38','2026-08-27 15:13:38',0);
/*!40000 ALTER TABLE `datasheet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite`
--

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `type` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '反馈类型：建议/投诉',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '反馈内容',
  `reply` text COLLATE utf8mb4_unicode_ci COMMENT '管理员回复',
  `status` tinyint DEFAULT '0' COMMENT '处理状态：0-待处理 1-已处理',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='意见反馈表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filter_attr`
--

DROP TABLE IF EXISTS `filter_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filter_attr`
--

LOCK TABLES `filter_attr` WRITE;
/*!40000 ALTER TABLE `filter_attr` DISABLE KEYS */;
/*!40000 ALTER TABLE `filter_attr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inductor_attr`
--

DROP TABLE IF EXISTS `inductor_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inductor_attr`
--

LOCK TABLES `inductor_attr` WRITE;
/*!40000 ALTER TABLE `inductor_attr` DISABLE KEYS */;
/*!40000 ALTER TABLE `inductor_attr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inquiry`
--

DROP TABLE IF EXISTS `inquiry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inquiry`
--

LOCK TABLES `inquiry` WRITE;
/*!40000 ALTER TABLE `inquiry` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inquiry_item`
--

DROP TABLE IF EXISTS `inquiry_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inquiry_item`
--

LOCK TABLES `inquiry_item` WRITE;
/*!40000 ALTER TABLE `inquiry_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiry_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message`
--

LOCK TABLES `message` WRITE;
/*!40000 ALTER TABLE `message` DISABLE KEYS */;
/*!40000 ALTER TABLE `message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `source` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图片URL',
  `like_count` int DEFAULT '0' COMMENT '点赞数',
  `favorite_count` int DEFAULT '0' COMMENT '收藏数',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-发布 0-草稿',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2092951474728480791 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资讯/新闻表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (2092951474728480777,'高精度时间管理的完美搭档：YSN8563 RTC与32.768kHz晶振的协同设计','YXC','【唯样已成为YXC/扬兴科技官方授权代理商】本文将介绍YXC外置晶体RTC YSN8563搭配YXC 32.768kHz晶振的组合方案。',NULL,0,0,1,'2026-07-15 00:00:00','2026-08-28 13:31:15',0),(2092951474728480778,'Euro NCAP 2026 来了，您的座椅位置检测还够用吗？','TE','【唯样已成为TE Connectivity/泰科电子官方授权代理商】TE 3区座椅滑轨位置传感解决方案以高精度座椅位置数据为基石，赋能更精准的乘员分类与安全气囊展开控制，在帮助OEM和一级供应商满足新规要求的同时，显著降低系统集成成本。',NULL,0,0,1,'2026-06-25 00:00:00','2026-08-28 13:31:15',0),(2092951474728480779,'从多颗晶振到一颗时钟发生器芯片｜YXC-SYNK智能显示屏时钟方案','YXC','【唯样已成为yxc/扬兴科技官方授权代理商】YXC-SYNK提供的可编程时钟发生器SYKG1042E/Q5,一颗芯片输出4路差分加2路LVCMOS时钟,替代多颗独立晶振。',NULL,0,0,1,'2026-08-26 00:00:00','2026-08-28 13:31:15',0),(2092951474728480780,'RS422与RS485接口怎么选？读懂差异，选对收发芯片','AOTE','【唯样已成为AOTE/奥特官方授权代理商】本文将深入解析RS422与RS485接口的技术差异，帮助工程师根据应用场景选择最佳收发芯片方案。',NULL,0,0,1,'2026-08-26 00:00:00','2026-08-28 13:31:15',0),(2092951474728480781,'YSN8130：面向智能割草机器人的高可靠RTC方案','扬兴科技','【唯样已成为yxc/扬兴科技官方授权代理商】面向户外复杂环境与长时间续航需求，YXC扬兴科技推出高集成度、低功耗RTC芯片YSN8130系列，为智能割草机器人提供稳定时间基准。',NULL,0,0,1,'2026-08-17 00:00:00','2026-08-28 13:31:15',0),(2092951474728480782,'高速套标精度差、频繁停机？松下套标机方案解决四大行业难题！','松下','【唯样已成为Panasonic/松下官方授权代理商】松下基于现有产品和平台,为客户开发了智能套标一体化解决方案。',NULL,0,0,1,'2026-08-17 00:00:00','2026-08-28 13:31:15',0),(2092951474728480783,'应用篇：PFM控制中每次开关的能量是如何决定的？','TOREX','【唯样已成为Torex Semiconductor/特瑞仕官方授权代理商】本文将就PFM控制中单次开关的能量值是如何确定的、及电流型PFM控制与COT控制的区别进行解说。',NULL,0,0,1,'2026-08-17 00:00:00','2026-08-28 13:31:15',0),(2092951474728480784,'从听见，到持续聆听｜人工耳蜗中的超低功耗晶振','YXC','【唯样已成为yxc/扬兴科技官方授权代理商】针对人工耳蜗这类小型化、低功耗设备的时钟需求，YXC扬兴科技推出YSO131LR系列超低功耗有源晶振。',NULL,0,0,1,'2026-08-12 00:00:00','2026-08-28 13:31:15',0),(2092951474728480785,'业界领先的大尺寸封装（φ12.5），兼具高纹波电流承载能力、大容量与低高度设计','太阳诱电','【唯样已成为Taiyo Yuden/太阳诱电官方授权代理商】太阳诱电HVX/HTX-J系列在保持业界领先的高纹波电流承载能力和大容量特性的同时，提供多种尺寸的63V产品阵容，可满足48V系统多样化的设计需求。',NULL,0,0,1,'2026-08-12 00:00:00','2026-08-28 13:31:15',0),(2092951474728480786,'应用分享 | 国巨面向电气化与智能未来的传感器解决方案','国巨','【唯样已成为Yageo/国巨官方授权代理商】国巨集团（YAGEO Group）提供涵盖Pt RTD与NTC的全面温度传感器组合，包括引线式、贴片式（SMD）、浸入式及PTFE外壳传感器等，广泛适配各类应用与集成需求。',NULL,0,0,1,'2026-08-11 00:00:00','2026-08-28 13:31:15',0),(2092951474728480787,'行业应用 | 实装生产线解决方案','松下','【唯样已成为Panasonic/松下官方授权代理商】松下行业应用：实装生产线解决方案，助力智能制造升级。',NULL,0,0,1,'2026-07-23 00:00:00','2026-08-28 13:34:06',0),(2092951474728480788,'第3期｜仅凭VIN、VOUT、IOUT还不够？电源IC选型中应关注的基本规格','TOREX','【唯样已成为Torex Semiconductor/特瑞仕官方授权代理商】电源IC选型时需关注的各项基本规格参数详解。',NULL,0,0,1,'2026-07-23 00:00:00','2026-08-28 13:34:06',0),(2092951474728480789,'第4期｜您是否忽略了这些关键点？电源IC选型时需确认的重要特性','TOREX','【唯样已成为Torex Semiconductor/特瑞仕官方授权代理商】电源IC选型时需确认的重要特性分析。',NULL,0,0,1,'2026-07-23 00:00:00','2026-08-28 13:34:06',0),(2092951474728480790,'高精度时间管理的完美搭档：YSN8563 RTC与晶振协同设计','YXC','【唯样已成为YXC/扬兴科技官方授权代理商】YXC外置晶体RTC YSN8563搭配YXC 32.768kHz晶振的组合方案。',NULL,0,0,1,'2026-07-15 00:00:00','2026-08-28 13:34:06',0);
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_like`
--

DROP TABLE IF EXISTS `news_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_like`
--

LOCK TABLES `news_like` WRITE;
/*!40000 ALTER TABLE `news_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `news_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partner_apply`
--

DROP TABLE IF EXISTS `partner_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partner_apply`
--

LOCK TABLES `partner_apply` WRITE;
/*!40000 ALTER TABLE `partner_apply` DISABLE KEYS */;
/*!40000 ALTER TABLE `partner_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pay_record`
--

DROP TABLE IF EXISTS `pay_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pay_record`
--

LOCK TABLES `pay_record` WRITE;
/*!40000 ALTER TABLE `pay_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `pay_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,1,1,'C0805C104K5RAC','0805 100nF 50V X7R 多层陶瓷电容','0805封装 100nF 50V X7R 多层陶瓷电容，适用于电源去耦和滤波应用',10000,0.0850,100,NULL,'pcs',NULL,NULL,1,'2026-08-27 13:48:08','2026-08-27 13:48:08',0),(2,1,1,'C0603C100J5GAC','0603 10pF 50V C0G 多层陶瓷电容','0603封装 10pF 50V C0G 多层陶瓷电容，高稳定性适用于高频电路',8000,0.1200,100,NULL,'pcs',NULL,NULL,1,'2026-08-27 13:48:08','2026-08-27 13:48:08',0),(3,1,2,'GRM155R71H104KE14','0402 100nF 50V X7R 村田陶瓷电容','村田 0402 100nF 50V X7R 陶瓷电容，小型化设计适用于便携设备',12000,0.0950,100,NULL,'pcs',NULL,NULL,1,'2026-08-27 13:48:08','2026-08-27 13:48:08',0),(4,1,2,'GRM21BR61E106KA73','0805 10uF 25V X5R 村田陶瓷电容','村田 0805 10uF 25V X5R 陶瓷电容，大容量适用于电源平滑电路',5000,0.3200,50,NULL,'pcs',NULL,NULL,1,'2026-08-27 13:48:08','2026-08-27 13:48:08',0),(5,1,4,'CC0805KKX7R9BB105','0805 1uF 50V X7R 国巨陶瓷电容','国巨 0805 1uF 50V X7R 多层陶瓷电容，通用型适用于各类电子设备',6000,0.1500,100,NULL,'pcs',NULL,NULL,1,'2026-08-27 13:48:08','2026-08-27 13:48:08',0),(2092873149586862081,1,1,'API-TEST-001','API测试电容器_已更新','已通过API更新的测试电容器',2000,0.1500,10,0.1000,'个','https://example.com/datasheet_updated.pdf','https://example.com/product_updated.jpg',1,'2026-08-27 15:13:37','2026-08-27 15:13:37',0),(2092875596602535938,1,1,'API-TEST-002','API测试商品_已更新','测试商品',200,1.5000,1,NULL,'pcs',NULL,NULL,1,'2026-08-27 15:23:21','2026-08-27 15:27:02',0),(2092945550861283330,2092927356083875800,NULL,'','测试商品_PW',NULL,0,0.0000,1,NULL,NULL,NULL,NULL,1,'2026-08-27 20:01:19','2026-08-27 20:01:19',0),(2092949914829074433,NULL,NULL,'PW-TEST-1787833119162','测试商品_1787833119162',NULL,0,0.0000,1,NULL,NULL,NULL,NULL,1,'2026-08-27 20:18:39','2026-08-27 20:18:39',0),(2092949931803422721,NULL,NULL,'PW-TEST-1787833123034','测试商品_1787833123034',NULL,0,0.0000,1,NULL,NULL,NULL,NULL,1,'2026-08-27 20:18:44','2026-08-27 20:18:44',0),(2092950133381672962,NULL,NULL,'API-TEST-456','????_API',NULL,100,9.9900,1,NULL,NULL,NULL,NULL,1,'2026-08-27 20:19:32','2026-08-27 20:19:32',0),(2092950804407398402,NULL,NULL,'PW-TEST-1787833331234','测试商品_1787833331234',NULL,0,0.0000,1,NULL,NULL,NULL,NULL,1,'2026-08-27 20:22:12','2026-08-27 20:22:12',0),(2092950822052835330,NULL,NULL,'PW-TEST-1787833335206','测试商品_1787833335206',NULL,0,0.0000,1,NULL,NULL,NULL,NULL,1,'2026-08-27 20:22:16','2026-08-27 20:22:16',0),(2092951552507654145,NULL,NULL,'PW-TEST-1787833509604','测试商品_1787833509604',NULL,0,0.0000,1,NULL,NULL,NULL,NULL,1,'2026-08-27 20:25:10','2026-08-27 20:25:10',0),(2092951570329251842,NULL,NULL,'PW-TEST-1787833513674','测试商品_1787833513674',NULL,0,0.0000,1,NULL,NULL,NULL,NULL,1,'2026-08-27 20:25:14','2026-08-27 20:25:14',0),(2092951570329251843,2092927356083875842,NULL,'PW-TEST-001','????_PW','??????',100,10.9900,1,NULL,NULL,NULL,'',1,'2026-08-27 21:07:00','2026-08-27 21:07:00',0),(2092951570329251844,NULL,NULL,'PW-TEST-1787836132982','测试商品_1787836132982','',0,0.0000,1,NULL,NULL,NULL,'',1,'2026-08-27 21:08:53','2026-08-27 21:08:53',0),(2092951570329251845,NULL,NULL,'PW-TEST-1787836136671','测试商品_1787836136671','',0,0.0000,1,NULL,NULL,NULL,'',1,'2026-08-27 21:08:57','2026-08-27 21:08:57',0),(2092951570329251846,NULL,NULL,'PW-TEST-1787836340177','测试商品_1787836340177','',0,0.0000,1,NULL,NULL,NULL,'',1,'2026-08-27 21:12:20','2026-08-27 21:12:20',0),(2092951570329251847,NULL,NULL,'PW-TEST-1787836344421','测试商品_1787836344421','',0,0.0000,1,NULL,NULL,NULL,'',1,'2026-08-27 21:12:24','2026-08-27 21:12:24',0),(2092951570329251848,NULL,NULL,'PW-TEST-1787836470858','测试商品_1787836470858','',0,0.0000,1,NULL,NULL,NULL,'',1,'2026-08-27 21:14:31','2026-08-27 21:14:31',0),(2092951570329251849,NULL,NULL,'PW-TEST-1787836475239','测试商品_1787836475239','',0,0.0000,1,NULL,NULL,NULL,'',1,'2026-08-27 21:14:35','2026-08-27 21:14:35',0);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_config`
--

DROP TABLE IF EXISTS `sms_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sms_config`
--

LOCK TABLES `sms_config` WRITE;
/*!40000 ALTER TABLE `sms_config` DISABLE KEYS */;
INSERT INTO `sms_config` VALUES (1,'inquiry_notify',0,NULL,'2026-08-27 13:48:07','2026-08-27 13:48:07',0),(2,'order_notify',0,NULL,'2026-08-27 13:48:07','2026-08-27 13:48:07',0),(3,'register_notify',0,NULL,'2026-08-27 13:48:07','2026-08-27 13:48:07',0);
/*!40000 ALTER TABLE `sms_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'service_qq','4008888888','2026-08-27 13:48:08','2026-08-27 13:48:08',0),(2,'service_wechat','/uploads/wechat_qr.png','2026-08-27 13:48:08','2026-08-27 13:48:08',0),(3,'service_phone','400-888-8888','2026-08-27 13:48:08','2026-08-27 13:48:08',0);
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `openid` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微信openid',
  `nickname` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像URL',
  `balance` decimal(12,2) DEFAULT '0.00' COMMENT '账户余额',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-正常 0-禁用',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标记',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address`
--

LOCK TABLES `user_address` WRITE;
/*!40000 ALTER TABLE `user_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_balance_log`
--

DROP TABLE IF EXISTS `user_balance_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_balance_log`
--

LOCK TABLES `user_balance_log` WRITE;
/*!40000 ALTER TABLE `user_balance_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_balance_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'mall_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-29 10:36:55
