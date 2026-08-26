package com.mall.module.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.admin.entity.SmsConfig;
import com.mall.module.admin.entity.SysConfig;
import com.mall.module.admin.mapper.SmsConfigMapper;
import com.mall.module.admin.mapper.SysConfigMapper;
import com.mall.module.admin.service.AdminService;
import com.mall.module.order.mapper.OrderMapper;
import com.mall.module.product.mapper.ProductMapper;
import com.mall.module.user.mapper.FeedbackMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 系统管理 Service 实现类
 */
@Slf4j
@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private SmsConfigMapper smsConfigMapper;

    @Autowired
    private SysConfigMapper sysConfigMapper;

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private FeedbackMapper feedbackMapper;

    @Override
    public List<SmsConfig> getSmsConfigs() {
        return smsConfigMapper.selectList(
                new LambdaQueryWrapper<SmsConfig>()
                        .eq(SmsConfig::getDeleted, 0)
        );
    }

    @Override
    public void updateSmsConfig(SmsConfig config) {
        config.setUpdatedAt(LocalDateTime.now());
        smsConfigMapper.updateById(config);
    }

    @Override
    public List<SysConfig> getConfigs() {
        return sysConfigMapper.selectList(
                new LambdaQueryWrapper<SysConfig>()
                        .eq(SysConfig::getDeleted, 0)
        );
    }

    @Override
    public void updateConfig(SysConfig config) {
        config.setUpdatedAt(LocalDateTime.now());
        sysConfigMapper.updateById(config);
    }

    @Override
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        // 商品总数
        Long productCount = productMapper.selectCount(
                new LambdaQueryWrapper<com.mall.module.product.entity.Product>()
                        .eq(com.mall.module.product.entity.Product::getDeleted, 0)
        );
        stats.put("productCount", productCount);

        // 订单总数
        Long orderCount = orderMapper.selectCount(
                new LambdaQueryWrapper<com.mall.module.order.entity.Order>()
                        .eq(com.mall.module.order.entity.Order::getDeleted, 0)
        );
        stats.put("orderCount", orderCount);

        // 待处理订单数
        Long pendingOrderCount = orderMapper.selectCount(
                new LambdaQueryWrapper<com.mall.module.order.entity.Order>()
                        .eq(com.mall.module.order.entity.Order::getDeleted, 0)
                        .eq(com.mall.module.order.entity.Order::getStatus, "待审核")
        );
        stats.put("pendingOrderCount", pendingOrderCount);

        // 待处理反馈数
        Long pendingFeedbackCount = feedbackMapper.selectCount(
                new LambdaQueryWrapper<com.mall.module.user.entity.Feedback>()
                        .eq(com.mall.module.user.entity.Feedback::getDeleted, 0)
                        .eq(com.mall.module.user.entity.Feedback::getStatus, 0)
        );
        stats.put("pendingFeedbackCount", pendingFeedbackCount);

        log.info("仪表盘统计数据：{}", stats);
        return stats;
    }

    @Override
    public String uploadFile(MultipartFile file, String type) {
        if (file.isEmpty()) {
            throw new RuntimeException("上传文件不能为空");
        }

        try {
            // 获取文件扩展名
            String originalFilename = file.getOriginalFilename();
            String ext = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                ext = originalFilename.substring(originalFilename.lastIndexOf("."));
            }

            // 生成唯一文件名
            String fileName = UUID.randomUUID().toString().replaceAll("-", "") + ext;

            // 根据类型决定存储目录
            String uploadDir = "uploads/" + ("image".equals(type) ? "images" : "files");

            // 确保目录存在
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 保存文件
            File dest = new File(dir, fileName);
            file.transferTo(dest);

            String fileUrl = "/" + uploadDir + "/" + fileName;
            log.info("文件上传成功：{}", fileUrl);
            return fileUrl;

        } catch (IOException e) {
            log.error("文件上传失败", e);
            throw new RuntimeException("文件上传失败: " + e.getMessage());
        }
    }
}