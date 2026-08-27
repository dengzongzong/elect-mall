<?php
// +----------------------------------------------------------------------
// | 电子元器件商城 - 购物车API适配控制器
// +----------------------------------------------------------------------
// | 将现有前端购物车相关API映射到CRMEB后端服务
// +----------------------------------------------------------------------

namespace app\api\controller\adapter;

use app\Request;
use app\services\order\StoreCartServices;

class CartController
{
    /**
     * 获取购物车列表
     * @param Request $request
     * @param StoreCartServices $services
     * @return \think\Response
     */
    public function list(Request $request, StoreCartServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $data = $services->getCartList($uid);
        $count = $services->countCart($uid);

        return app('json')->success([
            'list' => $data,
            'count' => $count
        ]);
    }

    /**
     * 添加商品到购物车
     * @param Request $request
     * @param StoreCartServices $services
     * @return \think\Response
     */
    public function add(Request $request, StoreCartServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $params = $request->postMore([
            ['productId', 0],
            ['quantity', 1],
        ]);

        $productId = (int)$params['productId'];
        $quantity = (int)$params['quantity'];

        if (!$productId) {
            return app('json')->fail('商品ID不能为空');
        }

        try {
            $result = $services->addCart($uid, $productId, $quantity, 'product', 0, false);
            return app('json')->success(['message' => '添加成功', 'cartId' => $result]);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 更新购物车商品数量
     * @param Request $request
     * @param StoreCartServices $services
     * @return \think\Response
     */
    public function update(Request $request, StoreCartServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $params = $request->postMore([
            ['id', 0],
            ['quantity', 1],
        ]);

        $id = (int)$params['id'];
        $quantity = (int)$params['quantity'];

        if (!$id) {
            return app('json')->fail('购物车ID不能为空');
        }

        try {
            $services->modifyCartNum($id, $quantity, $uid);
            return app('json')->success(['message' => '更新成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 删除购物车商品
     * @param Request $request
     * @param StoreCartServices $services
     * @return \think\Response
     */
    public function delete(Request $request, StoreCartServices $services)
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
            return app('json')->fail('购物车ID不能为空');
        }

        try {
            $services->removeCart($uid, [$id]);
            return app('json')->success(['message' => '删除成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 清空购物车
     * @param Request $request
     * @param StoreCartServices $services
     * @return \think\Response
     */
    public function clear(Request $request, StoreCartServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        // 获取用户购物车所有ID
        $cartList = $services->getCartList($uid);
        $ids = array_column($cartList, 'id');
        if ($ids) {
            $services->removeCart($uid, $ids);
        }

        return app('json')->success(['message' => '已清空']);
    }
}