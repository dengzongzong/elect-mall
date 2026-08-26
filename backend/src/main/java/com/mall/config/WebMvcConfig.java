package com.mall.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web MVC 配置
 *
 * <p>配置静态资源映射，将 /uploads/** 路径映射到本地文件上传目录。</p>
 *
 * @author mall
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    /**
     * 配置静态资源映射
     *
     * <p>将上传目录映射为可访问的静态资源路径，用于图片、文件等预览。</p>
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 上传文件访问映射
        // 将 /uploads/** 请求映射到项目根目录下的 uploads 文件夹
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/");
    }

}