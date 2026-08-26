package com.mall.module.cart.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.cart.entity.Cart;
import com.mall.module.cart.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 购物车控制器（需登录）
 */
@RestController
@RequestMapping("/api/cart")
@SaCheckLogin
public class CartController {

    @Autowired
    private CartService cartService;

    /**
     * 添加商品到购物车
     *
     * @param params 请求参数：productId, quantity
     * @return 操作结果
     */
    @PostMapping("/add")
    public Map<String, Object> add(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();
        Long productId = Long.valueOf(params.get("productId").toString());
        Integer quantity = params.get("quantity") != null ? Integer.valueOf(params.get("quantity").toString()) : 1;

        cartService.add(userId, productId, quantity);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "添加成功");
        return result;
    }

    /**
     * 获取用户购物车列表
     *
     * @return 购物车列表
     */
    @GetMapping("/list")
    public List<Cart> list() {
        long userId = StpUtil.getLoginIdAsLong();
        return cartService.list(userId);
    }

    /**
     * 更新购物车商品数量
     *
     * @param params 请求参数：id, quantity
     * @return 操作结果
     */
    @PostMapping("/update")
    public Map<String, Object> update(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        Integer quantity = Integer.valueOf(params.get("quantity").toString());

        cartService.updateQuantity(id, quantity);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "更新成功");
        return result;
    }

    /**
     * 删除购物车记录
     *
     * @param params 请求参数：id
     * @return 操作结果
     */
    @DeleteMapping("/delete")
    public Map<String, Object> delete(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());

        cartService.delete(id);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}