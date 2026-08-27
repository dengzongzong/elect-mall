package com.mall.module.product.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.common.Result;
import com.mall.module.product.entity.AttrFieldDef;
import com.mall.module.product.entity.Category;
import com.mall.module.product.mapper.CategoryMapper;
import com.mall.module.product.service.AttrFieldDefService;
import com.mall.module.product.service.CategoryService;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 分类管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/category")
@SaCheckRole("admin")
public class AdminCategoryController {

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private AttrFieldDefService attrFieldDefService;

    @Autowired
    private CategoryMapper categoryMapper;

    /**
     * 分类列表（管理端）
     */
    @GetMapping("/list")
    public Result<List<Category>> list() {
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Category::getDeleted, 0);
        wrapper.orderByAsc(Category::getSort);
        return Result.success(categoryMapper.selectList(wrapper));
    }

    /**
     * 新增分类
     */
    @PostMapping({"/save", "/add"})
    public Result<Void> save(@RequestBody Category category) {
        categoryService.save(category);
        return Result.success();
    }

    /**
     * 更新分类
     */
    @PutMapping("/update")
    public Result<Void> update(@RequestBody Category category) {
        categoryService.update(category);
        return Result.success();
    }

    /**
     * 删除分类（逻辑删除）
     */
    @DeleteMapping({"/{id}", "/delete"})
    public Result<Void> delete(@PathVariable(required = false) Long id, @RequestBody(required = false) Map<String, Object> body) {
        if (id == null && body != null && body.containsKey("id")) {
            id = Long.valueOf(body.get("id").toString());
        }
        categoryService.delete(id);
        return Result.success();
    }

    /**
     * 保存属性字段定义，并动态创建属性表
     * 请求体包含：categoryId, tableName, fields（字段定义列表）
     */
    @PostMapping("/attr/save")
    public Result<Void> saveAttr(@RequestBody AttrSaveRequest request) {
        // 创建属性表（内部会先保存字段定义，再执行DDL建表）
        attrFieldDefService.createAttrTable(request.getCategoryId(), request.getTableName(), request.getFields());

        // 更新分类的 attrTable 字段
        Category category = categoryService.findById(request.getCategoryId());
        if (category != null) {
            category.setAttrTable(request.getTableName());
            categoryService.update(category);
        }
        return Result.success();
    }

    /**
     * 获取某个分类的属性字段定义
     */
    @GetMapping("/attr/{categoryId}")
    public Result<List<AttrFieldDef>> getAttr(@PathVariable Long categoryId) {
        return Result.success(attrFieldDefService.findByCategoryId(categoryId));
    }

    /**
     * 属性保存请求体
     */
    @Data
    public static class AttrSaveRequest {
        private Long categoryId;
        private String tableName;
        private List<AttrFieldDef> fields;
    }
}
