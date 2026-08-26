package com.mall.module.pay.service.impl;

import com.mall.module.order.entity.Order;
import com.mall.module.order.mapper.OrderMapper;
import com.mall.module.pay.entity.PayRecord;
import com.mall.module.pay.mapper.PayRecordMapper;
import com.mall.module.pay.service.PayService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 支付 Service 实现类（模拟模式）
 * <p>
 * 模拟支付流程：统一下单 -> 返回模拟支付URL -> 回调通知更新订单状态。
 * 实际对接第三方支付时，替换为真实支付SDK调用。
 * </p>
 */
@Slf4j
@Service
public class PayServiceImpl implements PayService {

    @Autowired
    private PayRecordMapper payRecordMapper;

    @Autowired
    private OrderMapper orderMapper;

    /** 每日支付序号生成器 */
    private static final Map<String, AtomicInteger> DAILY_SEQUENCE = new java.util.concurrent.ConcurrentHashMap<>();

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> unifiedOrder(Map<String, Object> params) {
        Long orderId = Long.valueOf(params.get("orderId").toString());
        String method = (String) params.get("method");

        // 查询订单
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }

        // 生成支付编号：PAY + yyyyMMdd + 6位流水号
        String dateStr = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        AtomicInteger seq = DAILY_SEQUENCE.computeIfAbsent(dateStr, k -> new AtomicInteger(0));
        int seqNum = seq.incrementAndGet();
        String payNo = "PAY" + dateStr + String.format("%06d", seqNum);

        // 创建支付记录
        PayRecord payRecord = new PayRecord();
        payRecord.setPayNo(payNo);
        payRecord.setOrderId(order.getId());
        payRecord.setOrderNo(order.getOrderNo());
        payRecord.setAmount(order.getTotalAmount());
        payRecord.setMethod(method);
        payRecord.setStatus("待支付");
        payRecord.setCreatedAt(LocalDateTime.now());
        payRecord.setUpdatedAt(LocalDateTime.now());
        payRecord.setDeleted(0);
        payRecordMapper.insert(payRecord);

        // 模拟支付URL
        String mockPayUrl = "/mock-pay?payNo=" + payNo + "&amount=" + order.getTotalAmount();

        log.info("模拟支付统一下单成功，支付编号：{}，金额：{}，方式：{}", payNo, order.getTotalAmount(), method);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("payNo", payNo);
        result.put("payUrl", mockPayUrl);
        result.put("amount", order.getTotalAmount());
        result.put("message", "统一下单成功");
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> notify(String method, Map<String, Object> params) {
        String payNo = (String) params.get("payNo");
        String tradeNo = (String) params.get("tradeNo");
        BigDecimal amount = params.get("amount") != null
                ? new BigDecimal(params.get("amount").toString())
                : BigDecimal.ZERO;

        log.info("收到模拟支付回调，支付编号：{}，交易号：{}，金额：{}", payNo, tradeNo, amount);

        // 查询支付记录
        PayRecord payRecord = payRecordMapper.selectOne(
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<PayRecord>()
                        .eq(PayRecord::getPayNo, payNo)
                        .eq(PayRecord::getDeleted, 0)
                        .last("LIMIT 1")
        );
        if (payRecord == null) {
            log.warn("支付记录不存在，payNo={}", payNo);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "支付记录不存在");
            return error;
        }

        // 更新支付记录状态
        payRecord.setStatus("已支付");
        payRecord.setPayTime(LocalDateTime.now());
        payRecord.setUpdatedAt(LocalDateTime.now());
        payRecordMapper.updateById(payRecord);

        // 更新订单状态为"待发货"
        Order order = orderMapper.selectById(payRecord.getOrderId());
        if (order != null && "待付款".equals(order.getStatus())) {
            order.setStatus("待发货");
            order.setPaymentMethod(method);
            order.setUpdatedAt(LocalDateTime.now());
            orderMapper.updateById(order);
            log.info("订单状态已更新为待发货，订单编号：{}", order.getOrderNo());
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "支付通知处理成功");
        return result;
    }
}