package com.mall.module.product.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.common.Result;
import com.mall.module.product.dto.ProductQuery;
import com.mall.module.product.entity.Product;
import com.mall.module.product.service.ProductService;
import com.mall.module.product.vo.ProductImportResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 商品管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/product")
@SaCheckRole("admin")
public class AdminProductController {

    @Autowired
    private ProductService productService;

    /**
     * 管理后台商品分页列表
     */
    @PostMapping("/page")
    public Result<IPage<Product>> page(@RequestBody ProductQuery query) {
        Page<Product> pageParam = new Page<>(query.getPage(), query.getSize());
        return Result.success(productService.page(pageParam, query));
    }

    /**
     * 新增商品
     */
    @PostMapping({"/save", "/add"})
    public Result<Void> save(@RequestBody Map<String, Object> params) {
        Product product = new Product();
        product.setCategoryId(params.get("categoryId") != null ? Long.valueOf(params.get("categoryId").toString()) : null);
        product.setBrandId(params.get("brandId") != null ? Long.valueOf(params.get("brandId").toString()) : null);
        product.setPartNo((String) params.get("partNo"));
        product.setName((String) params.get("name"));
        product.setDescription((String) params.get("description"));
        product.setStock(params.get("stock") != null ? Integer.valueOf(params.get("stock").toString()) : 0);
        product.setPrice(params.get("price") != null ? new java.math.BigDecimal(params.get("price").toString()) : java.math.BigDecimal.ZERO);
        product.setMinOrder(params.get("minOrder") != null ? Integer.valueOf(params.get("minOrder").toString()) : 1);
        product.setWeight(params.get("weight") != null ? new java.math.BigDecimal(params.get("weight").toString()) : null);
        product.setUnit((String) params.get("unit"));
        product.setDatasheetUrl((String) params.get("datasheetUrl"));
        product.setImageUrl((String) params.get("imageUrl"));
        product.setStatus(params.get("status") != null ? Integer.valueOf(params.get("status").toString()) : 1);

        @SuppressWarnings("unchecked")
        Map<String, Object> attrs = (Map<String, Object>) params.get("attrs");
        productService.save(product, attrs);
        return Result.success();
    }

    /**
     * 更新商品
     */
    @PutMapping("/update")
    public Result<Void> update(@RequestBody Map<String, Object> params) {
        Product product = new Product();
        product.setId(Long.valueOf(params.get("id").toString()));
        product.setCategoryId(params.get("categoryId") != null ? Long.valueOf(params.get("categoryId").toString()) : null);
        product.setBrandId(params.get("brandId") != null ? Long.valueOf(params.get("brandId").toString()) : null);
        product.setPartNo((String) params.get("partNo"));
        product.setName((String) params.get("name"));
        product.setDescription((String) params.get("description"));
        product.setStock(params.get("stock") != null ? Integer.valueOf(params.get("stock").toString()) : null);
        product.setPrice(params.get("price") != null ? new java.math.BigDecimal(params.get("price").toString()) : null);
        product.setMinOrder(params.get("minOrder") != null ? Integer.valueOf(params.get("minOrder").toString()) : null);
        product.setWeight(params.get("weight") != null ? new java.math.BigDecimal(params.get("weight").toString()) : null);
        product.setUnit((String) params.get("unit"));
        product.setDatasheetUrl((String) params.get("datasheetUrl"));
        product.setImageUrl((String) params.get("imageUrl"));
        product.setStatus(params.get("status") != null ? Integer.valueOf(params.get("status").toString()) : null);

        @SuppressWarnings("unchecked")
        Map<String, Object> attrs = (Map<String, Object>) params.get("attrs");
        productService.update(product, attrs);
        return Result.success();
    }

    /**
     * 删除商品（逻辑删除）
     */
    @DeleteMapping({"/{id}", "/delete"})
    public Result<Void> delete(@PathVariable(required = false) Long id, @RequestBody(required = false) Map<String, Object> body) {
        if (id == null && body != null && body.containsKey("id")) {
            id = Long.valueOf(body.get("id").toString());
        }
        productService.delete(id);
        return Result.success();
    }

    /**
     * 导入Excel
     * 支持覆盖模式参数 replaceMode
     */
    @PostMapping("/import")
    public Result<ProductImportResultVO> importExcel(@RequestParam("file") MultipartFile file,
                                              @RequestParam("categoryId") Long categoryId,
                                              @RequestParam(value = "replaceMode", defaultValue = "false") boolean replaceMode) {
        Map<String, Object> result = productService.importExcel(file, categoryId, replaceMode);

        ProductImportResultVO vo = new ProductImportResultVO();
        vo.setSuccessCount((Integer) result.get("successCount"));
        vo.setFailCount((Integer) result.get("failCount"));
        vo.setFailDetailUrl((String) result.get("failDetailUrl"));
        return Result.success(vo);
    }

    /**
     * 下载导入模板
     */
    @GetMapping("/template")
    public void downloadTemplate(HttpServletResponse response,
                                  @RequestParam("categoryId") Long categoryId) {
        productService.downloadTemplate(response, categoryId);
    }

    /**
     * 导出商品Excel
     */
    @GetMapping("/export")
    public void exportExcel(HttpServletResponse response,
                             @RequestParam("categoryId") Long categoryId) {
        productService.exportExcel(response, categoryId);
    }
}
