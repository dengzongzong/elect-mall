package com.mall.module.order.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.order.entity.Order;
import com.mall.module.order.entity.OrderItem;
import com.mall.module.order.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 订单前端控制器（需登录）
 */
@RestController
@RequestMapping("/api/order")
@SaCheckLogin
public class OrderController {

    @Autowired
    private OrderService orderService;

    /**
     * 创建订单
     *
     * @param params 请求参数：items（商品列表），address（收货地址信息）
     * @return 创建结果
     */
    @PostMapping("/create")
    public Map<String, Object> create(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> items = (List<Map<String, Object>>) params.get("items");

        @SuppressWarnings("unchecked")
        Map<String, Object> address = (Map<String, Object>) params.get("address");

        Order order = orderService.create(userId, items, address);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "订单创建成功");
        result.put("data", order);
        return result;
    }

    /**
     * 获取当前用户订单列表
     *
     * @return 订单列表
     */
    @GetMapping("/list")
    public List<Order> list() {
        long userId = StpUtil.getLoginIdAsLong();
        return orderService.listByUserId(userId);
    }

    /**
     * 获取订单详情
     *
     * @param id 订单ID
     * @return 订单详情（含明细）
     */
    @GetMapping("/{id}")
    public Map<String, Object> detail(@PathVariable Long id) {
        Order order = orderService.findById(id);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        List<OrderItem> items = orderService.findItemsByOrderId(id);

        Map<String, Object> result = new HashMap<>();
        result.put("order", order);
        result.put("items", items);
        return result;
    }

    /**
     * 上传转账凭证
     *
     * @param params 请求参数：id（订单ID），transferVoucher（凭证URL）
     * @return 操作结果
     */
    @PostMapping("/upload-voucher")
    public Map<String, Object> uploadVoucher(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        String transferVoucher = (String) params.get("transferVoucher");

        orderService.uploadVoucher(id, transferVoucher);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "凭证上传成功");
        return result;
    }

    /**
     * 取消订单
     *
     * @param id 订单ID
     * @return 操作结果
     */
    @PostMapping("/cancel/{id}")
    public Map<String, Object> cancel(@PathVariable Long id) {
        long userId = StpUtil.getLoginIdAsLong();
        orderService.cancel(id, userId);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "订单已取消");
        return result;
    }

    /**
     * 确认收货
     *
     * @param id 订单ID
     * @return 操作结果
     */
    @PostMapping("/confirm/{id}")
    public Map<String, Object> confirm(@PathVariable Long id) {
        long userId = StpUtil.getLoginIdAsLong();
        orderService.confirmReceipt(id, userId);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "已确认收货");
        return result;
    }
}