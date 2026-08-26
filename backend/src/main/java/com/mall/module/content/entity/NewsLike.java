package com.mall.module.content.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 资讯点赞/收藏记录实体类
 */
@Data
@TableName("news_like")
public class NewsLike {

    /** 记录ID */
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 资讯ID */
    private Long newsId;

    /** 类型：like-点赞 favorite-收藏 */
    private String type;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}