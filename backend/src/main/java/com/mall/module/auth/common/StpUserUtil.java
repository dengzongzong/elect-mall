package com.mall.module.auth.common;

import cn.dev33.satoken.stp.StpUtil;

/**
 * 用户认证工具类
 * <p>
 * 基于 Sa-Token 的 StpUtil 进行封装，提供便捷的用户认证操作方法。
 * 当前模块直接使用 StpUtil 进行认证管理，本工具类提供统一的门面接口，
 * 便于后续扩展或替换认证实现。
 * </p>
 */
public class StpUserUtil {

    /**
     * 获取当前登录用户ID
     *
     * @return 用户ID
     */
    public static long getLoginId() {
        return StpUtil.getLoginIdAsLong();
    }

    /**
     * 判断当前会话是否已登录
     *
     * @return true-已登录，false-未登录
     */
    public static boolean isLogin() {
        return StpUtil.isLogin();
    }

    /**
     * 登录指定用户
     *
     * @param userId 用户ID
     */
    public static void login(Long userId) {
        StpUtil.login(userId);
    }

    /**
     * 当前会话登出
     */
    public static void logout() {
        StpUtil.logout();
    }

    /**
     * 获取当前会话的token值
     *
     * @return token字符串
     */
    public static String getTokenValue() {
        return StpUtil.getTokenValue();
    }

    /**
     * 获取当前会话的token信息
     *
     * @return token信息
     */
    public static cn.dev33.satoken.stp.SaTokenInfo getTokenInfo() {
        return StpUtil.getTokenInfo();
    }
}