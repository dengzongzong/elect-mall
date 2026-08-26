package com.mall.module.product.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 商品实体
 */
@Data
@TableName("product")
public class Product {

    @TableId
    private Long id;

    /** 分类ID */
    private Long categoryId;

    /** 品牌ID */
    private Long brandId;

    /** 料号（唯一标识） */
    private String partNo;

    /** 商品名称 */
    private String name;

    /** 商品描述 */
    private String description;

    /** 库存数量 */
    private Integer stock;

    /** 价格 */
    private BigDecimal price;

    /** 最小起订量 */
    private Integer minOrder;

    /** 重量 */
    private BigDecimal weight;

    /** 单位，如 pcs/卷 */
    private String unit;

    /** 数据手册URL */
    private String datasheetUrl;

    /** 图片URL */
    private String imageUrl;

    /** 状态：0-下架，1-上架 */
    private Integer status;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}