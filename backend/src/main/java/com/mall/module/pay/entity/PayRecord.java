package com.mall.module.pay.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 支付记录实体类
 */
@Data
@TableName("pay_record")
public class PayRecord {

    /** 支付记录ID */
    private Long id;

    /** 支付编号 */
    private String payNo;

    /** 订单ID */
    private Long orderId;

    /** 订单编号 */
    private String orderNo;

    /** 支付金额 */
    private BigDecimal amount;

    /** 支付方式 */
    private String method;

    /** 支付状态 */
    private String status;

    /** 支付时间 */
    private LocalDateTime payTime;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}