package com.wework.platform.account.controller;

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
        return ApiResponse.success("pong - " + LocalDateTime.now());
    }

    @GetMapping("/accounts")
    public ApiResponse<Map<String, Object>> getTestAccounts(
            @RequestParam(value = "tenantId", required = false) String tenantId) {
        log.info("收到测试账号列表请求, tenantId: {}", tenantId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("total", 2);
        result.put("page", 1);
        result.put("size", 20);
        result.put("records", java.util.List.of(
            createTestAccount("acc-001", "测试账号1", "ONLINE"),
            createTestAccount("acc-002", "测试账号2", "OFFLINE")
        ));
        
        return ApiResponse.success("获取测试数据成功", result);
    }

    @PostMapping("/accounts")
    public ApiResponse<Map<String, Object>> createTestAccount(@RequestBody Map<String, Object> request) {
        log.info("收到创建账号请求: {}", request);
        
        Map<String, Object> account = createTestAccount(
            "acc-" + System.currentTimeMillis(),
            (String) request.get("accountName"),
            "CREATED"
        );
        
        return ApiResponse.success("账号创建成功", account);
    }

    private Map<String, Object> createTestAccount(String id, String name, String status) {
        Map<String, Object> account = new HashMap<>();
        account.put("id", id);
        account.put("accountName", name);
        account.put("accountStatus", status);
        account.put("tenantId", "tenant-001");
        account.put("createdAt", LocalDateTime.now());
        account.put("healthScore", 85);
        return account;
    }
}