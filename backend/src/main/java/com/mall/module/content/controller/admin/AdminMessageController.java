package com.mall.module.content.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.user.entity.Message;
import com.mall.module.user.mapper.MessageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 站内消息管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/message")
@SaCheckRole("admin")
public class AdminMessageController {

    @Autowired
    private MessageMapper messageMapper;

    /**
     * 发送站内消息
     *
     * @param params 请求参数（userId, title, content）
     * @return 操作结果
     */
    @PostMapping("/send")
    public Map<String, Object> send(@RequestBody Map<String, Object> params) {
        Long userId = Long.valueOf(params.get("userId").toString());
        String title = (String) params.get("title");
        String content = (String) params.get("content");

        Message message = new Message();
        message.setUserId(userId);
        message.setTitle(title);
        message.setContent(content);
        message.setIsRead(0);
        message.setCreatedAt(LocalDateTime.now());
        message.setUpdatedAt(LocalDateTime.now());
        message.setDeleted(0);
        messageMapper.insert(message);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "消息发送成功");
        return result;
    }

    /**
     * 消息列表
     *
     * @param params 查询参数（page, size, userId）
     * @return 分页结果
     */
    @GetMapping("/list")
    public IPage<Message> list(@RequestParam Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;

        Page<Message> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Message> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Message::getDeleted, 0);

        if (params.get("userId") != null) {
            wrapper.eq(Message::getUserId, Long.valueOf(params.get("userId").toString()));
        }

        wrapper.orderByDesc(Message::getCreatedAt);
        return messageMapper.selectPage(pageParam, wrapper);
    }
}