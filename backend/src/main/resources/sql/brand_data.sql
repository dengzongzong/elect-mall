-- ============================================================
-- 品牌数据更新脚本
-- 从 https://www.oneyac.com/brand/list.html 提取
-- ============================================================

-- 清空原有品牌数据
DELETE FROM mall_db.brand;
ALTER TABLE mall_db.brand AUTO_INCREMENT = 1;

-- 插入品牌数据（35条，含logo）
INSERT INTO mall_db.brand (id, name, logo, description, sort, status, is_cooperate, created_at, updated_at) VALUES
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