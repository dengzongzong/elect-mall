package com.mall.module.admin.service;

import com.mall.module.admin.entity.SmsConfig;
import com.mall.module.admin.entity.SysConfig;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 系统管理 Service 接口
 */
public interface AdminService {

    // ========== 短信配置 ==========

    /**
     * 获取所有短信配置
     *
     * @return 短信配置列表
     */
    List<SmsConfig> getSmsConfigs();

    /**
     * 更新短信配置
     *
     * @param config 短信配置
     */
    void updateSmsConfig(SmsConfig config);

    // ========== 系统配置 ==========

    /**
     * 获取所有系统配置
     *
     * @return 系统配置列表
     */
    List<SysConfig> getConfigs();

    /**
     * 更新系统配置
     *
     * @param config 系统配置
     */
    void updateConfig(SysConfig config);

    // ========== 仪表盘 ==========

    /**
     * 获取仪表盘统计数据
     *
     * @return 统计数据
     */
    Map<String, Object> getDashboardStats();

    // ========== 文件上传 ==========

    /**
     * 上传文件
     *
     * @param file 上传的文件
     * @param type 文件类型（image/file）
     * @return 文件URL
     */
    String uploadFile(MultipartFile file, String type);
}