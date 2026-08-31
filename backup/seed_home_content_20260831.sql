-- 电子元器件商城：首页默认内容种子数据
-- 轮播图(carousel) + 右侧广告位/卖点文案(home_block)
-- 说明：首页区块不依赖图片，轮播用 color 渐变背景+标题，广告用 bg/tag_bg 背景+文字，卖点用 Element Plus 图标名+文字。

-- ================= 轮播图 =================
INSERT INTO carousel (title, image_url, link, color, sort, status, created_at, updated_at) VALUES
('电子元器件一站式采购平台', '', '', 'linear-gradient(135deg, #A8071A 0%, #E60012 100%)', 1, 1, NOW(), NOW()),
('原装正品 · 现货速发', '', '', 'linear-gradient(135deg, #0958D9 0%, #1677FF 100%)', 2, 1, NOW(), NOW()),
('钽电容 / 连接器 新品专题', '', '', 'linear-gradient(135deg, #531DAB 0%, #722ED1 100%)', 3, 1, NOW(), NOW());

-- ================= 首页区块：右侧广告位 (side_ad) =================
INSERT INTO home_block (block_key, title, `desc`, tag, tag_bg, link, bg, icon, sort, status, created_at, updated_at, deleted) VALUES
('side_ad', '限时特惠专场', '精选阻容感器件 低至8折', 'HOT', 'linear-gradient(135deg, #A8071A 0%, #E60012 100%)', '', '#fff1f0', '', 1, 1, NOW(), NOW(), 0),
('side_ad', '样品免费申请', '工程师专属 · 小批量快送', 'NEW', 'linear-gradient(135deg, #0958D9 0%, #1677FF 100%)', '', '#e6f4ff', '', 2, 1, NOW(), NOW(), 0);

-- ================= 首页区块：卖点文案 (feature) =================
INSERT INTO home_block (block_key, title, `desc`, tag, tag_bg, link, bg, icon, sort, status, created_at, updated_at, deleted) VALUES
('feature', '正品保障', '原厂授权 · 假一赔十', '', '', '', '', 'Goods', 1, 1, NOW(), NOW(), 0),
('feature', '极速发货', '现货当日发出', '', '', '', '', 'Van', 2, 1, NOW(), NOW(), 0),
('feature', '正规发票', '支持13%增值税专票', '', '', '', '', 'Tickets', 3, 1, NOW(), NOW(), 0),
('feature', '技术支持', '资深工程师在线答疑', '', '', '', '', 'Service', 4, 1, NOW(), NOW(), 0);
