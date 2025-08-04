package com.wework.platform.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 统一响应码枚举
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Getter
@AllArgsConstructor
public enum ResultCode {

    // ========== 成功响应 ==========
    SUCCESS(200, "操作成功"),

    // ========== 客户端错误 4xx ==========
    BAD_REQUEST(400, "请求参数错误"),
    UNAUTHORIZED(401, "未授权"),
    FORBIDDEN(403, "权限不足"),
    NOT_FOUND(404, "资源不存在"),
    METHOD_NOT_ALLOWED(405, "方法不允许"),
    CONFLICT(409, "资源冲突"),
    VALIDATION_ERROR(422, "参数验证失败"),
    TOO_MANY_REQUESTS(429, "请求过于频繁"),

    // ========== 服务端错误 5xx ==========
    INTERNAL_SERVER_ERROR(500, "服务器内部错误"),
    BAD_GATEWAY(502, "网关错误"),
    SERVICE_UNAVAILABLE(503, "服务不可用"),
    GATEWAY_TIMEOUT(504, "网关超时"),

    // ========== 业务错误 40xxx ==========
    // 用户相关
    USER_NOT_FOUND(40001, "用户不存在"),
    USER_ALREADY_EXISTS(40002, "用户已存在"),
    USER_DISABLED(40003, "用户已被禁用"),
    USER_LOCKED(40004, "用户已被锁定"),
    INVALID_CREDENTIALS(40005, "用户名或密码错误"),
    PASSWORD_EXPIRED(40006, "密码已过期"),

    // 租户相关
    TENANT_NOT_FOUND(40011, "租户不存在"),
    TENANT_DISABLED(40012, "租户已被禁用"),
    TENANT_QUOTA_EXCEEDED(40013, "租户配额已满"),

    // 角色权限相关
    ROLE_NOT_FOUND(40021, "角色不存在"),
    PERMISSION_DENIED(40022, "权限不足"),
    ROLE_ALREADY_EXISTS(40023, "角色已存在"),

    // 企微账号相关
    ACCOUNT_NOT_FOUND(40031, "企微账号不存在"),
    ACCOUNT_OFFLINE(40032, "企微账号离线"),
    ACCOUNT_ERROR(40033, "企微账号异常"),
    ACCOUNT_QUOTA_EXCEEDED(40034, "账号配额已满"),
    ACCOUNT_ALREADY_EXISTS(40035, "账号已存在"),

    // 消息相关
    MESSAGE_SEND_FAILED(40041, "消息发送失败"),
    MESSAGE_TEMPLATE_NOT_FOUND(40042, "消息模板不存在"),
    MESSAGE_QUOTA_EXCEEDED(40043, "消息配额已满"),
    MESSAGE_CONTENT_INVALID(40044, "消息内容无效"),
    MESSAGE_RECIPIENT_INVALID(40045, "消息接收者无效"),

    // 文件相关
    FILE_NOT_FOUND(40051, "文件不存在"),
    FILE_TOO_LARGE(40052, "文件过大"),
    FILE_TYPE_NOT_ALLOWED(40053, "文件类型不允许"),
    FILE_UPLOAD_FAILED(40054, "文件上传失败"),

    // 监控相关
    METRIC_NOT_FOUND(40061, "监控指标不存在"),
    ALERT_RULE_NOT_FOUND(40062, "告警规则不存在"),

    // ========== 系统错误 50xxx ==========
    DATABASE_ERROR(50001, "数据库操作失败"),
    REDIS_ERROR(50002, "Redis操作失败"),
    MQ_ERROR(50003, "消息队列操作失败"),
    EXTERNAL_API_ERROR(50004, "外部API调用失败"),
    CONFIG_ERROR(50005, "配置错误"),
    NETWORK_ERROR(50006, "网络错误"),

    // JWT相关
    JWT_INVALID(50011, "JWT令牌无效"),
    JWT_EXPIRED(50012, "JWT令牌已过期"),
    JWT_MALFORMED(50013, "JWT令牌格式错误"),

    // 企微API相关
    WEWORK_API_ERROR(50021, "企微API调用失败"),
    WEWORK_TOKEN_INVALID(50022, "企微令牌无效"),
    WEWORK_RATE_LIMIT(50023, "企微API限流"),

    // 第三方服务相关
    THIRD_PARTY_ERROR(50031, "第三方服务错误"),
    EMAIL_SEND_FAILED(50032, "邮件发送失败"),
    SMS_SEND_FAILED(50033, "短信发送失败");

    /**
     * 响应码
     */
    private final Integer code;

    /**
     * 响应消息
     */
    private final String message;

    /**
     * 根据代码获取枚举
     */
    public static ResultCode getByCode(Integer code) {
        for (ResultCode resultCode : values()) {
            if (resultCode.getCode().equals(code)) {
                return resultCode;
            }
        }
        return INTERNAL_SERVER_ERROR;
    }
}