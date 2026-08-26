package com.mall.module.cart.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.cart.entity.Cart;
import com.mall.module.cart.mapper.CartMapper;
import com.mall.module.cart.service.CartService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 购物车 Service 实现类
 */
@Slf4j
@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartMapper cartMapper;

    @Override
    public void add(Long userId, Long productId, Integer quantity) {
        // 检查是否已存在该商品
        Cart existing = cartMapper.selectOne(
                new LambdaQueryWrapper<Cart>()
                        .eq(Cart::getUserId, userId)
                        .eq(Cart::getProductId, productId)
                        .eq(Cart::getDeleted, 0)
                        .last("LIMIT 1")
        );
        if (existing != null) {
            // 已存在则增加数量
            existing.setQuantity(existing.getQuantity() + (quantity != null ? quantity : 1));
            existing.setUpdatedAt(LocalDateTime.now());
            cartMapper.updateById(existing);
        } else {
            // 不存在则新增
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity != null ? quantity : 1);
            cart.setCreatedAt(LocalDateTime.now());
            cart.setUpdatedAt(LocalDateTime.now());
            cart.setDeleted(0);
            cartMapper.insert(cart);
        }
    }

    @Override
    public List<Cart> list(Long userId) {
        return cartMapper.selectList(
                new LambdaQueryWrapper<Cart>()
                        .eq(Cart::getUserId, userId)
                        .eq(Cart::getDeleted, 0)
                        .orderByDesc(Cart::getCreatedAt)
        );
    }

    @Override
    public void updateQuantity(Long id, Integer quantity) {
        Cart cart = cartMapper.selectById(id);
        if (cart != null) {
            cart.setQuantity(quantity);
            cart.setUpdatedAt(LocalDateTime.now());
            cartMapper.updateById(cart);
        }
    }

    @Override
    public void delete(Long id) {
        Cart cart = cartMapper.selectById(id);
        if (cart != null) {
            cart.setDeleted(1);
            cart.setUpdatedAt(LocalDateTime.now());
            cartMapper.updateById(cart);
        }
    }

    @Override
    public void clear(Long userId) {
        List<Cart> cartList = cartMapper.selectList(
                new LambdaQueryWrapper<Cart>()
                        .eq(Cart::getUserId, userId)
                        .eq(Cart::getDeleted, 0)
        );
        for (Cart cart : cartList) {
            cart.setDeleted(1);
            cart.setUpdatedAt(LocalDateTime.now());
            cartMapper.updateById(cart);
        }
    }
}