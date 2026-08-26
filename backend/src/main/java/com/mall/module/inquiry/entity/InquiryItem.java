package com.mall.module.inquiry.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 询价单明细实体类
 */
@Data
@TableName("inquiry_item")
public class InquiryItem {

    /** 明细ID */
    private Long id;

    /** 询价单ID */
    private Long inquiryId;

    /** 产品ID */
    private Long productId;

    /** 产品型号 */
    private String partNo;

    /** 数量 */
    private Integer quantity;

    /** 目标单价 */
    private BigDecimal targetPrice;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}