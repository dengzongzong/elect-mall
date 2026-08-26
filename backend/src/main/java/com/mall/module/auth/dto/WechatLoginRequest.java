package com.mall.module.auth.dto;

import lombok.Data;

/**
 * 微信登录请求 DTO
 */
@Data
public class WechatLoginRequest {
    /** 微信授权码 */
    private String code;
}