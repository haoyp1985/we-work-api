package com.wework.platform.common.core.exception;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wework.platform.common.core.base.Result;
import com.wework.platform.common.enums.ResultCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.DispatcherHandler;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * WebFlux全局异常处理器
 * 仅在存在DispatcherHandler且为REACTIVE类型的web应用时生效
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Slf4j
@Order(-1)
@Component
@RequiredArgsConstructor
@ConditionalOnClass(DispatcherHandler.class)
@ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.REACTIVE)
public class WebFluxGlobalExceptionHandler implements ErrorWebExceptionHandler {

    private final ObjectMapper objectMapper;

    @Override
    public Mono<Void> handle(ServerWebExchange exchange, Throwable ex) {
        ServerHttpResponse response = exchange.getResponse();
        
        if (response.isCommitted()) {
            return Mono.error(ex);
        }

        // 设置响应头
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
        
        Result<Void> result;
        HttpStatus httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;

        if (ex instanceof BusinessException businessException) {
            httpStatus = HttpStatus.BAD_REQUEST;
            result = Result.error(businessException.getCode(), businessException.getMessage());
            log.warn("Gateway业务异常: {}", businessException.getMessage());
        } else if (ex instanceof ResponseStatusException responseStatusException) {
            httpStatus = HttpStatus.valueOf(responseStatusException.getStatusCode().value());
            result = Result.error(responseStatusException.getStatusCode().value(), 
                                responseStatusException.getReason());
            log.warn("Gateway响应状态异常: {}", responseStatusException.getMessage());
        } else if (ex instanceof IllegalArgumentException illegalArgumentException) {
            httpStatus = HttpStatus.BAD_REQUEST;
            result = Result.error(ResultCode.PARAM_ERROR, illegalArgumentException.getMessage());
            log.warn("Gateway参数异常: {}", illegalArgumentException.getMessage());
        } else {
            result = Result.error(ResultCode.INTERNAL_SERVER_ERROR, "网关内部错误");
            log.error("Gateway未知异常", ex);
        }

        // 设置响应状态码
        response.setStatusCode(httpStatus);

        String body;
        try {
            body = objectMapper.writeValueAsString(result);
        } catch (JsonProcessingException e) {
            log.error("序列化错误响应失败", e);
            body = "{\"code\":500,\"message\":\"系统内部错误\",\"data\":null}";
        }

        DataBuffer buffer = response.bufferFactory().wrap(body.getBytes());
        return response.writeWith(Mono.just(buffer));
    }
}