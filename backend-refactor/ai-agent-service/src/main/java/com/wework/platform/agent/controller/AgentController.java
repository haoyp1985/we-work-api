package com.wework.platform.agent.controller;

import com.wework.platform.agent.dto.AgentDTO;
import com.wework.platform.agent.dto.request.AgentQueryRequest;
import com.wework.platform.agent.dto.request.CreateAgentRequest;
import com.wework.platform.agent.dto.request.UpdateAgentRequest;
import com.wework.platform.agent.dto.response.ApiResult;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.enums.AgentStatus;
import com.wework.platform.agent.service.AgentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import java.util.List;
import java.util.Map;

/**
 * 智能体管理控制器
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@RestController
@RequestMapping("/api/v1/agents")
@RequiredArgsConstructor
@Validated
@Tag(name = "智能体管理", description = "AI智能体的创建、编辑、发布等管理接口")
public class AgentController {

    private final AgentService agentService;

    @PostMapping
    @Operation(summary = "创建智能体", description = "创建新的AI智能体")
    public ApiResult<AgentDTO> createAgent(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "创建智能体请求", required = true)
            @Valid @RequestBody CreateAgentRequest request) {
        
        log.info("创建智能体, tenantId={}, name={}", tenantId, request.getName());
        
        try {
            AgentDTO agent = agentService.createAgent(tenantId, request);
            
            log.info("智能体创建成功, agentId={}", agent.getId());
            return ApiResult.success(agent);
            
        } catch (Exception e) {
            log.error("创建智能体失败, tenantId={}, name={}, error={}", 
                     tenantId, request.getName(), e.getMessage(), e);
            return ApiResult.error("创建智能体失败: " + e.getMessage());
        }
    }

    @PutMapping("/{agentId}")
    @Operation(summary = "更新智能体", description = "更新智能体信息")
    public ApiResult<AgentDTO> updateAgent(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "智能体ID", required = true)
            @PathVariable @NotBlank String agentId,
            
            @Parameter(description = "更新智能体请求", required = true)
            @Valid @RequestBody UpdateAgentRequest request) {
        
        log.info("更新智能体, tenantId={}, agentId={}", tenantId, agentId);
        
        try {
            AgentDTO agent = agentService.updateAgent(tenantId, agentId, request);
            
            log.info("智能体更新成功, agentId={}", agentId);
            return ApiResult.success(agent);
            
        } catch (Exception e) {
            log.error("更新智能体失败, tenantId={}, agentId={}, error={}", 
                     tenantId, agentId, e.getMessage(), e);
            return ApiResult.error("更新智能体失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{agentId}")
    @Operation(summary = "删除智能体", description = "删除指定的智能体")
    public ApiResult<Void> deleteAgent(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "智能体ID", required = true)
            @PathVariable @NotBlank String agentId) {
        
        log.info("删除智能体, tenantId={}, agentId={}", tenantId, agentId);
        
        try {
            agentService.deleteAgent(tenantId, agentId);
            
            log.info("智能体删除成功, agentId={}", agentId);
            return ApiResult.success();
            
        } catch (Exception e) {
            log.error("删除智能体失败, tenantId={}, agentId={}, error={}", 
                     tenantId, agentId, e.getMessage(), e);
            return ApiResult.error("删除智能体失败: " + e.getMessage());
        }
    }

    @GetMapping("/{agentId}")
    @Operation(summary = "获取智能体详情", description = "根据ID获取智能体详细信息")
    public ApiResult<AgentDTO> getAgent(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "智能体ID", required = true)
            @PathVariable @NotBlank String agentId) {
        
        log.debug("获取智能体详情, tenantId={}, agentId={}", tenantId, agentId);
        
        try {
            AgentDTO agent = agentService.getAgent(tenantId, agentId);
            
            return ApiResult.success(agent);
            
        } catch (Exception e) {
            log.error("获取智能体详情失败, tenantId={}, agentId={}, error={}", 
                     tenantId, agentId, e.getMessage(), e);
            return ApiResult.error("获取智能体详情失败: " + e.getMessage());
        }
    }

    @GetMapping
    @Operation(summary = "分页查询智能体", description = "根据条件分页查询智能体列表")
    public ApiResult<PageResult<AgentDTO>> queryAgents(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "智能体名称", required = false)
            @RequestParam(required = false) String name,
            
            @Parameter(description = "智能体类型", required = false)
            @RequestParam(required = false) String type,
            
            @Parameter(description = "智能体状态", required = false)
            @RequestParam(required = false) AgentStatus status,
            
            @Parameter(description = "页码", required = false)
            @RequestParam(defaultValue = "1") int pageNum,
            
            @Parameter(description = "每页大小", required = false)
            @RequestParam(defaultValue = "20") int pageSize) {
        
        log.debug("分页查询智能体, tenantId={}, name={}, type={}, status={}", 
                 tenantId, name, type, status);
        
        try {
            AgentQueryRequest request = AgentQueryRequest.builder()
                .name(name)
                .type(type != null ? Enum.valueOf(com.wework.platform.agent.enums.AgentType.class, type) : null)
                .status(status)
                .pageNum(pageNum)
                .pageSize(pageSize)
                .build();
            
            PageResult<AgentDTO> result = agentService.queryAgents(tenantId, request);
            
            return ApiResult.success(result);
            
        } catch (Exception e) {
            log.error("分页查询智能体失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("查询智能体失败: " + e.getMessage());
        }
    }

    @PostMapping("/{agentId}/publish")
    @Operation(summary = "发布智能体", description = "将智能体发布上线")
    public ApiResult<AgentDTO> publishAgent(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "智能体ID", required = true)
            @PathVariable @NotBlank String agentId) {
        
        log.info("发布智能体, tenantId={}, agentId={}", tenantId, agentId);
        
        try {
            AgentDTO agent = agentService.publishAgent(tenantId, agentId);
            
            log.info("智能体发布成功, agentId={}", agentId);
            return ApiResult.success(agent);
            
        } catch (Exception e) {
            log.error("发布智能体失败, tenantId={}, agentId={}, error={}", 
                     tenantId, agentId, e.getMessage(), e);
            return ApiResult.error("发布智能体失败: " + e.getMessage());
        }
    }

    @PostMapping("/{agentId}/unpublish")
    @Operation(summary = "下线智能体", description = "将智能体下线")
    public ApiResult<AgentDTO> unpublishAgent(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "智能体ID", required = true)
            @PathVariable @NotBlank String agentId) {
        
        log.info("下线智能体, tenantId={}, agentId={}", tenantId, agentId);
        
        try {
            AgentDTO agent = agentService.unpublishAgent(tenantId, agentId);
            
            log.info("智能体下线成功, agentId={}", agentId);
            return ApiResult.success(agent);
            
        } catch (Exception e) {
            log.error("下线智能体失败, tenantId={}, agentId={}, error={}", 
                     tenantId, agentId, e.getMessage(), e);
            return ApiResult.error("下线智能体失败: " + e.getMessage());
        }
    }

    @PostMapping("/{agentId}/version")
    @Operation(summary = "创建智能体新版本", description = "基于现有智能体创建新版本")
    public ApiResult<AgentDTO> createAgentVersion(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId,
            
            @Parameter(description = "智能体ID", required = true)
            @PathVariable @NotBlank String agentId) {
        
        log.info("创建智能体新版本, tenantId={}, agentId={}", tenantId, agentId);
        
        try {
            AgentDTO agent = agentService.createAgentVersion(tenantId, agentId);
            
            log.info("智能体新版本创建成功, originalAgentId={}, newAgentId={}", 
                    agentId, agent.getId());
            return ApiResult.success(agent);
            
        } catch (Exception e) {
            log.error("创建智能体新版本失败, tenantId={}, agentId={}, error={}", 
                     tenantId, agentId, e.getMessage(), e);
            return ApiResult.error("创建新版本失败: " + e.getMessage());
        }
    }

    @GetMapping("/published")
    @Operation(summary = "获取已发布的智能体", description = "获取租户下所有已发布的智能体")
    public ApiResult<List<AgentDTO>> getPublishedAgents(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId) {
        
        log.debug("获取已发布的智能体, tenantId={}", tenantId);
        
        try {
            List<AgentDTO> agents = agentService.getPublishedAgents(tenantId);
            
            return ApiResult.success(agents);
            
        } catch (Exception e) {
            log.error("获取已发布智能体失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取已发布智能体失败: " + e.getMessage());
        }
    }

    @GetMapping("/statistics")
    @Operation(summary = "获取智能体统计信息", description = "获取租户下智能体的统计数据")
    public ApiResult<Map<String, Long>> getAgentStatistics(
            @Parameter(description = "租户ID", required = true)
            @RequestHeader("X-Tenant-Id") @NotBlank String tenantId) {
        
        log.debug("获取智能体统计信息, tenantId={}", tenantId);
        
        try {
            Map<String, Long> statistics = Map.of(
                "DRAFT", agentService.countAgentsByStatus(tenantId, AgentStatus.DRAFT),
                "PUBLISHED", agentService.countAgentsByStatus(tenantId, AgentStatus.PUBLISHED),
                "DELETED", agentService.countAgentsByStatus(tenantId, AgentStatus.DELETED)
            );
            
            return ApiResult.success(statistics);
            
        } catch (Exception e) {
            log.error("获取智能体统计信息失败, tenantId={}, error={}", tenantId, e.getMessage(), e);
            return ApiResult.error("获取统计信息失败: " + e.getMessage());
        }
    }
}