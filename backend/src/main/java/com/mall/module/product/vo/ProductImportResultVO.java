package com.mall.module.product.vo;

import lombok.Data;

/**
 * 商品导入结果 VO
 */
@Data
public class ProductImportResultVO {

    /** 导入成功数量 */
    private Integer successCount;

    /** 导入失败数量 */
    private Integer failCount;

    /** 失败详情文件下载URL */
    private String failDetailUrl;
}