package com.mall.module.inquiry.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.inquiry.entity.Inquiry;
import com.mall.module.inquiry.entity.InquiryItem;
import com.mall.module.inquiry.mapper.InquiryItemMapper;
import com.mall.module.inquiry.mapper.InquiryMapper;
import com.mall.module.inquiry.service.InquiryService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 询价单 Service 实现类
 */
@Slf4j
@Service
public class InquiryServiceImpl implements InquiryService {

    @Autowired
    private InquiryMapper inquiryMapper;

    @Autowired
    private InquiryItemMapper inquiryItemMapper;

    /** 每日询价单序号生成器 */
    private static final Map<String, AtomicInteger> DAILY_SEQUENCE = new java.util.concurrent.ConcurrentHashMap<>();

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Inquiry submit(Long userId, Map<String, Object> params) {
        // 生成询价单编号：INQ + yyyyMMdd + 6位流水号
        String dateStr = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        AtomicInteger seq = DAILY_SEQUENCE.computeIfAbsent(dateStr, k -> new AtomicInteger(0));
        int seqNum = seq.incrementAndGet();
        String inquiryNo = "INQ" + dateStr + String.format("%06d", seqNum);

        // 创建询价单
        Inquiry inquiry = new Inquiry();
        inquiry.setInquiryNo(inquiryNo);
        inquiry.setUserId(userId);
        inquiry.setContact((String) params.get("contact"));
        inquiry.setPhone((String) params.get("phone"));
        inquiry.setRemark((String) params.get("remark"));
        inquiry.setStatus("待报价");
        inquiry.setCreatedAt(LocalDateTime.now());
        inquiry.setUpdatedAt(LocalDateTime.now());
        inquiry.setDeleted(0);
        inquiryMapper.insert(inquiry);

        // 保存询价单明细
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> items = (List<Map<String, Object>>) params.get("items");
        if (items != null) {
            for (Map<String, Object> item : items) {
                InquiryItem inquiryItem = new InquiryItem();
                inquiryItem.setInquiryId(inquiry.getId());
                inquiryItem.setProductId(item.get("productId") != null
                        ? Long.valueOf(item.get("productId").toString()) : null);
                inquiryItem.setPartNo((String) item.get("partNo"));
                inquiryItem.setQuantity(item.get("quantity") != null
                        ? Integer.valueOf(item.get("quantity").toString()) : null);
                inquiryItem.setTargetPrice(item.get("targetPrice") != null
                        ? new java.math.BigDecimal(item.get("targetPrice").toString()) : null);
                inquiryItem.setCreatedAt(LocalDateTime.now());
                inquiryItem.setUpdatedAt(LocalDateTime.now());
                inquiryItem.setDeleted(0);
                inquiryItemMapper.insert(inquiryItem);
            }
        }

        log.info("询价单提交成功，编号：{}", inquiryNo);
        return inquiry;
    }

    @Override
    public List<Inquiry> listByUser(Long userId) {
        return inquiryMapper.selectList(
                new LambdaQueryWrapper<Inquiry>()
                        .eq(Inquiry::getUserId, userId)
                        .eq(Inquiry::getDeleted, 0)
                        .orderByDesc(Inquiry::getCreatedAt)
        );
    }

    @Override
    public IPage<Inquiry> adminPage(Page<Inquiry> page, Map<String, Object> params) {
        LambdaQueryWrapper<Inquiry> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Inquiry::getDeleted, 0);

        String status = (String) params.get("status");
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Inquiry::getStatus, status);
        }

        String keyword = (String) params.get("keyword");
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Inquiry::getInquiryNo, keyword)
                    .or().like(Inquiry::getContact, keyword)
                    .or().like(Inquiry::getPhone, keyword));
        }

        wrapper.orderByDesc(Inquiry::getCreatedAt);
        return inquiryMapper.selectPage(page, wrapper);
    }

    @Override
    public void reply(Long id, String reply) {
        Inquiry inquiry = inquiryMapper.selectById(id);
        if (inquiry == null) {
            throw new RuntimeException("询价单不存在");
        }
        inquiry.setRemark(reply);
        inquiry.setStatus("已报价");
        inquiry.setUpdatedAt(LocalDateTime.now());
        inquiryMapper.updateById(inquiry);
        log.info("询价单已回复，ID：{}", id);
    }
}