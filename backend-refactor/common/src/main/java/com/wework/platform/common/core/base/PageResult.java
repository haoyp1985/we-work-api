package com.wework.platform.common.core.base;

import lombok.Data;

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

    public PageResult() {
    }

    public PageResult(List<T> records, Long total, Long current, Long size) {
        this.records = records;
        this.total = total;
        this.current = current;
        this.size = size;
        this.pages = calculatePages(total, size);
    }

    /**
     * 创建分页结果
     */
    public static <T> PageResult<T> of(List<T> records, Long total, Long current, Long size) {
        return new PageResult<>(records, total, current, size);
    }

    /**
     * 创建空分页结果
     */
    public static <T> PageResult<T> empty() {
        return new PageResult<>(Collections.emptyList(), 0L, 1L, 20L);
    }

    /**
     * 创建空分页结果
     */
    public static <T> PageResult<T> empty(Long current, Long size) {
        return new PageResult<>(Collections.emptyList(), 0L, current, size);
    }

    /**
     * 计算总页数
     */
    private Long calculatePages(Long total, Long size) {
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