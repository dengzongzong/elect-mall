<?php
// +----------------------------------------------------------------------
// | 电子元器件商城 - 认证API适配控制器
// +----------------------------------------------------------------------
// | 将现有前端认证相关API映射到CRMEB后端服务
// +----------------------------------------------------------------------

namespace app\api\controller\adapter;

use app\Request;
use app\services\user\LoginServices;
use app\services\user\UserServices;
use think\facade\Cache;

class AuthController
{
    /**
     * 发送短信验证码
     * @param Request $request
     * @return \think\Response
     */
    public function sendCode(Request $request)
    {
        $params = $request->postMore([
            ['phone', ''],
        ]);

        $phone = $params['phone'];
        if (!$phone) {
            return app('json')->fail('手机号不能为空');
        }

        // 调用CRMEB的验证码发送
        try {
            $loginService = app()->make(LoginServices::class);
            $result = $loginService->verify($phone);
            return app('json')->success(['message' => '验证码已发送']);
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 手机号验证码登录
     * @param Request $request
     * @param LoginServices $services
     * @return \think\Response
     */
    public function phoneLogin(Request $request, LoginServices $services)
    {
        $params = $request->postMore([
            ['phone', ''],
            ['code', ''],
        ]);

        $phone = $params['phone'];
        $code = $params['code'];

        if (!$phone || !$code) {
            return app('json')->fail('手机号和验证码不能为空');
        }

        try {
            // 直接调用CRMEB的登录服务
            $result = $services->loginMobile($phone, $code);
            if ($result) {
                $tokenInfo = $services->getLoginResult($result['userInfo'] ?? $result['user'] ?? $result);
                return app('json')->success([
                    'token' => $tokenInfo['token'] ?? '',
                    'userInfo' => $result
                ]);
            }
            return app('json')->fail('登录失败');
        } catch (\Exception $e) {
            return app('json')->fail($e->getMessage());
        }
    }

    /**
     * 微信登录
     * @param Request $request
     * @return \think\Response
     */
    public function wechatLogin(Request $request)
    {
        return app('json')->fail('微信登录暂未开放');
    }

    /**
     * 绑定手机号
     * @param Request $request
     * @return \think\Response
     */
    public function bindPhone(Request $request)
    {
        $params = $request->postMore([
            ['phone', ''],
            ['code', ''],
            ['tempToken', ''],
        ]);
        return app('json')->fail('绑定手机号功能暂未开放');
    }

    /**
     * 退出登录
     * @param Request $request
     * @return \think\Response
     */
    public function logout(Request $request)
    {
        $token = $request->header('Authori-zation', '');
        $token = str_replace('Bearer ', '', $token);
        if ($token) {
            Cache::delete('user_token_' . $token);
        }
        return app('json')->success(['message' => '退出成功']);
    }

    /**
     * 获取当前用户信息
     * @param Request $request
     * @param UserServices $services
     * @return \think\Response
     */
    public function userInfo(Request $request, UserServices $services)
    {
        $uid = $request->uid();
        if (!$uid) {
            return app('json')->fail('未登录', null, 401);
        }

        $user = $services->getUserInfo($uid);
        return app('json')->success($user);
    }
}