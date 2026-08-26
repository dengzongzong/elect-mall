package com.mall.module.content.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.mall.module.content.entity.CooperateBrand;
import com.mall.module.content.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 合作品牌管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/cooperate")
@SaCheckRole("admin")
public class AdminCooperateController {

    @Autowired
    private ContentService contentService;

    /**
     * 合作品牌列表（含隐藏的）
     *
     * @return 合作品牌列表
     */
    @GetMapping("/list")
    public List<CooperateBrand> list() {
        return contentService.listCooperateBrands();
    }

    /**
     * 新增/更新合作品牌
     *
     * @param brand 合作品牌实体
     * @return 操作结果
     */
    @PostMapping("/save")
    public Map<String, Object> save(@RequestBody CooperateBrand brand) {
        contentService.saveCooperateBrand(brand);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "保存成功");
        return result;
    }
}