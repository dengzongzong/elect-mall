package com.mall.module.content.controller;

import com.mall.module.content.entity.CooperateBrand;
import com.mall.module.content.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 合作品牌前端控制器（公开接口）
 */
@RestController
@RequestMapping("/api/cooperate-brand")
public class CooperateBrandController {

    @Autowired
    private ContentService contentService;

    /**
     * 公开合作品牌列表
     *
     * @return 合作品牌列表
     */
    @GetMapping("/list")
    public List<CooperateBrand> list() {
        return contentService.listCooperateBrands();
    }
}