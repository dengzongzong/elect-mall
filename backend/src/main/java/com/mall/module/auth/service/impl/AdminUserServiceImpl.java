package com.mall.module.auth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.auth.entity.AdminUser;
import com.mall.module.auth.mapper.AdminUserMapper;
import com.mall.module.auth.service.AdminUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 管理员用户服务实现类
 */
@Service
public class AdminUserServiceImpl implements AdminUserService {

    @Autowired
    private AdminUserMapper adminUserMapper;

    @Override
    public AdminUser findByUsername(String username) {
        LambdaQueryWrapper<AdminUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(AdminUser::getUsername, username)
                .eq(AdminUser::getDeleted, 0);
        return adminUserMapper.selectOne(wrapper);
    }

    @Override
    public AdminUser findById(Long id) {
        return adminUserMapper.selectById(id);
    }
}