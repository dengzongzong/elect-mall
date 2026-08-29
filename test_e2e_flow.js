// 全流程 E2E 测试：登录(自动注册测试账号) -> 加购 -> 查购物车 -> 下单 -> 支付 -> 查订单
const BASE = 'http://localhost:8000/api/adapter';
const TEST_PHONE = '13900008888';
const PRODUCT_ID = 1; // 0805 100nF 50V X7R 多层陶瓷电容

async function call(method, path, body, token) {
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers['Authorization'] = `Bearer ${token}`;
  const res = await fetch(`${BASE}/${path}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
  });
  const json = await res.json();
  return json; // { code, msg, data, success }
}

function assert(cond, msg) {
  if (!cond) throw new Error('断言失败: ' + msg);
  console.log('  ✓ ' + msg);
}

(async () => {
  console.log('【1】登录 / 自动注册测试账号 (phone=' + TEST_PHONE + ')');
  const login = await call('POST', 'auth/phone-login', { phone: TEST_PHONE });
  assert(login.code === 200, '登录成功 code=200');
  const token = login.data.token;
  assert(!!token, '获取到 token');
  const user = login.data.user;
  console.log('    账号信息: id=' + user.id + ' nickname=' + user.nickname + ' phone=' + user.phone);

  console.log('【2】获取用户信息 auth/user-info');
  const info = await call('GET', 'auth/user-info', null, token);
  assert(info.code === 200, 'user-info code=200, 昵称=' + info.data.nickname);

  console.log('【3】加入购物车 cart/add productId=' + PRODUCT_ID + ' qty=5');
  await call('DELETE', 'cart/clear', {}, token); // 先清空，保证断言确定
  const add = await call('POST', 'cart/add', { productId: PRODUCT_ID, quantity: 5 }, token);
  assert(add.code === 200, '加购成功 code=200');

  console.log('【4】查询购物车 cart/list');
  const cart = await call('GET', 'cart/list', null, token);
  assert(cart.code === 200, '购物车列表 code=200');
  const item = cart.data.find(i => String(i.product_id) === String(PRODUCT_ID));
  assert(item && item.quantity === 5, '购物车含目标商品且数量为5 (小计=' + (item.price * item.quantity) + ')');

  console.log('【5】创建订单 order/create');
  const total = Number((item.price * item.quantity).toFixed(2));
  const order = await call('POST', 'order/create', {
    address: '广东省深圳市南山区科技园1号',
    remark: 'E2E全流程测试订单',
    totalAmount: total,
  }, token);
  assert(order.code === 200, '下单成功 code=200, order_no=' + order.data.order_no);
  const orderId = order.data.id;

  console.log('【6】支付 pay/unified-order orderNo=' + order.data.order_no);
  const pay = await call('POST', 'pay/unified-order', { orderId: order.data.order_no, method: 'alipay' }, token);
  assert(pay.code === 200, '支付下单 code=200' + (pay.data ? ' payNo=' + pay.data.payNo : ''));
  assert(pay.data && pay.data.payNo, '返回支付流水号 payNo');

  console.log('【7】查询我的订单 order/list 验证落库');
  const list = await call('GET', 'order/list', null, token);
  assert(list.code === 200, '订单列表 code=200, 共' + list.data.total + '单');
  const myOrder = list.data.records.find(o => String(o.id) === String(orderId));
  assert(myOrder, '新订单已落库, 状态=' + myOrder.status + ' 金额=' + myOrder.total_amount);

  console.log('\n✅ 全流程测试通过：注册/登录 → 加购 → 下单 → 支付 → 订单落库 全部成功');
})().catch(e => {
  console.error('\n❌ 测试失败: ' + e.message);
  process.exit(1);
});
