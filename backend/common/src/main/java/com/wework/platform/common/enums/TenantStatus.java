package com.wework.platform.common.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 租户状态枚举
 * 
 * @author WeWork Platform Team
 */
@Getter
@AllArgsConstructor
public enum TenantStatus {

    /**
     * 活跃
     */
    ACTIVE("active", "活跃"),

    /**
     * 暂停
     */
    SUSPENDED("suspended", "暂停"),

    /**
     * 已删除
     */
    DELETED("deleted", "已删除");

    @EnumValue
    @JsonValue
    private final String code;
    private final String description;

    public static TenantStatus fromCode(String code) {
        for (TenantStatus status : values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown tenant status code: " + code);
    }
}