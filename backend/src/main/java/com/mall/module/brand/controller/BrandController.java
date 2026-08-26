package com.mall.module.brand.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.brand.entity.Brand;
import com.mall.module.brand.service.BrandService;
import com.mall.module.product.entity.Product;
import com.mall.module.product.mapper.ProductMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 品牌前端控制器（公开接口）
 */
@RestController
@RequestMapping("/api/brand")
public class BrandController {

    @Autowired
    private BrandService brandService;

    @Autowired
    private ProductMapper productMapper;

    /**
     * 公开品牌列表
     *
     * @return 品牌列表
     */
    @GetMapping("/list")
    public List<Brand> list() {
        return brandService.listAll();
    }

    /**
     * 根据品牌ID查询商品列表（公开接口）
     *
     * @param id 品牌ID
     * @return 商品列表
     */
    @GetMapping("/{id}/products")
    public List<Product> getProducts(@PathVariable Long id) {
        return productMapper.selectList(
                new LambdaQueryWrapper<Product>()
                        .eq(Product::getBrandId, id)
                        .eq(Product::getDeleted, 0)
                        .eq(Product::getStatus, 1)
                        .orderByDesc(Product::getCreatedAt)
        );
    }
}