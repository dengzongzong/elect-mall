package com.mall.module.product.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 电感属性实体
 */
@Data
@TableName("inductor_attr")
public class InductorAttr {

    @TableId
    private Long id;

    /** 商品ID */
    private Long productId;

    /** 电感值 */
    private String inductance;

    /** 额定电流 */
    private String ratedCurrent;

    /** 直流电阻 */
    private String dcResistance;

    /** 封装 */
    @TableField("`package`")
    private String packageField;

    /** 类型，如 贴片/插件 */
    private String type;
}