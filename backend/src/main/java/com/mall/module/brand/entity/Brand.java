package com.mall.module.brand.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 品牌实体类
 */
@Data
@TableName("brand")
public class Brand {

    /** 品牌ID */
    private Long id;

    /** 品牌名称 */
    private String name;

    /** 品牌Logo URL */
    private String logo;

    /** 品牌描述 */
    private String description;

    /** 排序 */
    private Integer sort;

    /** 状态：1-启用 0-禁用 */
    private Integer status;

    /** 是否合作品牌：1-是 0-否 */
    private Integer isCooperate;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}