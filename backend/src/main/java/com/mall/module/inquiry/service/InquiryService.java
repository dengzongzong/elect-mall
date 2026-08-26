package com.mall.module.inquiry.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.inquiry.entity.Inquiry;

import java.util.List;
import java.util.Map;

/**
 * 询价单 Service 接口
 */
public interface InquiryService {

    /**
     * 提交询价单
     *
     * @param userId 用户ID
     * @param params 询价参数（contact, phone, remark, items）
     * @return 询价单实体
     */
    Inquiry submit(Long userId, Map<String, Object> params);

    /**
     * 查询用户询价单列表
     *
     * @param userId 用户ID
     * @return 询价单列表
     */
    List<Inquiry> listByUser(Long userId);

    /**
     * 后台分页查询询价单
     *
     * @param page   分页参数
     * @param params 查询条件
     * @return 分页结果
     */
    IPage<Inquiry> adminPage(Page<Inquiry> page, Map<String, Object> params);

    /**
     * 回复询价单（更新状态）
     *
     * @param id     询价单ID
     * @param reply  回复内容
     */
    void reply(Long id, String reply);
}