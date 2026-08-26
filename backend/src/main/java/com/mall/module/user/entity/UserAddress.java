package com.mall.module.user.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户地址实体类
 */
@Data
@TableName("user_address")
public class UserAddress {

    /** 地址ID */
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 收货人姓名 */
    private String name;

    /** 收货人电话 */
    private String phone;

    /** 省份 */
    private String province;

    /** 城市 */
    private String city;

    /** 区县 */
    private String district;

    /** 详细地址 */
    private String detail;

    /** 是否默认地址：1-是 0-否 */
    private Integer isDefault;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}