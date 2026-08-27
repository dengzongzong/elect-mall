package com.mall.module.admin.controller;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.mall.module.admin.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

/**
 * 文件上传控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/upload")
@SaCheckRole("admin")
public class AdminUploadController {

    @Autowired
    private AdminService adminService;

    /**
     * 上传图片
     *
     * @param file 图片文件
     * @return 文件URL
     */
    @PostMapping("/image")
    public Map<String, Object> uploadImage(@RequestParam("file") MultipartFile file) {
        String fileUrl = adminService.uploadFile(file, "image");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("url", fileUrl);
        result.put("message", "上传成功");
        return result;
    }

    /**
     * 上传文件（兼容前端 /admin/upload 路径）
     *
     * @param file 文件
     * @return 文件URL
     */
    @PostMapping({"", "/file"})
    public Map<String, Object> uploadFile(@RequestParam("file") MultipartFile file) {
        String fileUrl = adminService.uploadFile(file, "file");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("url", fileUrl);
        result.put("message", "上传成功");
        return result;
    }
}