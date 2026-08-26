package com.mall.module.content.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.content.entity.*;
import com.mall.module.content.mapper.*;
import com.mall.module.content.service.ContentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 内容管理 Service 实现类
 */
@Slf4j
@Service
public class ContentServiceImpl implements ContentService {

    @Autowired
    private NewsMapper newsMapper;

    @Autowired
    private NewsLikeMapper newsLikeMapper;

    @Autowired
    private DatasheetMapper datasheetMapper;

    @Autowired
    private CooperateBrandMapper cooperateBrandMapper;

    @Autowired
    private PartnerApplyMapper partnerApplyMapper;

    // ========== 资讯管理 ==========

    @Override
    public List<News> listNews() {
        return newsMapper.selectList(
                new LambdaQueryWrapper<News>()
                        .eq(News::getDeleted, 0)
                        .eq(News::getStatus, 1)
                        .orderByDesc(News::getCreatedAt)
        );
    }

    @Override
    public News findNewsById(Long id) {
        return newsMapper.selectById(id);
    }

    @Override
    public void saveNews(News news) {
        news.setCreatedAt(LocalDateTime.now());
        news.setUpdatedAt(LocalDateTime.now());
        news.setDeleted(0);
        if (news.getLikeCount() == null) {
            news.setLikeCount(0);
        }
        if (news.getFavoriteCount() == null) {
            news.setFavoriteCount(0);
        }
        if (news.getStatus() == null) {
            news.setStatus(1);
        }
        newsMapper.insert(news);
    }

    @Override
    public void deleteNews(Long id) {
        News news = newsMapper.selectById(id);
        if (news != null) {
            news.setDeleted(1);
            news.setUpdatedAt(LocalDateTime.now());
            newsMapper.updateById(news);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean toggleLike(Long userId, Long newsId) {
        // 查询是否已点赞
        NewsLike existing = newsLikeMapper.selectOne(
                new LambdaQueryWrapper<NewsLike>()
                        .eq(NewsLike::getUserId, userId)
                        .eq(NewsLike::getNewsId, newsId)
                        .eq(NewsLike::getType, "like")
                        .eq(NewsLike::getDeleted, 0)
                        .last("LIMIT 1")
        );

        News news = newsMapper.selectById(newsId);
        if (news == null) {
            throw new RuntimeException("资讯不存在");
        }

        if (existing != null) {
            // 取消点赞
            existing.setDeleted(1);
            existing.setUpdatedAt(LocalDateTime.now());
            newsLikeMapper.updateById(existing);
            news.setLikeCount(Math.max(0, news.getLikeCount() - 1));
            news.setUpdatedAt(LocalDateTime.now());
            newsMapper.updateById(news);
            return false;
        } else {
            // 点赞
            NewsLike like = new NewsLike();
            like.setUserId(userId);
            like.setNewsId(newsId);
            like.setType("like");
            like.setCreatedAt(LocalDateTime.now());
            like.setUpdatedAt(LocalDateTime.now());
            like.setDeleted(0);
            newsLikeMapper.insert(like);
            news.setLikeCount(news.getLikeCount() != null ? news.getLikeCount() + 1 : 1);
            news.setUpdatedAt(LocalDateTime.now());
            newsMapper.updateById(news);
            return true;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean toggleFavorite(Long userId, Long newsId) {
        // 查询是否已收藏
        NewsLike existing = newsLikeMapper.selectOne(
                new LambdaQueryWrapper<NewsLike>()
                        .eq(NewsLike::getUserId, userId)
                        .eq(NewsLike::getNewsId, newsId)
                        .eq(NewsLike::getType, "favorite")
                        .eq(NewsLike::getDeleted, 0)
                        .last("LIMIT 1")
        );

        News news = newsMapper.selectById(newsId);
        if (news == null) {
            throw new RuntimeException("资讯不存在");
        }

        if (existing != null) {
            // 取消收藏
            existing.setDeleted(1);
            existing.setUpdatedAt(LocalDateTime.now());
            newsLikeMapper.updateById(existing);
            news.setFavoriteCount(Math.max(0, news.getFavoriteCount() - 1));
            news.setUpdatedAt(LocalDateTime.now());
            newsMapper.updateById(news);
            return false;
        } else {
            // 收藏
            NewsLike favorite = new NewsLike();
            favorite.setUserId(userId);
            favorite.setNewsId(newsId);
            favorite.setType("favorite");
            favorite.setCreatedAt(LocalDateTime.now());
            favorite.setUpdatedAt(LocalDateTime.now());
            favorite.setDeleted(0);
            newsLikeMapper.insert(favorite);
            news.setFavoriteCount(news.getFavoriteCount() != null ? news.getFavoriteCount() + 1 : 1);
            news.setUpdatedAt(LocalDateTime.now());
            newsMapper.updateById(news);
            return true;
        }
    }

    // ========== 数据手册管理 ==========

    @Override
    public List<Datasheet> listDatasheets() {
        return datasheetMapper.selectList(
                new LambdaQueryWrapper<Datasheet>()
                        .eq(Datasheet::getDeleted, 0)
                        .orderByDesc(Datasheet::getCreatedAt)
        );
    }

    @Override
    public void saveDatasheet(Datasheet datasheet) {
        datasheet.setCreatedAt(LocalDateTime.now());
        datasheet.setUpdatedAt(LocalDateTime.now());
        datasheet.setDeleted(0);
        datasheetMapper.insert(datasheet);
    }

    // ========== 合作品牌管理 ==========

    @Override
    public List<CooperateBrand> listCooperateBrands() {
        return cooperateBrandMapper.selectList(
                new LambdaQueryWrapper<CooperateBrand>()
                        .eq(CooperateBrand::getDeleted, 0)
                        .eq(CooperateBrand::getStatus, 1)
                        .orderByAsc(CooperateBrand::getSort)
        );
    }

    @Override
    public void saveCooperateBrand(CooperateBrand brand) {
        if (brand.getId() == null) {
            brand.setCreatedAt(LocalDateTime.now());
            brand.setUpdatedAt(LocalDateTime.now());
            brand.setDeleted(0);
            if (brand.getStatus() == null) {
                brand.setStatus(1);
            }
            cooperateBrandMapper.insert(brand);
        } else {
            brand.setUpdatedAt(LocalDateTime.now());
            cooperateBrandMapper.updateById(brand);
        }
    }

    // ========== 合作伙伴申请管理 ==========

    @Override
    public void submitPartnerApply(PartnerApply apply) {
        apply.setStatus("待审核");
        apply.setCreatedAt(LocalDateTime.now());
        apply.setUpdatedAt(LocalDateTime.now());
        apply.setDeleted(0);
        partnerApplyMapper.insert(apply);
        log.info("合作伙伴申请提交成功，公司：{}", apply.getCompanyName());
    }

    @Override
    public List<PartnerApply> listPartnerApplies() {
        return partnerApplyMapper.selectList(
                new LambdaQueryWrapper<PartnerApply>()
                        .eq(PartnerApply::getDeleted, 0)
                        .orderByDesc(PartnerApply::getCreatedAt)
        );
    }
}