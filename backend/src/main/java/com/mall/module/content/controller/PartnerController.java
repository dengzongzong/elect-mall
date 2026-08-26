package com.mall.module.content.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.content.entity.PartnerApply;
import com.mall.module.content.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 合作伙伴申请控制器（需登录）
 */
@RestController
@RequestMapping("/api/partner")
@SaCheckLogin
public class PartnerController {

    @Autowired
    private ContentService contentService;

    /**
     * 提交合作伙伴申请
     *
     * @param params 请求参数（companyName, category, contact, phone, remark）
     * @return 操作结果
     */
    @PostMapping("/apply")
    public Map<String, Object> apply(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();

        PartnerApply apply = new PartnerApply();
        apply.setUserId(userId);
        apply.setCompanyName((String) params.get("companyName"));
        apply.setCategory((String) params.get("category"));
        apply.setContact((String) params.get("contact"));
        apply.setPhone((String) params.get("phone"));
        apply.setRemark((String) params.get("remark"));
        contentService.submitPartnerApply(apply);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "申请提交成功");
        return result;
    }
}