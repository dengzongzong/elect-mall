package com.mall.module.content.controller;

import com.mall.module.content.entity.News;
import com.mall.module.content.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 资讯前端控制器（公开接口，登录后可点赞/收藏）
 */
@RestController
@RequestMapping("/api/news")
public class NewsController {

    @Autowired
    private ContentService contentService;

    /**
     * 公开资讯列表
     *
     * @return 资讯列表
     */
    @GetMapping("/list")
    public List<News> list() {
        return contentService.listNews();
    }

    /**
     * 公开资讯详情
     *
     * @param id 资讯ID
     * @return 资讯详情
     */
    @GetMapping("/{id}")
    public News detail(@PathVariable Long id) {
        return contentService.findNewsById(id);
    }

    /**
     * 点赞/取消点赞（需登录）
     *
     * @param params 请求参数（newsId）
     * @return 操作结果
     */
    @PostMapping("/like")
    public Map<String, Object> like(@RequestBody Map<String, Object> params) {
        Long newsId = Long.valueOf(params.get("newsId").toString());
        Long userId = cn.dev33.satoken.stp.StpUtil.getLoginIdAsLong();
        boolean isLiked = contentService.toggleLike(userId, newsId);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("liked", isLiked);
        result.put("message", isLiked ? "点赞成功" : "取消点赞");
        return result;
    }

    /**
     * 收藏/取消收藏（需登录）
     *
     * @param params 请求参数（newsId）
     * @return 操作结果
     */
    @PostMapping("/favorite")
    public Map<String, Object> favorite(@RequestBody Map<String, Object> params) {
        Long newsId = Long.valueOf(params.get("newsId").toString());
        Long userId = cn.dev33.satoken.stp.StpUtil.getLoginIdAsLong();
        boolean isFavorited = contentService.toggleFavorite(userId, newsId);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("favorited", isFavorited);
        result.put("message", isFavorited ? "收藏成功" : "取消收藏");
        return result;
    }
}