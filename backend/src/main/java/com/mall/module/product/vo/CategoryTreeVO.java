package com.mall.module.product.vo;

import lombok.Data;

import java.util.List;

/**
 * 分类树 VO
 */
@Data
public class CategoryTreeVO {

    private Long id;
    private String name;
    private Long parentId;

    /** 子分类列表 */
    private List<CategoryTreeVO> children;

    /** 属性表名 */
    private String attrTable;

    /** 分类前缀 */
    private String prefix;
}