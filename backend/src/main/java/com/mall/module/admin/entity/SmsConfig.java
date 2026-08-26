package com.mall.module.admin.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 短信通知配置实体类
 */
@Data
@TableName("sms_config")
public class SmsConfig {

    /** 配置ID */
    private Long id;

    /** 通知类型 */
    private String type;

    /** 是否启用：1-启用 0-禁用 */
    private Integer enabled;

    /** 接收手机号（多个用逗号分隔） */
    private String phones;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}