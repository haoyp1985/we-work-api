package com.wework.platform.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 企微接口提供商类型枚举
 *
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum WeWorkProviderType {

    /**
     * 广州孤星（主要提供商）
     */
    GUANGZHOU_GUXING("GUANGZHOU_GUXING", "广州孤星", "广州孤星企微协议提供商"),

    /**
     * 备用提供商A
     */
    BACKUP_PROVIDER_A("BACKUP_PROVIDER_A", "备用提供商A", "备用企微接口提供商A"),

    /**
     * 备用提供商B
     */
    BACKUP_PROVIDER_B("BACKUP_PROVIDER_B", "备用提供商B", "备用企微接口提供商B"),

    /**
     * 自定义提供商
     */
    CUSTOM("CUSTOM", "自定义提供商", "用户自定义的企微接口提供商");

    /**
     * 提供商代码
     */
    private final String code;

    /**
     * 提供商名称
     */
    private final String name;

    /**
     * 提供商描述
     */
    private final String description;

    /**
     * 根据代码获取提供商类型
     */
    public static WeWorkProviderType fromCode(String code) {
        for (WeWorkProviderType type : values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown provider type code: " + code);
    }
}