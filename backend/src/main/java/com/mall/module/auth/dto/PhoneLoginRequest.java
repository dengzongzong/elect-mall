package com.mall.module.auth.dto;

import lombok.Data;

/**
 * 手机号登录请求 DTO
 */
@Data
public class PhoneLoginRequest {
    /** 手机号 */
    private String phone;
    /** 验证码 */
    private String code;
}