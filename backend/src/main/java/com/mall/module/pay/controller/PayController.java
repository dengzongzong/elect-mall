package com.mall.module.pay.controller;

import com.mall.module.pay.service.PayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 支付控制器
 * <p>
 * 统一下单接口需登录，回调接口公开（模拟第三方支付回调）。
 * </p>
 */
@RestController
@RequestMapping("/api/pay")
public class PayController {

    @Autowired
    private PayService payService;

    /**
     * 统一下单
     * <p>
     * 创建支付记录，返回模拟支付URL。
     * </p>
     *
     * @param params 支付参数（orderId, method）
     * @return 支付结果
     */
    @PostMapping("/unified-order")
    public Map<String, Object> unifiedOrder(@RequestBody Map<String, Object> params) {
        return payService.unifiedOrder(params);
    }

    /**
     * 支付回调通知（公开接口，模拟第三方支付回调）
     *
     * @param method 支付方式
     * @param params 回调参数
     * @return 回调处理结果
     */
    @PostMapping("/notify/{method}")
    public Map<String, Object> notify(@PathVariable String method, @RequestBody Map<String, Object> params) {
        return payService.notify(method, params);
    }
}