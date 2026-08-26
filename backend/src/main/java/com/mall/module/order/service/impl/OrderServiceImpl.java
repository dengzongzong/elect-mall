package com.mall.module.order.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.order.entity.Order;
import com.mall.module.order.entity.OrderItem;
import com.mall.module.order.mapper.OrderItemMapper;
import com.mall.module.order.mapper.OrderMapper;
import com.mall.module.order.service.OrderService;
import com.mall.module.product.entity.Product;
import com.mall.module.product.mapper.ProductMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 订单 Service 实现类
 */
@Slf4j
@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private OrderItemMapper orderItemMapper;

    @Autowired
    private ProductMapper productMapper;

    /** 每日订单序号生成器 */
    private static final Map<String, AtomicInteger> DAILY_SEQUENCE = new java.util.concurrent.ConcurrentHashMap<>();

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Order create(Long userId, List<Map<String, Object>> items, Map<String, Object> address) {
        // 生成订单编号：ORD + yyyyMMdd + 6位流水号
        String dateStr = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        AtomicInteger seq = DAILY_SEQUENCE.computeIfAbsent(dateStr, k -> new AtomicInteger(0));
        int seqNum = seq.incrementAndGet();
        String orderNo = "ORD" + dateStr + String.format("%06d", seqNum);

        // 计算总金额
        BigDecimal totalAmount = BigDecimal.ZERO;
        List<OrderItem> orderItems = new ArrayList<>();

        for (Map<String, Object> item : items) {
            Long productId = Long.valueOf(item.get("productId").toString());
            Integer quantity = Integer.valueOf(item.get("quantity").toString());

            Product product = productMapper.selectById(productId);
            if (product == null || product.getDeleted() == 1) {
                throw new RuntimeException("商品不存在，productId=" + productId);
            }

            BigDecimal price = product.getPrice() != null ? product.getPrice() : BigDecimal.ZERO;
            BigDecimal subtotal = price.multiply(BigDecimal.valueOf(quantity));

            OrderItem orderItem = new OrderItem();
            orderItem.setProductId(productId);
            orderItem.setPartNo(product.getPartNo());
            orderItem.setProductName(product.getName());
            orderItem.setQuantity(quantity);
            orderItem.setPrice(price);
            orderItem.setSubtotal(subtotal);
            orderItem.setCreatedAt(LocalDateTime.now());
            orderItem.setUpdatedAt(LocalDateTime.now());
            orderItem.setDeleted(0);
            orderItems.add(orderItem);

            totalAmount = totalAmount.add(subtotal);
        }

        // 创建订单
        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setStatus("待审核");
        order.setReceiverName((String) address.get("name"));
        order.setReceiverPhone((String) address.get("phone"));
        order.setReceiverAddress((String) address.get("address"));
        order.setRemark((String) address.get("remark"));
        order.setCreatedAt(LocalDateTime.now());
        order.setUpdatedAt(LocalDateTime.now());
        order.setDeleted(0);
        orderMapper.insert(order);

        // 保存订单明细
        for (OrderItem orderItem : orderItems) {
            orderItem.setOrderId(order.getId());
            orderItemMapper.insert(orderItem);
        }

        log.info("订单创建成功，订单编号：{}，总金额：{}", orderNo, totalAmount);
        return order;
    }

    @Override
    public List<Order> listByUserId(Long userId) {
        return orderMapper.selectList(
                new LambdaQueryWrapper<Order>()
                        .eq(Order::getUserId, userId)
                        .eq(Order::getDeleted, 0)
                        .orderByDesc(Order::getCreatedAt)
        );
    }

    @Override
    public Order findById(Long id) {
        return orderMapper.selectById(id);
    }

    @Override
    public void cancel(Long id, Long userId) {
        Order order = orderMapper.selectById(id);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new RuntimeException("订单不存在或无权操作");
        }
        if (!"待审核".equals(order.getStatus()) && !"待付款".equals(order.getStatus())) {
            throw new RuntimeException("当前订单状态不可取消");
        }
        order.setStatus("已取消");
        order.setUpdatedAt(LocalDateTime.now());
        orderMapper.updateById(order);
        log.info("订单已取消，订单ID：{}，订单编号：{}", id, order.getOrderNo());
    }

    @Override
    public void uploadVoucher(Long id, String transferVoucher) {
        Order order = orderMapper.selectById(id);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        order.setTransferVoucher(transferVoucher);
        order.setUpdatedAt(LocalDateTime.now());
        orderMapper.updateById(order);
        log.info("转账凭证已上传，订单ID：{}", id);
    }

    @Override
    public void confirmReceipt(Long id, Long userId) {
        Order order = orderMapper.selectById(id);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new RuntimeException("订单不存在或无权操作");
        }
        if (!"待收货".equals(order.getStatus())) {
            throw new RuntimeException("当前订单状态不可确认收货");
        }
        order.setStatus("已完成");
        order.setUpdatedAt(LocalDateTime.now());
        orderMapper.updateById(order);
        log.info("订单已确认收货，订单ID：{}", id);
    }

    @Override
    public IPage<Order> adminPage(Page<Order> page, Map<String, Object> params) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getDeleted, 0);

        String status = (String) params.get("status");
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Order::getStatus, status);
        }

        String keyword = (String) params.get("keyword");
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Order::getOrderNo, keyword)
                    .or().like(Order::getReceiverName, keyword)
                    .or().like(Order::getReceiverPhone, keyword));
        }

        wrapper.orderByDesc(Order::getCreatedAt);
        return orderMapper.selectPage(page, wrapper);
    }

    @Override
    public void adminAudit(Long id) {
        Order order = orderMapper.selectById(id);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (!"待审核".equals(order.getStatus())) {
            throw new RuntimeException("当前订单状态不可审核");
        }
        order.setStatus("待付款");
        order.setUpdatedAt(LocalDateTime.now());
        orderMapper.updateById(order);
        log.info("订单已审核通过，订单ID：{}", id);
    }

    @Override
    public void adminShip(Long id) {
        Order order = orderMapper.selectById(id);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (!"待发货".equals(order.getStatus())) {
            throw new RuntimeException("当前订单状态不可发货");
        }
        order.setStatus("待收货");
        order.setUpdatedAt(LocalDateTime.now());
        orderMapper.updateById(order);
        log.info("订单已发货，订单ID：{}", id);
    }

    @Override
    public List<OrderItem> findItemsByOrderId(Long orderId) {
        return orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>()
                        .eq(OrderItem::getOrderId, orderId)
                        .eq(OrderItem::getDeleted, 0)
        );
    }
}