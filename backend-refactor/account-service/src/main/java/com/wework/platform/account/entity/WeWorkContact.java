package com.wework.platform.account.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wework.platform.common.core.base.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 企微联系人实体
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wework_contacts")
public class WeWorkContact extends BaseEntity {

    /**
     * 企微账号ID
     */
    private String accountId;

    /**
     * 企业ID
     */
    private String corpId;

    /**
     * 联系人类型：1-内部员工，2-外部联系人，3-群聊
     */
    private Integer contactType;

    /**
     * 联系人ID（企微内部ID）
     */
    private String contactId;

    /**
     * 联系人名称
     */
    private String contactName;

    /**
     * 联系人昵称
     */
    private String nickname;

    /**
     * 联系人头像
     */
    private String avatar;

    /**
     * 手机号
     */
    private String mobile;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 部门ID列表（JSON格式）
     */
    private String departmentIds;

    /**
     * 职位
     */
    private String position;

    /**
     * 性别：1-男，2-女，0-未知
     */
    private Integer gender;

    /**
     * 是否启用：1-启用，0-禁用
     */
    private Integer status;

    /**
     * 企微用户ID
     */
    private String userId;

    /**
     * 外部联系人公司
     */
    private String company;

    /**
     * 标签列表（JSON格式）
     */
    private String tags;

    /**
     * 添加时间
     */
    private String addTime;

    /**
     * 最后互动时间
     */
    private String lastInteractionTime;

    /**
     * 联系人来源
     */
    private String source;

    /**
     * 租户ID
     */
    private String tenantId;

    /**
     * 备注信息
     */
    private String remark;
}