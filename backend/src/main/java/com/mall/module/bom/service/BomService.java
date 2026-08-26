package com.mall.module.bom.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.bom.entity.BomRecord;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * BOM清单 Service 接口
 */
public interface BomService {

    /**
     * BOM匹配（解析文本或Excel，按料号匹配商品）
     *
     * @param userId 用户ID
     * @param params 匹配参数（items: 物料列表, 或 file: 上传文件）
     * @return BOM记录
     */
    BomRecord match(Long userId, Map<String, Object> params);

    /**
     * 上传BOM文件（Excel文件解析并匹配）
     *
     * @param userId 用户ID
     * @param file   Excel文件
     * @return BOM记录
     */
    BomRecord upload(Long userId, MultipartFile file);

    /**
     * 后台分页查询BOM记录
     *
     * @param page   分页参数
     * @param params 查询条件
     * @return 分页结果
     */
    IPage<BomRecord> adminPage(Page<BomRecord> page, Map<String, Object> params);

    /**
     * 回复BOM清单（更新状态）
     *
     * @param id     BOM记录ID
     * @param reply  回复内容
     */
    void reply(Long id, String reply);

    /**
     * 根据BOM记录ID查询明细
     *
     * @param bomId BOM记录ID
     * @return 明细列表
     */
    List<com.mall.module.bom.entity.BomItem> findItemsByBomId(Long bomId);
}