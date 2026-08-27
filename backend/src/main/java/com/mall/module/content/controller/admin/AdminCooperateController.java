package com.mall.module.content.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.content.entity.CooperateBrand;
import com.mall.module.content.mapper.CooperateBrandMapper;
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

    @Autowired
    private CooperateBrandMapper cooperateBrandMapper;

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
     * 新增合作品牌
     *
     * @param brand 合作品牌实体
     * @return 操作结果
     */
    @PostMapping("/add")
    public Map<String, Object> add(@RequestBody CooperateBrand brand) {
        contentService.saveCooperateBrand(brand);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "保存成功");
        return result;
    }

    /**
     * 更新合作品牌
     *
     * @param brand 合作品牌实体
     * @return 操作结果
     */
    @PutMapping("/update")
    public Map<String, Object> update(@RequestBody CooperateBrand brand) {
        cooperateBrandMapper.updateById(brand);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    /**
     * 新增/更新合作品牌（兼容旧接口）
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

    /**
     * 删除合作品牌（逻辑删除）
     *
     * @param body 请求体包含id
     * @return 操作结果
     */
    @DeleteMapping("/delete")
    public Map<String, Object> delete(@RequestBody Map<String, Object> body) {
        Long id = Long.valueOf(body.get("id").toString());
        contentService.deleteCooperateBrand(id);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}