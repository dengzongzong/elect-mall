package com.mall.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * MyBatis-Plus 配置类
 *
 * <p>配置分页插件等 MyBatis-Plus 功能。</p>
 *
 * @author mall
 */
@Configuration
public class MyBatisPlusConfig {

    /**
     * MyBatis-Plus 拦截器集合
     *
     * <p>注册分页插件，自动识别数据库类型。</p>
     */
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();

        // 分页插件，指定数据库类型为 MySQL
        PaginationInnerInterceptor paginationInterceptor = new PaginationInnerInterceptor(DbType.MYSQL);
        // 设置请求的页面大于最大页后是否返回空页，true 返回空页，false 继续查询
        paginationInterceptor.setOverflow(true);
        // 设置单页最大条数限制，默认 500 条
        paginationInterceptor.setMaxLimit(500L);

        interceptor.addInnerInterceptor(paginationInterceptor);

        return interceptor;
    }

}