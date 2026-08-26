package com.mall.module.product.dto;

import lombok.Data;

import java.util.Map;

/**
 * 商品查询参数 DTO
 */
@Data
public class ProductQuery {

    /** 分类ID */
    private Long categoryId;

    /** 品牌ID */
    private Long brandId;

    /** 搜索关键词（模糊匹配料号/名称） */
    private String keyword;

    /** 商品状态：0-下架，1-上架 */
    private Integer status;

    /** 当前页码，默认1 */
    private Integer page = 1;

    /** 每页条数，默认20 */
    private Integer size = 20;

    /** 排序字段 */
    private String orderBy;

    /** 排序方向：asc/desc */
    private String orderDir;

    /** 属性过滤条件，key=fieldName, value=filterValue */
    private Map<String, String> attrFilters;
}