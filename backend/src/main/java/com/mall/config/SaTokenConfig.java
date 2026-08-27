package com.mall.config;

import cn.dev33.satoken.interceptor.SaInterceptor;
import cn.dev33.satoken.router.SaHttpMethod;
import cn.dev33.satoken.router.SaRouter;
import cn.dev33.satoken.stp.StpUtil;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Sa-Token 权限认证配置
 *
 * <p>注册 Sa-Token 拦截器，配置路由拦截规则和 CORS 跨域处理。</p>
 *
 * @author mall
 */
@Configuration
public class SaTokenConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 注册 Sa-Token 拦截器，打开注解式鉴权功能
        registry.addInterceptor(new SaInterceptor(handler -> {
                    // 指定一条匹配路由规则，排除不需要鉴权的路径
                    SaRouter
                            .match("/**")
                            // 排除用户端登录和注册接口
                            .notMatch("/auth/**")
                            // 排除管理端登录接口
                            .notMatch("/admin/auth/login")
                            // 排除公共 API（无需登录即可访问）
                            .notMatch("/api/**")
                            // 排除 Knife4j 静态资源
                            .notMatch("/doc.html", "/webjars/**", "/v3/**", "/swagger-resources/**")
                            // 排除文件上传预览路径
                            .notMatch("/uploads/**")
                            // 校验是否登录
                            .check(StpUtil::checkLogin);

                    // 根据请求方法进行路由拦截
                    SaRouter.match(SaHttpMethod.OPTIONS).check(r -> {
                        // 预检请求直接放行
                        System.out.println("OPTIONS 请求放行");
                    });

                }))
                // 拦截所有路径
                .addPathPatterns("/**");
    }

}