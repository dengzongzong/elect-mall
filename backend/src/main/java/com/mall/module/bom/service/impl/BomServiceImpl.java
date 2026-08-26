package com.mall.module.bom.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.bom.entity.BomItem;
import com.mall.module.bom.entity.BomRecord;
import com.mall.module.bom.mapper.BomItemMapper;
import com.mall.module.bom.mapper.BomRecordMapper;
import com.mall.module.bom.service.BomService;
import com.mall.module.product.entity.Product;
import com.mall.module.product.mapper.ProductMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * BOM清单 Service 实现类
 */
@Slf4j
@Service
public class BomServiceImpl implements BomService {

    @Autowired
    private BomRecordMapper bomRecordMapper;

    @Autowired
    private BomItemMapper bomItemMapper;

    @Autowired
    private ProductMapper productMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public BomRecord match(Long userId, Map<String, Object> params) {
        // 解析物料列表
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> items = (List<Map<String, Object>>) params.get("items");
        if (items == null || items.isEmpty()) {
            throw new RuntimeException("物料列表不能为空");
        }

        // 创建BOM记录
        BomRecord bomRecord = new BomRecord();
        bomRecord.setUserId(userId);
        bomRecord.setTotalCount(items.size());
        bomRecord.setStatus("待报价");
        bomRecord.setCreatedAt(LocalDateTime.now());
        bomRecord.setUpdatedAt(LocalDateTime.now());
        bomRecord.setDeleted(0);
        bomRecordMapper.insert(bomRecord);

        int matchCount = 0;
        BigDecimal totalAmount = BigDecimal.ZERO;

        // 匹配每个物料
        for (Map<String, Object> item : items) {
            String partNo = (String) item.get("partNo");
            Integer quantity = item.get("quantity") != null
                    ? Integer.valueOf(item.get("quantity").toString()) : 1;

            // 按料号匹配商品
            Product product = productMapper.selectOne(
                    new LambdaQueryWrapper<Product>()
                            .eq(Product::getPartNo, partNo)
                            .eq(Product::getDeleted, 0)
                            .eq(Product::getStatus, 1)
                            .last("LIMIT 1")
            );

            BomItem bomItem = new BomItem();
            bomItem.setBomId(bomRecord.getId());
            bomItem.setPartNo(partNo);
            bomItem.setQuantity(quantity);

            if (product != null) {
                bomItem.setProductId(product.getId());
                bomItem.setMatchStatus("已匹配");
                bomItem.setPrice(product.getPrice());
                bomItem.setSubtotal(product.getPrice() != null
                        ? product.getPrice().multiply(BigDecimal.valueOf(quantity))
                        : BigDecimal.ZERO);
                matchCount++;
                if (bomItem.getSubtotal() != null) {
                    totalAmount = totalAmount.add(bomItem.getSubtotal());
                }
            } else {
                bomItem.setMatchStatus("未匹配");
                bomItem.setPrice(BigDecimal.ZERO);
                bomItem.setSubtotal(BigDecimal.ZERO);
            }

            bomItem.setCreatedAt(LocalDateTime.now());
            bomItem.setUpdatedAt(LocalDateTime.now());
            bomItem.setDeleted(0);
            bomItemMapper.insert(bomItem);
        }

        // 更新BOM记录统计
        bomRecord.setMatchCount(matchCount);
        bomRecord.setTotalAmount(totalAmount);
        bomRecord.setUpdatedAt(LocalDateTime.now());
        bomRecordMapper.updateById(bomRecord);

        log.info("BOM匹配完成，记录ID：{}，匹配数：{}/{}", bomRecord.getId(), matchCount, items.size());
        return bomRecord;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public BomRecord upload(Long userId, MultipartFile file) {
        try (InputStream is = file.getInputStream();
             Workbook workbook = new XSSFWorkbook(is)) {

            Sheet sheet = workbook.getSheetAt(0);
            List<Map<String, Object>> items = new ArrayList<>();

            // 从第二行开始读取（第一行为表头）
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                String partNo = getCellValue(row.getCell(0));
                String quantityStr = getCellValue(row.getCell(1));

                if (partNo == null || partNo.isEmpty()) continue;

                Map<String, Object> item = new java.util.HashMap<>();
                item.put("partNo", partNo);
                item.put("quantity", quantityStr != null && !quantityStr.isEmpty()
                        ? Integer.parseInt(quantityStr) : 1);
                items.add(item);
            }

            // 调用匹配逻辑
            Map<String, Object> params = new java.util.HashMap<>();
            params.put("items", items);
            return match(userId, params);

        } catch (Exception e) {
            log.error("BOM文件上传解析失败", e);
            throw new RuntimeException("BOM文件解析失败: " + e.getMessage());
        }
    }

    /**
     * 获取单元格的字符串值
     */
    private String getCellValue(Cell cell) {
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                // 判断是否为日期类型
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getLocalDateTimeCellValue().toString();
                }
                double val = cell.getNumericCellValue();
                if (val == Math.floor(val) && !Double.isInfinite(val)) {
                    return String.valueOf((long) val);
                }
                return String.valueOf(val);
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return null;
        }
    }

    @Override
    public IPage<BomRecord> adminPage(Page<BomRecord> page, Map<String, Object> params) {
        LambdaQueryWrapper<BomRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BomRecord::getDeleted, 0);

        String status = (String) params.get("status");
        if (status != null && !status.isEmpty()) {
            wrapper.eq(BomRecord::getStatus, status);
        }

        wrapper.orderByDesc(BomRecord::getCreatedAt);
        return bomRecordMapper.selectPage(page, wrapper);
    }

    @Override
    public void reply(Long id, String reply) {
        BomRecord bomRecord = bomRecordMapper.selectById(id);
        if (bomRecord == null) {
            throw new RuntimeException("BOM记录不存在");
        }
        bomRecord.setStatus("已报价");
        bomRecord.setUpdatedAt(LocalDateTime.now());
        bomRecordMapper.updateById(bomRecord);
        log.info("BOM清单已回复，ID：{}", id);
    }

    @Override
    public List<BomItem> findItemsByBomId(Long bomId) {
        return bomItemMapper.selectList(
                new LambdaQueryWrapper<BomItem>()
                        .eq(BomItem::getBomId, bomId)
                        .eq(BomItem::getDeleted, 0)
        );
    }
}