package com.wework.platform.gateway.filter;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.stereotype.Component;

/**
 * 跳过认证过滤器工厂
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Slf4j
@Component
public class SkipAuthGatewayFilterFactory extends AbstractGatewayFilterFactory<Object> {

    @Override
    public GatewayFilter apply(Object config) {
        return (exchange, chain) -> {
            // 添加跳过认证标记
            exchange.getAttributes().put("skipAuth", true);
            log.debug("标记路径 {} 跳过认证", exchange.getRequest().getURI().getPath());
            return chain.filter(exchange);
        };
    }
}