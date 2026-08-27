package com.mall.module.product.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.product.dto.ProductQuery;
import com.mall.module.product.entity.Product;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 商品 Service 接口
 */
public interface ProductService {

    /**
     * 分页查询商品列表
     */
    IPage<Product> page(Page<Product> page, ProductQuery query);

    /**
     * 查询商品详情（含属性、分类、品牌信息）
     */
    Product findDetailById(Long id);

    /**
     * 新增商品（含属性数据）
     */
    void save(Product product, Map<String, Object> attrs);

    /**
     * 更新商品（含属性数据）
     */
    void update(Product product, Map<String, Object> attrs);

    /**
     * 删除商品（逻辑删除）
     */
    void delete(Long id);

    /**
     * 从Excel导入商品
     *
     * @param file        Excel文件
     * @param categoryId  分类ID
     * @param replaceMode 是否覆盖已存在的料号
     * @return 导入结果
     */
    Map<String, Object> importExcel(MultipartFile file, Long categoryId, boolean replaceMode);

    /**
     * 导出商品为Excel
     */
    void exportExcel(HttpServletResponse response, Long categoryId);

    /**
     * 下载导入模板
     */
    void downloadTemplate(HttpServletResponse response, Long categoryId);

    /**
     * 推荐相关商品（同分类下）
     */
    List<Product> recommend(Long productId, int limit);
}