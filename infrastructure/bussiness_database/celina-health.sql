/*
 Navicat MySQL Data Transfer

 Source Server         : 健海-测试
 Source Server Type    : MySQL
 Source Server Version : 80034
 Source Host           : 192.168.3.88:3306
 Source Schema         : celina-health

 Target Server Type    : MySQL
 Target Server Version : 80034
 File Encoding         : 65001

 Date: 16/07/2025 11:12:59
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for DATABASECHANGELOG
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOG`;
CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `AUTHOR` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `FILENAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `MD5SUM` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `TAG` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `LIQUIBASE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CONTEXTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `LABELS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for DATABASECHANGELOGLOCK
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for PDMAN_DB_VERSION
-- ----------------------------
DROP TABLE IF EXISTS `PDMAN_DB_VERSION`;
CREATE TABLE `PDMAN_DB_VERSION` (
  `DB_VERSION` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `VERSION_DESC` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `CREATED_TIME` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for _select_pp_from_t_h_inhosp_order_pp_left_join_t_h_patient_thp_on
-- ----------------------------
DROP TABLE IF EXISTS `_select_pp_from_t_h_inhosp_order_pp_left_join_t_h_patient_thp_on`;
CREATE TABLE `_select_pp_from_t_h_inhosp_order_pp_left_join_t_h_patient_thp_on` (
  `INSERT INTO ``t_h_inhosp_order``  (id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `organ_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `empi_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pay_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PAT_INDEX_NO` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `INHOSP_NO` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `INHOSP_NUM` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `INHOSP_SERIAL_NO` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_NO` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_GROUP_NO` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_PLAN_BEGIN_DATE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_PLAN_END_DATE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_BEGIN_DATE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_END_DATE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_ORDER_DATE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_OPEN_DEPT_CODE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_OPEN_DEPT_NAME` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_OPEN_DR_CODE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_OPEN_DR_NAME` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_EXECUTE_DATE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_ITEM_TYPE_CODE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_ITEM_TYPE_NAME` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_CATEG_CODE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_CATEG_NAME` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_ITEM_CODE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_ITEM_NAME` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_CODE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_NAME` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_SPECIFICATIONS` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DOSE_WAY_CODE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DOSE_WAY_NAME` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_USE_ONE_DOSAGE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_USE_ONE_DOSAGE_UNIT` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_USE_FREQUENCY_CODE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_USE_FREQUENCY_NAME` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_FORM_CODE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_FORM_NAME` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_UNIT` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_UNIT_PRICE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_ABBREV` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_DESCR` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DRUG_AMOUNT` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_DURATION` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ORDER_DURATION_UNIT` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `BASE_AUX_DRUG_FLAG` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DISCHARGE_ORDER_FLAG` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DR_ENTRUST` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NOTE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `UPDATE_DATE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IS_REFUND` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CHARGE_DATE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `REFUND_DATE` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `JxhCreateTime) VALUES` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for ai_lung_rads
-- ----------------------------
DROP TABLE IF EXISTS `ai_lung_rads`;
CREATE TABLE `ai_lung_rads` (
  `id` varchar(36) NOT NULL COMMENT '主键ID',
  `pay_id` varchar(36) DEFAULT NULL COMMENT '支付ID',
  `interpret_id` varchar(36) DEFAULT NULL COMMENT '解读ID',
  `longest_diameter` decimal(5,1) DEFAULT NULL COMMENT '最长径',
  `size` varchar(50) DEFAULT NULL COMMENT '结节大小',
  `lung_rads_grade` varchar(20) DEFAULT NULL COMMENT 'lung_RADS分级',
  `risk_level` tinyint DEFAULT NULL COMMENT '风险等级 0-低 1-中 2-高',
  `location` varchar(100) DEFAULT NULL COMMENT '结节位置',
  `nature` varchar(50) DEFAULT NULL COMMENT '结节性质',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `report_date` varchar(20) DEFAULT NULL COMMENT '报告时间',
  `volume` decimal(8,2) DEFAULT NULL COMMENT '体积',
  `shape` varchar(100) DEFAULT NULL COMMENT '形态',
  PRIMARY KEY (`id`),
  KEY `idx_pay_id` (`pay_id`),
  KEY `idx_interpret_id` (`interpret_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI肺结节解读结果表';

-- ----------------------------
-- Table structure for ai_measure
-- ----------------------------
DROP TABLE IF EXISTS `ai_measure`;
CREATE TABLE `ai_measure` (
  `id` bigint NOT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '开单id',
  `pat_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者姓名',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者id',
  `health_user_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理人员id',
  `initial_measure_name` varchar(256) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '干预措施',
  `traceability` varchar(256) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '溯源信息',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ai措施';

-- ----------------------------
-- Table structure for ai_report_interpret
-- ----------------------------
DROP TABLE IF EXISTS `ai_report_interpret`;
CREATE TABLE `ai_report_interpret` (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键（UUID）',
  `pay_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付ID',
  `report_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报告名称',
  `report_image_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报告图片URL',
  `interpret_status` tinyint DEFAULT '0' COMMENT '解读状态（0-未解读，1-已解读）',
  `pat_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者名称',
  `sex_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别',
  `age` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '年龄',
  `exam_item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '检查项目',
  `report_date` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报告日期（字符串格式，如YYYY-MM-DD）',
  `diag_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '诊断（临床诊断）',
  `dept_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '科室',
  `sample_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标本种类',
  `exam_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '检查结果（检查结果描述）',
  `exam_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '检查描述（检查影像所见信息详细描述）',
  `personality_interpretation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '个性化解读',
  `test_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '检验结果',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除（0-未删除，1-已删除）',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `report_type` tinyint DEFAULT '0' COMMENT '报告类型（ 0-检验报告 1-检查报告 2-人体成分）',
  `risk_level` tinyint DEFAULT NULL COMMENT '风险等级 0-低 1-中 2-高',
  `risk_status` tinyint DEFAULT NULL COMMENT '风险评估状态 -1-无评估 0-评估中 1-完成',
  `is_check` tinyint(1) DEFAULT '0' COMMENT '是否检查 0否 1是',
  `check_user_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人',
  `check_time` datetime DEFAULT NULL COMMENT '操作日期',
  `is_lr_check` tinyint(1) DEFAULT '0' COMMENT '风险报告是否检查 0否 1是',
  `ai_lr_user` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风险报告操作人',
  `lr_check_time` datetime DEFAULT NULL COMMENT '风险报告操作日期',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '患者是否已读 0否 1是',
  PRIMARY KEY (`id`),
  KEY `idx_pay_id` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='AI报告解读表';

-- ----------------------------
-- Table structure for ai_task_back
-- ----------------------------
DROP TABLE IF EXISTS `ai_task_back`;
CREATE TABLE `ai_task_back` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ai_push_status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `content_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `content_title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ai_push_person_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ai_push_time` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `account` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for ai_task_back_copy1
-- ----------------------------
DROP TABLE IF EXISTS `ai_task_back_copy1`;
CREATE TABLE `ai_task_back_copy1` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ai_push_status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `content_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `content_title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ai_push_person_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ai_push_time` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `account` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for ai_task_back_copy2
-- ----------------------------
DROP TABLE IF EXISTS `ai_task_back_copy2`;
CREATE TABLE `ai_task_back_copy2` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ai_push_status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `content_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `content_title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ai_push_person_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ai_push_time` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `account` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for app_upgrade_config
-- ----------------------------
DROP TABLE IF EXISTS `app_upgrade_config`;
CREATE TABLE `app_upgrade_config` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '主键id',
  `app_type` int DEFAULT NULL COMMENT '0健管线下pad',
  `app_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'app名称',
  `app_version` double(3,1) DEFAULT NULL COMMENT 'app版本',
  `app_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'app下载url',
  `upgrade_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新提升信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for app_upgrade_config_1
-- ----------------------------
DROP TABLE IF EXISTS `app_upgrade_config_1`;
CREATE TABLE `app_upgrade_config_1` (
  `id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `app_type` int DEFAULT NULL,
  `app_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `app_version` double DEFAULT NULL,
  `app_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `upgrade_msg` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for databasechangelog
-- ----------------------------
DROP TABLE IF EXISTS `databasechangelog`;
CREATE TABLE `databasechangelog` (
  `ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AUTHOR` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FILENAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MD5SUM` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAG` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LIQUIBASE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTEXTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LABELS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for databasechangeloglock
-- ----------------------------
DROP TABLE IF EXISTS `databasechangeloglock`;
CREATE TABLE `databasechangeloglock` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for demo222
-- ----------------------------
DROP TABLE IF EXISTS `demo222`;
CREATE TABLE `demo222` (
  `a` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `b` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `c` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `d` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `e` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `f` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `g` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `h` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `i` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `j` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `k` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `l` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `m` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `n` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for demo333
-- ----------------------------
DROP TABLE IF EXISTS `demo333`;
CREATE TABLE `demo333` (
  `id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `inhosp_no` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `outhosp_no` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `total_money` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `charge_date` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `charge_item_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_advance` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for digital_therapy_management_plan
-- ----------------------------
DROP TABLE IF EXISTS `digital_therapy_management_plan`;
CREATE TABLE `digital_therapy_management_plan` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `same_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '同一方案的id',
  `special_disease_database_code` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '专病库编码',
  `applicable_disease_code` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用疾病编码',
  `description` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `version` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '版本',
  `release_status` tinyint(1) DEFAULT '0' COMMENT '发布状态，0未发布,1已发布',
  `plan_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方案名称',
  `create_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数疗管理方案表';

-- ----------------------------
-- Table structure for dtx_one_level_label
-- ----------------------------
DROP TABLE IF EXISTS `dtx_one_level_label`;
CREATE TABLE `dtx_one_level_label` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `code` int DEFAULT NULL COMMENT '标签',
  `label_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签名称',
  `create_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数疗一级标签';

-- ----------------------------
-- Table structure for dtx_second_level_label
-- ----------------------------
DROP TABLE IF EXISTS `dtx_second_level_label`;
CREATE TABLE `dtx_second_level_label` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `code` int DEFAULT NULL COMMENT '标签',
  `label_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签名称',
  `one_level_label_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '一级标签id',
  `create_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数疗二级标签';

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `context` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `desc_imgs` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `reply_content` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for hosp_req_status_info
-- ----------------------------
DROP TABLE IF EXISTS `hosp_req_status_info`;
CREATE TABLE `hosp_req_status_info` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构名称',
  `esb_status` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'esb状态 正常: 0  异常: 1',
  `interview_status` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '随访状态 正常: 0  异常: 1 ',
  `dischargesummary_status` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院小结状态 正常: 0  异常: 1 ',
  `esb_request_time` datetime DEFAULT NULL COMMENT '请求esb时间',
  `esb_response_time` datetime DEFAULT NULL COMMENT 'esb响应时间',
  `esb_spend_time` int NOT NULL COMMENT 'esb耗时 ms',
  `interview_request_time` datetime DEFAULT NULL COMMENT '请求随访时间',
  `interview_response_time` datetime DEFAULT NULL COMMENT '随访响应时间',
  `interview_spend_time` int NOT NULL COMMENT '随访耗时 ms',
  `dischargesummary_request_time` datetime DEFAULT NULL COMMENT '请求出院小结时间',
  `dischargesummary_response_time` datetime DEFAULT NULL COMMENT '出院小结响应时间',
  `dischargesummary_spend_time` int NOT NULL COMMENT '出院小结耗时 ms',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for hosp_req_status_info_log
-- ----------------------------
DROP TABLE IF EXISTS `hosp_req_status_info_log`;
CREATE TABLE `hosp_req_status_info_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构名称',
  `hosp_url` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院的url',
  `request_system` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'esb: 0  随访: 1  出院小结: 2',
  `status` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '响应的系统状态 正常: 0  异常: 1 ',
  `request_time` datetime DEFAULT NULL COMMENT '请求时间',
  `response_time` datetime DEFAULT NULL COMMENT '响应时间',
  `spend_time` int DEFAULT NULL COMMENT '耗时 ms',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `msg` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '返回消息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for hosp_req_status_monitor
-- ----------------------------
DROP TABLE IF EXISTS `hosp_req_status_monitor`;
CREATE TABLE `hosp_req_status_monitor` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构名称',
  `hosp_url` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院的url',
  `request_param` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `summary_cache_type` int DEFAULT NULL COMMENT '出院小结缓存方法类型 0-缓存pdf , 1-调用/hug_interview/summary接口 post  2-调用/hug_interview/summary接口 get  3-嘉善，第三方接口  4-绍二，第三方接口 5-宁波三院',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for key_words
-- ----------------------------
DROP TABLE IF EXISTS `key_words`;
CREATE TABLE `key_words` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `key_word` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关键词',
  `key_word_type` tinyint(1) DEFAULT '9' COMMENT '词类型',
  `parent_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '父级id',
  `enable_status` tinyint(1) DEFAULT '1' COMMENT '启用状态(0:禁用 1:启用)',
  `module_type` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '所属模块',
  `standard_documents` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标准文件',
  `coding` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编码',
  `update_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '更新人id',
  `update_user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '更新人姓名',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='标红关键词表';

-- ----------------------------
-- Table structure for key_words_conf
-- ----------------------------
DROP TABLE IF EXISTS `key_words_conf`;
CREATE TABLE `key_words_conf` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `conf_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '配置名',
  `remark` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '说说明',
  `enable_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '启用状态(0:禁用 1:启用)',
  `update_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '更新人id',
  `update_user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '更新人姓名',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='词库配置表';

-- ----------------------------
-- Table structure for key_words_hosp_pack_conf
-- ----------------------------
DROP TABLE IF EXISTS `key_words_hosp_pack_conf`;
CREATE TABLE `key_words_hosp_pack_conf` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `key_word_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'key_words表ID',
  `key_words_conf_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '词库配置表id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院编码',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'pack表ID',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标志0否1是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `hosp_code_pack_key` (`hosp_code`,`pack_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='标红关键词表';

-- ----------------------------
-- Table structure for key_words_pack_conf
-- ----------------------------
DROP TABLE IF EXISTS `key_words_pack_conf`;
CREATE TABLE `key_words_pack_conf` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `key_words_conf_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '词库配置表id',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '路径id',
  `pack_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '路径名称',
  `update_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '更新人id',
  `update_user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '更新人姓名',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='词库路径关联表';

-- ----------------------------
-- Table structure for lyg_pat
-- ----------------------------
DROP TABLE IF EXISTS `lyg_pat`;
CREATE TABLE `lyg_pat` (
  `a1` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a2` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a3` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a4` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a5` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a6` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a7` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a8` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a9` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a10` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a11` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a12` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a13` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a14` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a15` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a16` varchar(2047) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for lyg_pat2
-- ----------------------------
DROP TABLE IF EXISTS `lyg_pat2`;
CREATE TABLE `lyg_pat2` (
  `a1` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a2` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a3` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a4` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a5` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a6` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a7` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a8` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a9` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a10` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a11` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a12` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a13` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a14` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a15` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a16` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for lyg_pat4
-- ----------------------------
DROP TABLE IF EXISTS `lyg_pat4`;
CREATE TABLE `lyg_pat4` (
  `a1` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a2` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a3` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a4` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a5` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a6` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a7` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a8` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a9` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a10` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a11` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a12` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a13` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a14` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a15` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `a16` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for path_confirm_task
-- ----------------------------
DROP TABLE IF EXISTS `path_confirm_task`;
CREATE TABLE `path_confirm_task` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院名称',
  `rule_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '知识库专题包版本id',
  `rule_rule_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '知识库专题包主id',
  `rule_version` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '知识库专题包版本号',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '健管云随访计划id',
  `plan_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '健管云随访计划名称',
  `processor_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '指定责任人id',
  `processor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '指定责任人',
  `expiry_time` datetime NOT NULL COMMENT '失效日期',
  `path_content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '路径内容',
  `path_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '路径价值',
  `voice_url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '沟通录音',
  `doctor_opinions` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '整改意见',
  `path_confirm_file` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径确认文件',
  `confirm_status` int NOT NULL DEFAULT '0' COMMENT '状态 0:审核中 1:已审核通过 2:待整改',
  `diag_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用疾病',
  `dept_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属科室',
  `path_no` varchar(200) DEFAULT NULL COMMENT '路径编号',
  `confirm_dept_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '确认科室',
  `confirm_doctor_duty` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '确认医生职务',
  `doctor_sign_url` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '确认医生签名',
  `completion_time` datetime DEFAULT NULL COMMENT '完成时间',
  `is_delete` int DEFAULT NULL COMMENT '1删除 0未删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator_id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人姓名',
  `diag_code_with_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用疾病(编码)',
  `doctor_opinions_pic` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '整改意见图片',
  `goods_version_id` varchar(32) DEFAULT NULL COMMENT '商品版本ID',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '服务商品id',
  `goods_version` varchar(64) DEFAULT NULL COMMENT '服务商品版本号',
  `doctor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '院内医生id',
  `staff_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '院内医生工号',
  `staff_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '院内医生姓名',
  `management_time_type` tinyint DEFAULT NULL COMMENT '管理时长类型：0代表30,1代表42,2代表60,3代表90,4代表180,-1代表其他',
  `is_other_management_time` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '其他，管理时长值'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='路径确认任务表';

-- ----------------------------
-- Table structure for path_confirm_task_audit_voice
-- ----------------------------
DROP TABLE IF EXISTS `path_confirm_task_audit_voice`;
CREATE TABLE `path_confirm_task_audit_voice` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `task_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '任务id',
  `task_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路径任务名称',
  `type` tinyint DEFAULT NULL COMMENT '内容类型 0表单 1宣教',
  `content_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '内容id',
  `content_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单或宣教名称',
  `voice_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审核录音',
  `voice_text` text COLLATE utf8mb4_general_ci COMMENT '转文字内容',
  `media_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '微信媒体id',
  `is_delete` int DEFAULT NULL COMMENT '1删除 0正常',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for path_confirm_task_voice
-- ----------------------------
DROP TABLE IF EXISTS `path_confirm_task_voice`;
CREATE TABLE `path_confirm_task_voice` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '路径确认任务主键',
  `voice_url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '宣讲内容地址',
  `voice_text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '录音文本json',
  `voice_start_time` datetime DEFAULT NULL COMMENT '录音开始时间',
  `voice_end_time` datetime DEFAULT NULL COMMENT '录音结束时间',
  `voice_time` int DEFAULT NULL COMMENT '录音时长',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_task_id` (`task_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='路径确认录音';

-- ----------------------------
-- Table structure for path_flybook_config
-- ----------------------------
DROP TABLE IF EXISTS `path_flybook_config`;
CREATE TABLE `path_flybook_config` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径Id',
  `pack_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径名称',
  `flybook_url` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '飞书的知识库url',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '删除标记 1:删除 0:正常',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for permission
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `permission_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '权限名称',
  `parent_permission_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '父权限id',
  `parent_permission_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `permission_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '权限id',
  `permission_type` int DEFAULT NULL COMMENT '权限类型 1菜单2按钮',
  `permission_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对应url',
  `sort_no` int DEFAULT NULL COMMENT '排序',
  `pic_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '图片地址',
  `app_identify` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '应用标识',
  `system_type` int NOT NULL DEFAULT '1' COMMENT '所属系统 1 健康教练平台 2 济世大脑 3 良方簿 4 BI系统 5 运营平台',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='权限表';

-- ----------------------------
-- Table structure for person_order_field
-- ----------------------------
DROP TABLE IF EXISTS `person_order_field`;
CREATE TABLE `person_order_field` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户id',
  `field_type` tinyint(1) DEFAULT NULL COMMENT '排序字段1：开单时间、2：入院时间、3：床位',
  `order_type` tinyint(1) DEFAULT NULL COMMENT '排序顺序1：顺序 2：倒序',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='pad宣讲页面排序暂存';

-- ----------------------------
-- Table structure for plan_prescription
-- ----------------------------
DROP TABLE IF EXISTS `plan_prescription`;
CREATE TABLE `plan_prescription` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `prescription_name` varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方名称',
  `prescription_type` int DEFAULT NULL COMMENT '处方类型0健康评估1用药跟踪2复诊提醒3心理干预4饮食营养5运动指导6依从性促进7异常处理 ',
  `description` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `plan_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理方案id',
  `type` int DEFAULT NULL COMMENT '0一次性1持续性2阶段性',
  `state_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '阶段id',
  `axis_type` int DEFAULT NULL COMMENT '0主轴1副轴',
  `axis_unit` int DEFAULT NULL COMMENT '轴单位',
  `start_value` int DEFAULT NULL COMMENT '起始值',
  `end_value` int DEFAULT NULL COMMENT '结束值',
  `diag_codes` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方适用疾病编码',
  `diag_names` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方适用疾病',
  `lable_codes` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方标签编码',
  `lable_names` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方标签名称',
  `trigger_time_type` int DEFAULT NULL COMMENT '0实时1定时',
  `trigger_time` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '触发时间',
  `trigger_effective_time` int DEFAULT NULL COMMENT '触发有效时间',
  `create_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='处方表';

-- ----------------------------
-- Table structure for plan_prescription_action
-- ----------------------------
DROP TABLE IF EXISTS `plan_prescription_action`;
CREATE TABLE `plan_prescription_action` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `prescription_action_type` int DEFAULT NULL COMMENT '0随访1宣教2提醒3方案',
  `plan_prescription_action_config_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方配置id',
  `plan_prescription_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方id',
  `form` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单',
  `form_effective_time` int DEFAULT NULL COMMENT '表单有效时间',
  `education` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣教类别多个用，隔开',
  `reminder_object` int DEFAULT NULL COMMENT '提醒对象0患者1医生2健管师',
  `remind_content` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '提醒内容',
  `plan_category` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方案类别',
  `plan_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方案id',
  `channel_order` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话6短信，多个用，隔开',
  `synchronous_execution` int DEFAULT NULL COMMENT '0不同步执行1同步执行',
  `create_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='处方动作';

-- ----------------------------
-- Table structure for plan_prescription_action_config
-- ----------------------------
DROP TABLE IF EXISTS `plan_prescription_action_config`;
CREATE TABLE `plan_prescription_action_config` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `plan_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方id',
  `plan_prescription_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方id',
  `execution_time_type` int DEFAULT NULL COMMENT '执行时间类型 0实时1定时',
  `execution_timing_time_type` int DEFAULT NULL COMMENT '执行定时时间类型 0相对时间1绝对时间',
  `execution_time_day` int DEFAULT NULL COMMENT '执行时间天数',
  `execution_time_specific` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '具体的执行时间',
  `synchronous_management` int DEFAULT NULL COMMENT '是否同步管理端0否1是',
  `abnormal_state_synchronization` int DEFAULT NULL COMMENT '异常状态同步0否1是',
  `create_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='处方动作';

-- ----------------------------
-- Table structure for prescription
-- ----------------------------
DROP TABLE IF EXISTS `prescription`;
CREATE TABLE `prescription` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `prescription_name` varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方名称',
  `prescription_type` int DEFAULT NULL COMMENT '处方类型0健康评估1用药跟踪2复诊提醒3心理干预4饮食营养5运动指导6依从性促进7异常处理 ',
  `description` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `diag_codes` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方适用疾病编码',
  `diag_names` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方适用疾病',
  `lable_codes` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方标签编码',
  `lable_names` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方标签名称',
  `trigger_time_type` int DEFAULT NULL COMMENT '0实时1定时',
  `trigger_time` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '触发时间',
  `trigger_effective_time` int DEFAULT NULL COMMENT '触发有效时间',
  `create_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='处方表';

-- ----------------------------
-- Table structure for prescription_action
-- ----------------------------
DROP TABLE IF EXISTS `prescription_action`;
CREATE TABLE `prescription_action` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `prescription_action_type` int DEFAULT NULL COMMENT '0随访1宣教2提醒3方案',
  `prescription_action_config_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方配置id',
  `prescription_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方id',
  `form` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单',
  `form_effective_time` int DEFAULT NULL COMMENT '表单有效时间',
  `education` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣教类别多个用，隔开',
  `reminder_object` int DEFAULT NULL COMMENT '提醒对象0患者1医生2健管师',
  `remind_content` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '提醒内容',
  `plan_category` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方案类别',
  `plan_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方案id',
  `channel_order` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话6短信，多个用，隔开',
  `synchronous_execution` int DEFAULT NULL COMMENT '0不同步执行1同步执行',
  `create_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='处方动作';

-- ----------------------------
-- Table structure for prescription_action_config
-- ----------------------------
DROP TABLE IF EXISTS `prescription_action_config`;
CREATE TABLE `prescription_action_config` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `prescription_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处方id',
  `execution_time_type` int DEFAULT NULL COMMENT '执行时间类型 0实时1定时',
  `execution_timing_time_type` int DEFAULT NULL COMMENT '执行定时时间类型 0相对时间1绝对时间',
  `execution_time_day` int DEFAULT NULL COMMENT '执行时间天数',
  `execution_time_specific` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '具体的执行时间',
  `synchronous_management` int DEFAULT NULL COMMENT '是否同步管理端0否1是',
  `abnormal_state_synchronization` int DEFAULT NULL COMMENT '异常状态同步0否1是',
  `create_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='处方动作';

-- ----------------------------
-- Table structure for remote_hosp_permission
-- ----------------------------
DROP TABLE IF EXISTS `remote_hosp_permission`;
CREATE TABLE `remote_hosp_permission` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院名称',
  `is_delete` int DEFAULT NULL COMMENT '1删除0未删除',
  `update_time` date DEFAULT NULL COMMENT '更新时间',
  `create_time` date DEFAULT NULL COMMENT '创建时间',
  `permission_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `permission_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='远程医院权限';

-- ----------------------------
-- Table structure for remote_preach_hosp
-- ----------------------------
DROP TABLE IF EXISTS `remote_preach_hosp`;
CREATE TABLE `remote_preach_hosp` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院名称',
  `is_delete` int DEFAULT NULL COMMENT '1删除0未删除',
  `update_time` date DEFAULT NULL COMMENT '更新时间',
  `create_time` date DEFAULT NULL COMMENT '创建时间',
  `service_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='远程宣讲开通医院';

-- ----------------------------
-- Table structure for remote_preach_sign
-- ----------------------------
DROP TABLE IF EXISTS `remote_preach_sign`;
CREATE TABLE `remote_preach_sign` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  `mobile_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号',
  `sms_content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '短信内容',
  `is_delete` int DEFAULT NULL COMMENT '是否删除',
  `timeout_push` int DEFAULT NULL COMMENT '1已经超时推送',
  `client_token` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '客户端访问凭证',
  `sign_status` int DEFAULT NULL COMMENT '0同意1拒绝',
  `pic_url` varchar(180) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '签名后的图片地址',
  `pdf_desensitization_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '签名后的pdf图片',
  `pic_desensitization_url` varchar(180) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '签名后的脱敏图片',
  `update_time` date DEFAULT NULL,
  `create_time` date DEFAULT NULL,
  `bill_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单配置项目id',
  `goods_price_id` varchar(64) DEFAULT NULL COMMENT '服务商品物价id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for remote_preach_template
-- ----------------------------
DROP TABLE IF EXISTS `remote_preach_template`;
CREATE TABLE `remote_preach_template` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院编码',
  `template_name` varchar(50) DEFAULT NULL COMMENT '模板名称',
  `template_content` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '模板内容',
  `goods_price_ids` text COMMENT '物价id',
  `charge_item_names` text COMMENT '物价name',
  `is_delete` int DEFAULT NULL,
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `sign_pic_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '签名图片xy位置',
  `sign_relation_pic_xy` varchar(20) DEFAULT NULL COMMENT '亲属签名图片xy位置',
  `name_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '姓名位置X,Y,是否加粗,字体大小',
  `sex_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别位置X,Y,是否加粗,字体大小',
  `age_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '年龄位置X,Y,是否加粗,字体大小',
  `id_card_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '身份证位置X,Y,是否加粗,字体大小',
  `template_url` varchar(220) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模板文件图片地址X,Y,是否加粗,字体大小',
  `mobile_no_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号码X,Y,是否加粗,字体大小',
  `service_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务名称',
  `service_name_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务名称位置X,Y,是否加粗,字体大小',
  `sign_data_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '签名时间位置X,Y,是否加粗,字体大小',
  `dept_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室位置X,Y,是否加粗,字体大小',
  `manage_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '管理员位置X,Y,是否加粗,字体大小',
  `visit_card_num_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '门诊住院位置X,Y,是否加粗,字体大小',
  `birthday_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出生年月位置X,Y,是否加粗,字体大小',
  `attend_dr_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主治医生位置X,Y,是否加粗,字体大小',
  `service_period_xy` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务期限位置X,Y,是否加粗,字体大小',
  `bed_num_xy` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '床位X,Y,是否加粗,字体大小',
  `service_price_xy` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单价格',
  `sign_data_two_xy` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单价格',
  `local_file_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '本地文件名称',
  `relation_flag` tinyint(1) DEFAULT '0' COMMENT '是否区分本人与亲属 0:不区分 1:区分',
  `version_status` tinyint(1) DEFAULT '0' COMMENT '0老1新',
  `create_id` varchar(50) DEFAULT NULL COMMENT '创建人id',
  `create_name` varchar(50) DEFAULT NULL COMMENT '创建人name',
  `update_id` varchar(50) DEFAULT NULL COMMENT '更新人id',
  `update_name` varchar(50) DEFAULT NULL COMMENT '更新人name',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for remote_preach_template_copy1
-- ----------------------------
DROP TABLE IF EXISTS `remote_preach_template_copy1`;
CREATE TABLE `remote_preach_template_copy1` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院编码',
  `template_content` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '模板内容',
  `is_delete` int DEFAULT NULL,
  `update_time` date DEFAULT NULL,
  `create_time` date DEFAULT NULL,
  `sign_pic_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '签名图片xy位置',
  `name_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '姓名位置',
  `sex_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别位置',
  `age_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '年龄位置',
  `id_card_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '身份证位置',
  `template_url` varchar(220) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模板文件图片地址',
  `mobile_no_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号码',
  `service_name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务名称',
  `service_name_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务名称位置',
  `sign_data_xy` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '签名时间位置',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for remote_sign_log
-- ----------------------------
DROP TABLE IF EXISTS `remote_sign_log`;
CREATE TABLE `remote_sign_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `detail_msg` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for resource
-- ----------------------------
DROP TABLE IF EXISTS `resource`;
CREATE TABLE `resource` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `permission_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '权限id',
  `url` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'url地址',
  `method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '请求方式 GET/POST',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='资源表';

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `role_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色名称',
  `description` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '描述',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认 0否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='角色';

-- ----------------------------
-- Table structure for role_organization
-- ----------------------------
DROP TABLE IF EXISTS `role_organization`;
CREATE TABLE `role_organization` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `role_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色id',
  `org_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='角色机构关联表';

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `role_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色id',
  `permission_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '权限id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='角色权限关联表';

-- ----------------------------
-- Table structure for rule_task_operate_log
-- ----------------------------
DROP TABLE IF EXISTS `rule_task_operate_log`;
CREATE TABLE `rule_task_operate_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院编码',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣讲任务id',
  `label_code` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标签编码',
  `operate_type` tinyint(1) DEFAULT NULL COMMENT '操作类型 1:生成宣讲任务',
  `operate_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人id',
  `operate_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人name',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='策略宣讲log';

-- ----------------------------
-- Table structure for service_products_close_plan
-- ----------------------------
DROP TABLE IF EXISTS `service_products_close_plan`;
CREATE TABLE `service_products_close_plan` (
  `id` int DEFAULT NULL,
  `hosp_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `plan_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `rule_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `rule_title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `close_time` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `remark` int DEFAULT NULL,
  `product_primary_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `product_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  UNIQUE KEY `service_products_close_plan_id_IDX` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for service_products_pack_convert
-- ----------------------------
DROP TABLE IF EXISTS `service_products_pack_convert`;
CREATE TABLE `service_products_pack_convert` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `products_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '产品id',
  `pack_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径名',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径id',
  `server_pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务路径id',
  `rule_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专题包名称',
  `rule_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专题包id',
  `data_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '产品或商品',
  `relate_pack_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '对应路径名',
  `relate_rule_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '对应专题包',
  `relate_rule_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '对应专题包id',
  `relate_products_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '商品对应产品id',
  `inner_title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '内部名',
  `out_title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '外部名',
  `authorized_hosp_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用医院',
  `protective_medical_status` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '保护性医疗',
  `phone_task_base_time_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '电话任务触发基线',
  `management_time_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '管理时长',
  `recommend_charge_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推荐价格',
  `team_set_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务类别',
  `consult_open_status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '咨询服务开关',
  `exception_rule_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常规则',
  `ai_comment_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '点评规则',
  `remark` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注（选填）',
  `online_status` varchar(50) DEFAULT NULL COMMENT '是否上架',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='路径转产品表';

-- ----------------------------
-- Table structure for t_alarm_action_record
-- ----------------------------
DROP TABLE IF EXISTS `t_alarm_action_record`;
CREATE TABLE `t_alarm_action_record` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `empi_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `start_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `end_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `day_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `action_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_alarm_action_record1
-- ----------------------------
DROP TABLE IF EXISTS `t_alarm_action_record1`;
CREATE TABLE `t_alarm_action_record1` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `empi_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `start_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `end_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `day_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `action_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_alarm_call_record
-- ----------------------------
DROP TABLE IF EXISTS `t_alarm_call_record`;
CREATE TABLE `t_alarm_call_record` (
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主键',
  `alarm_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '预警任务id',
  `type` int DEFAULT NULL,
  `ai_flag` int DEFAULT NULL,
  `call_status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1',
  `start_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `end_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `download_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mobile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_alarm_call_record1
-- ----------------------------
DROP TABLE IF EXISTS `t_alarm_call_record1`;
CREATE TABLE `t_alarm_call_record1` (
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主键',
  `alarm_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '预警任务id',
  `type` int DEFAULT NULL,
  `ai_flag` int DEFAULT NULL,
  `call_status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `start_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `end_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `download_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mobile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_alert_hospital
-- ----------------------------
DROP TABLE IF EXISTS `t_alert_hospital`;
CREATE TABLE `t_alert_hospital` (
  `id` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hosp_code` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hosp_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` int DEFAULT NULL,
  `create_time` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `end_time` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `yun_xiao_id` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `day_time` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_assistant_client
-- ----------------------------
DROP TABLE IF EXISTS `t_assistant_client`;
CREATE TABLE `t_assistant_client` (
  `id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `client_ip` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `client_mac` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `staff_index` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `third_party` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `third_visit_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `online_state` int DEFAULT NULL,
  `last_online_time` datetime DEFAULT NULL,
  `last_offline_time` datetime DEFAULT NULL,
  `channel_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `asst_version` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_back_times
-- ----------------------------
DROP TABLE IF EXISTS `t_back_times`;
CREATE TABLE `t_back_times` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id 业务表 id',
  `organ_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `source_type` tinyint(1) NOT NULL COMMENT '数据来源 1.住院医嘱 2.住院收费 3.门诊收费',
  `times` int DEFAULT NULL COMMENT '失败重试次数',
  `push_type` tinyint(1) DEFAULT '0' COMMENT '是否推送 0.未推送 1.已推送',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='重试次数表';

-- ----------------------------
-- Table structure for t_billing_config
-- ----------------------------
DROP TABLE IF EXISTS `t_billing_config`;
CREATE TABLE `t_billing_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `config_key` int DEFAULT NULL COMMENT '0更新配置',
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院编码',
  `config_value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_billing_log
-- ----------------------------
DROP TABLE IF EXISTS `t_billing_log`;
CREATE TABLE `t_billing_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `client_ip` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `mac` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `asst_version` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `dll_version` int DEFAULT NULL,
  `his_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `his_version` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `work_number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `memo` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `login_state` int DEFAULT '0',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_billing_login_level_log
-- ----------------------------
DROP TABLE IF EXISTS `t_billing_login_level_log`;
CREATE TABLE `t_billing_login_level_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `client_ip` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `mac` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `asst_version` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `his_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `his_version` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `work_number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `memo` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `login_time` datetime DEFAULT NULL,
  `level_time` datetime DEFAULT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_billing_remind_config
-- ----------------------------
DROP TABLE IF EXISTS `t_billing_remind_config`;
CREATE TABLE `t_billing_remind_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `style_key` int DEFAULT NULL COMMENT '样式key值',
  `msg_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT ' 与客户端约定的消息类型',
  `simple_is_remind` int DEFAULT NULL COMMENT '精简提示框是否提示',
  `simple_bg_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '精简提示框背景图片url',
  `simple_tip_msg` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '精简提示框提示文本',
  `simple_tip_msg_color` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '精简提示框提示文本字体颜色',
  `simple_link_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '精简提示框超级链接文本',
  `simple_link_name_color` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '精简提示框超级链接文本颜色',
  `simple_link_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '精简提示框超级链接地址url',
  `simple_button_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '短框提示按钮内容、颜色',
  `simple_button_text_color` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '短框提示按钮内容、颜色',
  `simple_button_bg_color` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '短框提示按钮内容、颜色',
  `detail_bg_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框背景图片url',
  `title_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框标题栏文字',
  `title_text_color` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框标题栏文字颜色',
  `detail_sub_title_bg_color` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框副标题背景颜色',
  `detail_sub_title_left_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框副标题左边提示内容颜色',
  `detail_sub_title_left_text_color` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框副标题左边提示内容颜色',
  `detail_sub_title_right_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框副标题右边提示内容颜色',
  `detail_sub_title_right_text_color` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框副标题右边提示内容颜色',
  `link_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框超级链接url',
  `link_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框超级链接文本',
  `link_name_color` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框超级链接文本颜色',
  `float_box_icon_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '浮动框背景图片url',
  `form_height` double DEFAULT NULL COMMENT '详细提示框高度',
  `form_width` double DEFAULT NULL COMMENT '详细提示框宽度',
  `column_count` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框表格列',
  `row_count` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '详细提示框表格行',
  `table_height` double DEFAULT NULL COMMENT '详细提示框表格高度',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_chronic_manage_contract
-- ----------------------------
DROP TABLE IF EXISTS `t_chronic_manage_contract`;
CREATE TABLE `t_chronic_manage_contract` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `user_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院机构编码',
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `contract_user_info` varchar(3000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '签约医生JSON',
  `notice_user_info` varchar(3000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '通知医生JSON',
  `service_item_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务项目id',
  `service_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `sign_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '签约日期',
  `start_service_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '起始服务日期',
  `end_service_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '到期服务日期',
  `notice_type` int DEFAULT NULL COMMENT '通知方式',
  `file_address` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '附件地址',
  `create_time` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建日期',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改日期',
  `status` int unsigned NOT NULL DEFAULT '0' COMMENT '使用状态',
  `send_status` int unsigned DEFAULT '0' COMMENT '是否发送 0代表未发送  1代表已发送',
  `service_status` int unsigned DEFAULT '0' COMMENT '0 代表未开始 1代表服务中 2代表已结束',
  `remind_flag` int DEFAULT '0' COMMENT '服务提醒状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_collect_data
-- ----------------------------
DROP TABLE IF EXISTS `t_collect_data`;
CREATE TABLE `t_collect_data` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标题',
  `operate_time` datetime DEFAULT NULL COMMENT '实际时间',
  `real_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上门人员姓名',
  `service_content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务内容',
  `collect_data` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '采集数据json',
  `refuse_reason` tinyint(1) DEFAULT NULL COMMENT '拒绝原因 1患者拒绝 2无法联系 3非辖区 4其他',
  `refuse_content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '拒绝内容',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='上门服务登记';

-- ----------------------------
-- Table structure for t_crm_business_date
-- ----------------------------
DROP TABLE IF EXISTS `t_crm_business_date`;
CREATE TABLE `t_crm_business_date` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者主索引id',
  `customer_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户id',
  `business_date` date DEFAULT NULL COMMENT '业务日期',
  `business_type` int NOT NULL COMMENT '业务日期类型(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩)',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_crm_business_date` (`business_type`,`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者管理用户业务时间表';

-- ----------------------------
-- Table structure for t_crm_pay_patients
-- ----------------------------
DROP TABLE IF EXISTS `t_crm_pay_patients`;
CREATE TABLE `t_crm_pay_patients` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '缴费金额',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `repeat_flag` int DEFAULT NULL COMMENT '是否收案(0:未收案 1:已收案)',
  `collector_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人id',
  `collector_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生名称',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `drug_use_frequency_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次代码',
  `drug_use_frequency_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次名称',
  `note` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱备注',
  `drug_unit_price` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目单价',
  `drug_amount` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目开立数量',
  `add_plan_flag` int DEFAULT NULL COMMENT '是否添加至计划(0:否 1:是)',
  `add_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `add_plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院)',
  `pat_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者地址',
  `diag_code` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引号',
  `order_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱号',
  `is_refund` int NOT NULL DEFAULT '0' COMMENT '退费标志(0为退费 1:已退费)',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `refund_finish_status` int DEFAULT NULL COMMENT '退费完成状态(0:未完成,1:已完成)',
  `false_data` int DEFAULT '0' COMMENT '0：真实数据，1：种子计划数据',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体检报告号',
  `exam_date` datetime DEFAULT NULL COMMENT '体检日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `recheck_handle_status` int DEFAULT NULL COMMENT '复查处理状态(0:未处理 1:已处理)',
  `report_status` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '报告状态(0:未出 1:已出)',
  `preach_status` tinyint(1) DEFAULT '0' COMMENT '宣讲状态 0未宣讲 1已宣讲',
  `manage_status` tinyint(1) DEFAULT '0' COMMENT '管理状态 0未收案/未添加计划 1已收案/已添加计划',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)名称',
  `remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注信息',
  `ward_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区',
  `bed_no` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '床号',
  `sync_flag` int DEFAULT '0' COMMENT '0未同步 1已同步',
  `recheck_handle_time` datetime DEFAULT NULL COMMENT '处理时间',
  `age` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者年龄',
  `is_leave_hosp` int DEFAULT '0' COMMENT '是否出院 1是 0否',
  `succ_flag` int DEFAULT NULL,
  `sdfsdf_flag` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_no` (`order_no`) USING BTREE,
  KEY `idex_empi_id` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_del_mission
-- ----------------------------
DROP TABLE IF EXISTS `t_del_mission`;
CREATE TABLE `t_del_mission` (
  `id` varchar(255) NOT NULL,
  `empi_id` varchar(255) DEFAULT NULL,
  `goods_version_id` varchar(255) DEFAULT NULL,
  `hosp_code` varchar(255) DEFAULT NULL,
  `hosp_name` varchar(255) DEFAULT NULL,
  `pat_name` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `goods_name` varchar(255) DEFAULT NULL,
  `goods_id` varchar(255) DEFAULT NULL,
  `mission_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_disease_area
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_area`;
CREATE TABLE `t_disease_area` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'id',
  `hosp_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `hospital_area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '院区编码',
  `disease_area_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '病区编码',
  `disease_area_name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '病区名称',
  `build_num` int DEFAULT NULL COMMENT '楼号',
  `floor_num` int DEFAULT NULL COMMENT '楼层',
  `order_field` int DEFAULT NULL COMMENT '排序字段',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  `status` tinyint(1) DEFAULT NULL COMMENT '状态 0:待开 1:已开',
  `type` tinyint(1) DEFAULT NULL COMMENT '类型 1:门诊科室 2:住院科室 3:住院病区',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '病区实际名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='病区表';

-- ----------------------------
-- Table structure for t_disease_manage_hosp_config
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_manage_hosp_config`;
CREATE TABLE `t_disease_manage_hosp_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organ_code` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `organ_name` varchar(150) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构名称',
  `advance_minute` tinyint(1) NOT NULL DEFAULT '15' COMMENT '提前 分钟(每次)',
  `advance_mid_hour` tinyint(1) NOT NULL DEFAULT '6' COMMENT '提前 小时(每天中午)',
  `advance_hour` tinyint(1) NOT NULL DEFAULT '24' COMMENT '提前 小时(每天晚上)',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_organ_code` (`organ_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='规范化诊疗拉取配置表';

-- ----------------------------
-- Table structure for t_disease_manage_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_manage_patient`;
CREATE TABLE `t_disease_manage_patient` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `hosp_code` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `pat_index_no` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '门诊流水号',
  `inhosp_no` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '住院流水号',
  `pat_name` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '患者姓名',
  `id_number` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '身份证号码',
  `mobile_no` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '手机号码',
  `empi_id` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '患者主索引号',
  `source_type` int NOT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院 4:体检)',
  `screening_time` datetime NOT NULL COMMENT '筛选时间',
  `screener_name` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '筛选人',
  `screener_id` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '筛选人id',
  `filter_keyword` varchar(100) COLLATE utf8mb4_bin NOT NULL COMMENT '筛选关键词',
  `filter_detail` varchar(2000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '初筛符合条件',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `serial_no` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '业务流水号',
  `disease_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '筛选疾病id',
  `disease_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '筛选疾病name',
  `disease_project_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '疾病项目名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='规范化诊疗疾病管理患者表';

-- ----------------------------
-- Table structure for t_disease_manage_patient_filter
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_manage_patient_filter`;
CREATE TABLE `t_disease_manage_patient_filter` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `hosp_code` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `pay_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '开单id',
  `empi_id` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '患者主索引号',
  `screening_time` datetime NOT NULL COMMENT '筛选时间',
  `screener_name` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '筛选人',
  `screener_id` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '筛选人id',
  `filter_keyword` varchar(100) COLLATE utf8mb4_bin NOT NULL COMMENT '筛选关键词',
  `filter_detail` varchar(2000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '初筛符合条件',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='规范化诊疗疾病管理筛选原因表';

-- ----------------------------
-- Table structure for t_door_collect
-- ----------------------------
DROP TABLE IF EXISTS `t_door_collect`;
CREATE TABLE `t_door_collect` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `task_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务表id',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单表id',
  `door_state` tinyint(1) DEFAULT '0' COMMENT '上门状态 0.未分配 1.已分配待执行 2.已执行',
  `staff_code` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '待上门医生工号',
  `staff_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '待上门医生姓名',
  `operate_time` datetime DEFAULT NULL COMMENT '实际时间',
  `real_staff_code` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '实际上门医生工号',
  `real_staff_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '实际上门医生姓名',
  `service_content` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务内容',
  `pic` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图片',
  `collect_data` text COLLATE utf8mb4_general_ci COMMENT '采集数据json',
  `refuse_reason` tinyint(1) DEFAULT NULL COMMENT '拒绝原因 1患者拒绝 2无法联系 3非辖区 4其他',
  `refuse_content` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拒绝内容',
  `service_start_time` datetime DEFAULT NULL COMMENT '服务开始时间',
  `service_end_time` datetime DEFAULT NULL COMMENT '服务结束时间',
  `is_finish` tinyint(1) DEFAULT '0' COMMENT '是否结束 0.未结束 1.已结束',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='上门服务登记采集';

-- ----------------------------
-- Table structure for t_door_doctor
-- ----------------------------
DROP TABLE IF EXISTS `t_door_doctor`;
CREATE TABLE `t_door_doctor` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `staff_index` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职工索引号',
  `staff_code` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职工工号',
  `staff_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职工姓名',
  `team_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '基层团队id',
  `team_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '基层团队name',
  `dept_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属科室代码',
  `dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属科室名称',
  `pinyin_code` varchar(25) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拼音码',
  `disabled` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `id_card` varchar(18) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '身份证号',
  `sex_code` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别代码(1:男 2:女 9:其他)',
  `sex_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别名称',
  `title_code` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职称代码',
  `title_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职称名称',
  `mobile_no` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `birth_date` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '出生日期',
  `briefing` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职工简介',
  `good_desc` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '擅长描述',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `quit_flag` varchar(11) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '离职状态 (0:在职 1:离职)',
  `wechat_status` int DEFAULT NULL COMMENT '开通状态  1：开通',
  `dept_status` int DEFAULT NULL COMMENT '科室权限  1：查看科室下全部患者',
  `associated_staff_code` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联医生code',
  `associated_staff_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联医生名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_dict_staff_uq` (`staff_index`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='上门医生信息表';

-- ----------------------------
-- Table structure for t_door_doctor_range
-- ----------------------------
DROP TABLE IF EXISTS `t_door_doctor_range`;
CREATE TABLE `t_door_doctor_range` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `address_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '患者地址id',
  `doctor_team_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '医生团队id',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='医生管辖区域关联表';

-- ----------------------------
-- Table structure for t_door_doctor_team
-- ----------------------------
DROP TABLE IF EXISTS `t_door_doctor_team`;
CREATE TABLE `t_door_doctor_team` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `subject` int DEFAULT '0' COMMENT '主体 0:赤溪',
  `team_code` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '基层团队code',
  `team_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '基层团队name',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='医生团队';

-- ----------------------------
-- Table structure for t_door_pat_address
-- ----------------------------
DROP TABLE IF EXISTS `t_door_pat_address`;
CREATE TABLE `t_door_pat_address` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `street` int DEFAULT '0' COMMENT '街道 0:赤溪',
  `countryside_code` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区域code',
  `countryside_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区域name',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者地址';

-- ----------------------------
-- Table structure for t_education_record
-- ----------------------------
DROP TABLE IF EXISTS `t_education_record`;
CREATE TABLE `t_education_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主索引号',
  `relation_type` int DEFAULT NULL COMMENT '关联任务类型(1:PC/APP宣教任务 2:APP在院宣教 3:PC在院宣教 4:VIP宣教 5:宣教记录 6:专科宣教)',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任务ID',
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教类别ID',
  `category_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教类别名称',
  `education_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教ID',
  `education_title` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教标题或提醒内容',
  `education_type` int DEFAULT '1' COMMENT '任务类型(1:宣教 2:普通提醒) 默认为1',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教计划ID',
  `sender_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送人ID',
  `sender_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送人姓名',
  `sender_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送人科室代码',
  `sender_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送人科室名称',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `send_type` int DEFAULT NULL COMMENT '发送方式(1:APP/微信 2:短信 3:APP 4:微信)',
  `receiver_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人姓名',
  `mobile_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `bed_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病床号(出院/在院/转科)',
  `receiver_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人科室代码',
  `receiver_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人科室名称',
  `receiver_ward_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人病区代码',
  `receiver_ward_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接收人病区名称',
  `refer_status` int DEFAULT '0' COMMENT '查阅状态(0:未发送 -1:未读 1:已读)',
  `refer_time` datetime DEFAULT NULL COMMENT '查阅时间(最后一次查阅时间)',
  `click_count` int DEFAULT '0' COMMENT '点击率(患者查阅一次+1)',
  `send_status` int DEFAULT '0' COMMENT '宣教发送状态(0:发送成功 -1:发送失败)',
  `serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:建档 6:签约 7:入科 8:出科)\\r\\n            系统下拉表t_manage_select中取值select_id=hosp_sourceType',
  `business_time` datetime DEFAULT NULL COMMENT '业务时间',
  `ai_remind_push_status` int DEFAULT NULL COMMENT '宣教未读提醒推送状态(null 无需提醒，0 待提醒，1 已提醒，2 提醒成功，3 提醒失败)',
  `ai_remind_push_time` datetime DEFAULT NULL COMMENT 'ai宣教未读提醒推送时间',
  `ai_remind_reply_time` datetime DEFAULT NULL COMMENT 'ai宣教未读提醒回复时间',
  `call_voice_path` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '电话录音地址',
  `auto_push_ai_times` int DEFAULT '0' COMMENT '自动推送AI次数',
  `scene_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教场景id',
  `group_send_flag` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'APP调随访群发带URL的宣教 1表示群发',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `education_object` tinyint(1) DEFAULT NULL COMMENT '宣教对象 1:患者 2:家属',
  `is_praise` tinyint DEFAULT '0' COMMENT '是否点赞 0:否 1:是',
  `is_query` tinyint DEFAULT '0' COMMENT '是否疑问 0:否 1:是',
  `query_type` tinyint DEFAULT NULL COMMENT '疑问类型',
  `no_liked_code` tinyint DEFAULT NULL COMMENT '不喜欢原因code',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_send_time` (`send_time`) USING BTREE,
  KEY `idx_hosp_code_receiver_dept_code` (`send_time`,`receiver_dept_code`) USING BTREE,
  KEY `idx_relation_id_education_id` (`relation_id`,`education_id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='宣教记录拆分表';

-- ----------------------------
-- Table structure for t_empi_info
-- ----------------------------
DROP TABLE IF EXISTS `t_empi_info`;
CREATE TABLE `t_empi_info` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `source_type` int DEFAULT NULL COMMENT '业务数据来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊)',
  `index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务数据索引号',
  `card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务数据卡号(门诊号/住院号等)',
  `serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务数据流水号(住院流水号/门诊流水号等)',
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '机构代码',
  `name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `idcard` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号',
  `sex_code` int DEFAULT NULL COMMENT '性别代码(1:男 2:女 9:其他)',
  `birthday` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出生日期',
  `address` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '家庭住址',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主索引号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `parent_empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '父主索引id',
  `hosp_no` varchar(100) DEFAULT NULL COMMENT '住院号或门诊号，以类型为准',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_empi_info_uq` (`source_type`,`serial_no`,`hosp_code`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_name` (`name`) USING BTREE,
  KEY `idx_idcard` (`idcard`) USING BTREE,
  KEY `idx_mobile_no` (`mobile_no`) USING BTREE,
  KEY `idx_serial_no` (`serial_no`) USING BTREE,
  KEY `idx_source_type` (`source_type`) USING BTREE,
  KEY `idx_hosp_code` (`hosp_code`) USING BTREE,
  KEY `idx_card_no` (`card_no`) USING BTREE,
  KEY `idx_index_no` (`index_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_empi_main
-- ----------------------------
DROP TABLE IF EXISTS `t_empi_main`;
CREATE TABLE `t_empi_main` (
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键(患者主索引号)',
  `name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '姓名',
  `idcard` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号',
  `sex_code` int DEFAULT NULL COMMENT '性别代码(1:男 2:女 9:其他)',
  `birthday` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出生日期',
  `career` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '职业',
  `nation` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '民族',
  `education` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '文化程度',
  `marital_status` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '婚姻状况',
  `work_unit` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '工作单位',
  `address_code` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '家庭住址代码',
  `address_detail` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '家庭住址详情',
  `contacts` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '联系人',
  `contacts_relation` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '联系人关系',
  `contacts_mobile` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '联系人电话',
  `death` int DEFAULT '0' COMMENT '死亡标志(0:未死亡,1:死亡)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `parent_empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '父主索引id',
  `member_card_number` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '会员卡号',
  `filing_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '建档人id',
  `filing_user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '建档人姓名',
  `filing_dept_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '建档人科室代码',
  `filing_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '建档人科室名称',
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院编码',
  PRIMARY KEY (`empi_id`) USING BTREE,
  UNIQUE KEY `idx_empi_main_uq` (`empi_id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_equip_bind
-- ----------------------------
DROP TABLE IF EXISTS `t_equip_bind`;
CREATE TABLE `t_equip_bind` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `index_no` int DEFAULT NULL COMMENT 'Index',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '患者Id',
  `pat_name` varchar(100) DEFAULT NULL COMMENT '患者姓名',
  `hosp_id` varchar(32) DEFAULT NULL COMMENT '医院id',
  `hosp_name` varchar(100) DEFAULT NULL COMMENT '医院名称',
  `equip_id` varchar(32) DEFAULT NULL COMMENT '设备id',
  `equip_name` varchar(100) DEFAULT NULL COMMENT '设备name',
  `equip_classify_id` int DEFAULT NULL COMMENT '设备类型',
  `equip_classify_name` varchar(100) DEFAULT NULL COMMENT '设备类型名称',
  `bind_addr` varchar(100) DEFAULT NULL COMMENT '设备绑定地址',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_id` varchar(32) DEFAULT NULL COMMENT '创建人Id',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `update_id` varchar(32) DEFAULT NULL COMMENT '修改人Id',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '是否删除',
  `pay_id` varchar(32) DEFAULT NULL COMMENT 'payId',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='设备绑定信息表';

-- ----------------------------
-- Table structure for t_export_pdf_cache_data
-- ----------------------------
DROP TABLE IF EXISTS `t_export_pdf_cache_data`;
CREATE TABLE `t_export_pdf_cache_data` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `last_sys_time` datetime DEFAULT NULL,
  `data_type` int DEFAULT NULL,
  `data_value` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin,
  `hosp_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_external_consult_record
-- ----------------------------
DROP TABLE IF EXISTS `t_external_consult_record`;
CREATE TABLE `t_external_consult_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '开单id',
  `mobile_no` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号码',
  `business_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务id',
  `business_type` tinyint(1) DEFAULT NULL COMMENT '咨询方式 1 图文  2 语音  3 视频  9 其它',
  `business_start_time` datetime DEFAULT NULL COMMENT '咨询开始时间',
  `business_end_time` datetime DEFAULT NULL COMMENT '咨询结束时间',
  `visit_no` varchar(36) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询编号',
  `unified_org_code` varchar(18) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医疗机构编码',
  `org_name` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医疗机构名称',
  `dept_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室编码 科室院内编码',
  `dept_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室名称 科室院内名称',
  `dept_class_code` varchar(9) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室对应诊疗科目编码',
  `dept_class_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室对应诊疗科目名称',
  `doct_idcard_no` varchar(18) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医师身份证号',
  `doct_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医师姓名',
  `staff_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工号',
  `sign_type` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '签名渠道 1：省CA签名，已完成验签联调，支持验签。 2：院内自采购签名（非采购省CA），已完成验签联调，支持验签。 0：其他，不支持验签',
  `idcard_type_code` char(2) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者就诊卡证类型 01:居民身份证  02:居民户口簿  03:护照 04:军官证 05:驾驶证 06:港澳居民来往内地通行证 07:台湾居民来往内地通行证 99:其他有效证件',
  `idcard_no` varchar(24) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者就诊卡证号码',
  `name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '姓名',
  `gender_code` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别代码 1、男，2、女 未记录男女根据国家标准可以填0或9',
  `age` int DEFAULT NULL COMMENT '年龄',
  `tel_num` varchar(11) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系电话',
  `consultation_type` char(3) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询方式 1 图文  2 语音  3 视频  9 其它',
  `onsultation_attribute` char(3) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询类别 1诊疗咨询  2报告解读  3药事咨询  4医护咨询  9其他',
  `content` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询内容',
  `apply_time` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询申请时间',
  `visit_time_start` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询开始时间',
  `visit_time_end` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询结束时间',
  `status` char(3) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询状态 -1 拒绝  0 取消  1待回复  2已回复',
  `instruction` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医师指导意见',
  `visit_price` decimal(8,2) DEFAULT NULL COMMENT '咨询价格',
  `is_send` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否发送 0否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `img_url` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '企微图片地址',
  `is_qw` tinyint(1) DEFAULT '0' COMMENT '是否企微签署 0-否 1-是',
  PRIMARY KEY (`id`),
  KEY `business_id_index` (`business_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='互联网医院监管平台';

-- ----------------------------
-- Table structure for t_external_doctor
-- ----------------------------
DROP TABLE IF EXISTS `t_external_doctor`;
CREATE TABLE `t_external_doctor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `staff_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医生姓名',
  `staff_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工号',
  `id_card` char(18) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '身份证',
  `dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '院内科室名称',
  `dept_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '院内科室代码',
  `dept_type` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '科室类型',
  `hospital_area_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属院区',
  `title_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备案职称',
  `diagnosis_name` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备案诊疗科目名称',
  `diagnosis_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备案诊疗科目编码',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认值 0.否 1.是',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `doctor_index` (`staff_name`,`staff_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3822 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='院内医生配置表';

-- ----------------------------
-- Table structure for t_external_doctor_c
-- ----------------------------
DROP TABLE IF EXISTS `t_external_doctor_c`;
CREATE TABLE `t_external_doctor_c` (
  `staff_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医生姓名',
  `staff_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工号',
  `id_card` char(18) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '身份证',
  `dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '院内科室名称',
  `dept_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '院内科室代码',
  `diagnosis_name` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备案诊疗科目名称',
  `diagnosis_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备案诊疗科目编码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='院内医生配置表';

-- ----------------------------
-- Table structure for t_external_medical_record
-- ----------------------------
DROP TABLE IF EXISTS `t_external_medical_record`;
CREATE TABLE `t_external_medical_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单id',
  `visit_no` varchar(36) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询编号',
  `idcard_type_code` char(2) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者就诊卡证类型 01:居民身份证  02:居民户口簿  03:护照 04:军官证 05:驾驶证 06:港澳居民来往内地通行证 07:台湾居民来往内地通行证 99:其他有效证件',
  `idcard_no` varchar(24) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者就诊卡证号码',
  `name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '姓名',
  `gender_code` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别代码 1、男，2、女 未记录男女根据国家标准可以填0或9',
  `birthdate` char(8) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '出生日期 yyyyMMdd',
  `subj_complaint` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主诉记录',
  `treat_meas` varchar(4000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理措施',
  `md_dis_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '西医诊断疾病代码',
  `md_dis_name` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '西医诊断疾病名称',
  `dis_description` varchar(400) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医生对门诊诊断的描述',
  `unified_org_code` varchar(18) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医疗机构编码',
  `org_name` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医疗机构名称',
  `dept_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室编码 科室院内编码',
  `dept_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室名称 科室院内名称',
  `dept_class_code` varchar(9) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室对应诊疗科目编码',
  `dept_class_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室对应诊疗科目名称',
  `doct_idcard_no` varchar(18) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医师身份证号',
  `doct_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医师姓名',
  `visit_time_start` char(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '就诊开始时间 yyyyMMdd HHmmss',
  `visit_time_end` char(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '诊断结束时间 yyyyMMdd HHmmss',
  `doct_ca_sign` varchar(4000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '就诊医师电子签名',
  `sign_type` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '签名渠道 1：省 CA 签名，已完成验签联调，支持验签 2：院内自采购签名（非采购省 CA），已完成验签联调，支持验签 0：其他，不支持验签。',
  `review_url` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '诊疗过程调阅地址',
  `first_visit_record_json` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '线下初诊记录',
  `is_send` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否发送 0否 1是',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `pay_id_index` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='互联网医院就诊记录';

-- ----------------------------
-- Table structure for t_external_register_record
-- ----------------------------
DROP TABLE IF EXISTS `t_external_register_record`;
CREATE TABLE `t_external_register_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单id',
  `inhosp_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '住院号',
  `visit_no` varchar(36) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询编号',
  `idcard_type_code` char(2) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者就诊卡证类型 01:居民身份证  02:居民户口簿  03:护照 04:军官证 05:驾驶证 06:港澳居民来往内地通行证 07:台湾居民来往内地通行证 99:其他有效证件',
  `idcard_no` varchar(24) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者就诊卡证号码',
  `name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '姓名',
  `gender_code` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别代码 1、男，2、女 未记录男女根据国家标准可以填0或9',
  `birthdate` char(8) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '出生日期 yyyyMMdd',
  `unified_org_code` varchar(18) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医疗机构编码',
  `org_name` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医疗机构名称',
  `dept_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室编码 科室院内编码',
  `dept_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室名称 科室院内名称',
  `dept_class_code` varchar(9) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室对应诊疗科目编码',
  `dept_class_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询科室对应诊疗科目名称',
  `doct_idcard_no` varchar(18) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医师身份证号',
  `doct_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询医师姓名',
  `if_expert` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否挂专家号 0、否，1、是',
  `visit_date` char(8) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '预约就诊日期 yyyyMMdd',
  `visit_time` char(6) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '预约就诊时间 HHmmss',
  `visit_type` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '挂号类别 1、 复诊挂号， 2、医师咨询挂号， 3、药师咨询挂号 未填挂号类别，默认为复诊挂号',
  `examin_fee` decimal(10,2) DEFAULT NULL COMMENT '挂号费用 免费填 0',
  `record_date_time` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '挂号时间 yyyyMMdd HHmmss',
  `visit_type_code` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '看诊方式 1 图文 2 语音 3 视频 9 其它',
  `is_send` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否发送 0否 1是',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `pay_id_index` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='互联网医院线上复诊、咨询挂号';

-- ----------------------------
-- Table structure for t_faq_question
-- ----------------------------
DROP TABLE IF EXISTS `t_faq_question`;
CREATE TABLE `t_faq_question` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `question_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '问题标题',
  `hosp_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医院名称',
  `answer` text COLLATE utf8mb4_general_ci COMMENT '答案',
  `editor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改者',
  `create_time` datetime NOT NULL DEFAULT (now()) COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_question` (`question_title`(9)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1020012 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for t_form_update_record
-- ----------------------------
DROP TABLE IF EXISTS `t_form_update_record`;
CREATE TABLE `t_form_update_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引',
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访医院编码',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `user_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人',
  `fill_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '填写来源 0 随访医院端 1 移动端患者自填 2 AI 填充',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访表单id',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单关联id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单修改流水记录表';

-- ----------------------------
-- Table structure for t_form_update_record_answer
-- ----------------------------
DROP TABLE IF EXISTS `t_form_update_record_answer`;
CREATE TABLE `t_form_update_record_answer` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联表单ID(表t_repository_form的主键)',
  `relation_type` int DEFAULT NULL COMMENT '关联任务类型(1:随访任务 2:随访记录 3:满意度任务 4:VIP任务 5:满意度记录 6:APP在院满意度调查 7:随访抽查 8:专科随访 9:专科建档 99:妇幼那边提交的答案)',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任务ID',
  `question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联题目ID',
  `question_answer` varchar(10000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '题目答案(选项ID或者文本内容)',
  `other_content` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '其他项文本内容',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `quote_question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '引用题目ID(题库单题表主键ID)',
  `quote_question_answer` varchar(5000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '引用题目答案',
  `answer_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '答案编码 字典表匹配',
  `answer_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '答案名称 字典表匹配',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_relation_id_question_id` (`relation_id`,`question_id`) USING BTREE,
  KEY `idx_relation_id_form_id` (`relation_id`,`form_id`) USING BTREE,
  KEY `question_id` (`question_id`) USING BTREE,
  KEY `form_id` (`form_id`) USING BTREE,
  KEY `update_time` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单修改流水记录答案表';

-- ----------------------------
-- Table structure for t_global_id
-- ----------------------------
DROP TABLE IF EXISTS `t_global_id`;
CREATE TABLE `t_global_id` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `server_sequence` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务器序列',
  `prefixion` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '前缀字母',
  `curr_no` bigint DEFAULT NULL COMMENT '当前所用的序号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_abnormal_mission_question
-- ----------------------------
DROP TABLE IF EXISTS `t_h_abnormal_mission_question`;
CREATE TABLE `t_h_abnormal_mission_question` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `sort` tinyint DEFAULT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_h_abnormal_mission_question_mission_id_IDX` (`mission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_ai_auto_fill
-- ----------------------------
DROP TABLE IF EXISTS `t_h_ai_auto_fill`;
CREATE TABLE `t_h_ai_auto_fill` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `goods_version_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `goods_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `goods_name` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `match_product_name` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `timing_date` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `new_goods_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `new_goods_name` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `editor_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_h_ai_auto_fill_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动填充记录表';

-- ----------------------------
-- Table structure for t_h_ai_pre_call
-- ----------------------------
DROP TABLE IF EXISTS `t_h_ai_pre_call`;
CREATE TABLE `t_h_ai_pre_call` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '随访任务id',
  `push_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '推送日期',
  `period` tinyint NOT NULL COMMENT '时间段（1：上午，2：下午）',
  `call_status` int DEFAULT '1' COMMENT 'AI推送状态(1:未推送 2:已推送 3:呼叫成功 4:呼叫失败)',
  `call_time` datetime DEFAULT NULL COMMENT '呼叫时间',
  `voice_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '呼叫录音',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `answer` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者答复（上午/下午）',
  `hosp_code` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='ai预外呼记录表';

-- ----------------------------
-- Table structure for t_h_ai_remind_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_ai_remind_record`;
CREATE TABLE `t_h_ai_remind_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '任务',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '拨打内容',
  `result` int DEFAULT NULL COMMENT '任务结果,0表示成功,1表示失败',
  `record_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '录音地址，如果通话成功，则返回地址',
  `call_status` int DEFAULT NULL COMMENT '外呼结果, 0 正常结束AI挂机1 拨打失败2 通话中3 正常结束患者挂机4 无人接听5 空号6 关机',
  `call_time` datetime DEFAULT NULL COMMENT '外呼时间 ',
  `call_length` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '外呼时长，单位 秒',
  `create_time` datetime DEFAULT NULL,
  `ai_plan_time` datetime DEFAULT NULL COMMENT '计划拨打时间',
  `phone` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_ai_serve_verify
-- ----------------------------
DROP TABLE IF EXISTS `t_h_ai_serve_verify`;
CREATE TABLE `t_h_ai_serve_verify` (
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '开单id',
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `editor_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `editor_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `verify_point` tinyint DEFAULT NULL COMMENT '1:随访页面 2:企微页面',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ai模型收案核对表';

-- ----------------------------
-- Table structure for t_h_ai_task_statistics
-- ----------------------------
DROP TABLE IF EXISTS `t_h_ai_task_statistics`;
CREATE TABLE `t_h_ai_task_statistics` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `account` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '账号',
  `user_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户名称',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务的id',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单的id',
  `form_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单的名称',
  `ai_push_time` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推送时间',
  `is_delete` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '删除标记 0正常 1、删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_ai_voice_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_ai_voice_record`;
CREATE TABLE `t_h_ai_voice_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `relation_type` int DEFAULT NULL COMMENT '关联任务类型(1:随访任务 2:随访记录 3:满意度任务 4:VIP任务 5:满意度记录 6:APP在院满意度调查 7:随访抽查 8:专科随访 9:专科建档 99:妇幼那边提交的答案)',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任务ID',
  `voice_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ai任务ID',
  `voice_url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '录音地址',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_relation_id` (`relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='ai录音记录表';

-- ----------------------------
-- Table structure for t_h_alarm_task
-- ----------------------------
DROP TABLE IF EXISTS `t_h_alarm_task`;
CREATE TABLE `t_h_alarm_task` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `type` int DEFAULT NULL,
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `manage_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pat_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `project_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deal` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理状态 1待处理 2处理完成。',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `hosp_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hosp_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `goods_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `goods_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `descr` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `empi_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pay_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mobile_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `doc_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ai_advice` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AI建议',
  `temporary_status` int DEFAULT NULL,
  `project_picture_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目图片地址',
  `occur_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发生时间',
  `note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `no_deal_flag` int DEFAULT NULL,
  `deal_type_code` int DEFAULT NULL COMMENT '处理结果类型编码',
  `deal_type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理结果类型名称',
  `service_note` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `doc_deal` int DEFAULT '1',
  `notify_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第三方服务回调id',
  `equip_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '设备id',
  `alarm_code` tinyint DEFAULT '99' COMMENT '异常code',
  `alarm_desc` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_alarm_task1
-- ----------------------------
DROP TABLE IF EXISTS `t_h_alarm_task1`;
CREATE TABLE `t_h_alarm_task1` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `type` int DEFAULT NULL,
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `manage_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pat_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `project_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deal` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理状态 1待处理 2处理完成。',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `hosp_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hosp_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `goods_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `goods_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `descr` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `empi_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pay_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mobile_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `doc_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ai_advice` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AI建议',
  `temporary_status` int DEFAULT NULL,
  `project_picture_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目图片地址',
  `occur_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发生时间',
  `note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `no_deal_flag` int DEFAULT NULL,
  `deal_type_code` int DEFAULT NULL COMMENT '处理结果类型编码',
  `deal_type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理结果类型名称',
  `service_note` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_archive_analysis
-- ----------------------------
DROP TABLE IF EXISTS `t_h_archive_analysis`;
CREATE TABLE `t_h_archive_analysis` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_general_ci COMMENT '表单内容',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `protein` int DEFAULT NULL COMMENT '蛋白质占比',
  `fat` int DEFAULT NULL COMMENT '脂肪占比',
  `carbohydrates` int DEFAULT NULL COMMENT '碳水占比',
  `update_time` datetime DEFAULT NULL,
  `total_energy` int DEFAULT NULL COMMENT '总能量',
  `label` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `message_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '消息id',
  `summary` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '摘要',
  `summary_message_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '摘要消息id',
  PRIMARY KEY (`id`),
  KEY `t_h_archive_analysis_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `t_h_archive_analysis_empi_id_IDX` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='减重专病档案成分分析表';

-- ----------------------------
-- Table structure for t_h_assessment_management_task
-- ----------------------------
DROP TABLE IF EXISTS `t_h_assessment_management_task`;
CREATE TABLE `t_h_assessment_management_task` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pat_id` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '数据中心patId',
  `empi_id` varchar(40) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'empiId',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '单子id',
  `hosp_code` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者姓名',
  `task_date` date NOT NULL COMMENT '任务日期',
  `deal_status` tinyint DEFAULT '0' COMMENT '任务状态 1-已知晓',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `relation_id` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联id(t_patient_nut_science表id)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='智能评估任务表';

-- ----------------------------
-- Table structure for t_h_associated_doctor_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_associated_doctor_relation`;
CREATE TABLE `t_h_associated_doctor_relation` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `doctor_id` varchar(32) DEFAULT NULL COMMENT '医生id',
  `associated_doctor_id` varchar(32) DEFAULT NULL COMMENT '关联医生id',
  `associated_doctor_code` varchar(32) DEFAULT NULL COMMENT '关联医生编号',
  `associated_doctor_name` varchar(32) DEFAULT NULL COMMENT '关联医生名称',
  `associated_dept_code` varchar(32) DEFAULT NULL COMMENT '关联科室编号',
  `associated_dept_name` varchar(32) DEFAULT NULL COMMENT '关联科室名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `t_h_associated_doctor_relation_doctor_id_IDX` (`doctor_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_auto_send_config
-- ----------------------------
DROP TABLE IF EXISTS `t_h_auto_send_config`;
CREATE TABLE `t_h_auto_send_config` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院编码',
  `hosp_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院名称',
  `send_type` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送类型(1, 随访任务;2, 宣教任务,3, 提醒任务),多个,隔开',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `hosp_code_index` (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='自动发送配置表(未配置全部发送)';

-- ----------------------------
-- Table structure for t_h_basic_information_htm
-- ----------------------------
DROP TABLE IF EXISTS `t_h_basic_information_htm`;
CREATE TABLE `t_h_basic_information_htm` (
  `pay_id` varchar(32) NOT NULL,
  `basic_content_html` text,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='基本资料html版';

-- ----------------------------
-- Table structure for t_h_billing_drug_name
-- ----------------------------
DROP TABLE IF EXISTS `t_h_billing_drug_name`;
CREATE TABLE `t_h_billing_drug_name` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `drug_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '药品编码',
  `drug_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '药品名称--有这些名称可以开单',
  `is_delete` int DEFAULT NULL COMMENT '0:正常 1：删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_billing_login_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_billing_login_log`;
CREATE TABLE `t_h_billing_login_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `client_ip` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `mac` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `asst_version` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `dll_version` int DEFAULT NULL,
  `his_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `his_version` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `work_number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `memo` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `login_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_call_check_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_call_check_record`;
CREATE TABLE `t_h_call_check_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `call_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '通话记录id',
  `diag_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '来电号码',
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `ip_address` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'ip地址',
  `check_times` tinyint NOT NULL COMMENT '验证次数',
  `check_result` tinyint NOT NULL COMMENT '验证结果：1-匹配到患者，2-未匹配到患者，3-验证次数超过限制',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '匹配到的患者id',
  `check_params` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '验证参数',
  `operate_time` datetime NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='来电H5校验记录表';

-- ----------------------------
-- Table structure for t_h_case_tag
-- ----------------------------
DROP TABLE IF EXISTS `t_h_case_tag`;
CREATE TABLE `t_h_case_tag` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `pay_id` varchar(32) NOT NULL COMMENT '患者开单id',
  `empi_id` varchar(32) NOT NULL COMMENT '主索引id',
  `tag_code` int NOT NULL COMMENT '分类code',
  `tag_name` varchar(30) NOT NULL COMMENT '分类名称',
  `record_time` datetime DEFAULT NULL COMMENT '记录时间',
  `hosp_code` varchar(20) NOT NULL COMMENT '医院编码',
  `relation_type` int NOT NULL COMMENT '关联类型',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联id',
  `user_id` varchar(32) NOT NULL COMMENT '用户id',
  `user_name` varchar(20) NOT NULL COMMENT '用户名',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pay_id` (`pay_id`),
  KEY `idx_empi_id` (`empi_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='案例记录';

-- ----------------------------
-- Table structure for t_h_channel_auth_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_channel_auth_record`;
CREATE TABLE `t_h_channel_auth_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `pat_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '姓名',
  `mobile` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '手机号码',
  `auth_channel` tinyint DEFAULT NULL COMMENT '授权渠道 1-企微 2-短信',
  `auth_time` datetime DEFAULT NULL COMMENT '授权时间',
  `is_match_success` tinyint(1) DEFAULT '0' COMMENT '是否匹配成功 1-匹配成功 0-否',
  `match_time` datetime DEFAULT NULL COMMENT '匹配时间',
  `sync_health` tinyint(1) DEFAULT '0' COMMENT '是否已同步至健管云 1-是 0-否',
  `editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `hosp_code` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `dr_code` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者渠道授权记录表';

-- ----------------------------
-- Table structure for t_h_charge_item
-- ----------------------------
DROP TABLE IF EXISTS `t_h_charge_item`;
CREATE TABLE `t_h_charge_item` (
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '缴费金额',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `is_charge` tinyint DEFAULT '1' COMMENT '是否收费 1:云端收费',
  `item_desc` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '项目说明',
  `item_presentation` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '项目介绍',
  `item_content` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '项目内容',
  `item_pic_url` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包照片',
  `link_app` tinyint DEFAULT '1' COMMENT '是否需要跳转小程序 0 不需要 1需要',
  `title_pic_url` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标题图片地址',
  `content_pic_url` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '内容图片地址',
  `dept_code` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室代码 100:产科 200:妇科 300:心内科',
  `dept_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室名称',
  `allotted_time` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `sort` int DEFAULT '0',
  PRIMARY KEY (`charge_item_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='科室名称';

-- ----------------------------
-- Table structure for t_h_chemotherapy_manage
-- ----------------------------
DROP TABLE IF EXISTS `t_h_chemotherapy_manage`;
CREATE TABLE `t_h_chemotherapy_manage` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单id',
  `manage_start_date` datetime DEFAULT NULL COMMENT '管理开始时间',
  `manage_days` int DEFAULT NULL COMMENT '周期',
  `main_manage_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主方案id',
  `main_manage_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主方案name',
  `main_manage_date` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `secondary_manage_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '辅助方案id',
  `secondary_manage_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '辅助方案name',
  `secondary_manage_date` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '次方案时间，逗号隔开',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `is_end` int DEFAULT '0' COMMENT '是否结束',
  `surgery_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术code',
  `surgery_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术名称',
  `is_drainage_tube` tinyint(1) DEFAULT '0' COMMENT '是否带引流管',
  `is_secondary_manage` tinyint(1) DEFAULT '0' COMMENT '是否存在辅助方案',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组名称',
  `end_type` int DEFAULT '0' COMMENT '结束类型 1：正常结案 2：中途退出',
  `end_remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结束备注',
  `doctor_codes` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '管理医生编号（多个逗号分隔）',
  `doctor_names` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '管理医生姓名（多个逗号分隔）',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品 id',
  `goods_name` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_class_stage
-- ----------------------------
DROP TABLE IF EXISTS `t_h_class_stage`;
CREATE TABLE `t_h_class_stage` (
  `stage_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '分类阶段编码',
  `stage_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分类表述',
  `common_words` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '常用语',
  `level` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分类级别',
  `is_delete` int DEFAULT NULL,
  `score` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '评分',
  PRIMARY KEY (`stage_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_close_summary
-- ----------------------------
DROP TABLE IF EXISTS `t_h_close_summary`;
CREATE TABLE `t_h_close_summary` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '结案小结主键',
  `pay_ids` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务单主键,逗号隔开',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引号',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `first_text` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开头',
  `first_html` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '开头html',
  `index_json` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '指标项json',
  `end_text` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结尾',
  `end_html` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '结尾html',
  `short_url_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '短链接id',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品 id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `empi` (`empi_id`) USING BTREE,
  KEY `pay` (`pay_ids`) USING BTREE,
  KEY `plan` (`plan_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_close_summary_tpl
-- ----------------------------
DROP TABLE IF EXISTS `t_h_close_summary_tpl`;
CREATE TABLE `t_h_close_summary_tpl` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `tpl_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `tpl_content` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模板内容',
  `create_by` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='结案小结模板表';

-- ----------------------------
-- Table structure for t_h_closing_reason
-- ----------------------------
DROP TABLE IF EXISTS `t_h_closing_reason`;
CREATE TABLE `t_h_closing_reason` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `count_reference` int(1) unsigned zerofill NOT NULL DEFAULT '0' COMMENT '原因使用次数',
  `reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '' COMMENT '结案原因',
  `is_delete` tinyint(1) unsigned zerofill NOT NULL DEFAULT '0' COMMENT '是否可删除 ： 0 否   1是   默认 0',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `type` tinyint(1) DEFAULT NULL COMMENT '0 正常结案   1 中途退出',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_reason` (`reason`) USING BTREE,
  KEY `idx_count` (`count_reference`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='结案原因表';

-- ----------------------------
-- Table structure for t_h_cluster_auto_serve
-- ----------------------------
DROP TABLE IF EXISTS `t_h_cluster_auto_serve`;
CREATE TABLE `t_h_cluster_auto_serve` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `product_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品ID',
  `product_title` varchar(60) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品名称',
  `cluster_ids` varchar(320) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分群',
  `cluster_names` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `auto_send_flag` tinyint DEFAULT NULL COMMENT '患者自动发送标识',
  `serve_day_type` tinyint DEFAULT NULL COMMENT '服务期限 0:默认 1:自定义',
  `serve_day` int DEFAULT NULL COMMENT '服务天数',
  `diag_codes` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者诊断勾选',
  `record_model_type` tinyint DEFAULT NULL COMMENT '0.非通用模板，1.通用模板,2:pio通用',
  `diag_teach_form_check` tinyint DEFAULT NULL COMMENT '疾病教练问卷 0:默认关联 1:自定义',
  `diag_teach_form_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `diag_teach_form_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pipeline_check` tinyint DEFAULT NULL COMMENT '管道0:不管理 1:管理',
  `drug_check` tinyint DEFAULT NULL COMMENT '药品0:不管理 1:管理',
  `blood_sugar_check` tinyint DEFAULT NULL COMMENT '血糖0:不管理 1:管理',
  `blood_pressure_check` tinyint DEFAULT NULL COMMENT '血压0:不管理 1:管理',
  `weight_check` tinyint DEFAULT NULL COMMENT '体重0:不管理 1:管理',
  `heart_rate_check` tinyint DEFAULT NULL COMMENT '心率0:不管理 1:管理',
  `referral_check` tinyint DEFAULT NULL COMMENT '复诊0:不管理 1:管理',
  `after_begin_time` tinyint DEFAULT NULL COMMENT '出院后X天',
  `manage_user_json` varchar(2048) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理人员',
  `team_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分组名称',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL,
  `editor_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `editor_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `patient_count` int DEFAULT NULL,
  `serve_mode` tinyint DEFAULT NULL COMMENT '1:普通模式 2:ai模式',
  `team_rule_type` tinyint DEFAULT NULL COMMENT '分组规则 1:指定 2:按产品入组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='分群自动收案';

-- ----------------------------
-- Table structure for t_h_coach_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `t_h_coach_knowledge`;
CREATE TABLE `t_h_coach_knowledge` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '知识库名称',
  `form_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'PIO 问卷 id',
  `form_title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'PIO 问卷名称',
  `product_id` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用产品 id',
  `product_title` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用产品名称',
  `diag_code` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '适用疾病',
  `diag_name` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '适用疾病名称',
  `status` tinyint DEFAULT '0' COMMENT '0.未发布，1.已发布',
  `reference_count` int DEFAULT '0' COMMENT '引用次数',
  `is_delete` tinyint DEFAULT '0' COMMENT '0.正常，1.删除',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人 id',
  `creator_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `editor_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人 id',
  `editor_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='健康教练知识库-主表';

-- ----------------------------
-- Table structure for t_h_coach_knowledge_content
-- ----------------------------
DROP TABLE IF EXISTS `t_h_coach_knowledge_content`;
CREATE TABLE `t_h_coach_knowledge_content` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `prescription_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '知识库内容表的 id',
  `knowledge_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '知识库主表 id',
  `key_point_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '关联要点表的 id',
  `key_point_title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '要点的标题',
  `education_ids` varchar(320) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联宣教 id',
  `education_names` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联宣教名称',
  `concrete_content` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '具体内容',
  `sort` tinyint DEFAULT '0' COMMENT '关联要点顺序',
  `is_delete` tinyint DEFAULT '0' COMMENT '0.正常，1.删除',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人 id',
  `creator_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `default_use` int DEFAULT '1' COMMENT '是否默认使用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='健康教练知识库-关联要点和具体知识表';

-- ----------------------------
-- Table structure for t_h_coach_knowledge_key_point
-- ----------------------------
DROP TABLE IF EXISTS `t_h_coach_knowledge_key_point`;
CREATE TABLE `t_h_coach_knowledge_key_point` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `label_code` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签编码',
  `label_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名称',
  `is_delete` tinyint DEFAULT NULL COMMENT '0.正常，1.删除',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人 id',
  `creator_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='健康教练知识库-要点表';

-- ----------------------------
-- Table structure for t_h_coach_knowledge_prescription
-- ----------------------------
DROP TABLE IF EXISTS `t_h_coach_knowledge_prescription`;
CREATE TABLE `t_h_coach_knowledge_prescription` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `knowledge_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主表 id',
  `label_code` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签编码',
  `label_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名称',
  `question_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '问题id',
  `question_title` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '问卷题目名称',
  `is_delete` tinyint DEFAULT '0' COMMENT '0.正常，1.删除',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人 id',
  `creator_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `content_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '问卷id',
  `content_title` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '问卷名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='健康教练知识库-内容表';

-- ----------------------------
-- Table structure for t_h_collect_template
-- ----------------------------
DROP TABLE IF EXISTS `t_h_collect_template`;
CREATE TABLE `t_h_collect_template` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `template_name` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '模板名称',
  `pack_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '路径id',
  `pack_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '路径名称',
  `quote_template_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '引用模板id',
  `content` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '收案要点',
  `is_enabled` tinyint DEFAULT '1' COMMENT '1.启用，0.停用',
  `editor_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '最新编辑人id',
  `editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '最新编辑人姓名',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '最新编辑时间',
  `creator_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '1.删除，0.未删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='收案要点模板';

-- ----------------------------
-- Table structure for t_h_common_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `t_h_common_knowledge`;
CREATE TABLE `t_h_common_knowledge` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '知识名称',
  `code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '知识编码',
  `content` text COLLATE utf8mb4_general_ci,
  `creator_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人ID',
  `creator_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `editor_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  KEY `idx_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_compliance_edit_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_compliance_edit_record`;
CREATE TABLE `t_h_compliance_edit_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人',
  `edit_reason` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑原因',
  `create_time` datetime DEFAULT NULL COMMENT '时间',
  `edit_record` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑记录',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品 id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_compliance_form_config
-- ----------------------------
DROP TABLE IF EXISTS `t_h_compliance_form_config`;
CREATE TABLE `t_h_compliance_form_config` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `order_num` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编号 000001自动递增',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单form_id',
  `form_title` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单标题',
  `form_compliance_type` int DEFAULT NULL COMMENT '表单依从性类型',
  `form_compliance_type_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单依从性类型名称',
  `question_id` varchar(2024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '题目id',
  `question_title` varchar(2024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '题目标题',
  `option_id` varchar(2024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '选项id',
  `option_name` varchar(2024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '选项名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '是否删除',
  `is_enable` int DEFAULT '1' COMMENT '是否启用 1启用,0停用',
  `edit_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人姓名',
  `edit_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人id',
  `form_source_type` tinyint DEFAULT '1' COMMENT '表单来源类型 1:教练问卷 2:医学问卷',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT=' ';

-- ----------------------------
-- Table structure for t_h_compliance_form_label
-- ----------------------------
DROP TABLE IF EXISTS `t_h_compliance_form_label`;
CREATE TABLE `t_h_compliance_form_label` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `order_num` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编号',
  `label_type` int DEFAULT NULL COMMENT '标签类型 0依从性1阶段',
  `label_value` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标签值 0完全不依从1部分依从2',
  `label_score` int DEFAULT NULL COMMENT '标签分值',
  `form_key_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单id',
  `option_dimension` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '选项维度 如ABC,0表示无需判断',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `edit_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人姓名',
  `edit_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人id',
  `is_delete` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '0' COMMENT '是否删除',
  `is_enable` int DEFAULT '1' COMMENT '1有效0无效'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT=' ';

-- ----------------------------
-- Table structure for t_h_compliance_info
-- ----------------------------
DROP TABLE IF EXISTS `t_h_compliance_info`;
CREATE TABLE `t_h_compliance_info` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `compliance_type` int DEFAULT NULL COMMENT '依从性类型 0用药1复诊2护理3饮食4运动5心理',
  `compliance_type_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '依从性类型名称',
  `compliance_info` varchar(3072) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '依从性内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `edit_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人姓名',
  `edit_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人id',
  `is_enable` int DEFAULT NULL COMMENT '开启:1 关闭:0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT=' ';

-- ----------------------------
-- Table structure for t_h_compliance_pat_label
-- ----------------------------
DROP TABLE IF EXISTS `t_h_compliance_pat_label`;
CREATE TABLE `t_h_compliance_pat_label` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'empi_id',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划id',
  `label_type` int DEFAULT NULL COMMENT '标签类型 0依从性1阶段',
  `label_value` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标签值',
  `label_score` double(2,1) DEFAULT NULL,
  `label_dimension` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标签维度 0用药1心理',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '1删除0未删除',
  `change_reason` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_bin,
  `mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务id',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品 id',
  `form_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单formId',
  `revisit_plan_time` varchar(20) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT=' ';

-- ----------------------------
-- Table structure for t_h_compliance_pay_group
-- ----------------------------
DROP TABLE IF EXISTS `t_h_compliance_pay_group`;
CREATE TABLE `t_h_compliance_pay_group` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `patient_pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单id',
  `compliance_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '依从性入组类型',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `edit_name` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人姓名',
  `edit_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人id',
  `compliance_type_flag` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '依从性选择状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT=' ';

-- ----------------------------
-- Table structure for t_h_consultation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_consultation`;
CREATE TABLE `t_h_consultation` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `pat_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者姓名',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `sex_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '身份证',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '机构代码',
  `hosp_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构名称',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院)',
  `diag_code` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `dept_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '就诊科室',
  `dept_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '就诊科室名称',
  `consultation_date` date DEFAULT NULL COMMENT '会诊日期',
  `consultation_time` time DEFAULT NULL COMMENT '会诊时间',
  `consultant_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '会诊医生',
  `consultant_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '会诊医生id',
  `file` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '文件oss url',
  `consultation_flag` int DEFAULT NULL COMMENT '会诊完结标识 1：完成',
  `consultation_summary` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '会诊总结',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `recept_treat_dr_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `recept_treat_dr_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `discharge_date` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pat_name` (`pat_name`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_deal_diag
-- ----------------------------
DROP TABLE IF EXISTS `t_h_deal_diag`;
CREATE TABLE `t_h_deal_diag` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单主键',
  `deal_flag` int DEFAULT NULL COMMENT '处理标识',
  `diag_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '诊断编码',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径名称',
  `reason` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_dept_bu_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dept_bu_relation`;
CREATE TABLE `t_h_dept_bu_relation` (
  `hosp_code` varchar(30) NOT NULL,
  `dept_name` varchar(30) NOT NULL,
  `bu_name` varchar(30) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`hosp_code`,`dept_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_dept_library_h
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dept_library_h`;
CREATE TABLE `t_h_dept_library_h` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `parent_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上级科室代码',
  `parent_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上级科室名称',
  `pinyin_code` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '拼音码',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `desc` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室描述',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `code3` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `code4` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `code7` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `hospital_area_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '院区编码',
  `build_num` int DEFAULT NULL COMMENT '楼号',
  `floor_num` int DEFAULT NULL COMMENT '楼层',
  `status` tinyint(1) DEFAULT NULL COMMENT '科室状态 0:待开科室 1:已开科室',
  `type` tinyint(1) DEFAULT NULL COMMENT '科室类型 1:门诊科室 2:住院科室 3:住院病区',
  `real_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室实际名称',
  `sort` int DEFAULT NULL COMMENT '科室排序',
  `dept_mode` tinyint(1) DEFAULT '0' COMMENT '科室运营模式 0:经典 1:赢效',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`dept_code`,`hosp_code`,`invalid_flag`) USING BTREE,
  KEY `hosp` (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_dept_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dept_relation`;
CREATE TABLE `t_h_dept_relation` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `dept_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室编码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室名称',
  `hosp_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `relation_dept_codes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联科室编码',
  `relation_dept_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联科室名称',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_diag_match_llm
-- ----------------------------
DROP TABLE IF EXISTS `t_h_diag_match_llm`;
CREATE TABLE `t_h_diag_match_llm` (
  `id` int NOT NULL AUTO_INCREMENT,
  `diag_codes` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '匹配到的疾病',
  `diag_other` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '匹配到的其他疾病',
  `hosp_code` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '医院编码',
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '患者唯一标识',
  `inhosp_serial_no` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '住院流水号',
  `workflow_run_id` varchar(36) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '匹配工作流运行ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人id',
  `update_by_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人姓名',
  `success_flag` tinyint NOT NULL DEFAULT '1' COMMENT '是否调用接口成功',
  PRIMARY KEY (`id`),
  KEY `idx_hosp_empi` (`hosp_code`,`empi_id`,`inhosp_serial_no`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='收案页面个性化饮食方案诊断信息匹配表';

-- ----------------------------
-- Table structure for t_h_diag_med_match
-- ----------------------------
DROP TABLE IF EXISTS `t_h_diag_med_match`;
CREATE TABLE `t_h_diag_med_match` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pay_id` char(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开单id',
  `empi_id` char(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `request_id` char(36) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '匹配请求描述符',
  `hosp_code` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `diagnosis` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '诊断匹配结果',
  `diagnosis_raw` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '诊断匹配原始信息',
  `with_medication` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用药匹配结果',
  `with_medication_raw` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '用药匹配原始信息',
  `response_raw` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '匹配结果原始信息',
  `success_flag` tinyint NOT NULL DEFAULT '1' COMMENT '匹配是否成功 1表示成功',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '匹配时间',
  PRIMARY KEY (`id`),
  KEY `idx_patient` (`pay_id`,`hosp_code`),
  KEY `idx_empi` (`empi_id`,`hosp_code`),
  KEY `idx_request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_dict_dept
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dict_dept`;
CREATE TABLE `t_h_dict_dept` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `parent_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上级科室代码',
  `parent_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上级科室名称',
  `pinyin_code` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '拼音码',
  `invalid_flag` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `ward_flag` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区标识(1:科室 2:病区)',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_dict_dept_uq` (`hosp_code`,`dept_code`,`ward_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_dict_diagnosis
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dict_diagnosis`;
CREATE TABLE `t_h_dict_diagnosis` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `diag_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病诊断索引号',
  `diag_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病诊断代码',
  `diag_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病诊断名称',
  `pinyin_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '拼音码',
  `icd10` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'ICD-10编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_dict_hospital_area
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dict_hospital_area`;
CREATE TABLE `t_h_dict_hospital_area` (
  `hospital_area_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hospital_area_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '院区名称',
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `pinyin_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '拼音码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='拼音码';

-- ----------------------------
-- Table structure for t_h_dictionary_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dictionary_detail`;
CREATE TABLE `t_h_dictionary_detail` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `catalog_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '关联字典目录ID',
  `dictionary_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `dictionary_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '字典名称',
  `dictionary_desc` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '字典说明',
  `editor_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人姓名',
  `sort_no` int DEFAULT NULL COMMENT '排序号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `catalog` (`catalog_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='字典明细表';

-- ----------------------------
-- Table structure for t_h_dictionary_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dictionary_menu`;
CREATE TABLE `t_h_dictionary_menu` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户id',
  `menu_field_values` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `menu_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '页面 1：宣讲2：方案制定 3：退费 4到期 5任务6患者',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_dify_chat_app
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dify_chat_app`;
CREATE TABLE `t_h_dify_chat_app` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `key_word` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关键字',
  `app_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'dify应用名称',
  `app_id` varchar(28) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'dify app id',
  `dict_tag_group_id` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签类',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_ding_robot_hosp
-- ----------------------------
DROP TABLE IF EXISTS `t_h_ding_robot_hosp`;
CREATE TABLE `t_h_ding_robot_hosp` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `robot_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机器人地址',
  `feishu_robot_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `fs_land_url` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '耕地群机器人地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_ding_robot_hosp_remind
-- ----------------------------
DROP TABLE IF EXISTS `t_h_ding_robot_hosp_remind`;
CREATE TABLE `t_h_ding_robot_hosp_remind` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `robot_hosp_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `robot_model_id` int DEFAULT NULL,
  `mobile_phones` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_ding_robot_model
-- ----------------------------
DROP TABLE IF EXISTS `t_h_ding_robot_model`;
CREATE TABLE `t_h_ding_robot_model` (
  `id` int NOT NULL,
  `remind_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `remind_content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '提醒模板内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_discharge_summary_cache
-- ----------------------------
DROP TABLE IF EXISTS `t_h_discharge_summary_cache`;
CREATE TABLE `t_h_discharge_summary_cache` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者empiid',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '住院号',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '医院编码',
  `summary_file_src` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '小结文件地址',
  `summary_content` longblob COMMENT '小结内容',
  `summary_type` int NOT NULL COMMENT '小结类型 0-PDF 1-出院小结',
  `summary_cache_time` int NOT NULL COMMENT '小结缓存时长 ms',
  `is_delete` tinyint(1) NOT NULL COMMENT '是否删除（1：删除，0：未删除）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院索引号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_inhosp_no_hosp_code` (`inhosp_no`,`inhosp_serial_no`,`hosp_code`) USING BTREE,
  KEY `idx_hosp_code` (`hosp_code`) USING BTREE,
  KEY `idx_hosp_serial_no` (`inhosp_serial_no`,`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='住院索引号';

-- ----------------------------
-- Table structure for t_h_discharge_summary_cache_copy1
-- ----------------------------
DROP TABLE IF EXISTS `t_h_discharge_summary_cache_copy1`;
CREATE TABLE `t_h_discharge_summary_cache_copy1` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者empiid',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '住院号',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '医院编码',
  `summary_file_src` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '小结文件地址',
  `summary_content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '小结内容',
  `summary_type` int NOT NULL COMMENT '小结类型 0-PDF 1-出院小结',
  `summary_cache_time` int NOT NULL COMMENT '小结缓存时长 ms',
  `is_delete` tinyint(1) NOT NULL COMMENT '是否删除（1：删除，0：未删除）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院索引号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_inhosp_no_hosp_code` (`inhosp_no`,`inhosp_serial_no`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='住院索引号';

-- ----------------------------
-- Table structure for t_h_discharge_summary_disassemble
-- ----------------------------
DROP TABLE IF EXISTS `t_h_discharge_summary_disassemble`;
CREATE TABLE `t_h_discharge_summary_disassemble` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者empiid',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '医院编码',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院索引号',
  `summary_diagnosis` varchar(4096) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院诊断',
  `summary_inspect` varchar(4096) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院相关检查数值',
  `summary_medication` varchar(4096) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '目前用药',
  `summary_attention` varchar(4096) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '注意事项',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='出院小结拆解表';

-- ----------------------------
-- Table structure for t_h_discharge_summary_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_discharge_summary_log`;
CREATE TABLE `t_h_discharge_summary_log` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `user_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户id',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户名称',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '医院编码',
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者empiid',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院号',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院索引号',
  `is_cache` tinyint(1) NOT NULL COMMENT '是否缓存（1：缓存，0：未缓存）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_disease_archives
-- ----------------------------
DROP TABLE IF EXISTS `t_h_disease_archives`;
CREATE TABLE `t_h_disease_archives` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单的id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引',
  `package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id（服务包id或者路径id）',
  `prescription_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处方的id;处方服务id',
  `prescription_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处方名称',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单的id;专病档案表单id',
  `form_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单的名称;表单的名称',
  `form_json` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '表单内容;表单内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `is_delete` int DEFAULT NULL COMMENT '删除标记;0、正常；1、删除',
  `form_cloud_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单主键id',
  `form_version` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单版本号',
  `sort` int DEFAULT NULL,
  `is_need_patient` tinyint(1) DEFAULT NULL COMMENT '是否使用患者填写',
  `diagnosis_type` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '诊断类型：普通版 regular, 高血压版 hypertension,糖尿病版 diabetes,人流、产后版 abortionPostpartum,饮食建议版 dietAdvice;',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务id',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品 id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='是否患者填写 1：是';

-- ----------------------------
-- Table structure for t_h_disease_archives_answer
-- ----------------------------
DROP TABLE IF EXISTS `t_h_disease_archives_answer`;
CREATE TABLE `t_h_disease_archives_answer` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `archives_relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '专病档案关联id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单的id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引号',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单的formid',
  `form_answer` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '表单答案json',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `is_delete` int DEFAULT NULL COMMENT '1:删除',
  `form_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单的名称;表单的名称',
  `update_time` datetime DEFAULT NULL,
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务id',
  `question_score` double(8,2) DEFAULT NULL COMMENT '分数',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pay` (`archives_relation_id`,`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='专病档案答案表';

-- ----------------------------
-- Table structure for t_h_disease_bu_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_disease_bu_relation`;
CREATE TABLE `t_h_disease_bu_relation` (
  `disease_code` varchar(50) NOT NULL,
  `disease_name` varchar(100) DEFAULT NULL,
  `bu_name` varchar(100) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`disease_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_disease_diagnosis
-- ----------------------------
DROP TABLE IF EXISTS `t_h_disease_diagnosis`;
CREATE TABLE `t_h_disease_diagnosis` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已删除 0 否  1是',
  `create_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '医院编码',
  `diagnose_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '疾病诊断编码',
  `diagnose_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '疾病诊断名称',
  `is_exclude` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否排除 0否 1 是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_hospcode` (`hosp_code`) USING BTREE,
  KEY `idx_diagnose_name` (`diagnose_name`(8)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29347 DEFAULT CHARSET=utf8mb3 COMMENT='疾病诊断表';

-- ----------------------------
-- Table structure for t_h_doctor
-- ----------------------------
DROP TABLE IF EXISTS `t_h_doctor`;
CREATE TABLE `t_h_doctor` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `staff_index` varchar(50) DEFAULT NULL COMMENT '职工索引号',
  `staff_code` varchar(50) DEFAULT NULL COMMENT '职工工号',
  `staff_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '职工姓名',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属科室名称',
  `pinyin_code` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '拼音码',
  `disabled` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `id_card` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号',
  `sex_code` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别代码(1:男 2:女 9:其他)',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `title_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '职称代码',
  `title_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '职称名称',
  `mobile_no` varchar(15) CHARACTER SET ujis COLLATE ujis_japanese_ci DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '邮箱',
  `birth_date` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出生日期',
  `briefing` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '职工简介',
  `good_desc` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '擅长描述',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `quit_flag` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '离职状态 (0:在职 1:离职)',
  `wechat_status` int DEFAULT NULL COMMENT '开通状态  1：开通',
  `dept_status` int DEFAULT NULL COMMENT '科室权限  1：查看科室下全部患者',
  `associated_staff_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联医生code',
  `associated_staff_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联医生名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `business_permission_code` varchar(100) DEFAULT NULL,
  `business_permission_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_dict_staff_uq` (`staff_index`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_doctor_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_h_doctor_detail`;
CREATE TABLE `t_h_doctor_detail` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `doctor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'doctor表id',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属科室名称',
  `dept_status` int DEFAULT NULL COMMENT '科室权限  1：查看科室下全部患者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `doctor_id_key` (`doctor_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='医生科室详情';

-- ----------------------------
-- Table structure for t_h_dr_auto_confirm
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dr_auto_confirm`;
CREATE TABLE `t_h_dr_auto_confirm` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '机构代码',
  `dr_code` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '医生代码',
  `confirm_type` tinyint NOT NULL COMMENT '确认类型 1:路径确认2:结案确认',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='医生设置自动确认表';

-- ----------------------------
-- Table structure for t_h_dr_pat_comment
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dr_pat_comment`;
CREATE TABLE `t_h_dr_pat_comment` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `empi_id` varchar(32) NOT NULL COMMENT '患者主索引',
  `dr_code` varchar(50) NOT NULL COMMENT '医生工号',
  `hosp_code` varchar(50) NOT NULL COMMENT '机构代码',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '开单主键',
  `content` varchar(500) NOT NULL COMMENT '点评内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `t_h_dr_pat_comment__idx` (`empi_id`,`dr_code`,`hosp_code`,`create_time`) COMMENT '患者主索引+医生工号+机构代码+创建时间',
  KEY `t_h_dr_pat_comment__idx_ctime` (`create_time`) COMMENT '创建时间',
  KEY `t_h_dr_pat_comment__index_dr_time` (`dr_code`,`hosp_code`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='医生对患者点评';

-- ----------------------------
-- Table structure for t_h_dr_pat_confirm
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dr_pat_confirm`;
CREATE TABLE `t_h_dr_pat_confirm` (
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '开单主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `confirm_status` int DEFAULT NULL COMMENT '确认状态  1：已确认',
  `dr_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医生工号',
  `confirm_type` tinyint NOT NULL DEFAULT '0' COMMENT '确认类型 1:路径确认',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `is_system_confirm` tinyint DEFAULT NULL COMMENT '是否系统自动确认',
  PRIMARY KEY (`pay_id`,`confirm_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_electronic_medicine
-- ----------------------------
DROP TABLE IF EXISTS `t_h_electronic_medicine`;
CREATE TABLE `t_h_electronic_medicine` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `manage_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '电子药关联id',
  `package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包的id',
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构名称',
  `hosp_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `card` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '卡号',
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '卡号密码',
  `qr_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '二维码',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `is_delete` int DEFAULT NULL COMMENT '1、删除 其他未正常',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_electronic_medicine_manage
-- ----------------------------
DROP TABLE IF EXISTS `t_h_electronic_medicine_manage`;
CREATE TABLE `t_h_electronic_medicine_manage` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包id',
  `service_package_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包名称',
  `service_supporter` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务载体',
  `service_version` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '版本',
  `channel_type_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '通道类型编码',
  `channel_type_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '通道类型名称',
  `scene_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '场景编码',
  `scene_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '场景名称',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `batch` int DEFAULT NULL COMMENT '批次',
  `allocation_count` int DEFAULT NULL COMMENT '分配数量',
  `is_delete` int DEFAULT NULL COMMENT '是否删除',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_enc_field
-- ----------------------------
DROP TABLE IF EXISTS `t_h_enc_field`;
CREATE TABLE `t_h_enc_field` (
  `id` int NOT NULL AUTO_INCREMENT,
  `statement_id` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '加密涉及mapper语句id',
  `parameter_type` tinyint NOT NULL DEFAULT '0' COMMENT '参数类型，0表示单个对象，1表示列表对象',
  `parameter_class` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参数全限定类名',
  `field_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参数字段名',
  `field_type` tinyint NOT NULL DEFAULT '0' COMMENT '0表示联系方式，1表示姓名，2表示身份证号',
  `field_name_desensitized` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '脱敏字段名',
  `field_name_enc` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '加密后字段名',
  PRIMARY KEY (`id`),
  KEY `idx_statement_id` (`statement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='加密字段表';

-- ----------------------------
-- Table structure for t_h_excel_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_excel_log`;
CREATE TABLE `t_h_excel_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `flag` int DEFAULT NULL,
  `flag_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `real_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '操作人姓名',
  `excel_params` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '导出参数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_exception_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_exception_log`;
CREATE TABLE `t_h_exception_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `exception_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '异常待办表的主键',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人id',
  `user_name` varchar(50) DEFAULT NULL COMMENT '操作人name',
  `operate_type` tinyint DEFAULT NULL COMMENT '操作类型 0:创建，1:更新',
  `operate_detail` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作详情',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='异常待办日志表';

-- ----------------------------
-- Table structure for t_h_exception_monitor_num
-- ----------------------------
DROP TABLE IF EXISTS `t_h_exception_monitor_num`;
CREATE TABLE `t_h_exception_monitor_num` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `monitor_type` tinyint DEFAULT NULL COMMENT '1:宣讲后出院超时 2收案超时 3任务未生成 ',
  `patient_count` int DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_exception_todo
-- ----------------------------
DROP TABLE IF EXISTS `t_h_exception_todo`;
CREATE TABLE `t_h_exception_todo` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `pay_order_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'pay_order表的主键',
  `order_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'pay_order表的order_id',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'pay_patients表id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院编码',
  `exception_source` tinyint DEFAULT NULL COMMENT '异常来源',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者empiId',
  `pat_name` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `phone` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号',
  `pat_status` tinyint DEFAULT NULL COMMENT '患者状态',
  `doctor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生id',
  `doctor_name` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生姓名',
  `dept_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室编码',
  `dept_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `exception_type` tinyint DEFAULT NULL COMMENT '异常类型',
  `exception_desc` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常描述',
  `exception_status` tinyint DEFAULT '1' COMMENT '异常状态',
  `solve_type` tinyint DEFAULT NULL COMMENT '处理类型',
  `solve_remarks` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '处理备注',
  `is_send` tinyint(1) DEFAULT NULL COMMENT '是否发送',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `annex` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '附件',
  `incoming_call_count` int DEFAULT '0' COMMENT '来电次数',
  `incoming_call_time` timestamp NULL DEFAULT NULL COMMENT '最新来电时间',
  `discharge_summary_lack_flag` varchar(10) DEFAULT NULL COMMENT '出院小结 缺失具体原因 1无出院小结/2内容缺失/3缺日间手术记录/4缺门诊记录',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pay_order_id` (`pay_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='异常待办表';

-- ----------------------------
-- Table structure for t_h_export_pdf
-- ----------------------------
DROP TABLE IF EXISTS `t_h_export_pdf`;
CREATE TABLE `t_h_export_pdf` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `edit_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `edit_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `empid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `export_type` int DEFAULT NULL COMMENT '0单个1批量',
  `hosp_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `service_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务项目',
  `pat_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pdf_url` varchar(300) COLLATE utf8mb3_bin DEFAULT NULL,
  `operation_type` tinyint DEFAULT '0' COMMENT '操作类型，0.下载，1.预览',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_feedback_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_feedback_record`;
CREATE TABLE `t_h_feedback_record` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `app_identify` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '标识符',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '手机号',
  `contact_mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '联系电话',
  `context` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户反馈内容',
  `desc_imgs` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '反馈图片',
  `state` tinyint(1) DEFAULT '0' COMMENT '状态 -1 :暂存 0:待处理 1:已解决(已完成)2:无法解决 3:已回复 4.超时关闭 5.未解决',
  `reply_content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '回复内容',
  `reply_time` datetime DEFAULT NULL COMMENT '回复时间',
  `is_read` tinyint(1) DEFAULT NULL COMMENT '回复内容是否已读 0:未读 1:已读',
  `user_source_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'user_source表主键',
  `source` int DEFAULT NULL COMMENT '来源 17:健管服务',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '主索引',
  `hosp_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构代码',
  `pat_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者姓名',
  `feedback_type` tinyint DEFAULT NULL COMMENT '用户反馈类型 1：反馈 2：表扬 3：投诉',
  `solved` tinyint(1) DEFAULT NULL COMMENT '0:未解决 1：已解决',
  `edit_time` datetime DEFAULT NULL COMMENT '用户编辑时间',
  `hug_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '蓝牛号',
  `reply_user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `reply_user_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `service_package_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `service_package_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  `question_describe` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '定位问题描述，逗号隔开',
  `question_category_name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '定位问题分类，逗号隔开',
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者中心id',
  `notice` tinyint DEFAULT NULL COMMENT '超时提醒(1:已提醒 0:未提醒)',
  `robot_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '海海机器人缓存内容',
  `goods_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '商品 id',
  `goods_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '商品名称',
  `primary_feedback_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '父问题id',
  `mission_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务ID',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单ID',
  `reply_content_ai` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'DIFY 返回的回复内容',
  `references_ai` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'DIFY 返回的参考内容',
  `tags_ai` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'DIFY 请求标签',
  `dify_message_id` varchar(36) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'dify返回的message_id',
  `dify_conversation_id` varchar(36) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'dify返回的conversation_id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='反馈记录表';

-- ----------------------------
-- Table structure for t_h_feedback_reply
-- ----------------------------
DROP TABLE IF EXISTS `t_h_feedback_reply`;
CREATE TABLE `t_h_feedback_reply` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `feedback_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `reply_type` tinyint DEFAULT NULL COMMENT '回复类型 0:文本',
  `reply_content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '回复内容',
  `reply_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '编辑人',
  `state` tinyint DEFAULT NULL COMMENT '-1：暂存',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='咨询回复表';

-- ----------------------------
-- Table structure for t_h_file_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_file_relation`;
CREATE TABLE `t_h_file_relation` (
  `file_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `file_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_followup_assess
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_assess`;
CREATE TABLE `t_h_followup_assess` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主索引id',
  `remind_count` int DEFAULT NULL COMMENT '提醒天数',
  `remind_unit_code` int DEFAULT NULL COMMENT '1、日 2、周 3、月 4、年',
  `remind_unit_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '名称',
  `remind_content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '提醒内容',
  `is_delete` int DEFAULT NULL COMMENT '删除标记',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `after_begin_time` int DEFAULT NULL COMMENT '距开始时间后',
  `after_begin_time_unit` int DEFAULT NULL COMMENT '时间单位(系统下拉配置表取值 1:天 2:周 3:月 4:年)',
  `after_begin_time_unit_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '时间单位名称',
  `begin_time_type` int DEFAULT NULL COMMENT '3 、出院后 31、手术  19 制定日期',
  `begin_time_type_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `timing_date` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '定时日期',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划id',
  `plan_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划名称',
  `type_code` int DEFAULT NULL COMMENT '类型编码',
  `type_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '类型名称',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_followup_expired_ai_charge_item
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_expired_ai_charge_item`;
CREATE TABLE `t_h_followup_expired_ai_charge_item` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `rule_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '规则id',
  `charge_item_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '开单项目id',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '开单项目名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_rule_id` (`rule_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='过期任务ai推送规则关联开单项目表';

-- ----------------------------
-- Table structure for t_h_followup_expired_ai_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_expired_ai_plan`;
CREATE TABLE `t_h_followup_expired_ai_plan` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `rule_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '规则id',
  `plan_id` varchar(32) DEFAULT NULL,
  `plan_name` varchar(50) DEFAULT NULL,
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品 id',
  `goods_name` varchar(32) DEFAULT NULL COMMENT '商品名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_rule_id` (`rule_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='过期任务ai推送规则关联计划表';

-- ----------------------------
-- Table structure for t_h_followup_expired_ai_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_expired_ai_rule`;
CREATE TABLE `t_h_followup_expired_ai_rule` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院编码',
  `plan_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `age_upper_limit` tinyint DEFAULT NULL COMMENT '年龄上限',
  `age_lower_limit` tinyint DEFAULT NULL COMMENT '年龄下限',
  `push_strategy` tinyint NOT NULL DEFAULT '1' COMMENT '推送策略：1-没有推送AI历史，2-有推送AI历史',
  `push_time_interval` tinyint DEFAULT NULL COMMENT '推送时间间隔',
  `push_time_unit` tinyint NOT NULL DEFAULT '1' COMMENT '推送时间单位：1-天，2-周，3-月',
  `push_start_time` timestamp NULL DEFAULT NULL COMMENT '推送开始时间',
  `push_end_time` timestamp NULL DEFAULT NULL COMMENT '推送结束时间',
  `is_pushed` tinyint NOT NULL DEFAULT '0' COMMENT '是否推送：0-未推送，1-已推送',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人名称',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `editor_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人id',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人名称',
  `pushed_count` smallint DEFAULT '0' COMMENT '已推送总数',
  `push_time` timestamp NULL DEFAULT NULL COMMENT '推送时间',
  `push_user_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推送人id',
  `push_user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推送人名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='过期任务ai推送规则表';

-- ----------------------------
-- Table structure for t_h_followup_filter
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_filter`;
CREATE TABLE `t_h_followup_filter` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划ID(专科随访计划表主键)',
  `sample_day` int DEFAULT '0' COMMENT '抽样方式(0:当天 1:前1天 2:前2天...)',
  `sample_filter` int DEFAULT NULL COMMENT '抽样筛选(1:按比例抽取 2:按数量抽取)',
  `filter_num` int DEFAULT NULL COMMENT '筛选数值,如果是按比例的该值表示百分比',
  `unrepeatable_status` int DEFAULT NULL COMMENT '不可重复入档(1:不可重复入档 0:可重复入档)',
  `unrepeatable_days` int DEFAULT NULL COMMENT '不可重复入档天数',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 10:患者管理)',
  `filter_model_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '筛选器模板ID',
  `filter_record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '筛选器记录ID',
  `dept_relate` tinyint NOT NULL DEFAULT '1' COMMENT '0不关联科室 1包含科室 2不包含科室',
  `dept_code` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码(多选","分隔 上限10个)',
  `dept_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称(多选","分隔 上限10个)',
  `ward_relate` tinyint NOT NULL DEFAULT '1' COMMENT '0不关联病区 1包含病区 2不包含病区',
  `ward_code` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区代码(多选","分隔 上限10个)',
  `ward_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区名称(多选","分隔 上限10个)',
  `crm_group_id` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者分组ID,空为未分组,all为所有(选择分组的情况下恩泽分三级分组，逗号分隔)',
  `crm_group_name` varchar(1550) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者分组名称',
  `sex_code` int DEFAULT NULL COMMENT '性别代码(1:男 2:女 9:其他)系统下拉表t_manage_select中取值select_id=mg_sex',
  `age_year_start` int DEFAULT NULL COMMENT '开始年龄-年',
  `age_month_start` int DEFAULT NULL COMMENT '开始年龄-月',
  `age_day_start` int DEFAULT NULL COMMENT '开始年龄-天',
  `age_year_end` int DEFAULT NULL COMMENT '结束年龄-年',
  `age_month_end` int DEFAULT NULL COMMENT '结束年龄-月',
  `age_day_end` int DEFAULT NULL COMMENT '结束年龄-天',
  `childbirth_status` int DEFAULT NULL COMMENT '分娩情况(1:正常 -1:异常)',
  `diagnosis_relate` int DEFAULT '0' COMMENT '诊疗情况 0不关联诊疗 1包含诊疗 2不包含诊疗',
  `diagnosis_match` tinyint(1) DEFAULT '0' COMMENT '诊疗匹配方式(0:精确匹配 1:模糊匹配)',
  `diagnosis_code` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊疗项目代码（多选，以逗号分隔）',
  `diagnosis_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊疗项目名称（多选，以逗号分隔）',
  `diag_related` int DEFAULT '0' COMMENT '疾病情况 0不关联疾病 1包含疾病 2不包含疾病',
  `diag_match` tinyint(1) DEFAULT '0' COMMENT '关联疾病匹配方式(0:精确匹配 1:模糊匹配)',
  `diag_code` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病代码(多选,分隔 上限10个)',
  `diag_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病名称(多选,分隔 上限10个)',
  `surgery_status` int DEFAULT NULL COMMENT '手术情况(1:有手术记录)',
  `surgery_match` tinyint(1) DEFAULT '0' COMMENT '手术匹配方式(0:精确匹配 1:模糊匹配)',
  `surgery_code` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术(操作)代码(多选","分隔 上限10个)',
  `surgery_name` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术名称(多选","分隔 上限10个)',
  `drug_status` int DEFAULT NULL COMMENT '用药情况(0:不关联用药  1:包含用药  2:不包含用药)',
  `drug_match` tinyint(1) DEFAULT '0' COMMENT '药品匹配方式(0:精确匹配 1:模糊匹配)',
  `drug_code` varchar(3500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '药物代码(多选,分隔 上限10个)',
  `drug_name` varchar(5000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '药物名称(多选,分隔 上限10个)',
  `company` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '工作单位',
  `first_status` int DEFAULT '0' COMMENT '第一次启动标识(0:未启动过 1:已启动过)',
  `init_status` int DEFAULT '0' COMMENT '每次启动后初始化筛选标识(0:未进行过初始化筛选 1:已完成初始化筛选)',
  `filter_date` date DEFAULT NULL COMMENT '最后筛选截止日期',
  `execute_time` datetime DEFAULT NULL COMMENT '最近一次执行时间',
  `enable_status` int DEFAULT '0' COMMENT '启用状态(0:停用 1:启用)',
  `creator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人ID',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `label_relation` int DEFAULT NULL COMMENT '标签关系(0:不关联标签  1:包含标签  2:不包含标签)',
  `label_ids` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标签代码(多选,分隔 上限30个)',
  `label_names` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标签名称(多选,分隔 上限30个)',
  `repetition_close` int DEFAULT NULL COMMENT '重复入档是否结案标识 1是 其余否',
  `changelg_close_status` int DEFAULT NULL COMMENT '标签分组变动进行结案标识（1是 其余否）',
  `start_date` varchar(21) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '筛选开始日期',
  `end_date` varchar(21) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '筛选截止日期',
  `filter_mobile` tinyint DEFAULT '0' COMMENT '仅筛选有联系方式的患者（1是 0否）',
  `mobile_code` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '号码过滤方式',
  `exclude_filter_list` tinyint DEFAULT '1' COMMENT '排除过滤名单内患者（1，是  0，否）',
  `gps_flag` tinyint DEFAULT NULL COMMENT '是否GPS过滤（1，是  0，否）',
  `nrs_type` tinyint DEFAULT NULL COMMENT '筛选nrs评分类型（1，大于等于3分 2，小于3分）',
  `tpn_flag` tinyint DEFAULT '0' COMMENT 'TPN医嘱过滤标志 1过滤，0不过滤',
  `is_spare` tinyint(1) DEFAULT '0' COMMENT '是否是备选队列 1：是 0：否',
  `expired_mission_flag` tinyint DEFAULT NULL COMMENT '过期任务不自动生成（1：是，0否）',
  `address_status` int DEFAULT NULL COMMENT '地址情况(0不关联 1包含手术 2不包含手术)',
  `address_match` tinyint DEFAULT '0' COMMENT '地址匹配方式(0:精确匹配 1:模糊匹配)',
  `address_code` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '地址代码(多选","分隔 上限10个)',
  `address_name` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '地址名称(多选","分隔 上限10个)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_plan_id` (`plan_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专科随访自动筛选配置表';

-- ----------------------------
-- Table structure for t_h_followup_job
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_job`;
CREATE TABLE `t_h_followup_job` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划ID(专科随访计划表主键)',
  `send_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送时间段(多选'',''分隔 例如9,15,21; 0:表示立即发送)',
  `send_over_task` int DEFAULT '0' COMMENT '过期任务自动发送(0:否 1:是)',
  `auto_complete_task` int DEFAULT '0' COMMENT '无异常任务自动关闭(0:否 1:是)',
  `enable_status` int DEFAULT '0' COMMENT '启用状态(0:停用 1:启用)',
  `creator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人ID',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `except_remind` int DEFAULT '0' COMMENT '异常短信提醒(0否, 1是)',
  `remind_mobile` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常提醒号码,多个号码用逗号隔开',
  `auto_send_times_limit` tinyint DEFAULT NULL COMMENT '自动发送次数上限',
  `send_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '1' COMMENT '发送方式(1,ai语音/app/微信  2,短信)，多选逗号分隔拼接',
  `form_un_reply_remind` tinyint(1) NOT NULL DEFAULT '0' COMMENT '表单未回复AI提醒（0，否 1，是）',
  `after_send_days` tinyint DEFAULT NULL COMMENT '发送多少天后',
  `frequency` tinyint DEFAULT NULL COMMENT '频率，多久一次。',
  `frequency_count` tinyint DEFAULT NULL COMMENT '频次，执行次数',
  `remind_content` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒的内容',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_plan_id` (`plan_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专科随访自动随访配置表';

-- ----------------------------
-- Table structure for t_h_followup_mission
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_mission`;
CREATE TABLE `t_h_followup_mission` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '机构代码',
  `goods_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品ID',
  `goods_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `plan_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划ID(计划表主键)',
  `plan_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `serial_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `plan_task_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则任务ID，如果是阶段性任务,则在planTaskId后面追加--数字',
  `relation_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `relation_type` int DEFAULT NULL COMMENT '关联类型(1专科随访  2患者管理  3慢病随访  4慢病管理  5随访抽查)',
  `relation_type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联名称',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒时间',
  `revisit_plan_end_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒截止时间',
  `advance_send_time` int DEFAULT NULL COMMENT '提醒提前发送时间',
  `content_id` varchar(350) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒ID(","分隔，上限10个)',
  `content_title` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒标题(","分隔，上限10个)',
  `mission_prop` int DEFAULT NULL COMMENT '任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `mission_time_type` int DEFAULT NULL COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `mission_time_type_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务时间类型名称',
  `mission_type` int DEFAULT NULL COMMENT '任务类型(宣教: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒)',
  `mission_type_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务类型名称',
  `begin_time_type` int DEFAULT NULL COMMENT '任务开始时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后, 固定下拉字典表配置)',
  `begin_time_type_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务开始时间类型名称',
  `business_type` int DEFAULT NULL COMMENT '业务日期类型(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_type_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务日期类型名(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_date` date DEFAULT NULL COMMENT '基线日期',
  `valid_days` int DEFAULT NULL COMMENT '有效天数(天)',
  `remind_content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `plan_return_visit` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划回访方式',
  `followup_person_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员人ID',
  `followup_person_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员姓名',
  `followup_person_dept_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室代码',
  `followup_person_dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室名称',
  `return_visit_time` datetime DEFAULT NULL COMMENT '实际回访时间',
  `return_visit_type` int DEFAULT NULL COMMENT '实际回访方式(1:电话 2:APP/微信/短信)',
  `return_visit_type_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '实际回访方式名称',
  `revisit_status` int DEFAULT NULL COMMENT '随访状态(1:正常状态；2:无人接听；3:无法接通；4:关机；5:停机；6:死亡；7:家属接听(不了解情况)；8:拒绝；9:空号/电话错误；10:其他)',
  `revisit_result` int DEFAULT '0' COMMENT '随访结果(0:未完成 1:已完成 2:已结案)',
  `revisit_excp` int DEFAULT NULL COMMENT '随访结果异常标识(0:正常 1:异常)',
  `handling_opinion` varchar(1024) DEFAULT NULL,
  `app_send_status` int DEFAULT '0' COMMENT 'APP发送状态(0:未发送 -1未回复: 1:已回复)',
  `app_send_time` datetime DEFAULT NULL COMMENT 'APP发送时间',
  `app_reply_excp` int DEFAULT NULL COMMENT 'APP回复是否异常(0:否 1:是)',
  `plan_year` int DEFAULT NULL COMMENT '计划所属年份',
  `plan_month` int DEFAULT NULL COMMENT '计划所属月份',
  `followup_result` int DEFAULT NULL COMMENT '随访结果(统计)  1:电话完成 2:移动端完成 3:其他方式 （优先级：电话>移动端>其他）',
  `send_app_times` int DEFAULT '0' COMMENT '手动补发次数(记录手动发送的次数)',
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `creator_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `group_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务组块ID',
  `auto_send_times` tinyint DEFAULT '0' COMMENT '自动发送次数',
  `revisit_send_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒发送时间',
  `task_source_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务来源',
  `is_delete` int DEFAULT NULL COMMENT '1:删除',
  `sort` int DEFAULT NULL COMMENT '随访任务排序',
  `last_revisit_excp` int DEFAULT NULL COMMENT '上一次随访结果异常标识(0:正常 1:异常)',
  `referral_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复诊父id',
  `creator_source_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建来源:方案制定',
  `deal_date` datetime DEFAULT NULL,
  `ai_call_times` int DEFAULT NULL COMMENT 'ai拨打次数',
  `temporary_status` tinyint DEFAULT '0' COMMENT '0：未暂存 1：暂存',
  `is_personalise_edu` int DEFAULT NULL COMMENT '个性化宣教任务 1：是',
  `mission_categories` int DEFAULT NULL COMMENT '任务类别;1、普通随访任务（默认）；2、处方任务',
  `channel_order` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `channel_order_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `form_effective_time` int DEFAULT NULL COMMENT '表单有效时间 表单合并需要使用',
  `form_question_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单的题目的id',
  `synch_flag` int DEFAULT NULL COMMENT '1、 正常（默认）、2 需要重新同步',
  `form_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '表单答案',
  `yun_form_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '云端知识库的id',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `form_alias` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单别名',
  `form_cloud_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '云端知识库的id',
  `knowledge_task_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '知识库任务id',
  `task_target` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务对象，1.患者，2.健管师，逗号分隔',
  `track_type` tinyint DEFAULT NULL COMMENT '1.随访异常跟踪，2.咨询异常跟踪，3.预约挂号，99.其他',
  `creator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `is_merged` tinyint DEFAULT '0' COMMENT '是否被合并，0.否，1.是',
  `submit_reason_type` tinyint DEFAULT '0' COMMENT '提交原因,0.正常提交，1.下次跟踪，2.患者不配合据',
  `track_feedback_result` tinyint DEFAULT NULL COMMENT '跟踪反馈结果,1.已回院复诊/2.未回院复诊/3.无需回院复诊',
  `diet_plan_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '个性化饮食方案id',
  `send_diet_plan` tinyint(1) DEFAULT '0' COMMENT '是否发送饮食方案',
  `diet_plan_not_sent_reason` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '饮食方案未发送原因',
  `diet_plan_not_sent_reason_other` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '饮食方案未发送其他原因',
  `patient_target_status` tinyint DEFAULT NULL COMMENT '患者目标0:没有完成 1:完成目标',
  `consult_type` tinyint DEFAULT NULL COMMENT '1.协助预约挂号、2.要求退费、3.号码错误,需线下核实新号码',
  `importance_level` tinyint DEFAULT NULL COMMENT '重要程度，1.紧急(立即处理反馈)、2.中(当日处理处理反馈)、3.低(2个工作内处理反馈)',
  `consult_description` varchar(320) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询问题描述',
  `consult_result` tinyint DEFAULT '0' COMMENT '咨询任务中间流转状态结果 0.待线下处理，1.已处理，2.线上退回',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人姓名',
  `event_result` tinyint DEFAULT NULL COMMENT '事件最终结果状态，0.未解决，1.已解决',
  `consult_deal_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '最终处理详情',
  `follow_error_level` varchar(6) DEFAULT NULL COMMENT '关注的异常等级（0轻度，1中度，2重度，支持多选，必填） ',
  PRIMARY KEY (`id`),
  KEY `idx_pay_id` (`pay_id`),
  KEY `idx_empi_id_goods_id` (`empi_id`,`goods_id`),
  KEY `idx_mission_prop_plan_time` (`mission_prop`,`mission_time_type`,`revisit_result`,`revisit_plan_time`) USING BTREE,
  KEY `IDX_REFERRAL_ID` (`referral_id`),
  KEY `t_h_followup_mission_hosp_code_IDX` (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='随访任务表';

-- ----------------------------
-- Table structure for t_h_followup_mission_bak
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_mission_bak`;
CREATE TABLE `t_h_followup_mission_bak` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划ID(计划表主键)',
  `plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `plan_task_id` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '规则任务ID，如果是阶段性任务,则在planTaskId后面追加--数字',
  `relation_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `relation_type` int DEFAULT NULL COMMENT '关联类型(1专科随访  2患者管理  3慢病随访  4慢病管理  5随访抽查)',
  `relation_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联名称',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒时间',
  `revisit_plan_end_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒截止时间',
  `advance_send_time` int DEFAULT NULL COMMENT '提醒提前发送时间',
  `content_id` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒ID(","分隔，上限10个)',
  `content_title` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒标题(","分隔，上限10个)',
  `mission_prop` int DEFAULT NULL COMMENT '任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `mission_time_type` int DEFAULT NULL COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `mission_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务时间类型名称',
  `mission_type` int DEFAULT NULL COMMENT '任务类型(宣教: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒)',
  `mission_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务类型名称',
  `begin_time_type` int DEFAULT NULL COMMENT '任务开始时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后, 固定下拉字典表配置)',
  `begin_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务开始时间类型名称',
  `business_type` int DEFAULT NULL COMMENT '业务日期类型(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务日期类型名(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_date` date DEFAULT NULL COMMENT '基线日期',
  `valid_days` int DEFAULT NULL COMMENT '有效天数(天)',
  `remind_content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒内容',
  `lock_status` int DEFAULT '0' COMMENT '锁定状态(0:未被锁定 1:已被锁定)',
  `lock_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '锁定人ID',
  `lock_person_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '锁定人姓名',
  `lock_time` datetime DEFAULT NULL COMMENT '锁定时间',
  `plan_return_visit` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划回访方式',
  `form_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单说明',
  `followup_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员人ID',
  `followup_person_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员姓名',
  `followup_person_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室代码',
  `followup_person_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室名称',
  `return_visit_time` datetime DEFAULT NULL COMMENT '实际回访时间',
  `return_visit_type` int DEFAULT NULL COMMENT '实际回访方式(1:电话 2:APP/微信/短信)',
  `return_visit_type_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '实际回访方式名称',
  `revisit_status` int DEFAULT NULL COMMENT '随访状态(1:正常状态；2:无人接听；3:无法接通；4:关机；5:停机；6:死亡；7:家属接听(不了解情况)；8:拒绝；9:空号/电话错误；10:其他)',
  `revisit_result` int DEFAULT '0' COMMENT '随访结果(0:未完成 1:已完成 2:已结案)',
  `revisit_excp` int DEFAULT NULL COMMENT '随访结果异常标识(0:正常 1:异常)',
  `handling_opinion` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '处理意见',
  `app_send_status` int DEFAULT '0' COMMENT 'APP发送状态(0:未发送 -1未回复: 1:已回复)',
  `app_send_time` datetime DEFAULT NULL COMMENT 'APP发送时间',
  `app_reply_excp` int DEFAULT NULL COMMENT 'APP回复是否异常(0:否 1:是)',
  `plan_year` int DEFAULT NULL COMMENT '计划所属年份',
  `plan_month` int DEFAULT NULL COMMENT '计划所属月份',
  `followup_result` int DEFAULT NULL COMMENT '随访结果(统计)  1:电话完成 2:移动端完成 3:其他方式 （优先级：电话>移动端>其他）',
  `talk_time` int DEFAULT '0' COMMENT '通话时长(统计) 分钟',
  `followup_mode_phone` int DEFAULT '0' COMMENT '随访方式(统计) - 电话拨出次数',
  `followup_mode_app` int DEFAULT '0' COMMENT '随访方式(统计) - 发送到APP次数',
  `followup_mode_wechat` int DEFAULT '0' COMMENT '随访方式(统计) - 发送到微信次数',
  `followup_mode_sms` int DEFAULT '0' COMMENT '随访方式(统计) - 发送到短信次数',
  `send_app_times` int DEFAULT '0' COMMENT '手动补发次数(记录手动发送的次数)',
  `remark` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `close_desc` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '结案说明',
  `creator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人ID',
  `creator_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人所在科室/病区代码',
  `creator_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人所在科室/病区名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `ai_push_status` int DEFAULT '0' COMMENT 'AI推送状态(0:未推送 -1:未回复 1:已回复)',
  `ai_push_result_code` int DEFAULT NULL COMMENT 'AI推送结果状态值 0 正常, 其他 异常(具体AI系统定)',
  `ai_push_result_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI推送结果状态说明',
  `ai_push_time` datetime DEFAULT NULL COMMENT 'AI推送时间',
  `ai_push_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI推送人员ID',
  `auto_push_ai_times` int DEFAULT '0' COMMENT '自动AI推送次数',
  `manual_push_ai_times` int DEFAULT '0' COMMENT '手动AI推送次数',
  `ai_reply_time` datetime DEFAULT NULL COMMENT 'AI回复时间',
  `download_flag` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '下城区慢病随访自填下发标记 1 自填 其他下发',
  `excep_report` int DEFAULT '0' COMMENT '异常上报 0不上报 1上报',
  `push_to_cloud_flag` int DEFAULT '0' COMMENT '是否已将信息批量推给云端处理（0，否  1，是）',
  `ai_status` int DEFAULT '0' COMMENT '是否是ai任务(0否 1是)',
  `is_graded` int DEFAULT '0' COMMENT '是否由分级产生(0否，1是)',
  `graded_code` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分级编码',
  `graded_index` int DEFAULT NULL COMMENT '在一次分级中的序号',
  `followup_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '随访编号',
  `is_handled` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '是否已干预 1是 0否',
  `starting_point_flag` int DEFAULT '0' COMMENT '设置随访计划任务起点 1是起点 0不是起点',
  `enable_flag` int DEFAULT '1' COMMENT '有效标志位 0无效 1有效',
  `is_referral` tinyint DEFAULT '0' COMMENT '是否复诊（0，否  1，是）',
  `referral_dept_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊科室代码（逗号分隔拼接串）',
  `referral_plan_start_date` date DEFAULT NULL COMMENT '计划复诊有效开始时间',
  `referral_plan_date` date DEFAULT NULL COMMENT '计划复诊日期',
  `referral_plan_end_date` date DEFAULT NULL COMMENT '计划复诊有效截止时间',
  `group_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务组块ID',
  `auto_send_times` tinyint DEFAULT '0' COMMENT '自动发送次数',
  `referral_remind_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊提醒内容',
  `referral_remind_status` tinyint DEFAULT NULL COMMENT '复诊提醒结果',
  `revisit_send_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒发送时间',
  `task_source_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务来源',
  `surgery_code` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术代码(多选,分隔 上限10个)',
  `plan_time_delay_days` int DEFAULT '0' COMMENT '复诊任务计划时间因复诊确认时间变化产生的偏移天数',
  `referral_confirm_date` date DEFAULT NULL COMMENT '确认复诊日期',
  `referral_confirm_way` tinyint DEFAULT NULL COMMENT '复诊确认途径（1，系统确认  2，人工确认）',
  `is_cde_review_remind` tinyint DEFAULT NULL COMMENT '是否肺炎cde提醒任务（0，否  1，是）',
  `ai_label_codes` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ai标签编码（逗号隔开）',
  `ai_label_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ai标签名称（逗号隔开）',
  `is_delete` int DEFAULT NULL COMMENT '1:删除',
  `sort` int DEFAULT NULL COMMENT '随访任务排序',
  `last_revisit_excp` int DEFAULT NULL COMMENT '上一次随访结果异常标识(0:正常 1:异常)',
  `first_revisit_flag` int DEFAULT NULL COMMENT '首次标识',
  `referral_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊父id',
  `is_register` int DEFAULT NULL COMMENT '是否挂号',
  `creator_source_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建来源:方案制定',
  `register_date` datetime DEFAULT NULL COMMENT '挂号时间',
  `deal_date` datetime DEFAULT NULL,
  `referral_gather_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊采集说明',
  `ai_call_times` int DEFAULT NULL COMMENT 'ai拨打次数',
  `temporary_status` tinyint DEFAULT '0' COMMENT ' 1：暂存  2：未暂存',
  `is_personalise_edu` int DEFAULT NULL COMMENT '个性化宣教任务 1：是',
  `mission_categories` int DEFAULT NULL COMMENT '任务类别;1、普通随访任务（默认）；2、处方任务',
  `channel_order` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `channel_order_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `form_effective_time` int DEFAULT NULL COMMENT '表单有效时间 表单合并需要使用',
  `form_question_ids` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单的题目的id',
  `synch_flag` int DEFAULT NULL COMMENT '1、 正常（默认）、2 需要重新同步',
  `form_result` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '表单答案',
  `form_cloud_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '云端知识库的id',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `form_alias` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单别名',
  `pay_patient_type` int DEFAULT NULL COMMENT '开单患者类型',
  `score` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分数',
  `assess_result` varchar(3000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  `is_finally` tinyint DEFAULT '0' COMMENT '是否最后一条任务（1是2否0待定）',
  `cycle_num` tinyint DEFAULT '0' COMMENT '循环次数',
  `knowledge_task_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '知识库任务id',
  `yun_form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `task_target` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务对象，1.患者，2.健管师，逗号分隔',
  `track_type` tinyint DEFAULT NULL COMMENT '1.随访异常跟踪，2.咨询异常跟踪，3.预约挂号，99.其他',
  `team_type` tinyint DEFAULT '1' COMMENT '团队类型，1.线上履约团队，2.孵化团队',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `is_merged` tinyint DEFAULT '0' COMMENT '是否被合并，0.否，1.是',
  `ai_precall_status` tinyint DEFAULT NULL COMMENT 'AI预外呼状态(1:未推送 2:已推送 3:呼叫成功 4:呼叫失败)',
  `ai_precall_time` datetime DEFAULT NULL COMMENT 'AI预外呼时间',
  `ai_precall_label_codes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI预外呼标签id',
  `ai_precall_label_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI预外呼标签名称',
  `ai_precall_result` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI预外呼结果',
  `submit_reason_type` tinyint DEFAULT '0' COMMENT '提交原因,0.正常提交，1.下次跟踪，2.患者不配合据',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品id',
  `goods_name` varchar(50) DEFAULT NULL COMMENT '商品名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_plan_id` (`plan_id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_followup_id` (`followup_id`) USING BTREE,
  KEY `idx_revisit_plan_time` (`revisit_plan_time`) USING BTREE,
  KEY `idx_revisit_plan_end_time` (`revisit_plan_end_time`) USING BTREE,
  KEY `idx_return_visit_time` (`return_visit_time`) USING BTREE,
  KEY `idx_relation_id_revisit_plan_time` (`relation_id`,`revisit_plan_time`) USING BTREE,
  KEY `idx_followup_person` (`mission_prop`,`followup_person_id`,`revisit_result`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='循环次数';

-- ----------------------------
-- Table structure for t_h_followup_mission_business_time
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_mission_business_time`;
CREATE TABLE `t_h_followup_mission_business_time` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `pay_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `empi_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `begin_time_type` tinyint NOT NULL,
  `business_date` timestamp NULL DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='随访开单记录基线时间表';

-- ----------------------------
-- Table structure for t_h_followup_mission_consult
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_mission_consult`;
CREATE TABLE `t_h_followup_mission_consult` (
  `id` varchar(32) NOT NULL COMMENT '任务id',
  `consult_screenshot` varchar(1024) DEFAULT NULL COMMENT '咨询截图',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='咨询任务';

-- ----------------------------
-- Table structure for t_h_followup_mission_history
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_mission_history`;
CREATE TABLE `t_h_followup_mission_history` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) COLLATE utf8mb4_general_ci NOT NULL COMMENT '机构代码',
  `plan_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划ID(计划表主键)',
  `plan_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划名称',
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `serial_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `plan_task_id` varchar(36) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则任务ID，如果是阶段性任务,则在planTaskId后面追加--数字',
  `relation_id` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `relation_type` int DEFAULT NULL COMMENT '关联类型(1专科随访  2患者管理  3慢病随访  4慢病管理  5随访抽查)',
  `relation_type_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联名称',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒时间',
  `revisit_plan_end_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒截止时间',
  `advance_send_time` int DEFAULT NULL COMMENT '提醒提前发送时间',
  `content_id` varchar(350) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒ID(","分隔，上限10个)',
  `content_title` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒标题(","分隔，上限10个)',
  `mission_prop` int DEFAULT NULL COMMENT '任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `mission_time_type` int DEFAULT NULL COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `mission_time_type_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务时间类型名称',
  `mission_type` int DEFAULT NULL COMMENT '任务类型(宣教: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒)',
  `mission_type_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务类型名称',
  `begin_time_type` int DEFAULT NULL COMMENT '任务开始时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后, 固定下拉字典表配置)',
  `begin_time_type_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务开始时间类型名称',
  `business_type` int DEFAULT NULL COMMENT '业务日期类型(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_type_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务日期类型名(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_date` date DEFAULT NULL COMMENT '基线日期',
  `valid_days` int DEFAULT NULL COMMENT '有效天数(天)',
  `remind_content` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '提醒内容',
  `plan_return_visit` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划回访方式',
  `followup_person_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员人ID',
  `followup_person_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员姓名',
  `followup_person_dept_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室代码',
  `followup_person_dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室名称',
  `return_visit_time` datetime DEFAULT NULL COMMENT '实际回访时间',
  `return_visit_type` int DEFAULT NULL COMMENT '实际回访方式(1:电话 2:APP/微信/短信)',
  `return_visit_type_name` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '实际回访方式名称',
  `revisit_status` int DEFAULT NULL COMMENT '随访状态(1:正常状态；2:无人接听；3:无法接通；4:关机；5:停机；6:死亡；7:家属接听(不了解情况)；8:拒绝；9:空号/电话错误；10:其他)',
  `revisit_result` int DEFAULT '0' COMMENT '随访结果(0:未完成 1:已完成 2:已结案)',
  `revisit_excp` int DEFAULT NULL COMMENT '随访结果异常标识(0:正常 1:异常)',
  `handling_opinion` varchar(300) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理意见',
  `app_send_status` int DEFAULT '0' COMMENT 'APP发送状态(0:未发送 -1未回复: 1:已回复)',
  `app_send_time` datetime DEFAULT NULL COMMENT 'APP发送时间',
  `app_reply_excp` int DEFAULT NULL COMMENT 'APP回复是否异常(0:否 1:是)',
  `plan_year` int DEFAULT NULL COMMENT '计划所属年份',
  `plan_month` int DEFAULT NULL COMMENT '计划所属月份',
  `followup_result` int DEFAULT NULL COMMENT '随访结果(统计)  1:电话完成 2:移动端完成 3:其他方式 （优先级：电话>移动端>其他）',
  `send_app_times` int DEFAULT '0' COMMENT '手动补发次数(记录手动发送的次数)',
  `remark` varchar(300) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `creator_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `group_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务组块ID',
  `auto_send_times` tinyint DEFAULT '0' COMMENT '自动发送次数',
  `revisit_send_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒发送时间',
  `task_source_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务来源',
  `is_delete` int DEFAULT NULL COMMENT '1:删除',
  `sort` int DEFAULT NULL COMMENT '随访任务排序',
  `last_revisit_excp` int DEFAULT NULL COMMENT '上一次随访结果异常标识(0:正常 1:异常)',
  `referral_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复诊父id',
  `creator_source_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建来源:方案制定',
  `deal_date` datetime DEFAULT NULL,
  `ai_call_times` int DEFAULT NULL COMMENT 'ai拨打次数',
  `temporary_status` tinyint DEFAULT '0' COMMENT '0：未暂存 1：暂存',
  `is_personalise_edu` int DEFAULT NULL COMMENT '个性化宣教任务 1：是',
  `mission_categories` int DEFAULT NULL COMMENT '任务类别;1、普通随访任务（默认）；2、处方任务',
  `channel_order` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `channel_order_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `form_effective_time` int DEFAULT NULL COMMENT '表单有效时间 表单合并需要使用',
  `form_question_ids` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单的题目的id',
  `synch_flag` int DEFAULT NULL COMMENT '1、 正常（默认）、2 需要重新同步',
  `form_result` text COLLATE utf8mb4_general_ci COMMENT '表单答案',
  `yun_form_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '云端知识库的id',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `form_alias` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单别名',
  `form_cloud_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '云端知识库的id',
  `knowledge_task_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '知识库任务id',
  `task_target` varchar(5) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务对象，1.患者，2.健管师，逗号分隔',
  `track_type` tinyint DEFAULT NULL COMMENT '1.随访异常跟踪，2.咨询异常跟踪，3.预约挂号，99.其他',
  `creator_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `is_merged` tinyint DEFAULT '0' COMMENT '是否被合并，0.否，1.是',
  `submit_reason_type` tinyint DEFAULT '0' COMMENT '提交原因,0.正常提交，1.下次跟踪，2.患者不配合据',
  `goods_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品 id',
  `goods_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品 名称',
  `diet_plan_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '个性化饮食方案id',
  `send_diet_plan` tinyint(1) DEFAULT '0' COMMENT '是否发送饮食方案',
  `diet_plan_not_sent_reason` varchar(10) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '饮食方案未发送原因',
  `diet_plan_not_sent_reason_other` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '饮食方案未发送其他原因',
  `patient_target_status` tinyint DEFAULT NULL COMMENT '患者目标0:没有完成 1:完成目标',
  `consult_type` tinyint DEFAULT NULL COMMENT '1.协助预约挂号、2.要求退费、3.号码错误,需线下核实新号码',
  `importance_level` tinyint DEFAULT NULL COMMENT '重要程度，1.紧急(立即处理反馈)、2.中(当日处理处理反馈)、3.低(2个工作内处理反馈)',
  `consult_description` varchar(320) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询问题描述',
  `consult_result` tinyint DEFAULT '0' COMMENT '咨询任务中间流转状态结果 0.待线下处理，1.已处理，2.线上退回',
  `operator_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人姓名',
  `event_result` tinyint DEFAULT NULL COMMENT '事件最终结果状态，0.未解决，1.已解决',
  `consult_deal_detail` text COLLATE utf8mb4_general_ci COMMENT '最终处理详情',
  PRIMARY KEY (`id`),
  KEY `idx_hosp_code_plan_id` (`hosp_code`,`plan_id`),
  KEY `t_h_followup_mission_history_empi_id_IDX` (`empi_id`) USING BTREE,
  KEY `t_h_followup_mission_history_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='随访任务结案历史表（六个月以上）';

-- ----------------------------
-- Table structure for t_h_followup_mission_merge_relationship
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_mission_merge_relationship`;
CREATE TABLE `t_h_followup_mission_merge_relationship` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `old_mission_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '旧任务id',
  `new_mission_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '新任务id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='多单合并-新旧开单记录任务关联表';

-- ----------------------------
-- Table structure for t_h_followup_mission_remove
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_mission_remove`;
CREATE TABLE `t_h_followup_mission_remove` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) NOT NULL COMMENT '机构代码',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '计划ID(计划表主键)',
  `plan_name` varchar(200) DEFAULT NULL COMMENT '计划名称',
  `empi_id` varchar(32) NOT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `serial_no` varchar(50) DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `plan_task_id` varchar(36) DEFAULT NULL COMMENT '规则任务ID，如果是阶段性任务,则在planTaskId后面追加--数字',
  `relation_id` varchar(200) DEFAULT NULL,
  `relation_type` int DEFAULT NULL COMMENT '关联类型(1专科随访  2患者管理  3慢病随访  4慢病管理  5随访抽查)',
  `relation_type_name` varchar(50) DEFAULT NULL COMMENT '关联名称',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒时间',
  `revisit_plan_end_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒截止时间',
  `advance_send_time` int DEFAULT NULL COMMENT '提醒提前发送时间',
  `content_id` varchar(350) DEFAULT NULL COMMENT '关联随访/宣教/提醒ID(","分隔，上限10个)',
  `content_title` varchar(500) DEFAULT NULL COMMENT '关联随访/宣教/提醒标题(","分隔，上限10个)',
  `mission_prop` int DEFAULT NULL COMMENT '任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `mission_time_type` int DEFAULT NULL COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `mission_time_type_name` varchar(10) DEFAULT NULL COMMENT '任务时间类型名称',
  `mission_type` int DEFAULT NULL COMMENT '任务类型(宣教: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒)',
  `mission_type_name` varchar(10) DEFAULT NULL COMMENT '任务类型名称',
  `begin_time_type` int DEFAULT NULL COMMENT '任务开始时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后, 固定下拉字典表配置)',
  `begin_time_type_name` varchar(10) DEFAULT NULL COMMENT '任务开始时间类型名称',
  `business_type` int DEFAULT NULL COMMENT '业务日期类型(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_type_name` varchar(10) DEFAULT NULL COMMENT '业务日期类型名(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_date` date DEFAULT NULL COMMENT '基线日期',
  `valid_days` int DEFAULT NULL COMMENT '有效天数(天)',
  `remind_content` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒内容',
  `plan_return_visit` varchar(30) DEFAULT NULL COMMENT '计划回访方式',
  `followup_person_id` varchar(32) DEFAULT NULL COMMENT '随访/宣教/提醒人员人ID',
  `followup_person_name` varchar(50) DEFAULT NULL COMMENT '随访/宣教/提醒人员姓名',
  `followup_person_dept_code` varchar(30) DEFAULT NULL COMMENT '随访/宣教/提醒人科室代码',
  `followup_person_dept_name` varchar(50) DEFAULT NULL COMMENT '随访/宣教/提醒人科室名称',
  `return_visit_time` datetime DEFAULT NULL COMMENT '实际回访时间',
  `return_visit_type` int DEFAULT NULL COMMENT '实际回访方式(1:电话 2:APP/微信/短信)',
  `return_visit_type_name` varchar(30) DEFAULT NULL COMMENT '实际回访方式名称',
  `revisit_status` int DEFAULT NULL COMMENT '随访状态(1:正常状态；2:无人接听；3:无法接通；4:关机；5:停机；6:死亡；7:家属接听(不了解情况)；8:拒绝；9:空号/电话错误；10:其他)',
  `revisit_result` int DEFAULT '0' COMMENT '随访结果(0:未完成 1:已完成 2:已结案)',
  `revisit_excp` int DEFAULT NULL COMMENT '随访结果异常标识(0:正常 1:异常)',
  `handling_opinion` varchar(300) DEFAULT NULL COMMENT '处理意见',
  `app_send_status` int DEFAULT '0' COMMENT 'APP发送状态(0:未发送 -1未回复: 1:已回复)',
  `app_send_time` datetime DEFAULT NULL COMMENT 'APP发送时间',
  `app_reply_excp` int DEFAULT NULL COMMENT 'APP回复是否异常(0:否 1:是)',
  `plan_year` int DEFAULT NULL COMMENT '计划所属年份',
  `plan_month` int DEFAULT NULL COMMENT '计划所属月份',
  `followup_result` int DEFAULT NULL COMMENT '随访结果(统计)  1:电话完成 2:移动端完成 3:其他方式 （优先级：电话>移动端>其他）',
  `send_app_times` int DEFAULT '0' COMMENT '手动补发次数(记录手动发送的次数)',
  `remark` varchar(300) DEFAULT NULL,
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `group_id` char(32) DEFAULT NULL COMMENT '任务组块ID',
  `auto_send_times` tinyint DEFAULT '0' COMMENT '自动发送次数',
  `revisit_send_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒发送时间',
  `task_source_name` varchar(50) DEFAULT NULL COMMENT '任务来源',
  `is_delete` int DEFAULT NULL COMMENT '1:删除',
  `sort` int DEFAULT NULL COMMENT '随访任务排序',
  `last_revisit_excp` int DEFAULT NULL COMMENT '上一次随访结果异常标识(0:正常 1:异常)',
  `referral_id` varchar(32) DEFAULT NULL COMMENT '复诊父id',
  `creator_source_type` varchar(20) DEFAULT NULL COMMENT '创建来源:方案制定',
  `deal_date` datetime DEFAULT NULL,
  `ai_call_times` int DEFAULT NULL COMMENT 'ai拨打次数',
  `temporary_status` tinyint DEFAULT '0' COMMENT '0：未暂存 1：暂存',
  `is_personalise_edu` int DEFAULT NULL COMMENT '个性化宣教任务 1：是',
  `mission_categories` int DEFAULT NULL COMMENT '任务类别;1、普通随访任务（默认）；2、处方任务',
  `channel_order` varchar(10) DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `channel_order_name` varchar(20) DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `form_effective_time` int DEFAULT NULL COMMENT '表单有效时间 表单合并需要使用',
  `form_question_ids` varchar(500) DEFAULT NULL COMMENT '表单的题目的id',
  `synch_flag` int DEFAULT NULL COMMENT '1、 正常（默认）、2 需要重新同步',
  `form_result` text COMMENT '表单答案',
  `yun_form_id` varchar(32) DEFAULT NULL COMMENT '云端知识库的id',
  `pay_id` varchar(32) DEFAULT NULL,
  `form_alias` varchar(200) DEFAULT NULL COMMENT '表单别名',
  `form_cloud_id` varchar(32) DEFAULT NULL COMMENT '云端知识库的id',
  `knowledge_task_id` varchar(50) DEFAULT NULL COMMENT '知识库任务id',
  `task_target` varchar(5) DEFAULT NULL COMMENT '任务对象，1.患者，2.健管师，逗号分隔',
  `track_type` tinyint DEFAULT NULL COMMENT '1.随访异常跟踪，2.咨询异常跟踪，3.预约挂号，99.其他',
  `creator_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `is_merged` tinyint DEFAULT '0' COMMENT '是否被合并，0.否，1.是',
  `submit_reason_type` tinyint DEFAULT '0' COMMENT '提交原因,0.正常提交，1.下次跟踪，2.患者不配合据',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品 id',
  `goods_name` varchar(100) DEFAULT NULL COMMENT '商品 名称',
  `diet_plan_id` varchar(32) DEFAULT NULL COMMENT '个性化饮食方案id',
  `send_diet_plan` tinyint(1) DEFAULT '0' COMMENT '是否发送饮食方案',
  `diet_plan_not_sent_reason` varchar(10) DEFAULT '' COMMENT '饮食方案未发送原因',
  `diet_plan_not_sent_reason_other` varchar(100) DEFAULT '' COMMENT '饮食方案未发送其他原因',
  `patient_target_status` tinyint DEFAULT NULL COMMENT '患者目标0:没有完成 1:完成目标',
  `consult_type` tinyint DEFAULT NULL COMMENT '1.协助预约挂号、2.要求退费、3.号码错误,需线下核实新号码',
  `importance_level` tinyint DEFAULT NULL COMMENT '重要程度，1.紧急(立即处理反馈)、2.中(当日处理处理反馈)、3.低(2个工作内处理反馈)',
  `consult_description` varchar(320) DEFAULT NULL COMMENT '咨询问题描述',
  `consult_result` tinyint DEFAULT '0' COMMENT '咨询任务中间流转状态结果 0.待线下处理，1.已处理，2.线上退回',
  `operator_name` varchar(50) DEFAULT NULL COMMENT '操作人姓名',
  `event_result` tinyint DEFAULT NULL COMMENT '事件最终结果状态，0.未解决，1.已解决',
  `consult_deal_detail` text COMMENT '最终处理详情',
  `track_feedback_result` tinyint DEFAULT NULL COMMENT '跟踪反馈结果,1.已回院复诊/2.未回院复诊/3.无需回院复诊',
  `follow_error_level` varchar(6) DEFAULT NULL COMMENT '关注的异常等级（0轻度，1中度，2重度，支持多选，必填）',
  PRIMARY KEY (`id`),
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PAY_ID` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='随访任务手动删除表';

-- ----------------------------
-- Table structure for t_h_followup_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_plan`;
CREATE TABLE `t_h_followup_plan` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `plan_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `start_date` date DEFAULT NULL COMMENT '计划开始日期',
  `end_date` date DEFAULT NULL COMMENT '计划结束日期',
  `dept_code` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访科室代码(多选 '''',''''分隔 上限10个)',
  `dept_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访科室名称(多选 '''',''''分隔 上限10个)',
  `followup_person_id` varchar(3300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访人员ID(多选 '''',''''分隔 上限100个)',
  `followup_person_name` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访人员姓名(多选 '''',''''分隔 上限100个)',
  `category_id` varchar(330) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访表单分类(多选'''',''''分隔上限10个)',
  `form_id` varchar(330) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专科档案表单ID(多选'''',''''分隔上限10个)',
  `form_title` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专科档案表单标题(多选'''',''''分隔上限10个)',
  `intent` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访目的',
  `rule_id` varchar(330) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专科随访规则ID(多选 '''',''''分隔 上限10个)',
  `rule_rule_id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'rule表的rule_id',
  `rule_title` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专科随访规则名称(多选 '''',''''分隔 上限10个)',
  `creator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人ID',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `creator_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人所在科室/病区代码',
  `creator_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人所在科室/病区名称',
  `enable_status` int DEFAULT NULL COMMENT '启用状态(-1:禁用 1:启用)',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `send_mode` int DEFAULT '1' COMMENT '发送方式(1:APP/短信 2:短信 3:APP)',
  `surgery_drug_flag` int DEFAULT NULL COMMENT '手术药品过滤标识 （1 手术药品放在task过滤）',
  `ai_push` int DEFAULT '0' COMMENT '是否推送AI(0,否 1,是)',
  `no_reply_remind` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '是否启用未回复异常提醒 1是 0否',
  `remind_rule_type` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '1超过几次未回复 2超过多久未回复',
  `remind_rule_value` int DEFAULT NULL COMMENT '超过的时间的值',
  `remind_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒内容id',
  `remind_content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒内容',
  `has_opened` tinyint DEFAULT NULL COMMENT '是否开启过，（1，是  0，否）',
  `close_time` datetime DEFAULT NULL COMMENT '关闭时间',
  `diag_path_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径ID',
  `ai_app` int DEFAULT '0' COMMENT '是否推送AI微信',
  `ai_voice` int DEFAULT NULL COMMENT '是否推送AI语音(0 否，1 是)',
  `is_export_check` tinyint(1) DEFAULT '0' COMMENT '导出档案是否短信验证 1:是 0:否',
  `export_check_mobile` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '短信验证手机号',
  `identify_code` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '验证码',
  `valid_time` datetime DEFAULT NULL COMMENT '有效截至时间',
  `signature_status` int DEFAULT NULL COMMENT '确认签字状态',
  `upgrade_rule_status` int DEFAULT NULL COMMENT '规则升级状态 1：待升级',
  `upgrade_rule_time` datetime DEFAULT NULL COMMENT '规则升级时间',
  `upgrade_form_status` int DEFAULT NULL COMMENT '表单升级状态 1：待升级',
  `data_view_auth` tinyint DEFAULT '0' COMMENT '科室专病，数据权限(默认：0 不根据用户权限调整，1 根据用户权限调整)',
  `follow_up_mutex` tinyint DEFAULT '0' COMMENT '随访互斥(0:不互斥;1:互斥)',
  `complete_plan_flag` int DEFAULT NULL COMMENT '计划完整标识  1：完整 0：未完整',
  `complete_plan_time` datetime DEFAULT NULL COMMENT '计划完整时间',
  `rule_version` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `team_type` tinyint DEFAULT '1' COMMENT '团队类型，1.线上履约团队，2.孵化团队',
  `edu_specials` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教专题列表',
  `form_specials` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单专题列表',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品goodsId',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_followup_plan_edu
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_plan_edu`;
CREATE TABLE `t_h_followup_plan_edu` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `edu_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `course_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cover_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `rule_task_use_status` tinyint DEFAULT NULL COMMENT '专题包任务使用状态：1使用,0未使用',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品goodsId',
  `goods_version_id` varchar(32) DEFAULT NULL COMMENT '商品版本id',
  `goods_package_id` varchar(32) DEFAULT NULL COMMENT '专题包id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `IDX_GOODS_VERSION` (`goods_version_id`),
  KEY `IDX_GOODS_PACKAGE` (`goods_package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_followup_plan_form
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_plan_form`;
CREATE TABLE `t_h_followup_plan_form` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `form_title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `rule_task_use_status` tinyint DEFAULT NULL COMMENT '专题包任务使用状态：1使用,0未使用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_followup_plan_task
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_plan_task`;
CREATE TABLE `t_h_followup_plan_task` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专科随访计划ID',
  `task_prop` int DEFAULT NULL COMMENT '规则任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `task_time_type` int DEFAULT '1' COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `task_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/提醒类型名称',
  `task_type` int DEFAULT NULL COMMENT '宣教类型/提醒类别( 宣教类型: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒类别: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒,310:挂号提醒 )',
  `task_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教类型/提醒类别名称',
  `begin_time_type` int DEFAULT NULL COMMENT '发送时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后 固定下拉字典表配置)',
  `begin_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送时间类型名称',
  `business_date_type` int DEFAULT NULL COMMENT '收案后-业务时间类型(0,收案日期 1,预产期 2,末次月经日期 3,手术日期 4,检验日期 5,检查时间 6,胚胎移植日期 7,分娩日期)',
  `business_date_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案后-业务时间类型名称',
  `after_begin_time` int DEFAULT NULL COMMENT '距开始时间后',
  `after_begin_time_unit` int DEFAULT NULL COMMENT '时间单位(系统下拉配置表取值 1:天 2:周 3:月 4:年)',
  `after_begin_time_unit_name` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '时间单位名称',
  `after_begin_time_hour` int DEFAULT NULL COMMENT '需提醒日程的具体时间(0-20, 0点-20点, 页面写死)',
  `advance_send_time` int DEFAULT NULL COMMENT '提醒提前发送时间(转换成小时存,前端下拉从固定字典表取)',
  `advance_send_time_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提前发送时间名称',
  `after_begin_time_days` int DEFAULT NULL COMMENT '距开始时间后-天(根据时间单位转换成天数)',
  `timing_date` date DEFAULT NULL COMMENT '定时日期(定时任务用)',
  `range_days` int DEFAULT NULL COMMENT '范围天数',
  `frequency` int DEFAULT NULL COMMENT '周期(周期性随访)',
  `frequency_unit` int DEFAULT NULL COMMENT '周期单位(周期性随访)(1,天/次, 2,月/次 3,年/次)',
  `frequency_unit_name` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '周期单位名称(周期性随访)',
  `frequency_count` int DEFAULT NULL COMMENT '周期循环次数',
  `drug_code` varchar(3500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联药品代码(逗号","分隔,上限10个)',
  `drug_name` varchar(5000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联药品名称(逗号","分隔,上限10个)',
  `exam_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联检查代码(逗号","分隔,上限10个)',
  `exam_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联检查名称(逗号","分隔,上限10个)',
  `test_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联检验代码(逗号","分隔,上限10个)',
  `test_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联检验名称(逗号","分隔,上限10个)',
  `diag_related` int DEFAULT NULL COMMENT '关联疾病情况(0:不关联疾病 1:包含疾病 2:不包含疾病)',
  `diag_match` tinyint(1) DEFAULT '0' COMMENT '关联疾病匹配方式(0:精确匹配 1:模糊匹配)',
  `diag_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联疾病代码(逗号","分隔,上限10个)',
  `diag_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联疾病名称(逗号","分隔,上限10个)',
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒分类ID(表单)',
  `category_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒分类名称',
  `content_id` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒ID(多选逗号","分隔,上限10个)',
  `content_title` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒标题(多选逗号","分隔,上限10个)',
  `return_visit_type` int DEFAULT NULL COMMENT '回访方式(1,电话;2,app,短信,微信;)',
  `return_visit_type_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '回访方式名称',
  `valid_days` int DEFAULT NULL COMMENT '有效天数(天)',
  `remind_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单说明/提醒内容',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `drug_status` int DEFAULT NULL COMMENT '用药情况(0:不关联用药  1:包含用药  2:不包含用药)',
  `drug_match` tinyint(1) DEFAULT '0' COMMENT '关联药品匹配方式(0:精确匹配 1:模糊匹配)',
  `surgery_status` int DEFAULT NULL COMMENT '手术情况(0不关联 1包含手术 2不包含手术)',
  `surgery_match` tinyint(1) DEFAULT '0' COMMENT '手术匹配方式(0:精确匹配 1:模糊匹配)',
  `surgery_code` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术代码(多选,分隔 上限10个)',
  `surgery_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术名称(多选,分隔 上限10个)',
  `only_out_hosp_drug_status` int DEFAULT '0' COMMENT '仅表示出院带药勾选状态 0未勾选 1勾选',
  `group_index` tinyint DEFAULT NULL COMMENT '任务组块排序号，同排序号的认为是同一组',
  `inner_group_index` int DEFAULT NULL COMMENT '任务组块内部组块排序号，同排序号的认为是同一组',
  `referral_dept_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊科室，多选逗号分隔',
  `referral_dept_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊科室名称',
  `referral_valid_type` tinyint DEFAULT '0' COMMENT '复诊有效时间类型（0，当天  1，推迟  2，提前  3，提前或推迟）',
  `referral_valid_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊有效时间类型名称',
  `referral_valid_days` int DEFAULT NULL COMMENT '复诊有效时间天数',
  `referral_remind_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊提醒内容',
  `referral_confirm` tinyint DEFAULT NULL COMMENT '复诊确认0 否， 1 是',
  `not_referral_except` tinyint DEFAULT NULL COMMENT '未复诊算异常 0，否  1，是',
  `actual_referral_related` tinyint DEFAULT NULL COMMENT '实际复诊关联 0，否  1，是',
  `referral_begin_time_type` tinyint DEFAULT NULL COMMENT '诊前诊后任务开始时间类型(见枚举 SpecialistBeginTimeTypeEnum)',
  `referral_begin_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊前诊后任务开始时间类型名称',
  `referral_after_begin_time` int DEFAULT NULL COMMENT '诊前诊后任务开始时间天/周/月/年数',
  `referral_after_begin_time_unit` int DEFAULT NULL COMMENT '诊前诊后任务开始时时间单位',
  `referral_after_begin_time_unit_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊前诊后任务开始时时间单位名称',
  `referral_after_begin_time_hour` tinyint DEFAULT NULL COMMENT '复诊提醒任务类型计划具体小时',
  `branch_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属分支ID',
  `is_branch_task` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为分支下的任务（0，否  1，是）',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单主键',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲任务ID',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引',
  `desc` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `referral_after_timing_date` date DEFAULT NULL COMMENT '诊前诊后任务定时时间',
  `referral_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊父id',
  `referral_mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊任务父id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `need_collection_flag` int DEFAULT NULL COMMENT '0:需要采集 1：无需采集',
  `is_personalise_edu` int DEFAULT NULL COMMENT '涓€у寲瀹ｆ暀',
  `referral_effective_begin_time` timestamp NULL DEFAULT NULL COMMENT '复诊有效开始时间，230426开始启用，弃用有效天数字段',
  `referral_effective_end_time` timestamp NULL DEFAULT NULL COMMENT '复诊有效结束时间，230426开始启用，弃用有效天数字段',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品id',
  `goods_name` varchar(50) DEFAULT NULL COMMENT '商品名称',
  `is_referral_ai_remind` tinyint DEFAULT '0' COMMENT '使用AI复诊提醒, 1表示使用0表示不使用,2表示取消',
  `is_referral_ai_abnormal` tinyint DEFAULT '0' COMMENT '使用AI复诊异常跟踪, 1表示使用0表示不使用,2表示取消',
  `referral_abnormal_time_type` tinyint DEFAULT '47' COMMENT '复诊异常跟踪时间类型',
  `referral_abnormal_time_unit` tinyint DEFAULT '1' COMMENT '复诊异常跟踪时间单位',
  `referral_abnormal_time` tinyint DEFAULT '1' COMMENT '复诊异常跟踪时间值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_plan_id` (`plan_id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_pay_id` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专科随访计划规则表';

-- ----------------------------
-- Table structure for t_h_followup_register_remind
-- ----------------------------
DROP TABLE IF EXISTS `t_h_followup_register_remind`;
CREATE TABLE `t_h_followup_register_remind` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_register_remind` int DEFAULT NULL COMMENT '是否挂号提醒',
  `remind_day` int DEFAULT NULL COMMENT '提前提醒天数',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_foreign_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_foreign_record`;
CREATE TABLE `t_h_foreign_record` (
  `id` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `type` int DEFAULT NULL COMMENT '类型',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `success_flag` int DEFAULT NULL COMMENT '成功标识 0 成功 1失败',
  `relation_id` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id',
  `relation_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联名称',
  `reason_desc` varchar(3000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=298176 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_form_answer
-- ----------------------------
DROP TABLE IF EXISTS `t_h_form_answer`;
CREATE TABLE `t_h_form_answer` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联表单(老流程为表t_repository_form的主键，知识库大脑新流程为form_id字段)',
  `relation_type` int DEFAULT NULL COMMENT '关联任务类型(1:随访任务 2:随访记录 3:满意度任务 4:VIP任务 5:满意度记录 6:APP在院满意度调查 7:随访抽查 8:专科随访 9:专科建档 99:妇幼那边提交的答案)',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任务ID',
  `question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联题目ID',
  `question_answer` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '题目答案(选项ID或者文本内容)',
  `other_content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '其他内容',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `quote_question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '引用题目ID(题库单题表主键ID)',
  `quote_question_answer` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '引用题目答案',
  `answer_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '答案编码 字典表匹配',
  `answer_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '答案名称 字典表匹配',
  `cloud_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '知识库大脑新流程关联表单主键ID',
  `except` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常标识',
  `sort` int DEFAULT NULL,
  `question_type` tinyint(1) DEFAULT NULL COMMENT '题目类型',
  `child_ids` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '子题id集合',
  `error_level` varchar(4) DEFAULT NULL COMMENT '异常等级',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_relation_id` (`relation_id`) USING BTREE,
  KEY `idx_form_id` (`form_id`) USING BTREE,
  KEY `idx_form_relate` (`form_id`,`relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='题目类型';

-- ----------------------------
-- Table structure for t_h_form_patient_question_tag
-- ----------------------------
DROP TABLE IF EXISTS `t_h_form_patient_question_tag`;
CREATE TABLE `t_h_form_patient_question_tag` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `relation_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '随访任务id',
  `form_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单id',
  `question_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '题目id',
  `answer_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '答案id',
  `tag_type` tinyint DEFAULT NULL COMMENT '1.异常，2.必填题目未填',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `t_h_form_patient_question_tag_relation_id_IDX` (`relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者表单题目标记表';

-- ----------------------------
-- Table structure for t_h_front_exception_info
-- ----------------------------
DROP TABLE IF EXISTS `t_h_front_exception_info`;
CREATE TABLE `t_h_front_exception_info` (
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `exception_remark` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_general_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_h_general_patient`;
CREATE TABLE `t_h_general_patient` (
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pat_index_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者索引',
  `pat_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者姓名',
  `visit_card_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卡号',
  `id_number` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '身份证',
  `mobile_no` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号',
  `outhosp_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `inhosp_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_serial_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '住院流水号',
  `serve_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务名称',
  `serve_status` tinyint DEFAULT NULL COMMENT '状态 0:服务开始 1:服务结束 -1 退费',
  `serve_start_time` datetime DEFAULT NULL COMMENT '服务开始',
  `serve_end_time` datetime DEFAULT NULL COMMENT '服务结束',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `order_open_dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '科室',
  PRIMARY KEY (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_goods_statistics
-- ----------------------------
DROP TABLE IF EXISTS `t_h_goods_statistics`;
CREATE TABLE `t_h_goods_statistics` (
  `goods_id` varchar(64) NOT NULL COMMENT '商品id',
  `serve_patient_num` int DEFAULT '0' COMMENT '在管患者数',
  `total_patient_num` int DEFAULT '0' COMMENT '累计患者数',
  `month_task` int DEFAULT '0' COMMENT '本月任务数',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品使用统计';

-- ----------------------------
-- Table structure for t_h_group
-- ----------------------------
DROP TABLE IF EXISTS `t_h_group`;
CREATE TABLE `t_h_group` (
  `group_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '团队编码',
  `group_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '团队名称',
  `group_type` tinyint DEFAULT '0' COMMENT '团队性质，0：健海内部，1：第三方团队',
  `is_delete` tinyint DEFAULT '0' COMMENT '停用标识，0：启动，1：停用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `contracted_hosp_codes` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '包干医院',
  `bu_relation_type` tinyint DEFAULT NULL COMMENT 'bu线类型 1妇产BU、2 骨科BU、3 消化系统BU、4护理中心BU、5 心血管肿瘤BU、6 TLC内分泌BU 7 心理BU 8 规范化BU',
  PRIMARY KEY (`group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_group_patient_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_group_patient_relation`;
CREATE TABLE `t_h_group_patient_relation` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '病人id',
  `group_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '团队编码',
  `is_delete` tinyint DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_group_user_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_group_user_relation`;
CREATE TABLE `t_h_group_user_relation` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '健管师id',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '健管师名称',
  `group_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '团队编码',
  `is_delete` tinyint DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sort` int DEFAULT NULL COMMENT '排序',
  `role_type` int DEFAULT NULL COMMENT '角色',
  `owning_type` tinyint DEFAULT '0' COMMENT '归属预算团队 0:建海 1:轻舞',
  `bu_relation_type` tinyint DEFAULT NULL COMMENT 'bu线类型 1妇产BU、2 骨科BU、3 消化系统BU、4护理中心BU、5 心血管肿瘤BU、6 TLC内分泌BU 7 心理BU 8 规范化BU',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_handling_opinion_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_handling_opinion_record`;
CREATE TABLE `t_h_handling_opinion_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `handling_opinion` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '处理意见',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_health_info_collection
-- ----------------------------
DROP TABLE IF EXISTS `t_h_health_info_collection`;
CREATE TABLE `t_h_health_info_collection` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '健管云患者id',
  `organ_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `physical_exam_pic` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体检单图片url,多个以,号分割',
  `height` decimal(4,1) DEFAULT NULL COMMENT '身高cm',
  `weight` decimal(4,1) DEFAULT NULL COMMENT '体重kg',
  `bmi` decimal(3,1) DEFAULT NULL COMMENT 'bmi',
  `waist_circumference` decimal(4,1) DEFAULT NULL COMMENT '腰围',
  `diastolic_blood_pressure` int DEFAULT NULL COMMENT '舒张压',
  `systolic_blood_pressure` int DEFAULT NULL COMMENT '收缩压',
  `fasting_plasma_glucose` decimal(3,1) DEFAULT NULL COMMENT '空腹血糖',
  `high_density_lipoprotein` decimal(4,2) DEFAULT NULL COMMENT '高密度脂蛋白',
  `low_density_lipoprotein` decimal(4,2) DEFAULT NULL COMMENT '低密度脂蛋白',
  `total_cholesterol` decimal(4,2) DEFAULT NULL COMMENT '总胆固醇',
  `triglycerides` decimal(4,2) DEFAULT NULL COMMENT '甘油三脂',
  `gpt` decimal(4,1) DEFAULT NULL COMMENT '谷丙转氨酶 U/L',
  `got` decimal(4,1) DEFAULT NULL COMMENT '谷草转氨酶 U/L',
  `bil` decimal(4,1) DEFAULT NULL COMMENT '胆红素 μmol/L',
  `ggt` decimal(4,1) DEFAULT NULL COMMENT '谷氨酰转钛酶 U/L',
  `ua` decimal(4,1) DEFAULT NULL COMMENT '尿酸 μmol/L',
  `bun` decimal(4,1) DEFAULT NULL COMMENT '尿素氮 μmol/L',
  `cr` decimal(4,1) DEFAULT NULL COMMENT '血肌酐 μmol/L cr',
  `chest_x_ray` int DEFAULT NULL COMMENT '胸部X线/CT检查 1-正常 -1-异常 0-未检查 ',
  `b_ultra_pictures` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'B超图片',
  `health_problem` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '最想解决的健康问题,多个以,号分割',
  `health_problem_other` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '最想解决的健康问题_其它',
  `name` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '姓名',
  `sex` tinyint(1) DEFAULT NULL COMMENT '性别 1-男 2-女',
  `age` int DEFAULT NULL COMMENT '年龄',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '本人电话',
  `have_previous_med_history` tinyint(1) DEFAULT NULL COMMENT '既往史疾病有无0-无 1-有',
  `previous_med_histories` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '既往史疾病,多个以,号分割',
  `previous_med_history_tumor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '既往史疾病_肿瘤',
  `previous_med_history_other` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '既往史疾病_其它',
  `allergy_history` tinyint(1) DEFAULT NULL COMMENT '过敏史有无',
  `allergy_history_other` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '过敏史_其它',
  `long_term_med_history` tinyint(1) DEFAULT NULL COMMENT '长期服药史有无 0-无 1-有',
  `med_collection_ids` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 't_h_med_collection表主键id,多个,分割',
  `med_pics` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '药品图片,多个以,号分割',
  `have_genetic_history` tinyint(1) DEFAULT NULL COMMENT '家族遗传史疾病0-无 1-有',
  `genetic_histories` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '家族遗传史疾病,多个以,号分割',
  `genetic_histories_tumor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '家族遗传史疾病-肿瘤',
  `genetic_history_other` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '家族遗传史疾病_其它',
  `dietary_prefer` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '饮食偏好',
  `eating_habits` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '饮食习惯',
  `smoking` tinyint(1) DEFAULT NULL COMMENT '是否吸烟 0-无，1-有',
  `smoked` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '烟龄',
  `roots_per_day` int DEFAULT NULL COMMENT '每天多少根',
  `alcohol` tinyint(1) DEFAULT NULL COMMENT '是否长期饮酒 0-无 1-偶尔 2-是',
  `wine_ages` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '酒龄',
  `wine_variety` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '酒的种类',
  `drinking_capacity` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '酒量(两/每天)',
  `num_of_drinking` int DEFAULT NULL COMMENT '一周几次',
  `exercise_regularly` tinyint(1) DEFAULT NULL COMMENT '经常运动0-否 1-偶尔 2-是',
  `sport_ids` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '运动表主键id,多个以逗号分割',
  `sit_duration` tinyint(1) DEFAULT NULL COMMENT '坐时长(平均每天)',
  `sleep_quality` tinyint(1) DEFAULT NULL COMMENT ' 睡眠质量枚举 1-非常好 2-一般 3-不好 4-非常差',
  `sleep_quality_detail` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '睡眠质量表现',
  `sleep_time` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '入睡时间',
  `wake_up_time` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '起床时间',
  `is_sleeping_drug` tinyint(1) DEFAULT NULL COMMENT '是否服药入睡 0-否 1-是',
  `sleeping_drug_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '助眠药物名称',
  `sleeping_drug_freq` int DEFAULT NULL COMMENT '助眠药物服用频次 次/周',
  `negative_emotions` tinyint(1) DEFAULT NULL COMMENT '是否有负面情绪 0-无 1-有',
  `negative_emotions_detail` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '负面情绪表现',
  `negative_emotions_duation` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '负面情绪持续时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='健康信息采集表';

-- ----------------------------
-- Table structure for t_h_health_info_collection2
-- ----------------------------
DROP TABLE IF EXISTS `t_h_health_info_collection2`;
CREATE TABLE `t_h_health_info_collection2` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '健管云患者id',
  `organ_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `physical_exam_pic` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体检单图片url,多个以,号分割',
  `height` decimal(4,1) DEFAULT NULL COMMENT '身高cm',
  `weight` decimal(4,1) DEFAULT NULL COMMENT '体重kg',
  `bmi` decimal(3,1) DEFAULT NULL COMMENT 'bmi',
  `waist_circumference` decimal(4,1) DEFAULT NULL COMMENT '腰围',
  `diastolic_blood_pressure` int DEFAULT NULL COMMENT '舒张压',
  `systolic_blood_pressure` int DEFAULT NULL COMMENT '收缩压',
  `fasting_plasma_glucose` decimal(3,1) DEFAULT NULL COMMENT '空腹血糖',
  `high_density_lipoprotein` decimal(4,2) DEFAULT NULL COMMENT '高密度脂蛋白',
  `low_density_lipoprotein` decimal(4,2) DEFAULT NULL COMMENT '低密度脂蛋白',
  `total_cholesterol` decimal(4,2) DEFAULT NULL COMMENT '总胆固醇',
  `triglycerides` decimal(4,2) DEFAULT NULL COMMENT '甘油三脂',
  `gpt` int DEFAULT NULL COMMENT '谷丙转氨酶 U/L',
  `got` int DEFAULT NULL COMMENT '谷草转氨酶 U/L',
  `bil` decimal(4,1) DEFAULT NULL COMMENT '胆红素 μmol/L',
  `ggt` int DEFAULT NULL COMMENT '谷氨酰转钛酶 U/L',
  `ua` int DEFAULT NULL COMMENT '尿酸 μmol/L',
  `bun` decimal(4,1) DEFAULT NULL COMMENT '尿素氮 μmol/L',
  `cr` decimal(4,1) DEFAULT NULL COMMENT '血肌酐 μmol/L cr',
  `chest_x_ray` int DEFAULT NULL COMMENT '胸部X线/CT检查 1-正常 -1-异常 0-未检查 ',
  `b_ultra_pictures` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'B超图片',
  `health_problem` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '最想解决的健康问题,多个以,号分割',
  `health_problem_other` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '最想解决的健康问题_其它',
  `name` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '姓名',
  `sex` tinyint(1) DEFAULT NULL COMMENT '性别 1-男 2-女',
  `age` int DEFAULT NULL COMMENT '年龄',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '本人电话',
  `have_previous_med_history` tinyint(1) DEFAULT NULL COMMENT '既往史疾病有无0-无 1-有',
  `previous_med_histories` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '既往史疾病,多个以,号分割',
  `previous_med_history_tumor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '既往史疾病_肿瘤',
  `previous_med_history_other` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '既往史疾病_其它',
  `allergy_history` tinyint(1) DEFAULT NULL COMMENT '过敏史有无',
  `allergy_history_other` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '过敏史_其它',
  `long_term_med_history` tinyint(1) DEFAULT NULL COMMENT '长期服药史有无 0-无 1-有',
  `med_collection_ids` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 't_h_med_collection表主键id,多个,分割',
  `med_pics` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '药品图片,多个以,号分割',
  `have_genetic_history` tinyint(1) DEFAULT NULL COMMENT '家族遗传史疾病0-无 1-有',
  `genetic_histories` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '家族遗传史疾病,多个以,号分割',
  `genetic_histories_tumor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '家族遗传史疾病-肿瘤',
  `genetic_history_other` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '家族遗传史疾病_其它',
  `dietary_prefer` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '饮食偏好',
  `eating_habits` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '饮食习惯',
  `smoking` tinyint(1) DEFAULT NULL COMMENT '是否吸烟 0-无，1-有',
  `smoked` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '烟龄',
  `roots_per_day` int DEFAULT NULL COMMENT '每天多少根',
  `alcohol` tinyint(1) DEFAULT NULL COMMENT '是否长期饮酒 0-无 1-偶尔 2-是',
  `wine_ages` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '酒龄',
  `wine_variety` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '酒的种类',
  `drinking_capacity` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '酒量(两/每天)',
  `num_of_drinking` int DEFAULT NULL COMMENT '一周几次',
  `exercise_regularly` tinyint(1) DEFAULT NULL COMMENT '经常运动0-否 1-偶尔 2-是',
  `sport_ids` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '运动表主键id,多个以逗号分割',
  `sit_duration` tinyint(1) DEFAULT NULL COMMENT '坐时长(平均每天)',
  `sleep_quality` tinyint(1) DEFAULT NULL COMMENT ' 睡眠质量枚举 1-非常好 2-一般 3-不好 4-非常差',
  `sleep_quality_detail` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '睡眠质量表现',
  `sleep_time` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '入睡时间',
  `wake_up_time` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '起床时间',
  `is_sleeping_drug` tinyint(1) DEFAULT NULL COMMENT '是否服药入睡 0-否 1-是',
  `sleeping_drug_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '助眠药物名称',
  `sleeping_drug_freq` int DEFAULT NULL COMMENT '助眠药物服用频次 次/周',
  `negative_emotions` tinyint(1) DEFAULT NULL COMMENT '是否有负面情绪 0-无 1-有',
  `negative_emotions_detail` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '负面情绪表现',
  `negative_emotions_duation` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '负面情绪持续时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='健康信息采集表';

-- ----------------------------
-- Table structure for t_h_holiday_date
-- ----------------------------
DROP TABLE IF EXISTS `t_h_holiday_date`;
CREATE TABLE `t_h_holiday_date` (
  `year` int DEFAULT NULL,
  `month` int DEFAULT NULL,
  `date` date NOT NULL,
  `is_work` int DEFAULT NULL COMMENT '是否工作 0：否 1：是',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_hosp_answer_phone
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_answer_phone`;
CREATE TABLE `t_h_hosp_answer_phone` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `answer_phone` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `is_delete` int DEFAULT NULL,
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `agent` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_hosp_evaluation_answer
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_evaluation_answer`;
CREATE TABLE `t_h_hosp_evaluation_answer` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `archives_relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '院内评估关联id',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单的id',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单的formid',
  `form_answer` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '表单答案json',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `is_delete` int DEFAULT NULL COMMENT '1:删除',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pay` (`archives_relation_id`,`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='院内评估答案表';

-- ----------------------------
-- Table structure for t_h_hosp_evaluation_archives
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_evaluation_archives`;
CREATE TABLE `t_h_hosp_evaluation_archives` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单的id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单的id;专病档案表单id',
  `form_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单的名称;表单的名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `is_delete` int DEFAULT NULL COMMENT '删除标记;0、正常；1、删除',
  `form_cloud_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单主键id',
  `sort` int DEFAULT NULL,
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务id',
  `price_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '物价id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='院内评估';

-- ----------------------------
-- Table structure for t_h_hosp_fail_sync
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_fail_sync`;
CREATE TABLE `t_h_hosp_fail_sync` (
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `date` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `data_type` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '1:门诊 2：住院 3:出院',
  PRIMARY KEY (`hosp_code`,`date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_hosp_pay_channel
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_pay_channel`;
CREATE TABLE `t_h_hosp_pay_channel` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `pay_way_code` int DEFAULT NULL COMMENT '支付方式：1:微信 2：支付宝',
  `channel` int DEFAULT NULL COMMENT '渠道类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_hosp_pay_count
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_pay_count`;
CREATE TABLE `t_h_hosp_pay_count` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `count` int DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_hosp_personalize_form
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_personalize_form`;
CREATE TABLE `t_h_hosp_personalize_form` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `goods_id` varchar(32) NOT NULL COMMENT '商品id',
  `form_id` varchar(32) NOT NULL COMMENT '表单id',
  `form_title` varchar(100) DEFAULT NULL COMMENT '表单标题',
  `form_sort` tinyint DEFAULT NULL COMMENT '表单排序',
  `mission_fill_flag` tinyint DEFAULT NULL COMMENT '任务是否填写标志',
  `mission_sort` varchar(100) DEFAULT NULL COMMENT '任务排序',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(32) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='医院个性化表单';

-- ----------------------------
-- Table structure for t_h_hosp_personalize_form_question
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_personalize_form_question`;
CREATE TABLE `t_h_hosp_personalize_form_question` (
  `id` varchar(32) COLLATE utf8mb3_bin NOT NULL COMMENT 'id',
  `relation_id` varchar(32) COLLATE utf8mb3_bin NOT NULL COMMENT '关联id',
  `form_id` varchar(32) COLLATE utf8mb3_bin NOT NULL COMMENT '表单formId',
  `question_id` varchar(32) COLLATE utf8mb3_bin NOT NULL COMMENT '题目ID',
  `question_title` varchar(500) COLLATE utf8mb3_bin NOT NULL COMMENT '题目名称',
  `child_question_ids` varchar(320) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '子题目id',
  `question_sort` tinyint DEFAULT NULL COMMENT '题目排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='医院个性化表单题目';

-- ----------------------------
-- Table structure for t_h_hosp_record_banding
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_record_banding`;
CREATE TABLE `t_h_hosp_record_banding` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pay_patient_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '开单表id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '患者索引号',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '住院号',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '流水号',
  `admit_date` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '住院时间',
  `pat_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '患者名字',
  `mobile_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '手机号',
  `dept_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '科室名称',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  `admit_diag_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '疾病名称',
  `attend_dr_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '主治医生',
  `attend_dr_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '主治医生',
  `ward_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '病区名称',
  `bed_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '床位号',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='患者住院记录绑定表';

-- ----------------------------
-- Table structure for t_h_hosp_summary
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_summary`;
CREATE TABLE `t_h_hosp_summary` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构名称',
  `summary_url` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院小结url',
  `is_delete` int DEFAULT NULL COMMENT '删除标记',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `note` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `flag` int DEFAULT NULL COMMENT '1、需要特殊处理',
  `hosp_summary_url` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '院内小结url',
  `summary_cache_url` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '缓存出院小结url',
  `summary_cache_type` int DEFAULT NULL COMMENT '0-缓存pdf , 1-调用/hug_interview/summary接口',
  `is_cache_flag` int DEFAULT NULL COMMENT '是否缓存标志  0-不缓存 , 1-缓存',
  `is_dubbo_interface` tinyint DEFAULT '0' COMMENT '是否是dubbo接口 0-否 1-是',
  `summary_domain_url` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '' COMMENT '出院小结域名url',
  `important_hospital` int DEFAULT '0' COMMENT '重点医院 0-否 1-是',
  `admission_record_url` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '入院记录url',
  `surgical_record_url` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术记录url',
  `course_record_url` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '病程记录url',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='是否缓存标志  0-不缓存 , 1-缓存';

-- ----------------------------
-- Table structure for t_h_hosp_url
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_url`;
CREATE TABLE `t_h_hosp_url` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `platform_code` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `platform_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `url` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '外网地址',
  `update_time` datetime DEFAULT NULL,
  `intranet_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '内网地址',
  `mobile_no` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '联系号码',
  `qr_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者永久二维码地址',
  `price_open_status` int DEFAULT NULL COMMENT '物价开通标识 0：未开通 1：开通 ',
  `pay_open_status` int DEFAULT NULL COMMENT '推荐支付开通标识  0：未开通 1：开通 ',
  `pat_qr_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者个人二维码',
  `in_operation` int DEFAULT NULL COMMENT '运营医院标识 1：运营中',
  `dr_qr_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医生永久二维码地址',
  `enterprise_wechat` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '企业微信号',
  `hosp_simple_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '缩写名',
  `pat_sop_qr_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者sop二维码',
  `control_center_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '中心名称',
  `in_service_status` int DEFAULT NULL COMMENT '该医院是否正在服务中 服务状态 0：未在服务 1：正常',
  `hosp_code_mapping` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '映射机构代码',
  `enterprise_wechat_identify` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '企业微信id',
  `excel_flag` tinyint(1) DEFAULT '0' COMMENT '科室维护是否对接飞书 0:否 1:是',
  `classify_id_pat` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者公众号编码',
  `hosp_sms_type` tinyint DEFAULT NULL COMMENT '医院短信特殊 1：北肿 2：心归律',
  `open_bed_sort` tinyint(1) DEFAULT '0' COMMENT '是否开放床位排序0否1是',
  `sur_flag` tinyint(1) DEFAULT '0' COMMENT '是否对接手术信息 0:否 1:是',
  `hosp_operation_type` tinyint DEFAULT NULL COMMENT '医院运营类型 0：服务医院 1：北肿科研医院 2：心归律医院 9：测试/演示医院 99：其他医院',
  `repeat_order_define` tinyint(1) DEFAULT '0' COMMENT '重复开单定义 0标准1严格',
  `charge_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '收费方式 1:HIS收费 2:公众号收费 3:pad收费 4:其他收费登记',
  `inhosp_record_open_state` tinyint(1) DEFAULT '0' COMMENT '手术病程记录 0不开启,1开启',
  `is_permission` tinyint(1) DEFAULT '0' COMMENT '知情同意书 0非必填 1必填',
  `sign_status_flag` tinyint(1) DEFAULT '0' COMMENT '签约状态回写 0不支持1支持',
  `token_pwd` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '获取token密码',
  `sys_in_hosp` int DEFAULT NULL,
  `discharge_order_flag` int DEFAULT NULL,
  `service_end_buffer` int DEFAULT '0' COMMENT '续单授权缓冲时间',
  `service_mobile_no` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务总台电话',
  `mobile_auth_flag` int DEFAULT '0' COMMENT '联系方式验证 0-关闭 1-开启',
  `doctor_flag` tinyint(1) DEFAULT '0' COMMENT '是否支持医生查询 0 否 1 是',
  `informed_consent_form_send` tinyint(1) DEFAULT '0' COMMENT '知情同意书发送 0-不发送 1-出院后 2-宣讲后 3-收案后',
  `door_flag` tinyint(1) DEFAULT '0' COMMENT '是否支持医生上门 0 否 1 是',
  `recommend_pat_export` tinyint(1) DEFAULT '0' COMMENT '是否支持推荐患者导出 0 否 1 是',
  `billing_time_offset` int DEFAULT NULL COMMENT '计费时间偏移量（小时）',
  `offline_new_mode` tinyint(1) DEFAULT '0' COMMENT '线下新模式 0-否 1-是',
  `is_dispose_ai_precall` tinyint DEFAULT '0' COMMENT 'AI预外呼，1.是，0.否',
  `is_need_captcha` tinyint DEFAULT '0' COMMENT '预约挂号需要输入验证码,1.是，0.否',
  `is_referral_ai` tinyint(1) DEFAULT '0' COMMENT '复诊是否使用AI工具',
  `is_connotation_check` tinyint(1) DEFAULT '0' COMMENT '服务包内涵检验 0:否 1:是',
  `is_drug_remind` tinyint DEFAULT '0' COMMENT '用药闹钟设置 0:关 1:开',
  `introduce_context` varchar(500) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '介绍内容',
  `is_expire_edu_auto_send` tinyint DEFAULT '0' COMMENT '过期宣教是否需要自动发送 0:否 1:是',
  `referral_flag_chaixian` tinyint DEFAULT '0' COMMENT '拆线纳入复诊',
  `referral_flag_huan_yao` tinyint DEFAULT '0' COMMENT '换药纳入复诊',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1000000195 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_hospital_info
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hospital_info`;
CREATE TABLE `t_h_hospital_info` (
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院名称',
  `hosp_pic` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院图片',
  `hosp_introduce` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院介绍',
  PRIMARY KEY (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='医院介绍信息';

-- ----------------------------
-- Table structure for t_h_index_configuration
-- ----------------------------
DROP TABLE IF EXISTS `t_h_index_configuration`;
CREATE TABLE `t_h_index_configuration` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包Id',
  `my_index_configuration_code` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '我的指标配置编码',
  `my_index_configuration_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '我的指标配置名称',
  `my_index_configuration_count` int DEFAULT NULL COMMENT '我的指标配置数量',
  `my_index_configuration_picurl` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '我的指标配置图片url',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_index_content
-- ----------------------------
DROP TABLE IF EXISTS `t_h_index_content`;
CREATE TABLE `t_h_index_content` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `index_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '指标主键',
  `content_sort` int DEFAULT NULL COMMENT '指标内容排序',
  `content_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '指标内容编码',
  `content` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '指标内容',
  `default_flag` int DEFAULT NULL COMMENT '默认 0：未默认1：默认',
  `is_delete` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_index_item
-- ----------------------------
DROP TABLE IF EXISTS `t_h_index_item`;
CREATE TABLE `t_h_index_item` (
  `index_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '指标主键',
  `index_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '指标名称',
  `index_type` int DEFAULT NULL COMMENT '指标类型 ：1选项 2：文本',
  `relate_summary_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联小结指标',
  `relate_summary_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `is_delete` int DEFAULT NULL,
  PRIMARY KEY (`index_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_informed_consent_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_informed_consent_record`;
CREATE TABLE `t_h_informed_consent_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `task_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '宣讲任务id',
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '患者主索引',
  `content_md5` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容MD5值',
  `informed_consent_no` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '知情同意书编号',
  `patient_sign_img` varchar(512) COLLATE utf8mb4_general_ci NOT NULL COMMENT '患者签字img',
  `informed_consent_img` varchar(512) COLLATE utf8mb4_general_ci NOT NULL COMMENT '知情同意书图片',
  `informed_consent_pdf` varchar(512) COLLATE utf8mb4_general_ci NOT NULL COMMENT '知情同意书pdf',
  `pdf_md5` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'pdf文件MD5值',
  `notary_trans_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '存证事务id',
  `notary_tx_hash` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '存证凭证',
  `preach_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣讲人id',
  `preach_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣讲人name',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `hosp_code` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '医院编码',
  `charge_item_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收费项目编码',
  `is_sms_send` tinyint(1) DEFAULT '0' COMMENT '短信是否发送 0-未发送 1-已发送',
  `sms_send_time` datetime DEFAULT NULL COMMENT '短信发送时间',
  `goods_price_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务商品物价id',
  `relation` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '与本人关系',
  `stamp_flag` tinyint(1) DEFAULT NULL COMMENT '是否需要盖章 1：是 2：已签章'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知情同意书记录';

-- ----------------------------
-- Table structure for t_h_inhosp_order
-- ----------------------------
DROP TABLE IF EXISTS `t_h_inhosp_order`;
CREATE TABLE `t_h_inhosp_order` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `organ_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者empiId',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  `PAT_INDEX_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INHOSP_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INHOSP_NUM` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INHOSP_SERIAL_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_GROUP_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_PLAN_BEGIN_DATE` datetime DEFAULT NULL,
  `ORDER_PLAN_END_DATE` datetime DEFAULT NULL,
  `ORDER_BEGIN_DATE` datetime DEFAULT NULL,
  `ORDER_END_DATE` datetime DEFAULT NULL,
  `ORDER_ORDER_DATE` datetime DEFAULT NULL,
  `ORDER_OPEN_DEPT_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_OPEN_DEPT_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_OPEN_DR_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_OPEN_DR_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_EXECUTE_DATE` datetime DEFAULT NULL,
  `ORDER_ITEM_TYPE_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_TYPE_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_CATEG_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_CATEG_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_SPECIFICATIONS` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOSE_WAY_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOSE_WAY_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_USE_ONE_DOSAGE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_USE_ONE_DOSAGE_UNIT` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_USE_FREQUENCY_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_USE_FREQUENCY_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_FORM_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_FORM_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_UNIT` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_UNIT_PRICE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_ABBREV` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_DESCR` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DRUG_AMOUNT` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_DURATION` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_DURATION_UNIT` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BASE_AUX_DRUG_FLAG` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISCHARGE_ORDER_FLAG` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DR_ENTRUST` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NOTE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UPDATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `IS_REFUND` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHARGE_DATE` datetime DEFAULT NULL,
  `REFUND_DATE` datetime DEFAULT NULL,
  `JxhCreateTime` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `inhosp_index` (`INHOSP_SERIAL_NO`) USING BTREE,
  KEY `idx_pay_id` (`organ_code`,`pay_id`) USING BTREE,
  KEY `idx_empi_id` (`organ_code`,`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者医嘱表';

-- ----------------------------
-- Table structure for t_h_inhosp_surgery
-- ----------------------------
DROP TABLE IF EXISTS `t_h_inhosp_surgery`;
CREATE TABLE `t_h_inhosp_surgery` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `inhosp_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院记录ID',
  `organ_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组织机构代码',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `surgery_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术流水号',
  `surgery_seq_no` int DEFAULT NULL COMMENT '手术序号',
  `surgery_oper_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术(操作)代码',
  `surgery_oper_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术(操作)名称',
  `surgery_wound_categ_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术切口类别代码',
  `surgery_wound_categ_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术切口类别名称',
  `wound_healing_level_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术切口愈合等级代码',
  `wound_healing_level_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术切口愈合等级名称',
  `surgery_begin_date` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术开始日期',
  `surgery_end_date` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术结束日期',
  `surgery_dr_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术医生工号',
  `surgery_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术医生姓名',
  `anes_method_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '麻醉方式代码',
  `anes_method_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '麻醉方式名称',
  `anes_dr_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '麻醉医生工号',
  `anes_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '麻醉医生姓名',
  `surgery_level_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术等级代码',
  `surgery_level_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术登记名称',
  `empi_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主索引号',
  `empi_id_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `AK_surgery_record_index` (`inhosp_serial_no`,`surgery_no`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE,
  KEY `IDX_PATIENT_MAIN_ID` (`patient_main_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='手术记录';

-- ----------------------------
-- Table structure for t_h_initial_measure
-- ----------------------------
DROP TABLE IF EXISTS `t_h_initial_measure`;
CREATE TABLE `t_h_initial_measure` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `initial_measure_code` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '初始干预措施的Code',
  `initial_measure_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '初始干预措施的Name',
  `management_key_code` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Code',
  `management_key_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Name',
  `measure_upgrade_path_code` varchar(320) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '措施升级路径code ，多个逗号隔开',
  `measure_upgrade_path_name` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '措施升级路径name ，多个逗号隔开',
  `risk_factor_code` varchar(320) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风险因素code，多个逗号隔开',
  `risk_factor_name` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风险因素name，多个逗号隔开',
  `management_goal_code` varchar(320) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理目标code，多个逗号隔开',
  `management_goal_name` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理目标name，多个逗号隔开',
  `bu_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用BU的Code',
  `bu_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用BU的Name',
  `dept_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用科室的Code，多个逗号隔开',
  `dept_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用科室的Name，多个逗号隔开',
  `service_product_id` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务产品的product_id，多个逗号隔开',
  `service_product_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务产品的Name，多个逗号隔开',
  `editor_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除，0-未删除，1-已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='干预措施表';

-- ----------------------------
-- Table structure for t_h_issue_file_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_issue_file_record`;
CREATE TABLE `t_h_issue_file_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '机构代码',
  `file_path_url` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件原始路径',
  `table_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据表单名',
  `relation_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '关联数据id',
  `issue_status` int NOT NULL COMMENT '下发状态 0-未下发  1-下发完成',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文件下发医院记录';

-- ----------------------------
-- Table structure for t_h_key_words
-- ----------------------------
DROP TABLE IF EXISTS `t_h_key_words`;
CREATE TABLE `t_h_key_words` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `word_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关键词名称',
  `category_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关键词库类目id',
  `standard_file` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标准文件名称',
  `word_coding` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编码',
  `is_standard` tinyint DEFAULT '0' COMMENT '1.标准文件，0.不是',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '更新时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新人',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除   0 : 否    1：是',
  `category_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关键词库类目名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='关键词词库表';

-- ----------------------------
-- Table structure for t_h_key_words_category
-- ----------------------------
DROP TABLE IF EXISTS `t_h_key_words_category`;
CREATE TABLE `t_h_key_words_category` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `category_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类目名称',
  `category_type` tinyint DEFAULT NULL COMMENT '类目类型     1：关键词库类目 2：词表类目',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除   0 ：否    1 是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='关键词飘红-关键词类目表';

-- ----------------------------
-- Table structure for t_h_key_words_list
-- ----------------------------
DROP TABLE IF EXISTS `t_h_key_words_list`;
CREATE TABLE `t_h_key_words_list` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `word_list_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `apply_diag` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用疾病，逗号分隔',
  `apply_diag_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用疾病名称，逗号分隔',
  `apply_path` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用路径，逗号分隔',
  `apply_path_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用路径名称，逗号分隔',
  `apply_words_list_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '引用词表id',
  `category_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类目id',
  `word_list_desc` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `word_list_status` tinyint DEFAULT NULL COMMENT '状态  1：启用  2 停用',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除   0 : 否    1：是',
  `product_id` varchar(2000) DEFAULT NULL,
  `product_name` varchar(2000) DEFAULT NULL,
  `product_radius_flag` tinyint(1) DEFAULT NULL COMMENT '产品范围 0:全部 1:指定产品',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='关键词词表';

-- ----------------------------
-- Table structure for t_h_key_words_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_key_words_relation`;
CREATE TABLE `t_h_key_words_relation` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `key_words_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关键词主键Id',
  `key_words_list_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '词表主键Id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='关键词和词表关系表';

-- ----------------------------
-- Table structure for t_h_key_words_synonymous
-- ----------------------------
DROP TABLE IF EXISTS `t_h_key_words_synonymous`;
CREATE TABLE `t_h_key_words_synonymous` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `synonymous_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '同义词名称',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除   0 ：否    1 是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='关键词-同义词词表';

-- ----------------------------
-- Table structure for t_h_key_words_synonymous_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_key_words_synonymous_relation`;
CREATE TABLE `t_h_key_words_synonymous_relation` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `key_words_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关键词id',
  `synonymous_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '同义词id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='关键词和同义词关联关系表';

-- ----------------------------
-- Table structure for t_h_login_user_hosp
-- ----------------------------
DROP TABLE IF EXISTS `t_h_login_user_hosp`;
CREATE TABLE `t_h_login_user_hosp` (
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户id',
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_logs
-- ----------------------------
DROP TABLE IF EXISTS `t_h_logs`;
CREATE TABLE `t_h_logs` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `editor_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `log` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_manage_advise_tpl
-- ----------------------------
DROP TABLE IF EXISTS `t_h_manage_advise_tpl`;
CREATE TABLE `t_h_manage_advise_tpl` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `tpl_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `tpl_content` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模板内容',
  `create_by` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='结案-管理建议模板表';

-- ----------------------------
-- Table structure for t_h_manage_dept
-- ----------------------------
DROP TABLE IF EXISTS `t_h_manage_dept`;
CREATE TABLE `t_h_manage_dept` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `pinyin_code` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '拼音码',
  `parent_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上级科室代码',
  `parent_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上级科室名称',
  `ward_flag` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区标识(系统下拉配置表取值1:科室 2:病区)',
  `invalid_flag` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `dept_phone` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `sort_no` int DEFAULT NULL,
  `dept_sms_category` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室短信类型',
  `dept_sms_account` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室短信帐号',
  `dept_sms_password` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室短信密码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `hospital_area_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属院区代码',
  `extension` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分机号',
  `register_total` int DEFAULT '0' COMMENT '挂号次数',
  PRIMARY KEY (`id`,`hosp_code`) USING BTREE,
  UNIQUE KEY `idx_manage_dept` (`hosp_code`,`dept_code`,`ward_flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_manage_patient_recommend
-- ----------------------------
DROP TABLE IF EXISTS `t_h_manage_patient_recommend`;
CREATE TABLE `t_h_manage_patient_recommend` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) DEFAULT NULL,
  `empi_id` varchar(32) DEFAULT NULL,
  `hosp_code` varchar(30) DEFAULT NULL,
  `patient_team_id` varchar(200) DEFAULT NULL,
  `manager_user_ids` varchar(320) DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_h_manage_patient_recommend_empi_id_IDX` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='推荐管理人员表';

-- ----------------------------
-- Table structure for t_h_manage_sms
-- ----------------------------
DROP TABLE IF EXISTS `t_h_manage_sms`;
CREATE TABLE `t_h_manage_sms` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户姓名',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户科室名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主索引号',
  `patient_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `patient_mobile` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者手机号',
  `sms_theme` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '短信主题',
  `sms_content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '短信内容',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `send_status` int DEFAULT NULL COMMENT '发送状态(0:失败 1:成功)',
  `fail_reason` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送失败原因',
  `resend_time` datetime DEFAULT NULL COMMENT '短信重发时间',
  `message_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '消息id（舟山妇幼）',
  `sms_push_status` int DEFAULT NULL COMMENT '短信推送状态（舟山妇幼）1表示成功 0表示失败',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任何id',
  `role_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专科随访高级筛选关联字段',
  `model_id` int DEFAULT NULL COMMENT '短信模板id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_send_time` (`send_time`) USING BTREE,
  KEY `t_h_manage_sms_patient_mobile_IDX` (`patient_mobile`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='短信模板id';

-- ----------------------------
-- Table structure for t_h_match_disease_risk
-- ----------------------------
DROP TABLE IF EXISTS `t_h_match_disease_risk`;
CREATE TABLE `t_h_match_disease_risk` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'patId',
  `disease_risk_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '疾病风险名称',
  `deal_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '建议处理意见',
  `is_delete` tinyint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `is_recommend` tinyint DEFAULT NULL COMMENT '是否推荐 0:不推荐 1:推荐',
  `message_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `source_message` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_h_match_disease_risk_pat_id_IDX` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_match_education
-- ----------------------------
DROP TABLE IF EXISTS `t_h_match_education`;
CREATE TABLE `t_h_match_education` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'patId',
  `edu_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣教id',
  `edu_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣教名称',
  `is_delete` tinyint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `is_recommend` tinyint DEFAULT NULL COMMENT '是否推荐 0:不推荐 1:推荐',
  `message_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_send` tinyint DEFAULT '0' COMMENT '是否发送 1:发送',
  PRIMARY KEY (`id`),
  KEY `t_h_match_education_pat_id_IDX` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_measures_config
-- ----------------------------
DROP TABLE IF EXISTS `t_h_measures_config`;
CREATE TABLE `t_h_measures_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `is_delete` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '是否删除 0未删除  1已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `rule_name` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `apply_form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '适用表单id',
  `apply_form_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '使用表单名称',
  `rule_association` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '规则关联t_h_measures_rule表id',
  `problem_ids` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '问题id，多个,隔开',
  `measure_ids` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '措施id，多个,隔开',
  `status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '规则状态0 停用 1 启用 2 失效',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '编辑人id',
  `editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '编辑人姓名',
  `last_edit_time` datetime NOT NULL COMMENT '最新一次编辑时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1000014 DEFAULT CHARSET=utf8mb3 COMMENT='问题和措施配置表';

-- ----------------------------
-- Table structure for t_h_measures_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_h_measures_rule`;
CREATE TABLE `t_h_measures_rule` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0未删除  1已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '问题id',
  `question_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '问题名称',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '表单id',
  `meet_conditions` tinyint unsigned NOT NULL DEFAULT '0' COMMENT ' 0 或 1 且',
  `answer_json` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '选中答案json',
  `measure_config_id` int NOT NULL COMMENT '所属措施配置id',
  `component_key` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '题目类型 RadioBox/checkBox',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='问题和措施规则内容对应';

-- ----------------------------
-- Table structure for t_h_med_collection
-- ----------------------------
DROP TABLE IF EXISTS `t_h_med_collection`;
CREATE TABLE `t_h_med_collection` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '健管云患者id',
  `med_name` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '药品名称',
  `med_dosage` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服药剂量',
  `med_freq` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '频次',
  `med_duration` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服用持续时间(年)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='服药史信息采集表';

-- ----------------------------
-- Table structure for t_h_mini_user
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mini_user`;
CREATE TABLE `t_h_mini_user` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键(患者empiId 或医生主键id',
  `open_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `union_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `mobile_no` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `type` int DEFAULT NULL COMMENT '2：医生小程序 3：患者绑定公众号(关联empi) 4、患者绑定公众号（未关联empi）',
  `staff_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医生职工号',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `attributes` int DEFAULT NULL COMMENT '1：医生 2：患者',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_mission_ai
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_ai`;
CREATE TABLE `t_h_mission_ai` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ID',
  `ai_push_status` tinyint DEFAULT '0' COMMENT 'AI推送状态(0:未推送 -1:未回复 1:已回复,2正常 3异常 4未接通)',
  `ai_push_result_code` tinyint DEFAULT NULL COMMENT 'AI推送结果状态值 0 正常, 其他 异常(具体AI系统定)',
  `ai_push_result_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AI推送结果状态说明',
  `ai_push_time` datetime DEFAULT NULL COMMENT 'AI推送时间',
  `ai_push_person_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AI推送人员ID',
  `auto_push_ai_times` tinyint DEFAULT '0' COMMENT '自动AI推送次数',
  `manual_push_ai_times` tinyint DEFAULT '0' COMMENT '手动AI推送次数',
  `ai_reply_time` datetime DEFAULT NULL COMMENT 'AI回复时间',
  `ai_label_codes` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ai标签编码（逗号隔开）',
  `ai_label_names` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ai标签',
  `ai_precall_status` tinyint DEFAULT NULL COMMENT 'AI预外呼状态(1:未推送 2:已推送 3:呼叫成功 4:呼叫失败)',
  `ai_precall_time` datetime DEFAULT NULL COMMENT 'AI预外呼时间',
  `ai_precall_label_codes` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AI预外呼标签id',
  `ai_precall_label_names` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AI预外呼标签名称',
  `ai_precall_result` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'AI预外呼结果',
  `ai_call_times` int DEFAULT NULL COMMENT 'ai拨打次数',
  `is_referral_ai_remind` tinyint DEFAULT '0' COMMENT '使用AI复诊提醒, 1表示使用0表示不使用,2表示取消',
  `is_referral_ai_abnormal` tinyint DEFAULT '0' COMMENT '使用AI复诊异常跟踪, 1表示使用0表示不使用,2表示取消',
  `referral_abnormal_time` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='随访任务AI记录表';

-- ----------------------------
-- Table structure for t_h_mission_attention
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_attention`;
CREATE TABLE `t_h_mission_attention` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `attention_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_mission_consult_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_consult_record`;
CREATE TABLE `t_h_mission_consult_record` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `relation_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务id',
  `operation_type` tinyint NOT NULL COMMENT '操作类型，1.线下处理，2.线上退回',
  `detail` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '协作处理详情',
  `attachments` text COLLATE utf8mb4_general_ci COMMENT '附件地址',
  `event_result` tinyint DEFAULT NULL COMMENT '事件结果状态，0.未解决，1.已解决',
  `operator_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人姓名',
  `operator_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人 id',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='咨询协同工单--处理记录';

-- ----------------------------
-- Table structure for t_h_mission_next_time
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_next_time`;
CREATE TABLE `t_h_mission_next_time` (
  `id` varchar(32) NOT NULL COMMENT '任务id',
  `next_date` date DEFAULT NULL COMMENT '下次沟通日期',
  `next_start_time` datetime DEFAULT NULL COMMENT '具体开始时间',
  `next_end_time` datetime DEFAULT NULL COMMENT '具体结束时间',
  `next_time` tinyint DEFAULT NULL COMMENT '下次沟通时间 1:上午 2:下午',
  PRIMARY KEY (`id`),
  KEY `t_h_mission_next_time_next_start_time_IDX` (`next_start_time`,`next_end_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='任务下次沟通时间';

-- ----------------------------
-- Table structure for t_h_mission_not_reported
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_not_reported`;
CREATE TABLE `t_h_mission_not_reported` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `editor_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_mission_postpone_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_postpone_log`;
CREATE TABLE `t_h_mission_postpone_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `user_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `postpone_day` int DEFAULT NULL,
  `mission_ids` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `original_task_time` datetime DEFAULT NULL COMMENT '原任务时间',
  `postpone_reason_code` varchar(4) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '原因 20：住院中 26：今日出院 32：当前患者门诊复诊  0:择期管理',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_mission_referral
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_referral`;
CREATE TABLE `t_h_mission_referral` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ID',
  `is_referral` tinyint DEFAULT '0' COMMENT '是否复诊（0，否  1，是）',
  `referral_dept_code` varchar(350) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复诊科室代码（逗号分隔拼接串）',
  `referral_plan_start_date` date DEFAULT NULL COMMENT '计划复诊有效开始时间',
  `referral_plan_date` date DEFAULT NULL COMMENT '计划复诊日期',
  `referral_plan_end_date` date DEFAULT NULL COMMENT '计划复诊有效截止时间',
  `referral_confirm_date` date DEFAULT NULL COMMENT '确认复诊日期',
  `referral_confirm_way` tinyint DEFAULT NULL COMMENT '复诊确认途径（1，系统确认  2，人工确认）',
  `referral_gather_desc` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复诊采集说明',
  `creator_source_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建来源:方案制定',
  `is_register` tinyint DEFAULT NULL COMMENT '是否挂号',
  `register_date` datetime DEFAULT NULL COMMENT '挂号时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='随访任务复诊记录表';

-- ----------------------------
-- Table structure for t_h_mission_remind_flag
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_remind_flag`;
CREATE TABLE `t_h_mission_remind_flag` (
  `mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `is_remind` int DEFAULT NULL COMMENT '0:不提醒',
  `update_time` datetime DEFAULT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`mission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_mission_star_question
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_star_question`;
CREATE TABLE `t_h_mission_star_question` (
  `id` varchar(32) NOT NULL,
  `mission_id` varchar(32) DEFAULT NULL,
  `pay_id` varchar(32) DEFAULT NULL,
  `question_ids` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_h_mission_star_question_mission_id_IDX` (`mission_id`) USING BTREE,
  KEY `t_h_mission_star_question_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='任务星号题目';

-- ----------------------------
-- Table structure for t_h_mission_status
-- ----------------------------
DROP TABLE IF EXISTS `t_h_mission_status`;
CREATE TABLE `t_h_mission_status` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'empiId',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划',
  `artificial_status` int DEFAULT '0' COMMENT '健管师完成状态',
  `artificial_visit_time` datetime DEFAULT NULL COMMENT '完成时间',
  `sms_send_status` int DEFAULT '0' COMMENT '短信完成状态',
  `sms_send_time` datetime DEFAULT NULL COMMENT '短信发送时间',
  `sms_reply_time` datetime DEFAULT NULL COMMENT '短信回复时间',
  `ai_push_status` int DEFAULT '0' COMMENT 'ai完成状态',
  `ai_push_time` datetime DEFAULT NULL COMMENT 'ai推送时间',
  `ai_reply_time` datetime DEFAULT NULL COMMENT 'ai回复时间',
  `applet_send_status` int DEFAULT '0' COMMENT '小程序发送状态',
  `applet_send_time` datetime DEFAULT NULL COMMENT '小程序发送时间',
  `applet_reply_time` datetime DEFAULT NULL COMMENT '小程序完成时间',
  `doctor_mobile_no` varchar(20) DEFAULT NULL,
  `doctor_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_model_category
-- ----------------------------
DROP TABLE IF EXISTS `t_h_model_category`;
CREATE TABLE `t_h_model_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '类别名称',
  `model_relation_type` int DEFAULT NULL COMMENT '1:管理记录模板 2：常用语模板 3：提醒模板 4：短信模板',
  `hosp_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_new_followup_mission
-- ----------------------------
DROP TABLE IF EXISTS `t_h_new_followup_mission`;
CREATE TABLE `t_h_new_followup_mission` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) COLLATE utf8mb4_general_ci NOT NULL COMMENT '机构代码',
  `goods_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品ID',
  `goods_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `plan_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划ID(计划表主键)',
  `plan_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划名称',
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `serial_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `plan_task_id` varchar(36) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则任务ID，如果是阶段性任务,则在planTaskId后面追加--数字',
  `relation_id` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `relation_type` int DEFAULT NULL COMMENT '关联类型(1专科随访  2患者管理  3慢病随访  4慢病管理  5随访抽查)',
  `relation_type_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联名称',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒时间',
  `revisit_plan_end_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒截止时间',
  `advance_send_time` int DEFAULT NULL COMMENT '提醒提前发送时间',
  `content_id` varchar(350) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒ID(","分隔，上限10个)',
  `content_title` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒标题(","分隔，上限10个)',
  `mission_prop` int DEFAULT NULL COMMENT '任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `mission_time_type` int DEFAULT NULL COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `mission_time_type_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务时间类型名称',
  `mission_type` int DEFAULT NULL COMMENT '任务类型(宣教: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒)',
  `mission_type_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务类型名称',
  `begin_time_type` int DEFAULT NULL COMMENT '任务开始时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后, 固定下拉字典表配置)',
  `begin_time_type_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务开始时间类型名称',
  `business_type` int DEFAULT NULL COMMENT '业务日期类型(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_type_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '业务日期类型名(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_date` date DEFAULT NULL COMMENT '基线日期',
  `valid_days` int DEFAULT NULL COMMENT '有效天数(天)',
  `remind_content` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '提醒内容',
  `plan_return_visit` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划回访方式',
  `followup_person_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员人ID',
  `followup_person_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员姓名',
  `followup_person_dept_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室代码',
  `followup_person_dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室名称',
  `return_visit_time` datetime DEFAULT NULL COMMENT '实际回访时间',
  `return_visit_type` int DEFAULT NULL COMMENT '实际回访方式(1:电话 2:APP/微信/短信)',
  `return_visit_type_name` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '实际回访方式名称',
  `revisit_status` int DEFAULT NULL COMMENT '随访状态(1:正常状态；2:无人接听；3:无法接通；4:关机；5:停机；6:死亡；7:家属接听(不了解情况)；8:拒绝；9:空号/电话错误；10:其他)',
  `revisit_result` int DEFAULT '0' COMMENT '随访结果(0:未完成 1:已完成 2:已结案)',
  `revisit_excp` int DEFAULT NULL COMMENT '随访结果异常标识(0:正常 1:异常)',
  `handling_opinion` varchar(300) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理意见',
  `app_send_status` int DEFAULT '0' COMMENT 'APP发送状态(0:未发送 -1未回复: 1:已回复)',
  `app_send_time` datetime DEFAULT NULL COMMENT 'APP发送时间',
  `app_reply_excp` int DEFAULT NULL COMMENT 'APP回复是否异常(0:否 1:是)',
  `plan_year` int DEFAULT NULL COMMENT '计划所属年份',
  `plan_month` int DEFAULT NULL COMMENT '计划所属月份',
  `followup_result` int DEFAULT NULL COMMENT '随访结果(统计)  1:电话完成 2:移动端完成 3:其他方式 （优先级：电话>移动端>其他）',
  `send_app_times` int DEFAULT '0' COMMENT '手动补发次数(记录手动发送的次数)',
  `remark` varchar(300) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `creator_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `group_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务组块ID',
  `auto_send_times` tinyint DEFAULT '0' COMMENT '自动发送次数',
  `revisit_send_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒发送时间',
  `task_source_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务来源',
  `is_delete` int DEFAULT NULL COMMENT '1:删除',
  `sort` int DEFAULT NULL COMMENT '随访任务排序',
  `last_revisit_excp` int DEFAULT NULL COMMENT '上一次随访结果异常标识(0:正常 1:异常)',
  `referral_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复诊父id',
  `creator_source_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建来源:方案制定',
  `deal_date` datetime DEFAULT NULL,
  `ai_call_times` int DEFAULT NULL COMMENT 'ai拨打次数',
  `temporary_status` tinyint DEFAULT '0' COMMENT '0：未暂存 1：暂存',
  `is_personalise_edu` int DEFAULT NULL COMMENT '个性化宣教任务 1：是',
  `mission_categories` int DEFAULT NULL COMMENT '任务类别;1、普通随访任务（默认）；2、处方任务',
  `channel_order` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `channel_order_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '渠道顺序0为微信公众号1微信小程序2交互机器人3app4ai电话5短信 6人工 多个用，隔开',
  `form_effective_time` int DEFAULT NULL COMMENT '表单有效时间 表单合并需要使用',
  `form_question_ids` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单的题目的id',
  `synch_flag` int DEFAULT NULL COMMENT '1、 正常（默认）、2 需要重新同步',
  `form_result` text COLLATE utf8mb4_general_ci COMMENT '表单答案',
  `yun_form_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '云端知识库的id',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `form_alias` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单别名',
  `form_cloud_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '云端知识库的id',
  `knowledge_task_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '知识库任务id',
  `task_target` varchar(5) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务对象，1.患者，2.健管师，逗号分隔',
  `track_type` tinyint DEFAULT NULL COMMENT '1.随访异常跟踪，2.咨询异常跟踪，3.预约挂号，99.其他',
  `creator_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `is_merged` tinyint DEFAULT '0' COMMENT '是否被合并，0.否，1.是',
  `submit_reason_type` tinyint DEFAULT '0' COMMENT '提交原因,0.正常提交，1.下次跟踪，2.患者不配合据',
  PRIMARY KEY (`id`),
  KEY `idx_pay_id` (`pay_id`),
  KEY `idx_empi_id_goods_id` (`empi_id`,`goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='随访任务表';

-- ----------------------------
-- Table structure for t_h_new_mode_inhosp_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_new_mode_inhosp_relation`;
CREATE TABLE `t_h_new_mode_inhosp_relation` (
  `pay_id` varchar(32) NOT NULL COMMENT '开单id',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '患者empiId',
  `is_serve_stage` tinyint DEFAULT '-1' COMMENT '新模式可服务阶段 -1:无法服务 0:可服务 1:已经服务',
  `inhosp_no` varchar(50) DEFAULT NULL COMMENT '住院号',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院时间',
  `inhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '住院流水号',
  `dept_code` varchar(50) DEFAULT NULL COMMENT '住院科室',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '住院科室',
  `discharge_diag_code` varchar(100) DEFAULT NULL COMMENT '出院诊断code',
  `discharge_diag_name` varchar(100) DEFAULT NULL COMMENT '出院诊断name',
  PRIMARY KEY (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='新模式住院信息关联表';

-- ----------------------------
-- Table structure for t_h_no_manage_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_h_no_manage_patient`;
CREATE TABLE `t_h_no_manage_patient` (
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_not_answer_call
-- ----------------------------
DROP TABLE IF EXISTS `t_h_not_answer_call`;
CREATE TABLE `t_h_not_answer_call` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键id',
  `call_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '通话记录id',
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者id',
  `patient_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者姓名',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院名称',
  `patient_mobile` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '通话号码',
  `start_time` datetime NOT NULL COMMENT '通话开始时间',
  `doc_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分配坐席',
  `reg_user` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '坐席号',
  `mobile_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者手机号',
  `plan_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `plan_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `order_open_dept_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单科室编码',
  `order_open_dept_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单科室名称',
  `team_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组名称',
  `manage_user` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '管理人员id',
  `manage_user_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '管理人员姓名',
  `followup_mission_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '随访任务id',
  `deal_status` tinyint NOT NULL COMMENT '处理状态，1-处理 0-未处理',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `source_type` tinyint DEFAULT '1' COMMENT '来源类型：1-服务中未接通，2-未服务验证成功',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品 id',
  `goods_name` varchar(32) DEFAULT NULL COMMENT '商品名称',
  `deal_method` tinyint DEFAULT NULL COMMENT '处理办法 1:移交个管师处理 2:接听组处理',
  `pay_patient_type` varchar(100) DEFAULT NULL COMMENT '患者类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_online_service
-- ----------------------------
DROP TABLE IF EXISTS `t_h_online_service`;
CREATE TABLE `t_h_online_service` (
  `hosp_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '路径(场景)id',
  `plan_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '路径(场景)名称',
  `dept` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `plan_followup` int DEFAULT '0',
  `in_followup` int DEFAULT '0',
  `out_followup` int DEFAULT '0',
  `close_service` int DEFAULT '0' COMMENT '结案人数',
  `in_recover` int DEFAULT '0' COMMENT '按时收案',
  `out_recover` int DEFAULT '0' COMMENT '超时收案',
  `in_close` int DEFAULT '0' COMMENT '按期结案',
  `out_close` int DEFAULT '0' COMMENT '超时结案',
  `real_mission` int DEFAULT '0',
  `real_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '真实姓名',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci NOT NULL,
  `service_date` date NOT NULL,
  `hosp_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  PRIMARY KEY (`hosp_code`,`plan_id`,`dept`,`user_name`,`service_date`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `service_date` (`service_date`) USING BTREE,
  KEY `user_name` (`user_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `t_h_order_refund`;
CREATE TABLE `t_h_order_refund` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `order_no` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '订单号',
  `pay_no` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '第三方订单号',
  `refund_no` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '退款单号',
  `refund_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '第三方-退款单号',
  `refund_status` int NOT NULL COMMENT '退款状态 1:退款中 2:退款成功 3:退款失败',
  `refund_amount` decimal(7,2) NOT NULL COMMENT '退款金额',
  `reason` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '退款原因',
  `refund_time` datetime DEFAULT NULL COMMENT '退款时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='退款订单';

-- ----------------------------
-- Table structure for t_h_pack_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pack_plan`;
CREATE TABLE `t_h_pack_plan` (
  `id` int NOT NULL,
  `plan_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划名称',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_pat_frequency
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pat_frequency`;
CREATE TABLE `t_h_pat_frequency` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `pat_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者id',
  `frequency_type` int NOT NULL COMMENT '类型',
  `frequency` int NOT NULL COMMENT '频次',
  `frequency_value` int NOT NULL DEFAULT '0' COMMENT '频次值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '创建人',
  `update_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '修改人',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者频次表';

-- ----------------------------
-- Table structure for t_h_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient`;
CREATE TABLE `t_h_patient` (
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '机构代码',
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构名称',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `is_seed` int DEFAULT NULL COMMENT '0:普通 1：种子',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '项目',
  `charge_item_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '项目名称',
  `service_flag` int DEFAULT NULL COMMENT '0:服务中 1：结束服务',
  `service_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务项目id',
  `service_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务项目名称',
  `service_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务描述',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划id',
  `plan_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划名称',
  `plan_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划描述',
  `wechat_status` int(1) unsigned zerofill DEFAULT NULL COMMENT '开通状态  1：开通',
  `smart_phone_flag` int DEFAULT NULL COMMENT '是否使用智能机 1:使用（默认：1）',
  `hug_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '蓝牛号',
  `add_wechat` tinyint(1) DEFAULT '0' COMMENT '添加企业微信 0 没有 1 添加',
  `pat_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者编码',
  `case_category_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者案例分类编码',
  `case_category_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者案例分类名称',
  `coordinate_status` tinyint(1) DEFAULT NULL COMMENT '1、 配合（默认）、0 不配合',
  `not_add_wechat_type` tinyint DEFAULT NULL COMMENT '未添加企业微信原因类型',
  `not_add_wechat_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '未添加企业微信原因',
  `binding_status` tinyint(1) DEFAULT NULL COMMENT '1、 绑定、0、其他未绑定',
  `patient_type` tinyint DEFAULT NULL COMMENT '1:服务患者 2:减重患者 9:多重患者',
  `frequency` tinyint(1) DEFAULT NULL COMMENT '点评频次 1：一天一次 6：一天6次',
  `is_confirm` tinyint(1) DEFAULT '0' COMMENT '确认标识，0：未确认，1：已确认',
  `is_start` tinyint(1) DEFAULT '0' COMMENT '开启标识，0：未开启，1：已开启',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '编辑时间',
  `personal_plan_url` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者个性化方案地址',
  `profession` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '职业',
  `educational_level` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '文化程度',
  `clan_beliefs` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宗教信仰',
  `start_time` timestamp NULL DEFAULT NULL COMMENT '患者开启管理时间',
  `ob_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'ob编号',
  `informed_consent_content` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '知情同意书',
  `address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '地址（连云港）',
  `case_category_date` timestamp NULL DEFAULT NULL COMMENT '患者案例分类时间',
  `sport_frequency` tinyint(1) DEFAULT NULL COMMENT '运动点评频次 -1：不点评 1：日点评 6：次点评',
  `mr_number` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '病案号',
  `age` int DEFAULT NULL COMMENT '年龄',
  `frequency_value` tinyint(1) DEFAULT '1' COMMENT '饮食日点评具体值',
  `frequency_update_time` datetime DEFAULT NULL COMMENT '点评频次修改时间',
  `pat_note` varchar(1200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `sport_frequency_update_time` datetime DEFAULT NULL COMMENT '运动点评频次修改时间（周点评七天内不可修改使用）',
  `case_category_level` tinyint(1) DEFAULT NULL COMMENT '案例分类等级 1：优 2：良 3：差 4：有意见',
  `goods_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '当前商品名称',
  `pause_date` date DEFAULT NULL COMMENT '最近一次暂停日期',
  `accumulate_pause_days` int DEFAULT NULL COMMENT '累计暂停天数',
  `encryption_name` varchar(32) DEFAULT NULL COMMENT '加密后的姓名',
  `encryption_id_number` varchar(32) DEFAULT NULL COMMENT '加密后的idNumber',
  `encryption_name_key` varchar(100) DEFAULT NULL COMMENT '加密后的姓名key',
  `encryption_id_number_key` varchar(100) DEFAULT NULL COMMENT '加密后的idNumberkey',
  `pat_index_no` varchar(100) DEFAULT NULL COMMENT '医院患者索引号',
  `latest_start_time` datetime DEFAULT NULL COMMENT '最近一次开启时间',
  PRIMARY KEY (`empi_id`) USING BTREE,
  KEY `mobile` (`mobile_no`) USING BTREE,
  KEY `hosp_code` (`hosp_code`(50)) USING BTREE,
  KEY `idx_hosp_code_empi_id` (`empi_id`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者案例分类时间';

-- ----------------------------
-- Table structure for t_h_patient_bu_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_bu_relation`;
CREATE TABLE `t_h_patient_bu_relation` (
  `pay_id` varchar(32) NOT NULL,
  `bu_relation_type` tinyint DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `biz_bu_relation_type` tinyint DEFAULT NULL COMMENT '业务bu线类型 1妇产BU、2 骨科BU、3 消化系统BU、4护理中心BU、5 心血管肿瘤BU、6 TLC内分泌BU 7 心理BU 8 规范化BU',
  `is_biz_change` tinyint DEFAULT '0' COMMENT '是否业务改动 1:是 0:否',
  PRIMARY KEY (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_patient_class_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_class_record`;
CREATE TABLE `t_h_patient_class_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者主索引',
  `hosp_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '机构代码',
  `class_stage_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '分类阶段编码',
  `class_stage_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分类阶段名称',
  `class_level` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '分类等级',
  `create_time` datetime DEFAULT NULL,
  `is_new` int DEFAULT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `editor_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务主键id',
  `class_type_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分类类型名称',
  `class_type_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分类类型',
  `class_type_field_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分类领域编码',
  `class_type_field_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分类领域',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_coach_apply_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_coach_apply_record`;
CREATE TABLE `t_h_patient_coach_apply_record` (
  `id` varchar(32) NOT NULL,
  `pay_id` varchar(32) NOT NULL COMMENT '开单id',
  `mission_id` varchar(32) NOT NULL COMMENT '使用了pio的任务id',
  `knowledge_content_id` varchar(32) NOT NULL COMMENT '知识库内容 id',
  `knowledge_id` varchar(32) NOT NULL COMMENT '知识库主表 id',
  `label_code` varchar(100) NOT NULL COMMENT '标签编码',
  `label_name` varchar(100) NOT NULL COMMENT '标签名称',
  `question_id` varchar(32) NOT NULL COMMENT '问卷题目 id',
  `key_point_id` varchar(32) NOT NULL COMMENT '关联要点表的 id',
  `key_point_title` varchar(100) NOT NULL COMMENT '要点的标题',
  `education_ids` varchar(320) DEFAULT NULL COMMENT '关联宣教 id',
  `education_names` varchar(500) DEFAULT NULL COMMENT '关联宣教名称',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人 id',
  `creator_name` varchar(100) DEFAULT NULL COMMENT '创建人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='健康教练知识库-患者应用记录';

-- ----------------------------
-- Table structure for t_h_patient_configuration
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_configuration`;
CREATE TABLE `t_h_patient_configuration` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包id',
  `title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标题',
  `url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务项目的url',
  `sort` int DEFAULT NULL COMMENT '排序值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_connotation_num
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_connotation_num`;
CREATE TABLE `t_h_patient_connotation_num` (
  `id` varchar(32) NOT NULL,
  `package_connotation_id` varchar(32) DEFAULT NULL COMMENT '内涵主键id',
  `manage_prescription_code` varchar(2) DEFAULT NULL COMMENT '处方类型 0综合、1疾病（含指标）、2护理（伤口，管道 含戒烟戒酒）、3饮食、4运动、5用药、6复诊、7睡眠',
  `manage_means_type` varchar(2) DEFAULT NULL COMMENT '手段类型',
  `manage_compare_type` varchar(2) DEFAULT NULL COMMENT '比较类型',
  `manage_num` tinyint DEFAULT NULL COMMENT '次数',
  `manage_unit` varchar(2) DEFAULT NULL COMMENT '单位 1：次；2:天',
  `manage_connotation_type` varchar(100) DEFAULT NULL COMMENT '具体内涵方式类型 逗号隔开 1服务管理路径、2PIO问卷/专病档案/自评表单、3体成分分析等测量、4智能居家设备、5管理方案-A版（营养食谱/饮食建议）、6管理方案-B版（饮食方案+食谱+打卡）、7点评、8宣教/提醒/补充话术、9异常跟踪、10小程序/电话咨询、11企微咨询、12管理记录/soap报告/周报月报/结案小结、13报告解读',
  `manage_connotation_name` varchar(200) DEFAULT NULL COMMENT '具体内涵方式名称',
  `update_time` datetime DEFAULT NULL,
  `sort` tinyint DEFAULT NULL COMMENT '排序',
  `empi_id` varchar(32) NOT NULL,
  `pay_id` varchar(32) NOT NULL,
  `actual_manage_num` int DEFAULT NULL COMMENT '实际管理次数',
  `is_delete` tinyint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `no_verify_flag` tinyint DEFAULT '0' COMMENT '1:无需入组校验',
  PRIMARY KEY (`id`),
  KEY `t_h_patient_connotation_num_pay_id_IDX` (`pay_id`) USING BTREE,
  KEY `t_h_patient_connotation_num_empi_id_IDX` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者内涵计数表';

-- ----------------------------
-- Table structure for t_h_patient_connotation_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_connotation_record`;
CREATE TABLE `t_h_patient_connotation_record` (
  `id` varchar(32) NOT NULL,
  `manage_prescription_code` varchar(2) DEFAULT NULL COMMENT '处方类型 0综合、1疾病（含指标）、2护理（伤口，管道 含戒烟戒酒）、3饮食、4运动、5用药、6复诊、7睡眠',
  `manage_means_type` varchar(2) DEFAULT NULL COMMENT '手段类型',
  `manage_connotation_type` varchar(100) DEFAULT NULL COMMENT '具体内涵方式类型 逗号隔开 1服务管理路径、2PIO问卷/专病档案/自评表单、3体成分分析等测量、4智能居家设备、5管理方案-A版（营养食谱/饮食建议）、6管理方案-B版（饮食方案+食谱+打卡）、7点评、8宣教/提醒/补充话术、9异常跟踪、10小程序/电话咨询、11企微咨询、12管理记录/soap报告/周报月报/结案小结、13报告解读',
  `manage_connotation_name` varchar(200) DEFAULT NULL COMMENT '具体内涵方式名称',
  `create_time` datetime DEFAULT NULL,
  `empi_id` varchar(32) NOT NULL,
  `pay_id` varchar(32) NOT NULL COMMENT '开单id',
  `is_delete` tinyint DEFAULT NULL,
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联id',
  `execute_time` datetime DEFAULT NULL COMMENT '记录执行时间',
  `execute_way` varchar(10) DEFAULT NULL COMMENT '执行方式',
  `execute_desc` varchar(500) DEFAULT NULL COMMENT '执行情况',
  `manage_prescription_name` varchar(20) DEFAULT NULL COMMENT '处方类型名称 0综合、1疾病（含指标）、2护理（伤口，管道 含戒烟戒酒）、3饮食、4运动、5用药、6复诊、7睡眠',
  `manage_means_name` varchar(20) DEFAULT NULL COMMENT '手段类型名称',
  PRIMARY KEY (`id`),
  KEY `t_h_patient_connotation_record_empi_id_IDX` (`empi_id`) USING BTREE,
  KEY `t_h_patient_connotation_record_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者内涵记录表';

-- ----------------------------
-- Table structure for t_h_patient_connotation_sort
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_connotation_sort`;
CREATE TABLE `t_h_patient_connotation_sort` (
  `id` varchar(32) NOT NULL,
  `pay_id` varchar(32) NOT NULL,
  `package_connotation_id` varchar(32) NOT NULL,
  `prescription_type_sort` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_h_patient_connotation_sort_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_patient_delete_education
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_delete_education`;
CREATE TABLE `t_h_patient_delete_education` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '单子 id',
  `education_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣教名称',
  `education_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '宣教 id',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者收案时，选中删除的宣教';

-- ----------------------------
-- Table structure for t_h_patient_disease_risk
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_disease_risk`;
CREATE TABLE `t_h_patient_disease_risk` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `disease_risk_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `editor_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_h_patient_disease_risk_pat_id_IDX` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_patient_drug_match_info
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_drug_match_info`;
CREATE TABLE `t_h_patient_drug_match_info` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单ID',
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'empi_id',
  `hosp_code` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `drug_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '药品名称',
  `once_dosage` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '一次用量',
  `medication_way` tinyint DEFAULT NULL COMMENT '服药方式 1.口服 2.外用 3.皮下注射 4.舌下含服 5.咀嚼',
  `medication_requirement` tinyint DEFAULT NULL COMMENT '服药要求 1.空腹 2.餐前 3.餐后',
  `medication_frequency` tinyint DEFAULT NULL COMMENT '用药频率 1每晨一次 2每日一次 3每日两次 4每日三次 5每日四次 6睡前服用 7每6小时一次 8每8小时一次 9每12小时一次',
  `workflow_run_id` varchar(36) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '匹配工作流运行ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_patient_drug_remind
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_drug_remind`;
CREATE TABLE `t_h_patient_drug_remind` (
  `id` varchar(32) NOT NULL COMMENT 'id',
  `pay_id` varchar(32) DEFAULT NULL COMMENT '开单id',
  `empi_id` varchar(32) DEFAULT NULL COMMENT 'empiId',
  `drug_name` varchar(100) DEFAULT NULL COMMENT '药品名称',
  `medications_timing` varchar(50) DEFAULT NULL COMMENT '用药时间 ex:08:00,12:30',
  `once_dosage` varchar(20) DEFAULT NULL COMMENT '一次用量',
  `medication_way` tinyint DEFAULT NULL COMMENT '服药方式 1.口服 2.外用 3.皮下注射 4.舌下含服 5.咀嚼',
  `medication_requirement` tinyint DEFAULT NULL COMMENT '服药要求 1.空腹 2.餐前 3.餐后',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `staging_status` tinyint DEFAULT NULL COMMENT '暂存状态 1:暂存数据',
  `medication_frequency` tinyint DEFAULT NULL COMMENT '用药频率 1每晨一次 2每日一次 3每日两次 4每日三次 5每日四次 6睡前服用 7每6小时一次 8每8小时一次 9每12小时一次',
  `is_send` tinyint DEFAULT NULL COMMENT '是否发送 1:已发送',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) DEFAULT NULL,
  `editor_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_h_patient_drug_remind_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者用药提醒';

-- ----------------------------
-- Table structure for t_h_patient_edu_combination_sms
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_edu_combination_sms`;
CREATE TABLE `t_h_patient_edu_combination_sms` (
  `id` varchar(32) NOT NULL,
  `pay_id` varchar(32) DEFAULT NULL COMMENT '开单id',
  `create_time` datetime DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL COMMENT '删除标记 1:已删除',
  `edu_combination_url` varchar(255) DEFAULT NULL COMMENT '宣教组合短链接',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '机构代码',
  `edu_record_ids` varchar(500) DEFAULT NULL COMMENT '宣教记录id主键',
  `mission_id` varchar(32) DEFAULT NULL COMMENT '任务id',
  PRIMARY KEY (`id`),
  KEY `t_h_patient_edu_combination_sms_edu_combination_url_IDX` (`edu_combination_url`) USING BTREE,
  KEY `t_h_patient_edu_combination_sms_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者宣教组合短信表';

-- ----------------------------
-- Table structure for t_h_patient_edu_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_edu_record`;
CREATE TABLE `t_h_patient_edu_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `pat_edu_thematic_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者专题包id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者empiId',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  `edu_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教id',
  `edu_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教名称',
  `is_read` tinyint DEFAULT NULL COMMENT '阅读标志 1:已阅读 0:未阅读',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `pat_edu_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者宣教短链接',
  `is_delete` tinyint DEFAULT NULL COMMENT '删除标志 1:删除',
  `cover_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '封面',
  `rule_task_use_status` tinyint DEFAULT NULL COMMENT '专题包任务使用状态：1使用,0未使用',
  `label_codes` varchar(300) DEFAULT NULL COMMENT '标签code',
  `label_names` varchar(300) DEFAULT NULL COMMENT '标签name',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_pay_url` (`pay_id`,`edu_id`,`is_delete`) USING BTREE,
  KEY `idx_empi` (`empi_id`) USING BTREE,
  KEY `idx_thematic_id` (`pat_edu_thematic_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_patient_edu_thematic
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_edu_thematic`;
CREATE TABLE `t_h_patient_edu_thematic` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者empiId',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `is_send` tinyint DEFAULT NULL COMMENT '专题包发送标志 1:已发送',
  `create_time` datetime DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL COMMENT '删除标记 1:已删除',
  `sent_flag` tinyint DEFAULT NULL COMMENT '历史短信发送标识 1：已发过',
  `edu_thematic_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专题包短链接',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_pay_id` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_patient_electronic_medicine
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_electronic_medicine`;
CREATE TABLE `t_h_patient_electronic_medicine` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键的id',
  `medicine_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '电子药的id',
  `is_activate` int DEFAULT NULL COMMENT '激活状态 1、激活',
  `activate_time` datetime DEFAULT NULL COMMENT '激活时间、开始有效时间',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户的id',
  `pat_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户的姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `is_delete` int DEFAULT NULL COMMENT '删除标记',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_health_info
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_health_info`;
CREATE TABLE `t_h_patient_health_info` (
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `init_weight` decimal(8,2) DEFAULT NULL COMMENT '初始体重',
  `current_weight` decimal(8,2) DEFAULT NULL COMMENT '当前体重',
  `target_weight` decimal(8,2) DEFAULT NULL COMMENT '目标体重',
  `init_height` decimal(8,2) DEFAULT NULL COMMENT '初始身高',
  `current_height` decimal(8,2) DEFAULT NULL COMMENT '当前身高',
  `init_neck_circum` decimal(8,2) DEFAULT NULL COMMENT '初始颈围',
  `neck_circum` decimal(8,2) DEFAULT NULL COMMENT '当前颈围',
  `init_waist_circum` decimal(8,2) DEFAULT NULL COMMENT '初始腰围',
  `waist_circum` decimal(8,2) DEFAULT NULL COMMENT '当前腰围',
  `init_hip_circum` decimal(8,2) DEFAULT NULL COMMENT '初始臀围',
  `hip_circum` decimal(8,2) DEFAULT NULL COMMENT '当前臀围',
  `pregnant_flag` tinyint DEFAULT '0' COMMENT '是否怀孕 0 没有 1有',
  `pregnant_time` datetime DEFAULT NULL COMMENT '怀孕时间',
  `update_time` datetime DEFAULT NULL,
  `diastolic_pressure` int DEFAULT NULL COMMENT '舒张压',
  `systolic_pressure` int DEFAULT NULL COMMENT '收缩压',
  `resting_heart_rate` tinyint DEFAULT NULL COMMENT '静息心率',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `bmi` decimal(8,1) DEFAULT NULL COMMENT 'BMI',
  `body_fat_per` decimal(8,0) DEFAULT NULL COMMENT '体脂率',
  `waist_to_hip_ratio` decimal(8,0) DEFAULT NULL COMMENT '腰臀比',
  `basal_metabolic_rate` decimal(8,0) DEFAULT NULL COMMENT '基础代谢率',
  `body_mass_index` decimal(8,0) DEFAULT NULL COMMENT '健康评估',
  `muscle_kg` decimal(8,0) DEFAULT NULL COMMENT '肌肉量',
  `body_fat` decimal(8,0) DEFAULT NULL COMMENT '体脂肪',
  `visceral_fat_kg` decimal(8,0) DEFAULT NULL COMMENT '内脏脂肪',
  `skeletal_muscle` decimal(8,0) DEFAULT NULL COMMENT '骨骼肌',
  `fat_control` decimal(8,0) DEFAULT NULL COMMENT '脂肪控制',
  `muscle_control` decimal(8,0) DEFAULT NULL COMMENT '肌肉控制',
  `body_composition_report` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '体成分报告',
  `front_side_photo` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '正侧面照片',
  `health_score` decimal(8,0) DEFAULT NULL COMMENT '体成分报告',
  `lean_body_mass` decimal(8,0) DEFAULT NULL COMMENT '正侧面照片',
  `pat_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者中心id',
  `abdomen_subcutaneous_fat` decimal(8,2) DEFAULT NULL COMMENT '皮下脂肪',
  PRIMARY KEY (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='创建时间';

-- ----------------------------
-- Table structure for t_h_patient_health_sign
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_health_sign`;
CREATE TABLE `t_h_patient_health_sign` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲任务ID',
  `blood_pressure_sign` int DEFAULT NULL COMMENT '血压标记',
  `blood_glucose_sign` int DEFAULT NULL COMMENT '血糖标记',
  `weight_sign` int DEFAULT NULL COMMENT '体重标记',
  `scheme_switch` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '个性化方案开关 0 关闭 1 开启',
  `pulse_sign` int DEFAULT NULL COMMENT '脉搏',
  `is_complete` tinyint(1) DEFAULT '0' COMMENT '是否完成 0否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_hosp_personalize_form
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_hosp_personalize_form`;
CREATE TABLE `t_h_patient_hosp_personalize_form` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '医院编码',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '开单 id',
  `goods_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品id',
  `form_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单id',
  `form_title` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单标题',
  `form_sort` tinyint DEFAULT NULL COMMENT '表单排序',
  `mission_fill_flag` tinyint DEFAULT NULL COMMENT '任务是否填写标志',
  `mission_sort` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务排序',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `editor_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者版医院个性化表单';

-- ----------------------------
-- Table structure for t_h_patient_hosp_personalize_form_question
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_hosp_personalize_form_question`;
CREATE TABLE `t_h_patient_hosp_personalize_form_question` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'id',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '开单 id',
  `relation_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '关联id',
  `form_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单formId',
  `question_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '题目ID',
  `question_title` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '题目名称',
  `child_question_ids` varchar(320) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子题目id',
  `question_sort` tinyint DEFAULT NULL COMMENT '题目排序',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者版医院个性化表单题目';

-- ----------------------------
-- Table structure for t_h_patient_indicator_monitor_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_indicator_monitor_log`;
CREATE TABLE `t_h_patient_indicator_monitor_log` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `pay_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单记录 id',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作内容',
  `creator_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人 id',
  `creator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者指标监测开关操作记录表';

-- ----------------------------
-- Table structure for t_h_patient_information_configuration
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_information_configuration`;
CREATE TABLE `t_h_patient_information_configuration` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包',
  `title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标题',
  `url` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '页面url',
  `sort` int DEFAULT NULL COMMENT '排序值 1--n',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_label
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_label`;
CREATE TABLE `t_h_patient_label` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '医院编码',
  `empi_id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'empiId',
  `pat_index_no` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院患者索引号',
  `inhosp_no` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院号',
  `inhosp_serial_no` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院流水号',
  `outhosp_no` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '门诊流水号',
  `label_type` tinyint(1) DEFAULT NULL COMMENT '0-默认',
  `label_code` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标签编码',
  `label_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '标签名称',
  `is_delete` tinyint(1) unsigned zerofill NOT NULL DEFAULT '0' COMMENT '是否可删除 ： 0 否   1是   默认 0',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `surgery_begin_date` datetime DEFAULT NULL COMMENT '手术开始日期',
  `surgery_end_date` datetime DEFAULT NULL COMMENT '手术结束日期',
  `surgery_label_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术标签名',
  `refuse_reason` tinyint(1) DEFAULT NULL COMMENT '不推荐原因 1:医护家属 2:病情严重 3:经济不佳 4:其他',
  `remark` varchar(500) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `pat_mark` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者标识 MD5(身份证姓名)',
  `close_time` datetime DEFAULT NULL COMMENT '结案时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_hosp_code` (`hosp_code`) USING BTREE,
  KEY `idx_pat_index_no` (`pat_index_no`) USING BTREE,
  KEY `idx_inhosp_serial_no` (`inhosp_serial_no`) USING BTREE,
  KEY `idx_outhosp_serial_no` (`outhosp_serial_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='患者标签表';

-- ----------------------------
-- Table structure for t_h_patient_manage_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_manage_record`;
CREATE TABLE `t_h_patient_manage_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `type` int DEFAULT NULL COMMENT '类型，1, 随访任务;2, 宣教任务,3, 提醒任务 等等',
  `type_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `manage_model_id` int DEFAULT NULL COMMENT '模板id',
  `manage_model_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模板name',
  `manage_time` datetime DEFAULT NULL COMMENT '管理时间，可能带时分秒 也可能不带',
  `manage_content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '管理内容，包括类型',
  `run_type` int DEFAULT NULL COMMENT '运行类型',
  `execute_user` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '执行人 可以是AI,微信等等',
  `execute_status` int DEFAULT NULL COMMENT '执行的状态   1已回复 -1未回复',
  `is_exception` int DEFAULT NULL COMMENT '患者是否有异常情况',
  `update_time` datetime DEFAULT NULL,
  `is_delete` int DEFAULT NULL COMMENT '是否删除标识 0 正常 1删除状态',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id 开单主键、宣讲内容主键、方案制定主键、任务主键',
  `pay_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单id',
  `manage_content_htm` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `create_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `img_url` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片地址',
  `call_reason` varchar(100) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者咨询原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_mobile
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_mobile`;
CREATE TABLE `t_h_patient_mobile` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主索引号',
  `contacts` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '联系人',
  `relation` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '与患者关系(系统字典表取值: 本人/父亲/母亲/配偶/儿子/女儿/同事/秘书/其他)',
  `mobile_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '电话号码',
  `source` int DEFAULT NULL COMMENT '号码来源(1:院内记录 2:手动维护)',
  `status` int DEFAULT NULL COMMENT '启用状态(1:启用 0:未启用)',
  `is_smart_phone` tinyint DEFAULT NULL COMMENT '是否使用智能机 0非 1是',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `sex_code` int DEFAULT NULL COMMENT '性别代码(1:男 2:女 9:其他)',
  `birthdate` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出生日期',
  `language` int DEFAULT NULL COMMENT '语言(1:普通话 2:方言 3:外语)',
  `remark` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `invalid_flag` int DEFAULT '0' COMMENT '无效标识 1：无效',
  `create_name` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建者',
  `editor_name` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑者',
  `is_informed` tinyint(1) DEFAULT NULL COMMENT '是否知情 0-否 1-是',
  `is_sms_auth` tinyint(1) DEFAULT '0' COMMENT '是否短信认证 0-否 1-是',
  `not_auth_type` tinyint(1) DEFAULT '0' COMMENT '无法验证原因 0-默认 1-联系人不在现场 2-医生代宣讲 3-患者已出院 4-群体宣教 5-其他',
  `not_auth_reason` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '无法验证原因备注',
  `is_send` tinyint DEFAULT '0' COMMENT '发送号码标志 1:是',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_patient_mobile_uq` (`hosp_code`,`empi_id`,`mobile_no`) USING BTREE,
  KEY `t_h_patient_mobile_mobile_no_IDX` (`mobile_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者电话号码维护表';

-- ----------------------------
-- Table structure for t_h_patient_mobile_verify
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_mobile_verify`;
CREATE TABLE `t_h_patient_mobile_verify` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院编码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者empiId',
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '手机号',
  `verify_code` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '验证码',
  `verify_status` int DEFAULT '0' COMMENT '检验状态 0-已发送 1-已检验',
  `verify_count` int DEFAULT '0' COMMENT '检验次数',
  `operate_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人id',
  `operate_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人name',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者手机号认证表';

-- ----------------------------
-- Table structure for t_h_patient_name_warn_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_name_warn_log`;
CREATE TABLE `t_h_patient_name_warn_log` (
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pat_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_pio_measure
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_pio_measure`;
CREATE TABLE `t_h_patient_pio_measure` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `patient_pio_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者pioId',
  `measure_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理措施id',
  `measure_title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理措施',
  `measure_priority` tinyint DEFAULT NULL COMMENT '措施优先级',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '教练表单id',
  `form_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '教练表单名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `personal_measure_detail` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '个性化详情',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `completion_status` tinyint(1) DEFAULT '0' COMMENT '映射机构代码',
  `edit_mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑任务id',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_patient_pio_measure_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_pio_measure_detail`;
CREATE TABLE `t_h_patient_pio_measure_detail` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `mission_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `empi_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `personal_measure_detail` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '个性化详情',
  `measure_title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `measure_priority` tinyint DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_patient_pio_measure_detail_bak
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_pio_measure_detail_bak`;
CREATE TABLE `t_h_patient_pio_measure_detail_bak` (
  `mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `personal_measure_detail` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '个性化详情',
  PRIMARY KEY (`mission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_patient_pio_measure_education
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_pio_measure_education`;
CREATE TABLE `t_h_patient_pio_measure_education` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `mission_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务id',
  `measure_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '措施id',
  `education_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教id',
  `education_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教名称',
  `is_send_edu` tinyint DEFAULT NULL COMMENT '1.发送，0.不发送',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者措施关联宣教表';

-- ----------------------------
-- Table structure for t_h_patient_pio_question
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_pio_question`;
CREATE TABLE `t_h_patient_pio_question` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `pio_rule_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'pio规则主键',
  `diag_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病编码',
  `diag_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病名称',
  `label_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用标签代码',
  `label_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用标签名称',
  `priority` tinyint DEFAULT NULL COMMENT '问题优先级',
  `followup_sort` tinyint DEFAULT NULL COMMENT '随访排序',
  `question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理问题id',
  `question_title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理问题名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '边际人',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `pio_rule_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '规则名称',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pat` (`empi_id`,`plan_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_patient_placeholder
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_placeholder`;
CREATE TABLE `t_h_patient_placeholder` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `serve_placeholder_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '占位符主键id',
  `patient_module_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者模块id',
  `shape_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '占位符名称：${患者姓名}',
  `is_delete` int DEFAULT NULL,
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `record` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '记录内容',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_plan`;
CREATE TABLE `t_h_patient_plan` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主索引id',
  `service_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务id',
  `plan_id` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划id',
  `plan_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划名称',
  `is_close` int DEFAULT NULL COMMENT '是否关闭 0正常 1标识关闭',
  `is_delete` int DEFAULT NULL COMMENT '是否删除 0 正常 1删除状态',
  `update_time` datetime DEFAULT NULL COMMENT '创建/修改时间',
  `creator_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人（随访端）',
  `followup_person_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '随访人（随访端）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `t_h_patient_plan_empi_id_IDX` (`empi_id`) USING BTREE,
  KEY `t_h_patient_plan_service_id_IDX` (`service_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_plan_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_plan_record`;
CREATE TABLE `t_h_patient_plan_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者id',
  `new_goods_id` char(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '新计划id',
  `new_goods_name` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '新计划名称',
  `old_goods_id` char(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '旧计划id',
  `old_goods_name` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '旧计划名称',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_preach
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_preach`;
CREATE TABLE `t_h_patient_preach` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'pay_patients主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者主索引',
  `hosp_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '机构代码',
  `desc` varchar(800) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)名称',
  `dept_codes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室名称',
  `diag_codes` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病编码',
  `diag_names` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病名称',
  `preach_status` tinyint(1) DEFAULT '0' COMMENT '宣讲状态 0未宣讲 1已宣讲',
  `is_delete` int DEFAULT NULL COMMENT '删除标志1删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `informed_consent_content` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '知情同意书图片',
  `education_url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲url',
  `new_pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '最新路径(场景)id',
  `new_pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '最新路径(场景)名称',
  `path_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `service_package_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `preach_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲人id',
  `preach_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲人名称',
  `preach_finish_time` datetime DEFAULT NULL COMMENT '宣讲完成时间',
  `referral_collection_flag` int DEFAULT NULL COMMENT '是否采集复诊 0：否 1：是',
  `is_on_time` int DEFAULT NULL COMMENT '是否按时宣讲 0：否 1：是',
  `banding_inhosp_flag` tinyint(1) DEFAULT NULL COMMENT '是否管理住院记录',
  `service_term` tinyint DEFAULT NULL COMMENT '服务期限',
  `recall_type` tinyint DEFAULT NULL COMMENT '1 线上 2 线下',
  `recall_time` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '撤回日期',
  `recall_reason` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '撤回理由',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品goodsId',
  `goods_name` varchar(100) COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `hosp_pay` (`pay_id`,`hosp_code`,`is_delete`) USING BTREE,
  KEY `empi_id` (`empi_id`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `idx_pay_id` (`pay_id`) USING BTREE,
  KEY `finish_time` (`preach_finish_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_preach_merge
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_preach_merge`;
CREATE TABLE `t_h_patient_preach_merge` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pay_ids` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_preach_recall_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_preach_recall_log`;
CREATE TABLE `t_h_patient_preach_recall_log` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_preach_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '宣讲id',
  `recall_type` tinyint(1) DEFAULT NULL COMMENT '撤回类型 1 线下撤回 2 线上退回',
  `recall_reason` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '撤回理由',
  `recall_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '撤回时间',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '撤回操作人员',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='宣讲退回记录';

-- ----------------------------
-- Table structure for t_h_patient_preach_task
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_preach_task`;
CREATE TABLE `t_h_patient_preach_task` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'pay_patients主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者主索引',
  `hosp_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '机构代码',
  `order_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单编号signing',
  `sign_status` tinyint(1) DEFAULT NULL COMMENT '签约状态：1.完成签约',
  `desc` varchar(800) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)名称',
  `dept_codes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室名称',
  `diag_codes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病编码',
  `diag_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病名称',
  `preach_status` tinyint(1) DEFAULT '0' COMMENT '宣讲状态 0未宣讲 1已宣讲2宣讲中3取消宣讲',
  `is_delete` int DEFAULT NULL COMMENT '删除标志，1删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `informed_consent_content` varchar(5000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '知情同意书图片',
  `education_url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲url',
  `new_pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '最新路径(场景)id',
  `new_pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '最新路径(场景)名称',
  `path_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务管理（静态）0  ；数疗管理（妊糖）1 ；减重管理（减重）2 ；服务数疗（动态）3',
  `service_package_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包的id',
  `preach_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲人id',
  `preach_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲人名称',
  `preach_finish_time` datetime DEFAULT NULL COMMENT '宣讲完成时间',
  `referral_collection_flag` int DEFAULT NULL COMMENT '是否采集复诊 0：否 1：是',
  `is_on_time` int DEFAULT NULL COMMENT '是否按时宣讲 0：否 1：是',
  `banding_inhosp_flag` tinyint(1) DEFAULT NULL COMMENT '是否管理住院记录',
  `service_term` tinyint DEFAULT NULL COMMENT '服务期限',
  `recall_type` tinyint DEFAULT NULL COMMENT '1 线上 2 线下',
  `recall_time` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '撤回日期',
  `recall_reason` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '撤回理由',
  `inhosp_no` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院号',
  `inhosp_serial_no` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院流水号',
  `outhosp_no` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '门诊流水号',
  `pat_source` int DEFAULT NULL COMMENT '患者来源 1-门诊 2-住院 3-体检',
  `preach_type` int DEFAULT NULL COMMENT '宣讲类型 0-先宣讲，后开单 1-先开单，后宣讲',
  `ward_codes` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '病区编码',
  `ward_names` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '病区名称',
  `bed_no` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '床号',
  `inhosp_time` datetime DEFAULT NULL COMMENT '入院时间',
  `pat_name` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者姓名',
  `process_time` datetime DEFAULT NULL COMMENT '处理时间',
  `mobile_no` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '联系方式',
  `sex_code` int DEFAULT NULL COMMENT '性别',
  `pat_index_no` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引号',
  `termination_type` tinyint DEFAULT NULL COMMENT '终止宣讲原因类型 1服务内容相关 2费用相关 3随诊相关 4其他',
  `termination_reason` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '终止宣讲原因',
  `termination_remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '终止宣讲备注',
  `staging_information` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '暂存信息',
  `rule_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '规则id',
  `rule_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '规则名称',
  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务备注',
  `self_mobile` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '本人手机号',
  `service_package_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包名称',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '身份证号码',
  `source_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者来源（1:门诊 2:出院 3:在院）',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `is_refund` int DEFAULT '0' COMMENT '退费标志(0未退费 1:已退费)',
  `preach_name_letter` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲人名称全拼',
  `attend_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主治医生工号',
  `attend_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主治医生名称',
  `is_cancel` tinyint(1) DEFAULT '0' COMMENT '取消状态(工单) 0：未取消 1：已取消 ',
  `weight_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者营养学科记录表 id',
  `outhosp_time` datetime DEFAULT NULL COMMENT '出院时间',
  `voice_level` tinyint(1) DEFAULT '0' COMMENT '所含录音等级 1:一般录音 2:优质录音 0:未分类',
  `voice_time` int DEFAULT '0' COMMENT '录音时长',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `is_effective` tinyint(1) DEFAULT '0' COMMENT '是否为有效宣讲 0: 否 1:是',
  `address_state` tinyint(1) DEFAULT NULL COMMENT '现居地情况 0:管辖区 1:非管辖区',
  `address_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者地址id',
  `countryside_name` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '区域name',
  `street` int DEFAULT NULL COMMENT '现居地 街道code',
  `street_name` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '现居地 街道name',
  `goods_id` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务商品主id',
  `goods_version_id` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务商品版本id',
  `goods_name` varchar(128) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品名称',
  `repeat_flag` tinyint DEFAULT '0' COMMENT '是否可以收案 0非 1是',
  `exception_status` tinyint(1) DEFAULT NULL COMMENT '异常情况 0:异常 1:正常',
  `exception_flag` int DEFAULT NULL,
  `offline_new_mode` tinyint(1) DEFAULT '0' COMMENT '线下新模式 0-否 1-是',
  `is_informed_wechat` tinyint(1) DEFAULT NULL COMMENT '赢效小程序知情同意书是否同意 0-否 1-是',
  `informed_wechat_time` datetime DEFAULT NULL COMMENT '赢效小程序知情同意书是否同意时间',
  `goods_exception_flag` tinyint(1) DEFAULT '0' COMMENT '费用异常 0-否 1-是',
  `informed_flag` tinyint(1) DEFAULT NULL COMMENT '知情同意书生成成功 0-否 1-是',
  `informed_consent_content_his` varchar(5000) COLLATE utf8mb3_bin DEFAULT '0' COMMENT '知情同意书备份',
  `informed_send_flag` tinyint(1) DEFAULT '0' COMMENT '知情同意书是否下发 0-否 1-是 2-已下发',
  `goods_price_id` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务商品物价id',
  `goods_price_name` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务商品物价name',
  `is_qw` tinyint(1) DEFAULT '0' COMMENT '是否企微签署 0-否 1-是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `empi_id` (`empi_id`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `idx_pay_id` (`pay_id`) USING BTREE,
  KEY `finish_time` (`preach_finish_time`) USING BTREE,
  KEY `idx_order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='宣讲任务';

-- ----------------------------
-- Table structure for t_h_patient_preach_voice
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_preach_voice`;
CREATE TABLE `t_h_patient_preach_voice` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '宣讲任务主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者empid',
  `preach_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲人id',
  `voice_url` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '宣讲内容地址',
  `remark` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者姓名',
  `preach_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲人姓名',
  `id_number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者身份证号码',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院流水号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '门诊流水号',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '就诊卡号',
  `voice_flag` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT '1' COMMENT '录音有效标识（0-失效，1-有效）',
  `voice_start_time` datetime DEFAULT NULL COMMENT '录音开始时间',
  `voice_end_time` datetime DEFAULT NULL COMMENT '录音结束时间',
  `voice_time` int DEFAULT '0' COMMENT '录音时长',
  `is_report` tinyint(1) DEFAULT '0' COMMENT '录音上报 0:未上报 1:已上报',
  `report_time` datetime DEFAULT NULL COMMENT '上报时间',
  `voice_level` tinyint(1) DEFAULT '0' COMMENT '录音等级 1:一般录音 2:优质录音 0:未分类',
  `voice_text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '录音文本json',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_task_id` (`task_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='宣讲语音';

-- ----------------------------
-- Table structure for t_h_patient_problem
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_problem`;
CREATE TABLE `t_h_patient_problem` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `category_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '类别id',
  `problem` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题',
  `visible` tinyint(1) NOT NULL COMMENT '是否可见（1：可见，0：不可见）',
  `is_delete` tinyint(1) NOT NULL COMMENT '是否删除（1：删除，0：未删除）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `sort` tinyint NOT NULL COMMENT '问题排序',
  `apply_scene` tinyint(1) DEFAULT NULL COMMENT '问题适用场景  （0： 咨询  1 ：随访     2 全部）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_problem_category
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_problem_category`;
CREATE TABLE `t_h_patient_problem_category` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `category` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题类别',
  `visible` tinyint(1) NOT NULL COMMENT '是否可见（1：可见，0：不可见）',
  `is_delete` tinyint(1) NOT NULL COMMENT '是否删除（1：删除，0：未删除）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_problem_handle
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_problem_handle`;
CREATE TABLE `t_h_patient_problem_handle` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `category_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '类别id',
  `handle` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '处理措施',
  `visible` tinyint(1) NOT NULL COMMENT '是否可见（1：可见，0：不可见）',
  `is_delete` tinyint(1) NOT NULL COMMENT '是否删除（1：删除，0：未删除）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_question_negative
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_question_negative`;
CREATE TABLE `t_h_patient_question_negative` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `pay_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '开单id',
  `question_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '题目id',
  `status` tinyint DEFAULT '0' COMMENT '1.阳性（异常），0.阴性',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '上次更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pay_id_status` (`pay_id`,`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者每个单子下所有任务表单必填题目转阴记录';

-- ----------------------------
-- Table structure for t_h_patient_record_content
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_record_content`;
CREATE TABLE `t_h_patient_record_content` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `serve_record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id（模板版本主键id）',
  `patient_module_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者模块id',
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '内容',
  `is_delete` int DEFAULT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id（任务id）',
  `relation_first` tinyint(1) NOT NULL COMMENT '是否第一个随访任务（1：是，0：否）',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者主索引号',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者开单id',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `abnormal_text` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '异常文本',
  `is_excp` int DEFAULT '0' COMMENT '是否异常 0否 1是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pay` (`pay_id`) USING BTREE,
  KEY `idx_empi` (`empi_id`) USING BTREE,
  KEY `idx_patient_module` (`patient_module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_record_content_split
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_record_content_split`;
CREATE TABLE `t_h_patient_record_content_split` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `pay_id` varchar(32) DEFAULT NULL COMMENT '开单id',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '任务id',
  `content_label_code` varchar(30) DEFAULT NULL COMMENT '标签code',
  `content_label_name` varchar(20) DEFAULT NULL COMMENT '标签名称',
  `split_content` varchar(576) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_h_patient_record_content_split_pay_id_IDX` (`pay_id`) USING BTREE,
  KEY `t_h_patient_record_content_split_relation_id_IDX` (`relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者管理记录拆分记录';

-- ----------------------------
-- Table structure for t_h_patient_record_handle
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_record_handle`;
CREATE TABLE `t_h_patient_record_handle` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `patient_content_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者服务记录内容id',
  `patient_module_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者服务记录模块id',
  `pay_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '开单患者id',
  `handle_id` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `score` tinyint DEFAULT NULL COMMENT '打分',
  `problem_sort` tinyint NOT NULL COMMENT '问题排序',
  `handle_sort` tinyint NOT NULL COMMENT '问题处理排序',
  `is_delete` tinyint(1) NOT NULL COMMENT '是否删除（1：删除，0：未删除）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `problem_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题id',
  `handle` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题处理',
  `category_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题分类id',
  `category` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题分类',
  `problem` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pay` (`pay_id`) USING BTREE,
  KEY `idx_patient_content` (`patient_content_id`) USING BTREE,
  KEY `idx_patient_module` (`patient_module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_record_index
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_record_index`;
CREATE TABLE `t_h_patient_record_index` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者记录主键',
  `index_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '指标code',
  `content_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '指标内容code',
  `content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '选择指标内容',
  `content_sort` int DEFAULT NULL COMMENT '指标内容程度',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_record_module
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_record_module`;
CREATE TABLE `t_h_patient_record_module` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者开单id',
  `serve_record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id（模板版本主键id）',
  `module_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模块id',
  `module_type` int DEFAULT NULL COMMENT '模块类型1：基本信息 2：管理记录 3：结案小结',
  `module_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模块名称',
  `is_delete` int DEFAULT NULL,
  `sort` int DEFAULT NULL COMMENT '顺序',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `ediotr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pay` (`pay_id`) USING BTREE,
  KEY `idx_empi` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_relationship
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_relationship`;
CREATE TABLE `t_h_patient_relationship` (
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者empiid',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `data_center_pat_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '数据中心pat_id',
  PRIMARY KEY (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_remark
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_remark`;
CREATE TABLE `t_h_patient_remark` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '主键id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者信息唯一号',
  `inhosp_serial_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '住院流水号',
  `outhosp_serial_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '就诊流水号',
  `pat_index_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '就诊卡号',
  `pat_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者身份证号码',
  `content` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注内容',
  `img_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '备注图片地址列表（用英文逗号分隔）',
  `update_time` datetime DEFAULT NULL COMMENT '最后一次修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `pay_id` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_inhosp_serial_no` (`inhosp_serial_no`) USING BTREE,
  KEY `idx_outhosp_serial_no` (`outhosp_serial_no`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='患者备注表';

-- ----------------------------
-- Table structure for t_h_patient_remark_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_remark_log`;
CREATE TABLE `t_h_patient_remark_log` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `inhosp_no` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '住院流水号',
  `img_url` text COLLATE utf8mb4_general_ci COMMENT '备注图片地址列表（用英文逗号分隔）',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='rpa-出院小结';

-- ----------------------------
-- Table structure for t_h_patient_serve
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_serve`;
CREATE TABLE `t_h_patient_serve` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `goods_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品goodsId',
  `goods_version_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品版本主键id',
  `goods_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `service_start_time` date DEFAULT NULL COMMENT '服务开始时间',
  `service_end_time` date DEFAULT NULL COMMENT '服务结束时间',
  `service_status` tinyint(1) DEFAULT NULL COMMENT '服务状态 0:服务中 1:结束服务 2:暂存',
  `service_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收案备注',
  `is_delete` tinyint(1) DEFAULT NULL,
  `serve_time` datetime DEFAULT NULL COMMENT '收案时间',
  `serve_editor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收案人id',
  `serve_editor_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收案人name',
  `close_time` datetime DEFAULT NULL COMMENT '结案时间',
  `close_editor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结案人id',
  `close_editor_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结案人name',
  `close_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结案原因',
  `close_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结案备注',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `IDX_PAY_ID` (`pay_id`),
  KEY `IDX_PATIENT_GOODS` (`empi_id`,`goods_id`),
  KEY `t_h_patient_serve_empi_id_IDX` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='新患者收案记录表';

-- ----------------------------
-- Table structure for t_h_patient_serve_properties
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_serve_properties`;
CREATE TABLE `t_h_patient_serve_properties` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单id',
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者id',
  `goods_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品id',
  `consult_open_status` tinyint(1) DEFAULT NULL COMMENT '咨询1开0关',
  `protective_medical_status` tinyint(1) DEFAULT NULL COMMENT '保护性医疗1是0否',
  `exception_rule_type` tinyint(1) DEFAULT NULL COMMENT '异常规则类型 1成人减重类，2妊糖类、3多囊类',
  `ai_comment_type` tinyint(1) DEFAULT NULL COMMENT 'ai点评类型 0：无 1成人减重类，2妊糖类',
  `auto_send_flag` tinyint(1) DEFAULT NULL COMMENT '患者自动发送标识  0：不发送 1:自动发送',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `nutrition_program_open_status` tinyint(1) DEFAULT '0' COMMENT '个性化营养方案1开0关  默认0',
  `nutrition_program_value_rule` tinyint(1) DEFAULT NULL COMMENT '个性化营养方案取值规则0向上1向下  默认空',
  `diag_codes` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者疾病诊断信息, ,分隔',
  `diag_other` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者疾病勾选,其他',
  `send_diet_plan_flag` tinyint DEFAULT '0' COMMENT '是否生成发送个性化饮食方案标志 1表示需要发送, 0表示不发送',
  `recommend_charge_type` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '推荐收费',
  `send_remind_flag` tinyint DEFAULT '1' COMMENT '消息发送是否提醒 0:否 1:是',
  PRIMARY KEY (`id`),
  KEY `IDX_PAY_ID` (`pay_id`),
  KEY `IDX_PATIENT_GOODS` (`empi_id`,`goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者服务特性表';

-- ----------------------------
-- Table structure for t_h_patient_service
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_service`;
CREATE TABLE `t_h_patient_service` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '自增主键',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径的id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主索引号',
  `bill_ids` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单记录id',
  `item_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务类别id',
  `service_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务名称',
  `service_start_time` datetime DEFAULT NULL COMMENT '服务开始时间',
  `service_end_time` datetime DEFAULT NULL COMMENT '服务结束时间',
  `service_status` int DEFAULT NULL COMMENT '服务状态 0 服务中，1不在服务中 2暂存',
  `editor_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `editor_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `remark` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `update_time` datetime NOT NULL COMMENT '编辑时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int DEFAULT NULL COMMENT '删除标识 0整除 1删除',
  `time_out_status` int DEFAULT NULL,
  `pack_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径的名称',
  `type_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结案类别编码',
  `type_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结案类别名称',
  `close_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结案描述',
  `close_editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结案人',
  `close_editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `close_time` datetime DEFAULT NULL COMMENT '结束时间',
  `scheme_switch` tinyint unsigned DEFAULT '0' COMMENT '个性化方案开关 0 关闭 1 开启',
  `receive_remark` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '收案备注',
  `close_remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结案备注',
  `close_case_status` tinyint(1) DEFAULT NULL COMMENT '任务服务状态  0 :已结案  1 :暂存',
  `compliance_pay_group_flag` tinyint DEFAULT '0' COMMENT '依从性入组情况',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_item_id` (`item_id`) USING BTREE,
  KEY `t_h_patient_service_bill_ids_IDX` (`bill_ids`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_service_check
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_service_check`;
CREATE TABLE `t_h_patient_service_check` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  `manage_point_type` tinyint DEFAULT NULL COMMENT '管理要点类型 1、疾病 2、管道 3、用药 4、血糖 5、血压 6、体重 7、心率 8、复诊',
  `check_value` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '勾选情况',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '删除标识',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者收案要点选择表';

-- ----------------------------
-- Table structure for t_h_patient_service_package
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_service_package`;
CREATE TABLE `t_h_patient_service_package` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引号',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包id',
  `service_package_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包名称',
  `card` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '卡号',
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '密码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_delete` int DEFAULT NULL COMMENT '删除标记',
  `is_activate` int DEFAULT NULL COMMENT '是否激活 1:激活；其他为非激活',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单的id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_service_withdraw
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_service_withdraw`;
CREATE TABLE `t_h_patient_service_withdraw` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '开单id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者empiId',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '编辑人id',
  `editor_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_sign_push
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_sign_push`;
CREATE TABLE `t_h_patient_sign_push` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `pay_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'pay_patients主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '患者主索引',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '医嘱号',
  `order_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '订单编号signing',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '住院流水号',
  `hosp_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '机构代码',
  `preach_finish_time` datetime DEFAULT NULL COMMENT '宣讲完成时间',
  `push_status` tinyint(1) DEFAULT '0' COMMENT '推送状态：0成功 1失败',
  `push_times` tinyint(1) DEFAULT '1' COMMENT '推送次数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '编辑时间',
  `sign_status` tinyint(1) DEFAULT '1' COMMENT '签约状态：0.取消签约 1.签约',
  `task_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣讲任务id',
  `order_item_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱收费项目代码',
  `order_item_name` varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱收费项目名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ps` (`push_status`) USING BTREE,
  KEY `index_pay_id` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者签约状态推送记录表';

-- ----------------------------
-- Table structure for t_h_patient_summary
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_summary`;
CREATE TABLE `t_h_patient_summary` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `summary_model_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '小结模板id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者主索引',
  `pay_ids` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单ids',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划id',
  `hosp_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '机构代码',
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '内容',
  `create_time` datetime DEFAULT NULL,
  `content_url` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '地址',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人名称',
  `end_remark_content` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结束语内容',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品 id',
  `is_send_user` tinyint DEFAULT '0' COMMENT '是否发送给患者 0:不发送 1:发送',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_hosp` (`hosp_code`) USING BTREE,
  KEY `idx_pay` (`pay_ids`) USING BTREE,
  KEY `idx_empi` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_teach_form
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_teach_form`;
CREATE TABLE `t_h_patient_teach_form` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者id',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单formId',
  `form_title` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单标题',
  `form_label_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `form_label_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `manage_point_type` tinyint DEFAULT NULL COMMENT '管理要点类型  1、疾病 2、管道 3、用药 4、血糖 5、血压 6、体重 7、心率 8、复诊',
  `relevancy_pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联合并单id',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '删除标识',
  `is_check` int DEFAULT NULL COMMENT '勾选标识 0、未勾选 1、勾选',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `type` tinyint DEFAULT '0' COMMENT '0.疾病和指标等问卷，1.指标阴后生活方式问卷',
  `is_ai_recommend` tinyint DEFAULT NULL COMMENT '是否ai推荐 0、否 1、是',
  `is_ai_check` tinyint DEFAULT NULL COMMENT 'ai推荐勾选结果 0、否 1、是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者教练问卷表';

-- ----------------------------
-- Table structure for t_h_patient_teach_form_tag
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_teach_form_tag`;
CREATE TABLE `t_h_patient_teach_form_tag` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `pay_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单id',
  `relation_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务的id（切换问卷类型）',
  `status` tinyint DEFAULT NULL COMMENT '状态，1.使用生活化方式问卷',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者问卷使用类型标记';

-- ----------------------------
-- Table structure for t_h_patient_test_data
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_test_data`;
CREATE TABLE `t_h_patient_test_data` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院编码',
  `pay_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单患者id',
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引号',
  `test_type` tinyint(1) DEFAULT NULL COMMENT '检查类型（1：检验，2：体检）',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查报告编号',
  `report_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查项目编码',
  `report_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查项目名称',
  `report_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '报告时间',
  `item_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查项目编号',
  `item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查项目名称',
  `item_result` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查结果',
  `item_unit` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查结果单位',
  `reference_ranges` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '参考范围',
  `exception_flag` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '异常标志',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `dept_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pay` (`pay_id`) USING BTREE,
  KEY `idx_hosp` (`hosp_code`) USING BTREE,
  KEY `idx_empi` (`empi_id`) USING BTREE,
  KEY `idx_item` (`item_code`,`item_name`) USING BTREE,
  KEY `idx_item_code` (`item_code`) USING BTREE,
  KEY `idx_report` (`report_code`) USING BTREE,
  KEY `idx_hosp_report_date` (`hosp_code`,`report_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_patient_use_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_use_record`;
CREATE TABLE `t_h_patient_use_record` (
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '开单id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者id',
  `record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模版id',
  `create_time` datetime DEFAULT NULL,
  `use_record_flag` tinyint DEFAULT NULL COMMENT '使用新版记录 0:否 1:是',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径id',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划id',
  `model_type` tinyint(1) DEFAULT '0' COMMENT '模版类型0.个性化模板，1.普通通用模板,2:pio通用',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品id',
  PRIMARY KEY (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='新旧管理记录';

-- ----------------------------
-- Table structure for t_h_pay_image
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pay_image`;
CREATE TABLE `t_h_pay_image` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `admission_list` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin,
  `discharge_summary_list` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin,
  `check_list` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin,
  `other_list` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin,
  `create_time` datetime DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `is_delete` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_pay_order
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pay_order`;
CREATE TABLE `t_h_pay_order` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键（支付订单号）',
  `order_id` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '商品订单号',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单（推荐）主键',
  `pay_way_code` int DEFAULT NULL COMMENT '支付方式 1:微信 2：支付宝',
  `pay_way_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_type` int DEFAULT NULL COMMENT '订单类型 1：支付单 2：退费单',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `pay_user` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '支付账号',
  `price` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '支付价格',
  `pay_status` int DEFAULT NULL COMMENT '支付单子：0：未支付  1：已支付  -2：已退费 -3：已关闭；退费单子：-1：退费中 -2：退费成功',
  `refund_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '退费订单号',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `refund_user` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '退费操作人',
  `is_delete` int DEFAULT NULL COMMENT '1:已删除',
  `transaction_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_map` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `deal_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '操作人',
  `deal_user_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_mode_code` int DEFAULT NULL COMMENT '支付模式 1：扫码墩 2：pad端',
  `refund_reason` int DEFAULT NULL COMMENT '退费原因 1：患者主动退费 2：重复收费 3：其它原因',
  `is_advance` int DEFAULT NULL COMMENT '是否垫付退费 0-非垫付退费 1-垫付退费',
  `advance_img` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '垫付截图图片url,多张以,号分割',
  `order_source` int DEFAULT '0' COMMENT '订单来源 0：健海 1：HIS',
  `refund_reason_ext` varchar(400) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '退费原因补充描述',
  `order_phone` varchar(13) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '下单手机号',
  `relation_pat` tinyint DEFAULT '1' COMMENT '是否关联患者 0 否1 是',
  `unit_price` decimal(7,2) DEFAULT NULL COMMENT '单价',
  `quantity` int DEFAULT NULL COMMENT '数量',
  `pay_channel` tinyint(1) DEFAULT NULL COMMENT '收款渠道 1：有赞商城 2：无',
  `is_calculate` tinyint(1) DEFAULT NULL COMMENT '计费状态 0：未计费 1：已计费',
  `calculate_time` datetime DEFAULT NULL COMMENT '计费时间',
  `is_check` tinyint(1) DEFAULT '0' COMMENT '是否对账 0：否 1：是',
  `cancel_reason` tinyint(1) DEFAULT NULL COMMENT '取消原因 1：超时未支付（默认值） 2：患者主动取消 3：其它',
  `cancel_reason_ext` varchar(400) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '取消原因备注',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  `cancel_user_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '取消操作人id',
  `cancel_user_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '取消操作人name',
  `remark` varchar(400) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手动开单备注',
  `service_doctor_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务医生名称',
  `custom_parameters` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '自定义参数',
  `is_give` tinyint(1) DEFAULT '0' COMMENT '是否为赠送单 0:否 1:是',
  `external_order_id` char(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '互联网医院推送id',
  `doctor_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务医生id',
  `charge_item_code` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '收费项目代码',
  `pat_name` varchar(16) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '姓名',
  `sex_code` int DEFAULT NULL COMMENT '性别代码 1-男 2-女',
  `age` int DEFAULT NULL COMMENT '年龄',
  `psy_patient_phone` varchar(11) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '咨询人手机号',
  `informed_consent_url` varchar(500) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '知情同意书地址',
  `psy_day_count` varchar(11) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '咨询订单咨询天数',
  `psychological_channel` tinyint(1) DEFAULT NULL COMMENT '心理渠道 1、杭州市第七人民医院 2、杭州星潼潜能教育科技有限公司 3、杭州琅悦月子会所（杭州旗舰店） 4、杭州健海',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_hosp_code` (`hosp_code`) USING BTREE,
  KEY `idx_pay` (`pay_type`,`pay_status`) USING BTREE,
  KEY `t_h_pay_order_empi_id_IDX` (`empi_id`) USING BTREE,
  KEY `t_h_pay_order_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='自定义参数';

-- ----------------------------
-- Table structure for t_h_pay_patient_merge_relationship
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pay_patient_merge_relationship`;
CREATE TABLE `t_h_pay_patient_merge_relationship` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `old_pay_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '旧开单记录id',
  `new_pay_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '新开单记录id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='多单合并-新旧开单记录关联表';

-- ----------------------------
-- Table structure for t_h_pay_patients
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pay_patients`;
CREATE TABLE `t_h_pay_patients` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '缴费金额',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `repeat_flag` int DEFAULT NULL COMMENT '是否收案(0:未收案 1:已收案)',
  `collector_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人id',
  `collector_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生名称',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `sign_finished_date` datetime DEFAULT NULL COMMENT '签约完成时间',
  `drug_use_frequency_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次代码',
  `drug_use_frequency_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次名称',
  `note` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱备注',
  `drug_unit_price` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目单价',
  `drug_amount` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目开立数量',
  `order_amount` varchar(30) DEFAULT NULL COMMENT '医嘱项目开立数量(非收费项目数量)',
  `add_plan_flag` int DEFAULT NULL COMMENT '是否添加至计划(0:否 1:是)',
  `add_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `add_plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院) 4：体检 5：明日出院 6;今日出院',
  `pat_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者地址',
  `diag_code` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引号',
  `order_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱号',
  `is_refund` int DEFAULT '0' COMMENT '退费标志(0未退费 1:已退费)',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `refund_finish_status` int DEFAULT NULL COMMENT '退费完成状态(0:未完成,1:已完成)',
  `false_data` int DEFAULT '0' COMMENT '0：真实数据，1：种子计划数据',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体检报告号',
  `exam_date` datetime DEFAULT NULL COMMENT '体检日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `recheck_handle_status` int DEFAULT NULL COMMENT '复查处理状态(0:未处理 1:已处理)',
  `report_status` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '报告状态(0:未出 1:已出)',
  `preach_status` tinyint(1) DEFAULT '0' COMMENT '宣讲状态 0未宣讲 1已宣讲',
  `manage_status` tinyint(1) DEFAULT '0' COMMENT '管理状态 0未收案/未添加计划 1已收案/已添加计划',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)名称',
  `remark` varchar(800) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注信息',
  `ward_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区',
  `bed_no` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '床号',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人name',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组名称',
  `status_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '1、全部 2、服务中 3、方案待制定 4、待宣讲 5、正常结案 6、中途退出 7 中途退费 8：未服务退费 9取消开单',
  `actual_money` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '实收金额',
  `exception_desc` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常说明',
  `cancle_time` timestamp NULL DEFAULT NULL COMMENT '取消开单时间',
  `is_cancle` int DEFAULT '0' COMMENT '是否取消开单 0：否 1：是',
  `pay_patient_type` int DEFAULT NULL COMMENT '开单患者类型',
  `pay_patient_send_status` int DEFAULT NULL COMMENT '患者发送状态',
  `pat_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者编码',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务包的主键',
  `service_package_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务包的名称',
  `discharge_dept_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院科室编码',
  `discharge_dept_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院科室名称',
  `hosp_type` int DEFAULT NULL COMMENT '类型 1、医院（默认）；2、保险',
  `source` int DEFAULT NULL COMMENT '来源编写小程序任务需要',
  `operation_time` int DEFAULT NULL COMMENT '手术时间',
  `operation_time_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术时间名称',
  `age` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '年龄',
  `cell_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者手机号码加密后',
  `bill_status` int DEFAULT NULL COMMENT '收费状态 -1：取消 0：未收费 1：已收费 2：退费',
  `service_exception_desc` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案异常',
  `ward_codes` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '病区编码',
  `order_id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单号',
  `sign_status` tinyint DEFAULT NULL COMMENT '签约状态：1.完成签约',
  `self_mobile` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '本人手机号',
  `auth_status` tinyint DEFAULT NULL COMMENT '授权状态',
  `deal_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '交易流水号',
  `abnormal_management` int DEFAULT '0' COMMENT '异常管理 0正常 1全部异常 2部分异常',
  `discharge_summary_status` tinyint DEFAULT NULL COMMENT '出院小结状态 0-无 1-有 2-线下已提供',
  `service_goods_prices_id` char(32) DEFAULT NULL COMMENT '商品物价表id',
  `publicity_charge_item_name` varchar(64) DEFAULT NULL COMMENT '公示中的开单项目名称',
  `service_goods_price` double DEFAULT NULL COMMENT '物价表商品价格',
  `abnormal_management_v2` int DEFAULT '0' COMMENT '异常管理V2 0正常 1异常',
  `goods_exception_desc` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物价异常说明',
  `disease_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '筛选疾病id',
  `disease_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '筛选疾病name',
  `real_hosp_name` varchar(50) DEFAULT NULL COMMENT '机构名称 术疗健康关联的医院',
  `real_hosp_code` varchar(20) DEFAULT NULL COMMENT '机构代码 术疗健康关联的医院',
  `recommend_dr_code` varchar(30) DEFAULT NULL COMMENT '推荐医生工号 术疗健康',
  `recommend_dr_name` varchar(50) DEFAULT NULL COMMENT '推荐医生名称 术疗健康',
  `zq_type` tinyint(1) DEFAULT NULL COMMENT '术疗健康 转化是否与战区有关 0无关 1有关',
  `input_type` tinyint(1) DEFAULT NULL COMMENT '术疗健康 信息录入方式 0院内查询 1手动录入',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `empi_id` (`empi_id`) USING BTREE,
  KEY `status_flag` (`status_flag`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `preach_status` (`preach_status`) USING BTREE,
  KEY `order_no` (`order_no`) USING BTREE,
  KEY `charge_date` (`charge_date`) USING BTREE,
  KEY `t_h_pay_patients_hosp_code_IDX` (`hosp_code`,`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='付费患者表';

-- ----------------------------
-- Table structure for t_h_pay_patients_bi
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pay_patients_bi`;
CREATE TABLE `t_h_pay_patients_bi` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '缴费金额',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `repeat_flag` int DEFAULT NULL COMMENT '是否收案(0:未收案 1:已收案)',
  `collector_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人id',
  `collector_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生名称',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `drug_use_frequency_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次代码',
  `drug_use_frequency_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次名称',
  `note` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱备注',
  `drug_unit_price` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目单价',
  `drug_amount` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目开立数量',
  `add_plan_flag` int DEFAULT NULL COMMENT '是否添加至计划(0:否 1:是)',
  `add_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `add_plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院) 4：体检 5：明日出院 6;今日出院',
  `pat_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者地址',
  `diag_code` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引号',
  `order_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱号',
  `is_refund` int NOT NULL DEFAULT '0' COMMENT '退费标志(0为退费 1:已退费)',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `refund_finish_status` int DEFAULT NULL COMMENT '退费完成状态(0:未完成,1:已完成)',
  `false_data` int DEFAULT '0' COMMENT '0：真实数据，1：种子计划数据',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体检报告号',
  `exam_date` datetime DEFAULT NULL COMMENT '体检日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `recheck_handle_status` int DEFAULT NULL COMMENT '复查处理状态(0:未处理 1:已处理)',
  `report_status` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '报告状态(0:未出 1:已出)',
  `preach_status` tinyint(1) DEFAULT '0' COMMENT '宣讲状态 0未宣讲 1已宣讲',
  `manage_status` tinyint(1) DEFAULT '0' COMMENT '管理状态 0未收案/未添加计划 1已收案/已添加计划',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)名称',
  `remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注信息',
  `ward_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区',
  `bed_no` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '床号',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人name',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组名称',
  `status_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '1、全部 2、服务中 3、方案待制定 4、待宣讲 5、正常结案 6、中途退出 7 中途退费 8：未服务退费 9取消开单',
  `actual_money` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '实收金额',
  `exception_desc` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常说明',
  `cancle_time` timestamp NULL DEFAULT NULL COMMENT '取消开单时间',
  `is_cancle` int DEFAULT '0' COMMENT '是否取消开单 0：否 1：是',
  `pay_patient_type` int DEFAULT NULL COMMENT '开单患者类型',
  `pay_patient_send_status` int DEFAULT NULL COMMENT '患者发送状态',
  `pat_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者编码',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务包的主键',
  `service_package_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务包的名称',
  `discharge_dept_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院科室编码',
  `discharge_dept_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院科室名称',
  `hosp_type` int DEFAULT NULL COMMENT '类型 1、医院（默认）；2、保险',
  `source` int DEFAULT NULL COMMENT '来源编写小程序任务需要',
  `operation_time` int DEFAULT NULL COMMENT '手术时间',
  `operation_time_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术时间名称',
  `age` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '年龄',
  `cell_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者手机号码加密后',
  `hosp_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `empi_id` (`empi_id`) USING BTREE,
  KEY `status_flag` (`status_flag`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `preach_status` (`preach_status`) USING BTREE,
  KEY `order_no` (`order_no`) USING BTREE,
  KEY `charge_date` (`charge_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='付费患者表';

-- ----------------------------
-- Table structure for t_h_pay_patients_copy1
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pay_patients_copy1`;
CREATE TABLE `t_h_pay_patients_copy1` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_index_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '缴费金额',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `repeat_flag` int DEFAULT NULL COMMENT '是否收案(0:未收案 1:已收案)',
  `collector_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人id',
  `collector_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生名称',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `drug_use_frequency_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次代码',
  `drug_use_frequency_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次名称',
  `note` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱备注',
  `drug_unit_price` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医嘱项目单价',
  `drug_amount` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医嘱项目开立数量',
  `add_plan_flag` int DEFAULT NULL COMMENT '是否添加至计划(0:否 1:是)',
  `add_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划id',
  `add_plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划名称',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院)',
  `pat_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者地址',
  `diag_code` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '诊断名称',
  `empi_id` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引号',
  `order_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医嘱号',
  `is_refund` int NOT NULL DEFAULT '0' COMMENT '退费标志(0为退费 1:已退费)',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `refund_finish_status` int DEFAULT NULL COMMENT '退费完成状态(0:未完成,1:已完成)',
  `false_data` int DEFAULT '0' COMMENT '0：真实数据，1：种子计划数据',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '体检报告号',
  `exam_date` datetime DEFAULT NULL COMMENT '体检日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `recheck_handle_status` int DEFAULT NULL COMMENT '复查处理状态(0:未处理 1:已处理)',
  `report_status` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '报告状态(0:未出 1:已出)',
  `preach_status` tinyint(1) DEFAULT '0' COMMENT '宣讲状态 0未宣讲 1已宣讲',
  `manage_status` tinyint(1) DEFAULT '0' COMMENT '管理状态 0未收案/未添加计划 1已收案/已添加计划',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径(场景)名称',
  `remark` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注信息',
  `ward_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '病区',
  `bed_no` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '床号',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人name',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组名称',
  `status_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `actual_money` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '实收金额',
  `exception_desc` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '异常说明',
  `cancle_time` timestamp NULL DEFAULT NULL COMMENT '取消开单时间',
  `is_cancle` int DEFAULT '0' COMMENT '是否取消开单 0：否 1：是',
  `pay_patient_type` int DEFAULT NULL COMMENT '开单患者类型 1:服务管理 2:服务数疗  3:减重管理  4:数疗管理',
  `pay_patient_send_status` int DEFAULT NULL COMMENT '患者发送状态',
  `pat_number` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者编码',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包的id',
  `service_package_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包的名称',
  `discharge_dept_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院科室编码',
  `discharge_dept_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院科室名称',
  `cell_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者手机号码加密后',
  `hosp_type` int DEFAULT NULL COMMENT '类型 1、医院（默认）；2、保险',
  `source` int DEFAULT NULL COMMENT '来源编写小程序任务需要',
  `operation_time` int DEFAULT NULL COMMENT '手术时间',
  `operation_time_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术时间名称',
  `age` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '年龄',
  `bill_status` int DEFAULT NULL COMMENT '收费状态 -1：未取消 0：未收费 1：已收费 2：退费',
  `service_exception_desc` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案异常',
  `order_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `sign_status` int DEFAULT NULL,
  `self_mobile` varchar(55) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ward_codes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_no` (`order_no`) USING BTREE,
  KEY `item_code` (`charge_item_code`) USING BTREE,
  KEY `status_flag` (`status_flag`) USING BTREE,
  KEY `preach_status` (`preach_status`) USING BTREE,
  KEY `idx_mobile` (`mobile_no`) USING BTREE,
  KEY `empi_id` (`empi_id`) USING BTREE,
  KEY `charge_date` (`charge_date`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `type` (`pay_patient_type`) USING BTREE,
  KEY `IDX_PAT_INDEX_NO` (`hosp_code`,`pat_index_no`,`is_refund`) USING BTREE,
  KEY `IDX_HOSP_EMPI` (`hosp_code`,`empi_id`) USING BTREE,
  KEY `IDX_HOSP_SERIALNO` (`hosp_code`,`inhosp_serial_no`) USING BTREE,
  KEY `IDX_ORDER_OREDER_DATE` (`order_order_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='付费患者表';

-- ----------------------------
-- Table structure for t_h_pay_patients_dcz
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pay_patients_dcz`;
CREATE TABLE `t_h_pay_patients_dcz` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_index_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '缴费金额',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `repeat_flag` int DEFAULT NULL COMMENT '是否收案(0:未收案 1:已收案)',
  `collector_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人id',
  `collector_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生名称',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `drug_use_frequency_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次代码',
  `drug_use_frequency_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次名称',
  `note` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱备注',
  `drug_unit_price` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医嘱项目单价',
  `drug_amount` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医嘱项目开立数量',
  `add_plan_flag` int DEFAULT NULL COMMENT '是否添加至计划(0:否 1:是)',
  `add_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划id',
  `add_plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划名称',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院)',
  `pat_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者地址',
  `diag_code` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '诊断名称',
  `empi_id` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引号',
  `order_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医嘱号',
  `is_refund` int NOT NULL DEFAULT '0' COMMENT '退费标志(0为退费 1:已退费)',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `refund_finish_status` int DEFAULT NULL COMMENT '退费完成状态(0:未完成,1:已完成)',
  `false_data` int DEFAULT '0' COMMENT '0：真实数据，1：种子计划数据',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '体检报告号',
  `exam_date` datetime DEFAULT NULL COMMENT '体检日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `recheck_handle_status` int DEFAULT NULL COMMENT '复查处理状态(0:未处理 1:已处理)',
  `report_status` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '报告状态(0:未出 1:已出)',
  `preach_status` tinyint(1) DEFAULT '0' COMMENT '宣讲状态 0未宣讲 1已宣讲',
  `manage_status` tinyint(1) DEFAULT '0' COMMENT '管理状态 0未收案/未添加计划 1已收案/已添加计划',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径(场景)名称',
  `remark` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注信息',
  `ward_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '病区',
  `bed_no` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '床号',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人name',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组名称',
  `status_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `actual_money` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '实收金额',
  `exception_desc` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '异常说明',
  `cancle_time` timestamp NULL DEFAULT NULL COMMENT '取消开单时间',
  `is_cancle` int DEFAULT '0' COMMENT '是否取消开单 0：否 1：是',
  `pay_patient_type` int DEFAULT NULL COMMENT '开单患者类型 1:服务管理 2:服务数疗  3:减重管理  4:数疗管理',
  `pay_patient_send_status` int DEFAULT NULL COMMENT '患者发送状态',
  `pat_number` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者编码',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包的id',
  `service_package_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包的名称',
  `discharge_dept_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院科室编码',
  `discharge_dept_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院科室名称',
  `cell_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者手机号码加密后',
  `hosp_type` int DEFAULT NULL COMMENT '类型 1、医院（默认）；2、保险',
  `source` int DEFAULT NULL COMMENT '来源编写小程序任务需要',
  `operation_time` int DEFAULT NULL COMMENT '手术时间',
  `operation_time_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术时间名称',
  `age` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '年龄',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `empi_id` (`empi_id`) USING BTREE,
  KEY `status_flag` (`status_flag`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `preach_status` (`preach_status`) USING BTREE,
  KEY `order_no` (`order_no`) USING BTREE,
  KEY `charge_date` (`charge_date`) USING BTREE,
  KEY `item_code` (`charge_item_code`) USING BTREE,
  KEY `type` (`pay_patient_type`) USING BTREE,
  KEY `idx_mobile` (`mobile_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='付费患者表';

-- ----------------------------
-- Table structure for t_h_pay_patients_drug
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pay_patients_drug`;
CREATE TABLE `t_h_pay_patients_drug` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_index_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '缴费金额',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `repeat_flag` int DEFAULT NULL COMMENT '是否收案(0:未收案 1:已收案)',
  `collector_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人id',
  `collector_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生名称',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `drug_use_frequency_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次代码',
  `drug_use_frequency_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次名称',
  `note` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱备注',
  `drug_unit_price` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目单价',
  `drug_amount` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目开立数量',
  `add_plan_flag` int DEFAULT NULL COMMENT '是否添加至计划(0:否 1:是)',
  `add_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `add_plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院)',
  `pat_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者地址',
  `diag_code` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断名称',
  `empi_id` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引号',
  `order_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱号',
  `is_refund` int NOT NULL DEFAULT '0' COMMENT '退费标志(0为退费 1:已退费)',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `refund_finish_status` int DEFAULT NULL COMMENT '退费完成状态(0:未完成,1:已完成)',
  `false_data` int DEFAULT '0' COMMENT '0：真实数据，1：种子计划数据',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体检报告号',
  `exam_date` datetime DEFAULT NULL COMMENT '体检日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `recheck_handle_status` int DEFAULT NULL COMMENT '复查处理状态(0:未处理 1:已处理)',
  `report_status` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '报告状态(0:未出 1:已出)',
  `preach_status` tinyint(1) DEFAULT '0' COMMENT '宣讲状态 0未宣讲 1已宣讲',
  `manage_status` tinyint(1) DEFAULT '0' COMMENT '管理状态 0未收案/未添加计划 1已收案/已添加计划',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)名称',
  `remark` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注信息',
  `ward_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区',
  `bed_no` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '床号',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人name',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组名称',
  `status_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `actual_money` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '实收金额',
  `exception_desc` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常说明',
  `cancle_time` timestamp NULL DEFAULT NULL COMMENT '取消开单时间',
  `is_cancle` int DEFAULT '0' COMMENT '是否取消开单 0：否 1：是',
  `pay_patient_type` int DEFAULT NULL COMMENT '开单患者类型',
  `pay_patient_send_status` int DEFAULT NULL COMMENT '患者发送状态',
  `pat_number` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者编码',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务包的id',
  `service_package_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务包的名称',
  `discharge_dept_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院科室编码',
  `discharge_dept_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院科室名称',
  `cell_phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者手机号码加密后',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `empi_id` (`empi_id`) USING BTREE,
  KEY `status_flag` (`status_flag`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `preach_status` (`preach_status`) USING BTREE,
  KEY `order_no` (`order_no`) USING BTREE,
  KEY `charge_date` (`charge_date`) USING BTREE,
  KEY `item_code` (`charge_item_code`) USING BTREE,
  KEY `type` (`pay_patient_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='付费患者表';

-- ----------------------------
-- Table structure for t_h_pay_tag_rule_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pay_tag_rule_relation`;
CREATE TABLE `t_h_pay_tag_rule_relation` (
  `id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_push_rule_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mission_tag_rule_detail_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'mission_push_rule_detail表id',
  `pay_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '开单id',
  `pat_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '患者id',
  `push_content` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表单id',
  `form_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表单标题',
  `push_content_detail` text COLLATE utf8mb4_unicode_ci,
  `mission_range_type` tinyint NOT NULL DEFAULT '1' COMMENT '任务次数，1=全部任务，2=首次任务，3=末次任务',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `child_question_id_map` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_tag` (`tag_push_rule_id`),
  KEY `idx_tag_detail` (`mission_tag_rule_detail_id`),
  KEY `idx_pay` (`pay_id`),
  KEY `idx_pat` (`pat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收案开单和推送规则关联表';

-- ----------------------------
-- Table structure for t_h_personalized_solution
-- ----------------------------
DROP TABLE IF EXISTS `t_h_personalized_solution`;
CREATE TABLE `t_h_personalized_solution` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `is_delete` tinyint unsigned DEFAULT '0' COMMENT '0未删除 1已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '问卷id',
  `is_need_send` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否需要发送',
  `is_send` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已发送',
  `is_finish` tinyint(1) NOT NULL DEFAULT '0' COMMENT '问卷是否填写完成',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'empiId',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '开单id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '医院编码',
  `diagnosis_type` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '个性化方案类型',
  `total_energy` int unsigned NOT NULL DEFAULT '0' COMMENT '个性化方案规格',
  `scheme_switch` tinyint(1) NOT NULL DEFAULT '1' COMMENT '个性化方案开关  -1 不展示  0  关闭  1 开启',
  `un_send_remark` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '不发送原因',
  `disease_archives_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '专病档案id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_pio_match
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pio_match`;
CREATE TABLE `t_h_pio_match` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pay_id` char(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开单id',
  `empi_id` char(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `hosp_code` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `match_result` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'PIO匹配结果',
  `match_raw` text COLLATE utf8mb4_general_ci NOT NULL COMMENT 'PIO匹配原始信息',
  `success_flag` tinyint NOT NULL DEFAULT '1' COMMENT '匹配是否成功 1表示成功',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '匹配时间',
  PRIMARY KEY (`id`),
  KEY `idx_patient` (`pay_id`,`hosp_code`),
  KEY `idx_empi` (`empi_id`,`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_pio_measure
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pio_measure`;
CREATE TABLE `t_h_pio_measure` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `measure_title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理措施名称',
  `editor_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '1.删除，0.正常',
  `diag_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病代码',
  `diag_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='pio-护理措施表';

-- ----------------------------
-- Table structure for t_h_pio_question
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pio_question`;
CREATE TABLE `t_h_pio_question` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `question_title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理问题',
  `editor_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '1.删除，0.正常',
  `diag_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病代码',
  `diag_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='pio-护理问题';

-- ----------------------------
-- Table structure for t_h_pio_rules
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pio_rules`;
CREATE TABLE `t_h_pio_rules` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `primary_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '唯一业务主键',
  `version` tinyint NOT NULL DEFAULT '1' COMMENT '版本号',
  `rule_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '规则名称',
  `diag_code` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '疾病代码',
  `diag_name` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '疾病名称',
  `label_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用标签代码，英文逗号分隔',
  `label_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用标签名称，英文逗号分隔',
  `editor_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '编辑时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '1.删除，0.正常',
  `diag_level_compilation` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病等级顺序集合，逗号分隔',
  `form_id` varchar(32) DEFAULT NULL COMMENT '健康教练问卷id',
  `form_name` varchar(50) DEFAULT NULL COMMENT '健康教练问卷名称',
  `product_ids` varchar(330) DEFAULT NULL COMMENT '适用服务产品 id 集合，英文逗号拼接',
  `product_names` varchar(500) DEFAULT NULL COMMENT '适用服务产品名称集合，英文逗号拼接',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='PIO规则表';

-- ----------------------------
-- Table structure for t_h_pio_rules_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_pio_rules_relation`;
CREATE TABLE `t_h_pio_rules_relation` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `rule_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'PIO规则id',
  `question_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理问题id',
  `measure_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理措施id',
  `question_priority` tinyint DEFAULT NULL COMMENT '问题优先级',
  `measure_priority` tinyint DEFAULT NULL COMMENT '措施优先级',
  `question_sort` tinyint DEFAULT NULL COMMENT '问题顺序',
  `measure_sort` tinyint DEFAULT NULL COMMENT '措施顺序',
  `measure_detail` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '措施详情',
  `form_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '教练式问卷id',
  `form_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '教练式问卷名称',
  `measure_detail_text` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '措施详情',
  `education_ids` varchar(330) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教id，逗号分隔',
  `education_names` varchar(330) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教名称，逗号分隔',
  `associated_records` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '关联记录',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='PIO规则下护理问题和护理措施关联表';

-- ----------------------------
-- Table structure for t_h_placeholder
-- ----------------------------
DROP TABLE IF EXISTS `t_h_placeholder`;
CREATE TABLE `t_h_placeholder` (
  `type_code` int NOT NULL COMMENT '占位符类型编码：1',
  `type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '占位符类型名称：患者姓名',
  `shape_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '占位符名称：${患者姓名}',
  `default_value` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '默认值',
  `class_type` int DEFAULT NULL COMMENT '分类 ：1：变量 2：组件',
  PRIMARY KEY (`type_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_platform_user_relate
-- ----------------------------
DROP TABLE IF EXISTS `t_h_platform_user_relate`;
CREATE TABLE `t_h_platform_user_relate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '云端用户id',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `platform_code` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '平台',
  `platform_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `platform_user_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '平台用户账号',
  `platform_user_password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '平台用户密码',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_delete` int DEFAULT NULL,
  `agent` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分机号',
  `source_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '院内系统账号id',
  `role_id` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '角色的id',
  `role_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '角色名称人',
  `discharge_dept_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院科室编码',
  `discharge_dept_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出院科室名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2893 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_prescription_manage_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_prescription_manage_record`;
CREATE TABLE `t_h_prescription_manage_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `pay_id` varchar(32) NOT NULL COMMENT '开单id',
  `prescription_code` varchar(2) NOT NULL COMMENT '处方类型 0综合、1疾病（含指标）、2护理（伤口，管道\n            含戒烟戒酒）、3饮食、4运动、5用药、6复诊、7睡眠',
  `prescription_name` varchar(20) DEFAULT NULL,
  `manage_time` datetime DEFAULT NULL COMMENT '管理时间',
  `manage_type_code` tinyint DEFAULT NULL COMMENT '管理类型编码',
  `manage_type_name` varchar(20) DEFAULT NULL COMMENT '管理类型名称',
  `manage_content` varchar(2000) DEFAULT NULL COMMENT '内容',
  `manage_way` varchar(10) DEFAULT NULL COMMENT '方式： 小程序 电话 短信',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `business_id` varchar(32) DEFAULT NULL COMMENT '业务id',
  `content_json` text COMMENT '内容json',
  PRIMARY KEY (`id`),
  KEY `t_h_prescription_manage_record_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='按处方维度管理记录';

-- ----------------------------
-- Table structure for t_h_problem_handle_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_problem_handle_log`;
CREATE TABLE `t_h_problem_handle_log` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `category_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '类别id',
  `problem_id` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题id',
  `handle_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '处理措施id',
  `new_handle` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '更改后的处理措施',
  `editor_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理人id',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_problem_handle_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_problem_handle_relation`;
CREATE TABLE `t_h_problem_handle_relation` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `category_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '类别id',
  `problem_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题id',
  `handle_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '处理措施id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `sort` tinyint NOT NULL COMMENT '措施排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_promote
-- ----------------------------
DROP TABLE IF EXISTS `t_h_promote`;
CREATE TABLE `t_h_promote` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '促进记录id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引号',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院机构代码',
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院名称',
  `id_card` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '身份证号',
  `name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '姓名',
  `mobile_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号',
  `promote_content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '促进内容',
  `promote_matter_code` int DEFAULT NULL,
  `promote_matter` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '促进事项',
  `process_status` int DEFAULT NULL COMMENT '处理状态(0-未处理 1-已处理)',
  `process_time` datetime DEFAULT NULL COMMENT '处理时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `diagnosis` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '诊断',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_qos_control_deal_mission
-- ----------------------------
DROP TABLE IF EXISTS `t_h_qos_control_deal_mission`;
CREATE TABLE `t_h_qos_control_deal_mission` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `produce_mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '生成任务的意见id',
  `user_auth_type` int DEFAULT NULL COMMENT '用户权限类型',
  `need_user_id` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `need_user_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `deal_mission_type` int DEFAULT NULL COMMENT '1:处理任务 2:知会任务',
  `deal_record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理意见主键id',
  `process_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理流程主键',
  `is_deal` int DEFAULT NULL COMMENT '是否已处理 -1：已知会 0：未处理 1:已处理 2：无需处理',
  `qos_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `relation_value` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `is_feedback` tinyint(1) DEFAULT '0' COMMENT '是否为反馈发起人 0 否 1 是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_qos_control_deal_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_qos_control_deal_record`;
CREATE TABLE `t_h_qos_control_deal_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `deal_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理人',
  `deal_user_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理人',
  `is_solve` int DEFAULT NULL COMMENT '事件是否解决 0：未解决 1：已解决 2:无需解决',
  `deal_opinions_type_code` int DEFAULT NULL COMMENT '处理状态编码：1：继续处理 2：驳回 3：知会提醒',
  `deal_opinions_type_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理状态名称',
  `deal_opinions_remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理详情',
  `deal_process_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '本次处理流程',
  `is_delete` int DEFAULT NULL,
  `qos_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '质控事件主键id',
  `create_time` datetime DEFAULT NULL,
  `next_user_ids` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '后续跟踪人',
  `next_user_names` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `is_again` int DEFAULT NULL COMMENT '是否重新生成事件 0：不生产（默认） 1:生成',
  `inform_user_ids` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `inform_user_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `is_case_tag` tinyint(1) DEFAULT '0' COMMENT '是否标记优质案例  0:不是 1:是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_qos_control_event
-- ----------------------------
DROP TABLE IF EXISTS `t_h_qos_control_event`;
CREATE TABLE `t_h_qos_control_event` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `event_type` tinyint NOT NULL COMMENT '事件类型',
  `event_class` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '科室',
  `event_class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '科室',
  `event_people` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '被投诉人',
  `event_category` tinyint DEFAULT NULL COMMENT '事件类别',
  `event_time` datetime DEFAULT NULL COMMENT '事件时间',
  `event_desc` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '事件描述',
  `create_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '投诉人',
  `patient_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者姓名',
  `patient_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者id',
  `patient_relation` tinyint DEFAULT NULL COMMENT '患者关系',
  `event_source` tinyint DEFAULT NULL COMMENT '患者来源',
  `event_purpose` tinyint DEFAULT NULL COMMENT '投诉目的',
  `patient_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '联系电话',
  `team_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '分组名称',
  `team_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '分组id',
  `hosp_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医院名称',
  `sex` tinyint DEFAULT NULL COMMENT '性别',
  `status` tinyint DEFAULT NULL COMMENT '事件流程当前状态',
  `org_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医院',
  `create_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人id',
  `update_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '修改人id',
  `create_time` datetime DEFAULT NULL COMMENT '创建事件',
  `doctor_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '开单医生',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `next_user_id` varchar(320) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `next_user_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `return_down_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '驳回事件id',
  `user_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '处理人名字',
  `diag_name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '出院诊断',
  `event_scene` tinyint DEFAULT NULL COMMENT '异常场景 1:患者来电 2:个管师致电',
  `mission_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '关联任务ID',
  `consultant` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '咨询医生',
  `unusual_class_type` tinyint DEFAULT NULL COMMENT '异常事件分类 1:上报 2:咨询 默认1',
  `event_category_label` tinyint DEFAULT NULL COMMENT '分类标签 1：院方 2：服务',
  `importance_level` int DEFAULT '2',
  `pic_urls` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `register_id` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '预约挂号id',
  `register_info` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '预约挂号文案',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='出院诊断';

-- ----------------------------
-- Table structure for t_h_qos_control_process
-- ----------------------------
DROP TABLE IF EXISTS `t_h_qos_control_process`;
CREATE TABLE `t_h_qos_control_process` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `qos_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '质控id',
  `process_type_code` int DEFAULT NULL COMMENT '流程类型',
  `process_type_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `is_end` int DEFAULT NULL COMMENT '是否结束 0：当前未结束 1：当前流程结束 2:全部流程结束',
  `create_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `is_delete` int DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `jump_process_type_code` tinyint DEFAULT NULL COMMENT '直接跳转至流程',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_qos_control_user_auth
-- ----------------------------
DROP TABLE IF EXISTS `t_h_qos_control_user_auth`;
CREATE TABLE `t_h_qos_control_user_auth` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户id',
  `user_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户姓名',
  `auth_type` tinyint NOT NULL COMMENT '权限',
  `org_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '权限',
  `create_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建人id',
  `update_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '修改人id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `doctor_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医生id',
  `user_type` tinyint DEFAULT NULL COMMENT '用户类型:1:当前系统（线下代替） 2:医生监管系统（医生处理）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='服务质量监测-用户权限标';

-- ----------------------------
-- Table structure for t_h_qos_msg_sub
-- ----------------------------
DROP TABLE IF EXISTS `t_h_qos_msg_sub`;
CREATE TABLE `t_h_qos_msg_sub` (
  `id` varchar(32) NOT NULL COMMENT '主键ID',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院code',
  `user_id` varchar(32) DEFAULT NULL COMMENT '用户id',
  `notify_mobile` varchar(32) DEFAULT NULL COMMENT '消息通知的手机号',
  `wait_user_flag` tinyint(1) DEFAULT NULL COMMENT '待我处理 0 没有 1有',
  `offline_flag` tinyint(1) DEFAULT NULL COMMENT '线下处理',
  `open_status` tinyint(1) DEFAULT NULL COMMENT '订阅状态 0 关闭 1开启',
  `create_id` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_id` varchar(32) DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '是否删除',
  `sub_type` tinyint(1) DEFAULT NULL COMMENT '1 投诉表演 2 异常',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='消息订阅表';

-- ----------------------------
-- Table structure for t_h_question_score
-- ----------------------------
DROP TABLE IF EXISTS `t_h_question_score`;
CREATE TABLE `t_h_question_score` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `ref_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '关联id',
  `question_score` double(8,2) DEFAULT NULL COMMENT '分数',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '表单id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '创建人',
  `is_delete` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否删除 0否 1是',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '表单id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '表单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='问卷分数表';

-- ----------------------------
-- Table structure for t_h_quick_dept_search
-- ----------------------------
DROP TABLE IF EXISTS `t_h_quick_dept_search`;
CREATE TABLE `t_h_quick_dept_search` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `user_id` varchar(32) NOT NULL COMMENT '用户id',
  `hosp_code` varchar(20) NOT NULL COMMENT '机构代码',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '机构名称',
  `dept_codes` varchar(300) DEFAULT NULL COMMENT '科室编码 逗号隔开',
  `dept_names` varchar(300) DEFAULT NULL COMMENT '科室名称',
  `contain_flag` tinyint DEFAULT NULL COMMENT '0:不包含 1:包含',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `t_h_quick_dept_search_user_id_IDX` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_recipe_import_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_h_recipe_import_patient`;
CREATE TABLE `t_h_recipe_import_patient` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '姓名',
  `sex` tinyint DEFAULT NULL COMMENT '性别',
  `mobile` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号码',
  `age` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '年龄',
  `sequence` int DEFAULT NULL COMMENT '当前批次导入序号',
  `goods_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品 id',
  `goods_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `batch_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '批次 id，同一批次导入的 id 相同',
  `status` tinyint DEFAULT NULL COMMENT '状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `creator_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人 id',
  `creator_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='个性化食谱 b 端患者导入信息';

-- ----------------------------
-- Table structure for t_h_recommend_deal
-- ----------------------------
DROP TABLE IF EXISTS `t_h_recommend_deal`;
CREATE TABLE `t_h_recommend_deal` (
  `recommend_pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '推荐开单id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `is_purchase` int NOT NULL COMMENT '是否购买 0：不购买 1：购买',
  `charge_item_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单项目',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pay_way_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '支付方式 1：微信 2：支付宝',
  `pay_way_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `desc` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `fail_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '不购买原因',
  `total_money` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '金额',
  `deal_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理人id',
  `deal_user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`recommend_pay_id`) USING BTREE,
  KEY `idx_hosp` (`hosp_code`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_recommend_inaccuracy
-- ----------------------------
DROP TABLE IF EXISTS `t_h_recommend_inaccuracy`;
CREATE TABLE `t_h_recommend_inaccuracy` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) DEFAULT NULL COMMENT '开单id',
  `recommend_content` varchar(255) DEFAULT NULL COMMENT '推荐内容',
  `actual_content` varchar(255) DEFAULT NULL COMMENT '实际内容',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `empi_id` varchar(32) DEFAULT NULL COMMENT 'empiId',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `inaccuracy_type` tinyint DEFAULT NULL COMMENT '不准确类型 1：推荐商品结果',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(20) DEFAULT NULL COMMENT '编辑人名称',
  PRIMARY KEY (`id`),
  KEY `t_h_recommend_inaccuracy_hosp_code_IDX` (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='推荐不准确情况记录';

-- ----------------------------
-- Table structure for t_h_recommend_pay_patients
-- ----------------------------
DROP TABLE IF EXISTS `t_h_recommend_pay_patients`;
CREATE TABLE `t_h_recommend_pay_patients` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院名称',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '缴费金额',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `repeat_flag` int DEFAULT NULL COMMENT '是否收案(0:未收案 1:已收案)',
  `collector_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人id',
  `collector_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案人',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生名称',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `drug_use_frequency_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次代码',
  `drug_use_frequency_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次名称',
  `note` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱备注',
  `drug_unit_price` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目单价',
  `drug_amount` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目开立数量',
  `add_plan_flag` int DEFAULT NULL COMMENT '是否添加至计划(0:否 1:是)',
  `add_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `add_plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院) 4：体检 5：明日出院 6;今日出院',
  `pat_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者地址',
  `diag_code` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引号',
  `order_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱号',
  `is_refund` int NOT NULL DEFAULT '0' COMMENT '退费标志(0为退费 1:已退费)',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `refund_finish_status` int DEFAULT NULL COMMENT '退费完成状态(0:未完成,1:已完成)',
  `false_data` int DEFAULT '0' COMMENT '0：真实数据，1：种子计划数据',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体检报告号',
  `exam_date` datetime DEFAULT NULL COMMENT '体检日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `recheck_handle_status` int DEFAULT NULL COMMENT '复查处理状态(0:未处理 1:已处理)',
  `report_status` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '报告状态(0:未出 1:已出)',
  `preach_status` tinyint(1) DEFAULT '0' COMMENT '宣讲状态 0未宣讲 1已宣讲',
  `manage_status` tinyint(1) DEFAULT '0' COMMENT '管理状态 0未收案/未添加计划/未处理 1已收案/已添加计划/已处理',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径(场景)名称',
  `remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注信息',
  `ward_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区',
  `bed_no` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '床号',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人name',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分组名称',
  `status_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `actual_money` int DEFAULT NULL COMMENT '实收金额',
  `exception_desc` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常说明',
  `cancle_time` timestamp NULL DEFAULT NULL COMMENT '取消开单时间',
  `is_cancle` int DEFAULT '0' COMMENT '是否取消开单 0：否 1：是',
  `pay_patient_type` int DEFAULT NULL COMMENT '开单患者类型',
  `pay_patient_send_status` int DEFAULT NULL COMMENT '患者发送状态',
  `recommend_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推荐人id',
  `recommend_person_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推荐人姓名',
  `recommend_type` int DEFAULT NULL COMMENT '推荐类型 1：医院系统推荐 2：医护推荐 3：健管自主推荐 4:pad端推荐',
  `comment` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `img_url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注图片地址',
  `ward_codes` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '病区编码',
  `inhosp_time` datetime DEFAULT NULL COMMENT '入院时间',
  `attend_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主治医生工号',
  `attend_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主治医生名称',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_no` (`order_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='付费患者表';

-- ----------------------------
-- Table structure for t_h_record_model
-- ----------------------------
DROP TABLE IF EXISTS `t_h_record_model`;
CREATE TABLE `t_h_record_model` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `hosp_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `model_type` int DEFAULT NULL COMMENT '模板类别',
  `model_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模板类别名称',
  `model_title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模板标题',
  `model_content` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模板内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `model_relation_type` int DEFAULT NULL COMMENT '1:管理记录模板 2：常用语模板 3：提醒模板 4：短信模板',
  `regular_type` int DEFAULT NULL COMMENT '格式常规类型 1：定期',
  `model_content_htm` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '模板内容htm',
  `index_codes` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '指标codes',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室编码',
  `dept_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室名称',
  `creator` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人',
  `modifier` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '修改人',
  `fail_code` int DEFAULT NULL COMMENT '电话状态编码',
  `fail_msg` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '电话状态名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='修改人';

-- ----------------------------
-- Table structure for t_h_referral_task_analyze_result
-- ----------------------------
DROP TABLE IF EXISTS `t_h_referral_task_analyze_result`;
CREATE TABLE `t_h_referral_task_analyze_result` (
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `begin_time_type` tinyint NOT NULL,
  `begin_time_type_name` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `after_begin_time` tinyint NOT NULL,
  `after_begin_time_unit` tinyint NOT NULL,
  `after_begin_time_unit_name` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
  `timing_date` date NOT NULL,
  `workflow_run_id` varchar(36) COLLATE utf8mb4_general_ci NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `llm_used` tinyint NOT NULL DEFAULT '0',
  `raw_result` text COLLATE utf8mb4_general_ci NOT NULL COMMENT 'LLM匹配原始数据',
  `success_flag` tinyint NOT NULL DEFAULT '1' COMMENT '是否调用接口成功',
  PRIMARY KEY (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_register
-- ----------------------------
DROP TABLE IF EXISTS `t_h_register`;
CREATE TABLE `t_h_register` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `sys_code` int DEFAULT NULL COMMENT '1-hug 2-Integererview',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '组织机构代码',
  `scheduling_no` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '排班编号',
  `visit_date` datetime DEFAULT NULL COMMENT '日期',
  `visit_time` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '时间',
  `ap` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '班次 A-上午 P-下午  0全天 1上午 2下午',
  `seq_no` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '号源序号',
  `pat_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者id',
  `pat_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '姓名',
  `sexCode` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别名称',
  `birth` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '出生日期',
  `address` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '地址',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '身份证',
  `mobile_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号',
  `visit_card_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '就诊卡类型',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '就诊卡号',
  `dept_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '所属科室编码',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室名称',
  `dr_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医生工号',
  `dr_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医生姓名',
  `type` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '挂号类别',
  `vip` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'vip 标志 0、普通 1、vip',
  `delivery_type` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '运送方式1、步行 2、平车 3、轮椅',
  `note` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `data_source_type` int DEFAULT NULL COMMENT '数据源类型 1、oracle 2、sqlserver 3、mysql',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `register_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '预约id',
  `staff_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '工号',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引号',
  `order_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '预约人',
  `order_time` datetime DEFAULT NULL COMMENT '预约时间',
  `password` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '取号密码',
  `register_status` int DEFAULT '1' COMMENT '预约状态 -1取消预约 1预约',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_register_verify
-- ----------------------------
DROP TABLE IF EXISTS `t_h_register_verify`;
CREATE TABLE `t_h_register_verify` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '医院编码',
  `doctor_codes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医生编码',
  `doctor_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医生姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_regular_expression
-- ----------------------------
DROP TABLE IF EXISTS `t_h_regular_expression`;
CREATE TABLE `t_h_regular_expression` (
  `content` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bu_relation_type` tinyint DEFAULT NULL,
  `scene_type` tinyint DEFAULT NULL COMMENT '1慢阻肺 2高尿酸血症/痛风 3肾病(慢性肾炎CKD1~2期)4产后 5人流/流产6管道 7用药\n8血糖9血压10体重 11心率',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='正则表达式';

-- ----------------------------
-- Table structure for t_h_return_visit_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_return_visit_record`;
CREATE TABLE `t_h_return_visit_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务id',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者empiid',
  `is_referral` tinyint DEFAULT '0' COMMENT '是否复诊（0，否  1，是）',
  `not_return_code` tinyint DEFAULT NULL COMMENT '未复诊原因编码',
  `not_return_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '未复诊原因',
  `specific_reason_code` int DEFAULT NULL COMMENT '具体原因编码',
  `specific_reason_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '具体原因',
  `remark` varchar(600) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `referral_confirm_date` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `referral_confirm_way` tinyint DEFAULT NULL COMMENT '复诊确认途径（1，系统确认  2，人工确认）',
  `is_willing` tinyint DEFAULT NULL COMMENT '复诊意愿 0:否 1:是',
  `create_time` datetime DEFAULT NULL,
  `editor_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人',
  `is_on_time` tinyint DEFAULT NULL COMMENT '是否按期复诊（0，否  1，是）',
  `is_local` tinyint DEFAULT NULL COMMENT '是否本院复诊（0，否  1，是）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_satisfaction_followup_filter
-- ----------------------------
DROP TABLE IF EXISTS `t_h_satisfaction_followup_filter`;
CREATE TABLE `t_h_satisfaction_followup_filter` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '计划id',
  `charge_item_code` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单项目代码',
  `charge_item_name` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单项目名称',
  `pat_source_type` tinyint DEFAULT '1' COMMENT '患者来源，1.开单患者',
  `pay_patient_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务模式，1.服务管理，2.服务数疗，3.减重管理,多选',
  `is_delete` tinyint DEFAULT '0',
  `is_filtered` tinyint DEFAULT '0' COMMENT '是否筛选过，0.未曾筛选，1.已经筛选过',
  `first_filter_start_date` datetime DEFAULT NULL COMMENT '首次筛选起始时间',
  `product_id_list` varchar(3201) DEFAULT NULL COMMENT '需要包含或排除的产品id, 逗号隔开',
  `contain_status` tinyint DEFAULT NULL COMMENT '包含产品标志 1包含 2排除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='满意度调查-推送对象筛选表';

-- ----------------------------
-- Table structure for t_h_satisfaction_followup_job
-- ----------------------------
DROP TABLE IF EXISTS `t_h_satisfaction_followup_job`;
CREATE TABLE `t_h_satisfaction_followup_job` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `is_auto_send` tinyint DEFAULT '1' COMMENT '1.开启自动推送，0.关闭自动推送',
  `send_time_type` tinyint DEFAULT NULL COMMENT '推送时间类型，1.出院后，2.开单后，3.服务结束后',
  `send_time_days` smallint unsigned DEFAULT NULL COMMENT '推送时间天数',
  `send_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推送渠道，1.AI',
  `form_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '满意度表单id',
  `form_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '满意度表单名称',
  `is_delete` tinyint DEFAULT '0' COMMENT '0.正常，1.删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='满意度调查推送内容表';

-- ----------------------------
-- Table structure for t_h_satisfaction_followup_mission
-- ----------------------------
DROP TABLE IF EXISTS `t_h_satisfaction_followup_mission`;
CREATE TABLE `t_h_satisfaction_followup_mission` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划ID(满意度计划表主键)',
  `plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主索引号',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单id',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '计划随访时间',
  `revisit_plan_end_time` datetime DEFAULT NULL COMMENT '计划随访截止时间',
  `content_id` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联随访ID(","分隔，上限10个)',
  `content_title` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联随访标题(","分隔，上限10个)',
  `followup_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访人员人ID',
  `followup_person_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访人员姓名',
  `return_visit_time` datetime DEFAULT NULL COMMENT '实际回访时间',
  `return_visit_type` tinyint DEFAULT NULL COMMENT '实际回访方式(1:电话 2:APP/微信/短信)',
  `return_visit_type_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '实际回访方式名称',
  `revisit_status` tinyint DEFAULT NULL COMMENT '随访状态(1:正常状态；2:无人接听；3:无法接通；4:关机；5:停机；6:死亡；7:家属接听(不了解情况)；8:拒绝；9:空号/电话错误；10:其他)',
  `revisit_result` tinyint DEFAULT '0' COMMENT '随访结果(0:未完成 1:已完成 2:已结案)',
  `revisit_excp` tinyint DEFAULT NULL COMMENT '随访结果异常标识(0:正常 1:异常)',
  `ai_push_status` tinyint DEFAULT '0' COMMENT 'AI推送状态(0:未推送 -1:未回复 1:已回复)',
  `ai_push_result_code` tinyint DEFAULT NULL COMMENT 'AI推送结果状态值 0 正常, 其他 异常(具体AI系统定)',
  `ai_push_result_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI推送结果状态说明',
  `ai_push_time` datetime DEFAULT NULL COMMENT 'AI推送时间',
  `ai_push_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI推送人员ID',
  `auto_push_ai_times` tinyint unsigned DEFAULT '0' COMMENT '自动AI推送次数',
  `manual_push_ai_times` tinyint unsigned DEFAULT '0' COMMENT '手动AI推送次数',
  `ai_reply_time` datetime DEFAULT NULL COMMENT 'AI回复时间',
  `ai_label_codes` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ai标签编码（逗号隔开）',
  `ai_label_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ai标签名称（逗号隔开）',
  `handling_opinion` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '处理意见',
  `temporary_status` tinyint DEFAULT '0' COMMENT '暂存状态',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `IDX_PLAN_ID` (`plan_id`),
  KEY `t_h_satisfaction_followup_mission_pay_id_IDX` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_satisfaction_followup_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_h_satisfaction_followup_plan`;
CREATE TABLE `t_h_satisfaction_followup_plan` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '计划名称',
  `open_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开启时间',
  `close_time` timestamp NULL DEFAULT NULL COMMENT '关闭时间',
  `editor_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_open` tinyint DEFAULT '1' COMMENT '0.关闭，1.开启',
  `is_delete` tinyint DEFAULT '0' COMMENT '0.正常，1.删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='满意度调查计划表';

-- ----------------------------
-- Table structure for t_h_scheduling
-- ----------------------------
DROP TABLE IF EXISTS `t_h_scheduling`;
CREATE TABLE `t_h_scheduling` (
  `ORGAN_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组织机构代码',
  `SCHEDULING_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '排班编码',
  `SUPERIOR_DEPT_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上级科室代码',
  `SUPERIOR_DEPT_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上级科室名称',
  `DEPT_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `DEPT_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码',
  `DR_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医生代码',
  `DR_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医生名称',
  `TITLE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '职称',
  `TYPE` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类型',
  `VISIT_DATE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '就诊日期',
  `AP` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上、下午',
  `FEE` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '挂号费',
  `AMOUNT` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数量',
  `REGISTER_AMOUNT` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '剩余数量',
  `STATUS` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '状态',
  `AREA` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区',
  PRIMARY KEY (`SCHEDULING_NO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='病区';

-- ----------------------------
-- Table structure for t_h_serve_model_handle
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_model_handle`;
CREATE TABLE `t_h_serve_model_handle` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `serve_record_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '个案记录模板id',
  `module_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '模块id',
  `problem` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '问题',
  `handle` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '处理',
  `is_delete` tinyint(1) NOT NULL COMMENT '是否删除（1：删除，0：未删除）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_serve_model_module
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_model_module`;
CREATE TABLE `t_h_serve_model_module` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `serve_record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id（模板版本主键id）',
  `module_type` int DEFAULT NULL COMMENT '模块类型1：基本信息 2：管理记录 3：结案小结',
  `module_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模块名称',
  `is_delete` int DEFAULT NULL,
  `sort` int DEFAULT NULL COMMENT '顺序',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_serve_id` (`serve_record_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_serve_module_content
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_module_content`;
CREATE TABLE `t_h_serve_module_content` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `serve_record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id（模板版本主键id）',
  `module_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模块id',
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '内容',
  `content_html` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '内容html',
  `is_delete` int DEFAULT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_serve_id` (`serve_record_id`) USING BTREE,
  KEY `idx_model` (`module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_serve_package_connotation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_package_connotation`;
CREATE TABLE `t_h_serve_package_connotation` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `serve_package_name` varchar(30) DEFAULT NULL COMMENT '服务包名称',
  `price_grade_type_code` varchar(2) DEFAULT NULL COMMENT '档位0：49,1：99,2：295,3：795,4：1590,6：29 ,7：395 ,8：2616 ,9：3180',
  `price_grade_type_name` varchar(8) DEFAULT NULL COMMENT '档位名称',
  `manage_cycle` int DEFAULT NULL COMMENT '管理周期',
  `hosp_codes` varchar(500) DEFAULT NULL COMMENT '机构代码',
  `hosp_names` varchar(500) DEFAULT NULL COMMENT '机构代码',
  `serve_channel_type_code` varchar(100) DEFAULT NULL COMMENT '渠道类型 1:电话， 2:小程序/app，3:短信，4:企微',
  `serve_channel_type_name` varchar(100) DEFAULT NULL COMMENT '渠道类型名称',
  `is_delete` tinyint DEFAULT NULL COMMENT '删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(10) DEFAULT NULL COMMENT '编辑人',
  `is_open` tinyint DEFAULT NULL COMMENT '0:未启用 1:已启用',
  `prescription_type_sort` varchar(30) DEFAULT NULL COMMENT '处方记录排序',
  `hosp_evaluate_id` varchar(32) DEFAULT NULL COMMENT '院内评估(专病档案id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='服务包内涵表';

-- ----------------------------
-- Table structure for t_h_serve_package_connotation_set
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_package_connotation_set`;
CREATE TABLE `t_h_serve_package_connotation_set` (
  `id` varchar(32) NOT NULL,
  `package_connotation_id` varchar(32) DEFAULT NULL COMMENT '内涵主键id',
  `manage_prescription_code` varchar(2) DEFAULT NULL COMMENT '处方类型 0综合、1疾病（含指标）、2护理（伤口，管道 含戒烟戒酒）、3饮食、4运动、5用药、6复诊、7睡眠',
  `manage_means_type` varchar(2) DEFAULT NULL COMMENT '手段类型',
  `manage_compare_type` varchar(2) DEFAULT NULL COMMENT '比较类型',
  `manage_num` tinyint DEFAULT NULL COMMENT '次数',
  `manage_unit` varchar(2) DEFAULT NULL COMMENT '单位 1：次；2:天',
  `manage_connotation_type` varchar(100) DEFAULT NULL COMMENT '具体内涵方式类型 逗号隔开 1服务管理路径、2PIO问卷/专病档案/自评表单、3体成分分析等测量、4智能居家设备、5管理方案-A版（营养食谱/饮食建议）、6管理方案-B版（饮食方案+食谱+打卡）、7点评、8宣教/提醒/补充话术、9异常跟踪、10小程序/电话咨询、11企微咨询、12管理记录/soap报告/周报月报/结案小结、13报告解读',
  `manage_connotation_name` varchar(200) DEFAULT NULL COMMENT '具体内涵方式名称',
  `update_time` datetime DEFAULT NULL,
  `sort` tinyint DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `t_h_serve_package_connotation_set_package_connotation_id_IDX` (`package_connotation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='服务包内涵设置表';

-- ----------------------------
-- Table structure for t_h_serve_placeholder
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_placeholder`;
CREATE TABLE `t_h_serve_placeholder` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `serve_record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id（模板版本主键id）',
  `module_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模块id',
  `type_code` int DEFAULT NULL COMMENT '占位符类型编码：1',
  `type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '占位符类型名称：患者姓名',
  `shape_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '占位符名称：${患者姓名}',
  `is_delete` int DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `parameter_id1` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '参数1',
  `parameter_id2` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '参数2',
  `parameter_id3` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '参数3',
  `text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '前端占位符文本',
  `type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '前端类型',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_serve_id` (`serve_record_id`) USING BTREE,
  KEY `idx_model` (`module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_serve_quality_comment
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_quality_comment`;
CREATE TABLE `t_h_serve_quality_comment` (
  `id` varchar(32) NOT NULL,
  `relation_id` varchar(32) NOT NULL COMMENT '任务 id',
  `comment_content` varchar(1000) DEFAULT NULL COMMENT '点评内容',
  `comment_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '点评时间',
  `comment_user_id` varchar(32) DEFAULT NULL COMMENT '点评人id',
  `comment_user_name` varchar(32) DEFAULT NULL COMMENT '点评人姓名',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态,1-医生已点评,2-医生继续点评',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除,0-未删除,1-已删除',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(32) DEFAULT NULL COMMENT '创建人姓名',
  `reply_status` tinyint DEFAULT NULL COMMENT '回复状态,0-未回复,1-个管师已回复',
  PRIMARY KEY (`id`),
  KEY `IDX_RELATION_ID` (`relation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='点评表';

-- ----------------------------
-- Table structure for t_h_serve_quality_mission
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_quality_mission`;
CREATE TABLE `t_h_serve_quality_mission` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  `empi_id` varchar(32) NOT NULL COMMENT '患者主索引',
  `pay_id` varchar(32) NOT NULL COMMENT '开单id',
  `satisfaction_score` tinyint NOT NULL COMMENT '满意度评分,1-5',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态,1-医生已点评,2-个管师已回复,3-完成',
  `deal_time` datetime DEFAULT NULL COMMENT '处理时间',
  `deal_user_id` varchar(32) DEFAULT NULL COMMENT '处理人id',
  `deal_user_name` varchar(32) DEFAULT NULL COMMENT '处理人姓名',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除,0-未删除,1-已删除',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(32) DEFAULT NULL COMMENT '创建人姓名',
  PRIMARY KEY (`id`),
  KEY `IDX_PAY_ID` (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='点评和回复任务表';

-- ----------------------------
-- Table structure for t_h_serve_quality_reply
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_quality_reply`;
CREATE TABLE `t_h_serve_quality_reply` (
  `id` varchar(32) NOT NULL,
  `relation_id` varchar(32) NOT NULL COMMENT '任务 id',
  `comment_id` varchar(32) DEFAULT NULL,
  `reply_content` varchar(1000) DEFAULT NULL COMMENT '回复内容',
  `reply_time` datetime DEFAULT NULL COMMENT '回复时间',
  `reply_user_id` varchar(32) DEFAULT NULL COMMENT '回复人id',
  `reply_user_name` varchar(32) DEFAULT NULL COMMENT '回复人姓名',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态,1-个管师已回复,2-个管师已知晓',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除,0-未删除,1-已删除',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(32) DEFAULT NULL COMMENT '创建人姓名',
  PRIMARY KEY (`id`),
  KEY `IDX_COMMENT_ID` (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='点评和回复任务表';

-- ----------------------------
-- Table structure for t_h_serve_quality_score
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_quality_score`;
CREATE TABLE `t_h_serve_quality_score` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单id',
  `score_type` tinyint DEFAULT NULL COMMENT '分数项目类型 1:复诊 2:用药 3:饮食 4:运动 5:宣教 6:人工任务',
  `score_standard_type` tinyint DEFAULT NULL COMMENT '分数标准类型 0:不扣分 1:扣0.5分  2:扣1分 3:扣两分 9:不适用',
  `score_num` decimal(8,1) DEFAULT NULL COMMENT '分值',
  `create_time` datetime DEFAULT NULL,
  `hosp_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_serve_quality_selection
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_quality_selection`;
CREATE TABLE `t_h_serve_quality_selection` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  `quantity` int DEFAULT NULL COMMENT '抽检数量',
  `dept_codes` varchar(330) DEFAULT NULL COMMENT '科室代码集合',
  `dept_names` varchar(330) DEFAULT NULL COMMENT '科室名称集合',
  `is_filter_commented` tinyint DEFAULT '0' COMMENT '是否过滤已被点评,0-不过滤,1-过滤',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(32) DEFAULT NULL COMMENT '创建人姓名',
  `sort` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_serve_record_handle
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_record_handle`;
CREATE TABLE `t_h_serve_record_handle` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `keyword` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关键点',
  `problem` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '问题',
  `handle` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '相应处理',
  `sort` tinyint DEFAULT NULL COMMENT '排序',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '是否删除（1：删除，0：未删除）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_serve_record_handle_copy1
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_record_handle_copy1`;
CREATE TABLE `t_h_serve_record_handle_copy1` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `keyword` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关键点',
  `problem` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '问题',
  `handle` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '相应处理',
  `sort` tinyint DEFAULT NULL COMMENT '排序',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '是否删除（1：删除，0：未删除）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_serve_record_model
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_record_model`;
CREATE TABLE `t_h_serve_record_model` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '版本主键id',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id（路径id、服务包id）',
  `relation_type` int DEFAULT NULL COMMENT '关联类型（1：路径，2：服务包）',
  `relation_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联路径/服务包名称',
  `model_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模板名称',
  `publish_flag` int DEFAULT NULL COMMENT '发布标识 0 ：未发布 1：已发布',
  `is_delete` int DEFAULT NULL COMMENT '删除标识 0：未删除 1：删除(禁用)',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `universal_flag` int DEFAULT NULL COMMENT '通用标识 1：通用',
  `primary_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主id',
  `version` int DEFAULT NULL COMMENT '版本号',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `reference_template` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '引用模板',
  `form_ids` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '问卷表单id集合',
  `form_names` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '表单名称',
  `plan_id` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划Id',
  `model_type` tinyint DEFAULT '0' COMMENT '模板类型，0.非通用模板，1.通用模板',
  `hosp_codes` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码集合',
  `compliance_pay_group_flag` tinyint DEFAULT '0' COMMENT '依从性入组情况',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_serve_summary_item
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_summary_item`;
CREATE TABLE `t_h_serve_summary_item` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '小结模板主键',
  `test_item_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检验项目编码',
  `test_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检验项目名称',
  `health_item_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '健康监测项目编码',
  `health_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '健康监测项目名称',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `target_value` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '目标值',
  `is_delete` int DEFAULT NULL,
  `unit` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '单位',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_serve_summary_model
-- ----------------------------
DROP TABLE IF EXISTS `t_h_serve_summary_model`;
CREATE TABLE `t_h_serve_summary_model` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联id（路径id、服务包id）',
  `relation_type` int DEFAULT NULL COMMENT '关联类型（1：路径，2：服务包）',
  `relation_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联路径/服务包名称',
  `is_delete` int DEFAULT NULL COMMENT '删除标识 0：未删除 1：删除',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `end_remark_codes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结束语类型编码',
  `end_remark_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结束语类型名称',
  `update_time` datetime DEFAULT NULL,
  `model_type` tinyint DEFAULT '0' COMMENT '模版类型 1：通用 2：pio',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_auto
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_auto`;
CREATE TABLE `t_h_service_auto` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单项目',
  `charge_item_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单项目名称',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径id',
  `pack_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径名称',
  `service_item_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务项目id',
  `service_item_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务项目名称',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划id',
  `plan_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '计划名称',
  `auto_preach` int DEFAULT NULL COMMENT '自动宣讲 1',
  `auto_service` int DEFAULT NULL COMMENT '自动制定方案 1',
  `auto_stop` int DEFAULT NULL COMMENT '自动停止服务 1',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组名称',
  `add_day` int DEFAULT NULL,
  `pay_patient_type` tinyint(1) DEFAULT NULL COMMENT '开单管理类型',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品id',
  `goods_name` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_charge_project
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_charge_project`;
CREATE TABLE `t_h_service_charge_project` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '医院机构代码',
  `item_number` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目编号',
  `charge_item_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '开单项目',
  `status` tinyint NOT NULL DEFAULT '2' COMMENT '1.启用,0.停用,2.待开启',
  `creator_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人名称',
  `editor_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '编辑时间',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除',
  `medical_order_item_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱项目名称',
  `text_medical_order` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文本医嘱',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_hosp_code_item_number_is_delete` (`hosp_code`,`item_number`,`is_delete`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品开单项目表';

-- ----------------------------
-- Table structure for t_h_service_configuration
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_configuration`;
CREATE TABLE `t_h_service_configuration` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包Id',
  `my_service_configuration_code` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '我的指标配置编码',
  `my_service_configuration_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '我的指标配置名称',
  `my_service_configuration_count` int DEFAULT NULL COMMENT '我的指标配置数量',
  `my_service_configuration_picurl` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '我的指标配置图片url',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_doctor
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_doctor`;
CREATE TABLE `t_h_service_doctor` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `dept_code` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码 100:产科 200:妇科 300:心内科',
  `dept_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `doctor_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医生姓名',
  `doctor_pic` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生照片',
  `doctor_introduction` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生简介',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_service_doctor2
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_doctor2`;
CREATE TABLE `t_h_service_doctor2` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `doctor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医生姓名',
  `doctor_pic` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生照片',
  `doctor_introduction` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生简介',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_service_goods
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_goods`;
CREATE TABLE `t_h_service_goods` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键(商品版本ID)',
  `goods_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '服务商品id',
  `current_version` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '版本号',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '使用医院code',
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '使用医院name',
  `inner_title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '对内展示名称',
  `out_title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '对外展示名称',
  `description` varchar(800) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述说明',
  `product_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '产品id',
  `product_version_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '当前服务产品版本id',
  `latest_product_version_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '最新服务产品版本id',
  `diag_codes` varchar(1000) DEFAULT NULL COMMENT '适用疾病编码多个,分隔',
  `diag_names` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用疾病名称多个,分隔',
  `dept_codes` varchar(1000) DEFAULT NULL COMMENT '科室编码多个,分隔',
  `dept_names` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称多个,分隔',
  `label_codes` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '内容标签编码多个,分隔',
  `label_names` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '内容标签名称多个,分隔',
  `remark` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `specific_medical_codes` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专项医疗数据编码',
  `specific_medical_names` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专项医疗数据名称',
  `preach_education_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣讲资料id',
  `preach_education_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣讲资料名称',
  `special_disease_archives_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专病档案id',
  `special_disease_archives_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专病档案名称',
  `recommend_charge_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推荐收费',
  `consult_open_status` tinyint(1) NOT NULL COMMENT '咨询1开0关',
  `goods_consult_open_status` tinyint(1) NOT NULL COMMENT '咨询1开0关（健管云）',
  `protective_medical_status` tinyint(1) DEFAULT NULL COMMENT '保护性医疗1是0否',
  `team_set_type` tinyint NOT NULL COMMENT '团队设置（0：线上履约团队,1：高净值团队）',
  `content_send_type` tinyint DEFAULT NULL COMMENT '内容生效机制（0：满足基线条件发送，1：人工收案后发送）',
  `exception_rule_type` tinyint DEFAULT NULL COMMENT '异常规则类型',
  `ai_comment_type` tinyint DEFAULT NULL COMMENT 'ai点评类型',
  `is_latest` tinyint(1) NOT NULL COMMENT '是否最新，1：是，0：否',
  `confirm_url` varchar(1024) DEFAULT NULL COMMENT '确认函url',
  `online_status` tinyint NOT NULL COMMENT '商品上架状态，1：未上架，2：上架，3：停用',
  `sync_status` tinyint DEFAULT NULL COMMENT '产品版本同步状态，1：已同步，2：待更新，3：旧版本',
  `disable_time` datetime DEFAULT NULL COMMENT '停用时间',
  `has_draft` tinyint(1) DEFAULT NULL COMMENT '是否有草稿，1：有，0：无',
  `goods_charge` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '商品价格',
  `charge_detail` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '商品价格描述',
  `mission_change` tinyint(1) DEFAULT NULL COMMENT '影响未来任务，1：影响，0：不影响',
  `serve_patient_num` int DEFAULT NULL COMMENT '服务患者数',
  `accumulate_patient_num` int DEFAULT NULL COMMENT '累计患者数',
  `creator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人名称',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `is_delete` tinyint(1) NOT NULL COMMENT '1删除0未删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `management_time_type` tinyint DEFAULT NULL COMMENT '管理时长类型：0代表30,1代表42,2代表60,3代表90,4代表180,-1代表其他',
  `is_other_management_time` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '其他，管理时长值',
  `exception_rule_type_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常规则类型名称',
  `ai_comment_type_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ai点评类型名称	',
  `phone_date_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '电话任务发送时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后 固定下拉字典表配置)	',
  `phone_date_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '电话任务发送时间类型名称	',
  `is_other_recommend_charge` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '其他推荐收费值',
  `preach_education_preview_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣讲资料url',
  `dept_codes_list` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '科室编码json',
  `diag_level_compilation` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用疾病层级',
  `product_title` varchar(255) NOT NULL DEFAULT '' COMMENT '服务产品名称',
  `confirm_status` tinyint NOT NULL DEFAULT '0' COMMENT '状态 0:未审核，1:审核中，2:审核失败，3:审核成功',
  `price_id` char(32) DEFAULT NULL COMMENT '物价表id',
  `update_level` tinyint unsigned DEFAULT '255' COMMENT '更新级别 0一般更新 1重要更新 255表示默认',
  `change_effect_handle_list` varchar(40) DEFAULT '' COMMENT '更新内容 10 产品外部名 11 服务产品介绍 12 专项医疗数据 13 宣讲资料 14 专病档案 15 专题包 16 电话任务 17 咨询服务 18 授权医院 19 异常规则 20 AI点评规则',
  `nutrition_program_open_status` tinyint(1) DEFAULT '0' COMMENT '个性化营养方案1开0关  默认0',
  `nutrition_program_value_rule` tinyint(1) DEFAULT NULL COMMENT '个性化营养方案取值规则0向上1向下  默认空',
  `drug_remind_flag` tinyint DEFAULT '0' COMMENT '用药闹钟设置 0:关 1:开',
  `psy_day_count` int DEFAULT NULL COMMENT '心理咨询天数设置如果为null则默认没有开启',
  `is_project_show` int DEFAULT '0' COMMENT '是否在项目中进行展示 0:否 1:是',
  `report_type_config` varchar(500) DEFAULT NULL COMMENT '报告类型配置',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_t_h_service_goods_product_version` (`product_id`,`product_version_id`),
  KEY `t_h_service_goods_product_id_IDX` (`product_id`,`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='服务商品表';

-- ----------------------------
-- Table structure for t_h_service_goods_his
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_goods_his`;
CREATE TABLE `t_h_service_goods_his` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `goods_version_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '商品版本ID',
  `goods_content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '服务商品内容',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `is_delete` tinyint(1) NOT NULL COMMENT '1删除0未删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品专题包关系表';

-- ----------------------------
-- Table structure for t_h_service_goods_log
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_goods_log`;
CREATE TABLE `t_h_service_goods_log` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `editor_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime DEFAULT NULL,
  `log_type_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作名称',
  `good_version_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品版本id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_service_goods_package
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_goods_package`;
CREATE TABLE `t_h_service_goods_package` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `goods_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '服务商品id',
  `goods_version_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '商品版本ID',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '专题包id',
  `service_package_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '专题包名称',
  `is_delete` tinyint(1) NOT NULL COMMENT '1删除0未删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `rule_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '规则id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品专题包关系表';

-- ----------------------------
-- Table structure for t_h_service_goods_prices
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_goods_prices`;
CREATE TABLE `t_h_service_goods_prices` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '医院机构代码',
  `record_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '飞书多维表格唯一标识',
  `item_number` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '项目编号',
  `charge_item_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '开单项目',
  `service_cycle_value` smallint DEFAULT NULL COMMENT '服务周期-数值',
  `service_cycle_unit` tinyint DEFAULT '1' COMMENT '服务周期-单位',
  `service_term` smallint DEFAULT NULL COMMENT '服务期限，单位默认为天',
  `unit_price` double DEFAULT NULL COMMENT '单价',
  `quantity` tinyint DEFAULT NULL COMMENT '数量',
  `price` double DEFAULT NULL COMMENT '商品价格',
  `is_open` tinyint DEFAULT '1' COMMENT '1.启用,0.停用',
  `creator_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人名称',
  `editor_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '编辑时间',
  `publicity_charge_item_name` varchar(64) DEFAULT NULL COMMENT '公示中的开单项目名称',
  `status` tinyint DEFAULT NULL COMMENT '物价性质，1.正式，0.临时',
  `belong_project_code` varchar(64) DEFAULT NULL COMMENT '所属项目编码',
  `belong_project_name` varchar(64) DEFAULT NULL COMMENT '所属项目名称',
  `signing_team_type` tinyint DEFAULT '2' COMMENT '1.轻舞,2.城市,3.私域',
  `payer` tinyint DEFAULT '2' COMMENT '1.医院,2.患者',
  `is_special_medical_services` tinyint DEFAULT '1' COMMENT '是否特需医疗服务，1.是，0.否',
  `serve_type` tinyint DEFAULT NULL COMMENT '服务类别，1.高净值,2.精细化',
  `serve_exception` varchar(10) DEFAULT '1' COMMENT '开单异常，1.住院，9.其他，默认住院',
  `publicity_address` varchar(200) DEFAULT NULL COMMENT '上传公示资料地址',
  `price_grade_type_code` varchar(2) DEFAULT NULL COMMENT '档位0：49,1：99,2：295,3：795,4：1590,6：29 ,7：395 ,8：2616 ,9：3180',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='商品物价表';

-- ----------------------------
-- Table structure for t_h_service_goods_recommended
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_goods_recommended`;
CREATE TABLE `t_h_service_goods_recommended` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `push_content_type` tinyint DEFAULT NULL COMMENT '待办详情 4=推荐产品 5=推荐商品',
  `pat_id` varchar(32) DEFAULT NULL COMMENT '患者id',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `product_goods_id` varchar(32) DEFAULT NULL COMMENT '产品/商品',
  `product_goods_sort_no` tinyint DEFAULT NULL COMMENT '产品/商品 推荐顺序)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `is_delete` int DEFAULT NULL COMMENT '是否删除 0=否 1=是',
  `detail_id` varchar(32) DEFAULT NULL COMMENT '规则id',
  PRIMARY KEY (`id`),
  KEY `t_h_service_goods_recommended_pat_id_IDX` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分群推荐商品记录';

-- ----------------------------
-- Table structure for t_h_service_goods_task
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_goods_task`;
CREATE TABLE `t_h_service_goods_task` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `goods_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '服务商品id',
  `goods_version_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '商品版本ID',
  `goods_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专题包id',
  `task_prop` int DEFAULT NULL COMMENT '规则任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `task_time_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '1' COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `task_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/提醒类型名称',
  `task_type` int DEFAULT NULL COMMENT '宣教类型/提醒类别( 宣教类型: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒类别: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒,310:挂号提醒 )',
  `task_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教类型/提醒类别名称',
  `begin_time_type` int DEFAULT NULL COMMENT '发送时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后 固定下拉字典表配置)',
  `begin_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送时间类型名称',
  `business_date_type` int DEFAULT NULL COMMENT '收案后-业务时间类型(0,收案日期 1,预产期 2,末次月经日期 3,手术日期 4,检验日期 5,检查时间 6,胚胎移植日期 7,分娩日期)',
  `business_date_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案后-业务时间类型名称',
  `after_begin_time` int DEFAULT NULL COMMENT '距开始时间后',
  `after_begin_time_unit` int DEFAULT NULL COMMENT '时间单位(系统下拉配置表取值 1:天 2:周 3:月 4:年)',
  `after_begin_time_unit_name` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '时间单位名称',
  `after_begin_time_hour` int DEFAULT NULL COMMENT '需提醒日程的具体时间(0-20, 0点-20点, 页面写死)',
  `advance_send_time` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒提前发送时间(转换成小时存,前端下拉从固定字典表取)',
  `advance_send_time_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提前发送时间名称',
  `after_begin_time_days` int DEFAULT NULL COMMENT '距开始时间后-天(根据时间单位转换成天数)',
  `timing_date` date DEFAULT NULL COMMENT '定时日期(定时任务用)',
  `range_days` int DEFAULT NULL COMMENT '范围天数',
  `frequency` int DEFAULT NULL COMMENT '周期(周期性随访)',
  `frequency_unit` int DEFAULT NULL COMMENT '周期单位(周期性随访)(1,天/次, 2,月/次 3,年/次)',
  `frequency_unit_name` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '周期单位名称(周期性随访)',
  `frequency_count` int DEFAULT NULL COMMENT '周期循环次数',
  `content_id` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒ID(多选逗号","分隔,上限10个)',
  `content_title` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒标题(多选逗号","分隔,上限10个)',
  `return_visit_type` int DEFAULT NULL COMMENT '回访方式(1,电话;2,app,短信,微信;)',
  `return_visit_type_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '回访方式名称',
  `valid_days` int DEFAULT NULL COMMENT '有效天数(天)',
  `remind_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单说明/提醒内容',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '删除标识(0:未删除 1:已删除)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `content_json` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '表单/宣教/提醒标题完整内容',
  `follow_error_level` varchar(6) DEFAULT NULL COMMENT '关注的异常等级（0轻度，1中度，2重度，支持多选，必填） ',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `t_h_service_goods_task_goods_version_id_IDX` (`goods_version_id`) USING BTREE,
  KEY `t_h_service_goods_task_goods_id_IDX` (`goods_id`) USING BTREE,
  KEY `t_h_service_goods_task_task_prop_IDX` (`task_prop`,`content_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='服务商品任务表';

-- ----------------------------
-- Table structure for t_h_service_item
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_item`;
CREATE TABLE `t_h_service_item` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `service_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务项目名称',
  `pack_ids` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径ids',
  `pack_names` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径名称',
  `desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '说明',
  `is_status` int DEFAULT NULL COMMENT '状态 0：启用 1：停用',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_manage
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_manage`;
CREATE TABLE `t_h_service_manage` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者id',
  `pat_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '患者姓名',
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户id',
  `user_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户姓名',
  `service_type_code` tinyint DEFAULT NULL COMMENT '服务类型',
  `service_type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '服务类型名称',
  `call_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '通话记录id',
  `call_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '录音播放路径',
  `agent` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '坐席工号',
  `service_note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '服务备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间、服务时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `mobile_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '手机号码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='手机号码';

-- ----------------------------
-- Table structure for t_h_service_package
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_package`;
CREATE TABLE `t_h_service_package` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '名称',
  `manage_path_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '管理路径Id',
  `manage_path_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '管理路径名称',
  `manage_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '管理计划id',
  `manage_plan_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '管理计划名称',
  `service_time` int DEFAULT NULL COMMENT '服务期限',
  `service_time_unit_code` int DEFAULT NULL COMMENT '服务期限单位code',
  `service_time_unit_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务期限单位name',
  `team_id` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `team_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '小组的名称',
  `service_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务名称',
  `banner_param` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'banner参数',
  `banner_picurl` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'banner的图片',
  `base_count` int DEFAULT NULL COMMENT '基础数量',
  `grow_count` int DEFAULT NULL COMMENT '增长的数量',
  `service_type_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务类型编码',
  `service_type_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '服务类型名称',
  `service_app_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'appid',
  `service_path` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务路径',
  `treatment_type_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '数疗类型编码',
  `treatment_type_name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数疗类型名称',
  `treatment_path` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '数疗路径',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `is_delete` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '删除标记 1、删除',
  `is_finish` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '收案标记 1、收案',
  `treatment_app_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `service_package_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务编码',
  `mini_program_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '小程序编码',
  `mini_program_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '小程序名称',
  `init_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '初始化url',
  `init_version` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '初始化版本',
  `informed_consent` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '知情同意书',
  `batch` int DEFAULT NULL COMMENT '批次',
  `init_type_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '初始化类型编码',
  `init_type_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '初始化类型名称',
  `init_app_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '初始化appId',
  `application_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '应用的id',
  `application_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '应用的名称',
  `money` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包金额',
  `patient_detail_url` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者详情页面',
  `patient_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者类型',
  `type` int DEFAULT NULL COMMENT '类型 1、数疗类型；2、服务类型 3减重',
  `diag_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病编码',
  `diag_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病名称',
  `app_exhibit_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '小程序展示名称',
  `group_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '对应的团队编码id',
  `qa_instance_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `unusual_matters_judge_type` tinyint(1) DEFAULT '0' COMMENT '异常规则类型 1成人减重类，2妊糖类、3多囊类',
  `ai_frequency_type` tinyint(1) DEFAULT '0' COMMENT 'ai点评类型 0：无 1成人减重类，2妊糖类',
  `diagnosis_type` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '诊断类型：普通版 regular, 高血压版 hypertension,糖尿病版 diabetes,人流、产后版 abortionPostpartum,饮食建议版 dietAdvice;',
  `auto_service_flag` tinyint DEFAULT NULL COMMENT '自动收案标志 1：自动收案 0：不自动收案',
  `product_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品 id',
  `goods_name` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='对应的团队编码id';

-- ----------------------------
-- Table structure for t_h_service_price_basic
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_price_basic`;
CREATE TABLE `t_h_service_price_basic` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '医院机构代码',
  `start_date` timestamp NULL DEFAULT NULL COMMENT '适用开始时间',
  `end_date` timestamp NULL DEFAULT NULL COMMENT '适用结束时间',
  `price` double DEFAULT NULL COMMENT '基准价格',
  `status` tinyint DEFAULT '2' COMMENT '1.启用,0.停用,2.待开启',
  `creator_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人名称',
  `editor_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑人名称',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '编辑时间',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='基准价配置';

-- ----------------------------
-- Table structure for t_h_service_price_revision_history
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_price_revision_history`;
CREATE TABLE `t_h_service_price_revision_history` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `relation_id` char(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '物价 id',
  `charge_item_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'his 开单项目',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `creator_id` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人 id',
  `creator_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人 姓名',
  PRIMARY KEY (`id`),
  KEY `idx_relation_id` (`relation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_service_quality_comment
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_quality_comment`;
CREATE TABLE `t_h_service_quality_comment` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `service_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者服务id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者主索引',
  `month` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '月份',
  `is_rectification` int DEFAULT NULL COMMENT '整改标志 0：否 1：已整改 2：需要整改',
  `comment_content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '点评内容',
  `comment_edu_content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣教质量点评',
  `comment_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '点评人id',
  `comment_user_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '点评人',
  `comment_time` datetime DEFAULT NULL COMMENT '点评时间',
  `is_deal` int DEFAULT NULL COMMENT '处理标志 0：未处理  1：已处理',
  `deal_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理人id',
  `deal_user_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '处理人',
  `deal_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '点评备注',
  `is_delete` int DEFAULT NULL COMMENT '删除标志',
  `patient_satisfaction_code` int DEFAULT NULL COMMENT '患者满意度',
  `patient_satisfaction_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者满意度',
  `actual_comment_time` datetime DEFAULT NULL COMMENT '实际点评时间',
  `actual_deal_time` datetime DEFAULT NULL COMMENT '实际处理时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_service` (`service_id`) USING BTREE,
  KEY `idx_empi` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_quality_focus
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_quality_focus`;
CREATE TABLE `t_h_service_quality_focus` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引',
  `desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `focus_flag` int DEFAULT NULL COMMENT '1:重点关注',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user` (`user_id`) USING BTREE,
  KEY `empi` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_quality_reply
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_quality_reply`;
CREATE TABLE `t_h_service_quality_reply` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `comment_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '点评主键id',
  `reply_content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '回复内容',
  `reply_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '回复人id',
  `reply_user_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '回复人',
  `reply_time` datetime DEFAULT NULL COMMENT '回复时间',
  `reply_common_content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '共性整改',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '是否删除（0：否，1：是）',
  `deal_time` datetime DEFAULT NULL COMMENT '处理时间',
  `reply_type` int DEFAULT NULL COMMENT '回复类型（1：路径，2：宣教）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_quality_score
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_quality_score`;
CREATE TABLE `t_h_service_quality_score` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `service_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者服务主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者主索引',
  `month` int DEFAULT NULL COMMENT '月份',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户id',
  `score_project_type` int DEFAULT NULL COMMENT '评分项目类型',
  `score_project_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '评分项目类型名称',
  `score` int DEFAULT NULL COMMENT '分数',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_quality_score_json
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_quality_score_json`;
CREATE TABLE `t_h_service_quality_score_json` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `service_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `score_json` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_quality_selection
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_quality_selection`;
CREATE TABLE `t_h_service_quality_selection` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户id',
  `service_day_low` int DEFAULT NULL COMMENT '服务天数下限',
  `service_day_up` int DEFAULT NULL COMMENT '服务天数上限',
  `people_number` int DEFAULT NULL COMMENT '人数',
  `viewd_empi_id` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '已查看患者主索引',
  `today_empi_id` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin COMMENT '今日抽查患者',
  `dept_codes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `today_viewd_empi_id` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '今日已查看抽查患者',
  `sort` int DEFAULT NULL COMMENT '排序',
  `is_filter_commented` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_service_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_service_record`;
CREATE TABLE `t_h_service_record` (
  `id` bigint NOT NULL,
  `pat_id` varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '开单id',
  `event_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '对应事件id',
  `event_time` datetime DEFAULT NULL COMMENT '对应事件事件',
  `business_process` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务环节',
  `manage_record` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '管理记录拆解',
  `prescription` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `content` varchar(1024) COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `executor` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '具体执行',
  `begin_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `sort` int NOT NULL COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务记录';

-- ----------------------------
-- Table structure for t_h_sl_mission
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sl_mission`;
CREATE TABLE `t_h_sl_mission` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `type_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务类型(可配置)',
  `hug_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者蓝牛号',
  `content` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务内容（json）',
  `result` int DEFAULT NULL COMMENT '1、待随访、2、进行中、3、处理中、4、已完成、5、已结案',
  `create_time` datetime DEFAULT NULL COMMENT '开始时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` int DEFAULT NULL COMMENT '1、删除标记 0正常',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引号-查询患者详情信息',
  `level` int DEFAULT NULL COMMENT '任务优先级1-10 默认是5',
  `desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务的概述',
  `application_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '应用的id',
  `service_package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包的id',
  `version` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务版本号',
  `sex_code` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别编码',
  `sex_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别名称',
  `diag_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '诊断编码',
  `diag_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '诊断名称',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组名称',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '随访时间',
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院名称',
  `application_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '应用的名称',
  `service_package_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包的名称',
  `age` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '年龄',
  `es_flag` int DEFAULT NULL COMMENT '是否需要同步到es',
  `pat_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '姓名',
  `id_number` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '身份证',
  `mobile_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号码',
  `order_open_dr_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医生职工工号',
  `order_open_dr_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医生职工名称',
  `order_open_dept_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室编码',
  `order_open_dept_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `type_code` (`type_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_sl_mission_type
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sl_mission_type`;
CREATE TABLE `t_h_sl_mission_type` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `code` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '类型编码',
  `name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '类型名称',
  `picture_url` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片的url',
  `create_time` datetime DEFAULT NULL COMMENT '开始时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` int DEFAULT NULL COMMENT '1、删除标记 0正常',
  `is_batch` int DEFAULT NULL COMMENT '1、批量处理，默认0',
  `is_doctor` int DEFAULT NULL COMMENT '1、医生端 默认是0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_sl_mission_type_property
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sl_mission_type_property`;
CREATE TABLE `t_h_sl_mission_type_property` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `type_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '类型',
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '字段名称 -- 中文',
  `relation_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '字典类型1、字典表；2、文本；3、时间',
  `relation_type_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '字典类型名称',
  `code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '字段',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_delete` int DEFAULT NULL COMMENT '1、删除 其他未删除',
  `relation_content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '字典表的类型',
  `is_screen` int DEFAULT NULL COMMENT '1、支持筛选 其他不支持筛选',
  `sort` int DEFAULT NULL COMMENT '排序值',
  `screen_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '筛选字段编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_sl_patient_index
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sl_patient_index`;
CREATE TABLE `t_h_sl_patient_index` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主索引id',
  `type` int DEFAULT NULL COMMENT '类型',
  `json_value` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'json',
  `measure_time` datetime DEFAULT NULL COMMENT '测量时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `execution_date` datetime DEFAULT NULL COMMENT '执行时间',
  `hug_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_sl_role_mission_type_relate
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sl_role_mission_type_relate`;
CREATE TABLE `t_h_sl_role_mission_type_relate` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `role_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '角色主键',
  `role_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '角色名称',
  `mission_type_id` varchar(0) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务类型id',
  `mission_type_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务类型编码',
  `mission_type_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务类型名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分配人id',
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分配人名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_sl_service_item
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sl_service_item`;
CREATE TABLE `t_h_sl_service_item` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主索引id',
  `phone` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号码',
  `pat_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者姓名',
  `service_type` int DEFAULT NULL COMMENT '服务类型',
  `min_type` int DEFAULT NULL COMMENT '服务类型小类别',
  `content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `jump_type` int DEFAULT NULL,
  `app_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `jump_path` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `min_type_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `title` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hug_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_sl_user_mission_property_relate
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sl_user_mission_property_relate`;
CREATE TABLE `t_h_sl_user_mission_property_relate` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户主键',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户名称',
  `property_content` varchar(0) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务属性json字符串',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分配人id',
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分配人名称',
  `mission_type_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_sl_user_mission_relate
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sl_user_mission_relate`;
CREATE TABLE `t_h_sl_user_mission_relate` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户主键',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户名称',
  `mission_id` varchar(0) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务id',
  `mission_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分配人id',
  `editor_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分配人名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_sms_param
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sms_param`;
CREATE TABLE `t_h_sms_param` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `param` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单id',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务的id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_sms_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sms_patient`;
CREATE TABLE `t_h_sms_patient` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `sms_task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '短信任务主题ID',
  `pay_patients_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单患者ID',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者姓名',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '主索引号',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引号',
  `mobile_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号',
  `send_status` int DEFAULT '0' COMMENT '发送状态(0:未发送 1:已发送)',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `dept_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者科室编码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者科室名称',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人ID',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人姓名',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='发送患者短信';

-- ----------------------------
-- Table structure for t_h_sms_task
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sms_task`;
CREATE TABLE `t_h_sms_task` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医嘱开立科室名称',
  `status_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '1、全部 2、服务中 3、方案待制定 4、待宣讲 5、正常结案 6、中途退出 7 中途退费 8：未服务退费 9取消开单',
  `pay_patient_type` int DEFAULT NULL COMMENT '开单患者类型  1、健管开单患者 2、数疗开单 3、减重开单患者 4、服务数疗开单患者',
  `model_id` int DEFAULT NULL COMMENT '模板id',
  `model_type` int DEFAULT NULL COMMENT '模板类别',
  `model_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '模板类别名称',
  `sms_content` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '短信内容',
  `send_status` int DEFAULT NULL COMMENT '是否发送(0:否 1:是)',
  `send_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '定时日期',
  `send_hour` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '定时时间小时',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人ID',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人姓名',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '收费项目代码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='短信设置表';

-- ----------------------------
-- Table structure for t_h_sp_level_charge_item_rel
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sp_level_charge_item_rel`;
CREATE TABLE `t_h_sp_level_charge_item_rel` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '医院编码',
  `service_pack_level` tinyint NOT NULL COMMENT '服务包级别  1:专病短期精细化管理 2:专病短期精细化强化管理 3:专病标准精细化管理 4:专病标准精细化强化管理 5:专病强干预管理',
  `charge_item_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '收费项目代码',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_by` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(6) NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='服务包等级-开单项目关联表';

-- ----------------------------
-- Table structure for t_h_special_disease_data
-- ----------------------------
DROP TABLE IF EXISTS `t_h_special_disease_data`;
CREATE TABLE `t_h_special_disease_data` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单主键',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲任务ID',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引',
  `data_type` int DEFAULT NULL COMMENT '数据类型 0-文本 1-数字 2-类型',
  `data_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '数据编码',
  `data_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '数据名称',
  `specific_value` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '具体数值',
  `create_time` datetime DEFAULT NULL,
  `is_delete` int DEFAULT NULL COMMENT '1：删除',
  `pack_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务路径id',
  `business_meaning` int DEFAULT NULL COMMENT '业务含义 0-基线时间 99-其他',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_special_medical_data
-- ----------------------------
DROP TABLE IF EXISTS `t_h_special_medical_data`;
CREATE TABLE `t_h_special_medical_data` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开单主键',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '宣讲任务ID',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引',
  `data_type` int DEFAULT NULL COMMENT '数据类型  1-疾病 2-手术 3-药物 4-检验 5、科室 6-检查',
  `data_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '数据编码',
  `data_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '数据名称',
  `time_point_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '时间点名称',
  `time_point_value` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '时间点数值',
  `specific_time` datetime DEFAULT NULL COMMENT '具体时间',
  `create_time` datetime DEFAULT NULL,
  `is_delete` int DEFAULT NULL COMMENT '1：删除',
  `package_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '服务包id',
  `is_sync` int DEFAULT NULL COMMENT '1:同步',
  `is_secondary` int DEFAULT '0' COMMENT '是否是辅助方案时间',
  `is_abandoned` tinyint(1) DEFAULT '0' COMMENT '作废标志 1：作废',
  `goods_id` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品 id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='开单专项医疗数据表';

-- ----------------------------
-- Table structure for t_h_sport_collection
-- ----------------------------
DROP TABLE IF EXISTS `t_h_sport_collection`;
CREATE TABLE `t_h_sport_collection` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '健管云患者id',
  `exercise_types` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '运动种类',
  `exercise_unit` tinyint DEFAULT NULL COMMENT '运动单位 1-天 2-周',
  `exercise_num` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '运动次数',
  `exercise_duration` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '运动时长',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='运动信息采集表';

-- ----------------------------
-- Table structure for t_h_standardized_batch_arrangement
-- ----------------------------
DROP TABLE IF EXISTS `t_h_standardized_batch_arrangement`;
CREATE TABLE `t_h_standardized_batch_arrangement` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(100) DEFAULT NULL COMMENT '机构名称',
  `disease_id` varchar(32) DEFAULT NULL COMMENT '病种',
  `disease_name` varchar(100) DEFAULT NULL COMMENT '病种',
  `goods_id` varchar(32) DEFAULT NULL COMMENT '商品',
  `goods_name` varchar(100) DEFAULT NULL COMMENT '商品',
  `teach_form_id` varchar(32) DEFAULT NULL COMMENT '问卷formId',
  `teach_form_name` varchar(100) DEFAULT NULL COMMENT '问卷名称',
  `team_id` varchar(100) DEFAULT NULL,
  `team_name` varchar(100) DEFAULT NULL COMMENT '分组名称',
  `group_id` varchar(32) DEFAULT NULL COMMENT '团队id',
  `user_id` varchar(32) DEFAULT NULL COMMENT '管理人员id',
  `user_name` varchar(20) DEFAULT NULL COMMENT '管理人员',
  `auto_send_flag` tinyint DEFAULT NULL COMMENT '患者自动发送标识 0:不发 1:自动发送',
  `record_model_type` tinyint DEFAULT NULL COMMENT '0.非通用模板，1.通用模板,2:pio通用',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(20) DEFAULT NULL COMMENT '边际人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `is_delete` tinyint DEFAULT NULL COMMENT '删除标志',
  `group_name` varchar(20) DEFAULT NULL COMMENT '团队名称',
  PRIMARY KEY (`id`),
  KEY `t_h_standardized_batch_arrangement_hosp_code_IDX` (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规范化诊疗批量收案配置';

-- ----------------------------
-- Table structure for t_h_standardized_synch_fail_msg
-- ----------------------------
DROP TABLE IF EXISTS `t_h_standardized_synch_fail_msg`;
CREATE TABLE `t_h_standardized_synch_fail_msg` (
  `id` varchar(32) NOT NULL COMMENT 'id',
  `create_time` datetime DEFAULT NULL,
  `business_code` varchar(32) DEFAULT NULL COMMENT '协议号',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `msg_json` text COMMENT '内容json',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规范化诊疗同步失败记录表';

-- ----------------------------
-- Table structure for t_h_standardized_treatment_exclusion
-- ----------------------------
DROP TABLE IF EXISTS `t_h_standardized_treatment_exclusion`;
CREATE TABLE `t_h_standardized_treatment_exclusion` (
  `id` varchar(32) NOT NULL COMMENT '开单id',
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '患者主索引号',
  `exclusion_reason_code` varchar(10) DEFAULT NULL COMMENT '剔除原因',
  `exclusion_reason_desc` varchar(200) DEFAULT NULL COMMENT '剔除原因',
  `exclusion_type` varchar(2) DEFAULT NULL COMMENT '剔除范围：1仅剔除本次 2永久剔除 3时间范围内剔除',
  `exclusion_deadline` int DEFAULT NULL COMMENT '剔除时间范围',
  `exclusion_time` datetime DEFAULT NULL COMMENT '剔除时间',
  `exclusion_editor_id` varchar(32) DEFAULT NULL COMMENT '剔除操作人',
  `exclusion_editor_name` varchar(20) DEFAULT NULL COMMENT '剔除操作人',
  PRIMARY KEY (`id`),
  KEY `t_h_standardized_treatment_exclusion_empi_id_IDX` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规范化诊疗剔除表';

-- ----------------------------
-- Table structure for t_h_standardized_treatment_target
-- ----------------------------
DROP TABLE IF EXISTS `t_h_standardized_treatment_target`;
CREATE TABLE `t_h_standardized_treatment_target` (
  `id` varchar(32) NOT NULL COMMENT 'id',
  `empi_id` varchar(32) DEFAULT NULL COMMENT 'empiId',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `pay_id` varchar(32) DEFAULT NULL COMMENT '开单id',
  `mission_id` varchar(32) DEFAULT NULL COMMENT '任务id',
  `is_finish_visit` tinyint DEFAULT NULL COMMENT '是否完成就诊 0否 1是',
  `finish_visit_date` datetime DEFAULT NULL COMMENT '完成就诊日期',
  `finish_visit_dept_code` varchar(30) DEFAULT NULL COMMENT '完成就诊科室编码',
  `finish_visit_dept_name` varchar(30) DEFAULT NULL COMMENT '完成就诊科室名称',
  `is_finish_surgery` tinyint DEFAULT NULL COMMENT '是否完成手术 0否 1是',
  `finish_surgery_date` datetime DEFAULT NULL COMMENT '完成手术日期',
  `finish_surgery_name` varchar(30) DEFAULT NULL COMMENT '手术名称',
  `is_delete` tinyint DEFAULT NULL COMMENT '删除标记',
  `create_time` datetime DEFAULT NULL,
  `finish_inhosp_date` datetime DEFAULT NULL COMMENT '完成就诊日期',
  `finish_inhosp_doc_code` varchar(20) DEFAULT NULL COMMENT '完成就诊 医生工号',
  `finish_inhosp_doc_name` varchar(20) DEFAULT NULL COMMENT '完成就诊 医生姓名',
  `finish_inhosp_dept_code` varchar(20) DEFAULT NULL COMMENT '完成就诊 科室',
  `finish_inhosp_dept_name` varchar(20) DEFAULT NULL COMMENT '完成就诊 科室',
  `finish_inhosp_serial_no` varchar(20) DEFAULT NULL COMMENT '完成就诊 流水号',
  `is_finish_inhosp` tinyint(1) DEFAULT NULL COMMENT '是否完成住院 0否 1是',
  PRIMARY KEY (`id`),
  KEY `t_h_standardized_treatment_target_mission_id_IDX` (`mission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规范化诊疗目标表';

-- ----------------------------
-- Table structure for t_h_surgery_match
-- ----------------------------
DROP TABLE IF EXISTS `t_h_surgery_match`;
CREATE TABLE `t_h_surgery_match` (
  `id` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pay_id` char(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开单id',
  `empi_id` char(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `request_id` char(36) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '匹配请求描述符',
  `hosp_code` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `surgery_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '手术日期',
  `surgery_date_raw` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手术日期原始信息',
  `surgery_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `surgery_name_raw` text COLLATE utf8mb4_general_ci,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '匹配时间',
  `success_flag` tinyint NOT NULL DEFAULT '1' COMMENT '是否调用接口成功',
  PRIMARY KEY (`id`),
  KEY `idx_patient` (`pay_id`,`hosp_code`),
  KEY `idx_empi` (`empi_id`,`hosp_code`),
  KEY `idx_request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_task_monitor
-- ----------------------------
DROP TABLE IF EXISTS `t_h_task_monitor`;
CREATE TABLE `t_h_task_monitor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `relation_type` int DEFAULT NULL COMMENT '类型 1、sop',
  `relation_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '路径的id或者服务包的id',
  `relation_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '关联名称',
  `day_num` int DEFAULT NULL COMMENT '天数',
  `followup_min_num` int DEFAULT NULL COMMENT '随访任务最少数量',
  `edu_min_num` int DEFAULT NULL COMMENT '宣教任务最少数量',
  `remind_min_num` int DEFAULT NULL COMMENT '提醒任务最少个数',
  `coordinate_status` int DEFAULT NULL COMMENT '1、配合 2、不配合',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_team
-- ----------------------------
DROP TABLE IF EXISTS `t_h_team`;
CREATE TABLE `t_h_team` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `team_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组名称',
  `team_level` int DEFAULT NULL COMMENT '分组等级',
  `team_parent_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组上级id',
  `sort` int DEFAULT NULL COMMENT '顺序',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_delete` int DEFAULT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `type` int DEFAULT NULL,
  `group_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '对应的团队编码id',
  `disease_type` tinyint DEFAULT NULL COMMENT '分组对应病种：1、乳腺癌 2、胃癌 3、结肠癌',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='对应的团队编码id';

-- ----------------------------
-- Table structure for t_h_team_patient_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_team_patient_relation`;
CREATE TABLE `t_h_team_patient_relation` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者主索引',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组id',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人',
  `editor_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '编辑人名称',
  `join_time` datetime DEFAULT NULL COMMENT '加入时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_team_product_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_team_product_relation`;
CREATE TABLE `t_h_team_product_relation` (
  `product_title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品内部名称',
  `first_team_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '一级分组',
  `second_team_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '二级分组',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`product_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='产品和分组的管理';

-- ----------------------------
-- Table structure for t_h_team_user_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_team_user_relation`;
CREATE TABLE `t_h_team_user_relation` (
  `id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户id',
  `team_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '分组id',
  `team_sort` int DEFAULT NULL COMMENT '排序',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_test_exception
-- ----------------------------
DROP TABLE IF EXISTS `t_h_test_exception`;
CREATE TABLE `t_h_test_exception` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '医院编码',
  `pay_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '开单患者id',
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '患者索引号',
  `test_type` tinyint(1) NOT NULL COMMENT '检查类型（1：检验，2：体检）',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查报告编号',
  `report_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查项目名称',
  `report_date` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '报告时间',
  `item_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查项目编号',
  `item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查项目名称',
  `item_result` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查结果',
  `item_unit` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检查结果单位',
  `reference_ranges` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '参考范围',
  `exception_flag` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '异常标志',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pay` (`pay_id`) USING BTREE,
  KEY `idx_hosp` (`hosp_code`) USING BTREE,
  KEY `idx_empi` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_test_item_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_test_item_relation`;
CREATE TABLE `t_h_test_item_relation` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `test_item_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检验项目编码',
  `test_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '检验项目名称',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机构代码',
  `health_item_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '健康监测项目编码',
  `health_item_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '健康监测项目名称',
  `dept_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室编码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室名称',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `target_value` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '目标值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_topic_task_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_h_topic_task_relation`;
CREATE TABLE `t_h_topic_task_relation` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联表单id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者ID',
  `task_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任务ID',
  `question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联题目ID',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `form_check` tinyint(1) DEFAULT '0' COMMENT '表单是否选中 0 未选中   1 选中',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单题目随访任务关系表';

-- ----------------------------
-- Table structure for t_h_user_category
-- ----------------------------
DROP TABLE IF EXISTS `t_h_user_category`;
CREATE TABLE `t_h_user_category` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户id',
  `user_category` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户标签code,多个以逗号分隔',
  `user_category_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户标签名称,多个以逗号分隔',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='用户标签表';

-- ----------------------------
-- Table structure for t_h_user_hosp
-- ----------------------------
DROP TABLE IF EXISTS `t_h_user_hosp`;
CREATE TABLE `t_h_user_hosp` (
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_codes` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_user_manage_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_h_user_manage_patient`;
CREATE TABLE `t_h_user_manage_patient` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者id',
  `group_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '团队id',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '删除标志',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `sort` tinyint(1) DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_h_user_task_statistics
-- ----------------------------
DROP TABLE IF EXISTS `t_h_user_task_statistics`;
CREATE TABLE `t_h_user_task_statistics` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `flag` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '类型',
  `create_time` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '创建时间',
  `start_time` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '开始时间',
  `end_time` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结束时间',
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户姓名',
  `real_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '真实姓名',
  `mobile_num` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '电话任务数量',
  `task_num` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '任务数量',
  `preach_num` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '制定任务数量',
  `referral_num` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '复诊任务数量',
  `ai_num` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'ai任务数量',
  `register_num` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '预约挂号数',
  `aierr_num` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'ai异常处理数',
  `tel_num` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '接听电话数',
  `group_num` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '分组管理数',
  `feedback_num` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '咨询回复数',
  `close_service_num` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '结案数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_virtual_man
-- ----------------------------
DROP TABLE IF EXISTS `t_h_virtual_man`;
CREATE TABLE `t_h_virtual_man` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `virtual_type` tinyint NOT NULL DEFAULT '0' COMMENT '数字人类型 0 医生，1公共',
  `hosp_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '机构代码',
  `hosp_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '医院名称',
  `dept_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '科室代码',
  `dept_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '科室名称',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '数字人名称',
  `sex_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别编码 1男 0 女',
  `sex_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别',
  `role_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '角色编码',
  `role_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '角色名称',
  `img_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图片地址',
  `audio_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '音频地址',
  `demo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '演示视频地址',
  `examine_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '审核用户id',
  `examine_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '审核用户名称',
  `examine_time` datetime DEFAULT '1970-01-01 00:00:00',
  `examine_status` tinyint DEFAULT '0' COMMENT '审核状态 0不通过 1通过',
  `not_pass_reason` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '不通过原因',
  `create_time` datetime DEFAULT (now()) COMMENT '上传时间',
  `update_time` datetime DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  `is_delete` int DEFAULT '0',
  `audio_id` varchar(37) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `audio_qq_url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '腾讯这边的音频地址',
  `demo_audio_url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '腾讯的演示音频地址',
  `video_url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '制作完成的视频地址',
  `audio_demo_task_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '音频demo制作任务id',
  `video_demo_task_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '视频demo制作任务id',
  `video_task_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '视频制作任务id',
  `virtualman_key` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '腾讯数字人key',
  `timbre_key` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '音频返回的音色key',
  `train_text` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用于生成视频的文本',
  `text_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '训练文本id',
  `state` int NOT NULL DEFAULT '0' COMMENT '数字人状态',
  `img_qq_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '数字人图片腾讯地址',
  `virtual_man_state` tinyint NOT NULL DEFAULT '0' COMMENT '数字人状态2合1， 0待审核 1审核通过 2审核不通过 3生成中 4生成完成，5生成失败',
  `subtitles_url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT 'demo字幕地址',
  `doctor_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '医生工号',
  `fail_msg` varchar(2000) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '失败原因',
  `img_demo_task_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '形象制作任务id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_virtual_man_task
-- ----------------------------
DROP TABLE IF EXISTS `t_h_virtual_man_task`;
CREATE TABLE `t_h_virtual_man_task` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `virtual_man_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '数字人id',
  `task_type` tinyint NOT NULL DEFAULT '0' COMMENT '任务类型 1音色 2图片形象 3视频',
  `task_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_h_wechat_link
-- ----------------------------
DROP TABLE IF EXISTS `t_h_wechat_link`;
CREATE TABLE `t_h_wechat_link` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键id',
  `link_type` tinyint(1) NOT NULL COMMENT '链接类型（1：小程序，2：公众号模板消息）',
  `link_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '链接地址',
  `param` text CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '生成链接参数',
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者标识id',
  `send_status` tinyint(1) NOT NULL COMMENT '发送状态（0：未发送，1：发送成功，2：发送失败）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_h_weekly_followup
-- ----------------------------
DROP TABLE IF EXISTS `t_h_weekly_followup`;
CREATE TABLE `t_h_weekly_followup` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hosp_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL,
  `revisit_result` tinyint DEFAULT NULL COMMENT '0未完成 1已完成 -1 过期',
  `create_time` datetime DEFAULT NULL,
  `deal_time` datetime DEFAULT NULL COMMENT '处理时间',
  `deal_user_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理人',
  `last_deal_time` datetime DEFAULT NULL COMMENT '上次处理时间',
  `suggestion` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '建议',
  `msg_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模型msgId',
  `intervention_days` int DEFAULT NULL COMMENT '干预天数',
  `last_week_weight_time` datetime DEFAULT NULL COMMENT '上周体重记录时间',
  `last_week_weight` decimal(8,2) DEFAULT NULL COMMENT '上周体重',
  `this_week_weight` decimal(8,2) DEFAULT NULL COMMENT '本周体重',
  `this_week_weight_time` datetime DEFAULT NULL COMMENT '本周体重记录时间',
  `diet_proportion` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '饮食比例',
  `sport_duration` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '运动时长',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `sport_days` tinyint DEFAULT NULL COMMENT '运动天数',
  PRIMARY KEY (`id`),
  KEY `t_h_weekly_followup_pay_id_IDX` (`pay_id`) USING BTREE,
  KEY `t_h_weekly_followup_hosp_code_IDX` (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='周跟进任务表';

-- ----------------------------
-- Table structure for t_h_workload
-- ----------------------------
DROP TABLE IF EXISTS `t_h_workload`;
CREATE TABLE `t_h_workload` (
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `user_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户名称',
  `collector_num` int DEFAULT NULL,
  `calls_num` int DEFAULT NULL,
  `task_num` int DEFAULT NULL,
  `followup_num` int DEFAULT NULL,
  `ai_num` int DEFAULT NULL,
  `report_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_hosp_location
-- ----------------------------
DROP TABLE IF EXISTS `t_hosp_location`;
CREATE TABLE `t_hosp_location` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院名',
  `hospital_area_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '院区code',
  `hospital_area_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '院区名称',
  `latitude` decimal(9,6) DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(9,6) DEFAULT NULL COMMENT '经度',
  `range` int DEFAULT NULL COMMENT '范围',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='医院位置配置表';

-- ----------------------------
-- Table structure for t_hosp_warn
-- ----------------------------
DROP TABLE IF EXISTS `t_hosp_warn`;
CREATE TABLE `t_hosp_warn` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'id',
  `organ_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '机构代码',
  `organ_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL COMMENT '机构名称',
  `res_status` int DEFAULT NULL COMMENT '异常状态 0：正常 1：超时 2：异常',
  `res` int DEFAULT NULL COMMENT '错误编码 超时：1111 ',
  `source_type` int DEFAULT NULL COMMENT '数据来源 1.住院医嘱 2.住院收费 3.门诊收费',
  `data_type` int DEFAULT NULL COMMENT '数据渠道 1.开立（计费） 2.执行（缴费） 3.作废（退费）',
  `details` text COLLATE utf8mb4_general_ci COMMENT '详情',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `key_organ_status` (`organ_code`,`res_status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='医院告警表';

-- ----------------------------
-- Table structure for t_hospital_followup_record
-- ----------------------------
DROP TABLE IF EXISTS `t_hospital_followup_record`;
CREATE TABLE `t_hospital_followup_record` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主索引号',
  `relation_type` int DEFAULT NULL COMMENT '关联任务类型(1:随访任务 2:随访记录 3:满意度任务 4:VIP任务 5:满意度记录 6:APP在院满意度调查 7:随访抽查 8:专科随访)',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任务ID',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单ID',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访计划ID(院级随访计划表主键)',
  `sender_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送人ID',
  `sender_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送人姓名',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送人科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送人科室名称',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `send_type` int DEFAULT NULL COMMENT '发送方式(1:APP/微信 2:短信 3:随访调研)',
  `pat_source_type` int DEFAULT NULL COMMENT '患者来源',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者业务流水号',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者手机号',
  `attend_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主治医生姓名',
  `pat_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者科室编码',
  `pat_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者科室名称',
  `dr_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生所属科室名称',
  `dr_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生所属科室代码',
  `pat_ward_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者病区编码',
  `pat_ward_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者病区名称',
  `reply_status` int DEFAULT '0' COMMENT '回复状态(0:未发送 -1:无回复 1:有回复)',
  `submit_status` int DEFAULT '0' COMMENT '提交状态(0:未提交 1:已提交)',
  `submit_type` int DEFAULT NULL COMMENT '提交类型(1,医生提交)',
  `submit_person` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提交人',
  `submit_time` datetime DEFAULT NULL COMMENT '提交时间',
  `exception_status` int DEFAULT NULL COMMENT '异常状态(0:无异常 1:有异常)',
  `reply_type` int DEFAULT NULL COMMENT '回复方式(1:APP 2:微信 3:短信 9:其他)',
  `send_answer` int DEFAULT '0' COMMENT '是否向第三方推送答案 0否 1是',
  `third_party` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '第三方机构名称',
  `talk_time` int DEFAULT '0' COMMENT '统计-通话时长',
  `mode_phone_count` int DEFAULT '0' COMMENT '统计-电话拨出次数',
  `mode_app_count` int DEFAULT '0' COMMENT '统计-APP发送次数',
  `mode_wechat_count` int DEFAULT '0' COMMENT '统计-微信发送次数',
  `mode_sms_count` int DEFAULT '0' COMMENT '统计-短信发送次数',
  `business_time` datetime DEFAULT NULL COMMENT '业务时间(门诊时间、出院时间、基线时间等等)',
  `ai_push_status` int DEFAULT '0' COMMENT 'AI推送状态(0:未推送 -1:未回复 1:已回复)',
  `ai_push_result_code` int DEFAULT NULL COMMENT 'AI推送结果状态值 0 正常, 其他 异常(具体AI系统定)',
  `ai_push_result_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI推送结果状态说明',
  `ai_push_time` datetime DEFAULT NULL COMMENT 'AI推送时间',
  `ai_push_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI推送人员ID',
  `auto_push_ai_times` int DEFAULT '0' COMMENT '自动AI推送次数',
  `manual_push_ai_times` int DEFAULT '0' COMMENT '手动AI推送次数',
  `ai_reply_time` datetime DEFAULT NULL COMMENT 'AI回复时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `primary_nurse_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '责任护士',
  `path_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '新专科随访路径id',
  `ai_reply_excp` tinyint(1) DEFAULT NULL COMMENT 'AI回复表单是否异常（1 异常）',
  `ai_reply_type` tinyint(1) DEFAULT NULL COMMENT '回复方式为AI(AI回复不覆盖原有的，单独放一个字段 5：AI语音 6：AI微信)',
  `ai_label_codes` varchar(330) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI标签代码逗号分隔串',
  `ai_label_names` varchar(510) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI标签名称逗号分隔串',
  `hospital_area_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属院区代码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_hospital_followup_record` (`submit_time`,`relation_type`) USING BTREE,
  KEY `index_send_time_relation_type` (`send_time`,`relation_type`) USING BTREE,
  KEY `idx_relation_id_form_id` (`relation_id`,`form_id`) USING BTREE,
  KEY `idx_business_time` (`business_time`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_serial_no` (`serial_no`) USING BTREE,
  KEY `idx_hosp_code_pat_dept_code` (`send_time`,`pat_dept_code`) USING BTREE,
  KEY `idx_form_id_dept_code_pat_dept_code_pat_ward_code` (`form_id`,`dept_code`,`pat_dept_code`,`pat_ward_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='随访记录表单拆分表';

-- ----------------------------
-- Table structure for t_informed_stamp
-- ----------------------------
DROP TABLE IF EXISTS `t_informed_stamp`;
CREATE TABLE `t_informed_stamp` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `task_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣讲任务id',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知情同意书盖章失败表';

-- ----------------------------
-- Table structure for t_inhosp_pdm_fee
-- ----------------------------
DROP TABLE IF EXISTS `t_inhosp_pdm_fee`;
CREATE TABLE `t_inhosp_pdm_fee` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `organ_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医嘱号（住院）',
  `deal_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '交易流水号',
  `charge_item_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '收费项目名称',
  `order_unit_price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '项目单价',
  `order_amount` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '项目数量',
  `charge_status` tinyint(1) DEFAULT NULL COMMENT '费用状态 1，已计费（未结算），2.已结算  3.已退费',
  `total_money` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '缴费金额',
  `calculate_time` datetime DEFAULT NULL COMMENT '计费时间',
  `charge_time` datetime DEFAULT NULL COMMENT '结算时间',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `is_upload` tinyint(1) DEFAULT '0' COMMENT '是否同步 0.未同步 1.已同步',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `deal_no` (`deal_no`) USING BTREE,
  KEY `hosp_code` (`organ_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='住院收费表';

-- ----------------------------
-- Table structure for t_inhosp_pdm_order
-- ----------------------------
DROP TABLE IF EXISTS `t_inhosp_pdm_order`;
CREATE TABLE `t_inhosp_pdm_order` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `organ_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '住院号',
  `inhosp_num` int NOT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '住院流水号',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '医嘱号(ID)',
  `order_type` tinyint(1) DEFAULT NULL COMMENT '1-文本医嘱（门诊收费） 2-收费医嘱（住院收费）',
  `order_item_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '医嘱项目代码',
  `order_item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '医嘱项目名称',
  `order_amount` int NOT NULL COMMENT '项目数量',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医嘱开立医生名称',
  `order_order_time` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医嘱备注',
  `order_status` tinyint(1) DEFAULT NULL COMMENT '医嘱状态 1.已开立 2.已执行 3.已撤消',
  `execution_time` datetime DEFAULT NULL COMMENT '执行时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '撤销时间',
  `is_upload` tinyint(1) DEFAULT '0' COMMENT '是否同步 0.未同步 1.已同步',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `drug_use_frequency_code` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医嘱类型 0-临时医嘱  1-长期医嘱',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_item` (`order_no`,`order_item_code`) USING BTREE,
  KEY `hosp_inhosp` (`organ_code`,`inhosp_serial_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='住院医嘱表';

-- ----------------------------
-- Table structure for t_intervention_option
-- ----------------------------
DROP TABLE IF EXISTS `t_intervention_option`;
CREATE TABLE `t_intervention_option` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键，唯一标识',
  `intervention_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '干预方案库 主键',
  `management_key_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Code',
  `management_key_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Name',
  `initial_measure_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '初始干预措施的Code',
  `initial_measure_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '初始干预措施的Name',
  `measure_upgrade_path_code` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '措施升级路径code',
  `measure_upgrade_path_name` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '措施升级路径name',
  `management_cycle` int DEFAULT NULL COMMENT '管理周期，数字表示周期长度',
  `management_cycle_unit` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理周期单位，1天、2周、3月',
  `priority` int DEFAULT '1' COMMENT '优先级，数字越大优先级越高，默认值为1',
  `benefit_statement` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '获益语，描述实施该措施后的预期收益',
  `risk_factor_code` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风险因素code',
  `risk_factor_name` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风险因素name',
  `management_goal_code` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理目标code',
  `management_goal_name` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理目标name',
  `is_regular_service` tinyint(1) DEFAULT '1' COMMENT '是否是常规服务 0否 1是',
  `execution_task` text COLLATE utf8mb4_general_ci COMMENT '执行任务，描述具体的执行步骤或任务',
  `sort` int DEFAULT NULL COMMENT '排序',
  `execution_difficulty` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行难度预测，1低、2中、3高',
  `execution_difficulty_reason` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行难度预测理由',
  `core_focus` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '核心关注',
  `initial_measure_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `is_auto_confirm` tinyint(1) DEFAULT '0',
  `is_use_okrs` tinyint(1) DEFAULT '0' COMMENT '是否使用okrs',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='干预措施库-管理要点';

-- ----------------------------
-- Table structure for t_intervention_patient_option
-- ----------------------------
DROP TABLE IF EXISTS `t_intervention_patient_option`;
CREATE TABLE `t_intervention_patient_option` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键，唯一标识',
  `original_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '源id',
  `pay_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '开单的id',
  `intervention_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '干预方案库 主键',
  `management_key_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Code',
  `management_key_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Name',
  `initial_measure_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '初始干预措施的Code',
  `initial_measure_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '初始干预措施的Name',
  `measure_upgrade_path_code` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '措施升级路径code',
  `measure_upgrade_path_name` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '措施升级路径name',
  `management_cycle` int DEFAULT NULL COMMENT '管理周期，数字表示周期长度',
  `management_cycle_unit` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理周期单位，1天、2周、3月',
  `priority` int DEFAULT '1' COMMENT '优先级，数字越大优先级越高，默认值为1',
  `benefit_statement` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '获益语，描述实施该措施后的预期收益',
  `risk_factor_code` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风险因素code',
  `risk_factor_name` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风险因素name',
  `management_goal_code` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理目标code',
  `management_goal_name` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理目标name',
  `is_regular_service` tinyint(1) DEFAULT '1' COMMENT '是否是常规服务 0否 1是',
  `execution_task` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '执行任务，描述具体的执行步骤或任务',
  `traceability` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `start_time` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `end_time` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `execution_difficulty` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行难度预测，1低、2中、3高',
  `execution_difficulty_reason` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行难度预测理由',
  `core_focus` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '核心关注',
  `measure_downgrade_path_code` varchar(320) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `measure_downgrade_path_name` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_use_okrs` tinyint(1) DEFAULT '0' COMMENT '是否使用okrs',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='干预措施库-管理要点';

-- ----------------------------
-- Table structure for t_intervention_patient_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_intervention_patient_plan`;
CREATE TABLE `t_intervention_patient_plan` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键，唯一标识',
  `original_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '源id',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单的id',
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医院编码',
  `plan_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方案名称',
  `bu_code` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用BU的Code',
  `bu_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用BU的Name',
  `dept_code` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用科室的Code',
  `dept_name` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用科室的Name',
  `service_product_id` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务产品的id',
  `service_product_name` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务产品的Name',
  `status_code` tinyint(1) DEFAULT '0' COMMENT '状态的Code: 0待发布、1已发布（启用）、2已停用',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `created_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人的ID',
  `created_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人的姓名',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modified_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人的ID',
  `modified_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人的姓名',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='患者干预方案库';

-- ----------------------------
-- Table structure for t_intervention_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_intervention_plan`;
CREATE TABLE `t_intervention_plan` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键，唯一标识',
  `hosp_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医院编码',
  `plan_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方案名称',
  `bu_code` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用BU的Code',
  `bu_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用BU的Name',
  `dept_code` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用科室的Code',
  `dept_name` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '适用科室的Name',
  `service_product_id` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务产品的id',
  `service_product_name` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务产品的Name',
  `status_code` tinyint(1) DEFAULT '0' COMMENT '状态的Code: 0待发布、1已发布（启用）、2已停用',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `created_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人的ID',
  `created_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人的姓名',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modified_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人的ID',
  `modified_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人的姓名',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='干预方案库';

-- ----------------------------
-- Table structure for t_intervention_upgrade_task
-- ----------------------------
DROP TABLE IF EXISTS `t_intervention_upgrade_task`;
CREATE TABLE `t_intervention_upgrade_task` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `plan_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联方案id',
  `option_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方案干扰id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `execute_flag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行状态 1未执行2执行过',
  `create_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `execute_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行人',
  `pay_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_jh_inhosprecord
-- ----------------------------
DROP TABLE IF EXISTS `t_jh_inhosprecord`;
CREATE TABLE `t_jh_inhosprecord` (
  `ORGAN_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '组织机构代码',
  `PAT_INDEX_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `VISIT_CARD_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `PAT_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `SEX_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别代码',
  `SEX_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `BIRTH_DATE` datetime DEFAULT NULL COMMENT '出生日期',
  `INHOSP_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `INHOSP_NUM` int DEFAULT NULL COMMENT '住院次数',
  `INHOSP_SERIAL_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '住院流水号',
  `DEPT_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `WARD_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区代码',
  `WARD_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区名称',
  `SICKROOM_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病房号',
  `BED_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病床号',
  `ADMIT_DATE` datetime DEFAULT NULL COMMENT '入院日期',
  `ADMIT_SITUATION` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '入院情况',
  `ADMIT_WAY_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '入院途径代码',
  `ADMIT_WAY_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '入院途径名称',
  `PAT_CHIEF_DESCR` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主诉',
  `BRIEF_DISEASE_SITUATION` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '简要病情',
  `TREAT_PLAN` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊疗计划',
  `PAST_DISEASE_HISTORY_DESCR` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '既往史描述',
  `DISEASE_HISTORY` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病史',
  `SURGERY_HISTORY` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术史',
  `METACHYSIS_HISTORY` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '输血史',
  `INFECT_DISEASE_HISTORY` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '传染病史',
  `ADMIT_DIAG_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '入院诊断代码',
  `ADMIT_DIAG_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '入院诊断名称',
  `RECEPT_TREAT_DR_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接诊医师工号',
  `RECEPT_TREAT_DR_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接诊医师姓名',
  `INHOSP_DR_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院医师工号',
  `INHOSP_DR_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院医师姓名',
  `ATTEND_DR_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主治医师工号',
  `ATTEND_DR_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主治医师姓名',
  `CHIEF_DR_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主任医师工号',
  `CHIEF_DR_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主任医师姓名',
  `NURSING_LEVEL_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理等级代码',
  `NURSING_LEVEL_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '护理等级名称',
  `PRIMARY_NURSE_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '责任护士工号',
  `PRIMARY_NURSE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '责任护士姓名',
  `TREAT_PROCESS_DESCR` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊疗过程描述',
  `DISCHARGE_STATUS` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院情况 2在院4出院',
  `DISCHARGE_DATE` datetime DEFAULT NULL COMMENT '出院日期时间',
  `DISCHARGE_DIAG_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院诊断代码',
  `DISCHARGE_DIAG_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院诊断名称',
  `DISCHARGE_SYMPTOM` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院时症状与体征',
  `DISCHARGE_ORDER` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院医嘱',
  `OUTCOME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '转归情况',
  `DISCHARGE_METHOD_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '离院方式代码',
  `DISCHARGE_METHOD_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '离院方式名称',
  `MOBILE_NO` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMPANY` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '工作单位',
  `ID_NUMBER` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLERGY_HISTORY` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEPT_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURR_DISEASE_HISTORY` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OUTCOME_CODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OUTCOME_NAME` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PHYSICAL_EXAM` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体格检查',
  `TREATMENT_ADVICE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '处理意见',
  `DISEASES_REPORTED_FLAG` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '疾病报卡标志',
  `PAIN_FLAG` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疼痛患者标识 1、疼痛患者 2、非疼痛患者（台州中心医院）',
  `SURGERY_FLAG` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术患者标识 1、手术患者 2、非手术患者（台州中心医院）',
  `ANALGESIC_FLAG` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '使用镇痛棒标识 1、使用镇痛棒 2、未使用镇痛棒（台州中心医院）',
  `CANCER_FLAG` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患癌标识 1、患癌 2、未患癌（台州中心医院）',
  `BLOOD_GLUCOSE_FLAG` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '血糖检测患者标识 1、血糖检测患者 2、非血糖检测患者（台州中心医院）',
  `AGE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者年龄',
  `DISCHARGE_SUMMARY` varchar(3000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERVENTIONAL_FLAG` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '介入患者 1是 其他否',
  `DAY_SURGERY_FLAG` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRE_DISCHARGE_DATE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PATH_CODE` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径编码',
  `PATH_STATUS` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径状态 0:停止  1:执行中',
  `TPN_FLAG` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '''医嘱标志，1有，其他无'',',
  `CONTACT_PHONE_NO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOSP_TYPE` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OUT_ZONE_FLAG` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHECK_FLAG` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STAFF_FLAG` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOSPITAL_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOSPITAL_ID` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORGAN_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRUSTED_ORGAN_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRUSTED_ORGAN_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FOLLOWUP_TYPE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRUSTED_ATTEND_DR_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRUSTED_ATTEND_DR_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRUSTED_TIME` date DEFAULT NULL,
  `DISCHARGE_STATUS_TIME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INHOSP_STATUS` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`INHOSP_SERIAL_NO`,`ORGAN_CODE`) USING BTREE,
  KEY `IDX_VISIT_CARD_NO` (`VISIT_CARD_NO`) USING BTREE,
  KEY `IDX_NHOSP_SERIAL_NO` (`INHOSP_SERIAL_NO`) USING BTREE,
  KEY `IDX_ORGAN_CODE` (`ORGAN_CODE`) USING BTREE,
  KEY `idx_pat_index` (`PAT_INDEX_NO`) USING BTREE,
  KEY `idx_organ_admit_date` (`ORGAN_CODE`,`ADMIT_DATE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='住院记录 2015-06-25';

-- ----------------------------
-- Table structure for t_jh_surgery_record
-- ----------------------------
DROP TABLE IF EXISTS `t_jh_surgery_record`;
CREATE TABLE `t_jh_surgery_record` (
  `organ_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '医院编码',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '患者索引号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '门诊流水号',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院号',
  `inhosp_num` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '住院流水号',
  `surgery_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '手术流水号',
  `surgery_seq_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术序号',
  `surgery_oper_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术(操作)代码',
  `surgery_oper_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术(操作)名称',
  `surgery_level_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术级别代码',
  `surgery_level_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术级别名称',
  `surgery_wound_categ_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术切口类别代码',
  `surgery_wound_categ_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术切口类别名称',
  `wound_healing_level_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术切口愈合等级代码',
  `wound_healing_level_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术切口愈合等级名称',
  `surgery_begin_date` datetime DEFAULT NULL COMMENT '手术开始日期',
  `surgery_end_date` datetime DEFAULT NULL COMMENT '手术结束日期',
  `surgery_dr_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术医生工号',
  `surgery_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术医生姓名',
  `anes_method_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '麻醉方式代码',
  `anes_method_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '麻醉方式名称',
  `anes_dr_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '麻醉医生工号',
  `anes_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '麻醉医生姓名',
  `day_surgery_flag` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '日间手术标志   0:日间',
  `surgery_diag_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '术前诊断名称',
  `surgery_find` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '术中所见',
  `surgery_hours` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手术时数（分钟）',
  `red_cells` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '红细胞',
  `plat_elet` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '血小板',
  `plasma` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '血浆',
  `whole_blood` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '全血',
  `surgery_mabl` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '术中出血量',
  `implant_flag` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '植入类型 0未植入 1已植入',
  PRIMARY KEY (`surgery_no`,`organ_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_jh_visitinfo
-- ----------------------------
DROP TABLE IF EXISTS `t_jh_visitinfo`;
CREATE TABLE `t_jh_visitinfo` (
  `ORGAN_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '组织机构代码',
  `PAT_INDEX_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `VISIT_CARD_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `PAT_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `ID_NUMBER` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `SEX_CODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别代码',
  `SEX_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `BIRTH_DATE` datetime DEFAULT NULL COMMENT '出生日期',
  `MOBILE_NO` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `COMPANY` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '工作单位',
  `OUTHOSP_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `OUTHOSP_SERIAL_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '门诊流水号',
  `PAT_TYPE_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者类型代码',
  `PAT_TYPE_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者类型名称',
  `REGIST_NO` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '挂号流水号',
  `REGIST_DATE` datetime DEFAULT NULL COMMENT '挂号日期时间',
  `VISIT_DATE` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `VISIT_START_DATE` datetime DEFAULT NULL COMMENT '就诊开始时间',
  `VISIT_END_DATE` datetime DEFAULT NULL COMMENT '就诊结束时间',
  `CHIEF_DESCR` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主诉',
  `CURR_DISEASE_HISTORY` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '现病史',
  `PAST_DISEASE_HISTORY` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '既往史',
  `RECEPT_TREAT_DR_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接诊医生工号',
  `RECEPT_TREAT_DR_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '接诊医生姓名',
  `VISIT_DEPT_CODE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊科室代码',
  `VISIT_DEPT_NAME` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊科室名称',
  `DIAG_CODE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '疾病编号',
  `DIAG_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '疾病名称',
  `ALLERGY_HISTORY` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PHYSICAL_EXAM` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体格检查',
  `TREATMENT_ADVICE` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '处理意见',
  `DISEASES_REPORTED_FLAG` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病报卡标志',
  `VISIT_SUMMARY` varchar(3000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者年龄',
  `PATH_CODE` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径编码',
  `PATH_STATUS` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径状态 0:停止  1:执行中',
  `DR_DEPT_CODE` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DR_DEPT_NAME` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VIP_FLAG` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VISIT_FLAG` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOSP_TYPE` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`OUTHOSP_SERIAL_NO`,`ORGAN_CODE`) USING BTREE,
  KEY `IDX_VISIT_CARD_NO` (`VISIT_CARD_NO`) USING BTREE,
  KEY `idx_hosp_code` (`ORGAN_CODE`) USING BTREE,
  KEY `idx_pat_index` (`PAT_INDEX_NO`) USING BTREE,
  KEY `idx_organ_visit_date` (`ORGAN_CODE`,`VISIT_DATE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='就诊信息（门、急诊） 2015-06-25';

-- ----------------------------
-- Table structure for t_okrs_task
-- ----------------------------
DROP TABLE IF EXISTS `t_okrs_task`;
CREATE TABLE `t_okrs_task` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键，唯一标识',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单的id',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'patId',
  `patient_option_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者干预管理要点id',
  `management_key_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Code',
  `management_key_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Name',
  `initial_measure_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '初始干预措施的Code',
  `initial_measure_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '初始干预措施的Name',
  `days` int DEFAULT NULL COMMENT '天数',
  `execute_day` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行天数 yyyy-MM-dd',
  `project_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目',
  `task_num` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务量',
  `task_cycle` int DEFAULT NULL COMMENT '任务频次',
  `task_cycle_unit` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务周期单位，1天、2周、3月',
  `is_finish` tinyint(1) DEFAULT '0' COMMENT '是否完成 0否 1是 2取消完成',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `cancel_finish_time` datetime DEFAULT NULL COMMENT '取消完成时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `created_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人的ID',
  `created_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人的姓名',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modified_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人的ID',
  `modified_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人的姓名',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `k_pay_id` (`pay_id`) USING BTREE,
  KEY `k_pat_id` (`pat_id`) USING BTREE,
  KEY `k_execute_day` (`execute_day`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='okrs任务';

-- ----------------------------
-- Table structure for t_okrs_task_init
-- ----------------------------
DROP TABLE IF EXISTS `t_okrs_task_init`;
CREATE TABLE `t_okrs_task_init` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键，唯一标识',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单的id',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'patId',
  `patient_option_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者干预管理要点id',
  `management_key_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Code',
  `management_key_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '管理要点的Name',
  `initial_measure_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '初始干预措施的Code',
  `initial_measure_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '初始干预措施的Name',
  `days` int DEFAULT NULL COMMENT '天数',
  `project_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目',
  `task_num` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务量',
  `task_cycle` int DEFAULT NULL COMMENT '任务频次',
  `task_cycle_unit` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务周期单位，1天、2周、3月',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `k_pay_id` (`pay_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='okrs任务';

-- ----------------------------
-- Table structure for t_order
-- ----------------------------
DROP TABLE IF EXISTS `t_order`;
CREATE TABLE `t_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_order0
-- ----------------------------
DROP TABLE IF EXISTS `t_order0`;
CREATE TABLE `t_order0` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=923619168014565378 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_order1
-- ----------------------------
DROP TABLE IF EXISTS `t_order1`;
CREATE TABLE `t_order1` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=923619168001982465 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_order_remind_config
-- ----------------------------
DROP TABLE IF EXISTS `t_order_remind_config`;
CREATE TABLE `t_order_remind_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院编码',
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院名称',
  `feishu_robot_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '机器人地址',
  `mobile_no` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '健管师手机号',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb3 COMMENT='异常待办表';

-- ----------------------------
-- Table structure for t_organ_employee
-- ----------------------------
DROP TABLE IF EXISTS `t_organ_employee`;
CREATE TABLE `t_organ_employee` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `employee_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '员工姓名',
  `organ_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构id',
  `mobile_phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '手机号码',
  `sex` tinyint NOT NULL COMMENT '性别 1-男 2-女',
  `service_status` tinyint NOT NULL COMMENT '服务状态 0：未激活  1：已激活',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `age` tinyint NOT NULL DEFAULT '0' COMMENT '年龄',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='合作企业员工信息表';

-- ----------------------------
-- Table structure for t_original_pay_patients
-- ----------------------------
DROP TABLE IF EXISTS `t_original_pay_patients`;
CREATE TABLE `t_original_pay_patients` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `order_no` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '医嘱号',
  `organCode` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_index_no` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '住院流水号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期',
  `pat_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号码',
  `charge_item_code` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '缴费金额',
  `charge_date` datetime DEFAULT NULL COMMENT '缴费时间',
  `collector_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收案人id',
  `collector_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收案人',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院)',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `order_open_dept_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱开立医生名称',
  `drug_use_frequency_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱使用频次代码',
  `drug_use_frequency_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱使用频次名称',
  `drug_unit_price` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱项目单价',
  `drug_amount` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '药品数量',
  `pat_address` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者地址',
  `diag_code` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '诊断名称',
  `is_refund` int NOT NULL DEFAULT '0' COMMENT '退费标志(0为退费 1:已退费)',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `note` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱备注',
  `false_data` int DEFAULT '0' COMMENT '0：真实数据，1：种子计划数据',
  `report_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '体检报告号',
  `exam_date` datetime DEFAULT NULL COMMENT '体检日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `report_status` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报告状态(0:未出 1:已出)',
  `empi_id` varchar(35) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者主索引号',
  `ward_name` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '病区',
  `bed_no` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '床号',
  `is_upload` tinyint(1) DEFAULT '0' COMMENT '是否同步 0.未同步 1.已同步',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_no` (`order_no`) USING BTREE,
  KEY `outhosp_serial_no` (`outhosp_serial_no`) USING BTREE,
  KEY `inhosp_serial_no` (`inhosp_serial_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='老模式开单表';

-- ----------------------------
-- Table structure for t_outhosp_pdm_fee
-- ----------------------------
DROP TABLE IF EXISTS `t_outhosp_pdm_fee`;
CREATE TABLE `t_outhosp_pdm_fee` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `organ_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '门诊流水号',
  `deal_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '交易流水号',
  `charge_item_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '收费项目名称',
  `item_unit_price` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '项目单价',
  `item_amount` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '项目开立数量',
  `deal_open_dept_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '费用开立科室代码',
  `deal_open_dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '费用开立科室名称',
  `deal_open_dr_code` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '费用开立医生工号',
  `deal_open_dr_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '费用开立医生名称',
  `deal_status` tinyint(1) DEFAULT NULL COMMENT '费用状态 1.未结算 2.已结算 3.已退费',
  `calculate_time` datetime DEFAULT NULL COMMENT '计费时间',
  `charge_time` datetime DEFAULT NULL COMMENT '结算时间',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医嘱号（住院）',
  `is_upload` tinyint(1) DEFAULT '0' COMMENT '是否同步 0.未同步 1.已同步',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `deal_no` (`deal_no`) USING BTREE,
  KEY `hosp_outhosp` (`organ_code`,`outhosp_serial_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='门诊收费表';

-- ----------------------------
-- Table structure for t_patient_heart_archives
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_heart_archives`;
CREATE TABLE `t_patient_heart_archives` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `visit_date` datetime DEFAULT NULL COMMENT '首次就诊时间',
  `join_time` datetime DEFAULT NULL COMMENT '入组时间',
  `is_atrial` int DEFAULT NULL COMMENT '是否房颤患者  0-否 1-是',
  `non_patient_type` int DEFAULT NULL COMMENT '0-默认  1-对房颤感兴趣的其他患者 2-误扫  3-医院工作人员  9-其他',
  `is_cardiology` int DEFAULT NULL COMMENT '入组时是否去过心内科门诊  0-否 1-是',
  `non_atrial_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '不去房颤门诊原因',
  `group_ep_vist` int DEFAULT NULL COMMENT '入组时是否去过房颤门诊 0-否 1-是',
  `group_operation` int DEFAULT NULL COMMENT '入组时是否已手术 0-否 1-是',
  `new_np` int DEFAULT NULL COMMENT '是否NP 0-否 1-是',
  `from_type` int DEFAULT NULL COMMENT '来源类型 1-自主注册  2-术后患者导入 3-术前患者导入  4-医院录入',
  `department` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '送检科室/医生',
  `prescribed_treatment` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医嘱治疗方式',
  `willingnes_state` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '消融安排',
  `patient_wish` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '规范化治疗意愿度',
  `operate_date` datetime DEFAULT NULL COMMENT '完成手术时间',
  `willingness_scheduling` datetime DEFAULT NULL COMMENT '预约手术时间',
  `recurrence_atrial_fibrillation` int DEFAULT NULL COMMENT '是否复发 0-否 1-是',
  `recurrence_time` datetime DEFAULT NULL COMMENT '复发时间',
  `treatment_stage` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '诊疗阶段',
  `diagnosis_date` datetime DEFAULT NULL COMMENT '确诊时间',
  `atrial_fibrillation_type` int DEFAULT NULL COMMENT '房颤类型 1-持续性 2-阵发性 3-永久性 4-长程持续性',
  `symptoms_now` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '症状\n',
  `co_morbidity` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '合并疾病\n',
  `take_drug_state` int DEFAULT NULL COMMENT '是否使用药物 0-否 1-是',
  `use_drug_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用药类型\n',
  `use_drug_duration` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用药时长',
  `heart_rate` int DEFAULT NULL COMMENT '房颤时心率\n',
  `left_atrial_diameter` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '左房内径\n',
  `follow_up_state` int DEFAULT NULL COMMENT '随访状态 0-关爱中  1-停止关爱',
  `last_follow_up_time` datetime DEFAULT NULL COMMENT '最后一次随访时间',
  `fv_remark` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注\n',
  `patient_wish_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '意愿度原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_patient_mobile_log
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_mobile_log`;
CREATE TABLE `t_patient_mobile_log` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '患者主索引号',
  `operate_type` int DEFAULT NULL COMMENT '操作类型 1新增 2删除 3编辑',
  `content` text COMMENT '操作内容',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `editor_name` varchar(25) DEFAULT NULL COMMENT '编辑者',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='患者电话号码日志表';

-- ----------------------------
-- Table structure for t_patient_weight
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_weight`;
CREATE TABLE `t_patient_weight` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `task_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣讲任务id',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单id',
  `meal_flag` tinyint(1) DEFAULT NULL COMMENT '是否代餐 0否 1是',
  `meal_type` tinyint(1) DEFAULT NULL COMMENT '代餐类型 0:逆糖项目代餐产品、1:甬健壹号营养棒、2:零纬度营养棒、3:其他',
  `meal_other_remark` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '其他代餐备注',
  `service_days` tinyint(1) DEFAULT NULL COMMENT '服务天数 无赠送，正常管理0 有赠送天数1',
  `deferment_days` tinyint DEFAULT NULL COMMENT '赠送天数',
  `repeat_type` tinyint(1) DEFAULT NULL COMMENT '收案管理时效要求 “正常，在3-5日内开始管理0 有特殊要求1',
  `repeat_remark` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '特殊服务要求备注',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `goods_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品goodsId',
  `goods_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品名称',
  `group_id` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '团队id',
  `sport_manage_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '运动师',
  `nourishment_manage_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '营养师',
  `nourishment_manage_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '营养师',
  `sport_manage_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '运动师',
  `is_preparation_deal` tinyint DEFAULT '0' COMMENT '是否预收案 1:是 0:否',
  `follow_frequency_re` tinyint(1) DEFAULT NULL COMMENT '复诊频率要求 0:无 1:有',
  `follow_period` tinyint DEFAULT NULL COMMENT '复诊周期',
  `follow_frequency_type` tinyint DEFAULT NULL COMMENT '复诊频率类型 0:每周 1:每月',
  `follow_frequency_num` tinyint DEFAULT NULL COMMENT '复诊频次',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='高净值收案登记';

-- ----------------------------
-- Table structure for t_pay_account
-- ----------------------------
DROP TABLE IF EXISTS `t_pay_account`;
CREATE TABLE `t_pay_account` (
  `id` varchar(32) NOT NULL COMMENT 'id',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '机构代码',
  `account_no` varchar(150) NOT NULL COMMENT '对账编号',
  `account_type` tinyint(1) NOT NULL COMMENT '对账口径 0:计费 1:缴费',
  `account_start_date` datetime DEFAULT NULL COMMENT '对账开始时间',
  `account_end_date` datetime DEFAULT NULL COMMENT '对账结束时间',
  `user_id` varchar(32) DEFAULT NULL COMMENT '对账人id',
  `user_name` varchar(50) DEFAULT NULL COMMENT '对账人名称',
  `result` text COMMENT '对账结果',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对账任务表';

-- ----------------------------
-- Table structure for t_pay_account_exception
-- ----------------------------
DROP TABLE IF EXISTS `t_pay_account_exception`;
CREATE TABLE `t_pay_account_exception` (
  `id` varchar(32) NOT NULL COMMENT 'id',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '机构代码',
  `account_id` varchar(32) NOT NULL COMMENT '对账id',
  `hosp_no` varchar(50) DEFAULT NULL COMMENT '病例号,住院号,门诊号',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '患者姓名',
  `charge_item_code` varchar(50) DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) DEFAULT NULL COMMENT '收费项目名称',
  `date_str` varchar(50) DEFAULT NULL COMMENT '日期',
  `current_date` datetime DEFAULT NULL COMMENT '日期',
  `order_open_dept_name` varchar(50) DEFAULT NULL COMMENT '科室',
  `price` varchar(50) DEFAULT NULL COMMENT '单价',
  `order_amount` varchar(50) DEFAULT NULL COMMENT '数量',
  `total_money` varchar(50) DEFAULT NULL COMMENT '金额',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对账异常数据表';

-- ----------------------------
-- Table structure for t_pay_order_log
-- ----------------------------
DROP TABLE IF EXISTS `t_pay_order_log`;
CREATE TABLE `t_pay_order_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `pay_order_id` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '订单主键',
  `operate_type` tinyint(1) DEFAULT NULL COMMENT '操作类型 1：创建订单 2：更新订单 3：关联诊疗记录 4：手动退费',
  `pay_status_old` int DEFAULT NULL COMMENT '旧支付单子：0：未支付  1：已支付  -2：已退费 -3：已关闭；退费单子：-1：退费中 -2：退费成功',
  `pay_status_new` int DEFAULT NULL COMMENT '新支付单子：0：未支付  1：已支付  -2：已退费 -3：已关闭；退费单子：-1：退费中 -2：退费成功',
  `operate_detail` varchar(400) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作详情',
  `operator_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人id',
  `operator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人name',
  `operator_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `remark` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='订单日志';

-- ----------------------------
-- Table structure for t_preach_bill_config
-- ----------------------------
DROP TABLE IF EXISTS `t_preach_bill_config`;
CREATE TABLE `t_preach_bill_config` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `bill_name` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `bill_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `bill_price` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `service_period` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `service_period_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `hosp_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_preach_dept
-- ----------------------------
DROP TABLE IF EXISTS `t_preach_dept`;
CREATE TABLE `t_preach_dept` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `preach_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣讲人id',
  `preach_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣讲人名称',
  `dept_state` tinyint(1) DEFAULT '0' COMMENT '开启责任科室 0: 否 1:是',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='责任科室配置表';

-- ----------------------------
-- Table structure for t_psy_consult_task_record
-- ----------------------------
DROP TABLE IF EXISTS `t_psy_consult_task_record`;
CREATE TABLE `t_psy_consult_task_record` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `task_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `channel_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `app_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `app_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `download_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `template_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `layout_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `record_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `talk_length` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for t_pull_config
-- ----------------------------
DROP TABLE IF EXISTS `t_pull_config`;
CREATE TABLE `t_pull_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `organ_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `organ_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构名称',
  `current_flag` tinyint(1) NOT NULL DEFAULT '1' COMMENT '同步模式 0:老模式(不区分住院门诊type默认即可) 1:新模式',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '适配方式, 0: 医嘱-住院, 1: 医嘱-门诊',
  `advance_minute` tinyint(1) NOT NULL DEFAULT '1' COMMENT '提前 分钟(每次)',
  `advance_hour` tinyint(1) NOT NULL DEFAULT '24' COMMENT '提前 小时(每天)',
  `advance_mid_hour` tinyint(1) NOT NULL DEFAULT '6' COMMENT '提前 小时(每天中午)',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_organ_code` (`organ_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='拉取配置表';

-- ----------------------------
-- Table structure for t_recommend_pat_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_recommend_pat_rule`;
CREATE TABLE `t_recommend_pat_rule` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `hosp_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院编码',
  `hosp_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '医院名称',
  `dept_codes` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室编码可多选',
  `dept_names` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '科室名称可多选',
  `rule_relation` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'or and',
  `rule_title` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '规则名称',
  `rule_json` varchar(2255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '规则详情',
  `open_state` int DEFAULT NULL COMMENT '1开0关',
  `is_delete` int DEFAULT NULL COMMENT '1删0未删',
  `edit_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `edit_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `rule_type` int DEFAULT '0' COMMENT '0普通1公共',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `rule_desc` varchar(1200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '描述',
  `have_handle_num` int DEFAULT NULL COMMENT '已处理人数',
  `add_num` int DEFAULT NULL COMMENT '新增人数',
  `is_top` int DEFAULT NULL COMMENT '置顶',
  `total_num` int DEFAULT NULL COMMENT '置顶',
  `top_user` varchar(1200) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '置顶',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='推荐患者规则表';

-- ----------------------------
-- Table structure for t_recommend_sys_day
-- ----------------------------
DROP TABLE IF EXISTS `t_recommend_sys_day`;
CREATE TABLE `t_recommend_sys_day` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '主键',
  `recommend_rule_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '规则id',
  `sys_day` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '同步日期',
  `sys_num` int DEFAULT NULL COMMENT '同步数量',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_repository_ai_scene_conf
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_ai_scene_conf`;
CREATE TABLE `t_repository_ai_scene_conf` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `module_code` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '模块代码(1,患者管理)',
  `module_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '模块名称',
  `content_code` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '执行内容代码(1,宣教未读提醒 2,配药提醒)',
  `content_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '执行内容名称',
  `content_type` int DEFAULT NULL COMMENT '执行内容类型(1,表单 2,宣教 3,提醒)',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '配置人ID',
  `user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '配置人姓名',
  `after_days_push` int DEFAULT '1' COMMENT '发送天数患者未回复则开始推AI',
  `push_keep_days` int DEFAULT '1' COMMENT '推送AI持续天数(从开始推AI那天算)',
  `manual_push_limit_count` int DEFAULT '1' COMMENT '手动推AI次数上限',
  `auto_push_limit_count` int DEFAULT '1' COMMENT '自动推AI次数上限',
  `dosage_remind_type` int DEFAULT NULL COMMENT '配药提醒提醒方式(1、APP/AI, 2、仅APP)',
  `content_desc` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '执行内容描述说明',
  `update_time` datetime DEFAULT NULL COMMENT '配置时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='AI配置表';

-- ----------------------------
-- Table structure for t_repository_category
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_category`;
CREATE TABLE `t_repository_category` (
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '分类ID',
  `category_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分类名称',
  `category_type` int DEFAULT NULL COMMENT '分类类型(1:表单 2:宣教 3:提醒 4:模板)',
  `category_property` int DEFAULT '0' COMMENT '分类属性(0:私有性 1:公有性[不可编辑且所有人都可使用])',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='知识库分类表';

-- ----------------------------
-- Table structure for t_repository_education
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_education`;
CREATE TABLE `t_repository_education` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `creator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人ID',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人姓名',
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教分类ID',
  `cover_img_src` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教封面图片路径',
  `title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教标题',
  `content` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '宣教内容/内容外网URL',
  `ppt_src` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教PPT路径',
  `share_status` int DEFAULT '0' COMMENT '共享状态(0:不共享 1:本科室共享 2:全院(需引用后可使用) 3全院(全院用户可使用) 4 指定科室共享',
  `invalid_flag` int DEFAULT '1' COMMENT '作废标识(0:作废 1:有效)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `share_dept` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分享科室(多选 '',''分隔)',
  `share_dept_code` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分享科室代码(多选 '',''分隔)',
  `share_dept_name` varchar(5000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分享科室名(多选 '',''分隔)',
  `app_version` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教编辑版本号(For App)',
  `review_status` int DEFAULT '1' COMMENT '审核状态(0:审核中 1:通过  -1:未通过)',
  `review_content` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '审核缓存内容',
  `refuse_reason` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '审核未通过原因',
  `review_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '审核人ID',
  `review_user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '审核人姓名',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `hosp_course_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院课程ID',
  `data_type` int DEFAULT NULL COMMENT '数据类型(1自建 2随访后台 3知识库大脑)',
  `pack_education_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教在场景中的id',
  `pack_education_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教在场景中的名称',
  `self_flag` int DEFAULT '1' COMMENT '自建标识 1自建 2收费',
  `diag_codes` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病编码(逗号分隔,上限10个)',
  `diag_names` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病名称',
  `label_codes` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标签编码(逗号分隔,上限10个)',
  `label_names` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标签名称',
  `education_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教描述',
  `qr_code_flag` tinyint DEFAULT '0' COMMENT '是否有二维码图片，0，否  1，是',
  `process_flag` tinyint(1) DEFAULT '2' COMMENT '问卷类型 1:问卷 2:宣教',
  `top_category_id` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '最上层分类（1，住院  2，门诊  3，全院  4，未分配）',
  `diag_category_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病分类',
  `is_quote` tinyint DEFAULT '0' COMMENT '是否为引用的宣教,0:否 1:是',
  `quote_edu_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '引用公共宣教id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='健康宣教库表';

-- ----------------------------
-- Table structure for t_repository_education_third_party
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_education_third_party`;
CREATE TABLE `t_repository_education_third_party` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院编码',
  `title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教标题',
  `content` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '宣教内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_repository_form_answer
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form_answer`;
CREATE TABLE `t_repository_form_answer` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联表单(老流程为表t_repository_form的主键，知识库大脑新流程为form_id字段)',
  `relation_type` int DEFAULT NULL COMMENT '关联任务类型(1:随访任务 2:随访记录 3:满意度任务 4:VIP任务 5:满意度记录 6:APP在院满意度调查 7:随访抽查 8:专科随访 9:专科建档 99:妇幼那边提交的答案)',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任务ID',
  `question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联题目ID',
  `question_answer` varchar(10000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '题目答案(选项ID或者文本内容)',
  `other_content` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '其他项文本内容',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `quote_question_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '引用题目ID(题库单题表主键ID)',
  `quote_question_answer` varchar(10000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '引用题目答案',
  `answer_code` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '答案编码 字典表匹配',
  `answer_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '答案名称 字典表匹配',
  `cloud_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '知识库大脑新流程关联表单主键ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_relation_id_question_id` (`relation_id`,`question_id`) USING BTREE,
  KEY `idx_relation_id_form_id` (`relation_id`,`form_id`) USING BTREE,
  KEY `idx_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='随访表单答案表';

-- ----------------------------
-- Table structure for t_repository_form_answer_summary
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form_answer_summary`;
CREATE TABLE `t_repository_form_answer_summary` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单主键ID(新流程后实际为云端表单formId)',
  `relation_type` int DEFAULT NULL COMMENT '关联任务类别(以表单记录表为准)',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任务ID',
  `judg_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '对应的表单总结设置ID',
  `except` int DEFAULT NULL COMMENT '是否异常(0,否;1,是)',
  `score` double(7,3) DEFAULT '0.000' COMMENT '表单填写得分',
  `cloud_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '云端主键ID',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_relation_id_form_id` (`relation_id`,`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单回复总结表';

-- ----------------------------
-- Table structure for t_repository_form_judg
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form_judg`;
CREATE TABLE `t_repository_form_judg` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联表单ID(表t_repository_form的主键)',
  `lower_limit` double(11,3) DEFAULT NULL COMMENT '分段下限',
  `upper_limit` double(11,3) DEFAULT NULL COMMENT '分段上限',
  `judg_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分段名称',
  `judg_desc` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分段说明',
  `except` int DEFAULT NULL COMMENT '是否异常(0,否;1,是)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='评分标准(如果有分值题则有该评分标准)';

-- ----------------------------
-- Table structure for t_repository_form_score
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form_score`;
CREATE TABLE `t_repository_form_score` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `form_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联表单ID(表t_repository_form的主键)',
  `relation_type` int DEFAULT NULL COMMENT '关联任务类别(1:随访任务 2:随访记录)',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联任务ID',
  `score` double(7,3) DEFAULT '0.000' COMMENT '评分结果',
  `judg_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '评分标准分段ID',
  `except` int DEFAULT NULL COMMENT '是否异常(0:否 1:是)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_relation_id_form_id` (`relation_id`,`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_repository_plan_template
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_plan_template`;
CREATE TABLE `t_repository_plan_template` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `plan_type` tinyint NOT NULL COMMENT '计划类型（FastPlanTypeEnum）',
  `pat_source_type` tinyint DEFAULT NULL COMMENT '患者来源',
  `plan_json` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '计划默认值JSON串',
  `editor_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '编辑人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_responsibility_dept
-- ----------------------------
DROP TABLE IF EXISTS `t_responsibility_dept`;
CREATE TABLE `t_responsibility_dept` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `preach_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣讲人id',
  `preach_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣讲人名称',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `hospital_area_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '院区编码',
  `type` tinyint(1) DEFAULT NULL COMMENT '科室类型 1:门诊科室 2:住院科室 3:住院病区',
  `real_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室实际名称',
  `sort` int DEFAULT NULL COMMENT '科室排序',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `code` (`dept_code`,`hosp_code`,`preach_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='责任科室表';

-- ----------------------------
-- Table structure for t_service_organization
-- ----------------------------
DROP TABLE IF EXISTS `t_service_organization`;
CREATE TABLE `t_service_organization` (
  `organ_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `organ_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者id',
  `service_start_time` datetime NOT NULL COMMENT '服务开始时间',
  `service_end_time` datetime NOT NULL COMMENT '服务结束时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`organ_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='合作企业机构表';

-- ----------------------------
-- Table structure for t_simulate_config
-- ----------------------------
DROP TABLE IF EXISTS `t_simulate_config`;
CREATE TABLE `t_simulate_config` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键id',
  `month_total_max_limit` int DEFAULT NULL COMMENT '月度阀值',
  `month_department_con_rate` double(4,2) DEFAULT NULL COMMENT '月度科室转化率',
  `hosp_code` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院编码',
  `hosp_name` varchar(655) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院名称',
  `status_flag` int DEFAULT NULL COMMENT '0未启动1启动',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '是否删除',
  `last_execute_result` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '最近一次执行结果',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_simulate_execute_log
-- ----------------------------
DROP TABLE IF EXISTS `t_simulate_execute_log`;
CREATE TABLE `t_simulate_execute_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `execute_day` datetime DEFAULT NULL COMMENT '执行日期',
  `success_flag` int DEFAULT NULL COMMENT '1成功0失败',
  `remark` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '备注',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3 COMMENT='记录定时器每天执行的情况';

-- ----------------------------
-- Table structure for t_simulate_patients
-- ----------------------------
DROP TABLE IF EXISTS `t_simulate_patients`;
CREATE TABLE `t_simulate_patients` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `batch_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '判断数据是否属于同一批次',
  `batch_dept_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '批次科室编码',
  `batch_dept_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '批次科室名称',
  `batch_dept_type` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '批次科室类型',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `sample_close_time` datetime DEFAULT NULL COMMENT '样本数据结案时间',
  `simulate_close_time` datetime DEFAULT NULL COMMENT '模拟数据结案时间',
  `simulate_pay_patient_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '模拟数据的payId',
  `sample_pay_patient_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '样本数据的payId',
  `base_time` datetime DEFAULT NULL COMMENT '模拟数据的基线日期',
  `sample_base_time` datetime DEFAULT NULL COMMENT '样本数据的基线日期',
  `sample_pat_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '样本姓名',
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院名称',
  `hosp_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期',
  `id_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `order_open_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室编码',
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱开立医生名称',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `drug_use_frequency_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次代码',
  `drug_use_frequency_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱使用频次名称',
  `note` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱备注',
  `drug_unit_price` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目单价',
  `drug_amount` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱项目开立数量',
  `source_type` int DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院) 4：体检 5：明日出院 6;今日出院',
  `pat_address` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者地址',
  `diag_code` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引号',
  `order_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医嘱号',
  `report_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '体检报告号',
  `exam_date` datetime DEFAULT NULL COMMENT '体检日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `recheck_handle_status` int DEFAULT NULL COMMENT '复查处理状态(0:未处理 1:已处理)',
  `report_status` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '报告状态(0:未出 1:已出)',
  `remark` varchar(800) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注信息',
  `ward_name` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区',
  `bed_no` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '床号',
  `editor_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人name',
  `status_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '1、全部 2、服务中 3、方案待制定 4、待宣讲 5、正常结案 6、中途退出 7 中途退费 8：未服务退费 9取消开单',
  `exception_desc` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常说明',
  `pat_number` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者编码',
  `discharge_dept_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院科室编码',
  `discharge_dept_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出院科室名称',
  `operation_time` datetime DEFAULT NULL COMMENT '手术时间',
  `operation_time_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术时间名称',
  `age` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '年龄',
  `is_delete` int DEFAULT '0',
  `is_end` int DEFAULT '0' COMMENT '1结案',
  `mission_end_time` datetime DEFAULT NULL COMMENT '随访任务结束时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `empi_id` (`empi_id`) USING BTREE,
  KEY `status_flag` (`status_flag`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `order_no` (`order_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='付费患者表';

-- ----------------------------
-- Table structure for t_simulate_table_data
-- ----------------------------
DROP TABLE IF EXISTS `t_simulate_table_data`;
CREATE TABLE `t_simulate_table_data` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `simulate_table_type` int DEFAULT NULL COMMENT '数据类型',
  `simulate_table_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数据表名称',
  `simulate_pat_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '模拟患者名称',
  `simulate_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '模拟数据主键id',
  `simulate_base_time` datetime DEFAULT NULL COMMENT '模拟数据基线日期',
  `simulate_data_time` datetime DEFAULT NULL COMMENT '生成的模拟数据日期',
  `batch_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `data_key_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数据的主键id',
  `data_key_id_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数据的主键名称',
  `emp_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主键id',
  `hosp_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hosp_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `is_delete` int DEFAULT '0' COMMENT '对应表数据是否删除',
  `create_time` datetime DEFAULT NULL,
  `sample_base_time` datetime DEFAULT NULL COMMENT '样本数据基线日期',
  `sample_data_time` datetime DEFAULT NULL COMMENT '本条样本数据日期',
  `sample_base_between` int DEFAULT NULL COMMENT '样本数据时间与样本基线时间差',
  `sample_table_data_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '模拟数据对应表的数据id',
  `simulate_pay_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数据所属的开单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='记录生成记录的数据';

-- ----------------------------
-- Table structure for t_sl_followup_advanced_patients
-- ----------------------------
DROP TABLE IF EXISTS `t_sl_followup_advanced_patients`;
CREATE TABLE `t_sl_followup_advanced_patients` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `role_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联规则id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引',
  `pat_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `sex_code` tinyint DEFAULT NULL COMMENT '性别代码',
  `age` int DEFAULT NULL COMMENT '年龄',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `first_business_time` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '首次管理时间',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `id_card` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码(门诊/出院/在院/转科)',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称(门诊/出院/在院/转科)',
  `ward_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区代码(出院/在院/转科)',
  `ward_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区名称(出院/在院/转科)',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专科随访高级筛选患者表';

-- ----------------------------
-- Table structure for t_sl_followup_job
-- ----------------------------
DROP TABLE IF EXISTS `t_sl_followup_job`;
CREATE TABLE `t_sl_followup_job` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划ID(专科随访计划表主键)',
  `send_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送时间段(多选'',''分隔 例如9,15,21; 0:表示立即发送)',
  `send_over_task` int DEFAULT '0' COMMENT '过期任务自动发送(0:否 1:是)',
  `auto_complete_task` int DEFAULT '0' COMMENT '无异常任务自动关闭(0:否 1:是)',
  `enable_status` int DEFAULT '0' COMMENT '启用状态(0:停用 1:启用)',
  `creator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人ID',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `except_remind` int DEFAULT '0' COMMENT '异常短信提醒(0否, 1是)',
  `remind_mobile` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常提醒号码,多个号码用逗号隔开',
  `auto_send_times_limit` tinyint DEFAULT NULL COMMENT '自动发送次数上限',
  `send_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '1' COMMENT '发送方式(1,ai语音/app/微信  2,短信)，多选逗号分隔拼接',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_plan_id` (`plan_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专科随访自动随访配置表';

-- ----------------------------
-- Table structure for t_sl_followup_mission
-- ----------------------------
DROP TABLE IF EXISTS `t_sl_followup_mission`;
CREATE TABLE `t_sl_followup_mission` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划ID(计划表主键)',
  `plan_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划名称',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `plan_task_id` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '规则任务ID，如果是阶段性任务,则在planTaskId后面追加--数字',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联ID',
  `relation_type` int DEFAULT NULL COMMENT '关联类型(1专科随访  2患者管理  3慢病随访  4慢病管理  5随访抽查)',
  `relation_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联名称',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒时间',
  `revisit_plan_end_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒截止时间',
  `advance_send_time` int DEFAULT NULL COMMENT '提醒提前发送时间',
  `content_id` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒ID(","分隔，上限10个)',
  `content_title` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联随访/宣教/提醒标题(","分隔，上限10个)',
  `mission_prop` int DEFAULT NULL COMMENT '任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `mission_time_type` int DEFAULT NULL COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `mission_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务时间类型名称',
  `mission_type` int DEFAULT NULL COMMENT '任务类型(宣教: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒)',
  `mission_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务类型名称',
  `begin_time_type` int DEFAULT NULL COMMENT '任务开始时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后, 固定下拉字典表配置)',
  `begin_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务开始时间类型名称',
  `business_type` int DEFAULT NULL COMMENT '业务日期类型(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务日期类型名(1预产期,2末次月经,3手术,4检验,5检查,6胚胎移植,7分娩,建档)',
  `business_date` date DEFAULT NULL COMMENT '基线日期',
  `valid_days` int DEFAULT NULL COMMENT '有效天数(天)',
  `remind_content` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒内容',
  `lock_status` int DEFAULT '0' COMMENT '锁定状态(0:未被锁定 1:已被锁定)',
  `lock_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '锁定人ID',
  `lock_person_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '锁定人姓名',
  `lock_time` datetime DEFAULT NULL COMMENT '锁定时间',
  `plan_return_visit` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划回访方式',
  `form_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单说明',
  `followup_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员人ID',
  `followup_person_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人员姓名',
  `followup_person_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室代码',
  `followup_person_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/宣教/提醒人科室名称',
  `return_visit_time` datetime DEFAULT NULL COMMENT '实际回访时间',
  `return_visit_type` int DEFAULT NULL COMMENT '实际回访方式(1:电话 2:APP/微信/短信)',
  `return_visit_type_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '实际回访方式名称',
  `revisit_status` int DEFAULT NULL COMMENT '随访状态(1:正常状态；2:无人接听；3:无法接通；4:关机；5:停机；6:死亡；7:家属接听(不了解情况)；8:拒绝；9:空号/电话错误；10:其他)',
  `revisit_result` int DEFAULT '0' COMMENT '随访结果(0:未完成 1:已完成 2:已结案)',
  `revisit_excp` int DEFAULT NULL COMMENT '随访结果异常标识(0:正常 1:异常)',
  `handling_opinion` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '处理意见',
  `app_send_status` int DEFAULT '0' COMMENT 'APP发送状态(0:未发送 -1未回复: 1:已回复)',
  `app_send_time` datetime DEFAULT NULL COMMENT 'APP发送时间',
  `app_reply_excp` int DEFAULT NULL COMMENT 'APP回复是否异常(0:否 1:是)',
  `plan_year` int DEFAULT NULL COMMENT '计划所属年份',
  `plan_month` int DEFAULT NULL COMMENT '计划所属月份',
  `followup_result` int DEFAULT NULL COMMENT '随访结果(统计)  1:电话完成 2:移动端完成 3:其他方式 （优先级：电话>移动端>其他）',
  `talk_time` int DEFAULT '0' COMMENT '通话时长(统计) 分钟',
  `followup_mode_phone` int DEFAULT '0' COMMENT '随访方式(统计) - 电话拨出次数',
  `followup_mode_app` int DEFAULT '0' COMMENT '随访方式(统计) - 发送到APP次数',
  `followup_mode_wechat` int DEFAULT '0' COMMENT '随访方式(统计) - 发送到微信次数',
  `followup_mode_sms` int DEFAULT '0' COMMENT '随访方式(统计) - 发送到短信次数',
  `send_app_times` int DEFAULT '0' COMMENT '手动补发次数(记录手动发送的次数)',
  `remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `close_desc` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '结案说明',
  `creator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人ID',
  `creator_dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人所在科室/病区代码',
  `creator_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人所在科室/病区名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `ai_push_status` int DEFAULT '0' COMMENT 'AI推送状态(0:未推送 -1:未回复 1:已回复)',
  `ai_push_result_code` int DEFAULT NULL COMMENT 'AI推送结果状态值 0 正常, 其他 异常(具体AI系统定)',
  `ai_push_result_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI推送结果状态说明',
  `ai_push_time` datetime DEFAULT NULL COMMENT 'AI推送时间',
  `ai_push_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'AI推送人员ID',
  `auto_push_ai_times` int DEFAULT '0' COMMENT '自动AI推送次数',
  `manual_push_ai_times` int DEFAULT '0' COMMENT '手动AI推送次数',
  `ai_reply_time` datetime DEFAULT NULL COMMENT 'AI回复时间',
  `download_flag` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '下城区慢病随访自填下发标记 1 自填 其他下发',
  `excep_report` int DEFAULT '0' COMMENT '异常上报 0不上报 1上报',
  `push_to_cloud_flag` int DEFAULT '0' COMMENT '是否已将信息批量推给云端处理（0，否  1，是）',
  `ai_status` int DEFAULT '0' COMMENT '是否是ai任务(0否 1是)',
  `is_graded` int DEFAULT '0' COMMENT '是否由分级产生(0否，1是)',
  `graded_code` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分级编码',
  `graded_index` int DEFAULT NULL COMMENT '在一次分级中的序号',
  `followup_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '随访编号',
  `is_handled` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '是否已干预 1是 0否',
  `starting_point_flag` int DEFAULT '0' COMMENT '设置随访计划任务起点 1是起点 0不是起点',
  `enable_flag` int DEFAULT '1' COMMENT '有效标志位 0无效 1有效',
  `is_referral` tinyint DEFAULT '0' COMMENT '是否复诊（0，否  1，是）',
  `referral_dept_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊科室代码（逗号分隔拼接串）',
  `referral_plan_start_date` date DEFAULT NULL COMMENT '计划复诊有效开始时间',
  `referral_plan_date` date DEFAULT NULL COMMENT '计划复诊日期',
  `referral_plan_end_date` date DEFAULT NULL COMMENT '计划复诊有效截止时间',
  `group_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务组块ID',
  `referral_remind_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊提醒内容',
  `referral_remind_status` tinyint DEFAULT NULL COMMENT '复诊提醒结果',
  `revisit_send_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒发送时间',
  `task_source_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务来源',
  `surgery_code` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术代码(多选,分隔 上限10个)',
  `plan_time_delay_days` int DEFAULT '0' COMMENT '复诊任务计划时间因复诊确认时间变化产生的偏移天数',
  `referral_confirm_date` date DEFAULT NULL COMMENT '确认复诊日期',
  `referral_confirm_way` tinyint DEFAULT NULL COMMENT '复诊确认途径（1，系统确认  2，人工确认）',
  `auto_send_times` tinyint DEFAULT NULL COMMENT '自动发送次数',
  `ai_label_codes` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ai鏍囩缂栫爜锛堥€楀彿闅斿紑锛?',
  `ai_label_names` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ai鏍囩鍚嶇О锛堥€楀彿闅斿紑锛?',
  `is_branch_mission` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为分支任务（0，否  1，是）',
  `ai_call_times` int DEFAULT '0' COMMENT '自动拨打次数',
  `branch_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属分支id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_serial_no_plan_id_plan_task_id_pat_source_type` (`serial_no`,`plan_id`,`plan_task_id`,`pat_source_type`) USING BTREE,
  KEY `idx_plan_id` (`plan_id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_followup_id` (`followup_id`) USING BTREE,
  KEY `idx_revisit_plan_time` (`revisit_plan_time`) USING BTREE,
  KEY `idx_revisit_plan_end_time` (`revisit_plan_end_time`) USING BTREE,
  KEY `idx_return_visit_time` (`return_visit_time`) USING BTREE,
  KEY `idx_relation_id_revisit_plan_time` (`relation_id`,`revisit_plan_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='新版专科随访任务表';

-- ----------------------------
-- Table structure for t_sl_followup_mission_skip
-- ----------------------------
DROP TABLE IF EXISTS `t_sl_followup_mission_skip`;
CREATE TABLE `t_sl_followup_mission_skip` (
  `mission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '任务id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `plan_time` datetime DEFAULT NULL COMMENT '原计划时间',
  `new_plan_time` datetime DEFAULT NULL COMMENT '跳过后计划时间',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`mission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='随访任务计划时间跳过周末表';

-- ----------------------------
-- Table structure for t_sl_followup_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_sl_followup_patient`;
CREATE TABLE `t_sl_followup_patient` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划ID',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `pat_source_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病人来源名称',
  `serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `in_hosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `out_hosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `sex_code` int DEFAULT NULL COMMENT '性别代码(1:男 2:女 9:其他)',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `birthdate` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出生日期',
  `age` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '年龄',
  `id_card` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `his_mobile` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'HIS手机号',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码(门诊/出院/在院/转科)',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称(门诊/出院/在院/转科)',
  `ward_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区代码(出院/在院/转科)',
  `ward_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区名称(出院/在院/转科)',
  `bed_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病床号(出院/在院/转科)',
  `dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主治/签约医生工号',
  `dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主治/签约医生姓名',
  `diag_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病诊断代码',
  `diag_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病诊断名称',
  `out_come` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '转归情况',
  `business_time` datetime DEFAULT NULL COMMENT '业务发生时间 入院/出院/就诊/体检/签约/入科/出科/建档/签约/收藏患者时间（或加入分组时间）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `branch_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '使用分支id',
  `branch_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '使用分支名称',
  `column_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '列存储值代码(目前只有高危因素，后续加了之后再加个类型跟类型名称区分)',
  `column_value` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '列存储值名称',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_plan_id_empi_id` (`plan_id`,`empi_id`) USING BTREE,
  KEY `idx_serial_no` (`serial_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='随访患者信息表';

-- ----------------------------
-- Table structure for t_sl_followup_patient_job
-- ----------------------------
DROP TABLE IF EXISTS `t_sl_followup_patient_job`;
CREATE TABLE `t_sl_followup_patient_job` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者主索引',
  `is_delete` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '0: 开启 1 删除',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划ID(专科随访计划表主键)',
  `send_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送时间段(多选'',''分隔 例如9,15,21; 0:表示立即发送)',
  `send_over_task` int DEFAULT '0' COMMENT '过期任务自动发送(0:否 1:是)',
  `send_over_task_days` int DEFAULT NULL COMMENT '过期任务自动发送×天内',
  `auto_complete_task` int DEFAULT '0' COMMENT '无异常任务自动关闭(0:否 1:是)',
  `enable_status` int DEFAULT '0' COMMENT '启用状态(0:停用 1:启用)',
  `creator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人ID',
  `creator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `except_remind` int DEFAULT '0' COMMENT '异常短信提醒(0否, 1是)',
  `remind_mobile` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常提醒号码,多个号码用逗号隔开',
  `personal_or_family` tinyint(1) DEFAULT NULL COMMENT '发送给本人或家属',
  `auto_send_times_limit` tinyint DEFAULT NULL COMMENT '自动发送次数上限',
  `send_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送方式(1,ai语音/app/微信  2,短信)，多选逗号分隔拼接',
  `enable_edu_status` int DEFAULT '0' COMMENT '宣教发送启用状态(0:停用 1:启用)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专科患者随访自动随访配置表';

-- ----------------------------
-- Table structure for t_sl_followup_patient_job_log
-- ----------------------------
DROP TABLE IF EXISTS `t_sl_followup_patient_job_log`;
CREATE TABLE `t_sl_followup_patient_job_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `job_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '关联自动随访配置id',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者主索引',
  `old_enable_status` tinyint(1) DEFAULT NULL COMMENT '旧的启用状态(0:停用 1:启用)',
  `old_enable_edu_status` tinyint(1) DEFAULT NULL COMMENT '旧的宣教发送启用状态(0:停用 1:启用)',
  `new_enable_status` tinyint(1) DEFAULT NULL COMMENT '新的启用状态(0:停用 1:启用)',
  `new_enable_edu_status` tinyint(1) DEFAULT NULL COMMENT '新的宣教发送启用状态(0:停用 1:启用)',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间',
  `operate_type` tinyint DEFAULT NULL COMMENT '操作类型，1:新增 2:修改',
  `operator_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人ID',
  `operator_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建/编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者随访自动随访配置日志表';

-- ----------------------------
-- Table structure for t_sl_followup_patient_spare
-- ----------------------------
DROP TABLE IF EXISTS `t_sl_followup_patient_spare`;
CREATE TABLE `t_sl_followup_patient_spare` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划ID',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `pat_source_type_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病人来源名称',
  `serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `in_hosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `out_hosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者姓名',
  `sex_code` int DEFAULT NULL COMMENT '性别代码(1:男 2:女 9:其他)',
  `sex_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `birthdate` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '出生日期',
  `age` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '年龄',
  `id_card` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号',
  `mobile_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号码',
  `his_mobile` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'HIS手机号',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码(门诊/出院/在院/转科)',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称(门诊/出院/在院/转科)',
  `ward_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区代码(出院/在院/转科)',
  `ward_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区名称(出院/在院/转科)',
  `bed_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病床号(出院/在院/转科)',
  `dr_code` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主治/签约医生工号',
  `dr_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主治/签约医生姓名',
  `diag_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病诊断代码',
  `diag_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '疾病诊断名称',
  `out_come` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '转归情况',
  `business_time` datetime DEFAULT NULL COMMENT '业务发生时间 入院/出院/就诊/体检/签约/入科/出科/建档/签约/收藏患者时间（或加入分组时间）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `is_manage` tinyint(1) DEFAULT '2' COMMENT '是否已管理(1:是  2:否）',
  `pathology_report` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病理报告（检查报告-检查描述）',
  `surgery_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术名称',
  `in_hosp_days` smallint DEFAULT NULL COMMENT '住院天数',
  `remark` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_plan_id_empi_id_spare` (`plan_id`,`empi_id`) USING BTREE,
  KEY `idx_serial_no_spare` (`serial_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专科随访患者信息备选表';

-- ----------------------------
-- Table structure for t_sl_followup_plan_task
-- ----------------------------
DROP TABLE IF EXISTS `t_sl_followup_plan_task`;
CREATE TABLE `t_sl_followup_plan_task` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '专科随访计划ID',
  `task_prop` int DEFAULT NULL COMMENT '规则任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `task_time_type` int DEFAULT '1' COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `task_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '随访/提醒类型名称',
  `task_type` int DEFAULT NULL COMMENT '宣教类型/提醒类别( 宣教类型: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒类别: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒 )',
  `task_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教类型/提醒类别名称',
  `begin_time_type` int DEFAULT NULL COMMENT '发送时间类型(1,收案后 2,入院后, 3,出院后 4,门诊手术后 5,住院手术后 6,门诊后 7,体检后 8,出科后 9,入科后 固定下拉字典表配置)',
  `begin_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发送时间类型名称',
  `business_date_type` int DEFAULT NULL COMMENT '收案后-业务时间类型(0,收案日期 1,预产期 2,末次月经日期 3,手术日期 4,检验日期 5,检查时间 6,胚胎移植日期 7,分娩日期)',
  `business_date_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '收案后-业务时间类型名称',
  `after_begin_time` int DEFAULT NULL COMMENT '距开始时间后',
  `after_begin_time_unit` int DEFAULT NULL COMMENT '时间单位(系统下拉配置表取值 1:天 2:周 3:月 4:年)',
  `after_begin_time_unit_name` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '时间单位名称',
  `after_begin_time_hour` int DEFAULT NULL COMMENT '需提醒日程的具体时间(0-20, 0点-20点, 页面写死)',
  `advance_send_time` int DEFAULT NULL COMMENT '提醒提前发送时间(转换成小时存,前端下拉从固定字典表取)',
  `advance_send_time_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提前发送时间名称',
  `after_begin_time_days` int DEFAULT NULL COMMENT '距开始时间后-天(根据时间单位转换成天数)',
  `timing_date` date DEFAULT NULL COMMENT '定时日期(定时任务用)',
  `range_days` int DEFAULT NULL COMMENT '范围天数',
  `frequency` int DEFAULT NULL COMMENT '周期(周期性随访)',
  `frequency_unit` int DEFAULT NULL COMMENT '周期单位(周期性随访)(1,天/次, 2,月/次 3,年/次)',
  `frequency_unit_name` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '周期单位名称(周期性随访)',
  `frequency_count` int DEFAULT NULL COMMENT '周期循环次数',
  `drug_code` varchar(3500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联药品代码(逗号","分隔,上限10个)',
  `drug_name` varchar(5000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联药品名称(逗号","分隔,上限10个)',
  `exam_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联检查代码(逗号","分隔,上限10个)',
  `exam_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联检查名称(逗号","分隔,上限10个)',
  `test_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联检验代码(逗号","分隔,上限10个)',
  `test_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联检验名称(逗号","分隔,上限10个)',
  `diag_related` int DEFAULT NULL COMMENT '关联疾病情况(0:不关联疾病 1:包含疾病 2:不包含疾病)',
  `diag_match` tinyint(1) DEFAULT '0' COMMENT '关联疾病匹配方式(0:精确匹配 1:模糊匹配)',
  `diag_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联疾病代码(逗号","分隔,上限10个)',
  `diag_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联疾病名称(逗号","分隔,上限10个)',
  `category_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒分类ID(表单)',
  `category_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒分类名称',
  `content_id` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒ID(多选逗号","分隔,上限10个)',
  `content_title` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单/宣教/提醒标题(多选逗号","分隔,上限10个)',
  `return_visit_type` int DEFAULT NULL COMMENT '回访方式(1,电话;2,app,短信,微信;)',
  `return_visit_type_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '回访方式名称',
  `valid_days` int DEFAULT NULL COMMENT '有效天数(天)',
  `remind_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表单说明/提醒内容',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `drug_status` int DEFAULT NULL COMMENT '用药情况(0:不关联用药  1:包含用药  2:不包含用药)',
  `drug_match` tinyint(1) DEFAULT '0' COMMENT '关联药品匹配方式(0:精确匹配 1:模糊匹配)',
  `surgery_status` int DEFAULT NULL COMMENT '手术情况(0不关联 1包含手术 2不包含手术)',
  `surgery_match` tinyint(1) DEFAULT '0' COMMENT '手术匹配方式(0:精确匹配 1:模糊匹配)',
  `surgery_code` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术代码(多选,分隔 上限10个)',
  `surgery_name` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手术名称(多选,分隔 上限10个)',
  `only_out_hosp_drug_status` int DEFAULT '0' COMMENT '仅表示出院带药勾选状态 0未勾选 1勾选',
  `group_index` tinyint DEFAULT NULL COMMENT '任务组块排序号，同排序号的认为是同一组',
  `inner_group_index` int DEFAULT NULL COMMENT '任务组块内部组块排序号，同排序号的认为是同一组',
  `referral_dept_code` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊科室，多选逗号分隔',
  `referral_dept_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊科室名称',
  `referral_valid_type` tinyint DEFAULT '0' COMMENT '复诊有效时间类型（0，当天  1，推迟  2，提前  3，提前或推迟）',
  `referral_valid_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊有效时间类型名称',
  `referral_valid_days` int DEFAULT NULL COMMENT '复诊有效时间天数',
  `referral_remind_desc` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '复诊提醒内容',
  `referral_confirm` tinyint DEFAULT NULL COMMENT '复诊确认0 否， 1 是',
  `not_referral_except` tinyint DEFAULT NULL COMMENT '未复诊算异常 0，否  1，是',
  `actual_referral_related` tinyint DEFAULT NULL COMMENT '实际复诊关联 0，否  1，是',
  `referral_begin_time_type` tinyint DEFAULT NULL COMMENT '诊前诊后任务开始时间类型(见枚举 SpecialistBeginTimeTypeEnum)',
  `referral_begin_time_type_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊前诊后任务开始时间类型名称',
  `referral_after_begin_time` int DEFAULT NULL COMMENT '诊前诊后任务开始时间天/周/月/年数',
  `referral_after_begin_time_unit` int DEFAULT NULL COMMENT '诊前诊后任务开始时时间单位',
  `referral_after_begin_time_unit_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊前诊后任务开始时时间单位名称',
  `referral_after_begin_time_hour` tinyint DEFAULT NULL COMMENT '复诊提醒任务类型计划具体小时',
  `branch_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属分支ID',
  `is_branch_task` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为分支下的任务（0，否  1，是）',
  `is_personalise_edu` int DEFAULT NULL COMMENT '个性化宣教任务 0：否（默认） 1：是 ',
  `pat_source_type` tinyint DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院)',
  `dept_relate` tinyint DEFAULT NULL COMMENT '1包含科室/病区 2不包含科室/病区',
  `dept_code` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码(多选 ,分隔 上限10个)',
  `dept_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称(多选 ,分隔 上限10个)',
  `ward_code` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区代码(多选 ,分隔 上限10个)',
  `ward_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区名称(多选 ,分隔 上限10个)',
  `daytime_flag` tinyint DEFAULT '0' COMMENT '是否日间过滤（0:什么都不选 1：选了是 2：选了否）',
  `eras_flag` tinyint DEFAULT '0' COMMENT '是否ERAS过滤（0:什么都不选 1：选了是 2：选了否）',
  `vte_flag` tinyint DEFAULT '0' COMMENT '是否VTE过滤（0:什么都不选 1：选了是 2：选了否）',
  `gps_flag` tinyint DEFAULT '0' COMMENT '是否GPS过滤（0:什么都不选 1：选了是 2：选了否）',
  `nrs_type` tinyint DEFAULT '0' COMMENT '筛选nrs评分类型（1：大于等于3分   2：小于3分）',
  `knowledge_task_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '知识库任务id',
  `task_target` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '任务对象，1.患者，2.健管师，逗号分隔',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专科随访计划规则表';

-- ----------------------------
-- Table structure for t_upload_time
-- ----------------------------
DROP TABLE IF EXISTS `t_upload_time`;
CREATE TABLE `t_upload_time` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `organ_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `source_type` tinyint(1) NOT NULL COMMENT '数据来源 1.住院医嘱 2.住院收费 3.门诊收费',
  `upload_time` datetime NOT NULL COMMENT '同步完成时间',
  `advice_time_type` tinyint(1) DEFAULT NULL COMMENT '医嘱同步时间 1.开立时间 2.执行时间 3.撤销时间',
  `inhosp_time_type` tinyint(1) DEFAULT NULL COMMENT '住院收费 1.计费时间 2.结算时间 3.退费时间',
  `outhosp_time_type` tinyint(1) DEFAULT NULL COMMENT '门诊收费 1.计费时间 2.结算时间 3.退费时间',
  `result_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '同步状态 0.正常 1.异常',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='同步时间表';

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `uname` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_video_script
-- ----------------------------
DROP TABLE IF EXISTS `t_video_script`;
CREATE TABLE `t_video_script` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `content` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '内容',
  `preach_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣教id',
  `preach_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣教名称',
  `version` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '版本',
  `label_code` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `source_code` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源编码',
  `source_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_user_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人名称',
  `update_user_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人名称',
  `release_status` int DEFAULT NULL COMMENT '发布状态 1 发布 0待发布。',
  `delete_status` int DEFAULT NULL COMMENT '删除状态 1 删除 0正常 2 暂存',
  `label_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签名称',
  `app_ids` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本应用id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_wechat_service_config
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_service_config`;
CREATE TABLE `t_wechat_service_config` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '机构代码',
  `hosp_name` varchar(150) DEFAULT NULL COMMENT '机构名称',
  `dept_codes` text COMMENT '科室代码',
  `dept_names` text COMMENT '科室名称',
  `main_title` varchar(50) DEFAULT NULL COMMENT '主标题',
  `subtitle` varchar(50) DEFAULT NULL COMMENT '副标题',
  `theme` tinyint(1) DEFAULT NULL COMMENT '皮肤风格 1 母婴风格 2 通用风格',
  `video_url` varchar(500) DEFAULT NULL COMMENT '视频地址',
  `video_name` varchar(50) DEFAULT NULL COMMENT '视频name',
  `service_goods_prices` text COMMENT '物价',
  `service_content` text COMMENT '服务内容介绍',
  `create_id` varchar(50) DEFAULT NULL COMMENT '创建人id',
  `create_name` varchar(50) DEFAULT NULL COMMENT '创建人name',
  `edit_id` varchar(50) DEFAULT NULL COMMENT '编辑人id',
  `edit_name` varchar(50) DEFAULT NULL COMMENT '编辑人name',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务配置表';

-- ----------------------------
-- Table structure for t_weight_followup
-- ----------------------------
DROP TABLE IF EXISTS `t_weight_followup`;
CREATE TABLE `t_weight_followup` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `task_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣讲任务id',
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单id',
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开单id',
  `followup_flag` tinyint DEFAULT NULL COMMENT '0:复诊提醒 1:复诊预约',
  `followup_type` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '0:门诊复查 1:体成分复查',
  `pad_flag` tinyint DEFAULT NULL COMMENT '0:pad不展示 1:pad展示',
  `is_send` tinyint DEFAULT NULL COMMENT '0:未发送 1:已发送',
  `followup_status` tinyint DEFAULT NULL COMMENT '0:未开始 1:待预约 2:已预约待复查 3:已复查 4:已取消(未复查) 5:改约日期',
  `plan_date` datetime DEFAULT NULL COMMENT '计划复诊时间',
  `plan_date_str` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划复诊时间 时分秒（暂存）',
  `remind_date` datetime DEFAULT NULL COMMENT '复诊提醒时间',
  `remind_date_str` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复诊提醒时间 时分秒（暂存）',
  `real_date` datetime DEFAULT NULL COMMENT '实际复诊时间',
  `pad_plan_date` datetime DEFAULT NULL COMMENT 'pad预约复诊时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复诊备注',
  `cancel_remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '取消原因',
  `change_remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '改约原因',
  `weight_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '患者营养学科记录表 id',
  `is_task` tinyint DEFAULT '0' COMMENT '是否pad配置录入0:否 1:是',
  `is_wechat` tinyint DEFAULT NULL COMMENT '是否小程序录入 0:否 1:是',
  `is_edit` tinyint DEFAULT '1' COMMENT '是否可编辑 0:否 1:是',
  `save_flag` tinyint DEFAULT NULL COMMENT '是否暂存 0:暂存 1:保存',
  `create_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人id',
  `create_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人name',
  `update_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人id',
  `update_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人name',
  `pad_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'pad最后修处理id',
  `pad_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'pad最后修处理name',
  `pad_create_time` datetime DEFAULT NULL COMMENT 'pad展示时间',
  `pad_update_time` timestamp NULL DEFAULT NULL COMMENT 'pad更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='高净值复诊';

-- ----------------------------
-- Table structure for t_weight_followup_log
-- ----------------------------
DROP TABLE IF EXISTS `t_weight_followup_log`;
CREATE TABLE `t_weight_followup_log` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `weight_followup_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '高净值复诊id',
  `followup_status` tinyint DEFAULT NULL COMMENT '0:未开始 1:待预约 2:已预约待复查 3:已复查 4:已取消(未复查) 5:改约日期',
  `followup_status_desc` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '0:未开始 1:待预约 2:已预约待复查 3:已复查 4:已取消(未复查) 5:改约日期',
  `deal_detail` varchar(600) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理详情',
  `remark` varchar(600) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `deal_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理人id',
  `deal_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理人name',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='高净值预约复诊处理日志';

-- ----------------------------
-- Table structure for t_wfy_order_fee
-- ----------------------------
DROP TABLE IF EXISTS `t_wfy_order_fee`;
CREATE TABLE `t_wfy_order_fee` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `outhosp_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `inhosp_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '住院号',
  `inhosp_serial_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '住院流水号',
  `organ_code` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `deal_no` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '交易流水号',
  `charge_item_code` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '收费项目名称',
  `item_unit_price` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目单价',
  `item_amount` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目开立数量',
  `deal_open_dept_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '费用开立科室代码',
  `deal_open_dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '费用开立科室名称',
  `deal_open_dr_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '费用开立医生工号',
  `deal_open_dr_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '费用开立医生名称',
  `deal_status` tinyint(1) DEFAULT NULL COMMENT '费用状态 1.收费 2.退费 3.对冲记录',
  `charge_time` datetime DEFAULT NULL COMMENT '结算时间',
  `refund_time` datetime DEFAULT NULL COMMENT '退费时间',
  `order_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '医嘱号',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_xt_data_temp
-- ----------------------------
DROP TABLE IF EXISTS `t_xt_data_temp`;
CREATE TABLE `t_xt_data_temp` (
  `id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `health_type` int DEFAULT NULL COMMENT '类型 1胎心2血压3血糖4体温5心率6身高体重',
  `health_value` varchar(5000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数值',
  `health_unit` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '单位',
  `health_status` int DEFAULT NULL COMMENT '健康状态',
  `measuring_time` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '测量时间 yyyy-MM-dd HH:mm:ss',
  `instruction` varchar(5000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `measuring_point` int DEFAULT NULL COMMENT '测量点 1早餐前2早餐后3午餐前4午餐后5晚餐前6晚餐后7睡前',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `resource_id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '文件id',
  `pat_id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病人id',
  `visit_card_no` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `visit_no` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊序号',
  `hosp_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医院编码',
  `id_card_no` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证号',
  `phone` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号',
  `name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '姓名',
  `status` int DEFAULT '1' COMMENT '状态 0无效1有效',
  `artificial_flag` int DEFAULT '0' COMMENT '人工上传标志(1:是0:否)',
  `source_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生随访帐号id',
  `empi_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主索引号',
  `birth_date` date DEFAULT NULL COMMENT '出生日期',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室编码',
  `dept_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室名称',
  `ward_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区编码',
  `ward_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '病区名称',
  `bed_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '床号',
  `device_type` int DEFAULT NULL COMMENT '设备类型',
  `source_type` int DEFAULT NULL COMMENT '来源(1门诊2出院3在院13建档（其他）99健康小屋(新附一个性化需求) 88院内血糖',
  `remark` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `update_person_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人id',
  `update_person_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人姓名',
  `update_dept_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人科室编码',
  `update_dept_name` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '编辑人科室名称',
  `false_data` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `thh_phone_index` (`phone`) USING BTREE,
  KEY `thh_id_card_no_index` (`id_card_no`) USING BTREE,
  KEY `thh_hosp_code` (`hosp_code`) USING BTREE,
  KEY `thh_health_type` (`health_type`) USING BTREE,
  KEY `thh_empi_id_index` (`empi_id`) USING BTREE,
  KEY `idx_measuring_time` (`measuring_time`) USING BTREE,
  KEY `idx_phone_healthtype_status` (`phone`,`health_type`,`status`) USING BTREE,
  KEY `idx_idcardno_healthtype_status` (`id_card_no`,`health_type`,`status`) USING BTREE,
  KEY `idx_idcardno_phone_health_type` (`id_card_no`,`phone`,`health_type`) USING BTREE,
  KEY `idx_idcardno_phone` (`id_card_no`,`phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='健康数据院内';

-- ----------------------------
-- Table structure for t_xt_pat_temp
-- ----------------------------
DROP TABLE IF EXISTS `t_xt_pat_temp`;
CREATE TABLE `t_xt_pat_temp` (
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `sex` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `age` tinyint DEFAULT NULL,
  `kfxt_b` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `2hxt_b` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `thxhdb_b` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `kfxt_a` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `2hxt_a` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `thxhdb_a` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `phone` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `service_start_time` datetime DEFAULT NULL,
  `service_end_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_xt_patient_temp
-- ----------------------------
DROP TABLE IF EXISTS `t_xt_patient_temp`;
CREATE TABLE `t_xt_patient_temp` (
  `pat_index_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `empi_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `mobile_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `pat_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `sex_name` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `age` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `inhosp_serial_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `service_start_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `service_end_time` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `visit_card_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `id_number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `outhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `inhosp_no` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `order_open_dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for t_zq_manage
-- ----------------------------
DROP TABLE IF EXISTS `t_zq_manage`;
CREATE TABLE `t_zq_manage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '机构名称',
  `zq_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '战区名称',
  `manage_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '战区管理姓名',
  `mobile_no` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '战区管理联系方式',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='战区负责人';

-- ----------------------------
-- Table structure for table_1
-- ----------------------------
DROP TABLE IF EXISTS `table_1`;
CREATE TABLE `table_1` (
  `id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户名',
  `user_pwd` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '手机号',
  `hosp_code` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医院编码',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `salt` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '盐',
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '真实姓名',
  `update_pwd_time` datetime DEFAULT NULL COMMENT '更新密码时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后一次登录时间',
  `agent` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '分机号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='用户';

-- ----------------------------
-- Table structure for user_organization
-- ----------------------------
DROP TABLE IF EXISTS `user_organization`;
CREATE TABLE `user_organization` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户id',
  `org_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='用户机构关联表';

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户id',
  `role_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='用户角色关联表';

-- ----------------------------
-- Table structure for v_jh_hos_operation
-- ----------------------------
DROP TABLE IF EXISTS `v_jh_hos_operation`;
CREATE TABLE `v_jh_hos_operation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci NOT NULL COMMENT '机构名称',
  `dept` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci NOT NULL COMMENT '科室',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci NOT NULL COMMENT '科室名称',
  `discharge_num` int DEFAULT '0' COMMENT '出院人数',
  `discharge_date` date NOT NULL COMMENT '出院日期',
  `dept_num` int DEFAULT '0' COMMENT '开单科室出院人数',
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci NOT NULL COMMENT '机构代码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `discharge_date` (`discharge_date`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=262717 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_mysql500_ci;

-- ----------------------------
-- Table structure for v_jh_plan_count
-- ----------------------------
DROP TABLE IF EXISTS `v_jh_plan_count`;
CREATE TABLE `v_jh_plan_count` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `hosp_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `plan_count` int DEFAULT '0' COMMENT '路径总数',
  `open_sign_plan` int DEFAULT '0' COMMENT '开启签字路径总数',
  `open_nosign_plan` int DEFAULT '0' COMMENT '开启路径签字总数',
  `close_sign_plan` int DEFAULT '0' COMMENT '未开启签字总数',
  `close_nosign_plan` int DEFAULT '0',
  `file_plan` int DEFAULT '0' COMMENT '开启路径上传文档总数',
  `create_date` datetime DEFAULT NULL COMMENT '路径创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `hosp_code` (`hosp_code`) USING BTREE,
  KEY `create_date` (`create_date`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=471 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- ----------------------------
-- Table structure for v_jh_sync_time
-- ----------------------------
DROP TABLE IF EXISTS `v_jh_sync_time`;
CREATE TABLE `v_jh_sync_time` (
  `id` int NOT NULL DEFAULT '0',
  `function_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci DEFAULT '' COMMENT '功能代码',
  `function_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci DEFAULT '' COMMENT '功能名',
  `last_sync_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_mysql500_ci;

-- ----------------------------
-- Table structure for v_jh_workload_count
-- ----------------------------
DROP TABLE IF EXISTS `v_jh_workload_count`;
CREATE TABLE `v_jh_workload_count` (
  `user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci NOT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci NOT NULL,
  `work_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci DEFAULT NULL COMMENT '工作名称',
  `work_count` int DEFAULT '0' COMMENT '工作量',
  `flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci NOT NULL DEFAULT '' COMMENT '标识符 1：收案人数 2：有效电话数 3：任务完成数 4：复诊异常处理书 5：AI推送数 6：预约挂号数 7：AI异常处理数 8：分组管理人数 9:接听电话数',
  `work_date` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_mysql500_ci NOT NULL COMMENT '工作量对应时间',
  PRIMARY KEY (`user_name`,`hosp_code`,`work_date`,`flag`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_mysql500_ci;

-- ----------------------------
-- View structure for t_jh_url
-- ----------------------------
DROP VIEW IF EXISTS `t_jh_url`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `t_jh_url` AS select `t_h_hosp_url`.`hosp_code` AS `hosp_code`,`t_h_hosp_url`.`hosp_name` AS `hosp_name` from `t_h_hosp_url` where (`t_h_hosp_url`.`hosp_code` like '%166%');

-- ----------------------------
-- Function structure for workdaynum
-- ----------------------------
DROP FUNCTION IF EXISTS `workdaynum`;
delimiter ;;
CREATE FUNCTION `celina-health`.`workdaynum`(`datefrom` date,`dateto` date)
 RETURNS int
  NO SQL 
BEGIN
	declare days int default 1;
	if (datefrom > dateto  or year(datefrom) != year(dateto)) then
	   return -1;
	end if;
	
	set days = 
	   case 
	   when week(dateto)-week(datefrom) = 0 then 
	        dayofweek(dateto) - dayofweek(datefrom) + 1
		  - case 
		    when (dayofweek(datefrom) > 1 and dayofweek(dateto) < 7) then 0
		    when (dayofweek(datefrom) = 1 and dayofweek(dateto) =7) then 2
		    else 1
		    end
	   else (week(dateto)-week(datefrom)-1) * 5
	      + case 
		    when dayofweek(datefrom) = 1 then 5
			when dayofweek(datefrom) = 7 then 0
		    else 7 - dayofweek(datefrom)
			end
		  + case 
		    when dayofweek(dateto) = 1 then 0
			when dayofweek(dateto) = 7 then 5
			else dayofweek(dateto) - 1
			end
	   end;
			 
	   return days;
end
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
