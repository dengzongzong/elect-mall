package com.mall.module.pay.service;

import java.util.Map;

/**
 * 支付 Service 接口
 */
public interface PayService {

    /**
     * 统一下单（创建支付记录，返回模拟支付URL）
     * <p>
     * 模拟模式：生成支付记录，返回一个模拟的支付页面URL。
     * </p>
     *
     * @param params 支付参数（orderId, method等）
     * @return 包含支付URL的Map
     */
    Map<String, Object> unifiedOrder(Map<String, Object> params);

    /**
     * 支付回调通知（模拟回调）
     * <p>
     * 模拟模式：仅记录日志，更新订单状态为"待发货"。
     * </p>
     *
     * @param method 支付方式
     * @param params 回调参数
     * @return 回调处理结果
     */
    Map<String, Object> notify(String method, Map<String, Object> params);
}