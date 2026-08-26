package com.mall.module.product.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.product.dto.ProductQuery;
import com.mall.module.product.entity.AttrFieldDef;
import com.mall.module.product.entity.Category;
import com.mall.module.product.entity.Product;
import com.mall.module.product.service.AttrFieldDefService;
import com.mall.module.product.service.CategoryService;
import com.mall.module.product.service.ProductService;
import com.mall.module.product.vo.ProductDetailVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 商品前端控制器（公开接口）
 */
@RestController
@RequestMapping("/api/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private AttrFieldDefService attrFieldDefService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 公开商品列表，支持筛选和分页
     * 返回 ProductDetailVO 列表，附带动态属性
     */
    @GetMapping("/list")
    public IPage<ProductDetailVO> list(ProductQuery query) {
        // 构建分页参数
        Page<Product> pageParam = new Page<>(query.getPage(), query.getSize());

        // 查询商品列表
        IPage<Product> productPage = productService.page(pageParam, query);

        // 转换为VO并填充属性数据
        List<ProductDetailVO> voList = productPage.getRecords().stream()
                .map(this::convertToDetailVO)
                .collect(Collectors.toList());

        // 构建返回分页对象
        IPage<ProductDetailVO> resultPage = new Page<>(productPage.getCurrent(), productPage.getSize(), productPage.getTotal());
        resultPage.setRecords(voList);
        return resultPage;
    }

    /**
     * 公开商品详情
     */
    @GetMapping("/{id}")
    public ProductDetailVO detail(@PathVariable Long id) {
        Product product = productService.findDetailById(id);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }
        return convertToDetailVO(product);
    }

    /**
     * 推荐商品（同分类，最多8条）
     */
    @GetMapping("/recommend/{id}")
    public List<Product> recommend(@PathVariable Long id) {
        return productService.recommend(id, 8);
    }

    /**
     * 将 Product 转换为 ProductDetailVO，并填充动态属性
     */
    private ProductDetailVO convertToDetailVO(Product product) {
        ProductDetailVO vo = new ProductDetailVO();
        BeanUtils.copyProperties(product, vo);

        // 填充分类名称
        Category category = categoryService.findById(product.getCategoryId());
        if (category != null) {
            vo.setCategoryName(category.getName());
        }

        // 填充动态属性
        if (category != null && category.getAttrTable() != null) {
            try {
                Map<String, Object> attrRow = jdbcTemplate.queryForMap(
                        "SELECT * FROM " + category.getAttrTable() + " WHERE product_id = ?",
                        product.getId()
                );
                // 去掉 id 和 product_id
                attrRow.remove("id");
                attrRow.remove("product_id");
                vo.setAttrMap(attrRow);
            } catch (Exception e) {
                vo.setAttrMap(Collections.emptyMap());
            }
        } else {
            vo.setAttrMap(Collections.emptyMap());
        }

        return vo;
    }
}