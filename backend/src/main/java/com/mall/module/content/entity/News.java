package com.mall.module.content.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 资讯/新闻实体类
 */
@Data
@TableName("news")
public class News {

    /** 新闻ID */
    private Long id;

    /** 标题 */
    private String title;

    /** 内容 */
    private String content;

    /** 封面图片URL */
    private String image;

    /** 点赞数 */
    private Integer likeCount;

    /** 收藏数 */
    private Integer favoriteCount;

    /** 状态：1-发布 0-草稿 */
    private Integer status;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}