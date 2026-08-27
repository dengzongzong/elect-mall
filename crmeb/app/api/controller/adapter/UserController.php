<?php
// +----------------------------------------------------------------------
// | 电子元器件商城 - 用户API适配控制器
// +----------------------------------------------------------------------
// | 将现有前端用户相关API映射到CRMEB后端服务
// +----------------------------------------------------------------------

namespace app\api\controller\adapter;

use app\Request;
use app\services\user\UserAddressServices;
use app\services\user\UserServices;
use app\services\product\product\StoreProductRelationServices;

class UserController
{
    /**
     * 获取用户地址列表
     * @param Request $request
     * @param UserAddressServices $services
     * @return \think\Response
     */
    public function addressList(Request $request, UserAddressServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $list = $services->getUserAddressList($uid);
        return app('json')->success(['list' => $list]);
    }

    /**
     * 新增地址
     * @param Request $request
     * @param UserAddressServices $services
     * @return \think\Response
     */
    public function addressAdd(Request $request, UserAddressServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $data = $request->postMore([
            ['name', ''],
            ['phone', ''],
            ['province', ''],
            ['city', ''],
            ['district', ''],
            ['detail', ''],
            ['is_default', 0],
        ]);

        $data['uid'] = $uid;

        try {
            $result = $services->addAddress($uid, $data);
            return app('json')->success(['message' => '添加成功', 'id' => $result]);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 更新地址
     * @param Request $request
     * @param UserAddressServices $services
     * @return \think\Response
     */
    public function addressUpdate(Request $request, UserAddressServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $data = $request->postMore([
            ['id', 0],
            ['name', ''],
            ['phone', ''],
            ['province', ''],
            ['city', ''],
            ['district', ''],
            ['detail', ''],
            ['is_default', 0],
        ]);

        $id = (int)$data['id'];
        unset($data['id']);

        try {
            $services->editAddress($uid, $id, $data);
            return app('json')->success(['message' => '更新成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 删除地址
     * @param Request $request
     * @param UserAddressServices $services
     * @return \think\Response
     */
    public function addressDelete(Request $request, UserAddressServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $params = $request->postMore([
            ['id', 0],
        ]);

        $id = (int)$params['id'];

        try {
            $services->delAddress($id, $uid);
            return app('json')->success(['message' => '删除成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 获取用户收藏列表
     * @param Request $request
     * @param StoreProductRelationServices $services
     * @return \think\Response
     */
    public function favoriteList(Request $request, StoreProductRelationServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $list = $services->getUserCollectList($uid);
        return app('json')->success(['list' => $list]);
    }

    /**
     * 添加收藏
     * @param Request $request
     * @param StoreProductRelationServices $services
     * @return \think\Response
     */
    public function favoriteAdd(Request $request, StoreProductRelationServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $params = $request->postMore([
            ['productId', 0],
        ]);

        $productId = (int)$params['productId'];

        try {
            $services->addProductRelation($productId, $uid, 'collect', 'product');
            return app('json')->success(['message' => '收藏成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 删除收藏
     * @param Request $request
     * @param StoreProductRelationServices $services
     * @return \think\Response
     */
    public function favoriteDelete(Request $request, StoreProductRelationServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $params = $request->postMore([
            ['id', 0],
        ]);

        $productId = (int)$params['id'];

        try {
            $services->delProductRelation($productId, $uid, 'collect', 'product');
            return app('json')->success(['message' => '取消收藏成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 获取余额流水
     * @param Request $request
     * @param \app\services\user\UserBillServices $services
     * @return \think\Response
     */
    public function balanceLog(Request $request, \app\services\user\UserBillServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $list = $services->getBalanceList($uid);
        return app('json')->success(['list' => $list]);
    }

    /**
     * 提交反馈
     * @param Request $request
     * @return \think\Response
     */
    public function submitFeedback(Request $request)
    {
        $uid = $request->uid();
        $params = $request->postMore([
            ['content', ''],
            ['type', ''],
        ]);

        // CRMEB有客服反馈功能
        try {
            $feedbackService = app()->make(\app\services\kefu\service\StoreServiceFeedbackServices::class);
            $feedbackService->saveFeedback($uid, $params['content'], $params['type']);
            return app('json')->success(['message' => '提交成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 获取用户消息列表
     * @param Request $request
     * @return \think\Response
     */
    public function messageList(Request $request)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        try {
            $msgService = app()->make(\app\services\message\MessageSystemServices::class);
            $list = $msgService->getMessageList($uid);
            return app('json')->success(['list' => $list]);
        } catch (\Exception $e) {
            return app('json')->success(['list' => []]);
        }
    }

    /**
     * 更新用户资料
     * @param Request $request
     * @param UserServices $services
     * @return \think\Response
     */
    public function updateProfile(Request $request, UserServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录');
        }

        $data = $request->postMore([
            ['nickname', ''],
            ['avatar', ''],
        ]);

        try {
            $services->updateUserInfo($uid, $data);
            return app('json')->success(['message' => '更新成功']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }
}