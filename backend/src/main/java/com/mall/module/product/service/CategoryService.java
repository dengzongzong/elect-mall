package com.mall.module.product.service;

import com.mall.module.product.entity.Category;

import java.util.List;

/**
 * 分类 Service 接口
 */
public interface CategoryService {

    /**
     * 获取分类树（顶级->子级）
     */
    List<Category> treeList();

    /**
     * 根据ID查询分类
     */
    Category findById(Long id);

    /**
     * 新增分类
     */
    void save(Category category);

    /**
     * 更新分类
     */
    void update(Category category);

    /**
     * 删除分类（逻辑删除）
     */
    void delete(Long id);

    /**
     * 根据前缀查询分类
     */
    Category findByPrefix(String prefix);
}