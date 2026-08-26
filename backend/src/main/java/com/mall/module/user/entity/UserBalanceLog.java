package com.mall.module.user.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 用户余额变动记录实体类
 */
@Data
@TableName("user_balance_log")
public class UserBalanceLog {

    /** 记录ID */
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 变动金额（正数收入/负数支出） */
    private BigDecimal amount;

    /** 变动类型 */
    private String type;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}