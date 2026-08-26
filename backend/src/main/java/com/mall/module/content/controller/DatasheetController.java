package com.mall.module.content.controller;

import com.mall.module.content.entity.Datasheet;
import com.mall.module.content.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 数据手册前端控制器（公开接口）
 */
@RestController
@RequestMapping("/api/datasheet")
public class DatasheetController {

    @Autowired
    private ContentService contentService;

    /**
     * 公开数据手册列表
     *
     * @return 数据手册列表
     */
    @GetMapping("/list")
    public List<Datasheet> list() {
        return contentService.listDatasheets();
    }
}