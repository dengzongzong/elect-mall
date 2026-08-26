package com.mall.module.auth.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 管理员用户实体类
 */
@Data
@TableName("admin_user")
public class AdminUser {
    /** 主键ID */
    private Long id;
    /** 用户名 */
    private String username;
    /** 密码（BCrypt加密） */
    private String password;
    /** 昵称 */
    private String nickname;
    /** 角色 */
    private String role;
    /** 状态：0-禁用，1-启用 */
    private Integer status;
    /** 创建时间 */
    private LocalDateTime createdAt;
    /** 更新时间 */
    private LocalDateTime updatedAt;
    /** 逻辑删除：0-未删除，1-已删除 */
    private Integer deleted;
}