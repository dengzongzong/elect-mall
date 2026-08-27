package com.mall.module.content.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import cn.dev33.satoken.annotation.SaCheckRole;
import com.mall.module.content.entity.Datasheet;
import com.mall.module.content.mapper.DatasheetMapper;
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

    @Autowired
    private DatasheetMapper datasheetMapper;

    /**
     * 数据手册分页列表
     */
    @GetMapping("/list")
    public IPage<Datasheet> list(@RequestParam Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;
        Long categoryId = params.get("categoryId") != null ? Long.valueOf(params.get("categoryId").toString()) : null;

        Page<Datasheet> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Datasheet> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Datasheet::getDeleted, 0);
        if (categoryId != null) {
            wrapper.eq(Datasheet::getCategoryId, categoryId);
        }
        wrapper.orderByDesc(Datasheet::getCreatedAt);
        return datasheetMapper.selectPage(pageParam, wrapper);
    }

    /**
     * 删除数据手册（逻辑删除）
     */
    @DeleteMapping("/delete")
    public Map<String, Object> delete(@RequestBody Map<String, Object> body) {
        Long id = Long.valueOf(body.get("id").toString());
        Datasheet datasheet = new Datasheet();
        datasheet.setId(id);
        datasheet.setDeleted(1);
        datasheetMapper.updateById(datasheet);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }

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