<?php
// +----------------------------------------------------------------------
// | 电子元器件商城 - 订单API适配控制器
// +----------------------------------------------------------------------
// | 将现有前端订单相关API映射到CRMEB后端服务
// +----------------------------------------------------------------------

namespace app\api\controller\adapter;

use app\Request;
use app\services\order\StoreCartServices;
use app\services\order\StoreOrderServices;
use app\services\order\StoreOrderCreateServices;
use app\services\order\StoreOrderComputedServices;

class OrderController
{
    /**
     * 创建订单
     * @param Request $request
     * @param StoreOrderCreateServices $createServices
     * @param StoreCartServices $cartServices
     * @return \think\Response
     */
    public function create(Request $request, StoreOrderCreateServices $createServices, StoreCartServices $cartServices)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $params = $request->postMore([
            ['address', ''],
            ['remark', ''],
        ]);

        $addressId = (int)$params['address'];
        $remark = $params['remark'];

        try {
            // 获取购物车信息
            $cartList = $cartServices->getCartList($uid);
            if (empty($cartList)) {
                return app('json')->fail('购物车为空');
            }

            // 构建订单数据
            $orderData = [
                'addressId' => $addressId,
                'remark' => $remark,
                'uid' => $uid,
                'cartIds' => $cartList
            ];

            // 计算订单金额
            $computed = app()->make(StoreOrderComputedServices::class);
            $priceData = $computed->computedOrder($uid, $cartList, $addressId);

            // 创建订单
            $order = $createServices->createOrder($uid, $cartList, $addressId, $remark);

            return app('json')->success([
                'orderId' => $order['order_id'] ?? '',
                'orderNo' => $order['order_sn'] ?? '',
                'totalPrice' => $order['total_price'] ?? 0,
                'payPrice' => $order['pay_price'] ?? 0,
            ]);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 获取用户订单列表
     * @param Request $request
     * @param StoreOrderServices $services
     * @return \think\Response
     */
    public function list(Request $request, StoreOrderServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $where = $request->getMore([
            ['type', '', '', 'status'],
            [['page', 'd'], 0],
            [['limit', 'd'], 10],
        ]);
        $where['uid'] = $uid;
        $where['is_del'] = 0;
        $where['is_system_del'] = 0;

        $list = $services->getOrderList($where);
        $count = $services->getOrderCount($where);

        return app('json')->success([
            'list' => $list,
            'total' => $count
        ]);
    }

    /**
     * 获取订单详情
     * @param Request $request
     * @param $id
     * @param StoreOrderServices $services
     * @return \think\Response
     */
    public function detail(Request $request, $id, StoreOrderServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $order = $services->detail($id, $uid);
        if (!$order) {
            return app('json')->fail('订单不存在');
        }

        return app('json')->success($order);
    }

    /**
     * 取消订单
     * @param Request $request
     * @param StoreOrderServices $services
     * @return \think\Response
     */
    public function cancel(Request $request, StoreOrderServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $params = $request->postMore([
            ['id', 0],
        ]);

        $id = (int)$params['id'];
        if (!$id) {
            return app('json')->fail('订单ID不能为空');
        }

        try {
            $services->cancelOrder($id, $uid);
            return app('json')->success(['message' => '取消成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 确认收货
     * @param Request $request
     * @param StoreOrderServices $services
     * @return \think\Response
     */
    public function confirmReceipt(Request $request, StoreOrderServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $params = $request->postMore([
            ['id', 0],
        ]);

        $id = (int)$params['id'];
        if (!$id) {
            return app('json')->fail('订单ID不能为空');
        }

        try {
            $services->takeOrder($id, $uid);
            return app('json')->success(['message' => '确认收货成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }
}