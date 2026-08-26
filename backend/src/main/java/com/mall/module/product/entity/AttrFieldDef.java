package com.mall.module.product.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 属性字段定义实体
 */
@Data
@TableName("attr_field_def")
public class AttrFieldDef {

    @TableId
    private Long id;

    /** 所属分类ID */
    private Long categoryId;

    /** 字段名（英文，对应数据库列名） */
    private String fieldName;

    /** 字段标签（中文显示名） */
    private String fieldLabel;

    /** 字段类型：input/select/boolean */
    private String fieldType;

    /** 选项值，JSON数组，如 ["A","B","C"] */
    private String options;

    /** 是否用于搜索：0-否，1-是 */
    private Integer isSearch;

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
}