package com.mall.module.brand.service;

import com.mall.module.brand.entity.Brand;

import java.util.List;

/**
 * 品牌 Service 接口
 */
public interface BrandService {

    /**
     * 查询所有品牌列表
     *
     * @return 品牌列表
     */
    List<Brand> listAll();

    /**
     * 根据ID查询品牌
     *
     * @param id 品牌ID
     * @return 品牌实体
     */
    Brand findById(Long id);

    /**
     * 新增品牌
     *
     * @param brand 品牌实体
     */
    void save(Brand brand);

    /**
     * 更新品牌
     *
     * @param brand 品牌实体
     */
    void update(Brand brand);

    /**
     * 删除品牌（逻辑删除）
     *
     * @param id 品牌ID
     */
    void delete(Long id);
}