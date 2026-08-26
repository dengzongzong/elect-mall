package com.mall.module.inquiry.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.inquiry.entity.Inquiry;
import com.mall.module.inquiry.service.InquiryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 询价单前端控制器（需登录）
 */
@RestController
@RequestMapping("/api/inquiry")
@SaCheckLogin
public class InquiryController {

    @Autowired
    private InquiryService inquiryService;

    /**
     * 提交询价单
     *
     * @param params 询价参数（contact, phone, remark, items）
     * @return 提交结果
     */
    @PostMapping("/submit")
    public Map<String, Object> submit(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();
        Inquiry inquiry = inquiryService.submit(userId, params);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "询价单提交成功");
        result.put("data", inquiry);
        return result;
    }

    /**
     * 获取当前用户询价单列表
     *
     * @return 询价单列表
     */
    @GetMapping("/list")
    public List<Inquiry> list() {
        long userId = StpUtil.getLoginIdAsLong();
        return inquiryService.listByUser(userId);
    }
}