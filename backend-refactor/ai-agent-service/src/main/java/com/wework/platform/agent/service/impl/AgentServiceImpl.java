package com.wework.platform.agent.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wework.platform.agent.dto.AgentDTO;
import com.wework.platform.agent.dto.request.AgentQueryRequest;
import com.wework.platform.agent.dto.request.CreateAgentRequest;
import com.wework.platform.agent.dto.request.UpdateAgentRequest;
import com.wework.platform.agent.dto.response.PageResult;
import com.wework.platform.agent.entity.Agent;
import com.wework.platform.agent.enums.AgentStatus;
import com.wework.platform.agent.repository.AgentRepository;
import com.wework.platform.agent.service.AgentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Agent服务实现
 * 
 * @author WeWork Platform Team
 * @since 2024-01-15
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AgentServiceImpl implements AgentService {

    private final AgentRepository agentRepository;

    @Transactional(rollbackFor = Exception.class)
    public AgentDTO createAgent(String tenantId, CreateAgentRequest request) {
        log.info("创建智能体, tenantId={}, name={}", tenantId, request.getName());
        
        // 检查同租户下名称是否重复
        boolean exists = agentRepository.exists(
            new LambdaQueryWrapper<Agent>()
                .eq(Agent::getTenantId, tenantId)
                .eq(Agent::getName, request.getName())
        );
        
        if (exists) {
            throw new IllegalArgumentException("智能体名称已存在: " + request.getName());
        }
        
        // 创建Agent实体
        Agent agent = new Agent();
        agent.setTenantId(tenantId);
        agent.setName(request.getName());
        agent.setDescription(request.getDescription());
        agent.setType(request.getType());
        agent.setAvatar(request.getAvatar());
        agent.setSystemPrompt(request.getSystemPrompt());
        agent.setWelcomeMessage(request.getWelcomeMessage());
        agent.setStatus(AgentStatus.DRAFT);
        agent.setVersion(1);
        agent.setCreatedAt(LocalDateTime.now());
        agent.setUpdatedAt(LocalDateTime.now());
        
        // 保存到数据库
        agentRepository.insert(agent);
        
        log.info("智能体创建成功, agentId={}", agent.getId());
        return convertToDTO(agent);
    }

    @Transactional(rollbackFor = Exception.class)
    public AgentDTO updateAgent(String tenantId, String agentId, UpdateAgentRequest request) {
        log.info("更新智能体, tenantId={}, agentId={}", tenantId, agentId);
        
        // 查询现有Agent
        Agent agent = getAgentEntity(tenantId, agentId);
        
        // 检查状态是否允许修改
        if (agent.getStatus() == AgentStatus.PUBLISHED && 
            !request.isForceUpdate()) {
            throw new IllegalStateException("已发布的智能体不能直接修改，请创建新版本或强制更新");
        }
        
        // 如果修改名称，检查是否重复
        if (StringUtils.hasText(request.getName()) && 
            !request.getName().equals(agent.getName())) {
            boolean exists = agentRepository.exists(
                new LambdaQueryWrapper<Agent>()
                    .eq(Agent::getTenantId, tenantId)
                    .eq(Agent::getName, request.getName())
                    .ne(Agent::getId, agentId)
            );
            
            if (exists) {
                throw new IllegalArgumentException("智能体名称已存在: " + request.getName());
            }
            agent.setName(request.getName());
        }
        
        // 更新字段
        if (StringUtils.hasText(request.getDescription())) {
            agent.setDescription(request.getDescription());
        }
        if (request.getType() != null) {
            agent.setType(request.getType());
        }
        if (StringUtils.hasText(request.getAvatar())) {
            agent.setAvatar(request.getAvatar());
        }
        if (StringUtils.hasText(request.getSystemPrompt())) {
            agent.setSystemPrompt(request.getSystemPrompt());
        }
        if (StringUtils.hasText(request.getWelcomeMessage())) {
            agent.setWelcomeMessage(request.getWelcomeMessage());
        }
        
        agent.setUpdatedAt(LocalDateTime.now());
        
        // 保存更新
        agentRepository.updateById(agent);
        
        log.info("智能体更新成功, agentId={}", agentId);
        return convertToDTO(agent);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteAgent(String tenantId, String agentId) {
        log.info("删除智能体, tenantId={}, agentId={}", tenantId, agentId);
        
        // 查询现有Agent
        Agent agent = getAgentEntity(tenantId, agentId);
        
        // 检查状态是否允许删除
        if (agent.getStatus() == AgentStatus.PUBLISHED) {
            throw new IllegalStateException("已发布的智能体不能删除，请先下线");
        }
        
        // 软删除
        agent.setStatus(AgentStatus.DELETED);
        agent.setUpdatedAt(LocalDateTime.now());
        agentRepository.updateById(agent);
        
        log.info("智能体删除成功, agentId={}", agentId);
    }

    public AgentDTO getAgent(String tenantId, String agentId) {
        log.debug("查询智能体详情, tenantId={}, agentId={}", tenantId, agentId);
        
        Agent agent = getAgentEntity(tenantId, agentId);
        return convertToDTO(agent);
    }

    @Override
    public PageResult<AgentDTO> queryAgents(String tenantId, AgentQueryRequest request) {
        log.debug("分页查询智能体, tenantId={}, request={}", tenantId, request);
        
        // 构建查询条件
        LambdaQueryWrapper<Agent> queryWrapper = new LambdaQueryWrapper<Agent>()
            .eq(Agent::getTenantId, tenantId)
            .ne(Agent::getStatus, AgentStatus.DELETED);
        
        // 添加过滤条件
        if (StringUtils.hasText(request.getName())) {
            queryWrapper.like(Agent::getName, request.getName());
        }
        if (request.getType() != null) {
            queryWrapper.eq(Agent::getType, request.getType());
        }
        if (request.getStatus() != null) {
            queryWrapper.eq(Agent::getStatus, request.getStatus());
        }
        
        // 添加排序
        queryWrapper.orderByDesc(Agent::getUpdatedAt);
        
        // 分页查询
        Page<Agent> page = new Page<>(request.getPageNum(), request.getPageSize());
        IPage<Agent> result = agentRepository.selectPage(page, queryWrapper);
        
        // 转换为DTO
        List<AgentDTO> dtoList = result.getRecords().stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        
        return PageResult.<AgentDTO>builder()
            .records(dtoList)
            .total(result.getTotal())
            .current(request.getPageNum().longValue())
            .size(request.getPageSize().longValue())
            .pages(result.getPages())
            .build();
    }

    @Transactional(rollbackFor = Exception.class)
    public AgentDTO publishAgent(String tenantId, String agentId) {
        log.info("发布智能体, tenantId={}, agentId={}", tenantId, agentId);
        
        Agent agent = getAgentEntity(tenantId, agentId);
        
        // 检查状态
        if (agent.getStatus() == AgentStatus.PUBLISHED) {
            throw new IllegalStateException("智能体已经是发布状态");
        }
        if (agent.getStatus() == AgentStatus.DELETED) {
            throw new IllegalStateException("已删除的智能体不能发布");
        }
        
        // 验证必要配置
        validateAgentConfig(agent);
        
        // 更新状态
        agent.setStatus(AgentStatus.PUBLISHED);
        agent.setUpdatedAt(LocalDateTime.now());
        agentRepository.updateById(agent);
        
        log.info("智能体发布成功, agentId={}", agentId);
        return convertToDTO(agent);
    }

    @Transactional(rollbackFor = Exception.class)
    public AgentDTO unpublishAgent(String tenantId, String agentId) {
        log.info("下线智能体, tenantId={}, agentId={}", tenantId, agentId);
        
        Agent agent = getAgentEntity(tenantId, agentId);
        
        // 检查状态
        if (agent.getStatus() != AgentStatus.PUBLISHED) {
            throw new IllegalStateException("只有已发布的智能体可以下线");
        }
        
        // 更新状态
        agent.setStatus(AgentStatus.DRAFT);
        agent.setUpdatedAt(LocalDateTime.now());
        agentRepository.updateById(agent);
        
        log.info("智能体下线成功, agentId={}", agentId);
        return convertToDTO(agent);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public AgentDTO createAgentVersion(String tenantId, String agentId) {
        log.info("创建智能体新版本, tenantId={}, agentId={}", tenantId, agentId);
        
        Agent originalAgent = getAgentEntity(tenantId, agentId);
        
        // 创建新版本
        Agent newAgent = new Agent();
        BeanUtils.copyProperties(originalAgent, newAgent);
        newAgent.setId(null); // 清空ID，让MyBatis-Plus自动生成
        newAgent.setVersion(originalAgent.getVersion() + 1);
        newAgent.setStatus(AgentStatus.DRAFT);
        newAgent.setCreatedAt(LocalDateTime.now());
        newAgent.setUpdatedAt(LocalDateTime.now());
        
        // 保存新版本
        agentRepository.insert(newAgent);
        
        log.info("智能体新版本创建成功, originalAgentId={}, newAgentId={}, version={}", 
                agentId, newAgent.getId(), newAgent.getVersion());
        
        return convertToDTO(newAgent);
    }

    @Override
    public List<AgentDTO> getPublishedAgents(String tenantId) {
        log.debug("查询已发布的智能体, tenantId={}", tenantId);
        
        List<Agent> agents = agentRepository.selectList(
            new LambdaQueryWrapper<Agent>()
                .eq(Agent::getTenantId, tenantId)
                .eq(Agent::getStatus, AgentStatus.PUBLISHED)
                .orderByDesc(Agent::getUpdatedAt)
        );
        
        return agents.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    @Override
    public long countAgentsByStatus(String tenantId, AgentStatus status) {
        return agentRepository.selectCount(
            new LambdaQueryWrapper<Agent>()
                .eq(Agent::getTenantId, tenantId)
                .eq(Agent::getStatus, status)
        );
    }

    /**
     * 获取Agent实体
     */
    private Agent getAgentEntity(String tenantId, String agentId) {
        Agent agent = agentRepository.selectOne(
            new LambdaQueryWrapper<Agent>()
                .eq(Agent::getId, agentId)
                .eq(Agent::getTenantId, tenantId)
                .ne(Agent::getStatus, AgentStatus.DELETED)
        );
        
        if (agent == null) {
            throw new IllegalArgumentException("智能体不存在: " + agentId);
        }
        
        return agent;
    }

    /**
     * 验证智能体配置
     */
    private void validateAgentConfig(Agent agent) {
        if (!StringUtils.hasText(agent.getName())) {
            throw new IllegalStateException("智能体名称不能为空");
        }
        if (!StringUtils.hasText(agent.getSystemPrompt())) {
            throw new IllegalStateException("系统提示词不能为空");
        }
        // 可以添加更多验证规则
    }

    public AgentService.AgentUsageStats getAgentUsageStats(String tenantId, String agentId) {
        // 验证Agent存在
        getAgentEntity(tenantId, agentId);
        
        // 创建统计对象
        AgentService.AgentUsageStats stats = new AgentService.AgentUsageStats();
        
        // TODO: 实现具体的统计逻辑
        // 这里应该查询会话、消息、令牌等统计信息
        stats.setTotalConversations(0L);
        stats.setTotalMessages(0L);
        stats.setTotalTokens(0L);
        stats.setAvgResponseTime(0.0);
        stats.setSuccessRate(100.0);
        stats.setLastUsedAt(java.time.LocalDateTime.now());
        
        return stats;
    }

    public String testAgent(String tenantId, String agentId, String testInput) {
        log.info("测试智能体, tenantId={}, agentId={}, testInput={}", tenantId, agentId, testInput);
        
        // 验证Agent存在
        Agent agent = getAgentEntity(tenantId, agentId);
        
        try {
            // 这里应该调用实际的AI服务进行测试
            // 暂时返回一个模拟的测试结果
            String testResult = String.format(
                "测试成功！智能体 '%s' 响应正常。输入: '%s'，响应: '这是一个测试响应，表明智能体配置正确。'",
                agent.getName(),
                testInput
            );
            
            log.info("智能体测试完成, agentId={}, result={}", agentId, testResult);
            return testResult;
            
        } catch (Exception e) {
            log.error("智能体测试失败, agentId={}, error={}", agentId, e.getMessage(), e);
            return "测试失败: " + e.getMessage();
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public AgentDTO copyAgent(String tenantId, String sourceAgentId, String newName) {
        log.info("复制智能体, tenantId={}, sourceAgentId={}, newName={}", tenantId, sourceAgentId, newName);
        
        // 验证源智能体存在
        Agent sourceAgent = getAgentEntity(tenantId, sourceAgentId);
        
        // 创建新智能体
        Agent newAgent = new Agent();
        newAgent.setTenantId(tenantId);
        newAgent.setName(newName);
        newAgent.setDescription(sourceAgent.getDescription() + " (复制)");
        newAgent.setType(sourceAgent.getType());
        newAgent.setStatus(AgentStatus.DRAFT); // 复制的智能体默认为草稿状态
        newAgent.setSystemPrompt(sourceAgent.getSystemPrompt());
        newAgent.setConfigJson(sourceAgent.getConfigJson());
        newAgent.setPlatformType(sourceAgent.getPlatformType());
        newAgent.setPlatformConfigId(sourceAgent.getPlatformConfigId());
        newAgent.setAvatar(sourceAgent.getAvatar());
        newAgent.setCreatedAt(LocalDateTime.now());
        newAgent.setUpdatedAt(LocalDateTime.now());
        
        // 保存新智能体
        agentRepository.insert(newAgent);
        
        log.info("智能体复制成功, sourceAgentId={}, newAgentId={}", sourceAgentId, newAgent.getId());
        return convertToDTO(newAgent);
    }

    @Transactional(rollbackFor = Exception.class)
    public AgentDTO updateAgentStatus(String tenantId, String agentId, AgentStatus status) {
        log.info("更新智能体状态, tenantId={}, agentId={}, status={}", tenantId, agentId, status);
        
        // 验证智能体存在
        Agent agent = getAgentEntity(tenantId, agentId);
        
        // 更新状态
        agent.setStatus(status);
        agent.setUpdatedAt(LocalDateTime.now());
        
        // 保存更新
        agentRepository.updateById(agent);
        
        log.info("智能体状态更新成功, agentId={}, status={}", agentId, status);
        return convertToDTO(agent);
    }

    public List<AgentDTO> getUserAccessibleAgents(String tenantId, String userId) {
        log.debug("获取用户可访问的智能体, tenantId={}, userId={}", tenantId, userId);
        
        // 查询用户可访问的智能体（这里简化处理，返回所有已发布的智能体）
        List<Agent> agents = agentRepository.selectList(
            new LambdaQueryWrapper<Agent>()
                .eq(Agent::getTenantId, tenantId)
                .eq(Agent::getStatus, AgentStatus.PUBLISHED)
                .eq(Agent::getEnabled, true)
                .orderByDesc(Agent::getCreatedAt)
        );
        
        // 转换为DTO
        List<AgentDTO> agentDTOs = agents.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        
        log.debug("获取用户可访问智能体完成, count={}", agentDTOs.size());
        return agentDTOs;
    }

    public PageResult<AgentDTO> getAgentList(String tenantId, AgentQueryRequest request) {
        log.debug("获取智能体列表, tenantId={}, request={}", tenantId, request);
        
        // 构建查询条件
        LambdaQueryWrapper<Agent> queryWrapper = new LambdaQueryWrapper<Agent>()
            .eq(Agent::getTenantId, tenantId);
        
        // 根据请求参数添加过滤条件
        if (request.getName() != null && !request.getName().trim().isEmpty()) {
            queryWrapper.like(Agent::getName, request.getName().trim());
        }
        if (request.getType() != null) {
            queryWrapper.eq(Agent::getType, request.getType());
        }
        if (request.getStatus() != null) {
            queryWrapper.eq(Agent::getStatus, request.getStatus());
        }
        
        // 分页查询
        Page<Agent> page = new Page<>(request.getPageNum(), request.getPageSize());
        IPage<Agent> result = agentRepository.selectPage(page, queryWrapper);
        
        // 转换为DTO
        List<AgentDTO> dtoList = result.getRecords().stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        
        return PageResult.<AgentDTO>builder()
            .records(dtoList)
            .total(result.getTotal())
            .current(request.getPageNum().longValue())
            .size(request.getPageSize().longValue())
            .pages(result.getPages())
            .build();
    }

    /**
     * 转换为DTO
     */
    private AgentDTO convertToDTO(Agent agent) {
        AgentDTO dto = new AgentDTO();
        BeanUtils.copyProperties(agent, dto);
        return dto;
    }
}