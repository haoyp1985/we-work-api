package com.wework.platform.message.provider;

import com.wework.platform.common.enums.MessageTemplateType;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * 企微接口提供商管理器
 * 
 * 负责管理多个企微接口提供商，实现负载均衡和故障转移
 *
 * @author WeWork Platform Team
 */
@Slf4j
@Component
public class WeWorkProviderManager {

    private final List<WeWorkApiProvider> providers;
    private final Map<String, WeWorkApiProvider> providerMap;

    public WeWorkProviderManager(List<WeWorkApiProvider> providers) {
        this.providers = providers.stream()
                .filter(WeWorkApiProvider::isEnabled)
                .sorted(Comparator.comparingInt(WeWorkApiProvider::getPriority))
                .toList();
        
        this.providerMap = this.providers.stream()
                .collect(Collectors.toMap(
                    WeWorkApiProvider::getProviderCode,
                    provider -> provider
                ));
        
        log.info("已加载企微接口提供商: {}", 
                this.providers.stream()
                        .map(p -> String.format("%s(优先级:%d)", p.getProviderName(), p.getPriority()))
                        .collect(Collectors.joining(", ")));
    }

    /**
     * 获取所有启用的提供商
     */
    public List<WeWorkApiProvider> getAllProviders() {
        return providers;
    }

    /**
     * 根据代码获取指定提供商
     */
    public Optional<WeWorkApiProvider> getProvider(String providerCode) {
        return Optional.ofNullable(providerMap.get(providerCode));
    }

    /**
     * 获取默认提供商（优先级最高的可用提供商）
     */
    public WeWorkApiProvider getDefaultProvider() {
        return providers.stream()
                .filter(WeWorkApiProvider::isEnabled)
                .filter(WeWorkApiProvider::healthCheck)
                .findFirst()
                .orElseThrow(() -> new RuntimeException("没有可用的企微接口提供商"));
    }

    /**
     * 获取支持指定消息类型的提供商
     */
    public WeWorkApiProvider getProviderForMessageType(MessageTemplateType messageType) {
        return providers.stream()
                .filter(WeWorkApiProvider::isEnabled)
                .filter(provider -> provider.supportsMessageType(messageType))
                .filter(WeWorkApiProvider::healthCheck)
                .findFirst()
                .orElseThrow(() -> new RuntimeException("没有支持该消息类型的提供商: " + messageType));
    }

    /**
     * 获取支持指定功能的提供商
     */
    public WeWorkApiProvider getProviderForFeature(String feature) {
        return providers.stream()
                .filter(WeWorkApiProvider::isEnabled)
                .filter(provider -> provider.supports(feature))
                .filter(WeWorkApiProvider::healthCheck)
                .findFirst()
                .orElseThrow(() -> new RuntimeException("没有支持该功能的提供商: " + feature));
    }

    /**
     * 故障转移：获取下一个可用的提供商
     */
    public Optional<WeWorkApiProvider> getNextAvailableProvider(String currentProviderCode) {
        // 找到当前提供商的索引
        int currentIndex = -1;
        for (int i = 0; i < providers.size(); i++) {
            if (providers.get(i).getProviderCode().equals(currentProviderCode)) {
                currentIndex = i;
                break;
            }
        }
        
        // 从下一个提供商开始查找
        for (int i = currentIndex + 1; i < providers.size(); i++) {
            WeWorkApiProvider provider = providers.get(i);
            if (provider.isEnabled() && provider.healthCheck()) {
                return Optional.of(provider);
            }
        }
        
        return Optional.empty();
    }

    /**
     * 执行健康检查
     */
    public Map<String, Boolean> healthCheck() {
        return providers.stream()
                .collect(Collectors.toMap(
                    WeWorkApiProvider::getProviderCode,
                    provider -> {
                        try {
                            return provider.healthCheck();
                        } catch (Exception e) {
                            log.warn("提供商健康检查失败: {}, 错误: {}", 
                                    provider.getProviderCode(), e.getMessage());
                            return false;
                        }
                    }
                ));
    }

    /**
     * 获取提供商统计信息
     */
    public Map<String, Object> getProviderStats() {
        return Map.of(
            "total", providers.size(),
            "enabled", providers.stream().mapToInt(p -> p.isEnabled() ? 1 : 0).sum(),
            "healthy", providers.stream().mapToInt(p -> {
                try {
                    return p.healthCheck() ? 1 : 0;
                } catch (Exception e) {
                    return 0;
                }
            }).sum(),
            "providers", providers.stream().map(p -> Map.of(
                "code", p.getProviderCode(),
                "name", p.getProviderName(),
                "enabled", p.isEnabled(),
                "priority", p.getPriority(),
                "healthy", safeHealthCheck(p)
            )).toList()
        );
    }

    /**
     * 安全的健康检查
     */
    private boolean safeHealthCheck(WeWorkApiProvider provider) {
        try {
            return provider.healthCheck();
        } catch (Exception e) {
            return false;
        }
    }
}