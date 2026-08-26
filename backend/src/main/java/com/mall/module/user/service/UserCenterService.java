package com.mall.module.user.service;

import com.mall.module.auth.entity.User;
import com.mall.module.user.entity.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 用户中心 Service 接口
 */
public interface UserCenterService {

    /**
     * 获取用户个人信息
     *
     * @param userId 用户ID
     * @return 用户信息
     */
    User getProfile(Long userId);

    /**
     * 更新用户个人信息
     *
     * @param user 用户信息
     */
    void updateProfile(User user);

    /**
     * 修改密码
     *
     * @param userId      用户ID
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     */
    void changePassword(Long userId, String oldPassword, String newPassword);

    /**
     * 绑定微信
     *
     * @param userId 用户ID
     * @param openid 微信OpenID
     */
    void bindWechat(Long userId, String openid);

    /**
     * 申请注销账号
     *
     * @param userId 用户ID
     */
    void logoutApply(Long userId);

    // ========== 地址管理 ==========

    /**
     * 查询用户地址列表
     *
     * @param userId 用户ID
     * @return 地址列表
     */
    List<UserAddress> listAddress(Long userId);

    /**
     * 新增地址
     *
     * @param address 地址实体
     */
    void saveAddress(UserAddress address);

    /**
     * 更新地址
     *
     * @param address 地址实体
     */
    void updateAddress(UserAddress address);

    /**
     * 删除地址
     *
     * @param id 地址ID
     */
    void deleteAddress(Long id);

    // ========== 余额管理 ==========

    /**
     * 获取用户余额
     *
     * @param userId 用户ID
     * @return 余额
     */
    BigDecimal getBalance(Long userId);

    /**
     * 充值
     *
     * @param userId 用户ID
     * @param amount 充值金额
     */
    void recharge(Long userId, BigDecimal amount);

    // ========== 收藏管理 ==========

    /**
     * 添加收藏
     *
     * @param userId    用户ID
     * @param productId 产品ID
     */
    void addFavorite(Long userId, Long productId);

    /**
     * 取消收藏
     *
     * @param userId    用户ID
     * @param productId 产品ID
     */
    void removeFavorite(Long userId, Long productId);

    /**
     * 查询用户收藏列表
     *
     * @param userId 用户ID
     * @return 收藏列表
     */
    List<Favorite> listFavorite(Long userId);

    // ========== 消息管理 ==========

    /**
     * 查询用户消息列表
     *
     * @param userId 用户ID
     * @return 消息列表
     */
    List<Message> listMessage(Long userId);

    // ========== 反馈管理 ==========

    /**
     * 提交反馈
     *
     * @param userId 用户ID
     * @param params 反馈参数
     */
    void submitFeedback(Long userId, Map<String, Object> params);
}