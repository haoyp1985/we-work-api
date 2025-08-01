package com.wework.platform.message.controller;

import com.wework.platform.common.dto.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 测试控制器 - 用于前后端联调验证
 */
@Slf4j
@RestController
@RequestMapping("/test")
public class TestController {

    @GetMapping("/ping")
    public ApiResponse<String> ping() {
        log.info("收到ping请求");
        return ApiResponse.success("pong from message-service - " + LocalDateTime.now());
    }

    @GetMapping("/no-auth")
    public Map<String, Object> noAuth() {
        log.info("收到无认证测试请求");
        Map<String, Object> result = new HashMap<>();
        result.put("service", "message-service");
        result.put("timestamp", LocalDateTime.now());
        result.put("status", "ok");
        result.put("message", "前后端联调测试成功！");
        return result;
    }

    @PostMapping("/echo")
    public ApiResponse<Map<String, Object>> echo(@RequestBody Map<String, Object> request) {
        log.info("收到echo请求: {}", request);
        
        Map<String, Object> response = new HashMap<>();
        response.put("received", request);
        response.put("timestamp", LocalDateTime.now());
        response.put("service", "message-service");
        
        return ApiResponse.success("Echo测试成功", response);
    }
}