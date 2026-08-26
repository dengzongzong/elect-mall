package com.mall.module.content.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 合作伙伴申请实体类
 */
@Data
@TableName("partner_apply")
public class PartnerApply {

    /** 申请ID */
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 公司名称 */
    private String companyName;

    /** 合作品类 */
    private String category;

    /** 联系人 */
    private String contact;

    /** 联系电话 */
    private String phone;

    /** 备注 */
    private String remark;

    /** 状态：待审核/已通过/已拒绝 */
    private String status;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 逻辑删除标记：0-未删除，1-已删除 */
    private Integer deleted;
}