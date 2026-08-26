package com.mall.common;

import cn.dev33.satoken.exception.NotLoginException;
import cn.dev33.satoken.exception.NotPermissionException;
import cn.dev33.satoken.exception.NotRoleException;
import cn.dev33.satoken.exception.SaTokenException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理器
 *
 * <p>统一拦截各类异常，返回标准 Result 格式响应。</p>
 *
 * @author mall
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 处理 Sa-Token 异常（未登录、无权限等）
     */
    @ExceptionHandler(SaTokenException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public Result<Void> handleSaTokenException(SaTokenException e) {
        log.warn("Sa-Token 异常: {}", e.getMessage());

        if (e instanceof NotLoginException) {
            return Result.error(ResultCode.UNAUTHORIZED, "未登录，请先登录");
        }
        if (e instanceof NotPermissionException) {
            return Result.error(ResultCode.UNAUTHORIZED, "无权限访问，请联系管理员");
        }
        if (e instanceof NotRoleException) {
            return Result.error(ResultCode.UNAUTHORIZED, "无角色权限，请联系管理员");
        }

        return Result.error(ResultCode.UNAUTHORIZED.getCode(), e.getMessage());
    }

    /**
     * 处理参数校验异常（@Valid 或 @Validated）
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Void> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        log.warn("参数校验异常: {}", e.getMessage());

        // 提取第一个校验失败的字段错误信息
        FieldError fieldError = e.getBindingResult().getFieldError();
        String errorMsg = "参数校验失败";
        if (fieldError != null) {
            errorMsg = fieldError.getDefaultMessage();
        }

        return Result.error(ResultCode.PARAM_ERROR.getCode(), errorMsg);
    }

    /**
     * 处理 IllegalArgumentException 参数非法异常
     */
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Void> handleIllegalArgumentException(IllegalArgumentException e) {
        log.warn("参数非法异常: {}", e.getMessage());
        return Result.error(ResultCode.PARAM_ERROR.getCode(), e.getMessage());
    }

    /**
     * 处理所有未知异常
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Result<Void> handleException(Exception e) {
        log.error("系统内部异常: ", e);
        return Result.error(ResultCode.FAIL.getCode(), "系统繁忙，请稍后重试");
    }

}