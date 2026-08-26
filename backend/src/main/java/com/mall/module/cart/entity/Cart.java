package com.mall.module.cart.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 购物车实体类
 */
@Data
@TableName("cart")
public class Cart {

    /** 购物车ID */
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 产品ID */
    private Long productId;

    /** 数量 */
    private Integer quantity;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}