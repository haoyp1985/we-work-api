package com.wework.platform.user.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 权限信息传输对象
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@Schema(description = "权限信息")
public class PermissionDTO {

    @Schema(description = "权限ID")
    private String id;

    @Schema(description = "权限代码")
    private String permissionCode;

    @Schema(description = "权限名称")
    private String permissionName;

    @Schema(description = "权限类型：menu-菜单，button-按钮，data-数据")
    private String permissionType;

    @Schema(description = "父权限ID")
    private String parentId;

    @Schema(description = "路径")
    private String path;

    @Schema(description = "组件")
    private String component;

    @Schema(description = "图标")
    private String icon;

    @Schema(description = "排序")
    private Integer sortOrder;

    @Schema(description = "子权限列表")
    private List<PermissionDTO> children;

    @Schema(description = "角色数量")
    private Integer roleCount;

    @Schema(description = "创建时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @Schema(description = "更新时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;

    @Schema(description = "创建人")
    private String createdBy;

    @Schema(description = "更新人")
    private String updatedBy;
}