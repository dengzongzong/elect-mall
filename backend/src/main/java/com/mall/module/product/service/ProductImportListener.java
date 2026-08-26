package com.mall.module.product.service;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.mall.module.product.entity.Product;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * EasyExcel 导入监听器
 * 逐行读取Excel数据，批量处理商品导入
 */
@Slf4j
public class ProductImportListener extends AnalysisEventListener<Map<Integer, String>> {

    /** 每批处理条数 */
    private static final int BATCH_SIZE = 100;

    /** 当前批次数据 */
    private final List<Map<Integer, String>> batchData = new ArrayList<>();

    /** 分类ID */
    private final Long categoryId;

    /** 是否覆盖模式 */
    private final boolean replaceMode;

    /** 属性字段列表（列名映射） */
    private final List<String> fieldNames;

    /** 商品Service，用于持久化 */
    private final ProductService productService;

    /** 导入成功计数 */
    private int successCount = 0;

    /** 导入失败计数 */
    private int failCount = 0;

    /** 失败详情 */
    private final StringBuilder failDetail = new StringBuilder();

    public ProductImportListener(Long categoryId, boolean replaceMode,
                                  List<String> fieldNames, ProductService productService) {
        this.categoryId = categoryId;
        this.replaceMode = replaceMode;
        this.fieldNames = fieldNames;
        this.productService = productService;
    }

    /**
     * 每读取一行数据时调用
     */
    @Override
    public void invoke(Map<Integer, String> rowData, AnalysisContext context) {
        batchData.add(rowData);

        // 达到批处理数量时，批量保存
        if (batchData.size() >= BATCH_SIZE) {
            processBatch();
        }
    }

    /**
     * 所有数据读取完成后调用
     */
    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        // 处理剩余数据
        if (!batchData.isEmpty()) {
            processBatch();
        }
        log.info("Excel导入完成，成功：{}，失败：{}", successCount, failCount);
    }

    /**
     * 批量处理导入数据
     */
    private void processBatch() {
        // 逐行解析并保存
        for (Map<Integer, String> row : batchData) {
            try {
                // 第一行通常是表头，跳过
                // 构建商品对象
                Product product = new Product();
                product.setCategoryId(categoryId);

                // 解析行数据：第0列是料号(partNo)，第1列是名称(name)，第2列是描述(description)，
                // 后续列是属性字段
                int colIndex = 0;
                String partNo = row.get(colIndex++);
                if (partNo == null || partNo.trim().isEmpty()) {
                    failCount++;
                    failDetail.append("第").append(batchData.indexOf(row) + 2).append("行：料号为空\n");
                    continue;
                }
                product.setPartNo(partNo.trim());

                String name = row.get(colIndex++);
                product.setName(name != null ? name.trim() : partNo);

                String description = row.get(colIndex++);
                product.setDescription(description != null ? description.trim() : "");

                String stockStr = row.get(colIndex++);
                try {
                    product.setStock(stockStr != null && !stockStr.isEmpty() ? Integer.parseInt(stockStr.trim()) : 0);
                } catch (NumberFormatException e) {
                    product.setStock(0);
                }

                String priceStr = row.get(colIndex++);
                try {
                    product.setPrice(priceStr != null && !priceStr.isEmpty() ? new java.math.BigDecimal(priceStr.trim()) : java.math.BigDecimal.ZERO);
                } catch (NumberFormatException e) {
                    product.setPrice(java.math.BigDecimal.ZERO);
                }

                // 解析属性字段
                java.util.Map<String, Object> attrs = new java.util.HashMap<>();
                for (int i = 0; i < fieldNames.size() && colIndex < row.size(); i++) {
                    String value = row.get(colIndex++);
                    if (value != null && !value.trim().isEmpty()) {
                        attrs.put(fieldNames.get(i), value.trim());
                    }
                }

                // 保存或更新商品
                if (replaceMode) {
                    productService.update(product, attrs);
                } else {
                    productService.save(product, attrs);
                }
                successCount++;
            } catch (Exception e) {
                failCount++;
                failDetail.append("第").append(batchData.indexOf(row) + 2).append("行：").append(e.getMessage()).append("\n");
                log.error("导入Excel行数据失败", e);
            }
        }
        batchData.clear();
    }

    public int getSuccessCount() {
        return successCount;
    }

    public int getFailCount() {
        return failCount;
    }

    public String getFailDetail() {
        return failDetail.toString();
    }
}