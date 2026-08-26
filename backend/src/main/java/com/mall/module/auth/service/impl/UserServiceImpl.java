package com.mall.module.auth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.auth.entity.User;
import com.mall.module.auth.mapper.UserMapper;
import com.mall.module.auth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 用户服务实现类
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User findByPhone(String phone) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getPhone, phone)
                .eq(User::getDeleted, 0);
        return userMapper.selectOne(wrapper);
    }

    @Override
    public User findByOpenid(String openid) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getOpenid, openid)
                .eq(User::getDeleted, 0);
        return userMapper.selectOne(wrapper);
    }

    @Override
    public User findById(Long id) {
        return userMapper.selectById(id);
    }

    @Override
    public void register(User user) {
        userMapper.insert(user);
    }

    @Override
    public void updateById(User user) {
        userMapper.updateById(user);
    }
}