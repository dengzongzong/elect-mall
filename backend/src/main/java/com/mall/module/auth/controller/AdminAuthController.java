package com.mall.module.auth.controller;

import cn.dev33.satoken.annotation.SaCheckRole;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.auth.dto.AdminLoginRequest;
import com.mall.module.auth.entity.AdminUser;
import com.mall.module.auth.service.AdminUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 管理员认证控制器
 * 处理管理员登录、登出和信息获取
 */
@RestController
@RequestMapping("/admin/auth")
public class AdminAuthController {

    @Autowired
    private AdminUserService adminUserService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    /**
     * 管理员登录
     * <p>
     * 使用用户名 + 密码登录。密码使用BCrypt进行校验。
     * 登录成功后通过Sa-Token记录会话，并设置角色为"admin"。
     * </p>
     *
     * @param request 管理员登录请求体
     * @return 登录结果，包含token和管理员信息
     */
    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody AdminLoginRequest request) {
        Map<String, Object> result = new HashMap<>();
        String username = request.getUsername();
        String password = request.getPassword();

        // 参数校验
        if (username == null || username.isEmpty()) {
            result.put("success", false);
            result.put("message", "用户名不能为空");
            return result;
        }
        if (password == null || password.isEmpty()) {
            result.put("success", false);
            result.put("message", "密码不能为空");
            return result;
        }

        // 查找管理员
        AdminUser admin = adminUserService.findByUsername(username);
        if (admin == null) {
            result.put("success", false);
            result.put("message", "用户名或密码错误");
            return result;
        }

        // 检查管理员状态
        if (admin.getStatus() == null || admin.getStatus() != 1) {
            result.put("success", false);
            result.put("message", "账号已被禁用，请联系管理员");
            return result;
        }

        // 验证密码（BCrypt）
        if (!passwordEncoder.matches(password, admin.getPassword())) {
            result.put("success", false);
            result.put("message", "用户名或密码错误");
            return result;
        }

        // 使用Sa-Token登录，并设置角色为admin
        StpUtil.login(admin.getId());
        StpUtil.getSession().set("role", "admin");

        result.put("success", true);
        result.put("message", "登录成功");
        result.put("token", StpUtil.getTokenValue());
        // 返回管理员信息时，不返回密码
        admin.setPassword(null);
        result.put("admin", admin);
        return result;
    }

    /**
     * 管理员登出
     *
     * @return 登出结果
     */
    @PostMapping("/logout")
    @SaCheckRole("admin")
    public Map<String, Object> logout() {
        StpUtil.logout();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "登出成功");
        return result;
    }

    /**
     * 获取当前管理员信息
     *
     * @return 管理员信息
     */
    @GetMapping("/info")
    @SaCheckRole("admin")
    public Map<String, Object> info() {
        Map<String, Object> result = new HashMap<>();
        long adminId = StpUtil.getLoginIdAsLong();
        AdminUser admin = adminUserService.findById(adminId);
        if (admin == null) {
            result.put("success", false);
            result.put("message", "管理员不存在");
            return result;
        }
        // 返回管理员信息时，不返回密码
        admin.setPassword(null);
        result.put("success", true);
        result.put("admin", admin);
        return result;
    }
}