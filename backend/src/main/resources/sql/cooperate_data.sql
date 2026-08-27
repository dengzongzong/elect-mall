-- ============================================================
-- 合作品牌（授权分销商）数据
-- 参考 https://www.oneyac.com/page/sqdl.html
-- ============================================================

DELETE FROM mall_db.cooperate_brand;
ALTER TABLE mall_db.cooperate_brand AUTO_INCREMENT = 1;

INSERT INTO mall_db.cooperate_brand (id, brand_name, logo, show_image, description, sort, status, created_at, updated_at) VALUES
(1, '厦门信和达电子有限公司',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-logo-1.jpg',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-show-1.jpg',
 '厦门信和达电子有限公司成立于2000年，专业从事电子元器件代理销售业务，经过十几年的发展，已先后取得TDK、YAGEO（台湾国巨）、Panasonic、KEMET（美国基美）、Chilisin（台湾奇力新）、TAI-TECH（台湾台庆）、KDS（日本大真空）、H.ELE（台湾加高）、TOREX（日本特瑞仕）、LRC（乐山无线电）、PTTC（台湾聚鼎）、ATO（台湾荣创）、ISND等公司的销售代理权，我司代理的产品被广泛应用于各个电子行业。\n\n应用领域：手机、液晶电视、智能穿戴、无人机、新能源汽车、新能源逆变等行业',
 1, 1, NOW(), NOW()),

(2, '富昌电子（Future Electronics）',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-logo-2.jpg',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-show-2.jpg',
 '富昌电子成立于1968年，是全球领先的电子元器件分销商，也是目前业界公认的最受尊敬和最具创新性的公司之一。富昌电子的总部设在蒙特利尔，经营业务遍布全球40多个国家，为客户提供优质的服务，开发高效、完善的全球供应链解决方案，在业界独具盛名。\n\n应用领域：充电桩、电源驱动、BMS、电源、手表、医疗设备、汽车电子、LED照明、工业电子设备等行业',
 2, 1, NOW(), NOW()),

(3, 'TME（Transfer Multisort Elektronik）',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-logo-3.png',
 'https://uploadcdn.oneyac.com/attachments/page/brand/sqdl/images/partner-show-3.jpg',
 'TME是电子元器件、电器元件、车间设备及工业自动化产品全球最大的分销商之一。公司在波兰总部和其他国家的子公司现有员工近800人。我们为140个国家的数万企业服务，每天发送5000个包裹。其中提供的250000种产品，大多数为电子元器件最重要的制造商的产品。\n\n应用领域：电子元器件、电器元件、车间设备、工业自动化产品',
 3, 1, NOW(), NOW());