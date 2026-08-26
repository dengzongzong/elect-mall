package com.mall.common;

import lombok.Data;

import java.io.Serializable;

/**
 * 统一响应结果封装类
 *
 * <p>所有 API 接口统一返回此格式，包含状态码、提示信息和数据。</p>
 *
 * @param <T> 数据类型
 * @author mall
 */
@Data
public class Result<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 状态码，200 表示成功，其他表示失败
     */
    private int code;

    /**
     * 提示信息
     */
    private String msg;

    /**
     * 响应数据
     */
    private T data;

    private Result() {
    }

    private Result(int code, String msg, T data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    /**
     * 成功返回（无数据）
     */
    public static <T> Result<T> success() {
        return new Result<>(ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), null);
    }

    /**
     * 成功返回（带数据）
     *
     * @param data 返回数据
     */
    public static <T> Result<T> success(T data) {
        return new Result<>(ResultCode.SUCCESS.getCode(), ResultCode.SUCCESS.getMessage(), data);
    }

    /**
     * 成功返回（自定义消息和数据）
     *
     * @param msg  提示信息
     * @param data 返回数据
     */
    public static <T> Result<T> success(String msg, T data) {
        return new Result<>(ResultCode.SUCCESS.getCode(), msg, data);
    }

    /**
     * 失败返回（自定义状态码和消息）
     *
     * @param code 状态码
     * @param msg  提示信息
     */
    public static <T> Result<T> error(int code, String msg) {
        return new Result<>(code, msg, null);
    }

    /**
     * 失败返回（自定义消息，使用默认 500 状态码）
     *
     * @param msg 提示信息
     */
    public static <T> Result<T> error(String msg) {
        return new Result<>(ResultCode.FAIL.getCode(), msg, null);
    }

    /**
     * 失败返回（使用 ResultCode 枚举）
     *
     * @param resultCode 状态码枚举
     */
    public static <T> Result<T> error(ResultCode resultCode) {
        return new Result<>(resultCode.getCode(), resultCode.getMessage(), null);
    }

    /**
     * 失败返回（使用 ResultCode 枚举 + 自定义消息）
     *
     * @param resultCode 状态码枚举
     * @param msg        自定义提示信息
     */
    public static <T> Result<T> error(ResultCode resultCode, String msg) {
        return new Result<>(resultCode.getCode(), msg, null);
    }

    /**
     * 判断是否成功
     */
    public boolean isSuccess() {
        return this.code == ResultCode.SUCCESS.getCode();
    }

}