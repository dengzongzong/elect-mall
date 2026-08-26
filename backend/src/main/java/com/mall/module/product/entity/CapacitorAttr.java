package com.mall.module.product.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 电容属性实体
 */
@Data
@TableName("capacitor_attr")
public class CapacitorAttr {

    @TableId
    private Long id;

    /** 商品ID */
    private Long productId;

    /** 电容值 */
    private String capacitance;

    /** 容差 */
    private String tolerance;

    /** 额定电压 */
    private String voltageRating;

    /** 封装（package为MySQL保留字，使用反引号转义） */
    @TableField("`package`")
    private String packageField;

    /** 材质 */
    private String material;

    /** 温度范围 */
    private String temperatureRange;
}