package com.mall.module.content.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 合作品牌展示实体类
 */
@Data
@TableName("cooperate_brand")
public class CooperateBrand {

    /** 合作品牌ID */
    private Long id;

    /** 品牌名称 */
    private String brandName;

    /** 品牌Logo URL */
    private String logo;

    /** 品牌描述 */
    private String description;

    /** 排序 */
    private Integer sort;

    /** 状态：1-显示 0-隐藏 */
    private Integer status;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}