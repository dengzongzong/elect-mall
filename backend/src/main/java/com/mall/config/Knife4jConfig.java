package com.mall.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Knife4j / Swagger 接口文档配置
 *
 * <p>配置 OpenAPI 文档信息，访问地址：http://localhost:9000/doc.html</p>
 *
 * @author mall
 */
@Configuration
public class Knife4jConfig {

    /**
     * 自定义 OpenAPI 文档信息
     */
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        // 文档标题
                        .title("电子元器件商城API")
                        // 版本号
                        .version("1.0")
                        // 文档描述
                        .description("电子元器件商城系统后端接口文档，提供商品管理、订单管理、用户管理等 API 接口。")
                        // 联系人信息
                        .contact(new Contact()
                                .name("mall")
                                .email("support@mall.com")
                                .url("https://www.mall.com"))
                        // 许可证
                        .license(new License()
                                .name("Apache 2.0")
                                .url("https://www.apache.org/licenses/LICENSE-2.0")));
    }

}