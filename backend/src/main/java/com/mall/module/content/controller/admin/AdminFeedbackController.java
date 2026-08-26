package com.mall.module.content.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.user.entity.Feedback;
import com.mall.module.user.mapper.FeedbackMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 反馈管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/feedback")
@SaCheckRole("admin")
public class AdminFeedbackController {

    @Autowired
    private FeedbackMapper feedbackMapper;

    /**
     * 反馈列表
     *
     * @param params 查询参数（page, size, status）
     * @return 分页结果
     */
    @GetMapping("/list")
    public IPage<Feedback> list(@RequestParam Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;

        Page<Feedback> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Feedback> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Feedback::getDeleted, 0);

        if (params.get("status") != null) {
            wrapper.eq(Feedback::getStatus, Integer.valueOf(params.get("status").toString()));
        }

        wrapper.orderByDesc(Feedback::getCreatedAt);
        return feedbackMapper.selectPage(pageParam, wrapper);
    }

    /**
     * 回复反馈
     *
     * @param params 请求参数（id, reply）
     * @return 操作结果
     */
    @PostMapping("/reply")
    public Map<String, Object> reply(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        String reply = (String) params.get("reply");

        Feedback feedback = feedbackMapper.selectById(id);
        if (feedback != null) {
            feedback.setReply(reply);
            feedback.setStatus(1); // 已处理
            feedback.setUpdatedAt(LocalDateTime.now());
            feedbackMapper.updateById(feedback);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "回复成功");
        return result;
    }
}