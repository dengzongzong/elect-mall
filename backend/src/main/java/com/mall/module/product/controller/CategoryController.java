package com.mall.module.product.controller;

import com.mall.module.product.entity.AttrFieldDef;
import com.mall.module.product.entity.Category;
import com.mall.module.product.service.AttrFieldDefService;
import com.mall.module.product.service.CategoryService;
import com.mall.module.product.vo.CategoryTreeVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 分类前端控制器（公开接口）
 */
@RestController
@RequestMapping("/api/category")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private AttrFieldDefService attrFieldDefService;

    /**
     * 公开分类树
     */
    @GetMapping("/list")
    public List<CategoryTreeVO> list() {
        List<Category> tree = categoryService.treeList();
        return tree.stream()
                .map(this::convertToTreeVO)
                .collect(Collectors.toList());
    }

    /**
     * 获取分类的属性字段定义（用于搜索筛选条件）
     */
    @GetMapping("/{id}/attrs")
    public List<AttrFieldDef> attrs(@PathVariable Long id) {
        return attrFieldDefService.findByCategoryId(id);
    }

    /**
     * 将 Category 递归转换为 CategoryTreeVO
     */
    private CategoryTreeVO convertToTreeVO(Category category) {
        CategoryTreeVO vo = new CategoryTreeVO();
        BeanUtils.copyProperties(category, vo);

        if (category.getChildren() != null && !category.getChildren().isEmpty()) {
            List<CategoryTreeVO> children = category.getChildren().stream()
                    .map(this::convertToTreeVO)
                    .collect(Collectors.toList());
            vo.setChildren(children);
        }

        return vo;
    }
}