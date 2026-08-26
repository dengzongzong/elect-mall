package com.mall.module.order.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 订单明细实体类
 */
@Data
@TableName("order_item")
public class OrderItem {

    /** 明细ID */
    private Long id;

    /** 订单ID */
    private Long orderId;

    /** 产品ID */
    private Long productId;

    /** 产品型号 */
    private String partNo;

    /** 产品名称 */
    private String productName;

    /** 数量 */
    private Integer quantity;

    /** 单价 */
    private BigDecimal price;

    /** 小计金额 */
    private BigDecimal subtotal;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}