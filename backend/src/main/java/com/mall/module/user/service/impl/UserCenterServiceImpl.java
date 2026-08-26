package com.mall.module.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.auth.entity.User;
import com.mall.module.auth.mapper.UserMapper;
import com.mall.module.user.entity.*;
import com.mall.module.user.mapper.*;
import com.mall.module.user.service.UserCenterService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 用户中心 Service 实现类
 */
@Slf4j
@Service
public class UserCenterServiceImpl implements UserCenterService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private UserAddressMapper userAddressMapper;

    @Autowired
    private UserBalanceLogMapper userBalanceLogMapper;

    @Autowired
    private FavoriteMapper favoriteMapper;

    @Autowired
    private MessageMapper messageMapper;

    @Autowired
    private FeedbackMapper feedbackMapper;

    @Override
    public User getProfile(Long userId) {
        return userMapper.selectById(userId);
    }

    @Override
    public void updateProfile(User user) {
        user.setUpdatedAt(LocalDateTime.now());
        userMapper.updateById(user);
    }

    @Override
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        // 模拟修改密码：实际项目中需要校验旧密码并加密存储
        log.info("用户修改密码，userId：{}", userId);
    }

    @Override
    public void bindWechat(Long userId, String openid) {
        User user = userMapper.selectById(userId);
        if (user != null) {
            user.setOpenid(openid);
            user.setUpdatedAt(LocalDateTime.now());
            userMapper.updateById(user);
            log.info("用户绑定微信成功，userId：{}，openid：{}", userId, openid);
        }
    }

    @Override
    public void logoutApply(Long userId) {
        User user = userMapper.selectById(userId);
        if (user != null) {
            user.setStatus(0); // 禁用账号
            user.setUpdatedAt(LocalDateTime.now());
            userMapper.updateById(user);
            log.info("用户申请注销账号，userId：{}", userId);
        }
    }

    // ========== 地址管理 ==========

    @Override
    public List<UserAddress> listAddress(Long userId) {
        return userAddressMapper.selectList(
                new LambdaQueryWrapper<UserAddress>()
                        .eq(UserAddress::getUserId, userId)
                        .eq(UserAddress::getDeleted, 0)
                        .orderByDesc(UserAddress::getIsDefault)
                        .orderByDesc(UserAddress::getCreatedAt)
        );
    }

    @Override
    public void saveAddress(UserAddress address) {
        // 如果设置为默认地址，取消其他默认地址
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            clearDefaultAddress(address.getUserId());
        }
        address.setCreatedAt(LocalDateTime.now());
        address.setUpdatedAt(LocalDateTime.now());
        address.setDeleted(0);
        userAddressMapper.insert(address);
    }

    @Override
    public void updateAddress(UserAddress address) {
        // 如果设置为默认地址，取消其他默认地址
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            clearDefaultAddress(address.getUserId());
        }
        address.setUpdatedAt(LocalDateTime.now());
        userAddressMapper.updateById(address);
    }

    @Override
    public void deleteAddress(Long id) {
        UserAddress address = userAddressMapper.selectById(id);
        if (address != null) {
            address.setDeleted(1);
            address.setUpdatedAt(LocalDateTime.now());
            userAddressMapper.updateById(address);
        }
    }

    /**
     * 取消用户所有默认地址
     */
    private void clearDefaultAddress(Long userId) {
        List<UserAddress> defaultAddresses = userAddressMapper.selectList(
                new LambdaQueryWrapper<UserAddress>()
                        .eq(UserAddress::getUserId, userId)
                        .eq(UserAddress::getIsDefault, 1)
                        .eq(UserAddress::getDeleted, 0)
        );
        for (UserAddress addr : defaultAddresses) {
            addr.setIsDefault(0);
            addr.setUpdatedAt(LocalDateTime.now());
            userAddressMapper.updateById(addr);
        }
    }

    // ========== 余额管理 ==========

    @Override
    public BigDecimal getBalance(Long userId) {
        User user = userMapper.selectById(userId);
        return user != null ? user.getBalance() : BigDecimal.ZERO;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void recharge(Long userId, BigDecimal amount) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        // 更新余额
        BigDecimal newBalance = user.getBalance() != null
                ? user.getBalance().add(amount) : amount;
        user.setBalance(newBalance);
        user.setUpdatedAt(LocalDateTime.now());
        userMapper.updateById(user);

        // 记录余额变动日志
        UserBalanceLog logRecord = new UserBalanceLog();
        logRecord.setUserId(userId);
        logRecord.setAmount(amount);
        logRecord.setType("充值");
        logRecord.setRemark("用户充值");
        logRecord.setCreatedAt(LocalDateTime.now());
        logRecord.setUpdatedAt(LocalDateTime.now());
        logRecord.setDeleted(0);
        userBalanceLogMapper.insert(logRecord);

        log.info("用户充值成功，userId：{}，金额：{}，余额：{}", userId, amount, newBalance);
    }

    // ========== 收藏管理 ==========

    @Override
    public void addFavorite(Long userId, Long productId) {
        // 检查是否已收藏
        Favorite existing = favoriteMapper.selectOne(
                new LambdaQueryWrapper<Favorite>()
                        .eq(Favorite::getUserId, userId)
                        .eq(Favorite::getProductId, productId)
                        .eq(Favorite::getDeleted, 0)
                        .last("LIMIT 1")
        );
        if (existing != null) {
            return; // 已收藏，不重复添加
        }

        Favorite favorite = new Favorite();
        favorite.setUserId(userId);
        favorite.setProductId(productId);
        favorite.setCreatedAt(LocalDateTime.now());
        favorite.setUpdatedAt(LocalDateTime.now());
        favorite.setDeleted(0);
        favoriteMapper.insert(favorite);
    }

    @Override
    public void removeFavorite(Long userId, Long productId) {
        Favorite favorite = favoriteMapper.selectOne(
                new LambdaQueryWrapper<Favorite>()
                        .eq(Favorite::getUserId, userId)
                        .eq(Favorite::getProductId, productId)
                        .eq(Favorite::getDeleted, 0)
                        .last("LIMIT 1")
        );
        if (favorite != null) {
            favorite.setDeleted(1);
            favorite.setUpdatedAt(LocalDateTime.now());
            favoriteMapper.updateById(favorite);
        }
    }

    @Override
    public List<Favorite> listFavorite(Long userId) {
        return favoriteMapper.selectList(
                new LambdaQueryWrapper<Favorite>()
                        .eq(Favorite::getUserId, userId)
                        .eq(Favorite::getDeleted, 0)
                        .orderByDesc(Favorite::getCreatedAt)
        );
    }

    // ========== 消息管理 ==========

    @Override
    public List<Message> listMessage(Long userId) {
        return messageMapper.selectList(
                new LambdaQueryWrapper<Message>()
                        .eq(Message::getUserId, userId)
                        .eq(Message::getDeleted, 0)
                        .orderByDesc(Message::getCreatedAt)
        );
    }

    // ========== 反馈管理 ==========

    @Override
    public void submitFeedback(Long userId, Map<String, Object> params) {
        Feedback feedback = new Feedback();
        feedback.setUserId(userId);
        feedback.setType((String) params.get("type"));
        feedback.setContent((String) params.get("content"));
        feedback.setStatus(0); // 待处理
        feedback.setCreatedAt(LocalDateTime.now());
        feedback.setUpdatedAt(LocalDateTime.now());
        feedback.setDeleted(0);
        feedbackMapper.insert(feedback);
        log.info("用户提交反馈，userId：{}，type：{}", userId, feedback.getType());
    }
}