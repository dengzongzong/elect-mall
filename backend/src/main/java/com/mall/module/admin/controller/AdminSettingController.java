package com.mall.module.admin.controller;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.mall.module.admin.entity.SmsConfig;
import com.mall.module.admin.entity.SysConfig;
import com.mall.module.admin.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统设置控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/setting")
@SaCheckRole("admin")
public class AdminSettingController {

    @Autowired
    private AdminService adminService;

    /**
     * 获取短信配置
     *
     * @return 短信配置列表
     */
    @GetMapping("/sms")
    public List<SmsConfig> getSms() {
        return adminService.getSmsConfigs();
    }

    /**
     * 更新短信配置
     *
     * @param config 短信配置
     * @return 操作结果
     */
    @PutMapping("/sms")
    public Map<String, Object> updateSms(@RequestBody SmsConfig config) {
        adminService.updateSmsConfig(config);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "短信配置更新成功");
        return result;
    }

    /**
     * 获取系统配置
     *
     * @return 系统配置列表
     */
    @GetMapping({"/config", "/list"})
    public List<SysConfig> getConfig() {
        return adminService.getConfigs();
    }

    /**
     * 更新系统配置
     *
     * @param config 系统配置
     * @return 操作结果
     */
    @PutMapping({"/config", "/save"})
    public Map<String, Object> updateConfig(@RequestBody SysConfig config) {
        adminService.updateConfig(config);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "系统配置更新成功");
        return result;
    }
}