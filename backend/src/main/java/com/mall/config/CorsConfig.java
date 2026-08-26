package com.mall.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;

/**
 * 跨域资源共享（CORS）配置
 *
 * <p>允许来自 admin-web 和 mall-web 前端的跨域请求，支持所有请求方法和请求头。</p>
 *
 * @author mall
 */
@Configuration
public class CorsConfig {

    /**
     * 跨域过滤器
     */
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();

        // 允许的跨域来源（前端地址）
        config.setAllowedOriginPatterns(Arrays.asList(
                "http://localhost:8080",
                "http://localhost:8081",
                "http://admin.mall.com:*",
                "http://mall.mall.com:*"
        ));

        // 允许的请求方法
        config.setAllowedMethods(Arrays.asList(
                "GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS", "HEAD"
        ));

        // 允许的请求头
        config.setAllowedHeaders(Arrays.asList(
                "*"
        ));

        // 允许携带认证信息（Cookie、Authorization 头等）
        config.setAllowCredentials(true);

        // 预检请求的缓存时间（秒）
        config.setMaxAge(3600L);

        // 暴露的响应头
        config.setExposedHeaders(Arrays.asList(
                "Authorization", "Content-Disposition"
        ));

        // 注册 CORS 配置
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return new CorsFilter(source);
    }

}