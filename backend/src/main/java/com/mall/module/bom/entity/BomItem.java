package com.mall.module.bom.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * BOM清单明细实体类
 */
@Data
@TableName("bom_item")
public class BomItem {

    /** 明细ID */
    private Long id;

    /** BOM记录ID */
    private Long bomId;

    /** 产品型号 */
    private String partNo;

    /** 数量 */
    private Integer quantity;

    /** 匹配状态 */
    private String matchStatus;

    /** 匹配产品ID */
    private Long productId;

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