package com.mall.module.brand.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.brand.entity.Brand;
import com.mall.module.brand.mapper.BrandMapper;
import com.mall.module.brand.service.BrandService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 品牌 Service 实现类
 */
@Slf4j
@Service
public class BrandServiceImpl implements BrandService {

    @Autowired
    private BrandMapper brandMapper;

    @Override
    public List<Brand> listAll() {
        return brandMapper.selectList(
                new LambdaQueryWrapper<Brand>()
                        .eq(Brand::getDeleted, 0)
                        .orderByAsc(Brand::getSort)
        );
    }

    @Override
    public Brand findById(Long id) {
        return brandMapper.selectById(id);
    }

    @Override
    public void save(Brand brand) {
        brand.setCreatedAt(LocalDateTime.now());
        brand.setUpdatedAt(LocalDateTime.now());
        brand.setDeleted(0);
        if (brand.getStatus() == null) {
            brand.setStatus(1);
        }
        if (brand.getIsCooperate() == null) {
            brand.setIsCooperate(0);
        }
        brandMapper.insert(brand);
    }

    @Override
    public void update(Brand brand) {
        brand.setUpdatedAt(LocalDateTime.now());
        brandMapper.updateById(brand);
    }

    @Override
    public void delete(Long id) {
        Brand brand = brandMapper.selectById(id);
        if (brand != null) {
            brand.setDeleted(1);
            brand.setUpdatedAt(LocalDateTime.now());
            brandMapper.updateById(brand);
        }
    }
}