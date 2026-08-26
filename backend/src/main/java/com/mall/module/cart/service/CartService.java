package com.mall.module.cart.service;

import com.mall.module.cart.entity.Cart;

import java.util.List;

/**
 * 购物车 Service 接口
 */
public interface CartService {

    /**
     * 添加商品到购物车
     *
     * @param userId    用户ID
     * @param productId 商品ID
     * @param quantity  数量
     */
    void add(Long userId, Long productId, Integer quantity);

    /**
     * 查询用户购物车列表
     *
     * @param userId 用户ID
     * @return 购物车列表
     */
    List<Cart> list(Long userId);

    /**
     * 更新购物车商品数量
     *
     * @param id       购物车ID
     * @param quantity 新数量
     */
    void updateQuantity(Long id, Integer quantity);

    /**
     * 删除购物车记录
     *
     * @param id 购物车ID
     */
    void delete(Long id);

    /**
     * 清空用户购物车
     *
     * @param userId 用户ID
     */
    void clear(Long userId);
}