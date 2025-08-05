package com.wework.platform.account.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

/**
 * 账号统计信息传输对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "账号统计信息")
public class AccountStatisticsDTO {

    @Schema(description = "账号总数")
    private Integer totalAccounts;

    @Schema(description = "在线账号数")
    private Integer onlineAccounts;

    @Schema(description = "离线账号数")
    private Integer offlineAccounts;

    @Schema(description = "异常账号数")
    private Integer errorAccounts;

    @Schema(description = "初始化中账号数")
    private Integer initializingAccounts;

    @Schema(description = "在线率（百分比）")
    private Double onlineRate;

    @Schema(description = "总联系人数")
    private Integer totalContacts;

    @Schema(description = "内部员工数")
    private Integer internalContacts;

    @Schema(description = "外部联系人数")
    private Integer externalContacts;

    @Schema(description = "群聊数")
    private Integer groupContacts;

    @Schema(description = "状态分布统计")
    private List<StatusDistribution> statusDistribution;

    @Schema(description = "最近7天状态变更趋势")
    private List<StatusTrend> statusTrends;

    @Data
    @Schema(description = "状态分布")
    public static class StatusDistribution {
        @Schema(description = "状态值")
        private Integer status;

        @Schema(description = "状态描述")
        private String statusDesc;

        @Schema(description = "账号数量")
        private Integer count;

        @Schema(description = "占比（百分比）")
        private Double percentage;
    }

    @Data
    @Schema(description = "状态趋势")
    public static class StatusTrend {
        @Schema(description = "日期")
        private String date;

        @Schema(description = "在线账号数")
        private Integer onlineCount;

        @Schema(description = "离线账号数")
        private Integer offlineCount;

        @Schema(description = "异常账号数")
        private Integer errorCount;
    }
}