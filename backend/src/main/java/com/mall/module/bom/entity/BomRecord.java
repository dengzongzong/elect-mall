package com.mall.module.bom.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * BOM清单记录实体类
 */
@Data
@TableName("bom_record")
public class BomRecord {

    /** BOM记录ID */
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 匹配数量 */
    private Integer matchCount;

    /** 总物料数 */
    private Integer totalCount;

    /** 总金额 */
    private BigDecimal totalAmount;

    /** 状态 */
    private String status;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}