package com.mall.module.inquiry.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 询价单实体类
 */
@Data
@TableName("inquiry")
public class Inquiry {

    /** 询价单ID */
    private Long id;

    /** 询价单编号 */
    private String inquiryNo;

    /** 用户ID */
    private Long userId;

    /** 联系人 */
    private String contact;

    /** 联系电话 */
    private String phone;

    /** 备注 */
    private String remark;

    /** 状态 */
    private String status;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}