package com.wework.platform.account.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 企微联系人信息传输对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "企微联系人信息")
public class WeWorkContactDTO {

    @Schema(description = "联系人ID")
    private String id;

    @Schema(description = "企微账号ID")
    private String accountId;

    @Schema(description = "企业ID")
    private String corpId;

    @Schema(description = "联系人类型")
    private Integer contactType;

    @Schema(description = "联系人类型描述")
    private String contactTypeDesc;

    @Schema(description = "联系人ID（企微内部ID）")
    private String contactId;

    @Schema(description = "联系人名称")
    private String contactName;

    @Schema(description = "联系人昵称")
    private String nickname;

    @Schema(description = "联系人头像")
    private String avatar;

    @Schema(description = "手机号")
    private String mobile;

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "部门ID列表")
    private List<String> departmentIds;

    @Schema(description = "职位")
    private String position;

    @Schema(description = "性别")
    private Integer gender;

    @Schema(description = "性别描述")
    private String genderDesc;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "状态描述")
    private String statusDesc;

    @Schema(description = "企微用户ID")
    private String userId;

    @Schema(description = "外部联系人公司")
    private String company;

    @Schema(description = "标签列表")
    private List<String> tags;

    @Schema(description = "添加时间")
    private String addTime;

    @Schema(description = "最后互动时间")
    private String lastInteractionTime;

    @Schema(description = "联系人来源")
    private String source;

    @Schema(description = "备注信息")
    private String remark;

    @Schema(description = "创建时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;
}