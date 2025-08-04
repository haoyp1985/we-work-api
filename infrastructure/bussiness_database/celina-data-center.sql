/*
 Navicat MySQL Data Transfer

 Source Server         : 健海测试-3.212
 Source Server Type    : MySQL
 Source Server Version : 80028
 Source Host           : 192.168.3.212:3306
 Source Schema         : celina-data-center

 Target Server Type    : MySQL
 Target Server Version : 80028
 File Encoding         : 65001

 Date: 17/07/2025 16:41:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for DATABASECHANGELOG
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOG`;
CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `AUTHOR` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FILENAME` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MD5SUM` varchar(35) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COMMENTS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TAG` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LIQUIBASE` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CONTEXTS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LABELS` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for DATABASECHANGELOGLOCK
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for bool_metric_record
-- ----------------------------
DROP TABLE IF EXISTS `bool_metric_record`;
CREATE TABLE `bool_metric_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` tinyint NOT NULL COMMENT '数据值-布尔',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `pay_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `enum_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `enum_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `enum_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `enum_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `enum_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `enum_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `enum_metric_record_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for calorie_metric_record_huawei
-- ----------------------------
DROP TABLE IF EXISTS `calorie_metric_record_huawei`;
CREATE TABLE `calorie_metric_record_huawei` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` decimal(11,4) NOT NULL COMMENT '数据值-数值',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '删除标记 0未删除 1已删除',
  `pay_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `idx_pat_id` (`pat_id`) USING BTREE,
  KEY `idx_source_id` (`source_id`,`source_type`) USING BTREE,
  KEY `idx_metric_id` (`business_label`) USING BTREE,
  KEY `idx_record_time` (`record_time`) USING BTREE,
  KEY `idx_update_time` (`update_time`) USING BTREE,
  KEY `idx_pat_label` (`pat_id`,`business_label`,`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='华为卡路里指标数据';

-- ----------------------------
-- Table structure for click_house_opt_log
-- ----------------------------
DROP TABLE IF EXISTS `click_house_opt_log`;
CREATE TABLE `click_house_opt_log` (
  `id` bigint NOT NULL COMMENT '主键',
  `opt_time` datetime DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='clickhouse操作日志表';

-- ----------------------------
-- Table structure for condition_tag_pat
-- ----------------------------
DROP TABLE IF EXISTS `condition_tag_pat`;
CREATE TABLE `condition_tag_pat` (
  `id` bigint NOT NULL COMMENT '主键',
  `collection_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签集合id',
  `pat_id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '患者id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `condition_tag_pat_collection_id_IDX` (`collection_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for data_type
-- ----------------------------
DROP TABLE IF EXISTS `data_type`;
CREATE TABLE `data_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `data_table` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据表名',
  `visible` tinyint NOT NULL COMMENT '是否对外可见：1-可见，0-不可见',
  PRIMARY KEY (`id`),
  KEY `data_type_name_IDX` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for date_metric_record
-- ----------------------------
DROP TABLE IF EXISTS `date_metric_record`;
CREATE TABLE `date_metric_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` date NOT NULL COMMENT '数据值-日期',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `pay_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `date_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `date_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `date_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `date_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `date_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `date_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `date_metric_record_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for decimal_metric_record
-- ----------------------------
DROP TABLE IF EXISTS `decimal_metric_record`;
CREATE TABLE `decimal_metric_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` decimal(11,4) NOT NULL COMMENT '数据值-数值',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '单位',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `pay_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `decimal_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `decimal_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `decimal_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `decimal_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `decimal_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `decimal_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `decimal_metric_record_update_time_IDX` (`update_time`) USING BTREE,
  KEY `pat_label_idx` (`pat_id`,`business_label`,`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for decimal_metric_record_huawei
-- ----------------------------
DROP TABLE IF EXISTS `decimal_metric_record_huawei`;
CREATE TABLE `decimal_metric_record_huawei` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` decimal(11,4) NOT NULL COMMENT '数据值-数值',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '删除标记 0未删除 1已删除',
  `pay_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `idx_pat_id` (`pat_id`) USING BTREE,
  KEY `idx_source_id` (`source_id`,`source_type`) USING BTREE,
  KEY `idx_metric_id` (`business_label`) USING BTREE,
  KEY `idx_record_time` (`record_time`) USING BTREE,
  KEY `idx_update_time` (`update_time`) USING BTREE,
  KEY `idx_pat_label` (`pat_id`,`business_label`,`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='华为房颤指标数据';

-- ----------------------------
-- Table structure for demo_patient
-- ----------------------------
DROP TABLE IF EXISTS `demo_patient`;
CREATE TABLE `demo_patient` (
  `empi_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pat_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for dept_library_cloud
-- ----------------------------
DROP TABLE IF EXISTS `dept_library_cloud`;
CREATE TABLE `dept_library_cloud` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `parent_dept_code` varchar(30) DEFAULT NULL COMMENT '上级科室代码',
  `parent_dept_name` varchar(50) DEFAULT NULL COMMENT '上级科室名称',
  `pinyin_code` varchar(25) DEFAULT NULL COMMENT '拼音码',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `desc` varchar(200) DEFAULT NULL COMMENT '科室描述',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `is_level` int DEFAULT NULL COMMENT '1:一级科室 2：二级科室',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `is_map` int DEFAULT NULL COMMENT '必要映射 1:必要映射',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dict_tag
-- ----------------------------
DROP TABLE IF EXISTS `dict_tag`;
CREATE TABLE `dict_tag` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签代码',
  `tag_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `parent_tag_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '父级标签code,0-本身父级',
  `is_leaf` tinyint(1) DEFAULT NULL COMMENT '是否叶子标签 1-是',
  `sort_no` tinyint DEFAULT NULL COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag_code` (`tag_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签字典表';

-- ----------------------------
-- Table structure for dict_tag_group
-- ----------------------------
DROP TABLE IF EXISTS `dict_tag_group`;
CREATE TABLE `dict_tag_group` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键',
  `object_type` int NOT NULL COMMENT '对象属性',
  `tag_code` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签编码',
  `tag_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `tag_desc` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签定义',
  `first_category_id` int NOT NULL COMMENT '一级类目id',
  `second_category_id` int NOT NULL COMMENT '二级类目id',
  `third_category_id` int DEFAULT NULL COMMENT '三级类目id',
  `fourth_category_id` int DEFAULT NULL COMMENT '四级类目id',
  `data_type` int NOT NULL COMMENT '数据类型',
  `data_type_desc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '数据描述',
  `status` tinyint NOT NULL COMMENT '状态 0 已停用 1 已启用 3 已删除',
  `create_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建时间',
  `create_by` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '修改人id',
  `update_by` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '创建时间',
  `start_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开启人id',
  `start_by` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开启人',
  `start_time` datetime DEFAULT NULL COMMENT '开启时间',
  `stop_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '停用人id',
  `stop_by` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '停用人',
  `stop_time` datetime DEFAULT NULL COMMENT '停用时间',
  `delete_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '删除人id',
  `delete_by` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '删除人',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  `is_delete` tinyint(1) NOT NULL COMMENT '删除标识，0：未删除，1：已删除',
  `label_source` int DEFAULT '2' COMMENT '标签来源 1系统自动生成 2人工',
  `column_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `real_time_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '标签是否实时生成标识 0：否 1：是',
  `used_grouping` tinyint DEFAULT '0' COMMENT '是否用于用户分群',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签字典表';

-- ----------------------------
-- Table structure for disease_library_cloud
-- ----------------------------
DROP TABLE IF EXISTS `disease_library_cloud`;
CREATE TABLE `disease_library_cloud` (
  `id` varchar(32) NOT NULL,
  `code` varchar(50) DEFAULT '' COMMENT '编码',
  `name` varchar(100) DEFAULT NULL COMMENT '名称',
  `additional_code` varchar(50) DEFAULT NULL COMMENT '附加名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `level` int DEFAULT NULL COMMENT '等级 ',
  `father_code` varchar(50) DEFAULT NULL COMMENT '上一级code',
  PRIMARY KEY (`id`),
  KEY `co` (`code`) USING BTREE,
  KEY `l` (`level`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for distance_metric_record_huawei
-- ----------------------------
DROP TABLE IF EXISTS `distance_metric_record_huawei`;
CREATE TABLE `distance_metric_record_huawei` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` decimal(11,4) NOT NULL COMMENT '数据值-数值',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '删除标记 0未删除 1已删除',
  `pay_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `idx_pat_id` (`pat_id`) USING BTREE,
  KEY `idx_source_id` (`source_id`,`source_type`) USING BTREE,
  KEY `idx_metric_id` (`business_label`) USING BTREE,
  KEY `idx_record_time` (`record_time`) USING BTREE,
  KEY `idx_update_time` (`update_time`) USING BTREE,
  KEY `idx_pat_label` (`pat_id`,`business_label`,`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='华为活动距离指标数据';

-- ----------------------------
-- Table structure for dwt_dict_tag
-- ----------------------------
DROP TABLE IF EXISTS `dwt_dict_tag`;
CREATE TABLE `dwt_dict_tag` (
  `tag_code` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签代码',
  `tag_name` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签名称',
  `parent_tag_code` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '父级标签code,0-本身父级',
  `sort_no` int DEFAULT NULL COMMENT '排序'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签字典表';

-- ----------------------------
-- Table structure for dwt_patient_label
-- ----------------------------
DROP TABLE IF EXISTS `dwt_patient_label`;
CREATE TABLE `dwt_patient_label` (
  `pat_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据中心patId',
  `empi_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '患者empId',
  `sex` int DEFAULT NULL COMMENT '性别',
  `age` int DEFAULT NULL COMMENT '年龄',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `last_visit_hosp_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次门诊医院',
  `last_visit_dept_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次门诊科室',
  `last_visit_main_diag_name` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次门诊主诊断疾病',
  `last_visit_main_diag_code_icdverified` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次门诊主诊断ICD',
  `last_visit_date_ts` datetime DEFAULT NULL COMMENT '最近一次门诊时间',
  `last_inhosp_hosp_code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次住院医院',
  `last_inhosp_dept_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次住院科室',
  `last_inhosp_dept_code_guifan` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次住院规范科室名',
  `last_inhosp_ward_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次住院病区',
  `last_inhosp_main_diag_name` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次住院主诊断疾病',
  `last_inhosp_main_diag_code_icdverified` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次住院主诊断ICD',
  `last_order_open_hosp_code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次开嘱医院',
  `last_order_open_dept_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次开嘱科室',
  `last_order_open_dept_code_guifan` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次开嘱规范科室名',
  `last_order_order_date` datetime DEFAULT NULL COMMENT '最近一次开嘱时间',
  `last_order_charge_item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次收费项目名称',
  `last_order_actual_money_origin` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次实收金额',
  `last_preach_finish_time` datetime DEFAULT NULL COMMENT '最近一次宣讲时间',
  `current_service_create_time` datetime DEFAULT NULL COMMENT '当前服务收案时间',
  `current_service_product_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '当前服务产品名称',
  `current_service_start_time` date DEFAULT NULL COMMENT '当前服务开始日期',
  `current_service_end_time` date DEFAULT NULL COMMENT '当前服务结束日期',
  `current_service_status_flag` int DEFAULT NULL COMMENT '当前服务状态',
  `current_service_goods_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '当前服务商品名称',
  `current_team_set_type` int DEFAULT NULL COMMENT '履约团队',
  `current_goods_charge` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '服务包档位',
  `applet_is_banding` int DEFAULT NULL COMMENT '是否注册小程序',
  `hosp_code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '医院编码',
  `wecom_is_banding` int DEFAULT NULL COMMENT '是否添加企业微信为好友',
  `applet_visit_is_banding` int DEFAULT NULL COMMENT '是否绑定小程序就诊人',
  `current_service_inner_goods_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '当前服务商品内部名称',
  `current_service_inner_product_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '当前服务产品内部名称',
  `wecom_add_time` datetime DEFAULT NULL COMMENT '企微添加时间',
  `last_discharge_date` datetime DEFAULT NULL COMMENT '最近出院时间',
  `last_order_hosp_area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次开单院区',
  `last_order_source_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次开单患者来源',
  `last_surgery_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次手术名称',
  `last_order_is_upload_informed` int DEFAULT NULL COMMENT '最近一次开单是否上传知情同意书',
  `last_gastrointestinal_endoscopy_appointment_time` datetime DEFAULT NULL COMMENT '最近一次预约胃肠镜检查时间',
  `last_gastrointestinal_endoscopy_time` datetime DEFAULT NULL COMMENT '最近一次实际胃肠镜检查时间',
  `has_gastrointestinal_endoscopy_report` int DEFAULT NULL COMMENT '是否有最近一次胃肠镜检查报告',
  `has_gastrointestinal_endoscopy_pathological_report` int DEFAULT NULL COMMENT '是否有最近一次胃肠镜病理报告',
  `last_gastrointestinal_endoscopy_report_time` datetime DEFAULT NULL COMMENT '最近一次胃肠镜检查报告出具时间',
  `last_gastrointestinal_endoscopy_pathological_report_time` datetime DEFAULT NULL COMMENT '最近一次胃肠镜病理报告出具时间',
  `last_inhosp_diag_name` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次住院诊断疾病',
  `last_visit_diag_name` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次门诊诊断疾病',
  `last_leave_hosp_diag_name` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最近一次出院诊断疾病',
  `is_suspected_afib` int DEFAULT NULL COMMENT '是否疑似房颤',
  `last_is_surgery` int DEFAULT NULL COMMENT '最近一次是否有手术',
  `last_gastroscope_appointment_time` datetime DEFAULT NULL COMMENT '最近一次开单预约胃镜时间',
  `last_colonoscopy_appointment_time` datetime DEFAULT NULL COMMENT '最近一次开单预约肠镜时间',
  `last_inhosp_time` datetime DEFAULT NULL COMMENT '最近一次入院时间',
  `bu_relation_type` tinyint DEFAULT NULL,
  `is_physical_test` int DEFAULT NULL COMMENT '是否体测 0-未体测 1-已体测',
  `health_conpetition_status` int DEFAULT NULL COMMENT '健康赛状态 1-已报名',
  `weight_conpetition_status` int DEFAULT NULL COMMENT '减重赛状态 1-体重管理通过 2-体重管理排除',
  `patient_last_msg_time` date DEFAULT NULL COMMENT '用户最近一次主动发企微消息时间',
  `staff_last_reply_time` date DEFAULT NULL COMMENT '管理端最近一次主动发企微消息时间',
  PRIMARY KEY (`pat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- ----------------------------
-- Table structure for ecg_metric_record
-- ----------------------------
DROP TABLE IF EXISTS `ecg_metric_record`;
CREATE TABLE `ecg_metric_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` json NOT NULL COMMENT '数据值-json',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `pay_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  `device_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `string_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `string_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `string_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `string_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `string_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `string_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `string_metric_record_update_time_IDX` (`update_time`) USING BTREE,
  KEY `inx_pat_label` (`pat_id`,`business_label`,`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for enum_metric_record
-- ----------------------------
DROP TABLE IF EXISTS `enum_metric_record`;
CREATE TABLE `enum_metric_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据值-枚举',
  `unit` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `pay_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `enum_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `enum_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `enum_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `enum_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `enum_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `enum_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `enum_metric_record_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for hos_tag_record
-- ----------------------------
DROP TABLE IF EXISTS `hos_tag_record`;
CREATE TABLE `hos_tag_record` (
  `id` bigint NOT NULL,
  `hosp_code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '医院编码',
  `pat_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `pat_id` bigint DEFAULT NULL COMMENT '患者id',
  `id_card` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证',
  `phone` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `outhosp_no` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '门诊号',
  `inhosp_no` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '住院号',
  `pat_index_no` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '患者流水号',
  `tags` varchar(2048) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='院内标签记录';

-- ----------------------------
-- Table structure for huawei_af_record
-- ----------------------------
DROP TABLE IF EXISTS `huawei_af_record`;
CREATE TABLE `huawei_af_record` (
  `id` bigint unsigned NOT NULL COMMENT 'id',
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'patId',
  `record_time` datetime NOT NULL COMMENT '记录日期',
  `is_chest_oppression` tinyint(1) NOT NULL COMMENT '胸闷  0-否 1-是',
  `is_palpitations` tinyint(1) NOT NULL COMMENT '心悸  0-否 1-是',
  `co_attack_time` datetime DEFAULT NULL COMMENT '胸闷发作时间',
  `pp_attack_time` datetime DEFAULT NULL COMMENT '心悸发作时间',
  `max_rate` int DEFAULT NULL COMMENT '最高心率',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_pat_id` (`pat_id`) USING BTREE,
  KEY `idx_record_time` (`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='华为房颤发作记录';

-- ----------------------------
-- Table structure for huawei_patient_report
-- ----------------------------
DROP TABLE IF EXISTS `huawei_patient_report`;
CREATE TABLE `huawei_patient_report` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `pat_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '患者姓名',
  `value` json NOT NULL COMMENT '报告内容',
  `ai_answer` json DEFAULT NULL COMMENT 'ai返回内容',
  `ai_req_content` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ai请求内容',
  `ai_res_content` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ai返回全部内容',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `report_type` tinyint NOT NULL COMMENT '报告类型，1周报 2月报',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `rating` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '消息反馈，点赞 like, 点踩 dislike',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `idx_patId` (`pat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='患者报告表';

-- ----------------------------
-- Table structure for huawei_sleep_record
-- ----------------------------
DROP TABLE IF EXISTS `huawei_sleep_record`;
CREATE TABLE `huawei_sleep_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `huawei_source_id` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '华为数据id',
  `fall_asleep_time` datetime NOT NULL COMMENT '入睡时间',
  `wakeup_time` datetime NOT NULL COMMENT '出睡时间',
  `all_sleep_time` int NOT NULL COMMENT '全部睡眠时长，分钟',
  `light_sleep_time` int DEFAULT NULL COMMENT '浅睡时长，分钟',
  `deep_sleep_time` int DEFAULT NULL COMMENT '深睡时长，分钟',
  `dream_time` int DEFAULT NULL COMMENT '快速眼动时长，分钟',
  `awake_time` int DEFAULT NULL COMMENT '清醒时长，分钟',
  `wakeup_count` int DEFAULT NULL COMMENT '清醒次数',
  `deep_sleep_part` int DEFAULT NULL COMMENT '深睡连续性得分，分数',
  `sleep_score` int DEFAULT NULL COMMENT '睡眠得分，分数',
  `go_bed_time` datetime DEFAULT NULL COMMENT '上床时间',
  `prepare_sleep_time` datetime DEFAULT NULL COMMENT '准备入睡时间',
  `off_bed_time` datetime DEFAULT NULL COMMENT '最后一次离床时间',
  `sleep_efficiency` int DEFAULT NULL COMMENT '呼吸质量，分数',
  `sleep_type` int DEFAULT '1' COMMENT '睡眠类型，默认为科学睡眠，1: 科学睡眠，2: 普通睡眠，3: 零星小睡',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_pw` (`pat_id`,`wakeup_time`) USING BTREE,
  KEY `idx_hsi` (`huawei_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='华为患者睡眠记录';

-- ----------------------------
-- Table structure for huawei_subscribe_record
-- ----------------------------
DROP TABLE IF EXISTS `huawei_subscribe_record`;
CREATE TABLE `huawei_subscribe_record` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_type` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关注/订阅的事件',
  `type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '事件类别',
  `sub_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '事件子类别',
  `subscription_mode` tinyint(1) DEFAULT '0' COMMENT '订阅方式',
  `subscriber_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订阅者ID',
  `subscription_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订阅记录ID',
  `open_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户唯一标识',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for huawei_update_remark
-- ----------------------------
DROP TABLE IF EXISTS `huawei_update_remark`;
CREATE TABLE `huawei_update_remark` (
  `id` varchar(35) NOT NULL COMMENT '主键',
  `pat_id` varchar(35) NOT NULL COMMENT '患者id',
  `huawei_open_id` varchar(100) NOT NULL COMMENT '华为用户id',
  `huawei_data_type` varchar(200) NOT NULL COMMENT '华为数据类型',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for huawei_user
-- ----------------------------
DROP TABLE IF EXISTS `huawei_user`;
CREATE TABLE `huawei_user` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pat_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'patId',
  `access_token` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'access_token',
  `refresh_token` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用于刷新AccessToken',
  `expires_in` int NOT NULL COMMENT 'Access Token的过期时间，以秒为单位',
  `id_token` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id_token',
  `scope` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '授权范围，多个以逗号拼接',
  `open_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户唯一标识',
  `union_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'unionId',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `is_show_first_dialog` tinyint(1) DEFAULT NULL COMMENT '是否展示过解绑后的首次弹框 1-是  0-否',
  `unbind_time` datetime DEFAULT NULL COMMENT '解绑时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for isv_keys
-- ----------------------------
DROP TABLE IF EXISTS `isv_keys`;
CREATE TABLE `isv_keys` (
  `id` bigint NOT NULL,
  `app_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'app_id',
  `app_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名称',
  `isv_public_key` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'isv公钥',
  `isv_private_key` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'isv私钥',
  `certificate_whitelist` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '认证白名单',
  `query_whitelist` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '查询白名单',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `isv_keys_app_id_IDX` (`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for json_metric_record
-- ----------------------------
DROP TABLE IF EXISTS `json_metric_record`;
CREATE TABLE `json_metric_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` json NOT NULL COMMENT '数据值-json',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `unit` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `pay_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `string_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `string_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `string_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `string_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `string_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `string_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `string_metric_record_update_time_IDX` (`update_time`) USING BTREE,
  KEY `inx_pat_label` (`pat_id`,`business_label`,`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for json_metric_record_copy1
-- ----------------------------
DROP TABLE IF EXISTS `json_metric_record_copy1`;
CREATE TABLE `json_metric_record_copy1` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` json NOT NULL COMMENT '数据值-json',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `pay_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `string_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `string_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `string_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `string_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `string_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `string_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `string_metric_record_update_time_IDX` (`update_time`) USING BTREE,
  KEY `inx_pat_label` (`pat_id`,`business_label`,`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for metric
-- ----------------------------
DROP TABLE IF EXISTS `metric`;
CREATE TABLE `metric` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '编码',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `international_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '指标国际编码',
  `data_type_id` bigint NOT NULL COMMENT '数据类型id',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `validate_json` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数校验json，根据默认单位',
  `business_label` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务指标标签',
  `business_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务指标名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `alias` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '别名',
  PRIMARY KEY (`id`),
  KEY `metric_label_IDX` (`label`) USING BTREE,
  KEY `metric_data_type_id_IDX` (`data_type_id`) USING BTREE,
  KEY `metric_business_label_IDX` (`business_label`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for mission_push_rule_detail
-- ----------------------------
DROP TABLE IF EXISTS `mission_push_rule_detail`;
CREATE TABLE `mission_push_rule_detail` (
  `id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_push_rule_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'TagPushRule表id',
  `push_content_type` tinyint NOT NULL COMMENT '推送内容类型1:评估量表 2:宣教',
  `push_content` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '推送内容（宣教id、表单id）',
  `push_content_detail` text COLLATE utf8mb4_unicode_ci,
  `mission_range_type` tinyint NOT NULL DEFAULT '1' COMMENT '任务次数，1=全部任务，2=首次任务，3=末次任务',
  `sort_no` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建人',
  `update_by` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `form_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `child_question_id_map` text COLLATE utf8mb4_unicode_ci,
  `hosp_code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机构代码',
  `product_goods_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '产品/商品id',
  `product_goods_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '产品/商品 名称',
  `product_goods_sort_no` tinyint DEFAULT NULL COMMENT '产品/商品 推荐顺序',
  `push_channel` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '推送渠道3:企微私聊',
  `mission_executor_type` tinyint DEFAULT NULL COMMENT '任务对象,1:个管 2：医生 3:护士',
  `patient_team_id` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '患者分组（多层 逗号隔开）',
  `manager_user_ids` varchar(320) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '患者管理人员（多个 逗号隔开）',
  PRIMARY KEY (`id`),
  KEY `idx_tag_push` (`tag_push_rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签推送规则详情表';

-- ----------------------------
-- Table structure for mission_push_rule_detail_1
-- ----------------------------
DROP TABLE IF EXISTS `mission_push_rule_detail_1`;
CREATE TABLE `mission_push_rule_detail_1` (
  `id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_push_rule_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'TagPushRule表id',
  `push_content_type` tinyint NOT NULL COMMENT '推送内容类型1:评估量表 2:宣教',
  `push_content` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '推送内容（宣教id、表单id）',
  `push_content_detail` text COLLATE utf8mb4_unicode_ci,
  `mission_range_type` tinyint NOT NULL DEFAULT '1' COMMENT '任务次数，1=全部任务，2=首次任务，3=末次任务',
  `sort_no` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建人',
  `update_by` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `form_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `child_question_id_map` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_tag_push` (`tag_push_rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签推送规则详情表';

-- ----------------------------
-- Table structure for mobile_certification
-- ----------------------------
DROP TABLE IF EXISTS `mobile_certification`;
CREATE TABLE `mobile_certification` (
  `id` bigint NOT NULL,
  `mobile_no` varchar(20) NOT NULL COMMENT '手机号',
  `is_certificate` tinyint unsigned NOT NULL COMMENT '认证状态1是0否',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `mobile_certification_mobile_no_IDX` (`mobile_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for page_fields
-- ----------------------------
DROP TABLE IF EXISTS `page_fields`;
CREATE TABLE `page_fields` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `editor` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户',
  `fields` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '列表页面展示字段名称（多个逗号分隔）',
  `list_type` tinyint NOT NULL COMMENT '列表页面 1-数据元 2-其他',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for pat_examine_data
-- ----------------------------
DROP TABLE IF EXISTS `pat_examine_data`;
CREATE TABLE `pat_examine_data` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `relate_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'record表relateId(同次提交唯一健)',
  `pat_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'patId',
  `pay_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'payId',
  `type` tinyint(1) NOT NULL COMMENT '类型 1-肝功能 2-血脂',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='患者检验数据记录表';

-- ----------------------------
-- Table structure for pat_notice_status
-- ----------------------------
DROP TABLE IF EXISTS `pat_notice_status`;
CREATE TABLE `pat_notice_status` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `notice_status` tinyint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `editor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for patient
-- ----------------------------
DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient` (
  `id` bigint NOT NULL COMMENT '主键',
  `id_card` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证件号',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `patient_id_card_IDX` (`id_card`) USING BTREE,
  KEY `patient_mobile_IDX` (`mobile`) USING BTREE,
  KEY `patient_name_IDX` (`name`) USING BTREE,
  KEY `patient_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for patient_activity_points
-- ----------------------------
DROP TABLE IF EXISTS `patient_activity_points`;
CREATE TABLE `patient_activity_points` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `total_points` int DEFAULT '0' COMMENT '总积分',
  `available_points` int DEFAULT '0' COMMENT '可使用的积分',
  `used_points` int DEFAULT '0' COMMENT '已被使用的积分',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `editor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='活动积分表';

-- ----------------------------
-- Table structure for patient_activity_points_log
-- ----------------------------
DROP TABLE IF EXISTS `patient_activity_points_log`;
CREATE TABLE `patient_activity_points_log` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `change_points` int DEFAULT '0' COMMENT '变化积分',
  `pre_change_points` int DEFAULT '0' COMMENT '变化前积分',
  `post_change_points` int DEFAULT '0' COMMENT '变化后积分',
  `event_desc` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '事件描述',
  `event_type` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '类型',
  `change_points_type` tinyint(1) DEFAULT NULL COMMENT '积分类型 0-减少 1-增加',
  `create_time` datetime DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT '0',
  `editor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='活动积分日志表';

-- ----------------------------
-- Table structure for patient_bind
-- ----------------------------
DROP TABLE IF EXISTS `patient_bind`;
CREATE TABLE `patient_bind` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '患者来源 1/服务系统 2/小程序',
  `access_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问token',
  `refresh_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '刷新token',
  `expire_time` datetime NOT NULL COMMENT 'token过期时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '删除标志：0-未删除，1-删除',
  PRIMARY KEY (`id`),
  KEY `patient_bind_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `patient_bind_mobile_IDX` (`mobile`) USING BTREE,
  KEY `patient_bind_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `patient_bind_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for patient_copy1
-- ----------------------------
DROP TABLE IF EXISTS `patient_copy1`;
CREATE TABLE `patient_copy1` (
  `id` bigint NOT NULL COMMENT '主键',
  `id_card` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证件号',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `patient_id_card_IDX` (`id_card`) USING BTREE,
  KEY `patient_mobile_IDX` (`mobile`) USING BTREE,
  KEY `patient_name_IDX` (`name`) USING BTREE,
  KEY `patient_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for patient_id_mapping
-- ----------------------------
DROP TABLE IF EXISTS `patient_id_mapping`;
CREATE TABLE `patient_id_mapping` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source_type` tinyint NOT NULL COMMENT '患者来源 1/服务系统 2/小程序',
  `id_card` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '证件号',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `hosp_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '医院编码',
  `business_json` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务json',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `patient_id_mapping_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `patient_id_mapping_id_card_IDX` (`id_card`) USING BTREE,
  KEY `patient_id_mapping_mobile_IDX` (`mobile`) USING BTREE,
  KEY `patient_id_mapping_name_IDX` (`name`) USING BTREE,
  KEY `patient_id_mapping_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for patient_id_mapping_copy1
-- ----------------------------
DROP TABLE IF EXISTS `patient_id_mapping_copy1`;
CREATE TABLE `patient_id_mapping_copy1` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '患者来源 1/服务系统 2/小程序',
  `id_card` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '证件号',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `hosp_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '医院编码',
  `business_json` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务json',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `patient_id_mapping_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `patient_id_mapping_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `patient_id_mapping_id_card_IDX` (`id_card`) USING BTREE,
  KEY `patient_id_mapping_mobile_IDX` (`mobile`) USING BTREE,
  KEY `patient_id_mapping_name_IDX` (`name`) USING BTREE,
  KEY `patient_id_mapping_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for patient_id_mapping_copy2
-- ----------------------------
DROP TABLE IF EXISTS `patient_id_mapping_copy2`;
CREATE TABLE `patient_id_mapping_copy2` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '患者来源 1/服务系统 2/小程序',
  `id_card` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '证件号',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `hosp_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '医院编码',
  `business_json` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务json',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `patient_id_mapping_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `patient_id_mapping_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `patient_id_mapping_id_card_IDX` (`id_card`) USING BTREE,
  KEY `patient_id_mapping_mobile_IDX` (`mobile`) USING BTREE,
  KEY `patient_id_mapping_name_IDX` (`name`) USING BTREE,
  KEY `patient_id_mapping_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for patient_tag_record
-- ----------------------------
DROP TABLE IF EXISTS `patient_tag_record`;
CREATE TABLE `patient_tag_record` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pat_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签代码',
  `tag_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签代码',
  `tag_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `create_by` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `dict_tag_group_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签分组表id dictTagGroup表id',
  `date_type` tinyint(1) DEFAULT NULL COMMENT '数据类型 1 文本 2 数值 3 布尔 4 日期 5 枚举 ',
  `object_type` int DEFAULT NULL COMMENT '对象属性',
  PRIMARY KEY (`id`),
  KEY `idx_pat_tag` (`pat_id`,`tag_code`,`dict_tag_group_id`,`is_delete`) USING BTREE,
  KEY `patient_tag_record_tag_code_IDX` (`tag_code`,`is_delete`,`dict_tag_group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='患者标签表';

-- ----------------------------
-- Table structure for patient_tag_record_for_hive
-- ----------------------------
DROP TABLE IF EXISTS `patient_tag_record_for_hive`;
CREATE TABLE `patient_tag_record_for_hive` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pat_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签代码',
  `tag_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签代码',
  `tag_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名称',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'hive计算' COMMENT '创建人',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'hive计算' COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `dict_tag_group_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签分组表id dictTagGroup表id',
  `date_type` tinyint(1) NOT NULL COMMENT '标签类型',
  PRIMARY KEY (`id`),
  KEY `hive_idx` (`pat_id`,`tag_code`,`dict_tag_group_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=845087 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='患者标签表hive';

-- ----------------------------
-- Table structure for pay_tag_rule_relation
-- ----------------------------
DROP TABLE IF EXISTS `pay_tag_rule_relation`;
CREATE TABLE `pay_tag_rule_relation` (
  `id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_rule_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '推送规则id',
  `mission_tag_rule_detail_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'mission_push_rule_detail表id',
  `pay_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '开单id',
  `pat_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '患者id',
  `push_content` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表单id',
  `push_content_detail` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表单问题id, ","隔开',
  `mission_range_type` tinyint NOT NULL DEFAULT '1' COMMENT '任务次数，1=全部任务，2=首次任务，3=末次任务',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_tag` (`tag_rule_id`),
  KEY `idx_tag_detail` (`mission_tag_rule_detail_id`),
  KEY `idx_pay` (`pay_id`),
  KEY `idx_pat` (`pat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收案开单和推送规则关联表';

-- ----------------------------
-- Table structure for sleep_metric_record
-- ----------------------------
DROP TABLE IF EXISTS `sleep_metric_record`;
CREATE TABLE `sleep_metric_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` json NOT NULL COMMENT '数据值-json',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `pay_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  `device_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `string_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `string_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `string_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `string_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `string_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `string_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `string_metric_record_update_time_IDX` (`update_time`) USING BTREE,
  KEY `inx_pat_label` (`pat_id`,`business_label`,`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for sms_record
-- ----------------------------
DROP TABLE IF EXISTS `sms_record`;
CREATE TABLE `sms_record` (
  `id` bigint NOT NULL,
  `mobile_no` varchar(20) NOT NULL COMMENT '手机号',
  `content` varchar(50) NOT NULL COMMENT '短信内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `sms_record_mobile_no_IDX` (`mobile_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for step_metric_record
-- ----------------------------
DROP TABLE IF EXISTS `step_metric_record`;
CREATE TABLE `step_metric_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` json NOT NULL COMMENT '数据值-json',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `pay_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `string_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `string_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `string_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `string_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `string_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `string_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `string_metric_record_update_time_IDX` (`update_time`) USING BTREE,
  KEY `inx_pat_label` (`pat_id`,`business_label`,`record_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for string_metric_record
-- ----------------------------
DROP TABLE IF EXISTS `string_metric_record`;
CREATE TABLE `string_metric_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `source_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源id',
  `source_type` tinyint NOT NULL COMMENT '来源 场景',
  `business_label` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务指标标签',
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据值-字符串',
  `unit` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '单位',
  `relate_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联id',
  `operator_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人id',
  `record_time` datetime NOT NULL COMMENT '记录时间，没上报默认为创建时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  `pay_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '开单id',
  `business_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务id',
  PRIMARY KEY (`id`),
  KEY `string_metric_record_pat_id_IDX` (`pat_id`) USING BTREE,
  KEY `string_metric_record_source_id_IDX` (`source_id`,`source_type`) USING BTREE,
  KEY `string_metric_record_metric_id_IDX` (`business_label`) USING BTREE,
  KEY `string_metric_record_relate_id_IDX` (`relate_id`) USING BTREE,
  KEY `string_metric_record_operator_id_IDX` (`operator_id`) USING BTREE,
  KEY `string_metric_record_record_time_IDX` (`record_time`) USING BTREE,
  KEY `string_metric_record_update_time_IDX` (`update_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for t_user_device
-- ----------------------------
DROP TABLE IF EXISTS `t_user_device`;
CREATE TABLE `t_user_device` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hug_id` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `device_id` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `login_status` tinyint DEFAULT NULL COMMENT '1:登录中 0:未登录',
  `update_time` datetime DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for t_user_patient_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_user_patient_relation`;
CREATE TABLE `t_user_patient_relation` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pat_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hosp_code` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pay_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `empi_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_delete` tinyint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `t_user_patient_relation_user_id_IDX` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户和管理患者关系表';

-- ----------------------------
-- Table structure for tag_push_rule
-- ----------------------------
DROP TABLE IF EXISTS `tag_push_rule`;
CREATE TABLE `tag_push_rule` (
  `id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rule_name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则名称',
  `pat_group_ids` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户群体表id列表，逗号分隔',
  `is_open` tinyint(1) DEFAULT '0' COMMENT '是否开启，0：关闭，1：开启',
  `push_freq_type` tinyint NOT NULL COMMENT '推送时间类型(1：即刻推送 2：时间点推送)',
  `push_time` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '推送时间(HH:mm:ss)',
  `push_freq` tinyint(1) DEFAULT NULL COMMENT '推送频次(1：仅发一次 2：每天)',
  `create_by` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建人',
  `update_by` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `mission_push_freq_type` tinyint NOT NULL DEFAULT '1' COMMENT '推送时间， 1=立即推送',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签推送规则表';

-- ----------------------------
-- Table structure for tag_push_rule_detail
-- ----------------------------
DROP TABLE IF EXISTS `tag_push_rule_detail`;
CREATE TABLE `tag_push_rule_detail` (
  `id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_push_rule_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'TagPushRule表id',
  `push_content_type` tinyint NOT NULL COMMENT '推送内容类型1:评估量表 2:宣教',
  `push_content` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '推送内容（宣教id、表单id）',
  `push_content_detail` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '推送内容详情(宣教标题、表单标题)',
  `edu_label_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '宣教标签名称，一级名称/二级名称',
  `edu_label_code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '宣教标签，一级标签/二级标签',
  `push_channel` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '推送渠道1:短信 2:公众号,多选以逗号分隔',
  `sort_no` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建人',
  `update_by` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `msg_signature_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '签名id',
  `message_template_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '消息模板Id',
  `apply_corp_ids` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '适用企业(企微)单选',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签推送规则详情表';

-- ----------------------------
-- Table structure for task_push_record
-- ----------------------------
DROP TABLE IF EXISTS `task_push_record`;
CREATE TABLE `task_push_record` (
  `id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pat_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '数据中心patId',
  `empi_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '健管云empiId',
  `hosp_code` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机构代码',
  `hug_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '蓝牛号',
  `push_content_type` tinyint(1) NOT NULL COMMENT '推送内容类型 1:表单 2:宣教',
  `task_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '推送任务id',
  `tag_push_rule_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则id',
  `tag_push_rule_detail_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则详情id',
  `push_content` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '知识库表单/宣教id',
  `push_content_detail` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '知识库表单/宣教标题',
  `push_channel` tinyint(1) NOT NULL COMMENT '推送渠道1:短信 2:公众号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `receive_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '接收手机号',
  `push_status` tinyint DEFAULT NULL COMMENT '推送状态 -1:推送失败 0:推送成功',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务推送记录表';

-- ----------------------------
-- Table structure for user_tag_collection
-- ----------------------------
DROP TABLE IF EXISTS `user_tag_collection`;
CREATE TABLE `user_tag_collection` (
  `id` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `name` varchar(35) NOT NULL COMMENT '名称',
  `condition_count` int NOT NULL DEFAULT '0' COMMENT '任务',
  `count_update_time` datetime NOT NULL COMMENT '任务更新时间',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `tag_rule_json` varchar(2048) NOT NULL COMMENT '规则jsonString',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_by` varchar(35) NOT NULL COMMENT '创建人',
  `create_id` varchar(35) NOT NULL COMMENT '创建id',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_by` varchar(35) NOT NULL COMMENT '更新人',
  `update_id` varchar(35) NOT NULL COMMENT '更新人id',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `limit_user_tag_collection_ids` varchar(255) DEFAULT NULL COMMENT '限定分群，逗号隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for xxl_job_record
-- ----------------------------
DROP TABLE IF EXISTS `xxl_job_record`;
CREATE TABLE `xxl_job_record` (
  `id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_push_rule_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tag_push_rule表id',
  `job_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务id',
  `job_desc` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务描述',
  `cron` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'cron表达式',
  `handler` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'handler',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='xxlJob任务记录表';

SET FOREIGN_KEY_CHECKS = 1;
