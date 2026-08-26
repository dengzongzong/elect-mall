package com.mall.module.user.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户收藏实体类
 */
@Data
@TableName("favorite")
public class Favorite {

    /** 收藏ID */
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 产品ID */
    private Long productId;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}