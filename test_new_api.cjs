// 验证本次新增后端接口：型号管理/绑定邮箱/BOM提交/凭证上传
const BASE = 'http://localhost:8000/api/adapter';

async function call(method, path, body, token, isForm) {
  const headers = {};
  let payload;
  if (isForm) {
    payload = body;
  } else {
    headers['Content-Type'] = 'application/json';
    payload = body ? JSON.stringify(body) : undefined;
  }
  if (token) headers['Authorization'] = `Bearer ${token}`;
  const res = await fetch(`${BASE}/${path}`, { method, headers, body: payload });
  return res.json();
}

(async () => {
  const login = await call('POST', 'auth/phone-login', { phone: '13900008888' });
  const token = login.data.token;
  let ok = true;
  const t = (name, cond, extra) => { console.log(`  ${cond ? '✓' : '✗'} ${name}${extra ? ' — ' + extra : ''}`); if (!cond) ok = false; };

  console.log('【型号管理】');
  await call('POST', 'user/part-no/add', { partNo: 'STM32F103C8T6' }, token);
  await call('POST', 'user/part-no/add', { partNo: 'ESP32-WROOM-32' }, token);
  await call('POST', 'user/part-no/add', { partNo: 'STM32F103C8T6' }, token); // 重复
  const pl = await call('GET', 'user/part-no/list', null, token);
  t('列表', pl.code === 200 && pl.data.length === 2, `共${pl.data.length}条(去重)`);
  const firstId = pl.data[0].id;
  await call('DELETE', 'user/part-no/delete', { id: firstId }, token);
  const pl2 = await call('GET', 'user/part-no/list', null, token);
  t('删除', pl2.data.length === 1, `剩${pl2.data.length}条`);

  console.log('【绑定邮箱】');
  const be = await call('PUT', 'user/security/bind-email', { email: 'test@example.com' }, token);
  t('绑定', be.code === 200, be.msg);
  const bad = await call('PUT', 'user/security/bind-email', { email: 'not-an-email' }, token);
  t('非法邮箱拒绝', bad.code !== 200, bad.msg);
  const info = await call('GET', 'auth/user-info', null, token);
  t('user-info 含 email', info.data.email === 'test@example.com', `email=${info.data.email}`);

  console.log('【BOM 提交/列表】');
  const bom = await call('POST', 'bom/submit', { partNo: 'C0805C104K5RAC, ESP32-WROOM-32, 不存在的料号', quantity: '5, 2, 1' }, token);
  t('提交', bom.code === 200 && bom.data.totalCount === 3, `匹配${bom.data.matchCount}/${bom.data.totalCount} 金额=${bom.data.totalAmount}`);
  const bomList = await call('GET', 'bom/user/list', null, token);
  t('用户列表', bomList.code === 200 && bomList.data.length >= 1, `${bomList.data.length}条记录`);
  t('列表含明细', (bomList.data[0]?.items || []).length > 0, `${(bomList.data[0]?.items || []).length}条明细`);

  console.log('【凭证上传(JSON)】');
  const orders = await call('GET', 'order/list', null, token);
  const myOrder = orders.data.records[0];
  const up = await call('POST', 'order/upload-voucher', { id: myOrder.id, transferVoucher: 'TEST-VOUCHER-123' }, token);
  t('上传', up.code === 200, up.msg);
  const od = await call('GET', `order/${myOrder.id}`, null, token);
  t('订单含凭证', od.data.transfer_voucher === 'TEST-VOUCHER-123', `transfer_voucher=${od.data.transfer_voucher}`);

  console.log(ok ? '\n✅ 全部通过' : '\n❌ 有失败项');
  process.exit(ok ? 0 : 1);
})().catch(e => { console.error('异常: ' + e.message); process.exit(2); });
