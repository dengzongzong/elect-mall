package com.mall.module.product.service;

import com.mall.module.product.entity.AttrFieldDef;

import java.util.List;

/**
 * 属性字段定义 Service 接口
 */
public interface AttrFieldDefService {

    /**
     * 根据分类ID查询属性字段定义
     */
    List<AttrFieldDef> findByCategoryId(Long categoryId);

    /**
     * 批量保存属性字段定义
     */
    void saveAll(Long categoryId, List<AttrFieldDef> fields);

    /**
     * 动态创建属性表
     *
     * @param categoryId 分类ID
     * @param tableName  表名
     * @param fields     字段定义列表
     */
    void createAttrTable(Long categoryId, String tableName, List<AttrFieldDef> fields);
}