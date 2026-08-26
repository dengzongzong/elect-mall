package com.mall.module.user.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户反馈实体类
 */
@Data
@TableName("feedback")
public class Feedback {

    /** 反馈ID */
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 反馈类型：建议/投诉 */
    private String type;

    /** 反馈内容 */
    private String content;

    /** 管理员回复 */
    private String reply;

    /** 处理状态：0-待处理 1-已处理 */
    private Integer status;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}