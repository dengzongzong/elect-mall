package com.mall.module.inquiry.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.inquiry.entity.Inquiry;
import com.mall.module.inquiry.service.InquiryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 询价单管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/inquiry")
@SaCheckRole("admin")
public class AdminInquiryController {

    @Autowired
    private InquiryService inquiryService;

    /**
     * 询价单分页列表
     *
     * @param params 查询参数（page, size, status, keyword）
     * @return 分页结果
     */
    @GetMapping("/page")
    public IPage<Inquiry> page(@RequestParam Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;
        Page<Inquiry> pageParam = new Page<>(page, size);
        return inquiryService.adminPage(pageParam, params);
    }

    /**
     * 回复询价单
     *
     * @param params 请求参数（id, reply）
     * @return 操作结果
     */
    @PostMapping("/reply")
    public Map<String, Object> reply(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        String reply = (String) params.get("reply");
        inquiryService.reply(id, reply);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "回复成功");
        return result;
    }

    /**
     * 发送短信通知（模拟）
     *
     * @param params 请求参数（id）
     * @return 操作结果
     */
    @PostMapping("/send-sms")
    public Map<String, Object> sendSms(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());

        // 模拟发送短信
        Inquiry inquiry = inquiryService.adminPage(new Page<>(1, 1), Map.of()).getRecords().stream()
                .filter(i -> i.getId().equals(id))
                .findFirst().orElse(null);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "短信通知已发送（模拟）");
        if (inquiry != null) {
            result.put("phone", inquiry.getPhone());
        }
        return result;
    }
}