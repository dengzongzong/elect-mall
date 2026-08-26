package com.mall.module.auth.service;

import com.mall.module.auth.entity.AdminUser;

/**
 * 管理员用户服务接口
 */
public interface AdminUserService {

    /**
     * 根据用户名查找管理员
     *
     * @param username 用户名
     * @return 管理员用户
     */
    AdminUser findByUsername(String username);

    /**
     * 根据ID查找管理员
     *
     * @param id 管理员ID
     * @return 管理员用户
     */
    AdminUser findById(Long id);
}