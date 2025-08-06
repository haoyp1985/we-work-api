package com.wework.platform.common.core.base;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

/**
 * 分页查询参数
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageQuery implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 页码（从1开始）
     */
    @Builder.Default
    private Integer pageNum = 1;

    /**
     * 每页大小
     */
    @Builder.Default
    private Integer pageSize = 20;

    /**
     * 排序字段
     */
    private String sortBy;

    /**
     * 排序方向（asc/desc）
     */
    @Builder.Default
    private String sortOrder = "desc";

    /**
     * 搜索关键词
     */
    private String keyword;

    /**
     * 获取偏移量
     */
    public Long getOffset() {
        return (long) (pageNum - 1) * pageSize;
    }

    /**
     * 获取限制数量
     */
    public Integer getLimit() {
        return pageSize;
    }

    /**
     * 获取页码（Long类型，适配MyBatis Plus）
     */
    public Long getCurrent() {
        return pageNum.longValue();
    }

    /**
     * 获取页大小（Long类型，适配MyBatis Plus）
     */
    public Long getSize() {
        return pageSize.longValue();
    }
}