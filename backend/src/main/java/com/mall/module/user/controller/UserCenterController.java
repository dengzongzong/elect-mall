package com.mall.module.user.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.auth.entity.User;
import com.mall.module.user.service.UserCenterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 用户中心控制器（需登录）
 */
@RestController
@RequestMapping("/api/user")
@SaCheckLogin
public class UserCenterController {

    @Autowired
    private UserCenterService userCenterService;

    /**
     * 获取用户个人信息
     *
     * @return 用户信息
     */
    @GetMapping("/info")
    public User getInfo() {
        long userId = StpUtil.getLoginIdAsLong();
        return userCenterService.getProfile(userId);
    }

    /**
     * 更新用户个人信息
     *
     * @param user 用户信息
     * @return 操作结果
     */
    @PutMapping("/info")
    public Map<String, Object> updateInfo(@RequestBody User user) {
        long userId = StpUtil.getLoginIdAsLong();
        user.setId(userId);
        userCenterService.updateProfile(user);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    /**
     * 修改密码
     *
     * @param params 请求参数（oldPassword, newPassword）
     * @return 操作结果
     */
    @PostMapping("/change-password")
    public Map<String, Object> changePassword(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();
        String oldPassword = (String) params.get("oldPassword");
        String newPassword = (String) params.get("newPassword");
        userCenterService.changePassword(userId, oldPassword, newPassword);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "密码修改成功");
        return result;
    }

    /**
     * 绑定微信
     *
     * @param params 请求参数（openid）
     * @return 操作结果
     */
    @PostMapping("/bind-wechat")
    public Map<String, Object> bindWechat(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();
        String openid = (String) params.get("openid");
        userCenterService.bindWechat(userId, openid);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "微信绑定成功");
        return result;
    }

    /**
     * 申请注销账号
     *
     * @return 操作结果
     */
    @PostMapping("/logout-apply")
    public Map<String, Object> logoutApply() {
        long userId = StpUtil.getLoginIdAsLong();
        userCenterService.logoutApply(userId);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "注销申请已提交");
        return result;
    }
}