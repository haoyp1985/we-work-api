package com.wework.platform.common.core.base;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.Collections;
import java.util.List;

/**
 * 分页响应结果
 *
 * @param <T> 数据类型
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageResult<T> implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 数据列表
     */
    private List<T> records;

    /**
     * 总记录数
     */
    private Long total;

    /**
     * 当前页码
     */
    private Long current;

    /**
     * 每页大小
     */
    private Long size;

    /**
     * 总页数
     */
    private Long pages;

    /**
     * 创建分页结果
     */
    public static <T> PageResult<T> of(List<T> records, Long total, Long current, Long size) {
        Long pages = calculatePages(total, size);
        return new PageResult<>(records, total, current, size, pages);
    }

    /**
     * 创建空分页结果
     */
    public static <T> PageResult<T> empty() {
        return new PageResult<>(Collections.emptyList(), 0L, 1L, 20L, 0L);
    }

    /**
     * 创建空分页结果
     */
    public static <T> PageResult<T> empty(Long current, Long size) {
        return new PageResult<>(Collections.emptyList(), 0L, current, size, 0L);
    }

    /**
     * 计算总页数
     */
    private static Long calculatePages(Long total, Long size) {
        if (total == null || size == null || size == 0) {
            return 0L;
        }
        return (total + size - 1) / size;
    }

    /**
     * 是否有下一页
     */
    public boolean hasNext() {
        return current != null && pages != null && current < pages;
    }

    /**
     * 是否有上一页
     */
    public boolean hasPrevious() {
        return current != null && current > 1;
    }

    /**
     * 获取记录数量
     */
    public int getRecordCount() {
        return records != null ? records.size() : 0;
    }
}