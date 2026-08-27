package com.mall.module.brand.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.common.Result;
import com.mall.module.brand.entity.Brand;
import com.mall.module.brand.mapper.BrandMapper;
import com.mall.module.brand.service.BrandService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 品牌管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/brand")
@SaCheckRole("admin")
public class AdminBrandController {

    @Autowired
    private BrandService brandService;

    @Autowired
    private BrandMapper brandMapper;

    /**
     * 品牌列表（管理端）
     */
    @GetMapping("/list")
    public Result<List<Brand>> list() {
        LambdaQueryWrapper<Brand> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Brand::getDeleted, 0);
        wrapper.orderByAsc(Brand::getSort);
        return Result.success(brandMapper.selectList(wrapper));
    }

    /**
     * 品牌分页列表
     *
     * @param params 分页参数（page, size, keyword）
     * @return 分页结果
     */
    @PostMapping("/page")
    public Result<IPage<Brand>> page(@RequestBody Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;
        String keyword = (String) params.get("keyword");

        Page<Brand> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Brand> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Brand::getDeleted, 0);
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Brand::getName, keyword);
        }
        wrapper.orderByAsc(Brand::getSort);
        return Result.success(brandMapper.selectPage(pageParam, wrapper));
    }

    /**
     * 新增品牌
     *
     * @param brand 品牌实体
     */
    @PostMapping({"/save", "/add"})
    public Result<Void> save(@RequestBody Brand brand) {
        brandService.save(brand);
        return Result.success();
    }

    /**
     * 更新品牌
     *
     * @param brand 品牌实体
     */
    @PutMapping("/update")
    public Result<Void> update(@RequestBody Brand brand) {
        brandService.update(brand);
        return Result.success();
    }

    /**
     * 删除品牌（逻辑删除）
     *
     * @param id 品牌ID
     */
    @DeleteMapping({"/{id}", "/delete"})
    public Result<Void> delete(@PathVariable(required = false) Long id, @RequestBody(required = false) Map<String, Object> body) {
        if (id == null && body != null && body.containsKey("id")) {
            id = Long.valueOf(body.get("id").toString());
        }
        brandService.delete(id);
        return Result.success();
    }
}
