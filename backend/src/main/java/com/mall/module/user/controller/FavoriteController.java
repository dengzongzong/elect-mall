package com.mall.module.user.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.user.entity.Favorite;
import com.mall.module.user.service.UserCenterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户收藏控制器（需登录）
 */
@RestController
@RequestMapping("/api/favorite")
@SaCheckLogin
public class FavoriteController {

    @Autowired
    private UserCenterService userCenterService;

    /**
     * 添加收藏
     *
     * @param params 请求参数（productId）
     * @return 操作结果
     */
    @PostMapping("/add")
    public Map<String, Object> add(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();
        Long productId = Long.valueOf(params.get("productId").toString());
        userCenterService.addFavorite(userId, productId);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "收藏成功");
        return result;
    }

    /**
     * 取消收藏
     *
     * @param productId 产品ID
     * @return 操作结果
     */
    @DeleteMapping("/{productId}")
    public Map<String, Object> remove(@PathVariable Long productId) {
        long userId = StpUtil.getLoginIdAsLong();
        userCenterService.removeFavorite(userId, productId);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "取消收藏成功");
        return result;
    }

    /**
     * 获取用户收藏列表
     *
     * @return 收藏列表
     */
    @GetMapping("/list")
    public List<Favorite> list() {
        long userId = StpUtil.getLoginIdAsLong();
        return userCenterService.listFavorite(userId);
    }
}