package com.mall.module.content.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.user.service.UserCenterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 用户反馈控制器（需登录）
 */
@RestController
@RequestMapping("/api/feedback")
@SaCheckLogin
public class FeedbackController {

    @Autowired
    private UserCenterService userCenterService;

    /**
     * 提交反馈
     *
     * @param params 请求参数（type, content）
     * @return 操作结果
     */
    @PostMapping("/submit")
    public Map<String, Object> submit(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();
        userCenterService.submitFeedback(userId, params);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "反馈提交成功");
        return result;
    }
}