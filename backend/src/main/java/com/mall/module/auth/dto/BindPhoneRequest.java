package com.mall.module.auth.dto;

import lombok.Data;

/**
 * 绑定手机号请求 DTO
 */
@Data
public class BindPhoneRequest {
    /** 手机号 */
    private String phone;
    /** 验证码 */
    private String code;
    /** 微信登录临时Token */
    private String tempToken;
}