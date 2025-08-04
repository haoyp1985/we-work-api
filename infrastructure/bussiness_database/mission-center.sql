/*
 Navicat MySQL Data Transfer

 Source Server         : 192.168.3.31
 Source Server Type    : MySQL
 Source Server Version : 50650
 Source Host           : 192.168.3.31:3306
 Source Schema         : mission-center

 Target Server Type    : MySQL
 Target Server Version : 50650
 File Encoding         : 65001

 Date: 17/07/2025 09:48:18
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for DATABASECHANGELOG
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOG`;
CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) NOT NULL,
  `AUTHOR` varchar(255) NOT NULL,
  `FILENAME` varchar(255) NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int(11) NOT NULL,
  `EXECTYPE` varchar(10) NOT NULL,
  `MD5SUM` varchar(35) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `COMMENTS` varchar(255) DEFAULT NULL,
  `TAG` varchar(255) DEFAULT NULL,
  `LIQUIBASE` varchar(20) DEFAULT NULL,
  `CONTEXTS` varchar(255) DEFAULT NULL,
  `LABELS` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for DATABASECHANGELOGLOCK
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int(11) NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_comprehensive_task
-- ----------------------------
DROP TABLE IF EXISTS `t_comprehensive_task`;
CREATE TABLE `t_comprehensive_task` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `task_id` varchar(32) NOT NULL COMMENT '任务id',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `task_type` tinyint(1) DEFAULT '0' COMMENT '任务类型 1:饮食 2:点评 3:血糖 4:体重',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `task_status` tinyint(1) DEFAULT '0' COMMENT '任务状态 0 没完成 1 完成',
  `plan_time` datetime DEFAULT NULL COMMENT '创建时间',
  `finish_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) DEFAULT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) DEFAULT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_task` (`pat_id`,`task_id`) USING BTREE,
  KEY `idx_hosp` (`hosp_code`) USING BTREE,
  KEY `t_comprehensive_task_plan_time_IDX` (`plan_time`,`is_delete`,`task_status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务总表';

-- ----------------------------
-- Table structure for t_consumer_error_log
-- ----------------------------
DROP TABLE IF EXISTS `t_consumer_error_log`;
CREATE TABLE `t_consumer_error_log` (
  `id` bigint(19) NOT NULL DEFAULT '0',
  `pat_id` varchar(32) DEFAULT NULL COMMENT '患者id',
  `consumer_key` varchar(32) DEFAULT NULL COMMENT '消费者规则key',
  `err_msg` varchar(1024) DEFAULT NULL COMMENT '异常信息',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消费者异常日志';

-- ----------------------------
-- Table structure for t_consumer_log
-- ----------------------------
DROP TABLE IF EXISTS `t_consumer_log`;
CREATE TABLE `t_consumer_log` (
  `id` bigint(19) NOT NULL DEFAULT '0',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `consumer_key` varchar(32) NOT NULL COMMENT '消费者规则key',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消费者消费日志表';

-- ----------------------------
-- Table structure for t_diet_review_task
-- ----------------------------
DROP TABLE IF EXISTS `t_diet_review_task`;
CREATE TABLE `t_diet_review_task` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `app_source` tinyint(1) DEFAULT '0' COMMENT '应用来源 10:减重',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `pat_name` varchar(30) NOT NULL COMMENT '患者名称',
  `team_id` varchar(32) NOT NULL DEFAULT '' COMMENT '分组id',
  `task_meal` varchar(32) DEFAULT NULL,
  `record_num` tinyint(1) DEFAULT NULL COMMENT '餐次记录数',
  `task_num` tinyint(1) NOT NULL COMMENT '任务数',
  `task_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT '任务状态 0 激活 1 没激活',
  `execution_date` varchar(16) NOT NULL COMMENT '任务日期',
  `review_by` varchar(32) DEFAULT NULL COMMENT '点评人名称',
  `review_content` varchar(2048) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '点评内容',
  `review_id` varchar(32) DEFAULT NULL COMMENT '点评时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_id` varchar(32) DEFAULT NULL COMMENT '点评人',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `is_review` tinyint(1) DEFAULT '0' COMMENT '点评标识，0：未点评，1：已点评',
  `is_read_review` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读点评0未读1已读',
  `team_name` varchar(32) NOT NULL COMMENT '分组名称',
  `sex_code` tinyint(1) NOT NULL COMMENT '性别',
  `group_id` varchar(32) DEFAULT '' COMMENT '团队id',
  `review_start_date` varchar(20) NOT NULL COMMENT '点评开始时间',
  `review_end_date` varchar(20) NOT NULL COMMENT '点评结束时间',
  `ai_review_status` tinyint(2) NOT NULL DEFAULT '0' COMMENT 'ai点评状态 0 没有 1 有',
  `manage_user_id` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员id',
  `manage_user_name` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员姓名',
  `review_frequency` tinyint(3) NOT NULL DEFAULT '6' COMMENT '点评频次',
  `review_frequency_value` tinyint(3) NOT NULL DEFAULT '0' COMMENT '点评间隔',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  `ai_review_content` varchar(1024) DEFAULT NULL COMMENT 'ai点评内容',
  `recognition_incorrect` tinyint(4) DEFAULT '-1' COMMENT '识别不准 1是 默认-1',
  `not_plan_review` tinyint(4) DEFAULT '-1' COMMENT '未按方案点评 1是  默认-1',
  `evaluate` tinyint(4) DEFAULT '0' COMMENT '0-初始值 1-点赞 2-点踩',
  `message_id` varchar(500) DEFAULT NULL COMMENT '消息id',
  `conversation_id` varchar(500) DEFAULT NULL COMMENT '对话id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_pat_id_excution_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pat_blood_pressure_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_blood_pressure_task`;
CREATE TABLE `t_pat_blood_pressure_task` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `hosp_code` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '监管云患者id',
  `team_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者分组id',
  `execution_date` varchar(16) CHARACTER SET utf8 DEFAULT NULL COMMENT '执行日期',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '完成标志 0未完成 1已完成',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者血压任务表';

-- ----------------------------
-- Table structure for t_pat_blood_sugar_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_blood_sugar_task`;
CREATE TABLE `t_pat_blood_sugar_task` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) NOT NULL COMMENT '健管云患者id',
  `team_id` varchar(32) NOT NULL DEFAULT '' COMMENT '分组id',
  `execution_date` varchar(16) DEFAULT NULL COMMENT '执行日期',
  `measure_point` tinyint(4) NOT NULL COMMENT '监测点',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '完成标志 0未完成 1已完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pat_body_temp_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_body_temp_task`;
CREATE TABLE `t_pat_body_temp_task` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) NOT NULL COMMENT '健管云患者id',
  `team_id` varchar(32) NOT NULL COMMENT '患者分组id',
  `execution_date` varchar(16) DEFAULT NULL COMMENT '执行日期',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '完成标志 0未完成 1已完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pat_diet_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_diet_task`;
CREATE TABLE `t_pat_diet_task` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `pat_name` varchar(30) NOT NULL COMMENT '患者名称',
  `team_id` varchar(32) NOT NULL DEFAULT '' COMMENT '分组id',
  `execution_date` varchar(32) NOT NULL COMMENT '日期',
  `meal` tinyint(1) NOT NULL COMMENT '餐次',
  `recommend_calories` decimal(8,2) DEFAULT '0.00' COMMENT '推荐能量',
  `task_source` tinyint(2) NOT NULL DEFAULT '0' COMMENT '任务来源 0 方案 1 记录',
  `diet_plan_id` varchar(32) DEFAULT NULL COMMENT '饮食方案id',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '任务状态 0 没完成 1 完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`,`meal`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务-饮食';

-- ----------------------------
-- Table structure for t_pat_height_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_height_task`;
CREATE TABLE `t_pat_height_task` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) NOT NULL COMMENT '健管云患者id',
  `team_id` varchar(32) NOT NULL COMMENT '分组id',
  `execution_date` varchar(16) DEFAULT NULL COMMENT '执行日期',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '完成标志 0未完成 1已完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者身高任务表';

-- ----------------------------
-- Table structure for t_pat_ovulation_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_ovulation_task`;
CREATE TABLE `t_pat_ovulation_task` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) NOT NULL COMMENT '健管云患者id',
  `team_id` varchar(32) NOT NULL COMMENT '患者分组id',
  `execution_date` varchar(16) DEFAULT NULL COMMENT '执行日期',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '完成标志 0未完成 1已完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pat_pregnancy_nwh_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_pregnancy_nwh_task`;
CREATE TABLE `t_pat_pregnancy_nwh_task` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `execution_date` varchar(32) NOT NULL COMMENT '日期',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '任务状态 0 没完成 1 完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) DEFAULT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) DEFAULT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务-孕期体围';

-- ----------------------------
-- Table structure for t_pat_pulse_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_pulse_task`;
CREATE TABLE `t_pat_pulse_task` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) NOT NULL COMMENT '健管云患者id',
  `team_id` varchar(32) NOT NULL COMMENT '分组id',
  `execution_date` varchar(16) DEFAULT NULL COMMENT '执行日期',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '完成标志 0未完成 1已完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者脉搏任务表';

-- ----------------------------
-- Table structure for t_pat_sport_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_sport_task`;
CREATE TABLE `t_pat_sport_task` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `pat_name` varchar(30) NOT NULL COMMENT '患者名称',
  `team_id` varchar(32) NOT NULL COMMENT '分组id',
  `execution_date` varchar(32) NOT NULL COMMENT '日期',
  `sport_id` varchar(50) NOT NULL COMMENT '运动任务id(活动默认为ms_)',
  `sport_type` tinyint(1) NOT NULL COMMENT '运动类型',
  `sport_plan_id` varchar(32) NOT NULL COMMENT '运动方案id',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '任务状态 0 没完成 1 完成',
  `task_num` int(4) NOT NULL COMMENT '运动任务数',
  `record_num` int(1) NOT NULL COMMENT '记录数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务-饮食';

-- ----------------------------
-- Table structure for t_pat_surrounded_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_surrounded_task`;
CREATE TABLE `t_pat_surrounded_task` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `hosp_code` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '监管云患者id',
  `team_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者分组id',
  `execution_date` varchar(16) CHARACTER SET utf8 DEFAULT NULL COMMENT '执行日期',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '完成标志 0未完成 1已完成',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者体围任务表';

-- ----------------------------
-- Table structure for t_pat_weight_task
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_weight_task`;
CREATE TABLE `t_pat_weight_task` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `pat_id` varchar(32) NOT NULL COMMENT '健管云患者id',
  `team_id` varchar(32) NOT NULL DEFAULT '' COMMENT '分组id',
  `execution_date` varchar(16) DEFAULT NULL COMMENT '执行日期',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '完成标志 0未完成 1已完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_remind_config
-- ----------------------------
DROP TABLE IF EXISTS `t_remind_config`;
CREATE TABLE `t_remind_config` (
  `id` varchar(32) NOT NULL,
  `user_id` varchar(32) NOT NULL COMMENT '用户id',
  `notice_type` tinyint(1) NOT NULL COMMENT '通知类型 1：饮食点评 2：运动点评',
  `state` tinyint(1) NOT NULL COMMENT '消息通知开启状态：0:关闭 1：已开启',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_sport_review_record_ref
-- ----------------------------
DROP TABLE IF EXISTS `t_sport_review_record_ref`;
CREATE TABLE `t_sport_review_record_ref` (
  `id` bigint(19) NOT NULL DEFAULT '0',
  `record_id` varchar(32) DEFAULT NULL COMMENT '记录id',
  `ref_review_id` varchar(32) DEFAULT NULL COMMENT '映射记录id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='运动记录和点评关系映射表';

-- ----------------------------
-- Table structure for t_sport_review_task
-- ----------------------------
DROP TABLE IF EXISTS `t_sport_review_task`;
CREATE TABLE `t_sport_review_task` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `pat_name` varchar(30) NOT NULL COMMENT '患者名称',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `team_id` varchar(32) NOT NULL COMMENT '患者分组',
  `execution_date` varchar(16) NOT NULL COMMENT '任务日期',
  `team_name` varchar(32) NOT NULL COMMENT '分组名称',
  `sex_code` tinyint(1) NOT NULL COMMENT '性别',
  `record_ids` varchar(1024) NOT NULL DEFAULT '' COMMENT '点评运动ids',
  `review_by` varchar(32) DEFAULT NULL COMMENT '点评人名称',
  `review_content` varchar(2048) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '点评内容',
  `review_id` varchar(32) DEFAULT NULL COMMENT '点评时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_id` varchar(32) DEFAULT NULL COMMENT '点评人',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `is_review` tinyint(1) DEFAULT '0' COMMENT '点评标识，0：未点评，1：已点评',
  `is_read_review` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已读点评0未读1已读',
  `record_qty` int(6) NOT NULL DEFAULT '0' COMMENT '当前记录数',
  `group_id` varchar(32) DEFAULT '' COMMENT '团队id',
  `manage_user_id` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员id',
  `manage_user_name` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员姓名',
  `review_start_date` varchar(20) NOT NULL COMMENT '点评开始时间',
  `review_end_date` varchar(20) NOT NULL COMMENT '点评结束时间',
  `review_frequency` tinyint(3) NOT NULL DEFAULT '2' COMMENT '点评频次',
  `review_frequency_value` tinyint(3) NOT NULL DEFAULT '0' COMMENT '点评间隔',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  `recognition_incorrect` tinyint(4) DEFAULT '-1' COMMENT '识别不准 1是 默认-1',
  `not_plan_review` tinyint(4) DEFAULT '-1' COMMENT '未按方案点评 1是  默认-1',
  `evaluate` tinyint(4) DEFAULT '0' COMMENT '0-初始值 1-点赞 2-点踩',
  `message_id` varchar(500) DEFAULT NULL COMMENT '消息id',
  `conversation_id` varchar(500) DEFAULT NULL COMMENT '对话id',
  `ai_review_content` text,
  `ai_bad_reason` varchar(1024) DEFAULT NULL COMMENT 'ai点评踩的原因',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_pat_id_excution_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
