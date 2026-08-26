package com.mall.module.product.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 商品分类实体
 */
@Data
@TableName("category")
public class Category {

    @TableId
    private Long id;

    /** 分类名称 */
    private String name;

    /** 父级分类ID，顶级分类为null */
    private Long parentId;

    /** 属性表名，如 capacitor_attr */
    private String attrTable;

    /** 分类前缀，用于生成料号 */
    private String prefix;

    /** 排序号 */
    private Integer sort;

    /** 状态：0-禁用，1-启用 */
    private Integer status;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;

    /** 子分类列表（非数据库字段） */
    @TableField(exist = false)
    private java.util.List<Category> children;
}