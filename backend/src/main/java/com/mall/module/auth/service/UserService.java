package com.mall.module.auth.service;

import com.mall.module.auth.entity.User;

/**
 * 用户服务接口
 */
public interface UserService {

    /**
     * 根据手机号查找用户
     *
     * @param phone 手机号
     * @return 用户
     */
    User findByPhone(String phone);

    /**
     * 根据微信OpenID查找用户
     *
     * @param openid 微信OpenID
     * @return 用户
     */
    User findByOpenid(String openid);

    /**
     * 根据ID查找用户
     *
     * @param id 用户ID
     * @return 用户
     */
    User findById(Long id);

    /**
     * 注册用户
     *
     * @param user 用户实体
     */
    void register(User user);

    /**
     * 更新用户信息
     *
     * @param user 用户实体
     */
    void updateById(User user);
}