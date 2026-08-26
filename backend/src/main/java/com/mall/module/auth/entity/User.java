package com.mall.module.auth.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 用户实体类
 */
@Data
@TableName("user")
public class User {
    /** 主键ID */
    private Long id;
    /** 手机号 */
    private String phone;
    /** 微信OpenID */
    private String openid;
    /** 昵称 */
    private String nickname;
    /** 头像URL */
    private String avatar;
    /** 账户余额 */
    private BigDecimal balance;
    /** 状态：0-禁用，1-启用 */
    private Integer status;
    /** 创建时间 */
    private LocalDateTime createdAt;
    /** 更新时间 */
    private LocalDateTime updatedAt;
    /** 逻辑删除：0-未删除，1-已删除 */
    private Integer deleted;
}