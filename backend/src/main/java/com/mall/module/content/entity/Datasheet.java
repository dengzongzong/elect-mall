package com.mall.module.content.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 数据手册实体类
 */
@Data
@TableName("datasheet")
public class Datasheet {

    /** 数据手册ID */
    private Long id;

    /** 分类ID */
    private Long categoryId;

    /** 子分类 */
    private String subCategory;

    /** 标题 */
    private String title;

    /** PDF文件URL */
    private String pdfUrl;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}