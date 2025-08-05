package com.wework.platform.agent.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

/**
 * 分页结果DTO
 */
@Data
@Schema(description = "分页结果")
public class PageResult<T> {

    @Schema(description = "当前页数据")
    private List<T> records;

    @Schema(description = "总记录数")
    private Long total;

    @Schema(description = "页大小")
    private Long size;

    @Schema(description = "当前页码")
    private Long current;

    @Schema(description = "总页数")
    private Long pages;

    @Schema(description = "是否有上一页")
    private Boolean hasPrevious;

    @Schema(description = "是否有下一页")
    private Boolean hasNext;

    @Schema(description = "是否为第一页")
    private Boolean isFirst;

    @Schema(description = "是否为最后一页")
    private Boolean isLast;

    /**
     * 构造分页结果
     */
    public static <T> PageResult<T> of(List<T> records, Long total, Long current, Long size) {
        PageResult<T> result = new PageResult<>();
        result.setRecords(records);
        result.setTotal(total);
        result.setCurrent(current);
        result.setSize(size);
        
        // 计算总页数
        Long pages = (total + size - 1) / size;
        result.setPages(pages);
        
        // 计算分页状态
        result.setHasPrevious(current > 1);
        result.setHasNext(current < pages);
        result.setIsFirst(current == 1);
        result.setIsLast(current.equals(pages));
        
        return result;
    }

    /**
     * 空分页结果
     */
    public static <T> PageResult<T> empty() {
        return of(List.of(), 0L, 1L, 10L);
    }
}