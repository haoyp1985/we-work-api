package com.wework.platform.agent.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 统一API响应结果DTO
 */
@Data
@Schema(description = "统一API响应结果")
public class ApiResult<T> {

    @Schema(description = "响应状态码")
    private Integer code;

    @Schema(description = "响应消息")
    private String message;

    @Schema(description = "响应数据")
    private T data;

    @Schema(description = "响应时间戳")
    private LocalDateTime timestamp;

    @Schema(description = "请求追踪ID")
    private String traceId;

    @Schema(description = "是否成功")
    private Boolean success;

    /**
     * 私有构造函数
     */
    private ApiResult() {
        this.timestamp = LocalDateTime.now();
    }

    /**
     * 成功响应(无数据)
     */
    public static <T> ApiResult<T> success() {
        return success(null);
    }

    /**
     * 成功响应(有数据)
     */
    public static <T> ApiResult<T> success(T data) {
        return success(data, "操作成功");
    }

    /**
     * 成功响应(有数据和消息)
     */
    public static <T> ApiResult<T> success(T data, String message) {
        ApiResult<T> result = new ApiResult<>();
        result.setCode(200);
        result.setMessage(message);
        result.setData(data);
        result.setSuccess(true);
        return result;
    }

    /**
     * 失败响应
     */
    public static <T> ApiResult<T> error(String message) {
        return error(500, message);
    }

    /**
     * 失败响应(指定状态码)
     */
    public static <T> ApiResult<T> error(Integer code, String message) {
        ApiResult<T> result = new ApiResult<>();
        result.setCode(code);
        result.setMessage(message);
        result.setSuccess(false);
        return result;
    }

    /**
     * 参数错误响应
     */
    public static <T> ApiResult<T> badRequest(String message) {
        return error(400, message);
    }

    /**
     * 未授权响应
     */
    public static <T> ApiResult<T> unauthorized(String message) {
        return error(401, message);
    }

    /**
     * 禁止访问响应
     */
    public static <T> ApiResult<T> forbidden(String message) {
        return error(403, message);
    }

    /**
     * 资源不存在响应
     */
    public static <T> ApiResult<T> notFound(String message) {
        return error(404, message);
    }

    /**
     * 设置追踪ID
     */
    public ApiResult<T> traceId(String traceId) {
        this.setTraceId(traceId);
        return this;
    }
}