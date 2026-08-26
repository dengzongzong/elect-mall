package com.mall.module.product.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.product.entity.Category;
import com.mall.module.product.mapper.CategoryMapper;
import com.mall.module.product.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 分类 Service 实现类
 */
@Service
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;

    /**
     * 获取分类树（顶级->子级）
     * 构建父子层级关系，parentId为null的为顶级节点
     */
    @Override
    public List<Category> treeList() {
        // 查询所有未删除的分类
        List<Category> all = categoryMapper.selectList(
                new LambdaQueryWrapper<Category>()
                        .eq(Category::getDeleted, 0)
                        .orderByAsc(Category::getSort)
        );

        // 顶级节点（parentId为null）
        List<Category> roots = all.stream()
                .filter(c -> c.getParentId() == null)
                .collect(Collectors.toList());

        // 为每个顶级节点递归构建子节点
        for (Category root : roots) {
            buildChildren(root, all);
        }

        return roots;
    }

    /**
     * 递归构建子分类
     */
    private void buildChildren(Category parent, List<Category> all) {
        List<Category> children = all.stream()
                .filter(c -> parent.getId().equals(c.getParentId()))
                .collect(Collectors.toList());

        if (!children.isEmpty()) {
            parent.setChildren(children);
            for (Category child : children) {
                buildChildren(child, all);
            }
        }
    }

    /**
     * 根据ID查询分类
     */
    @Override
    public Category findById(Long id) {
        return categoryMapper.selectById(id);
    }

    /**
     * 新增分类
     */
    @Override
    public void save(Category category) {
        category.setCreatedAt(LocalDateTime.now());
        category.setUpdatedAt(LocalDateTime.now());
        category.setDeleted(0);
        categoryMapper.insert(category);
    }

    /**
     * 更新分类
     */
    @Override
    public void update(Category category) {
        category.setUpdatedAt(LocalDateTime.now());
        categoryMapper.updateById(category);
    }

    /**
     * 删除分类（逻辑删除）
     */
    @Override
    public void delete(Long id) {
        Category category = categoryMapper.selectById(id);
        if (category != null) {
            category.setDeleted(1);
            category.setUpdatedAt(LocalDateTime.now());
            categoryMapper.updateById(category);
        }
    }

    /**
     * 根据前缀查询分类
     */
    @Override
    public Category findByPrefix(String prefix) {
        return categoryMapper.selectOne(
                new LambdaQueryWrapper<Category>()
                        .eq(Category::getPrefix, prefix)
                        .eq(Category::getDeleted, 0)
                        .last("LIMIT 1")
        );
    }
}