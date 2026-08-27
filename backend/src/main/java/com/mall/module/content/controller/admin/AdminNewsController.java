package com.mall.module.content.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.common.Result;
import com.mall.module.content.entity.News;
import com.mall.module.content.mapper.NewsMapper;
import com.mall.module.content.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
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

    @Autowired
    private NewsMapper newsMapper;

    /**
     * 新闻列表（前端管理端）
     */
    @GetMapping("/list")
    public Result<List<News>> list() {
        LambdaQueryWrapper<News> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(News::getDeleted, 0);
        wrapper.orderByDesc(News::getCreatedAt);
        return Result.success(newsMapper.selectList(wrapper));
    }

    /**
     * 新闻分页列表（管理端）
     */
    @PostMapping("/page")
    public Result<IPage<News>> page(@RequestBody Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;
        Page<News> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<News> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(News::getDeleted, 0);
        wrapper.orderByDesc(News::getCreatedAt);
        return Result.success(newsMapper.selectPage(pageParam, wrapper));
    }

    /**
     * 新增资讯
     *
     * @param news 资讯实体
     * @return 操作结果
     */
    @PostMapping({"/save", "/add"})
    public Result<Void> save(@RequestBody News news) {
        contentService.saveNews(news);
        return Result.success();
    }

    /**
     * 更新资讯
     *
     * @param news 资讯实体
     * @return 操作结果
     */
    @PutMapping("/update")
    public Result<Void> update(@RequestBody News news) {
        newsMapper.updateById(news);
        return Result.success();
    }

    /**
     * 删除资讯（逻辑删除）
     *
     * @param id 资讯ID
     * @return 操作结果
     */
    @DeleteMapping({"/{id}", "/delete"})
    public Result<Void> delete(@PathVariable(required = false) Long id, @RequestBody(required = false) Map<String, Object> body) {
        if (id == null && body != null && body.containsKey("id")) {
            id = Long.valueOf(body.get("id").toString());
        }
        contentService.deleteNews(id);
        return Result.success();
    }
}
