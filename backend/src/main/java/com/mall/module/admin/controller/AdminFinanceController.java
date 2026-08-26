package com.mall.module.admin.controller;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.order.entity.Order;
import com.mall.module.order.mapper.OrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 财务管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/finance")
@SaCheckRole("admin")
public class AdminFinanceController {

    @Autowired
    private OrderMapper orderMapper;

    /**
     * 财务列表（订单流水）
     *
     * @param params 查询参数（page, size, status, keyword）
     * @return 分页结果
     */
    @GetMapping("/list")
    public IPage<Order> list(@RequestParam Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;

        Page<Order> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getDeleted, 0);

        String status = (String) params.get("status");
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Order::getStatus, status);
        }

        String keyword = (String) params.get("keyword");
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Order::getOrderNo, keyword);
        }

        wrapper.orderByDesc(Order::getCreatedAt);
        return orderMapper.selectPage(pageParam, wrapper);
    }

    /**
     * 退款（模拟）
     *
     * @param params 请求参数（id, reason）
     * @return 操作结果
     */
    @PostMapping("/refund")
    public Map<String, Object> refund(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        String reason = (String) params.get("reason");

        Order order = orderMapper.selectById(id);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }

        // 模拟退款：将订单状态改为"已取消"
        order.setStatus("已取消");
        order.setUpdatedAt(LocalDateTime.now());
        orderMapper.updateById(order);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "退款成功，原因：" + reason);
        return result;
    }
}