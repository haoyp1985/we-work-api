package com.wework.platform.agent.dto.request;

import com.wework.platform.agent.enums.AgentStatus;
import com.wework.platform.agent.enums.AgentType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 智能体查询请求DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "智能体查询请求")
public class AgentQueryRequest {

    @Schema(description = "智能体名称(模糊匹配)")
    private String name;

    @Schema(description = "智能体类型")
    private AgentType type;

    @Schema(description = "智能体状态")
    private AgentStatus status;

    @Schema(description = "外部平台类型")
    private String externalPlatformType;

    @Schema(description = "是否启用")
    private Boolean enabled;

    @Schema(description = "是否公开")
    private Boolean isPublic;

    @Schema(description = "标签列表(任意匹配)")
    private List<String> tags;

    @Schema(description = "能力列表(任意匹配)")
    private List<String> capabilities;

    @Schema(description = "创建开始时间")
    private LocalDateTime createdStart;

    @Schema(description = "创建结束时间")
    private LocalDateTime createdEnd;

    @Schema(description = "更新开始时间")
    private LocalDateTime updatedStart;

    @Schema(description = "更新结束时间")
    private LocalDateTime updatedEnd;

    @Schema(description = "创建人")
    private String createdBy;

    @Schema(description = "关键词(搜索名称、描述、标签)")
    private String keyword;

    @Schema(description = "排序字段(name/created_at/updated_at/sort_weight)")
    private String sortBy = "created_at";

    @Schema(description = "排序方向(asc/desc)")
    private String sortOrder = "desc";

    @Min(value = 1, message = "页码不能小于1")
    @Schema(description = "页码", example = "1")
    private Integer pageNum = 1;

    @Min(value = 1, message = "页大小不能小于1")
    @Max(value = 100, message = "页大小不能大于100")
    @Schema(description = "页大小", example = "20")
    private Integer pageSize = 20;

    @Schema(description = "是否获取统计信息")
    private Boolean includeStats = false;

    @Schema(description = "是否获取扩展信息")
    private Boolean includeExtended = false;
}