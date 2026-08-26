package com.mall.common;

/**
 * 统一响应状态码枚举
 *
 * @author mall
 */
public enum ResultCode {

    /**
     * 成功
     */
    SUCCESS(200, "操作成功"),

    /**
     * 参数错误
     */
    PARAM_ERROR(400, "参数错误"),

    /**
     * 未授权
     */
    UNAUTHORIZED(401, "未登录或 Token 已过期"),

    /**
     * 资源未找到
     */
    NOT_FOUND(404, "请求的资源不存在"),

    /**
     * 请求失败
     */
    FAIL(500, "操作失败");

    /**
     * 状态码
     */
    private final int code;

    /**
     * 提示信息
     */
    private final String message;

    ResultCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

}