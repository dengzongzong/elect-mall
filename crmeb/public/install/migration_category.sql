-- ============================================================
-- 分类表迁移脚本：添加 description 字段
-- ============================================================

-- 检查字段是否存在，不存在则添加
SET @dbname = DATABASE();
SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = @dbname
    AND TABLE_NAME = 'category'
    AND COLUMN_NAME = 'description');

SET @sql = IF(@exists = 0,
    'ALTER TABLE category ADD COLUMN `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT ''分类详情'' AFTER `prefix`',
    'SELECT "description column already exists"');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;