package com.mall.module.auth.controller;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 短信服务控制器
 * 模拟短信发送功能，支持验证码发送和缓存管理
 */
@RestController
@RequestMapping("/api/sms")
public class SmsController {

    /**
     * 验证码缓存
     * key: 手机号, value: 验证码, 过期时间: 5分钟
     */
    private final Cache<String, String> smsCodeCache = Caffeine.newBuilder()
            .expireAfterWrite(5, TimeUnit.MINUTES)
            .maximumSize(10000)
            .build();

    /**
     * 发送短信验证码
     * <p>
     * 模拟实现：仅将验证码打印到日志，不实际发送短信。
     * 使用Caffeine缓存管理验证码，有效期5分钟。
     * 同一手机号在缓存有效期内重复调用会覆盖之前的验证码。
     * </p>
     *
     * @param request 请求体，包含 phone 字段
     * @return 发送结果
     */
    @PostMapping("/send")
    public Map<String, Object> send(@RequestBody Map<String, String> request) {
        Map<String, Object> result = new HashMap<>();
        String phone = request.get("phone");

        // 参数校验
        if (phone == null || phone.isEmpty()) {
            result.put("success", false);
            result.put("message", "手机号不能为空");
            return result;
        }

        // 生成随机6位验证码
        String code = String.valueOf((int) ((Math.random() * 900000) + 100000));

        // 存入Caffeine缓存，有效期5分钟
        smsCodeCache.put(phone, code);

        // 模拟发送短信，仅打印日志到控制台
        System.out.println("【短信服务】发送验证码到手机号：" + phone + "，验证码：" + code + "，有效期5分钟");

        result.put("success", true);
        result.put("message", "短信发送成功");
        return result;
    }
}