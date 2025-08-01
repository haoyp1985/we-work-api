package com.wework.platform.common.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.Data;

import java.io.Serializable;

/**
 * 分页请求参数
 * 
 * @author WeWork Platform Team
 */
@Data
public class PageRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 页码（从1开始）
     */
    @Min(value = 1, message = "页码必须大于0")
    private Integer page = 1;

    /**
     * 每页大小
     */
    @Min(value = 1, message = "每页大小必须大于0")
    @Max(value = 1000, message = "每页大小不能超过1000")
    private Integer size = 20;

    /**
     * 排序字段
     */
    private String sortBy;

    /**
     * 排序方向（asc/desc）
     */
    private String sortDir = "desc";

    /**
     * 搜索关键词
     */
    private String keyword;

    /**
     * 获取偏移量
     */
    public Long getOffset() {
        return (long) (page - 1) * size;
    }

    /**
     * 获取限制数量
     */
    public Integer getLimit() {
        return size;
    }
}