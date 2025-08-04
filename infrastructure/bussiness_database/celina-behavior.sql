/*
 Navicat MySQL Data Transfer

 Source Server         : 健海测试-3.88
 Source Server Type    : MySQL
 Source Server Version : 80034
 Source Host           : 192.168.3.88:3306
 Source Schema         : celina-behavior

 Target Server Type    : MySQL
 Target Server Version : 80034
 File Encoding         : 65001

 Date: 18/07/2025 13:55:25
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for DATABASECHANGELOG
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOG`;
CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `AUTHOR` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `FILENAME` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `MD5SUM` varchar(35) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TAG` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LIQUIBASE` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CONTEXTS` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LABELS` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for DATABASECHANGELOGLOCK
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_behavior_action
-- ----------------------------
DROP TABLE IF EXISTS `t_behavior_action`;
CREATE TABLE `t_behavior_action` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `action_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '动作名',
  `data_option` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '数据项字段',
  `data_option_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '数据项名称',
  `data_option_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '数据项类型',
  `table_name` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表名',
  `sort` int DEFAULT NULL COMMENT '排序',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='动作汇总';

-- ----------------------------
-- Table structure for t_behavior_diet_record
-- ----------------------------
DROP TABLE IF EXISTS `t_behavior_diet_record`;
CREATE TABLE `t_behavior_diet_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键，唯一标识',
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `execution_date` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行日期',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者id-数据中心',
  `hug_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '蓝牛id',
  `meal` tinyint DEFAULT NULL COMMENT '餐次',
  `meal_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '餐次名',
  `pic_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '饮食照片',
  `record_desc` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '记录描述(自我评价)',
  `text_desc` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '饮食文字描述',
  `ai_review_content` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ai点评',
  `record_time` datetime DEFAULT NULL COMMENT '记录时间',
  `detail` json DEFAULT NULL COMMENT '饮食详情',
  `source_desc` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '记录来源',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者饮食记录';

-- ----------------------------
-- Table structure for t_behavior_enroll_record
-- ----------------------------
DROP TABLE IF EXISTS `t_behavior_enroll_record`;
CREATE TABLE `t_behavior_enroll_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `execution_date` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行日期',
  `enroll_event` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报名赛事',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报名人患者id-数据中心',
  `hug_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报名人蓝牛id',
  `enroll_time` datetime DEFAULT NULL COMMENT '报名时间',
  `invite_pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邀请人患者id-数据中心',
  `invite_hug_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邀请人蓝牛id',
  `invite_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邀请人名字',
  `invite_flag` tinyint DEFAULT NULL COMMENT '邀请标记 0 否 1 是',
  `source_desc` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '记录来源',
  `competition_type` tinyint DEFAULT NULL COMMENT '参赛类型1.全民大赛2.减重大赛',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者报名动作';

-- ----------------------------
-- Table structure for t_behavior_invite_record
-- ----------------------------
DROP TABLE IF EXISTS `t_behavior_invite_record`;
CREATE TABLE `t_behavior_invite_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `execution_date` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行日期',
  `invite_event` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邀请主题',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邀请人患者id-数据中心',
  `invite_hug_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邀请人蓝牛id',
  `invite_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邀请人名字',
  `invited_hug_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '被邀请人蓝牛id',
  `invited_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '被邀请人名字',
  `invite_time` datetime DEFAULT NULL COMMENT '邀请时间',
  `source_desc` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '记录来源',
  `competition_type` tinyint DEFAULT NULL COMMENT '参赛类型1.全民大赛2.减重大赛',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者拉新动作';

-- ----------------------------
-- Table structure for t_behavior_physical_record
-- ----------------------------
DROP TABLE IF EXISTS `t_behavior_physical_record`;
CREATE TABLE `t_behavior_physical_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `execution_date` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行日期',
  `enroll_event` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报名赛事',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者id-数据中心',
  `hug_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '蓝牛id',
  `physical_url` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '体测照片',
  `physical_time` datetime DEFAULT NULL COMMENT '体测上传时间',
  `source_desc` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '记录来源',
  `competition_type` tinyint DEFAULT NULL COMMENT '参赛类型1.全民大赛2.减重大赛',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者体测动作';

-- ----------------------------
-- Table structure for t_behavior_sleep_record
-- ----------------------------
DROP TABLE IF EXISTS `t_behavior_sleep_record`;
CREATE TABLE `t_behavior_sleep_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者id-数据中心',
  `hug_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '蓝牛id',
  `execution_date` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行日期',
  `total_sleep_time` int DEFAULT NULL COMMENT '睡眠时长',
  `start_time` datetime DEFAULT NULL COMMENT '入睡时间',
  `end_time` datetime DEFAULT NULL COMMENT '醒来时间',
  `sleep_score` int DEFAULT NULL COMMENT '睡眠得分',
  `record_time` datetime DEFAULT NULL COMMENT '记录时间',
  `source_desc` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '记录来源',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者睡眠记录';

-- ----------------------------
-- Table structure for t_behavior_sport_record
-- ----------------------------
DROP TABLE IF EXISTS `t_behavior_sport_record`;
CREATE TABLE `t_behavior_sport_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者id-数据中心',
  `hug_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '蓝牛id',
  `execution_date` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行日期',
  `step_num` int DEFAULT NULL COMMENT '今日步数',
  `burn_calories` decimal(8,2) DEFAULT NULL COMMENT '今日消耗(卡路里)',
  `sport_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '-1' COMMENT '运动类型(运动id)',
  `sport_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '运动类型(运动名称)',
  `sport_time` int DEFAULT '0' COMMENT '运动时长',
  `record_time` datetime DEFAULT NULL COMMENT '记录时间',
  `source_desc` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '记录来源',
  `sport_record_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'plus减重运动记录表id',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者运动记录';

-- ----------------------------
-- Table structure for t_points_rule_config
-- ----------------------------
DROP TABLE IF EXISTS `t_points_rule_config`;
CREATE TABLE `t_points_rule_config` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `rule_code` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则编码',
  `rule_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则名称',
  `rule_task_type` tinyint(1) DEFAULT NULL COMMENT '规则类型  0-周期性任务 1-事件任务',
  `rule_cycle_type` tinyint(1) DEFAULT NULL COMMENT '周期类型 0-天 1-周  2-月',
  `is_frequency_up` tinyint(1) DEFAULT NULL COMMENT '是否有次数上线 0-无 1-有',
  `points_frequency_up` int DEFAULT NULL COMMENT '积分获取次数上限',
  `is_value_up` tinyint(1) DEFAULT NULL COMMENT '是否有分值上线 0-无 1-有',
  `points_value_up` int DEFAULT NULL COMMENT '积分获取值上线',
  `rule_validity_start_time` datetime DEFAULT NULL COMMENT '规则有效开始时间',
  `rule_validity_end_time` datetime DEFAULT NULL COMMENT '规则有效结束时间',
  `is_points_expire` tinyint(1) DEFAULT NULL COMMENT '积分是否会失效 0-不失效 1-会失效',
  `points_expire_day` int DEFAULT NULL COMMENT '积分失效天数',
  `associated_action` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联动作',
  `rule_field` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则字段',
  `calculation_symbol` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计算符号',
  `computed_value` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计算值',
  `score` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '得分',
  `is_delete` tinyint(1) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `editor_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='积分规则配置';

-- ----------------------------
-- Table structure for t_user_activity_points
-- ----------------------------
DROP TABLE IF EXISTS `t_user_activity_points`;
CREATE TABLE `t_user_activity_points` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hug_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `total_points` int DEFAULT '0' COMMENT '总积分',
  `available_points` int DEFAULT '0' COMMENT '可用积分',
  `used_points` int DEFAULT '0' COMMENT '已使用积分',
  `expired_Points` int DEFAULT '0' COMMENT '失效积分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0',
  `editor_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户活动积分表';

-- ----------------------------
-- Table structure for t_user_activity_points_batch
-- ----------------------------
DROP TABLE IF EXISTS `t_user_activity_points_batch`;
CREATE TABLE `t_user_activity_points_batch` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `hug_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `points_rule_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '积分规则id',
  `points_amount` int DEFAULT '0' COMMENT '积分数量',
  `available_points` int NOT NULL COMMENT '可用积分',
  `expiry_date` datetime NOT NULL COMMENT '失效日期',
  `status` int NOT NULL COMMENT '状态 0-有效 1-已使用 2-过期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0',
  `editor_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户活动积分获取表';

-- ----------------------------
-- Table structure for t_user_activity_points_log
-- ----------------------------
DROP TABLE IF EXISTS `t_user_activity_points_log`;
CREATE TABLE `t_user_activity_points_log` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `hug_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `batch_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `change_points` int DEFAULT '0' COMMENT '变化积分',
  `transaction_type` int NOT NULL COMMENT '交流类型 0-兑换 1-获得 2-失效',
  `event_desc` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '事件描述',
  `event_type` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '类型',
  `source_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '活动类型或兑换物品类型',
  `source_id` bigint DEFAULT NULL COMMENT '关联活动或兑换记录ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0',
  `editor_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户活动积分日志表';

SET FOREIGN_KEY_CHECKS = 1;
