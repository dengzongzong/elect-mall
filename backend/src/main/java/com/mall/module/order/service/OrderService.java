package com.mall.module.order.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.order.entity.Order;
import com.mall.module.order.entity.OrderItem;

import java.util.List;
import java.util.Map;

/**
 * 订单 Service 接口
 */
public interface OrderService {

    /**
     * 创建订单
     *
     * @param userId   用户ID
     * @param items    订单商品列表（productId, quantity）
     * @param address  收货地址信息
     * @return 订单实体
     */
    Order create(Long userId, List<Map<String, Object>> items, Map<String, Object> address);

    /**
     * 根据用户ID查询订单列表
     *
     * @param userId 用户ID
     * @return 订单列表
     */
    List<Order> listByUserId(Long userId);

    /**
     * 根据ID查询订单
     *
     * @param id 订单ID
     * @return 订单实体
     */
    Order findById(Long id);

    /**
     * 取消订单
     *
     * @param id     订单ID
     * @param userId 用户ID（用于校验）
     */
    void cancel(Long id, Long userId);

    /**
     * 上传转账凭证
     *
     * @param id              订单ID
     * @param transferVoucher 凭证URL
     */
    void uploadVoucher(Long id, String transferVoucher);

    /**
     * 确认收货
     *
     * @param id     订单ID
     * @param userId 用户ID
     */
    void confirmReceipt(Long id, Long userId);

    /**
     * 后台分页查询订单
     *
     * @param page   分页参数
     * @param params 查询条件
     * @return 分页结果
     */
    IPage<Order> adminPage(Page<Order> page, Map<String, Object> params);

    /**
     * 后台审核订单（待审核 -> 待付款）
     *
     * @param id 订单ID
     */
    void adminAudit(Long id);

    /**
     * 后台发货（待发货 -> 待收货）
     *
     * @param id 订单ID
     */
    void adminShip(Long id);

    /**
     * 根据订单ID查询订单明细
     *
     * @param orderId 订单ID
     * @return 订单明细列表
     */
    List<OrderItem> findItemsByOrderId(Long orderId);
}