package com.mall.module.content.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.mall.module.content.entity.News;
import com.mall.module.content.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 资讯管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/news")
@SaCheckRole("admin")
public class AdminNewsController {

    @Autowired
    private ContentService contentService;

    /**
     * 新增资讯
     *
     * @param news 资讯实体
     * @return 操作结果
     */
    @PostMapping("/save")
    public Map<String, Object> save(@RequestBody News news) {
        contentService.saveNews(news);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "保存成功");
        return result;
    }

    /**
     * 删除资讯（逻辑删除）
     *
     * @param id 资讯ID
     * @return 操作结果
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        contentService.deleteNews(id);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}