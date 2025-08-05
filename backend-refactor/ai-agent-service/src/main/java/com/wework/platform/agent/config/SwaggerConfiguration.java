package com.wework.platform.agent.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Swagger文档配置
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Configuration
public class SwaggerConfiguration {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("AI智能体服务API")
                .description("WeWork平台AI智能体服务的REST API文档")
                .version("1.0.0")
                .contact(new Contact()
                    .name("WeWork Platform Team")
                    .email("platform@wework.com"))
                .license(new License()
                    .name("Internal Use")
                    .url("https://wework.com")))
            .components(new Components()
                .addSecuritySchemes("bearerAuth", new SecurityScheme()
                    .type(SecurityScheme.Type.HTTP)
                    .scheme("bearer")
                    .bearerFormat("JWT"))
                .addSecuritySchemes("tenantId", new SecurityScheme()
                    .type(SecurityScheme.Type.APIKEY)
                    .in(SecurityScheme.In.HEADER)
                    .name("X-Tenant-Id"))
                .addSecuritySchemes("userId", new SecurityScheme()
                    .type(SecurityScheme.Type.APIKEY)
                    .in(SecurityScheme.In.HEADER)
                    .name("X-User-Id")))
            .addSecurityItem(new SecurityRequirement()
                .addList("bearerAuth")
                .addList("tenantId")
                .addList("userId"));
    }
}