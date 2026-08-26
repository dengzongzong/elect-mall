package com.mall.module.bom.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.bom.entity.BomRecord;
import com.mall.module.bom.service.BomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * BOM清单前端控制器（需登录）
 */
@RestController
@RequestMapping("/api/bom")
@SaCheckLogin
public class BomController {

    @Autowired
    private BomService bomService;

    /**
     * BOM匹配（文本输入）
     *
     * @param params 匹配参数（items: 物料列表）
     * @return 匹配结果
     */
    @PostMapping("/match")
    public Map<String, Object> match(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();
        BomRecord bomRecord = bomService.match(userId, params);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "BOM匹配完成");
        result.put("data", bomRecord);
        return result;
    }

    /**
     * 上传BOM文件（Excel）
     *
     * @param file Excel文件
     * @return 匹配结果
     */
    @PostMapping("/upload")
    public Map<String, Object> upload(org.springframework.web.multipart.MultipartFile file) {
        long userId = StpUtil.getLoginIdAsLong();
        BomRecord bomRecord = bomService.upload(userId, file);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "BOM上传匹配完成");
        result.put("data", bomRecord);
        return result;
    }
}