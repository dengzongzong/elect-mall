package com.mall.module.product.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 滤波器属性实体
 */
@Data
@TableName("filter_attr")
public class FilterAttr {

    @TableId
    private Long id;

    /** 商品ID */
    private Long productId;

    /** 类型，如 低通/高通/带通 */
    private String type;

    /** 频率 */
    private String frequency;

    /** 插入损耗 */
    private String insertionLoss;

    /** 封装 */
    @TableField("`package`")
    private String packageField;

    /** 工作温度 */
    private String operatingTemp;
}