package com.mall.module.order.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.order.entity.Order;
import com.mall.module.order.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 订单管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/order")
@SaCheckRole("admin")
public class AdminOrderController {

    @Autowired
    private OrderService orderService;

    /**
     * 订单分页列表
     *
     * @param params 查询参数（page, size, status, keyword）
     * @return 分页结果
     */
    @PostMapping("/page")
    public IPage<Order> page(@RequestBody Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;
        Page<Order> pageParam = new Page<>(page, size);
        return orderService.adminPage(pageParam, params);
    }

    /**
     * 审核订单（待审核 -> 待付款）
     *
     * @param params 请求参数：id
     * @return 操作结果
     */
    @PostMapping("/audit")
    public Map<String, Object> audit(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        orderService.adminAudit(id);

        Map<String, Object> result = new java.util.HashMap<>();
        result.put("success", true);
        result.put("message", "审核通过");
        return result;
    }

    /**
     * 发货（待发货 -> 待收货）
     *
     * @param params 请求参数：id
     * @return 操作结果
     */
    @PostMapping("/ship")
    public Map<String, Object> ship(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        orderService.adminShip(id);

        Map<String, Object> result = new java.util.HashMap<>();
        result.put("success", true);
        result.put("message", "发货成功");
        return result;
    }
}