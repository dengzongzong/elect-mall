package com.mall.module.content.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.mall.module.content.entity.PartnerApply;
import com.mall.module.content.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 合作伙伴申请管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/partner")
@SaCheckRole("admin")
public class AdminPartnerController {

    @Autowired
    private ContentService contentService;

    /**
     * 合作伙伴申请列表
     *
     * @return 申请列表
     */
    @GetMapping("/list")
    public List<PartnerApply> list() {
        return contentService.listPartnerApplies();
    }
}