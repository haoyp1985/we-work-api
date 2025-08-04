/*
 Navicat MySQL Data Transfer

 Source Server         : 健海测试-3.88
 Source Server Type    : MySQL
 Source Server Version : 80034
 Source Host           : 192.168.3.88:3306
 Source Schema         : celina-wecom

 Target Server Type    : MySQL
 Target Server Version : 80034
 File Encoding         : 65001

 Date: 17/07/2025 10:03:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for DATABASECHANGELOG
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOG`;
CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `AUTHOR` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `FILENAME` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) COLLATE utf8mb4_bin NOT NULL,
  `MD5SUM` varchar(35) COLLATE utf8mb4_bin DEFAULT NULL,
  `DESCRIPTION` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `COMMENTS` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `TAG` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `LIQUIBASE` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL,
  `CONTEXTS` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `LABELS` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for DATABASECHANGELOGLOCK
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for abnormal_todo
-- ----------------------------
DROP TABLE IF EXISTS `abnormal_todo`;
CREATE TABLE `abnormal_todo` (
  `id` bigint NOT NULL,
  `robot_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `account_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `abnormal_type` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '异常类型',
  `traceability` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '溯源信息',
  `process_status` int DEFAULT '0' COMMENT '处理状态 0未处理 1已处理',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='异常待办';

-- ----------------------------
-- Table structure for agent_info
-- ----------------------------
DROP TABLE IF EXISTS `agent_info`;
CREATE TABLE `agent_info` (
  `id` bigint NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `agent_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '授权方应用id',
  `name` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '应用名字',
  `square_logo_url` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '应用方形头像',
  `auth_mode` int DEFAULT NULL COMMENT '授权模式，0为管理员授权；1为成员授权',
  `is_customized_app` int DEFAULT NULL COMMENT '是否为代开发自建应用',
  `privilege` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '应用对应的权限',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `suite_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '套件id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='应用授权信息';

-- ----------------------------
-- Table structure for ai_reply
-- ----------------------------
DROP TABLE IF EXISTS `ai_reply`;
CREATE TABLE `ai_reply` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `msg_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '最新聊天msgId',
  `robot_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '（扫码号）客服id',
  `account_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '客户id',
  `health_user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云平台用户id',
  `update_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `is_delete` tinyint DEFAULT '0',
  `msg_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '鲟迹消息id列表(针对哪几条生成的），多条以逗号分隔',
  `ai_message_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '智能体msgId',
  PRIMARY KEY (`id`),
  KEY `chat_history_health_user_id_IDX` (`health_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='智能体回复记录';

-- ----------------------------
-- Table structure for ai_tag
-- ----------------------------
DROP TABLE IF EXISTS `ai_tag`;
CREATE TABLE `ai_tag` (
  `id` bigint NOT NULL,
  `robot_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `account_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `pat_id` bigint DEFAULT NULL COMMENT '患者id',
  `chat_content_tags` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '聊天内容标签',
  `discharge_summary_tags` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '出院小结标签',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='ai标签';

-- ----------------------------
-- Table structure for batch_task
-- ----------------------------
DROP TABLE IF EXISTS `batch_task`;
CREATE TABLE `batch_task` (
  `id` bigint NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `hosp_code` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医院编码',
  `external_user_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '外部联系人id',
  `task_type` int NOT NULL COMMENT '任务类型 1评估任务 2待办事项',
  `task_name` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '任务名称',
  `task_num` int DEFAULT NULL COMMENT '任务数量',
  `quick_reply_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '话术id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `external_user_name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '外部联系人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='批量任务';

-- ----------------------------
-- Table structure for chat_history
-- ----------------------------
DROP TABLE IF EXISTS `chat_history`;
CREATE TABLE `chat_history` (
  `id` bigint NOT NULL,
  `corp_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `msg_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '消息id，消息的唯一标识，企业可以使用此字段进行消息去重。',
  `action` varchar(16) COLLATE utf8mb4_bin NOT NULL COMMENT '消息动作，目前有send(发送消息)/recall(撤回消息)/switch(切换企业日志)三种类型',
  `from` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '消息发送方id',
  `tolist` text COLLATE utf8mb4_bin NOT NULL COMMENT '消息接收方列表，可能是多个',
  `room_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群聊消息的群id 如果是单聊则为空',
  `msg_time` datetime NOT NULL COMMENT '消息发送时间戳，utc时间，ms单位',
  `msg_type` varchar(16) COLLATE utf8mb4_bin NOT NULL COMMENT '文本消息为：text',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '消息内容',
  `sdk_fileid` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '媒体资源的id信息',
  `md5sum` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '图片资源的md5值，供进行校验',
  `file_size` int DEFAULT NULL COMMENT '资源的文件大小',
  `play_length` int DEFAULT NULL COMMENT '播放长度',
  `file_name` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '文件名',
  `file_ext` varchar(16) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '文件类型后缀',
  `title` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '消息标题',
  `description` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '消息描述',
  `link_url` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '消息链接',
  `image_url` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '链接图片url',
  `user_name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户名称',
  `display_name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '小程序名称',
  `item` text COLLATE utf8mb4_bin,
  `file_oss_id` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '文件在oss上的id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `is_read` tinyint DEFAULT '0' COMMENT '是否已读 0：未读，1：已读',
  PRIMARY KEY (`id`),
  KEY `msg_id_index` (`msg_id`),
  KEY `idx_chat_history_room_id` (`room_id`),
  KEY `from_IDX` (`from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='聊天记录';

-- ----------------------------
-- Table structure for chat_history_config
-- ----------------------------
DROP TABLE IF EXISTS `chat_history_config`;
CREATE TABLE `chat_history_config` (
  `id` bigint NOT NULL,
  `corp_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `open_corp_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '服务商corpId',
  `chat_secret` varchar(128) COLLATE utf8mb4_bin NOT NULL COMMENT '会话存档密钥',
  `private_key` text COLLATE utf8mb4_bin NOT NULL COMMENT '解密私钥',
  `seq` bigint NOT NULL COMMENT '会话存档的起始seq',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `public_key_ver` int DEFAULT NULL COMMENT '消息加密公钥版本号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='聊天记录配置';

-- ----------------------------
-- Table structure for chat_history_latest
-- ----------------------------
DROP TABLE IF EXISTS `chat_history_latest`;
CREATE TABLE `chat_history_latest` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `chat_history_id` bigint DEFAULT NULL COMMENT '聊天记录主键',
  `corp_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业ID',
  `type` tinyint DEFAULT NULL COMMENT '1:群聊，2:私聊',
  `chat_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群聊id',
  `avatar` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '私聊头像',
  `external_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '私聊客户id',
  `external_new_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '私聊客户newid',
  `external_user_name` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '私聊客户昵称',
  `wecom_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '客服id',
  `wecom_new_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '客服id',
  `wecom_user_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '客服name',
  `participant_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群聊名称，私聊名称',
  `pat_name` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者名字',
  `timestamp` bigint DEFAULT NULL COMMENT '时间戳',
  `unread_count` int DEFAULT NULL COMMENT '未读消息数',
  `update_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_history_latest_chat_id_IDX` (`chat_id`) USING BTREE,
  KEY `chat_history_latest_external_user_id_IDX` (`external_user_id`,`wecom_user_id`) USING BTREE,
  KEY `chat_history_latest_wecom_new_user_id_IDX` (`wecom_new_user_id`,`external_new_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='最新一条聊天记录';

-- ----------------------------
-- Table structure for chat_send_task
-- ----------------------------
DROP TABLE IF EXISTS `chat_send_task`;
CREATE TABLE `chat_send_task` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `chat_id` varchar(64) COLLATE utf8mb4_bin DEFAULT '' COMMENT '群聊Id',
  `user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '发送人userId 1v1时必传',
  `external_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '外部联系人id',
  `jgy_sender_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '实际发送人/值班人的健管云账号',
  `jgy_sender_name` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '实际发送人/值班人名称',
  `push_channel` int NOT NULL COMMENT '推送渠道 3-个人 4-群',
  `content` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '文本内容',
  `reply_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '话术id',
  `material_file_ids` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '素材库表id 多个以,分隔',
  `send_status` int NOT NULL DEFAULT '0' COMMENT '发送状态 0-未推送 1-已推送',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `cancel_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '取消操作人userId',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='聊天发送任务表';

-- ----------------------------
-- Table structure for chat_task_material_file
-- ----------------------------
DROP TABLE IF EXISTS `chat_task_material_file`;
CREATE TABLE `chat_task_material_file` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `corp_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '企业ID',
  `file_type` tinyint NOT NULL COMMENT '文件类型',
  `expiration_time` datetime NOT NULL COMMENT '过期时间',
  `media_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '微信素材id fileType=5时为小程序封面图media_id',
  `file_source` varchar(1000) DEFAULT NULL COMMENT '文件oss地址',
  `url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '跳转地址',
  `app_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '小程序appId',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `source_file_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '来源文件名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='素材详情';

-- ----------------------------
-- Table structure for contact_way
-- ----------------------------
DROP TABLE IF EXISTS `contact_way`;
CREATE TABLE `contact_way` (
  `id` bigint NOT NULL,
  `corp_id` varchar(32) NOT NULL COMMENT '企微id',
  `scene` int NOT NULL COMMENT '场景，1-在小程序中联系，2-通过二维码联系',
  `remark` varchar(128) DEFAULT NULL COMMENT '备注',
  `state` varchar(30) DEFAULT NULL COMMENT '企业自定义的state参数',
  `user_id` varchar(32) NOT NULL COMMENT '使用该联系方式的用户userID',
  `config_id` varchar(32) DEFAULT NULL COMMENT '新增联系方式的配置id',
  `qr_code` varchar(255) DEFAULT NULL COMMENT '联系我二维码链接',
  `expires_in` int DEFAULT NULL COMMENT '二维码有效期，以秒为单位',
  `expires_time` datetime DEFAULT NULL COMMENT '过期时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `third_id` varchar(32) DEFAULT NULL COMMENT '第三方主键',
  `qr_code_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '二维码类型 0 临时二维码 1 永久二维码',
  `rule_id` varchar(32) DEFAULT NULL COMMENT 'wecom_rule表主键id',
  `source_type` int DEFAULT NULL COMMENT '创建二维码来源 1:先宣讲后开单',
  `docking_type` int DEFAULT '1' COMMENT '对接方式 1 自研服务商模式 2 鲟迹',
  `str_id` varchar(100) DEFAULT NULL COMMENT '活码唯一id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='企业微信联系我';

-- ----------------------------
-- Table structure for corp_info
-- ----------------------------
DROP TABLE IF EXISTS `corp_info`;
CREATE TABLE `corp_info` (
  `id` bigint NOT NULL,
  `corp_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `corp_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '企业简称',
  `permanent_code` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `corp_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业类型，认证号：verified, 注册号：unverified',
  `corp_square_logo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业头像',
  `corp_user_max` int DEFAULT NULL COMMENT '企业用户最大数量',
  `subject_type` int DEFAULT NULL COMMENT '企业类型，1. 企业; 2. 政府以及事业单位; 3. 其他组织, 4.团队号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `hosp_codes` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医院编码',
  `binding_time` timestamp NULL DEFAULT NULL COMMENT '绑定时间',
  `docking_type` int DEFAULT '1' COMMENT '对接方式 1 自研服务商模式 2 鲟迹',
  `app_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户唯一标识',
  `app_secret` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业API调用凭据',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='企业信息';

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `id` bigint NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `account_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '客户id',
  `account_type` int DEFAULT NULL COMMENT '客户类型：0:客户类型未知，1=员工，2=微信外部联系人，3=企业微信外部联系人',
  `name` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '姓名',
  `alias` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '别名',
  `avatar` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '头像',
  `gender` int DEFAULT NULL COMMENT '性别：1=男，2=女，0=未知',
  `ww_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业微信id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='企业员工';

-- ----------------------------
-- Table structure for evaluate_task_record
-- ----------------------------
DROP TABLE IF EXISTS `evaluate_task_record`;
CREATE TABLE `evaluate_task_record` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业微信id',
  `user_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '发送提醒的客服id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '客户昵称',
  `pat_name` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '客户姓名',
  `external_user_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '客户标识',
  `form_record_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '表单记录id',
  `pat_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT 'patId',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '创建人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='评估任务提醒记录表';

-- ----------------------------
-- Table structure for evaluate_task_record2
-- ----------------------------
DROP TABLE IF EXISTS `evaluate_task_record2`;
CREATE TABLE `evaluate_task_record2` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(32) NOT NULL COMMENT '企业微信id',
  `user_id` varchar(64) NOT NULL COMMENT '发送提醒的客服id',
  `name` varchar(32) NOT NULL COMMENT '客户昵称',
  `pat_name` varchar(32) NOT NULL COMMENT '客户姓名',
  `external_user_id` varchar(64) NOT NULL COMMENT '客户标识',
  `form_record_id` varchar(32) NOT NULL COMMENT '表单记录id',
  `pat_id` varchar(32) NOT NULL COMMENT 'patId',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建人id',
  `create_by` varchar(32) NOT NULL COMMENT '创建人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='评估任务提醒记录表';

-- ----------------------------
-- Table structure for external_user
-- ----------------------------
DROP TABLE IF EXISTS `external_user`;
CREATE TABLE `external_user` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(32) NOT NULL COMMENT '企微id',
  `name` varchar(32) DEFAULT NULL COMMENT '外部联系人的名称',
  `type` int DEFAULT NULL COMMENT '外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户',
  `gender` int DEFAULT NULL COMMENT '外部联系人性别 0-未知 1-男性 2-女性',
  `union_id` varchar(32) DEFAULT NULL COMMENT '外部联系人在微信开放平台的唯一身份标识',
  `user_id` varchar(32) NOT NULL COMMENT '企业成员userid',
  `external_user_id` varchar(32) NOT NULL COMMENT '外部联系人的userid',
  `pat_id` varchar(32) DEFAULT NULL COMMENT 'patId',
  `is_banding` tinyint(1) DEFAULT '0' COMMENT '是否绑定就诊人',
  `avatar` varchar(500) DEFAULT NULL COMMENT '外部联系人头像',
  `add_way` int DEFAULT NULL COMMENT '该成员添加此客户的来源',
  `contact_way_id` varchar(32) DEFAULT NULL COMMENT 'contactWay表主键',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `empi_id` varchar(40) DEFAULT NULL COMMENT 'empiId',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `pat_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '患者姓名',
  `banding_time` datetime DEFAULT NULL COMMENT '绑定时间',
  `mobile_no` varchar(20) DEFAULT NULL COMMENT '手机号',
  `id_number` varchar(32) DEFAULT NULL COMMENT '身份证号码',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `hosp_name` varchar(32) DEFAULT NULL COMMENT '医院名称',
  `dept_codes` varchar(64) DEFAULT NULL COMMENT '科室',
  `remark` varchar(128) DEFAULT '' COMMENT '客户备注',
  `docking_type` int DEFAULT '1' COMMENT '对接方式 1 自研服务商模式 2 鲟迹',
  `health_user_id` varchar(64) DEFAULT NULL COMMENT '健管师账号(健管云userId)',
  `account_id` varchar(32) DEFAULT NULL COMMENT '客户id',
  `is_demo` tinyint DEFAULT '0' COMMENT '是否演示患者',
  `bu_relation_type` tinyint DEFAULT NULL COMMENT '患者bu',
  `halftime_manage_status` tinyint DEFAULT NULL COMMENT '探视管理状态1管理其他非管理',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='企业微信客户';

-- ----------------------------
-- Table structure for form_abnormal_undo_task
-- ----------------------------
DROP TABLE IF EXISTS `form_abnormal_undo_task`;
CREATE TABLE `form_abnormal_undo_task` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'patId',
  `relation_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '业务关联id',
  `corp_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `form_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '标签推送规则详情id',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `form_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '标签推送规则名称',
  `send_status` int DEFAULT '0' COMMENT '状态  0-未完成 1-已完成',
  `submit_time` datetime NOT NULL COMMENT '表单提交时间',
  `abnormal_time` datetime NOT NULL COMMENT '表单异常时间',
  `abnormal_level_total` int DEFAULT NULL COMMENT '表单异常等级',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `abnormal_level` varchar(16) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for group_chat
-- ----------------------------
DROP TABLE IF EXISTS `group_chat`;
CREATE TABLE `group_chat` (
  `id` bigint NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `chat_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '客户群id',
  `chat_name` varchar(128) COLLATE utf8mb4_bin NOT NULL COMMENT '群名',
  `owner` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群主ID',
  `member_version` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '当前群成员版本号',
  `manage_external_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '管理的外部联系人id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `group_notice` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群公告',
  `operator_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人员(健管云userId)',
  `op_account_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'xj返回的操作用户id',
  `hosp_code` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构',
  `bu_relation_type` int DEFAULT NULL COMMENT '所属bu',
  `qrcode_url` varchar(2000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群二维码',
  `next_refresh_time` datetime DEFAULT NULL COMMENT '下一次刷新群聊二维码时间戳',
  `group_type` int DEFAULT NULL COMMENT '群类型 1:nv1 2:nvn',
  `serial_no` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '序列号',
  PRIMARY KEY (`id`),
  KEY `idx_group_chat_chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='企微群消息';

-- ----------------------------
-- Table structure for group_chat_member
-- ----------------------------
DROP TABLE IF EXISTS `group_chat_member`;
CREATE TABLE `group_chat_member` (
  `id` bigint NOT NULL,
  `chat_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '客户群id',
  `user_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '成员ID',
  `type` tinyint(1) NOT NULL COMMENT '成员类型 1 - 企业成员 2 - 外部联系人',
  `join_time` datetime NOT NULL COMMENT '入群时间',
  `join_scene` tinyint(1) NOT NULL COMMENT '入群方式 1 - 由群成员邀请入群（直接邀请入群）2 - 由群成员邀请入群（通过邀请链接入群） 3 - 通过扫描群二维码入群',
  `invitor_user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '邀请人userid',
  `group_nickname` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '在群里的昵称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `name` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '姓名',
  `quit_scene` int DEFAULT NULL COMMENT '退群方式 0 - 自己退群 1 - 群主/群管理员移出',
  `inviter_type` tinyint DEFAULT NULL COMMENT '邀请人类型：1-员工，2-微信外部联系人，3-企业微信外部联系人',
  `avatar` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群内头像',
  `admin_type` int DEFAULT NULL COMMENT '管理员类型：0普通成员 1管理员 2群主',
  PRIMARY KEY (`id`),
  KEY `idx_group_chat_member_chat_id` (`chat_id`),
  KEY `idx_group_chat_member_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='企微群成员';

-- ----------------------------
-- Table structure for group_chat_req
-- ----------------------------
DROP TABLE IF EXISTS `group_chat_req`;
CREATE TABLE `group_chat_req` (
  `id` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `corp_id` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `hosp_code` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `serial_no` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL,
  `member_ids` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `creator_health_user_id` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群聊创建人',
  `group_type` int DEFAULT NULL COMMENT '群类型 1:nv1 2:nvn',
  `manage_external_user_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '管理的外部联系人id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for group_msg_send
-- ----------------------------
DROP TABLE IF EXISTS `group_msg_send`;
CREATE TABLE `group_msg_send` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(32) NOT NULL COMMENT '企业id',
  `msg_id` varchar(64) DEFAULT NULL COMMENT '群发消息的id',
  `title` varchar(32) NOT NULL COMMENT '群发标题',
  `text_desc` varchar(200) DEFAULT NULL COMMENT '群发内容文本',
  `material_file_ids` varchar(200) DEFAULT NULL COMMENT '群发内容素材id,多个以逗号分割',
  `group_msg_type` tinyint NOT NULL COMMENT '发送类型 1-立即发送 2-定时发送',
  `status` tinyint DEFAULT NULL COMMENT '状态 0-正常 1-失败',
  `creator_department` varchar(200) DEFAULT NULL COMMENT '创建人所属部门',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(32) NOT NULL COMMENT '创建人',
  `update_by` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='客户群发记录表';

-- ----------------------------
-- Table structure for hosp_dept_mode_config
-- ----------------------------
DROP TABLE IF EXISTS `hosp_dept_mode_config`;
CREATE TABLE `hosp_dept_mode_config` (
  `hosp_code` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '科室',
  `dept_code` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '科室编码',
  `mode_code` int NOT NULL COMMENT '模式编码 1-老模式',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`hosp_code`,`dept_code`,`mode_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='机构科室模式配置表';

-- ----------------------------
-- Table structure for hosp_name_simplify
-- ----------------------------
DROP TABLE IF EXISTS `hosp_name_simplify`;
CREATE TABLE `hosp_name_simplify` (
  `hosp_code` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT 'hosp_code',
  `hosp_name_simplify` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '机构名称简称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='机构简称表';

-- ----------------------------
-- Table structure for host_account
-- ----------------------------
DROP TABLE IF EXISTS `host_account`;
CREATE TABLE `host_account` (
  `id` bigint NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `robot_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '扫码号id',
  `user_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '用户id',
  `ww_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户id(用于生成渠道码)',
  `name` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户姓名',
  `real_name` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户实名',
  `avatar_url` varchar(256) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户头像url',
  `alias` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户别名',
  `sex` int DEFAULT NULL COMMENT '用户性别:1男 2女',
  `is_online` tinyint(1) DEFAULT NULL COMMENT '是否在线',
  `joining_time` mediumtext COLLATE utf8mb4_bin COMMENT '成员绑定端口时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `ban_warning_status` int DEFAULT NULL COMMENT '封号预警 1-封号，0-正常',
  `ban_time` datetime DEFAULT NULL COMMENT '封号预警提醒时间',
  `ban_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '封号原因',
  `external_user_count` int DEFAULT '0' COMMENT '外部联系人数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='扫码号';

-- ----------------------------
-- Table structure for intelligent_invocation_settings
-- ----------------------------
DROP TABLE IF EXISTS `intelligent_invocation_settings`;
CREATE TABLE `intelligent_invocation_settings` (
  `intelligent_name` varchar(100) COLLATE utf8mb4_bin NOT NULL,
  `intelligent_code` tinyint NOT NULL COMMENT '1商品推荐智能体、2个性化宣教推荐智能体、3异常待办智能体、4疾病风险洞察智能体',
  `bu_setting_type` tinyint NOT NULL DEFAULT '1' COMMENT '1全部开启 2部分开启 3部分不开启 4全部不开启',
  `bu_setting_relation` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'buType',
  `hosp_setting_type` tinyint NOT NULL DEFAULT '1' COMMENT '1全部开启 2部分开启 3部分不开启 4全部不开启',
  `hosp_setting_relation` varchar(2000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'hospCode',
  `editor_name` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `hosp_setting_relation_json` varchar(2000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'hospCode json(前端展示用)',
  PRIMARY KEY (`intelligent_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='智能体调用设置表';

-- ----------------------------
-- Table structure for match_evaluate_record
-- ----------------------------
DROP TABLE IF EXISTS `match_evaluate_record`;
CREATE TABLE `match_evaluate_record` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '主键',
  `external_account_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户id',
  `host_account_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '客服id',
  `result_msg` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '返回结果',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `is_recommend` tinyint DEFAULT NULL COMMENT '是否推荐引用 1:是',
  `evaluate_type` tinyint DEFAULT NULL COMMENT '1:页面发起 2:追踪 3:首次 4:第二次 5:第三次 6:第四次 7:固定第三天 8:固定第8天',
  `is_delete` tinyint DEFAULT NULL,
  `evaluate_content` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '评估内容',
  `message_id` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'message_id',
  PRIMARY KEY (`id`),
  KEY `match_evaluate_record_account_id_IDX` (`external_account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='基于对话模型的评估结果记录';

-- ----------------------------
-- Table structure for match_measure_record
-- ----------------------------
DROP TABLE IF EXISTS `match_measure_record`;
CREATE TABLE `match_measure_record` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '主键',
  `external_account_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户id',
  `host_account_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '客服id',
  `initial_measure_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '措施名称',
  `result_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '返回原因',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `is_recommend` tinyint DEFAULT NULL COMMENT '是否推荐引用 1:是',
  `is_delete` tinyint DEFAULT NULL,
  `traceability` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '溯源信息',
  `message_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'message_id',
  PRIMARY KEY (`id`),
  KEY `match_measure_record_account_id_IDX` (`external_account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='基于对话模型的干预措施结果记录';

-- ----------------------------
-- Table structure for material_file
-- ----------------------------
DROP TABLE IF EXISTS `material_file`;
CREATE TABLE `material_file` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(32) DEFAULT NULL,
  `material_group_id` varchar(32) NOT NULL COMMENT '分组id',
  `file_type` tinyint NOT NULL COMMENT '文件类型',
  `file_name` varchar(200) DEFAULT NULL COMMENT '文件名称',
  `expiration_time` datetime NOT NULL COMMENT '过期时间',
  `media_id` varchar(200) NOT NULL COMMENT '微信素材id fileType=5时为小程序封面图media_id',
  `file_source` varchar(200) DEFAULT NULL COMMENT '文件oss地址',
  `url` varchar(500) DEFAULT NULL COMMENT '跳转地址',
  `app_id` varchar(100) DEFAULT NULL COMMENT '小程序appId',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(32) NOT NULL COMMENT '创建人',
  `update_by` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `source_file_name` varchar(200) NOT NULL COMMENT '来源文件名称',
  `docking_type` tinyint DEFAULT '1' COMMENT '对接方式 1 自研服务商模式 2 鲟迹',
  `voice_time` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='素材详情';

-- ----------------------------
-- Table structure for material_group
-- ----------------------------
DROP TABLE IF EXISTS `material_group`;
CREATE TABLE `material_group` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(32) DEFAULT NULL,
  `group_name` varchar(200) NOT NULL COMMENT '分组名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(32) NOT NULL COMMENT '创建人',
  `update_by` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `docking_type` tinyint DEFAULT '1' COMMENT '对接方式 1 自研服务商模式 2 鲟迹',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='素材分组';

-- ----------------------------
-- Table structure for msg_read_record
-- ----------------------------
DROP TABLE IF EXISTS `msg_read_record`;
CREATE TABLE `msg_read_record` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `msg_key_ids` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `read_time` datetime DEFAULT NULL,
  `health_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `health_user_name` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for mytable
-- ----------------------------
DROP TABLE IF EXISTS `mytable`;
CREATE TABLE `mytable` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for oras_ai_conversation_record
-- ----------------------------
DROP TABLE IF EXISTS `oras_ai_conversation_record`;
CREATE TABLE `oras_ai_conversation_record` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `content` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '内容',
  `message_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '消息id',
  `conversation_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对话id',
  `evaluate` tinyint NOT NULL DEFAULT '0' COMMENT '0-初始值 1-点赞 2-点踩',
  `robot_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '（扫码号）客服id',
  `account_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '客户id',
  `health_user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云平台用户id',
  `pat_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'patId',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `customer_account` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_type` int DEFAULT NULL COMMENT '用户类型 0-机器人 1-客服',
  `relation_question_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对应的问题id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='ai对话记录';

-- ----------------------------
-- Table structure for pat_notice_status
-- ----------------------------
DROP TABLE IF EXISTS `pat_notice_status`;
CREATE TABLE `pat_notice_status` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `notice_status` tinyint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT NULL,
  `editor` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for private_domain
-- ----------------------------
DROP TABLE IF EXISTS `private_domain`;
CREATE TABLE `private_domain` (
  `id` varchar(32) NOT NULL COMMENT 'id',
  `name` varchar(255) NOT NULL COMMENT '名称',
  `welcome_rule_id` varchar(32) NOT NULL COMMENT '欢迎语规则id',
  `welcome_rule_name` varchar(255) NOT NULL COMMENT '欢迎语规则名称',
  `service_package_id` varchar(32) NOT NULL COMMENT '服务包id',
  `service_package_name` varchar(255) NOT NULL COMMENT '服务包名称',
  `service_package_status` varchar(255) NOT NULL COMMENT '服务包状态',
  `copy_writing` varchar(255) NOT NULL DEFAULT '' COMMENT '文案',
  `app_page_path` varchar(255) NOT NULL COMMENT '小程序地址',
  `app_page_title` varchar(255) NOT NULL COMMENT '小程序页面title',
  `private_domain_status` int NOT NULL DEFAULT '1' COMMENT '状态 0 启用 1 禁用',
  `create_id` varchar(32) NOT NULL COMMENT '创建人',
  `create_by` varchar(255) NOT NULL COMMENT '创建人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_id` varchar(32) NOT NULL COMMENT '更新人',
  `update_by` varchar(255) NOT NULL COMMENT '更新人名称',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '是否删除 0 否 1 是',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(255) NOT NULL COMMENT '医院名称',
  `corp_id` varchar(32) NOT NULL COMMENT '主体',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='私域运营';

-- ----------------------------
-- Table structure for quick_reply
-- ----------------------------
DROP TABLE IF EXISTS `quick_reply`;
CREATE TABLE `quick_reply` (
  `id` varchar(32) CHARACTER SET utf8mb3 NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `group_id` varchar(32) CHARACTER SET utf8mb3 NOT NULL COMMENT '分组id',
  `group_name` varchar(20) CHARACTER SET utf8mb3 NOT NULL COMMENT '分组名称',
  `quick_reply_type` tinyint NOT NULL COMMENT '1-企业 2-个人',
  `title` varchar(20) CHARACTER SET utf8mb3 NOT NULL COMMENT '标题',
  `material_file_ids` varchar(200) CHARACTER SET utf8mb3 DEFAULT NULL COMMENT '素材库表id 多个以,分隔',
  `text_desc` varchar(2001) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '文本内容',
  `send_amount` int NOT NULL COMMENT '总计发送次数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(32) CHARACTER SET utf8mb3 NOT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb3 NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `user_id` varchar(50) CHARACTER SET utf8mb3 DEFAULT NULL COMMENT '企微用户id',
  `edu_ids` varchar(500) CHARACTER SET utf8mb3 DEFAULT NULL COMMENT '宣教id列表',
  `edu_apply_hosp_code` varchar(50) CHARACTER SET utf8mb3 DEFAULT NULL COMMENT '宣教-适用医院的医院编码',
  `docking_type` tinyint DEFAULT '1' COMMENT '对接方式 1 自研服务商模式 2 鲟迹',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPACT COMMENT='话术库';

-- ----------------------------
-- Table structure for quick_reply_group
-- ----------------------------
DROP TABLE IF EXISTS `quick_reply_group`;
CREATE TABLE `quick_reply_group` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(32) DEFAULT NULL,
  `group_name` varchar(20) NOT NULL COMMENT '分组名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(32) NOT NULL COMMENT '创建人',
  `update_by` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `sort_no` int DEFAULT '0' COMMENT '排序',
  `no_group_flag` tinyint(1) DEFAULT '0' COMMENT '分组是否是“未分组”',
  `docking_type` tinyint DEFAULT '1' COMMENT '对接方式 1 自研服务商模式 2 鲟迹',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='话术分组';

-- ----------------------------
-- Table structure for user_id_mapping
-- ----------------------------
DROP TABLE IF EXISTS `user_id_mapping`;
CREATE TABLE `user_id_mapping` (
  `id` bigint NOT NULL,
  `user_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '用户id',
  `user_type` int NOT NULL DEFAULT '1' COMMENT '用户类型 1 - 企业成员 2 - 外部联系人',
  `new_user_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '新用户id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_user_id_mapping_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户id对照表';

-- ----------------------------
-- Table structure for user_view_scope
-- ----------------------------
DROP TABLE IF EXISTS `user_view_scope`;
CREATE TABLE `user_view_scope` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `health_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云userId',
  `corp_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业微信corpId',
  `corp_name` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业微信corpName',
  `wecom_user_ids` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业微信userId,逗号分割',
  `wecom_user_names` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业微信userName,逗号分割',
  `is_remember` tinyint DEFAULT NULL COMMENT '是否记住 0:否 1:是',
  `is_delete` tinyint DEFAULT NULL COMMENT '删除标识 0:否 1:是',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `user_view_scope_health_user_id_IDX` (`health_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户查看范围';

-- ----------------------------
-- Table structure for wecom_rule
-- ----------------------------
DROP TABLE IF EXISTS `wecom_rule`;
CREATE TABLE `wecom_rule` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(32) NOT NULL COMMENT '企业微信id',
  `rule_type` tinyint(1) NOT NULL COMMENT '规则类型 1 欢迎语',
  `rule_name` varchar(200) NOT NULL COMMENT '规则名称',
  `rule_content` varchar(1025) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '规则内容',
  `rule_status` tinyint(1) NOT NULL COMMENT '规则状态 O 启用 1 停用',
  `class_code` varchar(200) NOT NULL DEFAULT '' COMMENT '科室代码',
  `class_name` varchar(200) NOT NULL DEFAULT '' COMMENT '科室名称',
  `customer_service_id` varchar(32) NOT NULL COMMENT '客服id',
  `customer_service_name` varchar(32) NOT NULL COMMENT '客服名称',
  `doctor_id` varchar(50) NOT NULL DEFAULT '' COMMENT '医生id',
  `doctor_name` varchar(50) NOT NULL DEFAULT '' COMMENT '医生姓名',
  `qr_code_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '二维码类型  0 临时二维码 1 永久二维码',
  `add_qty` int NOT NULL DEFAULT '0' COMMENT '规则使用数',
  `del_qty` int NOT NULL DEFAULT '0' COMMENT '规则删除数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建人id',
  `update_id` varchar(32) NOT NULL COMMENT '修改人id',
  `create_by` varchar(32) NOT NULL COMMENT '创建人',
  `update_by` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `hosp_name` varchar(32) NOT NULL COMMENT '医院名称',
  `rule_scene` tinyint DEFAULT '0' COMMENT '适用场景 0 pad  1 私域',
  `robot_wecom_user_id` varchar(64) DEFAULT NULL COMMENT '机器人账号',
  `off_line_wecom_user_id` varchar(64) DEFAULT NULL COMMENT '线下个管师企微账号',
  `doctor_wecom_user_id` varchar(64) DEFAULT NULL COMMENT '医生企微账号',
  `docking_type` int DEFAULT '1' COMMENT '对接方式 1 自研服务商模式 2 鲟迹',
  `health_user_ids` varchar(512) DEFAULT NULL COMMENT '健管师id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='企业微信规则配置';

-- ----------------------------
-- Table structure for wecom_rule_file
-- ----------------------------
DROP TABLE IF EXISTS `wecom_rule_file`;
CREATE TABLE `wecom_rule_file` (
  `id` varchar(32) NOT NULL,
  `rule_id` varchar(32) NOT NULL COMMENT '规则id',
  `file_type` tinyint(1) NOT NULL COMMENT '文件类型 1 欢迎语',
  `file_name` varchar(200) NOT NULL COMMENT '文件名称',
  `file_sort` tinyint NOT NULL COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建人id',
  `update_id` varchar(32) NOT NULL COMMENT '修改人id',
  `expiration_time` datetime NOT NULL COMMENT '过期时间',
  `file_media` varchar(200) NOT NULL COMMENT '微信素材',
  `file_source` varchar(200) NOT NULL COMMENT '修改人id',
  `file_desc` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '''''' COMMENT '描述',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `voice_time` int DEFAULT NULL COMMENT '视频时长',
  `app_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '小程序appId',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='企业微信规则附件';

-- ----------------------------
-- Table structure for wecom_rule_used_info
-- ----------------------------
DROP TABLE IF EXISTS `wecom_rule_used_info`;
CREATE TABLE `wecom_rule_used_info` (
  `id` varchar(32) NOT NULL,
  `user_id` varchar(32) NOT NULL COMMENT '客服人员',
  `external_user_id` varchar(32) NOT NULL COMMENT '客户id',
  `rule_id` varchar(32) NOT NULL COMMENT '规则id',
  `info_status` tinyint(1) NOT NULL COMMENT '状态 0 新增 1 删除',
  `execution_date` date NOT NULL COMMENT '创建时间',
  `create_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='企业微信规则附件';

-- ----------------------------
-- Table structure for wecom_tag
-- ----------------------------
DROP TABLE IF EXISTS `wecom_tag`;
CREATE TABLE `wecom_tag` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(32) NOT NULL COMMENT '企微id',
  `tag_type` tinyint DEFAULT NULL COMMENT '标签类型 0-机构 1-科室',
  `tag_identify` varchar(32) NOT NULL COMMENT '标签匹配字段 tagType为0-值为机构代码 tagType为1-值为科室代码',
  `group_id` varchar(32) NOT NULL COMMENT '分组id',
  `group_name` varchar(40) NOT NULL COMMENT '分组名称',
  `tag_id` varchar(32) NOT NULL COMMENT '标签id',
  `tag_name` varchar(32) NOT NULL COMMENT '标签名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for wecom_user
-- ----------------------------
DROP TABLE IF EXISTS `wecom_user`;
CREATE TABLE `wecom_user` (
  `id` bigint NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `user_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业微信用户ID',
  `name` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '用户名称',
  `mobile` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '手机号',
  `email` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '邮箱',
  `biz_mail` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业邮箱',
  `gender` int DEFAULT NULL COMMENT '性别，1表示男性，2表示女性，0表示未知',
  `avatar` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '头像',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `follow_user_flag` int DEFAULT '0' COMMENT '是否有客户联系功能 0否1是',
  `sf_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '随访账号id',
  `sf_staff_code` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '随访账号工号',
  `is_bind` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否绑定 0否 1是',
  `hosp_code` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医院编码',
  `sys_type` varchar(20) COLLATE utf8mb4_bin NOT NULL DEFAULT '0' COMMENT '系统类型 SysTypeEnum',
  `role` int DEFAULT NULL COMMENT '角色 1线上运营人员 2线下运营人员 3医生 4机器人',
  `health_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云用户id',
  `health_user_name` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云用户Name',
  `update_by` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for workbench_undo_task
-- ----------------------------
DROP TABLE IF EXISTS `workbench_undo_task`;
CREATE TABLE `workbench_undo_task` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'patId',
  `relation_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'dataCenter库TaskPushRecord表taskId',
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `quick_reply_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '话术id',
  `tag_push_rule_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '标签推送规则id',
  `tag_push_rule_detail_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '标签推送规则详情id',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `tag_push_rule_name` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '标签推送规则名称',
  `send_count` int DEFAULT '0' COMMENT '发送次数',
  `push_channel` int DEFAULT '3' COMMENT '推送渠道 3-个人 4-群',
  `chat_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群聊Id',
  `task_type` int DEFAULT '1' COMMENT '任务类型 1.工作台待办事项任务(消息推送类) 3任务待办类(标签采集',
  `cancel_reason` int DEFAULT NULL COMMENT '取消原因',
  `cancel_reason_ext` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '取消原因补充说明',
  `content` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '提醒任务-提醒内容',
  `hosp_code` varchar(40) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构代码',
  `source_type` int DEFAULT NULL COMMENT '业务数据来源(1:门诊 2:出院 3:在院)',
  `serial_no` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '业务数据流水号(住院流水号/门诊流水号等)',
  `pat_name` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '姓名',
  `theme_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '主题id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='工作台待办任务表';

-- ----------------------------
-- Table structure for xj_auto_chat_record
-- ----------------------------
DROP TABLE IF EXISTS `xj_auto_chat_record`;
CREATE TABLE `xj_auto_chat_record` (
  `msg_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '鲟迹消息id',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`msg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='系统自动发送记录表';

-- ----------------------------
-- Table structure for xj_chat_history
-- ----------------------------
DROP TABLE IF EXISTS `xj_chat_history`;
CREATE TABLE `xj_chat_history` (
  `id` bigint NOT NULL,
  `corp_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '企业ID',
  `robot_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '机器人id',
  `sender_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '发送者id',
  `receiver_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '接收者id',
  `msg_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '鲟迹消息id',
  `custom_msg_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '客户消息id',
  `msg_type` int NOT NULL COMMENT '消息类型：1 文字；2 图文链接； 3 图片 ；4 视频； 5语音 ；6 文件；7 好友名片；8 小程序；11 视频号消息；12 视频号直播消息',
  `sender_external_user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '发送者external_user_id',
  `msg_content` text COLLATE utf8mb4_bin NOT NULL COMMENT '消息内容',
  `msg_time` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '消息时间',
  `voice_time` int DEFAULT NULL COMMENT '语音时长/视频时长，时长单位：秒',
  `href` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `title` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '当消息为图文链接时，填写图文链接的标题；当消息为文件时，填写文件名；',
  `desc` varchar(256) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '当消息为图文链接时，填写图文链接的描述',
  `channel_msg_sn` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '消息编号，当msg_type消息类型为视频号消息时，可用该字段进行转发',
  `app_info` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '消息appinfo',
  `quote_app_info` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '引用的消息appinfo',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `room_id` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群聊消息的群id 如果是单聊则为空',
  `at_list` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '当接收的消息中有被@的信息。展示被@的人员id，若多人被@，成员编号用逗号隔开；当@全体成员时，该值为 All',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='鲟迹聊天记录';

-- ----------------------------
-- Table structure for xj_chat_history_latest
-- ----------------------------
DROP TABLE IF EXISTS `xj_chat_history_latest`;
CREATE TABLE `xj_chat_history_latest` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `xj_chat_history_id` bigint DEFAULT NULL COMMENT '最新聊天记录主键',
  `corp_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企业ID',
  `type` tinyint DEFAULT NULL COMMENT '1:群聊，2:私聊',
  `chat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群聊id',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '私聊头像',
  `external_account_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '私聊客户id',
  `external_user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '私聊客户昵称',
  `host_account_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '（扫码号）客服id',
  `host_account_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '（扫码号）客服name',
  `health_user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云平台用户id',
  `participant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群聊名称，私聊名称',
  `pat_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者名字',
  `timestamp` bigint DEFAULT NULL COMMENT '时间戳',
  `unread_count` int DEFAULT NULL COMMENT '未读消息数',
  `update_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL,
  `is_set_unread` tinyint DEFAULT '0' COMMENT '是否手动设置未读 1:是 0:否',
  `exception_msg` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '异常消息',
  PRIMARY KEY (`id`),
  KEY `chat_history_latest_external_user_id_IDX` (`external_account_id`,`host_account_id`) USING BTREE,
  KEY `chat_history_health_user_id_IDX` (`health_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='鲟迹最新一条聊天记录(会话)';

-- ----------------------------
-- Table structure for xj_chat_history_marker
-- ----------------------------
DROP TABLE IF EXISTS `xj_chat_history_marker`;
CREATE TABLE `xj_chat_history_marker` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '主键',
  `health_user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云账号',
  `history_latest_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '最新记录表（会话）id',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `xj_chat_history_marker_health_user_id_IDX` (`health_user_id`,`history_latest_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='会话关注表';

-- ----------------------------
-- Table structure for xj_chat_history_top
-- ----------------------------
DROP TABLE IF EXISTS `xj_chat_history_top`;
CREATE TABLE `xj_chat_history_top` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '主键',
  `history_latest_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '最新记录表（会话）id',
  `health_user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云账号',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `xj_chat_history_pinned_history_latest_id_IDX` (`history_latest_id`,`health_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='会话置顶表';

-- ----------------------------
-- Table structure for xj_msg
-- ----------------------------
DROP TABLE IF EXISTS `xj_msg`;
CREATE TABLE `xj_msg` (
  `id` bigint NOT NULL,
  `robot_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '机器人id',
  `account_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `dead_line` int DEFAULT NULL COMMENT '单位秒 ，消息截止时间戳。到达dead_line消息不发送',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管师id',
  `chat_id` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '群聊id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='鲟迹聊天消息';

-- ----------------------------
-- Table structure for xj_msg_detail
-- ----------------------------
DROP TABLE IF EXISTS `xj_msg_detail`;
CREATE TABLE `xj_msg_detail` (
  `id` bigint NOT NULL,
  `msg_id` bigint NOT NULL COMMENT '鲟迹消息id',
  `inner_msg_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '鲟迹内部消息id',
  `msg_num` int NOT NULL COMMENT '消息num，消息序号',
  `msg_type` int NOT NULL COMMENT '消息类型：1 文字；2 图文链接； 3 图片 ；4 视频； 5语音 ；6 文件；7 好友名片；8 小程序；11 视频号消息；12 视频号直播消息',
  `msg_content` varchar(15000) COLLATE utf8mb4_bin NOT NULL COMMENT '消息内容，最长15000个字符',
  `voice_time` int DEFAULT NULL COMMENT '语音时长/视频时长，时长单位：秒',
  `href` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '当消息为图文链接或视频时，传入链接URL，视频格式限制为mp4且最大时长不可超过30秒； 当消息为文件时，此处传文件的链接地址；',
  `title` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '当消息为图文链接时，填写图文链接的标题；当消息为文件时，填写文件名；',
  `desc` varchar(256) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '当消息为图文链接时，填写图文链接的描述',
  `deliver` tinyint(1) DEFAULT '0' COMMENT '是否送达 0否1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `at_location` tinyint DEFAULT NULL,
  `at` tinyint DEFAULT NULL,
  `at_contact_id_list` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'at部分群成员时，必填,多个以英文逗号分隔',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_msg_id_msg_num` (`msg_id`,`msg_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='鲟迹消息详情';

-- ----------------------------
-- Table structure for xj_user_be_viewed
-- ----------------------------
DROP TABLE IF EXISTS `xj_user_be_viewed`;
CREATE TABLE `xj_user_be_viewed` (
  `be_view_user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '被查看的健管云用户id',
  `health_user_ids` varchar(320) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '当前用户ids（查看方） 逗号隔开',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`be_view_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='被查看的用户记录表';

-- ----------------------------
-- Table structure for xj_user_view_scope
-- ----------------------------
DROP TABLE IF EXISTS `xj_user_view_scope`;
CREATE TABLE `xj_user_view_scope` (
  `health_user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `user_flag` tinyint DEFAULT NULL COMMENT '患者范围 1:我的患者 2：小组患者 3:指定用户',
  `is_banding` tinyint DEFAULT NULL COMMENT '是否绑定 -1全部 0未绑定 1已绑定',
  `is_view_mark` tinyint DEFAULT NULL COMMENT '是否查看标记  -1:全部 0:没关注 1:已关注',
  `health_user_ids` varchar(640) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '其他健管云用户id集合',
  `msg_status` tinyint DEFAULT NULL COMMENT '消息状态 -1-全部 0-未读 1-已读',
  `session_type` tinyint DEFAULT NULL COMMENT '会话类型 -1:全部 0:私聊 1:群聊',
  `hosp_code` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医院编码',
  PRIMARY KEY (`health_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户查看范围表';

SET FOREIGN_KEY_CHECKS = 1;
