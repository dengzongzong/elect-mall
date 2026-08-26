package com.mall.module.product.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mall.module.product.entity.AttrFieldDef;
import com.mall.module.product.mapper.AttrFieldDefMapper;
import com.mall.module.product.service.AttrFieldDefService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 属性字段定义 Service 实现类
 */
@Service
public class AttrFieldDefServiceImpl implements AttrFieldDefService {

    @Autowired
    private AttrFieldDefMapper attrFieldDefMapper;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 根据分类ID查询属性字段定义
     */
    @Override
    public List<AttrFieldDef> findByCategoryId(Long categoryId) {
        return attrFieldDefMapper.selectList(
                new LambdaQueryWrapper<AttrFieldDef>()
                        .eq(AttrFieldDef::getCategoryId, categoryId)
                        .eq(AttrFieldDef::getDeleted, 0)
                        .orderByAsc(AttrFieldDef::getSort)
        );
    }

    /**
     * 批量保存属性字段定义
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveAll(Long categoryId, List<AttrFieldDef> fields) {
        // 先删除旧的属性定义（逻辑删除）
        List<AttrFieldDef> oldList = attrFieldDefMapper.selectList(
                new LambdaQueryWrapper<AttrFieldDef>()
                        .eq(AttrFieldDef::getCategoryId, categoryId)
                        .eq(AttrFieldDef::getDeleted, 0)
        );
        for (AttrFieldDef old : oldList) {
            old.setDeleted(1);
            old.setUpdatedAt(LocalDateTime.now());
            attrFieldDefMapper.updateById(old);
        }

        // 批量插入新的属性定义
        for (AttrFieldDef field : fields) {
            field.setId(null);
            field.setCategoryId(categoryId);
            field.setCreatedAt(LocalDateTime.now());
            field.setUpdatedAt(LocalDateTime.now());
            field.setDeleted(0);
            attrFieldDefMapper.insert(field);
        }
    }

    /**
     * 动态创建属性表
     * 根据字段定义列表动态生成 CREATE TABLE DDL
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createAttrTable(Long categoryId, String tableName, List<AttrFieldDef> fields) {
        // 先保存字段定义
        saveAll(categoryId, fields);

        // 构建动态列定义
        StringBuilder columnDefs = new StringBuilder();
        for (AttrFieldDef field : fields) {
            String colName = field.getFieldName();
            // 如果字段名是MySQL保留字（如 package），加反引号
            if ("package".equals(colName)) {
                colName = "`package`";
            }
            columnDefs.append(",\n  ").append(colName).append(" VARCHAR(64) DEFAULT NULL COMMENT '")
                    .append(field.getFieldLabel()).append("'");
        }

        // 构建完整DDL
        String sql = "CREATE TABLE IF NOT EXISTS " + tableName + " (\n" +
                "  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',\n" +
                "  product_id BIGINT NOT NULL COMMENT '商品ID'" +
                columnDefs +
                ",\n  KEY idx_product (product_id)\n" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='动态属性表-" + tableName + "'";

        // 执行DDL
        jdbcTemplate.execute(sql);
    }
}