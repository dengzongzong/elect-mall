package com.mall.module.auth.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.auth.dto.BindPhoneRequest;
import com.mall.module.auth.dto.PhoneLoginRequest;
import com.mall.module.auth.dto.WechatLoginRequest;
import com.mall.module.auth.entity.User;
import com.mall.module.auth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 用户认证控制器
 * 处理手机号登录、微信登录、绑定手机号等用户认证相关接口
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    /** 短信验证码缓存（手机号 -> 验证码） */
    private final ConcurrentHashMap<String, String> smsCodeCache = new ConcurrentHashMap<>();

    /** 发送频率限制（手机号 -> 上次发送时间戳） */
    private final ConcurrentHashMap<String, Long> rateLimitCache = new ConcurrentHashMap<>();

    /** 临时Token缓存（tempToken -> openid） */
    private final ConcurrentHashMap<String, String> tempTokenCache = new ConcurrentHashMap<>();

    /** 模拟验证码，始终可用 */
    private static final String MOCK_CODE = "123456";

    /**
     * 发送验证码
     * <p>
     * 模拟实现，仅将验证码打印到日志。
     * 频率限制：同一手机号每分钟最多发送1次。
     * </p>
     *
     * @param request 请求体，包含 phone 字段
     * @return 发送结果
     */
    @PostMapping("/send-code")
    public Map<String, Object> sendCode(@RequestBody Map<String, String> request) {
        String phone = request.get("phone");
        Map<String, Object> result = new HashMap<>();

        // 参数校验
        if (phone == null || phone.isEmpty()) {
            result.put("success", false);
            result.put("message", "手机号不能为空");
            return result;
        }

        // 检查频率限制（60秒内不可重复发送）
        Long lastSendTime = rateLimitCache.get(phone);
        if (lastSendTime != null && (System.currentTimeMillis() - lastSendTime) < 60_000) {
            result.put("success", false);
            result.put("message", "发送太频繁，请60秒后再试");
            return result;
        }

        // 生成随机6位验证码
        String code = String.valueOf((int) ((Math.random() * 900000) + 100000));
        smsCodeCache.put(phone, code);
        rateLimitCache.put(phone, System.currentTimeMillis());

        // 模拟发送短信，仅打印日志到控制台
        System.out.println("【短信验证码】手机号：" + phone + "，验证码：" + code);

        result.put("success", true);
        result.put("message", "验证码发送成功");
        return result;
    }

    /**
     * 手机号验证码登录
     * <p>
     * 使用手机号 + 验证码登录。如果用户不存在，则自动注册新用户。
     * 模拟验证码 123456 始终可用，用于测试。
     * </p>
     *
     * @param request 登录请求体
     * @return 登录结果，包含 token 和用户信息
     */
    @PostMapping("/phone-login")
    public Map<String, Object> phoneLogin(@RequestBody PhoneLoginRequest request) {
        Map<String, Object> result = new HashMap<>();
        String phone = request.getPhone();
        String code = request.getCode();

        // 参数校验
        if (phone == null || phone.isEmpty()) {
            result.put("success", false);
            result.put("message", "手机号不能为空");
            return result;
        }
        if (code == null || code.isEmpty()) {
            result.put("success", false);
            result.put("message", "验证码不能为空");
            return result;
        }

        // 验证验证码：模拟验证码123456始终可用，或使用真实缓存的验证码
        String cachedCode = smsCodeCache.get(phone);
        boolean codeValid = MOCK_CODE.equals(code) || (cachedCode != null && cachedCode.equals(code));
        if (!codeValid) {
            result.put("success", false);
            result.put("message", "验证码错误");
            return result;
        }

        // 查找用户，不存在则自动注册
        User user = userService.findByPhone(phone);
        if (user == null) {
            user = new User();
            user.setPhone(phone);
            // 默认昵称取手机号后4位
            user.setNickname("用户" + phone.substring(Math.max(0, phone.length() - 4)));
            user.setBalance(BigDecimal.ZERO);
            user.setStatus(1);
            user.setCreatedAt(LocalDateTime.now());
            user.setUpdatedAt(LocalDateTime.now());
            user.setDeleted(0);
            userService.register(user);
        }

        // 使用Sa-Token登录
        StpUtil.login(user.getId());

        // 清除验证码缓存和频率限制
        smsCodeCache.remove(phone);
        rateLimitCache.remove(phone);

        result.put("success", true);
        result.put("message", "登录成功");
        result.put("token", StpUtil.getTokenValue());
        result.put("user", user);
        return result;
    }

    /**
     * 微信OAuth登录
     * <p>
     * 模拟微信授权登录。如果用户已绑定手机号则直接登录；
     * 否则返回临时token，前端需引导用户跳转到绑定手机号页面。
     * </p>
     *
     * @param request 微信登录请求体
     * @return 登录结果，包含 needBindPhone 标志和临时token
     */
    @PostMapping("/wechat-login")
    public Map<String, Object> wechatLogin(@RequestBody WechatLoginRequest request) {
        Map<String, Object> result = new HashMap<>();
        String wechatCode = request.getCode();

        if (wechatCode == null || wechatCode.isEmpty()) {
            result.put("success", false);
            result.put("message", "微信授权码不能为空");
            return result;
        }

        // 模拟微信登录，生成临时token和模拟openid
        String tempToken = "temp_" + System.currentTimeMillis() + "_" + wechatCode;
        String mockOpenid = "mock_openid_" + wechatCode;

        // 查找是否已绑定手机号
        User user = userService.findByOpenid(mockOpenid);
        if (user != null && user.getPhone() != null && !user.getPhone().isEmpty()) {
            // 已绑定手机号，直接登录
            StpUtil.login(user.getId());
            result.put("success", true);
            result.put("message", "登录成功");
            result.put("token", StpUtil.getTokenValue());
            result.put("user", user);
            result.put("needBindPhone", false);
        } else {
            // 未绑定手机号，返回临时token
            if (user == null) {
                // 创建临时用户
                user = new User();
                user.setOpenid(mockOpenid);
                user.setNickname("微信用户_" + wechatCode.substring(Math.max(0, wechatCode.length() - 4)));
                user.setBalance(BigDecimal.ZERO);
                user.setStatus(1);
                user.setCreatedAt(LocalDateTime.now());
                user.setUpdatedAt(LocalDateTime.now());
                user.setDeleted(0);
                userService.register(user);
            }
            // 缓存临时token到openid的映射
            tempTokenCache.put(tempToken, mockOpenid);
            result.put("success", true);
            result.put("message", "请绑定手机号");
            result.put("tempToken", tempToken);
            result.put("needBindPhone", true);
        }

        return result;
    }

    /**
     * 绑定手机号
     * <p>
     * 微信登录后，如果未绑定手机号，调用此接口完成绑定。
     * 绑定成功后返回最终登录token。
     * </p>
     *
     * @param request 绑定手机号请求体
     * @return 绑定结果，包含最终token和用户信息
     */
    @PostMapping("/bind-phone")
    public Map<String, Object> bindPhone(@RequestBody BindPhoneRequest request) {
        Map<String, Object> result = new HashMap<>();
        String phone = request.getPhone();
        String code = request.getCode();
        String tempToken = request.getTempToken();

        // 参数校验
        if (phone == null || phone.isEmpty()) {
            result.put("success", false);
            result.put("message", "手机号不能为空");
            return result;
        }
        if (code == null || code.isEmpty()) {
            result.put("success", false);
            result.put("message", "验证码不能为空");
            return result;
        }
        if (tempToken == null || tempToken.isEmpty()) {
            result.put("success", false);
            result.put("message", "临时Token不能为空");
            return result;
        }

        // 验证临时token
        String openid = tempTokenCache.get(tempToken);
        if (openid == null) {
            result.put("success", false);
            result.put("message", "临时Token无效或已过期，请重新微信登录");
            return result;
        }

        // 验证验证码
        String cachedCode = smsCodeCache.get(phone);
        boolean codeValid = MOCK_CODE.equals(code) || (cachedCode != null && cachedCode.equals(code));
        if (!codeValid) {
            result.put("success", false);
            result.put("message", "验证码错误");
            return result;
        }

        // 查找用户并绑定手机号
        User user = userService.findByOpenid(openid);
        if (user == null) {
            result.put("success", false);
            result.put("message", "用户不存在");
            return result;
        }

        // 更新手机号
        user.setPhone(phone);
        user.setUpdatedAt(LocalDateTime.now());
        userService.updateById(user);

        // 登录并返回token
        StpUtil.login(user.getId());

        // 清除缓存
        tempTokenCache.remove(tempToken);
        smsCodeCache.remove(phone);

        result.put("success", true);
        result.put("message", "绑定成功");
        result.put("token", StpUtil.getTokenValue());
        result.put("user", user);
        return result;
    }

    /**
     * 用户登出
     *
     * @return 登出结果
     */
    @PostMapping("/logout")
    @SaCheckLogin
    public Map<String, Object> logout() {
        StpUtil.logout();
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "登出成功");
        return result;
    }

    /**
     * 获取当前登录用户信息
     *
     * @return 用户信息
     */
    @GetMapping("/user-info")
    @SaCheckLogin
    public Map<String, Object> userInfo() {
        Map<String, Object> result = new HashMap<>();
        long userId = StpUtil.getLoginIdAsLong();
        User user = userService.findById(userId);
        if (user == null) {
            result.put("success", false);
            result.put("message", "用户不存在");
            return result;
        }
        result.put("success", true);
        result.put("user", user);
        return result;
    }
}