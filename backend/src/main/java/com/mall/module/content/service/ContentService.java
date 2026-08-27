package com.mall.module.content.service;

import com.mall.module.content.entity.*;

import java.util.List;

/**
 * 内容管理 Service 接口
 */
public interface ContentService {

    // ========== 资讯管理 ==========

    /**
     * 查询所有已发布的资讯列表
     *
     * @return 资讯列表
     */
    List<News> listNews();

    /**
     * 根据ID查询资讯详情
     *
     * @param id 资讯ID
     * @return 资讯详情
     */
    News findNewsById(Long id);

    /**
     * 新增资讯
     *
     * @param news 资讯实体
     */
    void saveNews(News news);

    /**
     * 删除资讯（逻辑删除）
     *
     * @param id 资讯ID
     */
    void deleteNews(Long id);

    /**
     * 点赞/取消点赞资讯
     *
     * @param userId 用户ID
     * @param newsId 资讯ID
     * @return 当前是否已点赞
     */
    boolean toggleLike(Long userId, Long newsId);

    /**
     * 收藏/取消收藏资讯
     *
     * @param userId 用户ID
     * @param newsId 资讯ID
     * @return 当前是否已收藏
     */
    boolean toggleFavorite(Long userId, Long newsId);

    // ========== 数据手册管理 ==========

    /**
     * 查询数据手册列表
     *
     * @return 数据手册列表
     */
    List<Datasheet> listDatasheets();

    /**
     * 新增数据手册
     *
     * @param datasheet 数据手册
     */
    void saveDatasheet(Datasheet datasheet);

    // ========== 合作品牌管理 ==========

    /**
     * 查询合作品牌列表
     *
     * @return 合作品牌列表
     */
    List<CooperateBrand> listCooperateBrands();

    /**
     * 新增/更新合作品牌
     *
     * @param brand 合作品牌
     */
    void saveCooperateBrand(CooperateBrand brand);

    /**
     * 删除合作品牌（逻辑删除）
     *
     * @param id 合作品牌ID
     */
    void deleteCooperateBrand(Long id);

    // ========== 合作伙伴申请管理 ==========

    /**
     * 提交合作伙伴申请
     *
     * @param apply 申请信息
     */
    void submitPartnerApply(PartnerApply apply);

    /**
     * 查询合作伙伴申请列表
     *
     * @return 申请列表
     */
    List<PartnerApply> listPartnerApplies();
}