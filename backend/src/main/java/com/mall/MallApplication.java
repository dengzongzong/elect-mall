package com.mall;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 电子元器件商城系统 - 启动类
 *
 * @author mall
 */
@SpringBootApplication
@MapperScan("com.mall.**.mapper")
public class MallApplication {

    public static void main(String[] args) {
        SpringApplication.run(MallApplication.class, args);
        System.out.println("==========================================");
        System.out.println("  电子元器件商城系统启动成功！");
        System.out.println("  接口文档：http://localhost:9000/doc.html");
        System.out.println("==========================================");
    }

}