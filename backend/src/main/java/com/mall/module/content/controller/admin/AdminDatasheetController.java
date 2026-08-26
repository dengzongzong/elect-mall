package com.mall.module.content.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.mall.module.content.entity.Datasheet;
import com.mall.module.content.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 数据手册管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/datasheet")
@SaCheckRole("admin")
public class AdminDatasheetController {

    @Autowired
    private ContentService contentService;

    /**
     * 新增数据手册
     *
     * @param datasheet 数据手册实体
     * @return 操作结果
     */
    @PostMapping("/save")
    public Map<String, Object> save(@RequestBody Datasheet datasheet) {
        contentService.saveDatasheet(datasheet);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "保存成功");
        return result;
    }
}