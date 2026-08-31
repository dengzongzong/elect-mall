-- 覆盖式导入品牌分类（仅支持两级）
-- 生成时间：2026-08-31
-- 规则：A列=一级大类；B-F列=二级品牌；三级分类全部忽略

SET NAMES utf8mb4;

TRUNCATE TABLE category;

-- 1. 陶瓷贴片电容器
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES ('陶瓷贴片电容器', 0, 1, 1, NOW(), NOW(), 0);
SET @pid = LAST_INSERT_ID();
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES
('muRata(村田)', @pid, 1, 1, NOW(), NOW(), 0),
('TDK', @pid, 2, 1, NOW(), NOW(), 0),
('Taiyo Yuden(太诱)', @pid, 3, 1, NOW(), NOW(), 0),
('Kyocera(京瓷)', @pid, 4, 1, NOW(), NOW(), 0),
('Walsin(华科)', @pid, 5, 1, NOW(), NOW(), 0),
('SAMSUNG(三星)', @pid, 6, 1, NOW(), NOW(), 0),
('Holy Stone(禾伸堂)', @pid, 7, 1, NOW(), NOW(), 0),
('PSA(信昌)', @pid, 8, 1, NOW(), NOW(), 0),
('Yageo(国巨)', @pid, 9, 1, NOW(), NOW(), 0),
('FH(风华)', @pid, 10, 1, NOW(), NOW(), 0),
('CCTC(三环)', @pid, 11, 1, NOW(), NOW(), 0),
('VTIYONG(微容)', @pid, 12, 1, NOW(), NOW(), 0),
('SAMWHA(三和)', @pid, 13, 1, NOW(), NOW(), 0);

-- 2. 电感器（线圈）
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES ('电感器（线圈）', 0, 2, 1, NOW(), NOW(), 0);
SET @pid = LAST_INSERT_ID();
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES
('muRata(村田)', @pid, 1, 1, NOW(), NOW(), 0),
('TDK', @pid, 2, 1, NOW(), NOW(), 0);

-- 3. EMI静噪滤波器
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES ('EMI静噪滤波器', 0, 3, 1, NOW(), NOW(), 0);
SET @pid = LAST_INSERT_ID();
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES
('muRata(村田)', @pid, 1, 1, NOW(), NOW(), 0),
('TDK', @pid, 2, 1, NOW(), NOW(), 0);

-- 4. 片状铁氧体磁珠
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES ('片状铁氧体磁珠', 0, 4, 1, NOW(), NOW(), 0);
SET @pid = LAST_INSERT_ID();
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES
('TDK', @pid, 1, 1, NOW(), NOW(), 0),
('muRata(村田)', @pid, 2, 1, NOW(), NOW(), 0);

-- 5. 电源电路保护
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES ('电源电路保护', 0, 5, 1, NOW(), NOW(), 0);
SET @pid = LAST_INSERT_ID();
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES
('muRata(村田)', @pid, 1, 1, NOW(), NOW(), 0),
('TDK', @pid, 2, 1, NOW(), NOW(), 0);

-- 6. 传感器 无线射频
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES ('传感器 无线射频', 0, 6, 1, NOW(), NOW(), 0);
SET @pid = LAST_INSERT_ID();
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES
('muRata(村田)', @pid, 1, 1, NOW(), NOW(), 0),
('TDK', @pid, 2, 1, NOW(), NOW(), 0);

-- 7. 集成电路（IC）
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES ('集成电路（IC）', 0, 7, 1, NOW(), NOW(), 0);

-- 8. 晶体管
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES ('晶体管', 0, 8, 1, NOW(), NOW(), 0);

-- 9. 二极管整流器
INSERT INTO category (name, parent_id, sort, status, created_at, updated_at, deleted) VALUES ('二极管整流器', 0, 9, 1, NOW(), NOW(), 0);
