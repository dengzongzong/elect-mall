package com.mall.module.product.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * 商品详情 VO
 */
@Data
public class ProductDetailVO {

    private Long id;
    private Long categoryId;
    private Long brandId;
    private String partNo;
    private String name;
    private String description;
    private Integer stock;
    private BigDecimal price;
    private Integer minOrder;
    private BigDecimal weight;
    private String unit;
    private String datasheetUrl;
    private String imageUrl;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /** 品牌名称 */
    private String brandName;

    /** 分类名称 */
    private String categoryName;

    /** 动态属性键值对 */
    private Map<String, Object> attrMap;
}