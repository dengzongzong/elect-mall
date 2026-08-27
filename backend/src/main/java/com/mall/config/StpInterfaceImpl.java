package com.mall.config;

import cn.dev33.satoken.stp.StpInterface;
import cn.dev33.satoken.stp.StpUtil;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Sa-Token 权限认证接口实现
 *
 * <p>提供用户角色和权限的获取逻辑，支持 @SaCheckRole 和 @SaCheckPermission 注解鉴权。</p>
 */
@Component
public class StpInterfaceImpl implements StpInterface {

    @Override
    public List<String> getPermissionList(Object loginId, String loginType) {
        // 暂未实现细粒度权限，返回空列表
        return new ArrayList<>();
    }

    @Override
    public List<String> getRoleList(Object loginId, String loginType) {
        List<String> list = new ArrayList<>();
        // 从 Sa-Token 会话中获取角色
        Object role = StpUtil.getSession().get("role");
        if (role != null) {
            list.add(role.toString());
        }
        return list;
    }
}