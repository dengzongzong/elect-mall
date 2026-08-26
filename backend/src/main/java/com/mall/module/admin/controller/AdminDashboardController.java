package com.mall.module.admin.controller;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.mall.module.admin.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 仪表盘控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/dashboard")
@SaCheckRole("admin")
public class AdminDashboardController {

    @Autowired
    private AdminService adminService;

    /**
     * 获取仪表盘统计数据
     *
     * @return 统计数据
     */
    @GetMapping("/stats")
    public Map<String, Object> stats() {
        return adminService.getDashboardStats();
    }
}