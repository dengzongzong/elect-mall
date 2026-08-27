package com.mall.module.product.service.impl;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.write.style.column.LongestMatchColumnWidthStyleStrategy;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.product.dto.ProductQuery;
import com.mall.module.product.entity.AttrFieldDef;
import com.mall.module.product.entity.Category;
import com.mall.module.product.entity.Product;
import com.mall.module.product.mapper.ProductMapper;
import com.mall.module.product.service.AttrFieldDefService;
import com.mall.module.product.service.CategoryService;
import com.mall.module.product.service.ProductImportListener;
import com.mall.module.product.service.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 商品 Service 实现类
 */
@Slf4j
@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private AttrFieldDefService attrFieldDefService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 分页查询商品列表
     */
    @Override
    public IPage<Product> page(Page<Product> page, ProductQuery query) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getDeleted, 0);

        // 按分类筛选
        if (query.getCategoryId() != null) {
            wrapper.eq(Product::getCategoryId, query.getCategoryId());
        }

        // 按品牌筛选
        if (query.getBrandId() != null) {
            wrapper.eq(Product::getBrandId, query.getBrandId());
        }

        // 按状态筛选
        if (query.getStatus() != null) {
            wrapper.eq(Product::getStatus, query.getStatus());
        }

        // 关键词模糊匹配（料号或名称）
        if (query.getKeyword() != null && !query.getKeyword().isEmpty()) {
            wrapper.and(w -> w.like(Product::getPartNo, query.getKeyword())
                    .or()
                    .like(Product::getName, query.getKeyword()));
        }

        // 排序
        if (query.getOrderBy() != null && !query.getOrderBy().isEmpty()) {
            boolean isAsc = "asc".equalsIgnoreCase(query.getOrderDir());
            // 动态排序，使用 wrapper.last 追加 ORDER BY 子句
            wrapper.last("ORDER BY " + query.getOrderBy() + " " + (isAsc ? "ASC" : "DESC"));
        } else {
            // 默认按创建时间倒序
            wrapper.orderByDesc(Product::getCreatedAt);
        }

        return productMapper.selectPage(page, wrapper);
    }

    /**
     * 查询商品详情（含属性、分类、品牌信息）
     */
    @Override
    public Product findDetailById(Long id) {
        return productMapper.selectById(id);
    }

    /**
     * 新增商品（含属性数据）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void save(Product product, Map<String, Object> attrs) {
        product.setCreatedAt(LocalDateTime.now());
        product.setUpdatedAt(LocalDateTime.now());
        product.setDeleted(0);
        if (product.getStatus() == null) {
            product.setStatus(1);
        }
        productMapper.insert(product);

        // 保存属性数据到动态属性表
        saveAttrs(product.getId(), product.getCategoryId(), attrs);
    }

    /**
     * 更新商品（含属性数据）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Product product, Map<String, Object> attrs) {
        product.setUpdatedAt(LocalDateTime.now());
        productMapper.updateById(product);

        // 更新属性数据
        if (attrs != null && !attrs.isEmpty()) {
            saveAttrs(product.getId(), product.getCategoryId(), attrs);
        }
    }

    /**
     * 保存商品属性到动态属性表
     */
    private void saveAttrs(Long productId, Long categoryId, Map<String, Object> attrs) {
        if (attrs == null || attrs.isEmpty()) {
            return;
        }

        // 获取分类对应的属性表名
        Category category = categoryService.findById(categoryId);
        if (category == null || category.getAttrTable() == null) {
            log.warn("分类不存在或未配置属性表，categoryId={}", categoryId);
            return;
        }

        String tableName = category.getAttrTable();

        // 先删除旧属性
        String deleteSql = "DELETE FROM " + tableName + " WHERE product_id = ?";
        jdbcTemplate.update(deleteSql, productId);

        // 构建INSERT语句
        Set<String> colNames = attrs.keySet();
        String cols = String.join(", ", colNames);
        String placeholders = colNames.stream().map(k -> "?").collect(Collectors.joining(", "));

        String insertSql = "INSERT INTO " + tableName + " (product_id, " + cols + ") VALUES (?, " + placeholders + ")";

        List<Object> params = new ArrayList<>();
        params.add(productId);
        for (String key : colNames) {
            params.add(attrs.get(key));
        }

        jdbcTemplate.update(insertSql, params.toArray());
    }

    /**
     * 删除商品（逻辑删除）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        Product product = productMapper.selectById(id);
        if (product != null) {
            product.setDeleted(1);
            product.setUpdatedAt(LocalDateTime.now());
            productMapper.updateById(product);
        }
    }

    /**
     * 从Excel导入商品
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> importExcel(MultipartFile file, Long categoryId, boolean replaceMode) {
        // 获取分类的属性字段定义
        List<AttrFieldDef> attrFields = attrFieldDefService.findByCategoryId(categoryId);
        List<String> fieldNames = attrFields.stream()
                .map(AttrFieldDef::getFieldName)
                .collect(Collectors.toList());

        // 创建监听器处理导入
        ProductImportListener listener = new ProductImportListener(categoryId, replaceMode, fieldNames, this);

        try {
            EasyExcel.read(file.getInputStream(), listener)
                    .headRowNumber(0)
                    .sheet()
                    .doRead();
        } catch (Exception e) {
            log.error("Excel导入失败", e);
            throw new RuntimeException("Excel导入失败: " + e.getMessage(), e);
        }

        // 返回导入结果
        Map<String, Object> result = new HashMap<>();
        result.put("successCount", listener.getSuccessCount());
        result.put("failCount", listener.getFailCount());
        result.put("failDetail", listener.getFailDetail());
        return result;
    }

    /**
     * 导出商品为Excel
     */
    @Override
    public void exportExcel(HttpServletResponse response, Long categoryId) {
        // 查询分类下的商品
        List<Product> products = productMapper.selectList(
                new LambdaQueryWrapper<Product>()
                        .eq(Product::getCategoryId, categoryId)
                        .eq(Product::getDeleted, 0)
        );

        // 获取属性字段定义
        List<AttrFieldDef> attrFields = attrFieldDefService.findByCategoryId(categoryId);

        // 构建导出数据
        List<List<Object>> rows = new ArrayList<>();

        // 构建表头
        List<Object> header = new ArrayList<>();
        header.add("料号(part_no)");
        header.add("名称(name)");
        header.add("描述(description)");
        header.add("库存(stock)");
        header.add("价格(price)");
        header.add("最小起订量(min_order)");
        header.add("单位(unit)");
        for (AttrFieldDef field : attrFields) {
            header.add(field.getFieldLabel() + "(" + field.getFieldName() + ")");
        }
        rows.add(header);

        // 获取分类属性表名
        Category category = categoryService.findById(categoryId);
        String tableName = category != null ? category.getAttrTable() : null;

        // 构建数据行
        for (Product product : products) {
            List<Object> row = new ArrayList<>();
            row.add(product.getPartNo());
            row.add(product.getName());
            row.add(product.getDescription());
            row.add(product.getStock());
            row.add(product.getPrice());
            row.add(product.getMinOrder());
            row.add(product.getUnit());

            // 查询属性数据
            if (tableName != null) {
                try {
                    Map<String, Object> attrRow = jdbcTemplate.queryForMap(
                            "SELECT * FROM " + tableName + " WHERE product_id = ?", product.getId());
                    for (AttrFieldDef field : attrFields) {
                        Object val = attrRow.get(field.getFieldName());
                        row.add(val != null ? val : "");
                    }
                } catch (Exception e) {
                    for (AttrFieldDef ignored : attrFields) {
                        row.add("");
                    }
                }
            } else {
                for (AttrFieldDef ignored : attrFields) {
                    row.add("");
                }
            }
            rows.add(row);
        }

        // 写入Excel
        writeExcel(response, rows, "products_" + categoryId + ".xlsx");
    }

    /**
     * 下载导入模板
     */
    @Override
    public void downloadTemplate(HttpServletResponse response, Long categoryId) {
        // 获取分类的属性字段定义
        List<AttrFieldDef> attrFields = attrFieldDefService.findByCategoryId(categoryId);

        // 构建模板表头
        List<List<Object>> rows = new ArrayList<>();
        List<Object> header = new ArrayList<>();
        header.add("料号(part_no)");
        header.add("名称(name)");
        header.add("描述(description)");
        header.add("库存(stock)");
        header.add("价格(price)");
        header.add("最小起订量(min_order)");
        header.add("单位(unit)");
        for (AttrFieldDef field : attrFields) {
            header.add(field.getFieldLabel() + "(" + field.getFieldName() + ")");
        }
        rows.add(header);

        // 添加一行示例数据
        List<Object> example = new ArrayList<>();
        example.add("CAP-001");
        example.add("示例商品");
        example.add("商品描述");
        example.add("100");
        example.add("0.50");
        example.add("10");
        example.add("pcs");
        for (AttrFieldDef field : attrFields) {
            if ("select".equals(field.getFieldType()) && field.getOptions() != null) {
                // 从选项中取第一个作为示例
                String opt = field.getOptions().replaceAll("[\\[\\]\"]", "");
                example.add(opt.split(",")[0].trim());
            } else {
                example.add("");
            }
        }
        rows.add(example);

        writeExcel(response, rows, "import_template_" + categoryId + ".xlsx");
    }

    /**
     * 写入Excel到响应流
     */
    private void writeExcel(HttpServletResponse response, List<List<Object>> rows, String fileName) {
        try {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("utf-8");
            String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
            response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + encodedFileName);

            EasyExcel.write(response.getOutputStream())
                    .head(getHeadFromRows(rows))
                    .registerWriteHandler(new LongestMatchColumnWidthStyleStrategy())
                    .sheet("Sheet1")
                    .doWrite(getDataFromRows(rows));
        } catch (Exception e) {
            log.error("导出Excel失败", e);
            throw new RuntimeException("导出Excel失败: " + e.getMessage(), e);
        }
    }

    /**
     * 从行数据中提取表头（第一行）
     */
    private List<List<String>> getHeadFromRows(List<List<Object>> rows) {
        List<Object> headerRow = rows.get(0);
        List<List<String>> head = new ArrayList<>();
        for (Object col : headerRow) {
            head.add(Collections.singletonList(col.toString()));
        }
        return head;
    }

    /**
     * 从行数据中提取数据行（除第一行表头外）
     */
    private List<List<Object>> getDataFromRows(List<List<Object>> rows) {
        return rows.subList(1, rows.size());
    }

    /**
     * 推荐相关商品（同分类下）
     */
    @Override
    public List<Product> recommend(Long productId, int limit) {
        Product current = productMapper.selectById(productId);
        if (current == null) {
            return Collections.emptyList();
        }

        return productMapper.selectList(
                new LambdaQueryWrapper<Product>()
                        .eq(Product::getCategoryId, current.getCategoryId())
                        .eq(Product::getDeleted, 0)
                        .eq(Product::getStatus, 1)
                        .ne(Product::getId, productId)
                        .orderByDesc(Product::getCreatedAt)
                        .last("LIMIT " + limit)
        );
    }
}