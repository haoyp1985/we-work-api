/*
 Navicat MySQL Data Transfer

 Source Server         : 健海测试-3.212
 Source Server Type    : MySQL
 Source Server Version : 80028
 Source Host           : 192.168.3.212:3306
 Source Schema         : knowledge_test

 Target Server Type    : MySQL
 Target Server Version : 80028
 File Encoding         : 65001

 Date: 17/07/2025 11:06:36
*/

SET NAMES utf8mb3;
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
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) NOT NULL,
  `MD5SUM` varchar(35) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `COMMENTS` varchar(255) DEFAULT NULL,
  `TAG` varchar(255) DEFAULT NULL,
  `LIQUIBASE` varchar(20) DEFAULT NULL,
  `CONTEXTS` varchar(255) DEFAULT NULL,
  `LABELS` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for DATABASECHANGELOGLOCK
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for Sheet1
-- ----------------------------
DROP TABLE IF EXISTS `Sheet1`;
CREATE TABLE `Sheet1` (
  `id` varchar(255) DEFAULT NULL,
  `data_type` varchar(255) DEFAULT NULL,
  `course_id` varchar(255) DEFAULT NULL,
  `course_name` varchar(255) DEFAULT NULL,
  `course_content` varchar(255) DEFAULT NULL,
  `course_preview_url` varchar(255) DEFAULT NULL,
  `course_source` varchar(255) DEFAULT NULL,
  `hosp_code` varchar(255) DEFAULT NULL,
  `category_id` varchar(255) DEFAULT NULL,
  `category_name` varchar(255) DEFAULT NULL,
  `label_codes` varchar(255) DEFAULT NULL,
  `label_names` varchar(255) DEFAULT NULL,
  `diag_codes` varchar(255) DEFAULT NULL,
  `diag_names` varchar(255) DEFAULT NULL,
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(255) DEFAULT NULL,
  `editor_id` varchar(255) DEFAULT NULL,
  `editor_name` varchar(255) DEFAULT NULL,
  `create_time` varchar(255) DEFAULT NULL,
  `update_time` varchar(255) DEFAULT NULL,
  `is_delete` varchar(255) DEFAULT NULL,
  `process_type` varchar(255) DEFAULT NULL,
  `recommended` varchar(255) DEFAULT NULL,
  `suitable_codes` varchar(255) DEFAULT NULL,
  `suitable_names` varchar(255) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `quote_edu_id` varchar(255) DEFAULT NULL,
  `key_words` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for aaaa
-- ----------------------------
DROP TABLE IF EXISTS `aaaa`;
CREATE TABLE `aaaa` (
  `id` varchar(255) DEFAULT NULL,
  `is_enable` int DEFAULT NULL,
  `is_delete` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for archive
-- ----------------------------
DROP TABLE IF EXISTS `archive`;
CREATE TABLE `archive` (
  `id` varchar(32) NOT NULL,
  `archive_id` varchar(32) DEFAULT NULL COMMENT '档案id',
  `name` varchar(50) DEFAULT NULL COMMENT '档案名称',
  `content_desc` varchar(200) DEFAULT NULL COMMENT '描述',
  `label_codes` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '疾病编码多个用逗号隔开',
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_names` varchar(500) DEFAULT NULL COMMENT '疾病名称多个用逗号隔开',
  `permission_codes` varchar(50) DEFAULT NULL COMMENT '权限codes 1：病史信息，2：生活方式；3：指标数据',
  `version` decimal(7,1) NOT NULL COMMENT '版本',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `dept_codes` varchar(200) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for article_contents
-- ----------------------------
DROP TABLE IF EXISTS `article_contents`;
CREATE TABLE `article_contents` (
  `id` varchar(32) NOT NULL,
  `content_name` varchar(64) NOT NULL COMMENT '内容名称',
  `article_content` longtext COMMENT '编辑内容',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `cover_url` varchar(200) DEFAULT NULL COMMENT '封面图',
  `content_preview_url` varchar(200) DEFAULT NULL COMMENT '内容预览的url(外网可访问)',
  `author_id` varchar(64) DEFAULT NULL COMMENT '创建人id',
  `author_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `editor_id` varchar(64) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(64) DEFAULT NULL COMMENT '编辑人名称',
  `department_type` tinyint(1) NOT NULL COMMENT '部门，1：市场部门 2：运营部门',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='135内容编辑';

-- ----------------------------
-- Table structure for case_visit_info
-- ----------------------------
DROP TABLE IF EXISTS `case_visit_info`;
CREATE TABLE `case_visit_info` (
  `serial_no` varchar(32) NOT NULL COMMENT '模拟门诊流水号',
  `case_id` varchar(32) DEFAULT NULL COMMENT '模拟患者案例主键',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊时间',
  `visit_dept_code` varchar(50) DEFAULT NULL COMMENT '就诊科室代码',
  `visit_dept_name` varchar(50) DEFAULT NULL COMMENT '就诊科室名称',
  `surgery_json` varchar(1000) DEFAULT NULL,
  `examine_json` varchar(2000) DEFAULT NULL,
  `check_json` varchar(2000) DEFAULT NULL,
  `drug_json` varchar(1000) DEFAULT NULL,
  `diagnosis_json` varchar(1000) DEFAULT NULL,
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期时间',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `flag` int DEFAULT NULL COMMENT '1:门诊 2：出入院',
  PRIMARY KEY (`serial_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for check_library
-- ----------------------------
DROP TABLE IF EXISTS `check_library`;
CREATE TABLE `check_library` (
  `id` varchar(32) NOT NULL,
  `code` varchar(20) DEFAULT '' COMMENT '编码',
  `name` varchar(100) DEFAULT NULL COMMENT '名称',
  `additional_code` varchar(50) DEFAULT NULL COMMENT '附加名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `relation_type` int DEFAULT NULL COMMENT '1:适用于智宣教',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for check_library_h
-- ----------------------------
DROP TABLE IF EXISTS `check_library_h`;
CREATE TABLE `check_library_h` (
  `id` varchar(32) NOT NULL,
  `code` varchar(20) DEFAULT '' COMMENT '编码',
  `name` varchar(50) DEFAULT NULL,
  `additional_code` varchar(50) DEFAULT NULL COMMENT '附加名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `editor_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`,`hosp_code`) USING BTREE,
  KEY `idx_check_name_h` (`name`) USING BTREE,
  KEY `idx_check_code_h` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- ----------------------------
-- Table structure for check_library_map
-- ----------------------------
DROP TABLE IF EXISTS `check_library_map`;
CREATE TABLE `check_library_map` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` text,
  `hosp_check_code` text,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_check_map` (`std_id`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for check_library_map_revert
-- ----------------------------
DROP TABLE IF EXISTS `check_library_map_revert`;
CREATE TABLE `check_library_map_revert` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` varchar(100) DEFAULT NULL,
  `hosp_check_code` varchar(100) DEFAULT NULL,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_check_map` (`std_id`,`hosp_code`,`hosp_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for cloud_followup_mission
-- ----------------------------
DROP TABLE IF EXISTS `cloud_followup_mission`;
CREATE TABLE `cloud_followup_mission` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '计划ID(计划表主键)',
  `plan_name` varchar(200) DEFAULT NULL COMMENT '计划名称',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `patient_id` varchar(32) DEFAULT NULL COMMENT '随访传递患者信息主键id',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_unique_id` varchar(2000) DEFAULT NULL COMMENT '患者头数据主键Id',
  `serial_no` varchar(2000) DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `prescription_id` varchar(2000) DEFAULT NULL COMMENT '处方ID',
  `prescription_desc` varchar(1000) DEFAULT NULL COMMENT '处方描述',
  `therapy_stage_code` varchar(300) DEFAULT NULL COMMENT '治疗阶段代码',
  `therapy_stage_name` varchar(300) DEFAULT NULL COMMENT '治疗阶段名称',
  `therapy_stage_begin_time` datetime DEFAULT NULL COMMENT '疾病阶段开始时间',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联上传患者列表ID',
  `relation_type` int DEFAULT NULL COMMENT '关联上传患者列表类型(1专科随访  2患者管理  3慢病随访  4慢病管理  5随访抽查)',
  `relation_type_name` varchar(50) DEFAULT NULL COMMENT '关联类型名称',
  `remind_type` varchar(10) DEFAULT '1' COMMENT '宣教/提醒对象类型(1.患者 2.医生 3.健康管理师)',
  `reminder_type_name` varchar(10) DEFAULT '1' COMMENT '宣教/提醒对象名称',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒时间',
  `revisit_plan_date` varchar(50) DEFAULT NULL COMMENT '计划随访/宣教/提醒发送日期',
  `revisit_plan_hour` varchar(200) DEFAULT NULL COMMENT '计划随访/宣教/提醒发送时间点，多个时间点逗号分隔拼接',
  `revisit_plan_end_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒截止时间',
  `form_id` varchar(1000) DEFAULT NULL COMMENT '表单id(此id与contentId不同,contentId为表单主键id)',
  `content_id` varchar(1000) DEFAULT NULL COMMENT '关联随访/宣教/提醒ID(","分隔，上限10个)',
  `content_title` varchar(500) DEFAULT NULL COMMENT '关联随访/宣教/提醒标题(","分隔，上限10个)',
  `form_title_ids` text COMMENT '下发给AI的表单题目id列表',
  `is_directSend` int DEFAULT '0' COMMENT '是否直接发送(0,否  1,是)',
  `task_prop` int DEFAULT NULL COMMENT '任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `mission_time_type` int DEFAULT NULL COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `mission_time_type_name` varchar(10) DEFAULT NULL COMMENT '任务时间类型名称',
  `mission_type` int DEFAULT NULL COMMENT '任务类型(宣教: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒)',
  `mission_type_name` varchar(10) DEFAULT NULL COMMENT '任务类型名称',
  `content` longtext COMMENT '宣教/提醒/随访内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_circulation` int DEFAULT NULL COMMENT '循环判断 1:循环 0:不循环',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否被删除标志位 1:是 0:否',
  `is_success` tinyint(1) DEFAULT '1' COMMENT '是否下发随访成功标志位 默认成功下发异常会更改为失败',
  `delete_reason` varchar(50) DEFAULT NULL COMMENT '被删除原因',
  `app_send_status` tinyint(1) DEFAULT '0' COMMENT 'APP发送状态',
  `app_send_time` timestamp DEFAULT NULL COMMENT 'APP发送时间',
  `app_reply_status` tinyint(1) DEFAULT '0' COMMENT 'APP回复状态',
  `app_reply_time` timestamp DEFAULT NULL COMMENT 'APP回复时间',
  `ai_push_status` tinyint(1) DEFAULT '0' COMMENT 'AI推送状态',
  `ai_push_time` timestamp DEFAULT NULL COMMENT 'AI推送时间',
  `ai_reply_status` tinyint(1) DEFAULT '0' COMMENT 'AI回复状态',
  `ai_reply_time` timestamp DEFAULT NULL COMMENT 'AI回复时间',
  `revisit_result` int DEFAULT '0' COMMENT '随访结果(0:未完成 1:已完成 2:已结案)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='云端知识库任务表';

-- ----------------------------
-- Table structure for cloud_followup_mission-b
-- ----------------------------
DROP TABLE IF EXISTS `cloud_followup_mission-b`;
CREATE TABLE `cloud_followup_mission-b` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) DEFAULT '' COMMENT '机构代码',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '计划ID(计划表主键)',
  `plan_name` varchar(200) DEFAULT NULL COMMENT '计划名称',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `serial_no` varchar(50) DEFAULT NULL COMMENT '业务流水号(门诊流水号/住院流水号/体检报告单号/签约用就诊卡号)',
  `prescription_id` varchar(32) DEFAULT NULL COMMENT '处方ID',
  `is_circulation` int DEFAULT NULL COMMENT '循环判断 1:循环 0:不循环',
  `is_delete` int DEFAULT '0' COMMENT '是否被删除标志位 1:是 0:否',
  `delete_reason` varchar(50) DEFAULT NULL COMMENT '被删除原因',
  `patient_unique_id` varchar(32) DEFAULT NULL COMMENT '患者独特ID',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联上传患者列表ID',
  `relation_type` int DEFAULT NULL COMMENT '关联上传患者列表类型(1专科随访  2患者管理  3慢病随访  4慢病管理  5随访抽查)',
  `relation_type_name` varchar(50) DEFAULT NULL COMMENT '关联类型名称',
  `revisit_plan_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒时间',
  `revisit_plan_end_time` datetime DEFAULT NULL COMMENT '计划随访/宣教/提醒截止时间',
  `content_id` varchar(350) DEFAULT NULL COMMENT '关联随访/宣教/提醒ID(","分隔，上限10个)',
  `content_title` varchar(500) DEFAULT NULL COMMENT '关联随访/宣教/提醒标题(","分隔，上限10个)',
  `mission_prop` int DEFAULT NULL COMMENT '任务属性(1, 随访任务;2, 宣教任务,3, 提醒任务)',
  `mission_time_type` int DEFAULT NULL COMMENT '随访/提醒类型(1.普通任务(提醒) 2.定时任务(提醒) 3.阶段性任务 4.周期性任务)',
  `mission_time_type_name` varchar(10) DEFAULT NULL COMMENT '任务时间类型名称',
  `mission_type` int DEFAULT NULL COMMENT '任务类型(宣教: 201 普通宣教, 202 疾病宣教, 203 药品宣教, 204 检查宣教, 205 检验宣教; 提醒: 301 用药提醒, 302 复诊提醒, 303 检查提醒, 304 检验提醒, 305 体检提醒, 306 其他提醒)',
  `mission_type_name` varchar(10) DEFAULT NULL COMMENT '任务类型名称',
  `content` longtext COMMENT '宣教/提醒/随访内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='云端知识库任务表';

-- ----------------------------
-- Table structure for common_education
-- ----------------------------
DROP TABLE IF EXISTS `common_education`;
CREATE TABLE `common_education` (
  `id` varchar(32) NOT NULL,
  `data_type` tinyint(1) NOT NULL COMMENT '数据类型，1：基础库，2：医院库',
  `course_id` varchar(32) DEFAULT NULL COMMENT '课程id',
  `course_name` varchar(128) DEFAULT NULL COMMENT '宣教名称',
  `course_content` longtext COMMENT '宣教内容',
  `course_preview_url` varchar(1024) DEFAULT NULL COMMENT '宣教预览的url(外网可访问)',
  `course_source` tinyint(1) DEFAULT NULL COMMENT '来源，1:317护',
  `hosp_code` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '医院编码',
  `category_id` varchar(32) DEFAULT NULL COMMENT '分类id',
  `category_name` varchar(32) DEFAULT NULL COMMENT '分类名称',
  `label_codes` varchar(200) DEFAULT NULL COMMENT '标签',
  `label_names` varchar(200) DEFAULT NULL COMMENT '标签名称',
  `diag_codes` varchar(256) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(512) DEFAULT NULL COMMENT '关联疾病名称',
  `dept_codes` varchar(256) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(1024) DEFAULT NULL COMMENT '科室名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(256) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `process_type` varchar(128) DEFAULT NULL COMMENT '流程类型，1：门诊流程，2：入院准备流程，3：住院流程',
  `recommended` int DEFAULT NULL COMMENT '推荐指数',
  `suitable_codes` varchar(255) DEFAULT NULL COMMENT '适用对象编码',
  `suitable_names` varchar(255) DEFAULT NULL COMMENT '适用对象名称',
  `content_type` int DEFAULT NULL COMMENT '内容类型 1：编辑器  2纯文字短信',
  `quote_edu_id` varchar(32) DEFAULT NULL COMMENT '引用公共宣教id',
  `key_words` varchar(255) DEFAULT NULL COMMENT '关键词（逗号隔开）',
  `reviewer_id` varchar(32) DEFAULT NULL COMMENT '审核人id',
  `reviewer_name` varchar(256) DEFAULT NULL COMMENT '审核人名称',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `voice_url` varchar(512) DEFAULT NULL COMMENT '音频链接',
  `cover_picture` varchar(128) DEFAULT NULL COMMENT '封面图',
  `area_code` varchar(32) DEFAULT NULL COMMENT '院区编码',
  `area_name` varchar(128) DEFAULT NULL COMMENT '院区名称',
  `article_type` int DEFAULT NULL COMMENT '文章分类 1用药 2运动 3饮食 4心理 5护理 6其它',
  `with_questionnaire` tinyint DEFAULT NULL COMMENT '是否附带问卷 0否  1是',
  `is_update_course_content` int DEFAULT NULL COMMENT '是否外链处理',
  PRIMARY KEY (`id`),
  KEY `category_id_index` (`category_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='是否外链处理';

-- ----------------------------
-- Table structure for common_education_copy1
-- ----------------------------
DROP TABLE IF EXISTS `common_education_copy1`;
CREATE TABLE `common_education_copy1` (
  `id` varchar(32) NOT NULL,
  `data_type` tinyint(1) NOT NULL COMMENT '数据类型，1：基础库，2：医院库',
  `course_id` varchar(32) DEFAULT NULL COMMENT '课程id',
  `course_name` varchar(128) DEFAULT NULL COMMENT '宣教名称',
  `course_content` longtext COMMENT '宣教内容',
  `course_preview_url` varchar(1024) DEFAULT NULL COMMENT '宣教预览的url(外网可访问)',
  `course_source` tinyint(1) DEFAULT NULL COMMENT '来源，1:317护',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `category_id` varchar(32) DEFAULT NULL COMMENT '分类id',
  `category_name` varchar(32) DEFAULT NULL COMMENT '分类名称',
  `label_codes` varchar(200) DEFAULT NULL COMMENT '标签',
  `label_names` varchar(200) DEFAULT NULL COMMENT '标签名称',
  `diag_codes` varchar(256) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(512) DEFAULT NULL COMMENT '关联疾病名称',
  `dept_codes` varchar(256) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(1024) DEFAULT NULL COMMENT '科室名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(256) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `process_type` varchar(128) DEFAULT NULL COMMENT '流程类型，1：门诊流程，2：入院准备流程，3：住院流程',
  `recommended` int DEFAULT NULL COMMENT '推荐指数',
  `suitable_codes` varchar(255) DEFAULT NULL COMMENT '适用对象编码',
  `suitable_names` varchar(255) DEFAULT NULL COMMENT '适用对象名称',
  `content_type` int DEFAULT NULL COMMENT '内容类型 1：编辑器  2纯文字短信',
  `quote_edu_id` varchar(32) DEFAULT NULL COMMENT '引用公共宣教id',
  `key_words` varchar(255) DEFAULT NULL COMMENT '关键词（逗号隔开）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教表';

-- ----------------------------
-- Table structure for common_education_form
-- ----------------------------
DROP TABLE IF EXISTS `common_education_form`;
CREATE TABLE `common_education_form` (
  `id` varchar(32) NOT NULL,
  `title` varchar(32) DEFAULT NULL COMMENT '标题',
  `opening_words` varchar(100) DEFAULT NULL COMMENT '开头语',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '宣教关联ID',
  `enable` int DEFAULT NULL COMMENT '是否启动  0否 1是',
  `unpass_remind` int DEFAULT NULL COMMENT '未达标提醒 0不提醒 1提醒',
  `pass_score` varchar(32) DEFAULT NULL COMMENT '及格分分数线',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='宣教表单表';

-- ----------------------------
-- Table structure for common_education_options
-- ----------------------------
DROP TABLE IF EXISTS `common_education_options`;
CREATE TABLE `common_education_options` (
  `id` varchar(32) NOT NULL,
  `option_name` varchar(100) DEFAULT NULL COMMENT '选项名称',
  `question_id` varchar(32) DEFAULT NULL COMMENT '问卷题目关联ID',
  `is_corrected` tinyint DEFAULT NULL COMMENT '选项是否正确 0错误 1正确',
  `option_order` int DEFAULT NULL COMMENT '选项顺序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='宣教问卷题目选项表';

-- ----------------------------
-- Table structure for common_education_questionnaire
-- ----------------------------
DROP TABLE IF EXISTS `common_education_questionnaire`;
CREATE TABLE `common_education_questionnaire` (
  `id` varchar(32) NOT NULL,
  `question_name` varchar(100) DEFAULT NULL COMMENT '题目名称',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '宣教关联ID',
  `type` tinyint DEFAULT NULL COMMENT '题目类型 1单选  2多选',
  `question_order` int DEFAULT NULL COMMENT '题目顺序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='宣教问卷题目表';

-- ----------------------------
-- Table structure for common_education_review
-- ----------------------------
DROP TABLE IF EXISTS `common_education_review`;
CREATE TABLE `common_education_review` (
  `id` varchar(32) NOT NULL,
  `data_type` tinyint(1) NOT NULL COMMENT '数据类型，1：基础库，2：医院库',
  `course_id` varchar(32) DEFAULT NULL COMMENT '课程id',
  `course_name` varchar(128) DEFAULT NULL COMMENT '宣教名称',
  `course_content` longtext COMMENT '宣教内容',
  `course_preview_url` varchar(1024) DEFAULT NULL COMMENT '宣教预览的url(外网可访问)',
  `course_source` tinyint(1) DEFAULT NULL COMMENT '来源，1:317护',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `category_id` varchar(32) DEFAULT NULL COMMENT '分类id',
  `category_name` varchar(32) DEFAULT NULL COMMENT '分类名称',
  `label_codes` varchar(200) DEFAULT NULL COMMENT '标签',
  `label_names` varchar(200) DEFAULT NULL COMMENT '标签名称',
  `diag_codes` varchar(256) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(512) DEFAULT NULL COMMENT '关联疾病名称',
  `dept_codes` varchar(256) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(1024) DEFAULT NULL COMMENT '科室名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(256) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `process_type` varchar(128) DEFAULT NULL COMMENT '流程类型，1：门诊流程，2：入院准备流程，3：住院流程',
  `recommended` int DEFAULT NULL COMMENT '推荐指数',
  `suitable_codes` varchar(255) DEFAULT NULL COMMENT '适用对象编码',
  `suitable_names` varchar(255) DEFAULT NULL COMMENT '适用对象名称',
  `content_type` int DEFAULT NULL COMMENT '内容类型 1：编辑器  2纯文字短信',
  `quote_edu_id` varchar(32) DEFAULT NULL COMMENT '引用公共宣教id',
  `key_words` varchar(255) DEFAULT NULL COMMENT '关键词（逗号隔开）',
  `status` tinyint(1) DEFAULT '1' COMMENT '审核状态, 1:未提交 2:待审核 3:未通过 4:已通过',
  `reviewer_id` varchar(32) DEFAULT NULL COMMENT '审核人id',
  `reviewer_name` varchar(256) DEFAULT NULL COMMENT '审核人名称',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `un_pass_reason` varchar(256) DEFAULT NULL COMMENT '不通过原因',
  `cover_picture` varchar(128) DEFAULT NULL COMMENT '封面图',
  `article_type` int DEFAULT NULL COMMENT '文章分类 1用药 2运动 3饮食 4心理 5护理 6其它',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教审核临时表';

-- ----------------------------
-- Table structure for common_hosp_key
-- ----------------------------
DROP TABLE IF EXISTS `common_hosp_key`;
CREATE TABLE `common_hosp_key` (
  `hosp_code` varchar(200) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for common_param
-- ----------------------------
DROP TABLE IF EXISTS `common_param`;
CREATE TABLE `common_param` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `module` varchar(32) DEFAULT NULL COMMENT '模块',
  `param_name` varchar(32) DEFAULT NULL COMMENT '参数名称',
  `param_code` varchar(32) DEFAULT NULL COMMENT '参数代码',
  `value1` varchar(32) DEFAULT NULL COMMENT '值1',
  `value2` varchar(32) DEFAULT NULL COMMENT '值2',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='个性化参数';

-- ----------------------------
-- Table structure for common_scene
-- ----------------------------
DROP TABLE IF EXISTS `common_scene`;
CREATE TABLE `common_scene` (
  `id` varchar(32) NOT NULL,
  `data_type` tinyint(1) NOT NULL COMMENT '数据类型，1：基础库，2：医院库',
  `scene_name` varchar(128) DEFAULT NULL COMMENT '场景名称',
  `content_id` varchar(32) DEFAULT NULL COMMENT '项目code，包括检验，检查和疾病',
  `content_name` varchar(128) DEFAULT NULL COMMENT '项目名称',
  `hosp_code` varchar(1500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '医院编码',
  `dept_codes` varchar(256) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(512) DEFAULT NULL COMMENT '科室名称',
  `scene_type` tinyint(1) DEFAULT NULL COMMENT '场景类型，1：检验宣教，2：检查宣教，3：疾病宣教，4：流程宣教，5：预诊宣教',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(256) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `process_type` varchar(128) DEFAULT NULL COMMENT '流程类型，1：门诊流程，2：入院准备流程，3：住院流程',
  `reviewer_id` varchar(32) DEFAULT NULL COMMENT '审核人id',
  `reviewer_name` varchar(256) DEFAULT NULL COMMENT '审核人名称',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `area_code` varchar(32) DEFAULT NULL COMMENT '院区编码',
  `area_name` varchar(128) DEFAULT NULL COMMENT '院区名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教场景表';

-- ----------------------------
-- Table structure for common_scene_copy1
-- ----------------------------
DROP TABLE IF EXISTS `common_scene_copy1`;
CREATE TABLE `common_scene_copy1` (
  `id` varchar(32) NOT NULL,
  `data_type` tinyint(1) NOT NULL COMMENT '数据类型，1：基础库，2：医院库',
  `content_id` varchar(32) DEFAULT NULL COMMENT '项目code，包括检验，检查和疾病',
  `content_name` varchar(128) DEFAULT NULL COMMENT '项目名称',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `dept_codes` varchar(256) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(512) DEFAULT NULL COMMENT '科室名称',
  `scene_type` tinyint(1) DEFAULT NULL COMMENT '场景类型，1：检验宣教，2：检查宣教，3：疾病宣教，4：流程宣教，5：预诊宣教',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(256) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `process_type` varchar(128) DEFAULT NULL COMMENT '流程类型，1：门诊流程，2：入院准备流程，3：住院流程',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教场景表';

-- ----------------------------
-- Table structure for common_scene_review
-- ----------------------------
DROP TABLE IF EXISTS `common_scene_review`;
CREATE TABLE `common_scene_review` (
  `id` varchar(32) NOT NULL,
  `data_type` tinyint(1) NOT NULL COMMENT '数据类型，1：基础库，2：医院库',
  `scene_name` varchar(128) DEFAULT NULL COMMENT '场景名称',
  `content_id` varchar(32) DEFAULT NULL COMMENT '项目code，包括检验，检查和疾病',
  `content_name` varchar(128) DEFAULT NULL COMMENT '项目名称',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `dept_codes` varchar(256) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(512) DEFAULT NULL COMMENT '科室名称',
  `scene_type` tinyint(1) DEFAULT NULL COMMENT '场景类型，1：检验宣教，2：检查宣教，3：疾病宣教，4：流程宣教，5：预诊宣教',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(256) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `process_type` varchar(128) DEFAULT NULL COMMENT '流程类型，1：门诊流程，2：入院准备流程，3：住院流程',
  `status` tinyint(1) DEFAULT '1' COMMENT '审核状态, 1:未提交 2:待审核 3:未通过 4:已通过',
  `reviewer_id` varchar(32) DEFAULT NULL COMMENT '审核人id',
  `reviewer_name` varchar(256) DEFAULT NULL COMMENT '审核人名称',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `un_pass_reason` varchar(256) DEFAULT NULL COMMENT '不通过原因',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教场景临时表';

-- ----------------------------
-- Table structure for common_scene_triage_relation
-- ----------------------------
DROP TABLE IF EXISTS `common_scene_triage_relation`;
CREATE TABLE `common_scene_triage_relation` (
  `id` varchar(32) NOT NULL,
  `common_scene_id` varchar(32) DEFAULT NULL COMMENT '智宣教场景id',
  `triage_question_id` varchar(32) DEFAULT NULL COMMENT '智宣教分诊问卷id',
  `begin_time_type` tinyint(1) DEFAULT NULL COMMENT '场景类型，11：预约就诊前',
  `after_begin_time_unit` tinyint(1) DEFAULT NULL COMMENT '发送时间单位，1：分钟，2：小时，3：天',
  `after_begin_time` int DEFAULT NULL COMMENT '发送时间数值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教分诊问卷场景关联表';

-- ----------------------------
-- Table structure for common_triage_question
-- ----------------------------
DROP TABLE IF EXISTS `common_triage_question`;
CREATE TABLE `common_triage_question` (
  `id` varchar(32) NOT NULL,
  `question_title` varchar(128) DEFAULT NULL COMMENT '问卷名称',
  `question_content` text COMMENT '问卷内容',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(256) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `question_code` varchar(32) DEFAULT NULL COMMENT '问卷编码',
  `data_type` tinyint(1) DEFAULT NULL COMMENT '数据类型，1：基础库，2：医院库',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教分诊问卷表';

-- ----------------------------
-- Table structure for common_triage_result
-- ----------------------------
DROP TABLE IF EXISTS `common_triage_result`;
CREATE TABLE `common_triage_result` (
  `id` varchar(32) NOT NULL,
  `triage_question_id` varchar(32) NOT NULL COMMENT '分诊问卷id',
  `result_code` varchar(128) DEFAULT NULL COMMENT '问卷答案编码',
  `result_name` varchar(128) DEFAULT NULL COMMENT '问卷答案名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(256) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教分诊问卷结果表';

-- ----------------------------
-- Table structure for content_library
-- ----------------------------
DROP TABLE IF EXISTS `content_library`;
CREATE TABLE `content_library` (
  `id` varchar(32) NOT NULL,
  `content_code` varchar(32) DEFAULT NULL COMMENT '内容编码',
  `content_name` varchar(32) DEFAULT NULL COMMENT '内容名称',
  `parent_content_code` varchar(32) DEFAULT '0' COMMENT '上级内容编码',
  `parent_content_name` varchar(32) DEFAULT NULL COMMENT '上级内容名称',
  `level` int DEFAULT NULL COMMENT '层级',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(256) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='知识库内容分类表';

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `id` varchar(50) NOT NULL,
  `course_name` varchar(64) DEFAULT NULL COMMENT '名称',
  `course_label_code` varchar(500) DEFAULT NULL COMMENT '课程标签编码',
  `course_label_name` varchar(500) DEFAULT NULL COMMENT '课程标签名称',
  `diseases` varchar(1000) DEFAULT NULL COMMENT '疾病（层级）',
  `suit_disease_code` varchar(255) DEFAULT NULL COMMENT '适用疾病编码',
  `suit_disease_name` varchar(255) DEFAULT NULL COMMENT '适用疾病名称',
  `cover_small_url` varchar(500) DEFAULT NULL COMMENT '课程封面小图',
  `content_url` varchar(500) DEFAULT NULL COMMENT '内容地址',
  `editor_id` varchar(64) DEFAULT NULL COMMENT '创建人id',
  `editor_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `new_editor_id` varchar(64) DEFAULT NULL COMMENT '最近操作人id',
  `new_editor_name` varchar(64) DEFAULT NULL COMMENT '最近操作人名称',
  `temporary_course_id` varchar(64) DEFAULT NULL COMMENT '课程保存id',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '0:保存，1：删除，2暂存',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for course_material
-- ----------------------------
DROP TABLE IF EXISTS `course_material`;
CREATE TABLE `course_material` (
  `id` varchar(50) NOT NULL,
  `course_name` varchar(64) DEFAULT NULL COMMENT '课程名称',
  `course_id` varchar(255) DEFAULT NULL COMMENT '课程id',
  `content_name` varchar(255) DEFAULT NULL COMMENT '目录名',
  `material_id` varchar(64) DEFAULT NULL COMMENT '引用素材id',
  `coutent_type` varchar(255) DEFAULT NULL COMMENT '目录类型',
  `content_url` varchar(500) DEFAULT NULL COMMENT '目录url',
  `cover_url` varchar(255) DEFAULT NULL COMMENT '封面图',
  `duration` int DEFAULT NULL COMMENT '视频音频时长',
  `status` varchar(255) DEFAULT NULL COMMENT '状态',
  `priority` int DEFAULT '0' COMMENT '优先级（值越大优先级越低）',
  `shelf_time` datetime DEFAULT NULL COMMENT '上架时间',
  `is_delete` int NOT NULL DEFAULT '0',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for databasechangelog
-- ----------------------------
DROP TABLE IF EXISTS `databasechangelog`;
CREATE TABLE `databasechangelog` (
  `ID` varchar(255) NOT NULL,
  `AUTHOR` varchar(255) NOT NULL,
  `FILENAME` varchar(255) NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) NOT NULL,
  `MD5SUM` varchar(35) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `COMMENTS` varchar(255) DEFAULT NULL,
  `TAG` varchar(255) DEFAULT NULL,
  `LIQUIBASE` varchar(20) DEFAULT NULL,
  `CONTEXTS` varchar(255) DEFAULT NULL,
  `LABELS` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for databasechangeloglock
-- ----------------------------
DROP TABLE IF EXISTS `databasechangeloglock`;
CREATE TABLE `databasechangeloglock` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dept_library
-- ----------------------------
DROP TABLE IF EXISTS `dept_library`;
CREATE TABLE `dept_library` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `parent_dept_code` varchar(30) DEFAULT NULL COMMENT '上级科室代码',
  `parent_dept_name` varchar(50) DEFAULT NULL COMMENT '上级科室名称',
  `pinyin_code` varchar(25) DEFAULT NULL COMMENT '拼音码',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `desc` varchar(200) DEFAULT NULL COMMENT '科室描述',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_level` int DEFAULT NULL COMMENT '1:一级科室 2：二级科室',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `is_map` int DEFAULT NULL COMMENT '必要映射 1:必要映射',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_level` int DEFAULT NULL COMMENT '1:一级科室 2：二级科室',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `is_map` int DEFAULT NULL COMMENT '必要映射 1:必要映射',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dept_library_cloud1
-- ----------------------------
DROP TABLE IF EXISTS `dept_library_cloud1`;
CREATE TABLE `dept_library_cloud1` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `parent_dept_code` varchar(30) DEFAULT NULL COMMENT '上级科室代码',
  `parent_dept_name` varchar(50) DEFAULT NULL COMMENT '上级科室名称',
  `pinyin_code` varchar(25) DEFAULT NULL COMMENT '拼音码',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `desc` varchar(200) DEFAULT NULL COMMENT '科室描述',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_level` int DEFAULT NULL COMMENT '1:一级科室 2：二级科室',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `is_map` int DEFAULT NULL COMMENT '必要映射 1:必要映射',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dept_library_cloud_copy1
-- ----------------------------
DROP TABLE IF EXISTS `dept_library_cloud_copy1`;
CREATE TABLE `dept_library_cloud_copy1` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `parent_dept_code` varchar(30) DEFAULT NULL COMMENT '上级科室代码',
  `parent_dept_name` varchar(50) DEFAULT NULL COMMENT '上级科室名称',
  `pinyin_code` varchar(25) DEFAULT NULL COMMENT '拼音码',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `desc` varchar(200) DEFAULT NULL COMMENT '科室描述',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_level` int DEFAULT NULL COMMENT '1:一级科室 2：二级科室',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `is_map` int DEFAULT NULL COMMENT '必要映射 1:必要映射',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dept_library_h
-- ----------------------------
DROP TABLE IF EXISTS `dept_library_h`;
CREATE TABLE `dept_library_h` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `parent_dept_code` varchar(30) DEFAULT NULL COMMENT '上级科室代码',
  `parent_dept_name` varchar(50) DEFAULT NULL COMMENT '上级科室名称',
  `pinyin_code` varchar(25) DEFAULT NULL COMMENT '拼音码',
  `invalid_flag` int DEFAULT NULL COMMENT '作废标识(0:作废 1:有效)',
  `desc` varchar(200) DEFAULT NULL COMMENT '科室描述',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `code3` varchar(10) DEFAULT NULL,
  `code4` varchar(10) DEFAULT NULL,
  `code7` varchar(10) DEFAULT NULL,
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`dept_code`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dept_library_map
-- ----------------------------
DROP TABLE IF EXISTS `dept_library_map`;
CREATE TABLE `dept_library_map` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` text,
  `hosp_dept_code` text,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_drug_map` (`std_id`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dept_library_map_revert
-- ----------------------------
DROP TABLE IF EXISTS `dept_library_map_revert`;
CREATE TABLE `dept_library_map_revert` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` varchar(32) DEFAULT NULL,
  `hosp_dept_code` text,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_drug_map` (`std_id`,`hosp_code`,`hosp_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dept_library_replace
-- ----------------------------
DROP TABLE IF EXISTS `dept_library_replace`;
CREATE TABLE `dept_library_replace` (
  `dept_code` varchar(255) DEFAULT NULL,
  `dept_name` varchar(255) DEFAULT NULL,
  `new_dept_code` varchar(255) DEFAULT NULL,
  `new_dept_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dept_relation
-- ----------------------------
DROP TABLE IF EXISTS `dept_relation`;
CREATE TABLE `dept_relation` (
  `old_dept_code` varchar(255) DEFAULT NULL,
  `new_dept_code` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dictionary_catalog
-- ----------------------------
DROP TABLE IF EXISTS `dictionary_catalog`;
CREATE TABLE `dictionary_catalog` (
  `id` varchar(32) NOT NULL,
  `name` varchar(50) NOT NULL COMMENT '字典目录名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='字典目录';

-- ----------------------------
-- Table structure for dictionary_detail
-- ----------------------------
DROP TABLE IF EXISTS `dictionary_detail`;
CREATE TABLE `dictionary_detail` (
  `id` varchar(32) NOT NULL,
  `catalog_id` varchar(32) NOT NULL COMMENT '关联字典目录ID',
  `dictionary_code` varchar(32) DEFAULT NULL,
  `dictionary_name` varchar(50) NOT NULL COMMENT '字典名称',
  `dictionary_desc` varchar(50) DEFAULT NULL COMMENT '字典说明',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `sort_no` int DEFAULT NULL COMMENT '排序号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `label_sort_name` varchar(255) DEFAULT NULL,
  `label_sort_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='字典明细表';

-- ----------------------------
-- Table structure for dictionary_detail_copy1
-- ----------------------------
DROP TABLE IF EXISTS `dictionary_detail_copy1`;
CREATE TABLE `dictionary_detail_copy1` (
  `id` varchar(32) NOT NULL,
  `catalog_id` varchar(32) NOT NULL COMMENT '关联字典目录ID',
  `dictionary_code` varchar(32) DEFAULT NULL,
  `dictionary_name` varchar(50) NOT NULL COMMENT '字典名称',
  `dictionary_desc` varchar(50) DEFAULT NULL COMMENT '字典说明',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `sort_no` int DEFAULT NULL COMMENT '排序号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `label_sort_name` varchar(255) DEFAULT NULL,
  `label_sort_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='字典明细表';

-- ----------------------------
-- Table structure for dictionary_hosp
-- ----------------------------
DROP TABLE IF EXISTS `dictionary_hosp`;
CREATE TABLE `dictionary_hosp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(50) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `type` int DEFAULT NULL,
  `is_delete` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=124741399 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dictionary_hosp_area
-- ----------------------------
DROP TABLE IF EXISTS `dictionary_hosp_area`;
CREATE TABLE `dictionary_hosp_area` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '机构代码',
  `area_code` varchar(32) DEFAULT NULL COMMENT '院区代码',
  `area_name` varchar(128) DEFAULT NULL COMMENT '院区名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='医院院区字典';

-- ----------------------------
-- Table structure for dictionary_indicator
-- ----------------------------
DROP TABLE IF EXISTS `dictionary_indicator`;
CREATE TABLE `dictionary_indicator` (
  `id` varchar(32) NOT NULL,
  `name` varchar(100) DEFAULT NULL COMMENT '名称',
  `code` varchar(30) DEFAULT NULL COMMENT '编码',
  `unit` varchar(10) DEFAULT NULL COMMENT '单位',
  `content_length` int DEFAULT NULL COMMENT '内容长度',
  `content_type` smallint DEFAULT NULL COMMENT '内容类型(1:单行文本;2:多行文本;3:单选)',
  `options_content` varchar(50) DEFAULT NULL COMMENT '选项',
  `catalog_id` varchar(32) DEFAULT NULL COMMENT '关联字典目录id 5：指标',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` smallint DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dictionary_medical
-- ----------------------------
DROP TABLE IF EXISTS `dictionary_medical`;
CREATE TABLE `dictionary_medical` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dictionary_type` tinyint NOT NULL COMMENT '字典类型（1疾病 2手术 3药品,4检验，5科室）',
  `dictionary_code` varchar(32) NOT NULL COMMENT '代码',
  `dictionary_name` varchar(50) NOT NULL COMMENT '名称',
  `pinyin_code` varchar(50) DEFAULT NULL COMMENT '拼音码',
  `reference_ranges` varchar(50) DEFAULT NULL COMMENT '参考范围',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30860 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for disease_case
-- ----------------------------
DROP TABLE IF EXISTS `disease_case`;
CREATE TABLE `disease_case` (
  `id` varchar(32) NOT NULL COMMENT '模拟患者案例主键',
  `pack_id` varchar(32) DEFAULT NULL COMMENT '精细化路径id',
  `case_name` varchar(50) DEFAULT NULL COMMENT '案例名称',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '患者名称',
  `diag_code` varchar(200) DEFAULT NULL COMMENT '疾病代码',
  `diag_name` varchar(300) DEFAULT NULL COMMENT '疾病名称',
  `create_time` timestamp DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `sex_code` varchar(10) DEFAULT NULL COMMENT '性别',
  `birth_data` varchar(50) DEFAULT NULL COMMENT '生日',
  `desc` varchar(1000) DEFAULT NULL COMMENT '描述',
  `therapy_stage_code` varchar(255) DEFAULT NULL COMMENT '指定当前阶段编码',
  `therapy_stage_name` varchar(255) DEFAULT NULL COMMENT '指定当前阶段名称',
  `gestation_week` int DEFAULT NULL COMMENT '孕周',
  `gestation_date` datetime DEFAULT NULL COMMENT '孕周登记日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for disease_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `disease_dictionary`;
CREATE TABLE `disease_dictionary` (
  `id` varchar(32) NOT NULL,
  `dictionary_code` varchar(32) DEFAULT NULL COMMENT '数据编码',
  `dictionary_name` varchar(100) DEFAULT NULL COMMENT '数据名称',
  `data_type` int DEFAULT NULL COMMENT '数据类型 0-文本 1-数字 2-时间',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专病字典';

-- ----------------------------
-- Table structure for disease_library
-- ----------------------------
DROP TABLE IF EXISTS `disease_library`;
CREATE TABLE `disease_library` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
  KEY `l` (`level`) USING BTREE,
  KEY `cd` (`code`,`additional_code`,`level`) USING BTREE,
  KEY `aa` (`additional_code`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for disease_library_cloud_copy1_copy1
-- ----------------------------
DROP TABLE IF EXISTS `disease_library_cloud_copy1_copy1`;
CREATE TABLE `disease_library_cloud_copy1_copy1` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for disease_library_cloud_导入完成
-- ----------------------------
DROP TABLE IF EXISTS `disease_library_cloud_导入完成`;
CREATE TABLE `disease_library_cloud_导入完成` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for disease_library_copy1
-- ----------------------------
DROP TABLE IF EXISTS `disease_library_copy1`;
CREATE TABLE `disease_library_copy1` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for disease_library_h
-- ----------------------------
DROP TABLE IF EXISTS `disease_library_h`;
CREATE TABLE `disease_library_h` (
  `id` varchar(32) NOT NULL,
  `code` varchar(255) DEFAULT '' COMMENT '编码',
  `name` varchar(255) DEFAULT NULL COMMENT '名称',
  `additional_code` varchar(255) DEFAULT NULL COMMENT '附加名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `code3` varchar(3) DEFAULT NULL,
  `code4` varchar(4) DEFAULT NULL,
  `code7` varchar(7) DEFAULT NULL,
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`,`hosp_code`) USING BTREE,
  KEY `idx_disease_name_h` (`name`) USING BTREE,
  KEY `idx_disease_code_h` (`code`) USING BTREE,
  KEY `idx_disease_code_h_3` (`code3`) USING BTREE,
  KEY `idx_disease_code_h_4` (`code4`) USING BTREE,
  KEY `idx_disease_code_h_7` (`code7`) USING BTREE,
  KEY `idx_hosp_code` (`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for disease_library_map
-- ----------------------------
DROP TABLE IF EXISTS `disease_library_map`;
CREATE TABLE `disease_library_map` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` text,
  `hosp_disease_code` text,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for disease_library_map_cloud
-- ----------------------------
DROP TABLE IF EXISTS `disease_library_map_cloud`;
CREATE TABLE `disease_library_map_cloud` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `hosp_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '机构代码',
  `diag_code` varchar(255) DEFAULT NULL COMMENT '医院主诊断疾病编码',
  `diag_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '医院主诊断疾病名称',
  `mapped_diag_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '映射得到的标准疾病code',
  `mapped_diag_name` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '映射得到的标准疾病名称',
  `create_dt` datetime DEFAULT NULL COMMENT '记录新增日期',
  `source_type` int DEFAULT NULL COMMENT '来源0数据中心1飞书确认',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for disease_library_map_revert
-- ----------------------------
DROP TABLE IF EXISTS `disease_library_map_revert`;
CREATE TABLE `disease_library_map_revert` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` varchar(255) DEFAULT NULL,
  `hosp_disease_code` varchar(255) DEFAULT NULL,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_hosp_code` (`hosp_code`),
  KEY `idx_disease_code` (`std_code`,`hosp_disease_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for drug_library
-- ----------------------------
DROP TABLE IF EXISTS `drug_library`;
CREATE TABLE `drug_library` (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '主键',
  `drug_name` varchar(50) DEFAULT NULL COMMENT '药品名称（通用名）',
  `drug_alias` varchar(50) DEFAULT NULL COMMENT '药品别名(商品名)',
  `drug_type_codes` varchar(100) DEFAULT NULL COMMENT '药品类别编码',
  `fda_level` varchar(50) DEFAULT NULL COMMENT 'FDA等级',
  `use_dose` varchar(20) DEFAULT '' COMMENT '使用剂量',
  `medication_frequency` varchar(50) DEFAULT NULL COMMENT '服药频次',
  `use_disease_codes` varchar(200) DEFAULT NULL COMMENT '适用疾病编码',
  `label_codes` varchar(200) DEFAULT NULL COMMENT '标签编码',
  `use_disease_names` varchar(500) DEFAULT NULL COMMENT '适用疾病名称',
  `label_names` varchar(500) DEFAULT NULL COMMENT '标签名称',
  `drug_taboos` text COMMENT '药品禁忌',
  `needing_attention` text COMMENT '注意事项',
  `adverse_reactions` text COMMENT '不良反应',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT NULL COMMENT '删除标识',
  `drug_type_names` varchar(255) DEFAULT NULL COMMENT '药品类别名称',
  `drug_code` varchar(255) DEFAULT NULL COMMENT '药品编码',
  `pinyin_code` varchar(50) DEFAULT NULL COMMENT '药品拼音码',
  `wubi_code` varchar(50) DEFAULT NULL COMMENT '药品五笔码',
  `big_pack_spec` varchar(50) DEFAULT NULL COMMENT '规格',
  `character_label_codes` text COMMENT '特性',
  `character_label_names` text COMMENT '特性',
  `effect_drug_codes` text COMMENT '相互作用',
  `effect_drug_names` text COMMENT '相互作用',
  `disable_food_codes` text COMMENT '禁忌食物',
  `disable_food_names` text COMMENT '禁忌食物',
  `able_label_codes` text COMMENT '适宜标签',
  `able_label_names` text COMMENT '适宜标签',
  `disable_label_codes` text COMMENT '不适宜标签',
  `disable_label_names` text COMMENT '不适宜标签',
  `covers` text COMMENT '封面',
  `drug_component` text COMMENT '成分',
  `drug_characteristic` text COMMENT '性状',
  `drug_indication` text COMMENT '适应症',
  `drug_specs` text COMMENT '规格',
  `drug_usage` text COMMENT '用法',
  `drug_explain` text COMMENT '用药交代',
  `rule_code` text COMMENT '服药规则',
  `rule_code_name` text COMMENT '服药规则',
  `special_crowd` text COMMENT '特殊用药人群',
  `drug_action` text COMMENT '药理作用',
  `supprot_hours` int DEFAULT NULL COMMENT '小时',
  `diag_level` text COMMENT '适用疾病级别',
  `needing_attention_attachment` varchar(500) DEFAULT NULL COMMENT '注意事项附件',
  `needing_attention_cover` varchar(500) DEFAULT NULL COMMENT '注意事项封面',
  `adverse_reactions_attachment` varchar(500) DEFAULT NULL COMMENT '不良反应附件',
  `adverse_reactions_cover` varchar(500) DEFAULT NULL COMMENT '不良反应封面',
  `drug_taboos_attachment` varchar(500) DEFAULT NULL COMMENT '药品禁忌附件',
  `drug_taboos_cover` varchar(500) DEFAULT NULL COMMENT '药品禁忌封面',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for drug_library_h
-- ----------------------------
DROP TABLE IF EXISTS `drug_library_h`;
CREATE TABLE `drug_library_h` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `drug_name` varchar(50) DEFAULT NULL COMMENT '药品名称',
  `drug_alias` varchar(50) DEFAULT NULL COMMENT '药品别名',
  `drug_type_codes` varchar(100) DEFAULT NULL COMMENT '药品类别编码',
  `fda_level` varchar(50) DEFAULT NULL COMMENT 'FDA等级',
  `use_dose` varchar(20) DEFAULT '' COMMENT '使用剂量',
  `medication_frequency` varchar(50) DEFAULT NULL COMMENT '服药频次',
  `use_disease_codes` varchar(200) DEFAULT NULL COMMENT '适用疾病编码',
  `label_codes` varchar(200) DEFAULT NULL COMMENT '标签编码',
  `use_disease_names` varchar(500) DEFAULT NULL COMMENT '适用疾病名称',
  `label_names` varchar(500) DEFAULT NULL COMMENT '标签名称',
  `drug_taboos` text COMMENT '药品禁忌',
  `needing_attention` text COMMENT '注意事项',
  `adverse_reactions` text COMMENT '不良反应',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT NULL COMMENT '删除标识',
  `drug_type_names` varchar(255) DEFAULT NULL COMMENT '药品类别名称',
  `drug_code` varchar(255) DEFAULT NULL COMMENT '药品编码',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`drug_code`,`hosp_code`) USING BTREE,
  KEY `idx_drug_name_h` (`drug_name`) USING BTREE,
  KEY `idx_drug_code_h` (`drug_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for drug_library_map
-- ----------------------------
DROP TABLE IF EXISTS `drug_library_map`;
CREATE TABLE `drug_library_map` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` text,
  `hosp_drug_code` text,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_drug_map` (`std_id`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for drug_library_map_revert
-- ----------------------------
DROP TABLE IF EXISTS `drug_library_map_revert`;
CREATE TABLE `drug_library_map_revert` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` varchar(100) DEFAULT NULL,
  `hosp_drug_code` varchar(100) DEFAULT NULL,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_drug_map` (`std_id`,`hosp_code`,`hosp_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dwt_his_diag_code_mapped_inc_d
-- ----------------------------
DROP TABLE IF EXISTS `dwt_his_diag_code_mapped_inc_d`;
CREATE TABLE `dwt_his_diag_code_mapped_inc_d` (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '机构代码',
  `diag_code` varchar(255) DEFAULT NULL COMMENT '医院诊断编码',
  `diag_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '医院诊断名称',
  `mapped_diag_code` varchar(255) DEFAULT NULL COMMENT '映射诊断编码',
  `mapped_diag_name` varchar(255) DEFAULT NULL COMMENT '映射诊断名称',
  `create_dt` varchar(100) DEFAULT NULL COMMENT '日期',
  `source_type` int DEFAULT '0' COMMENT '0数据中心同步1飞书确认同步AI生成',
  `is_delete` int DEFAULT '0',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`,`diag_name`),
  KEY `dwt_his_diag_code_mapped_inc_d_diag_name_index` (`diag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dwt_his_diag_code_mapped_inc_d_copy1
-- ----------------------------
DROP TABLE IF EXISTS `dwt_his_diag_code_mapped_inc_d_copy1`;
CREATE TABLE `dwt_his_diag_code_mapped_inc_d_copy1` (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '机构代码',
  `diag_code` varchar(255) DEFAULT NULL COMMENT '医院诊断编码',
  `diag_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '医院诊断名称',
  `mapped_diag_code` varchar(255) DEFAULT NULL COMMENT '映射诊断编码',
  `mapped_diag_name` varchar(255) DEFAULT NULL COMMENT '映射诊断名称',
  `create_dt` varchar(100) DEFAULT NULL COMMENT '日期',
  `source_type` int DEFAULT '0' COMMENT '0数据中心同步1飞书确认同步AI生成',
  `is_delete` int DEFAULT '0',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for edu_base_association
-- ----------------------------
DROP TABLE IF EXISTS `edu_base_association`;
CREATE TABLE `edu_base_association` (
  `id` varchar(32) NOT NULL,
  `edu_base_id` varchar(32) NOT NULL,
  `edu_common_id` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='基础库和公共库宣教关联表';

-- ----------------------------
-- Table structure for edu_category_association
-- ----------------------------
DROP TABLE IF EXISTS `edu_category_association`;
CREATE TABLE `edu_category_association` (
  `category_id` varchar(20) DEFAULT NULL,
  `category_name` varchar(255) DEFAULT NULL,
  `second_category_id` varchar(20) DEFAULT NULL,
  `second_category_name` varchar(255) DEFAULT NULL,
  `common_category_id` varchar(20) DEFAULT NULL,
  `common_category_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='宣教分类关联表';

-- ----------------------------
-- Table structure for edu_hosp_distribution
-- ----------------------------
DROP TABLE IF EXISTS `edu_hosp_distribution`;
CREATE TABLE `edu_hosp_distribution` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) NOT NULL COMMENT '医院机构代码',
  `scene_type` int DEFAULT NULL,
  `common_scene_id` varchar(32) NOT NULL COMMENT '场景id',
  `common_scene_name` varchar(200) DEFAULT NULL COMMENT '场景名称',
  `success_flag` int DEFAULT NULL COMMENT '0:失败，1成功  2:等待',
  `reason_type` int DEFAULT NULL COMMENT '理由类型 1：映射 2医院网络异常',
  `reason_desc` varchar(500) DEFAULT NULL COMMENT '同步失败原因',
  `success_time` datetime DEFAULT NULL COMMENT '下发成功时间',
  `distribution_time` datetime DEFAULT NULL COMMENT '分配时间',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '分配人',
  `editor_name` varchar(30) DEFAULT NULL,
  `is_delete` int DEFAULT NULL COMMENT '删除标记',
  `process_type` varchar(128) DEFAULT NULL COMMENT '流程类型，1：门诊流程，2：入院准备流程，3：住院流程',
  `attribute_type` int DEFAULT NULL COMMENT '1：场景 2：宣教',
  `category_id` varchar(32) DEFAULT NULL COMMENT '分类id',
  `category_name` varchar(32) DEFAULT NULL COMMENT '分类名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教分配关系表';

-- ----------------------------
-- Table structure for edu_hosp_logo
-- ----------------------------
DROP TABLE IF EXISTS `edu_hosp_logo`;
CREATE TABLE `edu_hosp_logo` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `hosp_id` varchar(2000) DEFAULT NULL,
  `hosp_code` varchar(1000) DEFAULT NULL,
  `hosp_name` varchar(1000) DEFAULT NULL,
  `logo_src` varchar(255) NOT NULL COMMENT 'logo地址',
  `logo_position` int DEFAULT '0' COMMENT '0-置顶 1-底部',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '0-正常  1-删除',
  `editor_id` varchar(255) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='宣教医院logo配置表';

-- ----------------------------
-- Table structure for edu_hosp_record
-- ----------------------------
DROP TABLE IF EXISTS `edu_hosp_record`;
CREATE TABLE `edu_hosp_record` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '机构代码',
  `common_scene_id` varchar(32) NOT NULL COMMENT '云端场景id',
  `common_scene_name` varchar(255) DEFAULT NULL COMMENT '云端场景名称',
  `common_scene_hosp_id` varchar(32) NOT NULL COMMENT '院端场景id',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教公共库和医院库场景关系表';

-- ----------------------------
-- Table structure for edu_media
-- ----------------------------
DROP TABLE IF EXISTS `edu_media`;
CREATE TABLE `edu_media` (
  `id` varchar(32) NOT NULL,
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联id',
  `relation_type` int DEFAULT NULL COMMENT '关联类型 0-宣教  1-课程',
  `media_url` varchar(100) DEFAULT NULL COMMENT '媒体地址',
  `media_type` varchar(32) DEFAULT NULL COMMENT '媒体类型',
  `original_media_md5` varchar(64) DEFAULT NULL COMMENT '原媒体MD5,用于关联',
  `is_delete` int DEFAULT NULL COMMENT '0：正常  1:删除  2：未关联宣教',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='媒体资源表';

-- ----------------------------
-- Table structure for edu_scene_relation
-- ----------------------------
DROP TABLE IF EXISTS `edu_scene_relation`;
CREATE TABLE `edu_scene_relation` (
  `id` varchar(32) NOT NULL,
  `common_education_id` varchar(32) DEFAULT NULL COMMENT '智宣教id',
  `common_scene_id` varchar(32) DEFAULT NULL COMMENT '智宣教场景id',
  `begin_time_type` tinyint(1) DEFAULT NULL COMMENT '场景类型，1：检查开单后，2：检查出报告后，3：检验开单后，4：检验出报告后，5：门诊诊断后，6：入院诊断后，7：出院诊断后，8：门诊挂号后，9：门诊检查预约时间前，10：门诊检验预约时间前，11：预约就诊前',
  `after_begin_time_unit` tinyint(1) DEFAULT NULL COMMENT '发送时间单位，1：分钟，2：小时，3：天',
  `after_begin_time` int DEFAULT NULL COMMENT '发送时间数值',
  `condition_id` varchar(32) DEFAULT NULL COMMENT '条件id',
  `condition_name` varchar(128) DEFAULT NULL COMMENT '条件名称',
  `operator_type` tinyint DEFAULT NULL COMMENT '运算符类型,详情见SceneOperatorEnum枚举',
  `contrast_value` varchar(128) DEFAULT NULL COMMENT '筛选值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `triage_result_id` varchar(32) DEFAULT NULL COMMENT '分诊问卷结果id',
  `is_mount` tinyint(1) DEFAULT NULL COMMENT '是否挂载，0：非挂载，1：挂载',
  `dept_codes` varchar(256) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(1024) DEFAULT NULL COMMENT '科室名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教场景关联表';

-- ----------------------------
-- Table structure for edu_scene_relation_review
-- ----------------------------
DROP TABLE IF EXISTS `edu_scene_relation_review`;
CREATE TABLE `edu_scene_relation_review` (
  `id` varchar(32) NOT NULL,
  `common_education_id` varchar(32) DEFAULT NULL COMMENT '智宣教id',
  `common_scene_id` varchar(32) DEFAULT NULL COMMENT '智宣教场景id',
  `begin_time_type` tinyint(1) DEFAULT NULL COMMENT '场景类型，1：检查开单后，2：检查出报告后，3：检验开单后，4：检验出报告后，5：门诊诊断后，6：入院诊断后，7：出院诊断后，8：门诊挂号后，9：门诊检查预约时间前，10：门诊检验预约时间前，11：预约就诊前',
  `after_begin_time_unit` tinyint(1) DEFAULT NULL COMMENT '发送时间单位，1：分钟，2：小时，3：天',
  `after_begin_time` int DEFAULT NULL COMMENT '发送时间数值',
  `condition_id` varchar(32) DEFAULT NULL COMMENT '条件id',
  `condition_name` varchar(128) DEFAULT NULL COMMENT '条件名称',
  `operator_type` tinyint DEFAULT NULL COMMENT '运算符类型,详情见SceneOperatorEnum枚举',
  `contrast_value` varchar(128) DEFAULT NULL COMMENT '对比值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `triage_result_id` varchar(32) DEFAULT NULL COMMENT '分诊问卷结果id',
  `is_mount` tinyint(1) DEFAULT NULL COMMENT '是否挂载，0：非挂载，1：挂载',
  `dept_codes` varchar(256) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(1024) DEFAULT NULL COMMENT '科室名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='智宣教场景关联临时表';

-- ----------------------------
-- Table structure for educate_library
-- ----------------------------
DROP TABLE IF EXISTS `educate_library`;
CREATE TABLE `educate_library` (
  `id` varchar(32) NOT NULL,
  `course_id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL COMMENT '课程名称',
  `content_type` varchar(16) DEFAULT NULL COMMENT '内容类型',
  `category_id` varchar(500) DEFAULT NULL,
  `category_name` varchar(500) DEFAULT NULL,
  `course_content` longtext COMMENT '宣教内容',
  `source_type` varchar(64) DEFAULT NULL COMMENT '课程来源',
  `source_id` varchar(32) DEFAULT NULL COMMENT '来源ID',
  `download_count` bigint DEFAULT '0' COMMENT '课程的下载次数',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `valid_flag` smallint DEFAULT '1' COMMENT '有效标志 1 ：有效  0：无效',
  `edu_flag` smallint DEFAULT NULL COMMENT '宣教、宣讲标识 1宣教 2宣讲',
  `temporary_course_id` bigint DEFAULT NULL,
  `course_content_multimedia` varchar(500) DEFAULT NULL COMMENT '多媒体内容',
  `is_update_course_content` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_educate_library_course_id` (`course_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1002115 DEFAULT CHARSET=utf8mb3 COMMENT='公共宣教课程库';

-- ----------------------------
-- Table structure for educate_library_cloud
-- ----------------------------
DROP TABLE IF EXISTS `educate_library_cloud`;
CREATE TABLE `educate_library_cloud` (
  `id` varchar(32) NOT NULL,
  `course_id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL COMMENT '课程名称',
  `content_type` varchar(16) DEFAULT NULL COMMENT '内容类型',
  `category_id` varchar(500) DEFAULT NULL,
  `category_name` varchar(500) DEFAULT NULL,
  `course_content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '宣教内容',
  `source_type` varchar(64) DEFAULT NULL COMMENT '课程来源',
  `source_id` varchar(32) DEFAULT NULL COMMENT '来源ID',
  `download_count` bigint DEFAULT '0' COMMENT '课程的下载次数',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `valid_flag` smallint DEFAULT '1' COMMENT '有效标志 1 ：有效  0：无效',
  `edu_flag` smallint DEFAULT NULL COMMENT '宣教、宣讲标识 1宣教 2宣讲',
  `temporary_course_id` bigint DEFAULT NULL,
  `course_content_multimedia` varchar(500) DEFAULT NULL COMMENT '多媒体内容',
  `is_update_course_content` int DEFAULT '0',
  `theme` varchar(32) DEFAULT NULL COMMENT '主题',
  `skeleton` varchar(32) DEFAULT NULL COMMENT '行业',
  `mk_json` longtext COMMENT 'markdownJson内容',
  `total_word_num` int DEFAULT NULL COMMENT '字数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_educate_library_course_id` (`course_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1002747 DEFAULT CHARSET=utf8mb3 COMMENT='公共宣教课程库';

-- ----------------------------
-- Table structure for education
-- ----------------------------
DROP TABLE IF EXISTS `education`;
CREATE TABLE `education` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型 1,基础库 2,医院库',
  `course_id` varchar(32) DEFAULT NULL COMMENT '课程id',
  `course_name` varchar(100) DEFAULT NULL COMMENT '宣教标题',
  `course_content` varchar(2048) DEFAULT NULL COMMENT '课程内容',
  `course_preview_url` varchar(1024) DEFAULT NULL COMMENT '课程预览的url(外网可访问)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `self_flag` int DEFAULT NULL COMMENT '自建标示 1自建 2收费 3基础',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `release_time` datetime DEFAULT NULL COMMENT '发布时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `education_desc` varchar(1024) DEFAULT NULL COMMENT '宣教描述',
  `course_id_317` varchar(32) DEFAULT NULL COMMENT '317课程id',
  `edu_flag` smallint DEFAULT NULL COMMENT '宣教、宣讲标识 1宣教 2宣讲',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(500) DEFAULT NULL,
  `category_id` varchar(100) DEFAULT NULL COMMENT '一级类别编码',
  `category_name` varchar(100) DEFAULT NULL COMMENT '一级类别名称',
  `second_category_id` varchar(200) DEFAULT NULL COMMENT '二级类别编码',
  `second_category_name` varchar(100) DEFAULT NULL COMMENT '二级类别名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `temporary_education_id` varchar(32) DEFAULT NULL,
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `url_317` varchar(255) DEFAULT NULL COMMENT '317课程url',
  `cover_url` varchar(500) DEFAULT NULL COMMENT '封面URL地址',
  `key_words` varchar(255) DEFAULT NULL COMMENT '关键字',
  `annotation` varchar(255) DEFAULT NULL COMMENT '批注',
  `new_editor_id` varchar(32) DEFAULT NULL COMMENT '最新更新人id',
  `new_editor_name` varchar(50) DEFAULT NULL COMMENT '最新更新人姓名',
  `flag` int DEFAULT NULL,
  `old_label_codes` varchar(255) DEFAULT NULL,
  `old_label_names` varchar(255) DEFAULT NULL,
  `is_update_course_preview_url` int DEFAULT NULL COMMENT '是否修改course_preview_url',
  `is_service_edu` int DEFAULT '0' COMMENT '是否是服务宣教 0-否 1-是',
  `label_codes_old` varchar(1000) DEFAULT NULL,
  `label_names_old` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `eid` (`temporary_education_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='是否老宣教 0否  1是';

-- ----------------------------
-- Table structure for education_back20240321
-- ----------------------------
DROP TABLE IF EXISTS `education_back20240321`;
CREATE TABLE `education_back20240321` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型 1,基础库 2,医院库',
  `course_id` varchar(32) DEFAULT NULL COMMENT '课程id',
  `course_name` varchar(100) DEFAULT NULL COMMENT '宣教标题',
  `course_content` varchar(2048) DEFAULT NULL COMMENT '课程内容',
  `course_preview_url` varchar(1024) DEFAULT NULL COMMENT '课程预览的url(外网可访问)',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `self_flag` int DEFAULT NULL COMMENT '自建标示 1自建 2收费 3基础',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `release_time` datetime DEFAULT NULL COMMENT '发布时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `education_desc` varchar(1024) DEFAULT NULL COMMENT '宣教描述',
  `course_id_317` varchar(32) DEFAULT NULL COMMENT '317课程id',
  `edu_flag` smallint DEFAULT NULL COMMENT '宣教、宣讲标识 1宣教 2宣讲',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(500) DEFAULT NULL,
  `category_id` varchar(100) DEFAULT NULL COMMENT '类别编码',
  `category_name` varchar(200) DEFAULT NULL COMMENT '类别名称',
  `second_category_id` varchar(100) DEFAULT NULL COMMENT '二级类别编码',
  `second_category_name` varchar(200) DEFAULT NULL COMMENT '二级类别名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `temporary_education_id` varchar(32) DEFAULT NULL,
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `url_317` varchar(1000) DEFAULT NULL COMMENT '317课程url',
  `flag` varchar(10) DEFAULT NULL,
  `cover_url` varchar(500) DEFAULT NULL COMMENT '封面URL地址',
  `key_words` varchar(255) DEFAULT NULL COMMENT '关键字',
  `annotation` varchar(255) DEFAULT NULL COMMENT '批注',
  `new_editor_id` varchar(32) DEFAULT NULL COMMENT '最新更新人id',
  `new_editor_name` varchar(50) DEFAULT NULL COMMENT '最新更新人姓名',
  `old_label_codes` varchar(1000) DEFAULT NULL,
  `old_label_names` varchar(1000) DEFAULT NULL,
  `is_update_course_preview_url` int DEFAULT '0',
  `is_service_edu` int DEFAULT '0' COMMENT '是否是服务宣教 0-否 1-是',
  `label_codes_old` varchar(1000) DEFAULT NULL,
  `label_names_old` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='是否是服务宣教 0-否 1-是';

-- ----------------------------
-- Table structure for education_cloud
-- ----------------------------
DROP TABLE IF EXISTS `education_cloud`;
CREATE TABLE `education_cloud` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型 1,基础库 2,医院库',
  `course_id` varchar(32) DEFAULT NULL COMMENT '课程id',
  `course_name` varchar(100) DEFAULT NULL COMMENT '宣教标题',
  `external_title` varchar(100) DEFAULT NULL COMMENT '课程标题 对外',
  `course_summary` varchar(100) DEFAULT NULL COMMENT '课程摘要',
  `course_content` varchar(2048) DEFAULT NULL COMMENT '课程内容',
  `course_preview_url` varchar(1024) DEFAULT NULL COMMENT '课程预览的url(外网可访问)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` text,
  `diag_names` text,
  `self_flag` int DEFAULT NULL COMMENT '自建标示 1自建 2收费 3基础',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `release_time` datetime DEFAULT NULL COMMENT '发布时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `education_desc` varchar(1024) DEFAULT NULL COMMENT '宣教描述',
  `course_id_317` varchar(32) DEFAULT NULL COMMENT '317课程id',
  `edu_flag` smallint DEFAULT NULL COMMENT '宣教、宣讲标识 1宣教 2宣讲',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(500) DEFAULT NULL,
  `category_id` varchar(100) DEFAULT NULL COMMENT '一级类别编码',
  `category_name` varchar(100) DEFAULT NULL COMMENT '一级类别名称',
  `second_category_id` varchar(200) DEFAULT NULL COMMENT '二级类别编码',
  `second_category_name` varchar(100) DEFAULT NULL COMMENT '二级类别名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `temporary_education_id` varchar(32) DEFAULT NULL,
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `url_317` varchar(255) DEFAULT NULL COMMENT '317课程url',
  `cover_url` varchar(500) DEFAULT NULL COMMENT '封面URL地址',
  `key_words` varchar(255) DEFAULT NULL COMMENT '关键字',
  `annotation` varchar(255) DEFAULT NULL COMMENT '批注',
  `new_editor_id` varchar(32) DEFAULT NULL COMMENT '最新更新人id',
  `new_editor_name` varchar(50) DEFAULT NULL COMMENT '最新更新人姓名',
  `flag` int DEFAULT NULL,
  `old_label_codes` varchar(255) DEFAULT NULL,
  `old_label_names` varchar(255) DEFAULT NULL,
  `is_update_course_preview_url` int DEFAULT NULL COMMENT '是否修改course_preview_url',
  `is_service_edu` int DEFAULT '0' COMMENT '是否是服务宣教 0-否 1-是',
  `apply_hosp_code` varchar(255) DEFAULT '-1' COMMENT '适用医院',
  `apply_hosp_name` varchar(1255) DEFAULT NULL COMMENT '适用医院',
  `is_old` tinyint DEFAULT '1' COMMENT '是否老宣教 0否  1是',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `label_codes_old` varchar(1000) DEFAULT NULL,
  `label_names_old` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `eid` (`temporary_education_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='是否老宣教 0否  1是';

-- ----------------------------
-- Table structure for education_cloud_back20240321
-- ----------------------------
DROP TABLE IF EXISTS `education_cloud_back20240321`;
CREATE TABLE `education_cloud_back20240321` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型 1,基础库 2,医院库',
  `course_id` varchar(32) DEFAULT NULL COMMENT '课程id',
  `course_name` varchar(100) DEFAULT NULL COMMENT '宣教标题',
  `external_title` varchar(100) DEFAULT NULL COMMENT '课程标题 对外',
  `course_summary` varchar(100) DEFAULT NULL COMMENT '课程摘要',
  `course_content` varchar(2048) DEFAULT NULL COMMENT '课程内容',
  `course_preview_url` varchar(1024) DEFAULT NULL COMMENT '课程预览的url(外网可访问)',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(1500) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(1500) DEFAULT NULL COMMENT '关联疾病名称',
  `self_flag` int DEFAULT NULL COMMENT '自建标示 1自建 2收费 3基础',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `release_time` datetime DEFAULT NULL COMMENT '发布时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `education_desc` varchar(1024) DEFAULT NULL COMMENT '宣教描述',
  `course_id_317` varchar(32) DEFAULT NULL COMMENT '317课程id',
  `edu_flag` smallint DEFAULT NULL COMMENT '宣教、宣讲标识 1宣教 2宣讲',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(500) DEFAULT NULL,
  `category_id` varchar(100) DEFAULT NULL COMMENT '类别编码',
  `category_name` varchar(200) DEFAULT NULL COMMENT '类别名称',
  `second_category_id` varchar(100) DEFAULT NULL COMMENT '二级类别编码',
  `second_category_name` varchar(200) DEFAULT NULL COMMENT '二级类别名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `temporary_education_id` varchar(32) DEFAULT NULL,
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `url_317` varchar(1000) DEFAULT NULL COMMENT '317课程url',
  `flag` varchar(10) DEFAULT NULL,
  `cover_url` varchar(500) DEFAULT NULL COMMENT '封面URL地址',
  `key_words` varchar(255) DEFAULT NULL COMMENT '关键字',
  `annotation` varchar(255) DEFAULT NULL COMMENT '批注',
  `new_editor_id` varchar(32) DEFAULT NULL COMMENT '最新更新人id',
  `new_editor_name` varchar(50) DEFAULT NULL COMMENT '最新更新人姓名',
  `old_label_codes` varchar(1000) DEFAULT NULL,
  `old_label_names` varchar(1000) DEFAULT NULL,
  `is_update_course_preview_url` int DEFAULT '0',
  `is_service_edu` int DEFAULT '0' COMMENT '是否是服务宣教 0-否 1-是',
  `apply_hosp_code` varchar(255) DEFAULT '-1' COMMENT '适用医院',
  `apply_hosp_name` varchar(1255) DEFAULT NULL COMMENT '适用医院',
  `is_old` tinyint DEFAULT '1' COMMENT '是否老宣教 0否  1是',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `label_codes_old` varchar(1000) DEFAULT NULL,
  `label_names_old` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='是否是服务宣教 0-否 1-是';

-- ----------------------------
-- Table structure for education_content
-- ----------------------------
DROP TABLE IF EXISTS `education_content`;
CREATE TABLE `education_content` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '主键',
  `course_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '宣教名称',
  `diag_names` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT '适用疾病  ,分隔',
  `dept_names` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT '适用科室  ,分隔',
  `education_desc` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT '宣教描述',
  `category_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT '宣教分类',
  `course_content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '宣讲内容',
  `cover_url` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL COMMENT '宣教封面',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_delete` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- ----------------------------
-- Table structure for exam_report
-- ----------------------------
DROP TABLE IF EXISTS `exam_report`;
CREATE TABLE `exam_report` (
  `report_no` varchar(50) NOT NULL,
  `organ_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pat_index_no` varchar(50) DEFAULT NULL COMMENT '患者索引号',
  `outhosp_no` varchar(50) DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '门诊流水号',
  `inhosp_no` varchar(50) DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '住院流水号',
  `requisition_no` varchar(100) NOT NULL,
  `report_name` varchar(50) DEFAULT NULL COMMENT '报告名称',
  `equipment_code` varchar(50) DEFAULT NULL COMMENT '设备代码',
  `equipment_name` varchar(50) DEFAULT NULL COMMENT '设备名称',
  `oper_part_code` varchar(50) DEFAULT NULL COMMENT '操作部位代码',
  `oper_part_name` varchar(50) DEFAULT NULL COMMENT '操作部位名称',
  `exam_categ_code` varchar(50) DEFAULT NULL COMMENT '检查类别代码',
  `exam_categ_name` varchar(50) DEFAULT NULL COMMENT '检查类别名称',
  `exam_item_code` varchar(50) DEFAULT NULL COMMENT '检查项目代码',
  `exam_item_name` varchar(50) DEFAULT NULL COMMENT '检查项目名称',
  `apply_date` datetime DEFAULT NULL COMMENT '申请日期',
  `apply_dept_code` varchar(50) DEFAULT NULL COMMENT '申请科室代码',
  `apply_dept_name` varchar(50) DEFAULT NULL COMMENT '申请科室名称',
  `apply_dr_code` varchar(50) DEFAULT NULL COMMENT '申请医生工号',
  `apply_dr_name` varchar(50) DEFAULT NULL COMMENT '申请医生姓名',
  `execute_date` datetime DEFAULT NULL COMMENT '执行日期',
  `picture` varchar(500) DEFAULT NULL COMMENT '图片（jpg）',
  `picture_web` varchar(500) DEFAULT NULL COMMENT '图片（jpg）',
  `exam_result` varchar(1000) DEFAULT NULL COMMENT '检查结果（客观所见）',
  `exam_description` varchar(500) DEFAULT NULL COMMENT '检查描述（主观提示）',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `note` varchar(500) DEFAULT NULL COMMENT '备注',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`requisition_no`) USING BTREE,
  UNIQUE KEY `report_no_organ_code` (`report_no`,`organ_code`) USING BTREE,
  KEY `IDX_REQUISITION_NO` (`requisition_no`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE,
  KEY `IDX_PATIENT_MAIN_ID` (`patient_main_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='检查报告';

-- ----------------------------
-- Table structure for examine_library
-- ----------------------------
DROP TABLE IF EXISTS `examine_library`;
CREATE TABLE `examine_library` (
  `id` varchar(32) NOT NULL DEFAULT '0' COMMENT '主键',
  `test_item_detail_index_no` varchar(15) DEFAULT NULL COMMENT '检验项目明细索引号',
  `test_group_item_code` char(200) DEFAULT NULL COMMENT '检验组合项目代码',
  `test_group_item_name` char(255) DEFAULT NULL COMMENT '检验组合项目名称',
  `test_item_detail_code` varchar(50) DEFAULT NULL COMMENT '检验项目明细代码',
  `test_item_detail_name` varchar(500) DEFAULT NULL COMMENT '检验项目明细名称',
  `reference_ranges` varchar(200) DEFAULT NULL COMMENT '参考范围',
  `reference_upper_limit` varchar(200) DEFAULT NULL COMMENT '参考上限',
  `reference_lower_limit` varchar(200) DEFAULT NULL COMMENT '参考下限',
  `pinyin_code` varchar(50) DEFAULT NULL COMMENT '拼音码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `unit` varchar(200) DEFAULT NULL COMMENT '单位',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `flag` tinyint(1) DEFAULT NULL COMMENT '0：小项 1:大项',
  `relation_type` int DEFAULT NULL COMMENT '1:适用于智宣教',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='检验项目明细字典';

-- ----------------------------
-- Table structure for examine_library_copy1
-- ----------------------------
DROP TABLE IF EXISTS `examine_library_copy1`;
CREATE TABLE `examine_library_copy1` (
  `id` varchar(32) NOT NULL DEFAULT '0' COMMENT '主键',
  `test_item_detail_index_no` varchar(15) DEFAULT NULL COMMENT '检验项目明细索引号',
  `test_group_item_code` char(200) DEFAULT NULL COMMENT '检验组合项目代码',
  `test_group_item_name` char(200) DEFAULT NULL COMMENT '检验组合项目名称',
  `test_item_detail_code` varchar(50) DEFAULT NULL COMMENT '检验项目明细代码',
  `test_item_detail_name` varchar(32) DEFAULT NULL COMMENT '检验项目明细名称',
  `reference_ranges` varchar(200) DEFAULT NULL COMMENT '参考范围',
  `reference_upper_limit` varchar(200) DEFAULT NULL COMMENT '参考上限',
  `reference_lower_limit` varchar(200) DEFAULT NULL COMMENT '参考下限',
  `pinyin_code` varchar(50) DEFAULT NULL COMMENT '拼音码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `unit` varchar(200) DEFAULT NULL COMMENT '单位',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `flag` tinyint(1) DEFAULT NULL COMMENT '0：小项 1:大项',
  `relation_type` int DEFAULT NULL COMMENT '1:适用于智宣教',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='检验项目明细字典';

-- ----------------------------
-- Table structure for examine_library_h
-- ----------------------------
DROP TABLE IF EXISTS `examine_library_h`;
CREATE TABLE `examine_library_h` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `test_item_detail_index_no` varchar(15) DEFAULT NULL COMMENT '检验项目明细索引号',
  `test_group_item_code` char(200) DEFAULT NULL COMMENT '检验组合项目代码',
  `test_group_item_name` char(200) DEFAULT NULL COMMENT '检验组合项目名称',
  `test_item_detail_code` varchar(50) DEFAULT NULL COMMENT '检验项目明细代码',
  `test_item_detail_name` varchar(120) DEFAULT NULL COMMENT '检验项目明细名称',
  `reference_ranges` varchar(200) DEFAULT NULL COMMENT '参考范围',
  `reference_upper_limit` varchar(200) DEFAULT NULL COMMENT '参考上限',
  `reference_lower_limit` varchar(200) DEFAULT NULL COMMENT '参考下限',
  `pinyin_code` varchar(50) DEFAULT NULL COMMENT '拼音码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `unit` varchar(200) DEFAULT NULL COMMENT '单位',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '机构代码',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `flag` int DEFAULT NULL COMMENT '0：小项 1:大项',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_examine_name_h` (`test_item_detail_name`) USING BTREE,
  KEY `idx_examine_code_h` (`test_item_detail_code`) USING BTREE,
  KEY `code` (`test_item_detail_code`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='检验项目明细字典';

-- ----------------------------
-- Table structure for examine_library_h_copy1
-- ----------------------------
DROP TABLE IF EXISTS `examine_library_h_copy1`;
CREATE TABLE `examine_library_h_copy1` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `test_item_detail_index_no` varchar(15) DEFAULT NULL COMMENT '检验项目明细索引号',
  `test_group_item_code` char(200) DEFAULT NULL COMMENT '检验组合项目代码',
  `test_group_item_name` char(200) DEFAULT NULL COMMENT '检验组合项目名称',
  `test_item_detail_code` varchar(50) DEFAULT NULL COMMENT '检验项目明细代码',
  `test_item_detail_name` varchar(32) DEFAULT NULL COMMENT '检验项目明细名称',
  `reference_ranges` varchar(200) DEFAULT NULL COMMENT '参考范围',
  `reference_upper_limit` varchar(200) DEFAULT NULL COMMENT '参考上限',
  `reference_lower_limit` varchar(200) DEFAULT NULL COMMENT '参考下限',
  `pinyin_code` varchar(50) DEFAULT NULL COMMENT '拼音码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `unit` varchar(200) DEFAULT NULL COMMENT '单位',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `flag` tinyint(1) DEFAULT NULL COMMENT '0：小项 1:大项',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`test_item_detail_code`,`hosp_code`) USING BTREE,
  KEY `idx_examine_name_h` (`test_item_detail_name`) USING BTREE,
  KEY `idx_examine_code_h` (`test_item_detail_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='检验项目明细字典';

-- ----------------------------
-- Table structure for examine_library_map
-- ----------------------------
DROP TABLE IF EXISTS `examine_library_map`;
CREATE TABLE `examine_library_map` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` text,
  `hosp_examine_code` text,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for examine_library_map_revert
-- ----------------------------
DROP TABLE IF EXISTS `examine_library_map_revert`;
CREATE TABLE `examine_library_map_revert` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` text,
  `hosp_examine_code` text,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for form
-- ----------------------------
DROP TABLE IF EXISTS `form`;
CREATE TABLE `form` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型 1,基础库 2,医院库',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `form_id` varchar(32) NOT NULL COMMENT '历次编辑不变的ID',
  `form_version` decimal(7,1) NOT NULL COMMENT '表单升级版本号',
  `form_title` varchar(100) DEFAULT NULL COMMENT '表单标题',
  `begin_content` varchar(500) DEFAULT NULL COMMENT '表单开始语',
  `end_content` varchar(500) DEFAULT NULL COMMENT '表单结束语',
  `form_business_type` int NOT NULL COMMENT '表单业务类型(1, 随访表单  2, 满意度表单)',
  `form_prop` int NOT NULL COMMENT '表单属性(1, 普通表单 2, 分值表单)',
  `form_count` int DEFAULT NULL COMMENT '题目数量',
  `form_desc` varchar(500) DEFAULT NULL COMMENT '表单说明/应用场景说明',
  `update_desc` varchar(500) DEFAULT NULL COMMENT '表单升级说明',
  `form_json` mediumtext,
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `single_codes` varchar(2048) DEFAULT NULL COMMENT '关联单题(逗号分隔)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `source` varchar(128) DEFAULT NULL COMMENT '来源',
  `form_type` int DEFAULT NULL,
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `pat_source` varchar(20) DEFAULT NULL COMMENT '来源',
  `pat_source_name` varchar(100) DEFAULT NULL COMMENT '来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `synch_hosp_flag` int DEFAULT NULL,
  `scene_id` varchar(32) DEFAULT NULL COMMENT 'AI场景id',
  `scene_name` varchar(200) DEFAULT NULL COMMENT 'AI场景的名称',
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `evaluation_type` varchar(32) DEFAULT '0' COMMENT '评估类别',
  `is_coach_form` int DEFAULT '0' COMMENT '是否是教练式问卷 0-否 1-是',
  `label_codes_old` varchar(300) DEFAULT NULL,
  `label_names_old` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `form_id` (`hosp_code`,`form_id`) USING BTREE,
  KEY `time` (`update_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='是否是教练式问卷 0-否 1-是';

-- ----------------------------
-- Table structure for form_cloud
-- ----------------------------
DROP TABLE IF EXISTS `form_cloud`;
CREATE TABLE `form_cloud` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型 1,基础库 2,医院库',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `form_id` varchar(32) NOT NULL COMMENT '历次编辑不变的ID',
  `form_version` decimal(7,1) NOT NULL COMMENT '表单升级版本号',
  `form_title` varchar(100) DEFAULT NULL COMMENT '表单标题',
  `begin_content` varchar(500) DEFAULT NULL COMMENT '表单开始语',
  `end_content` varchar(500) DEFAULT NULL COMMENT '表单结束语',
  `form_business_type` int NOT NULL COMMENT '表单业务类型(1, 随访表单  2, 满意度表单)',
  `form_prop` int NOT NULL COMMENT '表单属性(1, 普通表单 2, 分值表单)',
  `form_count` int DEFAULT NULL COMMENT '题目数量',
  `form_desc` varchar(500) DEFAULT NULL COMMENT '表单说明/应用场景说明',
  `update_desc` varchar(500) DEFAULT NULL COMMENT '表单升级说明',
  `form_json` mediumtext,
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` text,
  `diag_names` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `single_codes` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '关联单题(逗号分隔)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `source` varchar(128) DEFAULT NULL COMMENT '来源',
  `form_type` int DEFAULT NULL,
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `pat_source` varchar(20) DEFAULT NULL COMMENT '来源',
  `pat_source_name` varchar(100) DEFAULT NULL COMMENT '来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `synch_hosp_flag` int DEFAULT NULL,
  `scene_id` varchar(32) DEFAULT NULL COMMENT 'AI场景id',
  `scene_name` varchar(200) DEFAULT NULL COMMENT 'AI场景的名称',
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `evaluation_type` varchar(32) DEFAULT '0' COMMENT '评估类别',
  `is_coach_form` int DEFAULT '0' COMMENT '是否是教练式问卷 0-否 1-是',
  `creator_name` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `content_label_code` varchar(800) DEFAULT NULL COMMENT '内容标签',
  `content_label_name` varchar(800) DEFAULT NULL COMMENT '内容标签',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `label_codes_old` varchar(300) DEFAULT NULL,
  `label_names_old` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `form_id` (`hosp_code`,`form_id`) USING BTREE,
  KEY `time` (`update_time`),
  KEY `_datatype` (`data_type`) USING BTREE,
  KEY `delete_` (`is_delete_cloud`) USING BTREE,
  KEY `delete_c` (`is_delete`) USING BTREE,
  KEY `ver` (`form_version`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='是否是教练式问卷 0-否 1-是';

-- ----------------------------
-- Table structure for form_cloud_back20240321
-- ----------------------------
DROP TABLE IF EXISTS `form_cloud_back20240321`;
CREATE TABLE `form_cloud_back20240321` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型 1,基础库 2,医院库',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `form_id` varchar(32) NOT NULL COMMENT '历次编辑不变的ID',
  `form_version` decimal(7,1) NOT NULL COMMENT '表单升级版本号',
  `form_title` varchar(100) DEFAULT NULL COMMENT '表单标题',
  `begin_content` varchar(1000) DEFAULT NULL COMMENT '表单开始语',
  `end_content` varchar(500) DEFAULT NULL COMMENT '表单结束语',
  `form_business_type` int NOT NULL COMMENT '表单业务类型(1, 随访表单  2, 满意度表单)',
  `form_prop` int NOT NULL COMMENT '表单属性(1, 普通表单 2, 分值表单)',
  `form_count` int DEFAULT NULL COMMENT '题目数量',
  `form_desc` varchar(500) DEFAULT NULL COMMENT '表单说明/应用场景说明',
  `update_desc` varchar(500) DEFAULT NULL COMMENT '表单升级说明',
  `form_json` mediumtext,
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(1500) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(1500) DEFAULT NULL COMMENT '关联疾病名称',
  `single_codes` varchar(2048) DEFAULT NULL COMMENT '关联单题(逗号分隔)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `source` varchar(128) DEFAULT NULL COMMENT '来源',
  `form_type` int DEFAULT NULL,
  `dept_codes` varchar(1000) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `pat_source` varchar(20) DEFAULT NULL COMMENT '来源',
  `pat_source_name` varchar(100) DEFAULT NULL COMMENT '来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `synch_hosp_flag` int DEFAULT NULL,
  `scene_id` varchar(32) DEFAULT NULL,
  `scene_name` varchar(200) DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `evaluation_type` varchar(20) DEFAULT NULL,
  `is_coach_form` int DEFAULT '0' COMMENT '是否是教练式问卷 0-否 1-是',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `content_label_code` varchar(800) DEFAULT NULL COMMENT '内容标签',
  `content_label_name` varchar(800) DEFAULT NULL COMMENT '内容标签',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `label_codes_old` varchar(300) DEFAULT NULL,
  `label_names_old` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='是否是教练式问卷 0-否 1-是';

-- ----------------------------
-- Table structure for form_content_remark
-- ----------------------------
DROP TABLE IF EXISTS `form_content_remark`;
CREATE TABLE `form_content_remark` (
  `id` varchar(32) NOT NULL,
  `form_id` varchar(32) DEFAULT NULL COMMENT '表单form_id',
  `content_id` varchar(32) DEFAULT NULL COMMENT '内容id',
  `content_type` int DEFAULT NULL COMMENT '内容类型 0-题目 1-答案',
  `parent_content_id` varchar(32) DEFAULT NULL COMMENT '上级内容id',
  `remark` varchar(500) DEFAULT NULL COMMENT '内容备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `remark_type` int DEFAULT NULL COMMENT '0-表单小结 1-访后小结',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单备注表';

-- ----------------------------
-- Table structure for form_content_remark_cloud
-- ----------------------------
DROP TABLE IF EXISTS `form_content_remark_cloud`;
CREATE TABLE `form_content_remark_cloud` (
  `id` varchar(32) NOT NULL,
  `form_id` varchar(32) DEFAULT NULL COMMENT '表单form_id',
  `content_id` varchar(32) DEFAULT NULL COMMENT '内容id',
  `content_type` int DEFAULT NULL COMMENT '内容类型 0-题目 1-答案',
  `parent_content_id` varchar(32) DEFAULT NULL COMMENT '上级内容id',
  `remark` varchar(500) DEFAULT NULL COMMENT '内容备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `remark_type` int DEFAULT NULL COMMENT '0-表单小结 1-访后小结',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单备注表';

-- ----------------------------
-- Table structure for form_export
-- ----------------------------
DROP TABLE IF EXISTS `form_export`;
CREATE TABLE `form_export` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型 1,基础库 2,医院库',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `form_id` varchar(32) NOT NULL COMMENT '历次编辑不变的ID',
  `form_version` decimal(7,1) NOT NULL COMMENT '表单升级版本号',
  `form_title` varchar(100) DEFAULT NULL COMMENT '表单标题',
  `begin_content` varchar(500) DEFAULT NULL COMMENT '表单开始语',
  `end_content` varchar(500) DEFAULT NULL COMMENT '表单结束语',
  `form_business_type` int NOT NULL COMMENT '表单业务类型(1, 随访表单  2, 满意度表单)',
  `form_prop` int NOT NULL COMMENT '表单属性(1, 普通表单 2, 分值表单)',
  `form_count` int DEFAULT NULL COMMENT '题目数量',
  `form_desc` varchar(500) DEFAULT NULL COMMENT '表单说明/应用场景说明',
  `update_desc` varchar(500) DEFAULT NULL COMMENT '表单升级说明',
  `form_json` mediumtext,
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `single_codes` varchar(2048) DEFAULT NULL COMMENT '关联单题(逗号分隔)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `source` varchar(128) DEFAULT NULL COMMENT '来源',
  `form_type` int DEFAULT NULL,
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `pat_source` varchar(20) DEFAULT NULL COMMENT '来源',
  `pat_source_name` varchar(100) DEFAULT NULL COMMENT '来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `synch_hosp_flag` int DEFAULT NULL,
  `scene_id` varchar(32) DEFAULT NULL,
  `scene_name` varchar(200) DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `evaluation_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_id` (`hosp_code`,`form_id`),
  KEY `time` (`update_time`),
  KEY `is_delete` (`is_delete`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单';

-- ----------------------------
-- Table structure for form_judg
-- ----------------------------
DROP TABLE IF EXISTS `form_judg`;
CREATE TABLE `form_judg` (
  `id` varchar(32) NOT NULL,
  `form_id` varchar(32) DEFAULT NULL COMMENT '表单主键',
  `judg_json` mediumtext COMMENT '表单总结json',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `const_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单总结';

-- ----------------------------
-- Table structure for form_judg_cloud
-- ----------------------------
DROP TABLE IF EXISTS `form_judg_cloud`;
CREATE TABLE `form_judg_cloud` (
  `id` varchar(32) NOT NULL,
  `form_id` varchar(32) DEFAULT NULL COMMENT '表单主键',
  `judg_json` mediumtext COMMENT '表单总结json',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `const_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单总结';

-- ----------------------------
-- Table structure for form_quote
-- ----------------------------
DROP TABLE IF EXISTS `form_quote`;
CREATE TABLE `form_quote` (
  `form_id` varchar(32) NOT NULL COMMENT 'form_id',
  `form_title` varchar(255) DEFAULT NULL COMMENT 'form标题',
  `quote_form_id` varchar(32) NOT NULL COMMENT '被引用的form的id',
  `quote_form_title` varchar(200) DEFAULT NULL COMMENT '被引用的form的标题',
  `hosp_code` varchar(255) DEFAULT NULL COMMENT '机构代码',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for form_quote_cloud
-- ----------------------------
DROP TABLE IF EXISTS `form_quote_cloud`;
CREATE TABLE `form_quote_cloud` (
  `form_id` varchar(32) NOT NULL COMMENT 'form_id',
  `form_title` varchar(255) DEFAULT NULL COMMENT 'form标题',
  `quote_form_id` varchar(32) NOT NULL COMMENT '被引用的form的id',
  `quote_form_title` varchar(200) DEFAULT NULL COMMENT '被引用的form的标题',
  `hosp_code` varchar(255) DEFAULT NULL COMMENT '机构代码',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for form_single
-- ----------------------------
DROP TABLE IF EXISTS `form_single`;
CREATE TABLE `form_single` (
  `id` varchar(32) NOT NULL,
  `single_title` varchar(50) NOT NULL COMMENT '单题标题',
  `single_type` int NOT NULL COMMENT '题目类型(1:文本描述题(单行) 2:单选题 3:多选题 4:矩阵题(主题目) 5:矩阵题(副题目) 6:分值单选题 7:填空题(主题目) 8:填空题(副题目) 9:图文单选题 10:下拉题 11:日期 12:手机 13:图片 14:文本描述题(多行) 15:图文多选题)',
  `single_json` text COMMENT '单题整体json串，需增加题目补充说明字段以及表单升级说明字段',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(500) DEFAULT NULL COMMENT '编辑人姓名',
  `label_codes` varchar(500) DEFAULT NULL COMMENT '随访要点',
  `label_names` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '删除标识，0：启用状态，1：停用状态 2:暂存',
  `reference_count` int DEFAULT '0' COMMENT '引用数',
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `surgery_codes` varchar(150) DEFAULT NULL COMMENT '手术编码',
  `surgery_names` varchar(500) DEFAULT NULL COMMENT '手术名称',
  `check_codes` varchar(150) DEFAULT NULL COMMENT '检查编码',
  `check_names` varchar(500) DEFAULT NULL COMMENT '检查名称',
  `examine_codes` varchar(150) DEFAULT NULL COMMENT '检验编码',
  `examine_names` varchar(500) DEFAULT NULL COMMENT '检验名称',
  `single_id` varchar(32) DEFAULT NULL COMMENT '题目id（不变）',
  `single_version` decimal(7,1) DEFAULT NULL COMMENT '题目版本',
  `is_enable` int DEFAULT NULL COMMENT '0:启用状态 1：停用 2:暂存',
  `drug_codes` varchar(150) DEFAULT NULL COMMENT '药品编码',
  `drug_names` varchar(500) DEFAULT NULL COMMENT '药品名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单单题';

-- ----------------------------
-- Table structure for form_single_copy
-- ----------------------------
DROP TABLE IF EXISTS `form_single_copy`;
CREATE TABLE `form_single_copy` (
  `id` varchar(32) NOT NULL,
  `single_title` varchar(50) NOT NULL COMMENT '单题标题',
  `single_type` int NOT NULL COMMENT '题目类型(1:文本描述题(单行) 2:单选题 3:多选题 4:矩阵题(主题目) 5:矩阵题(副题目) 6:分值单选题 7:填空题(主题目) 8:填空题(副题目) 9:图文单选题 10:下拉题 11:日期 12:手机 13:图片 14:文本描述题(多行) 15:图文多选题)',
  `single_json` text COMMENT '单题整体json串，需增加题目补充说明字段以及表单升级说明字段',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(500) DEFAULT NULL COMMENT '编辑人姓名',
  `label_codes` varchar(500) DEFAULT NULL COMMENT '随访要点',
  `label_names` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '删除标识，0：启用状态，1：停用状态 2:暂存',
  `reference_count` int DEFAULT '0' COMMENT '引用数',
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `surgery_codes` varchar(150) DEFAULT NULL COMMENT '手术编码',
  `surgery_names` varchar(500) DEFAULT NULL COMMENT '手术名称',
  `check_codes` varchar(150) DEFAULT NULL COMMENT '检查编码',
  `check_names` varchar(500) DEFAULT NULL COMMENT '检查名称',
  `examine_codes` varchar(150) DEFAULT NULL COMMENT '检验编码',
  `examine_names` varchar(500) DEFAULT NULL COMMENT '检验名称',
  `single_id` varchar(32) DEFAULT NULL COMMENT '题目id（不变）',
  `single_version` decimal(7,1) DEFAULT NULL COMMENT '题目版本',
  `is_enable` int DEFAULT NULL COMMENT '0:启用状态 1：停用 2:暂存',
  `drug_codes` varchar(150) DEFAULT NULL COMMENT '药品编码',
  `drug_names` varchar(500) DEFAULT NULL COMMENT '药品名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单单题';

-- ----------------------------
-- Table structure for form_single_form_relation
-- ----------------------------
DROP TABLE IF EXISTS `form_single_form_relation`;
CREATE TABLE `form_single_form_relation` (
  `id` varchar(32) NOT NULL,
  `form_key_id` varchar(32) NOT NULL COMMENT '表单id',
  `form_id` varchar(32) NOT NULL COMMENT '表单formId',
  `single_id` varchar(32) NOT NULL COMMENT '单题id',
  `single_key_id` varchar(32) NOT NULL COMMENT '单题主键id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for form_single_form_relation_cloud
-- ----------------------------
DROP TABLE IF EXISTS `form_single_form_relation_cloud`;
CREATE TABLE `form_single_form_relation_cloud` (
  `id` varchar(32) NOT NULL,
  `form_key_id` varchar(32) NOT NULL COMMENT '表单id',
  `form_id` varchar(32) NOT NULL COMMENT '表单formId',
  `single_id` varchar(32) NOT NULL COMMENT '单题id',
  `single_key_id` varchar(32) NOT NULL COMMENT '单题主键id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for form_single_group
-- ----------------------------
DROP TABLE IF EXISTS `form_single_group`;
CREATE TABLE `form_single_group` (
  `id` varchar(32) NOT NULL,
  `single_group_title` varchar(50) NOT NULL COMMENT '单题组标题',
  `single_group_json` mediumtext COMMENT '单题组整体json串，需增加题目补充说明字段以及表单升级说明字段',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `label_codes` varchar(500) DEFAULT NULL COMMENT '随访要点',
  `label_names` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：启用状态，1：停用状态 2:暂存',
  `reference_count` int DEFAULT '0' COMMENT '引用数',
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `surgery_codes` varchar(150) DEFAULT NULL COMMENT '手术编码',
  `surgery_names` varchar(500) DEFAULT NULL COMMENT '手术名称',
  `check_codes` varchar(150) DEFAULT NULL COMMENT '检查编码',
  `check_names` varchar(500) DEFAULT NULL COMMENT '检查名称',
  `examine_codes` varchar(150) DEFAULT NULL COMMENT '检验编码',
  `examine_names` varchar(500) DEFAULT NULL COMMENT '检验名称',
  `single_count` int DEFAULT NULL COMMENT '单题数量',
  `drug_codes` varchar(150) DEFAULT NULL COMMENT '药品编码',
  `drug_names` varchar(500) DEFAULT NULL COMMENT '药品名称',
  `jump_type` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for form_single_group_form_relation
-- ----------------------------
DROP TABLE IF EXISTS `form_single_group_form_relation`;
CREATE TABLE `form_single_group_form_relation` (
  `id` varchar(32) NOT NULL,
  `form_id` varchar(32) NOT NULL COMMENT '表单formId',
  `form_key_id` varchar(32) NOT NULL COMMENT '表单主键',
  `form_single_group_id` varchar(32) NOT NULL COMMENT '单题组id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for form_single_group_form_relation_cloud
-- ----------------------------
DROP TABLE IF EXISTS `form_single_group_form_relation_cloud`;
CREATE TABLE `form_single_group_form_relation_cloud` (
  `id` varchar(32) NOT NULL,
  `form_id` varchar(32) NOT NULL COMMENT '表单formId',
  `form_key_id` varchar(32) NOT NULL COMMENT '表单主键',
  `form_single_group_id` varchar(32) NOT NULL COMMENT '单题组id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for form_single_group_relation
-- ----------------------------
DROP TABLE IF EXISTS `form_single_group_relation`;
CREATE TABLE `form_single_group_relation` (
  `id` varchar(32) NOT NULL,
  `single_group_id` varchar(32) NOT NULL COMMENT '单题组id',
  `single_id` varchar(32) NOT NULL COMMENT '单题id',
  `single_key_id` varchar(32) NOT NULL COMMENT '单题主键id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for h_dept_library_mapping
-- ----------------------------
DROP TABLE IF EXISTS `h_dept_library_mapping`;
CREATE TABLE `h_dept_library_mapping` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室编码',
  `dept_name` varchar(200) DEFAULT NULL COMMENT '科室名称',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `hosp_name` varchar(200) DEFAULT NULL COMMENT '医院名称',
  `dept_type` int DEFAULT NULL COMMENT '科室类型',
  `dept_status` int DEFAULT NULL COMMENT '科室状态',
  `real_dept_name` varchar(200) DEFAULT NULL COMMENT '科室实际名称',
  `area` varchar(800) DEFAULT NULL COMMENT '院区',
  `mapper_dept_name` varchar(200) DEFAULT NULL COMMENT '匹配科室',
  `mapper_child_dept_name` varchar(3000) DEFAULT NULL COMMENT '匹配二级科室',
  `mapper_dept_code` varchar(200) DEFAULT NULL COMMENT '匹配科室',
  `mapper_child_dept_code` varchar(2000) DEFAULT NULL COMMENT '匹配二级科室',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='科室匹配';

-- ----------------------------
-- Table structure for hosp_system
-- ----------------------------
DROP TABLE IF EXISTS `hosp_system`;
CREATE TABLE `hosp_system` (
  `hosp_code` varchar(255) NOT NULL,
  `system_type` int NOT NULL COMMENT '系统标记 0、随访 1、慢病',
  `is_cloud` int NOT NULL DEFAULT '0' COMMENT '健管云医院标记0、否 1、是'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for hosp_unmapped
-- ----------------------------
DROP TABLE IF EXISTS `hosp_unmapped`;
CREATE TABLE `hosp_unmapped` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(30) NOT NULL COMMENT '医院编码',
  `dictionary_type_code` varchar(5) NOT NULL,
  `dictionary_type_name` varchar(5) DEFAULT NULL,
  `yun_id` varchar(32) DEFAULT NULL,
  `yun_codes` varchar(32) NOT NULL,
  `yun_names` varchar(200) DEFAULT NULL,
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联id',
  `relation_name` varchar(255) DEFAULT NULL COMMENT '关联名称',
  `relation_type` int DEFAULT NULL COMMENT '1:适用于317宣教场景',
  PRIMARY KEY (`id`),
  UNIQUE KEY `hosp_type_code` (`hosp_code`,`dictionary_type_code`,`yun_codes`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for index_data
-- ----------------------------
DROP TABLE IF EXISTS `index_data`;
CREATE TABLE `index_data` (
  `id` varchar(32) NOT NULL,
  `selected_index` varchar(1000) DEFAULT NULL COMMENT '已选中的疾病指标编码，逗号分隔，如tnb,gxy',
  `archive_id` varchar(32) DEFAULT NULL COMMENT '档案id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for inhosp_order
-- ----------------------------
DROP TABLE IF EXISTS `inhosp_order`;
CREATE TABLE `inhosp_order` (
  `order_no` varchar(50) NOT NULL,
  `organ_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pat_index_no` varchar(50) DEFAULT NULL COMMENT '患者索引号',
  `inhosp_no` varchar(50) DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '住院流水号',
  `order_group_no` varchar(50) DEFAULT NULL COMMENT '医嘱组号',
  `order_plan_begin_date` datetime DEFAULT NULL COMMENT '医嘱计划开始日期',
  `order_plan_end_date` datetime DEFAULT NULL COMMENT '医嘱计划结束日期',
  `order_begin_date` datetime DEFAULT NULL COMMENT '医嘱开始日期',
  `order_end_date` datetime DEFAULT NULL COMMENT '医嘱结束日期',
  `order_order_date` datetime DEFAULT NULL COMMENT '医嘱开立日期',
  `order_open_dept_code` varchar(50) DEFAULT NULL COMMENT '医嘱开立科室代码',
  `order_open_dept_name` varchar(50) DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(50) DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(50) DEFAULT NULL COMMENT '医嘱开立医生姓名',
  `order_execute_date` datetime DEFAULT NULL COMMENT '医嘱执行日期',
  `order_categ_code` varchar(50) DEFAULT NULL COMMENT '医嘱类别代码',
  `order_categ_name` varchar(50) DEFAULT NULL COMMENT '医嘱类别名称',
  `order_item_code` varchar(50) DEFAULT NULL COMMENT '医嘱项目代码',
  `order_item_name` varchar(50) DEFAULT NULL COMMENT '医嘱项目名称',
  `drug_code` varchar(50) DEFAULT NULL COMMENT '药品代码',
  `drug_name` varchar(50) DEFAULT NULL COMMENT '药品名称',
  `drug_specifications` varchar(50) DEFAULT NULL COMMENT '药品规格',
  `dose_way_code` varchar(50) DEFAULT NULL COMMENT '用药途径代码',
  `dose_way_name` varchar(50) DEFAULT NULL COMMENT '用药途径名称',
  `drug_use_one_dosage` varchar(50) DEFAULT NULL COMMENT '药品使用次剂量',
  `drug_use_one_dosage_unit` varchar(50) DEFAULT NULL COMMENT '药品使用次剂量单位',
  `drug_use_frequency_code` varchar(50) DEFAULT NULL COMMENT '药品使用频次代码',
  `drug_use_frequency_name` varchar(50) DEFAULT NULL COMMENT '药品使用频次名称',
  `drug_form_code` varchar(50) DEFAULT NULL COMMENT '药品剂型代码',
  `drug_form_name` varchar(50) DEFAULT NULL COMMENT '药品剂型名称',
  `drug_unit` varchar(50) DEFAULT NULL COMMENT '药品单位',
  `drug_unit_price` varchar(50) DEFAULT NULL COMMENT '药品单价',
  `drug_abbrev` varchar(50) DEFAULT NULL COMMENT '药品简称',
  `drug_descr` varchar(500) DEFAULT NULL COMMENT '药品描述',
  `drug_amount` varchar(50) DEFAULT NULL COMMENT '药品数量',
  `order_duration` int DEFAULT NULL COMMENT '医嘱持续时间',
  `order_duration_unit` varchar(50) DEFAULT NULL COMMENT '医嘱持续时间单位',
  `base_aux_drug_flag` varchar(50) DEFAULT NULL COMMENT '主副药标志',
  `dr_entrust` varchar(500) DEFAULT NULL COMMENT '医生嘱托',
  `note` varchar(500) DEFAULT NULL COMMENT '备注',
  `order_item_type_code` varchar(10) DEFAULT NULL,
  `order_item_type_name` varchar(50) DEFAULT NULL,
  `discharge_order_flag` varchar(10) DEFAULT NULL,
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`order_no`) USING BTREE,
  KEY `IDX_INHOSP_SERIAL_NO` (`inhosp_serial_no`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE,
  KEY `IDX_PATIENT_MAIN_ID` (`patient_main_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='住院医嘱';

-- ----------------------------
-- Table structure for inhosp_record
-- ----------------------------
DROP TABLE IF EXISTS `inhosp_record`;
CREATE TABLE `inhosp_record` (
  `inhosp_serial_no` varchar(50) NOT NULL,
  `organ_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pat_index_no` varchar(50) DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(50) DEFAULT NULL COMMENT '就诊卡号',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '患者姓名',
  `sex_code` varchar(50) DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(50) DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `inhosp_no` varchar(50) DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `ward_code` varchar(50) DEFAULT NULL COMMENT '病区代码',
  `ward_name` varchar(50) DEFAULT NULL COMMENT '病区名称',
  `sickroom_no` varchar(50) DEFAULT NULL COMMENT '病房号',
  `bed_no` varchar(50) DEFAULT NULL COMMENT '病床号',
  `admit_date` datetime DEFAULT NULL COMMENT '入院日期',
  `admit_situation` varchar(100) DEFAULT NULL COMMENT '入院情况',
  `admit_way_code` varchar(50) DEFAULT NULL COMMENT '入院途径代码',
  `admit_way_name` varchar(50) DEFAULT NULL COMMENT '入院途径名称',
  `pat_chief_descr` varchar(100) DEFAULT NULL COMMENT '患者主诉',
  `brief_disease_situation` varchar(100) DEFAULT NULL COMMENT '简要病情',
  `treat_plan` varchar(100) DEFAULT NULL COMMENT '诊疗计划',
  `past_disease_history_descr` varchar(100) DEFAULT NULL COMMENT '既往史描述',
  `disease_history` varchar(100) DEFAULT NULL COMMENT '疾病史',
  `surgery_history` varchar(100) DEFAULT NULL COMMENT '手术史',
  `metachysis_history` varchar(100) DEFAULT NULL COMMENT '输血史',
  `infect_disease_history` varchar(100) DEFAULT NULL COMMENT '传染病史',
  `admit_diag_code` varchar(100) DEFAULT NULL COMMENT '入院诊断代码',
  `admit_diag_name` varchar(100) DEFAULT NULL COMMENT '入院诊断名称',
  `recept_treat_dr_code` varchar(100) DEFAULT NULL COMMENT '接诊医师工号',
  `recept_treat_dr_name` varchar(100) DEFAULT NULL COMMENT '接诊医师姓名',
  `inhosp_dr_code` varchar(100) DEFAULT NULL COMMENT '住院医师工号',
  `inhosp_dr_name` varchar(100) DEFAULT NULL COMMENT '住院医师姓名',
  `attend_dr_code` varchar(100) DEFAULT NULL COMMENT '主治医师工号',
  `attend_dr_name` varchar(100) DEFAULT NULL COMMENT '主治医师姓名',
  `chief_dr_code` varchar(100) DEFAULT NULL COMMENT '主任医师工号',
  `chief_dr_name` varchar(100) DEFAULT NULL COMMENT '主任医师姓名',
  `nursing_level_code` varchar(100) DEFAULT NULL COMMENT '护理等级代码',
  `nursing_level_name` varchar(100) DEFAULT NULL COMMENT '护理等级名称',
  `primary_nurse_code` varchar(100) DEFAULT NULL COMMENT '责任护士工号',
  `primary_nurse_name` varchar(100) DEFAULT NULL COMMENT '责任护士姓名',
  `treat_process_descr` varchar(100) DEFAULT NULL COMMENT '诊疗过程描述',
  `discharge_status` varchar(100) DEFAULT NULL COMMENT '出院情况',
  `discharge_date` datetime DEFAULT NULL COMMENT '出院日期时间',
  `discharge_diag_code` varchar(100) DEFAULT NULL COMMENT '出院诊断代码',
  `discharge_diag_name` varchar(100) DEFAULT NULL COMMENT '出院诊断名称',
  `discharge_symptom` varchar(100) DEFAULT NULL COMMENT '出院时症状与体征',
  `discharge_order` varchar(100) DEFAULT NULL COMMENT '出院医嘱',
  `outcome` varchar(100) DEFAULT NULL COMMENT '转归情况',
  `discharge_method_code` varchar(100) DEFAULT NULL COMMENT '离院方式代码',
  `discharge_method_name` varchar(100) DEFAULT NULL,
  `mobile_no` varchar(100) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL COMMENT '工作单位',
  `id_number` varchar(30) DEFAULT NULL,
  `allergy_history` varchar(500) DEFAULT NULL,
  `dept_code` varchar(50) DEFAULT NULL,
  `curr_disease_history` varchar(50) DEFAULT NULL,
  `outcome_code` varchar(20) DEFAULT NULL,
  `outcome_name` varchar(20) DEFAULT NULL,
  `physical_exam` varchar(100) DEFAULT NULL COMMENT '体格检查',
  `treatment_advice` varchar(255) DEFAULT NULL COMMENT '处理意见',
  `diseases_reported_flag` varchar(255) DEFAULT NULL COMMENT '疾病报卡标志',
  `pain_flag` varchar(1) DEFAULT NULL COMMENT '疼痛患者标识 1、疼痛患者 2、非疼痛患者（台州中心医院）',
  `surgery_flag` varchar(1) DEFAULT NULL COMMENT '手术患者标识 1、手术患者 2、非手术患者（台州中心医院）',
  `analgesic_flag` varchar(1) DEFAULT NULL COMMENT '使用镇痛棒标识 1、使用镇痛棒 2、未使用镇痛棒（台州中心医院）',
  `cancer_flag` varchar(1) DEFAULT NULL COMMENT '患癌标识 1、患癌 2、未患癌（台州中心医院）',
  `blood_glucose_flag` varchar(1) DEFAULT NULL COMMENT '血糖检测患者标识 1、血糖检测患者 2、非血糖检测患者（台州中心医院）',
  `inhosp_status` varchar(1) DEFAULT NULL COMMENT '1:出院 ，2：在院',
  `birth_flag` varchar(10) DEFAULT NULL COMMENT '分娩标志  1正常、0异常、null非产妇',
  `sync_diag_flag` varchar(10) DEFAULT '0' COMMENT '诊断同步标识，0：未同步，1：已同步',
  `sync_order_flag` varchar(10) DEFAULT '0' COMMENT '医嘱同步标识，0：未同步，1：已同步',
  `sync_fee_flag` varchar(10) DEFAULT '0' COMMENT '费用同步标识，0：未同步，1：已同步',
  `sync_patientinfo_flag` varchar(10) DEFAULT '0' COMMENT '患者信息同步标识，0：未同步，1：已同步',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`inhosp_serial_no`) USING BTREE,
  KEY `IDX_VISIT_CARD_NO` (`visit_card_no`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE,
  KEY `IDX_PATIENT_MAIN_ID` (`patient_main_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='住院记录';

-- ----------------------------
-- Table structure for label_sort
-- ----------------------------
DROP TABLE IF EXISTS `label_sort`;
CREATE TABLE `label_sort` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `sort_code` varchar(50) DEFAULT NULL COMMENT '分类编码',
  `sort_name` varchar(50) DEFAULT NULL COMMENT '分类名称',
  `sort_desc` varchar(255) DEFAULT NULL COMMENT '分类说明',
  `sort_condition` int DEFAULT NULL COMMENT '分类状态 (0：停用 1:启用 )',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `sort_scope` varchar(512) DEFAULT NULL COMMENT '适用范围',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for label_sort_copy1
-- ----------------------------
DROP TABLE IF EXISTS `label_sort_copy1`;
CREATE TABLE `label_sort_copy1` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `sort_code` varchar(50) DEFAULT NULL COMMENT '分类编码',
  `sort_name` varchar(50) DEFAULT NULL COMMENT '分类名称',
  `sort_desc` varchar(255) DEFAULT NULL COMMENT '分类说明',
  `sort_condition` int DEFAULT NULL COMMENT '分类状态 (0：停用 1:启用 )',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `sort_scope` varchar(512) DEFAULT NULL COMMENT '适用范围',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for lf_asr
-- ----------------------------
DROP TABLE IF EXISTS `lf_asr`;
CREATE TABLE `lf_asr` (
  `id` varchar(32) NOT NULL COMMENT '主键id',
  `file_name` varchar(200) DEFAULT NULL COMMENT '录音文件名称',
  `file_path` varchar(200) DEFAULT NULL COMMENT '录音文件路径',
  `file_content` text COMMENT '录音解析内容',
  `error_rate` varchar(20) DEFAULT NULL COMMENT '录音解析错误率，人工比较',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `check_flag` varchar(5) DEFAULT NULL COMMENT '0:未审核 1表示审核',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for library_label_sys
-- ----------------------------
DROP TABLE IF EXISTS `library_label_sys`;
CREATE TABLE `library_label_sys` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `label_code` varchar(50) DEFAULT NULL,
  `label_name` varchar(200) DEFAULT NULL,
  `parent_label_id` bigint DEFAULT NULL,
  `rule` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=237 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for material
-- ----------------------------
DROP TABLE IF EXISTS `material`;
CREATE TABLE `material` (
  `id` varchar(50) NOT NULL DEFAULT '0',
  `material_name` varchar(64) DEFAULT NULL COMMENT '名称',
  `material_type` varchar(255) DEFAULT NULL COMMENT '所属分类',
  `material_label_code` varchar(255) DEFAULT NULL COMMENT '标签编码',
  `material_label_name` varchar(255) DEFAULT NULL COMMENT '标签名称',
  `material_url` varchar(255) DEFAULT NULL COMMENT '素材url',
  `duration` int DEFAULT NULL COMMENT '视频音频时长',
  `cover_url` varchar(255) DEFAULT NULL COMMENT '封面图',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '是否删除0：否1：是',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log` (
  `id` varchar(32) NOT NULL,
  `content_id` varchar(32) DEFAULT NULL COMMENT '内容id',
  `content_name` varchar(1000) DEFAULT NULL COMMENT '内容名称',
  `content_type` int DEFAULT NULL,
  `operation_type` tinyint(1) DEFAULT NULL COMMENT '操作类型，0：新增，1：删除，2：修改，3：暂存',
  `operation_name` varchar(16) DEFAULT NULL COMMENT '操作名称',
  `editor_id` varchar(64) DEFAULT NULL COMMENT '创建人id',
  `editor_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `operation_time` datetime DEFAULT NULL COMMENT '操作时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `operation_remark` varchar(2048) DEFAULT NULL COMMENT '操作备注',
  `update_info` varchar(800) DEFAULT NULL COMMENT '更新内容',
  `update_level` int DEFAULT NULL COMMENT '0一般更新1重要更新',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='操作备注';

-- ----------------------------
-- Table structure for order_detail
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail` (
  `pres_sub_no` varchar(50) NOT NULL,
  `organ_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pres_no` varchar(50) DEFAULT NULL COMMENT '处方号',
  `pres_group_no` varchar(100) DEFAULT NULL COMMENT '处方组号',
  `drug_code` varchar(50) DEFAULT NULL COMMENT '药品代码',
  `drug_name` varchar(50) DEFAULT NULL COMMENT '药品名称',
  `drug_specifications` varchar(50) DEFAULT NULL COMMENT '药品规格',
  `dose_way_code` varchar(50) DEFAULT NULL COMMENT '用药途径代码',
  `dose_way_name` varchar(50) DEFAULT NULL COMMENT '用药途径名称',
  `drug_use_one_dosage` varchar(50) DEFAULT NULL COMMENT '药品使用次剂量',
  `drug_use_one_dosage_unit` varchar(50) DEFAULT NULL COMMENT '药品使用次剂量单位',
  `drug_use_frequency_code` varchar(50) DEFAULT NULL COMMENT '药品使用频次代码',
  `drug_use_frequency_name` varchar(50) DEFAULT NULL COMMENT '药品使用频次名称',
  `drug_form_code` varchar(50) DEFAULT NULL COMMENT '药品剂型代码',
  `drug_form_name` varchar(50) DEFAULT NULL COMMENT '药品剂型名称',
  `drug_unit` varchar(50) DEFAULT NULL COMMENT '药品单位',
  `drug_unit_price` varchar(50) DEFAULT NULL COMMENT '药品单价',
  `drug_abbrev` varchar(50) DEFAULT NULL COMMENT '药品简称',
  `drug_descr` varchar(500) DEFAULT NULL COMMENT '药品描述',
  `pres_sustained_days` varchar(50) DEFAULT NULL COMMENT '处方持续天数',
  `drug_amount` varchar(50) DEFAULT NULL COMMENT '药品数量',
  `base_aux_drug_flag` varchar(50) DEFAULT NULL COMMENT '主副药标志',
  `self_drug_flag` varchar(50) DEFAULT NULL COMMENT '自备药标志',
  `group_flag` varchar(50) DEFAULT NULL COMMENT '成组标志',
  `note` varchar(500) DEFAULT NULL COMMENT '备注',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`pres_sub_no`) USING BTREE,
  KEY `IDX_PRES_NO` (`pres_no`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE,
  KEY `IDX_PATIENT_MAIN_ID` (`patient_main_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='处方明细信息';

-- ----------------------------
-- Table structure for order_info
-- ----------------------------
DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info` (
  `pres_no` varchar(50) NOT NULL,
  `organ_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pat_index_no` varchar(50) DEFAULT NULL COMMENT '患者索引号',
  `outhosp_no` varchar(50) DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '门诊流水号',
  `pres_group_no` varchar(100) DEFAULT NULL COMMENT '处方组号',
  `pres_open_dept_code` varchar(50) DEFAULT NULL COMMENT '处方开立科室代码',
  `pres_open_dept_name` varchar(50) DEFAULT NULL COMMENT '处方开立科室名称',
  `pres_open_dr_code` varchar(50) DEFAULT NULL COMMENT '处方开立医生工号',
  `pres_open_dr_name` varchar(50) DEFAULT NULL COMMENT '处方开立医生姓名',
  `pres_order_date` datetime DEFAULT NULL COMMENT '处方开立日期',
  `pres_begin_date` datetime DEFAULT NULL COMMENT '处方开始日期',
  `pres_end_date` datetime DEFAULT NULL COMMENT '处方结束日期',
  `pres_valid_day` int DEFAULT NULL COMMENT '处方有效天数',
  `pres_item_type_code` varchar(50) DEFAULT NULL COMMENT '处方项目类型代码',
  `pres_item_type_name` varchar(50) DEFAULT NULL COMMENT '处方项目类型名称',
  `pres_categ_code` varchar(50) DEFAULT NULL COMMENT '处方类别代码',
  `pres_categ_name` varchar(50) DEFAULT NULL COMMENT '处方类别名称',
  `pres_item_code` varchar(50) DEFAULT NULL COMMENT '处方项目代码',
  `pres_item_name` varchar(50) DEFAULT NULL COMMENT '处方项目名称',
  `note` varchar(50) DEFAULT NULL COMMENT '备注',
  `charge_flag` varchar(10) DEFAULT NULL,
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `sync_orderdetail_flag` varchar(10) DEFAULT '0' COMMENT '处方明细同步标识，0：未同步，1：已同步',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`pres_no`) USING BTREE,
  KEY `IDX_OUTHOSP_SERIAL_NO` (`outhosp_serial_no`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE,
  KEY `IDX_PATIENT_MAIN_ID` (`patient_main_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='处方信息';

-- ----------------------------
-- Table structure for oss_failure_record
-- ----------------------------
DROP TABLE IF EXISTS `oss_failure_record`;
CREATE TABLE `oss_failure_record` (
  `id` varchar(64) NOT NULL,
  `education_id` varchar(64) DEFAULT NULL COMMENT '宣教ID',
  `name` varchar(128) DEFAULT NULL COMMENT '课程名称',
  `educate_library_id` varchar(128) DEFAULT NULL COMMENT '课程表ID',
  `course_id` bigint DEFAULT NULL,
  `course_content` longtext COMMENT '宣教内容',
  `editor_id` varchar(64) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `temporary_course_id` bigint DEFAULT NULL,
  `new_editor_id` varchar(64) DEFAULT NULL COMMENT '最新更新人id',
  `new_editor_name` varchar(50) DEFAULT NULL COMMENT '最新更新人姓名',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='宣教内容外链处理失败记录';

-- ----------------------------
-- Table structure for over_test
-- ----------------------------
DROP TABLE IF EXISTS `over_test`;
CREATE TABLE `over_test` (
  `test_date` datetime DEFAULT NULL,
  `money` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for pack_detail
-- ----------------------------
DROP TABLE IF EXISTS `pack_detail`;
CREATE TABLE `pack_detail` (
  `id` varchar(32) NOT NULL,
  `pack_id` varchar(50) NOT NULL COMMENT '套餐ID',
  `content_id` varchar(100) DEFAULT NULL COMMENT '内容主键',
  `content_type` int DEFAULT NULL COMMENT '内容类型(1, 表单 2,随访规则 3,方案)',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `rule_id` varchar(50) DEFAULT NULL COMMENT '关联规则id',
  `release_version` int DEFAULT NULL COMMENT '0:正式发布 1：新增 2：删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `pack_detail_content_id_index` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='包详情';

-- ----------------------------
-- Table structure for pack_disease_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `pack_disease_dictionary`;
CREATE TABLE `pack_disease_dictionary` (
  `id` varchar(32) NOT NULL,
  `dictionary_id` varchar(32) DEFAULT NULL COMMENT '字典id',
  `pack_id` varchar(32) DEFAULT NULL COMMENT '路径id',
  `business_meaning` int DEFAULT NULL COMMENT '业务含义 0-基线时间 99-其他',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='路径专病字典';

-- ----------------------------
-- Table structure for pack_hosp_distribution
-- ----------------------------
DROP TABLE IF EXISTS `pack_hosp_distribution`;
CREATE TABLE `pack_hosp_distribution` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院机构代码',
  `content_type` int DEFAULT NULL COMMENT '内容类型',
  `content_id` varchar(32) NOT NULL COMMENT '内容id',
  `content_name` varchar(200) DEFAULT NULL COMMENT '内容名称',
  `content_label` varchar(255) DEFAULT NULL COMMENT '内容标签',
  `success_flag` int DEFAULT NULL COMMENT '0:失败，1成功  2:等待',
  `reason_type` int DEFAULT NULL COMMENT '理由类型 1：映射 2医院网络异常',
  `reason_desc` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '同步失败原因',
  `success_time` datetime DEFAULT NULL COMMENT '下发成功时间',
  `distribution_time` datetime DEFAULT NULL COMMENT '分配时间',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '分配人id',
  `editor_name` varchar(30) DEFAULT NULL COMMENT '分配人名称',
  `distribution_content` mediumtext COMMENT '下发内容',
  `distribution_count` int DEFAULT '0' COMMENT '下发次数',
  `is_delete` int DEFAULT '0' COMMENT '删除标记',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='医院引用包分配关系表';

-- ----------------------------
-- Table structure for pack_hosp_distribution_record
-- ----------------------------
DROP TABLE IF EXISTS `pack_hosp_distribution_record`;
CREATE TABLE `pack_hosp_distribution_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `relation_id` varchar(32) NOT NULL COMMENT '关联id',
  `success_flag` int DEFAULT NULL COMMENT '0:失败，1成功  2:等待',
  `reason_type` int DEFAULT NULL COMMENT '理由类型 1：映射 2医院网络异常',
  `reason_desc` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '下发失败原因',
  `distribution_time` datetime DEFAULT NULL COMMENT '下发时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标记',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='医院引用包下发记录表';

-- ----------------------------
-- Table structure for pack_hospital
-- ----------------------------
DROP TABLE IF EXISTS `pack_hospital`;
CREATE TABLE `pack_hospital` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(130) NOT NULL COMMENT '医院编码',
  `relation_id` varchar(32) NOT NULL COMMENT '关联内容ID',
  `relation_type` int NOT NULL COMMENT '关联内容类型(99,套餐 1,表单 2,规则 3,方案)',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `disease_codes` varchar(5000) DEFAULT NULL,
  `disease_names` varchar(5000) DEFAULT NULL,
  `rule_ids` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_hosp_relation_id` (`relation_id`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='医院引用包';

-- ----------------------------
-- Table structure for pack_main
-- ----------------------------
DROP TABLE IF EXISTS `pack_main`;
CREATE TABLE `pack_main` (
  `id` varchar(32) NOT NULL,
  `pack_name` varchar(50) DEFAULT NULL COMMENT '套餐名称',
  `pack_desc` varchar(100) DEFAULT NULL COMMENT '使用场景说明',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `archives_form_id` varchar(32) DEFAULT NULL,
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `first_pack_id` varchar(32) DEFAULT NULL COMMENT '总路径ID',
  `pack_type` int DEFAULT NULL COMMENT '路径分类 1：总场景（路径）11:专病路径 12：病程路径 13：服务路径 14：护士路径',
  `common_pack_type` varchar(10) DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `path_description` varchar(255) DEFAULT NULL COMMENT '路径描述',
  `creator_id` varchar(64) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='专病随访包主信息';

-- ----------------------------
-- Table structure for pack_remind
-- ----------------------------
DROP TABLE IF EXISTS `pack_remind`;
CREATE TABLE `pack_remind` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `pack_id` varchar(32) NOT NULL COMMENT '路径id',
  `remind_time` longtext,
  `remind_content` text COMMENT '题目内容',
  `remind_type_name` varchar(50) DEFAULT NULL COMMENT '提醒类型名称',
  `rule_id` varchar(32) DEFAULT NULL,
  `rule_json` longtext COMMENT 'json',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for patient_core
-- ----------------------------
DROP TABLE IF EXISTS `patient_core`;
CREATE TABLE `patient_core` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `plan_id` varchar(32) NOT NULL COMMENT '随访计划id',
  `empi_id` varchar(100) NOT NULL COMMENT '患者主索引号id',
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '医院编码',
  `stage_id` varchar(300) DEFAULT NULL COMMENT '患者治疗阶段id',
  `pack_id` varchar(32) DEFAULT NULL COMMENT '患者精细化路径id',
  `create_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_task_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '最新拆分任务时间',
  `is_prepare_send` int DEFAULT '0' COMMENT '待发送数据是否准备好标志位',
  `send_task_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '下发任务时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for patient_gestation
-- ----------------------------
DROP TABLE IF EXISTS `patient_gestation`;
CREATE TABLE `patient_gestation` (
  `id` varchar(35) NOT NULL,
  `serial_no` varchar(50) DEFAULT NULL,
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `gestation_week` int DEFAULT NULL COMMENT '孕周',
  `gestation_date` datetime DEFAULT NULL COMMENT '孕周登记日期',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `gestation_day` int DEFAULT NULL COMMENT '孕日',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for patient_info
-- ----------------------------
DROP TABLE IF EXISTS `patient_info`;
CREATE TABLE `patient_info` (
  `empi_id` varchar(100) NOT NULL COMMENT '主索引号,患者唯一标识，主键',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '患者姓名',
  `mobile_no` varchar(50) DEFAULT NULL COMMENT '手机号码',
  `id_card` varchar(50) DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int DEFAULT NULL COMMENT '性别代码(1:男 2:女 9:其他)',
  `sex_name` varchar(50) DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `age` varchar(10) DEFAULT NULL,
  `work_unit` varchar(255) DEFAULT NULL COMMENT '工作地址',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源(1:门诊 2:出院 3:在院 4:体检 5:转科 6:签约 7:预约 8:转诊 9:蓝牛 10:患者管理 11:号码维护 12:妇产专科 13:建档)',
  `pat_source_type_name` varchar(10) DEFAULT NULL COMMENT '病人来源名称',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步完成标志位（1已同步 0未同步）',
  PRIMARY KEY (`empi_id`) USING BTREE,
  UNIQUE KEY `patindexno` (`empi_id`) USING BTREE,
  KEY `patinfo_insad` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者基本信息';

-- ----------------------------
-- Table structure for patient_info-b
-- ----------------------------
DROP TABLE IF EXISTS `patient_info-b`;
CREATE TABLE `patient_info-b` (
  `pat_index_no` varchar(50) NOT NULL,
  `organ_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `outhosp_no` varchar(50) DEFAULT NULL COMMENT '门诊号',
  `inhosp_no` varchar(50) DEFAULT NULL COMMENT '住院号',
  `medicare_card_no` varchar(50) DEFAULT NULL COMMENT '医疗保险卡号',
  `medicare_categ_code` varchar(50) DEFAULT NULL COMMENT '医疗保险类别代码',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(50) DEFAULT NULL COMMENT '身份证号码',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `sex_code` varchar(50) DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(50) DEFAULT NULL COMMENT '性别名称',
  `ethnic_code` varchar(50) DEFAULT NULL COMMENT '民族代码',
  `ethnic_name` varchar(50) DEFAULT NULL COMMENT '名族名称',
  `mobile_no` varchar(50) DEFAULT NULL COMMENT '手机号码',
  `contact_name` varchar(50) DEFAULT NULL COMMENT '联系人姓名',
  `contact_relation` varchar(50) DEFAULT NULL COMMENT '联系人关系',
  `contact_phone_no` varchar(50) DEFAULT NULL COMMENT '联系人电话',
  `abo_code` varchar(50) DEFAULT NULL COMMENT 'ABO血型代码',
  `abo_name` varchar(50) DEFAULT NULL COMMENT 'ABO血型名称',
  `sync_time` datetime DEFAULT NULL COMMENT '同步时间',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  PRIMARY KEY (`pat_index_no`) USING BTREE,
  UNIQUE KEY `patindexno` (`pat_index_no`) USING BTREE,
  KEY `patinfo_insad` (`pat_index_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='患者基本信息';

-- ----------------------------
-- Table structure for patient_main
-- ----------------------------
DROP TABLE IF EXISTS `patient_main`;
CREATE TABLE `patient_main` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `patient_id` varchar(32) DEFAULT NULL COMMENT '随访上传患者所带的主键id',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '计划ID',
  `plan_name` varchar(200) DEFAULT NULL COMMENT '计划名称',
  `pack_id` varchar(32) DEFAULT NULL COMMENT '精细化路径id',
  `pack_name` varchar(200) DEFAULT NULL COMMENT '精细化路径名称',
  `therapy_name` varchar(10) DEFAULT NULL COMMENT '方案名称（低危，中高危，高危）',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '患者姓名',
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '医院编码',
  `diag_code` varchar(200) DEFAULT NULL COMMENT '疾病代码',
  `diag_name` varchar(200) DEFAULT NULL COMMENT '疾病名称',
  `dept_code` varchar(100) DEFAULT NULL COMMENT '科室代码(门诊/出院/在院/转科)',
  `dept_name` varchar(200) DEFAULT NULL COMMENT '科室名称(门诊/出院/在院/转科)',
  `dr_code` varchar(20) DEFAULT NULL COMMENT '主治/签约医生工号',
  `dr_name` varchar(200) DEFAULT NULL COMMENT '主治/签约医生姓名',
  `in_hosp_no` varchar(50) DEFAULT NULL COMMENT '住院号',
  `out_hosp_no` varchar(50) DEFAULT NULL COMMENT '门诊号',
  `inhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '住院流水号',
  `outhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '门诊流水号',
  `create_time` varchar(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `have_task` tinyint(1) DEFAULT '0' COMMENT '该条数据是否已经用以生成下发任务',
  `business_time` timestamp DEFAULT NULL COMMENT '业务发生时间 入院/出院/就诊/体检/签约/入科/出科/建档/签约/收藏患者时间（或加入分组时间）',
  `have_task_time` varchar(20) DEFAULT NULL COMMENT '下发任务生成时间',
  `push_task_time` varchar(20) DEFAULT NULL COMMENT '下发任务下发时间',
  `is_prepare_gain` int DEFAULT '0' COMMENT '该条任务的患者数据数据中心已经准备好的标志位',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '该条任务是否被使用拆分任务',
  `is_prepare` int DEFAULT '0' COMMENT '患者医疗数据是否准备完毕发送',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for patient_medicine_data
-- ----------------------------
DROP TABLE IF EXISTS `patient_medicine_data`;
CREATE TABLE `patient_medicine_data` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `empi_id` varchar(50) DEFAULT NULL COMMENT '患者主索引号',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '患者计划id',
  `old_medicine_info` longtext COMMENT '历史患者医疗数据',
  `new_medicine_info` longtext COMMENT '新批次患者医疗数据',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for patient_medicine_data_detail
-- ----------------------------
DROP TABLE IF EXISTS `patient_medicine_data_detail`;
CREATE TABLE `patient_medicine_data_detail` (
  `patient_main_id` varchar(32) NOT NULL COMMENT '患者主要信息表主键id',
  `empi_id` varchar(50) DEFAULT NULL COMMENT '患者主索引号',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `drug` longtext COMMENT '医药数据',
  `diagnosis` longtext COMMENT '诊断数据',
  `surgery` longtext COMMENT '手术数据',
  `examine` longtext COMMENT '检验检查数据',
  `check` longtext COMMENT '检查检查数据',
  PRIMARY KEY (`patient_main_id`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for patient_prescription
-- ----------------------------
DROP TABLE IF EXISTS `patient_prescription`;
CREATE TABLE `patient_prescription` (
  `id` varchar(32) NOT NULL,
  `prescription_id` varchar(32) DEFAULT NULL,
  `patient_id` varchar(32) DEFAULT NULL,
  `hospital_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- ----------------------------
-- Table structure for patient_process
-- ----------------------------
DROP TABLE IF EXISTS `patient_process`;
CREATE TABLE `patient_process` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '患者主索引号',
  `diag_code` varchar(20) DEFAULT NULL COMMENT '疾病编码',
  `order_no` mediumtext COMMENT '患者医嘱数据主键逗号分隔',
  `inhosp_serial_no` text COMMENT '住院信息主键，逗号分隔',
  `outhosp_serial_no` text COMMENT '门诊数据主键，逗号分隔',
  `pres_no` text COMMENT '处方信息主键，逗号分隔',
  `surgery_id` text COMMENT '手术信息主键，逗号分隔',
  `report_no` text COMMENT '检验信息主键，逗号分隔',
  `patient_main_id` text COMMENT '患者头数据主键，逗号分隔',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for patient_stage
-- ----------------------------
DROP TABLE IF EXISTS `patient_stage`;
CREATE TABLE `patient_stage` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `stage_id` varchar(32) DEFAULT NULL COMMENT '患者诊疗阶段id',
  `therapy_stage_code` varchar(300) DEFAULT NULL COMMENT '治疗阶段代码',
  `therapy_stage_name` varchar(300) DEFAULT NULL COMMENT '治疗阶段名称',
  `therapy_stage_begin_time` datetime DEFAULT NULL COMMENT '治疗阶段开始时间',
  `inhosp_serial_no` varchar(64) DEFAULT NULL COMMENT '住院流水号',
  `outhosp_serial_no` varchar(64) DEFAULT NULL COMMENT '门诊流水号',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` text COMMENT '患者某一阶段下所有的患者主要信息id列表',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '随访计划id',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '患者主索引号',
  `diag_code` varchar(50) DEFAULT NULL COMMENT '疾病编码',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `create_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT NULL,
  `is_success` tinyint(1) DEFAULT '1' COMMENT '是否下发随访成功标志位 默认为成功，异常会更改为失败',
  `stage_days` int DEFAULT NULL COMMENT '阶段维持天数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription
-- ----------------------------
DROP TABLE IF EXISTS `prescription`;
CREATE TABLE `prescription` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '处方名称',
  `prescription_type_id` varchar(32) DEFAULT NULL COMMENT '处方类型',
  `prescription_type_name` varchar(50) DEFAULT NULL COMMENT '处方类型名称',
  `diag_codes` varchar(200) DEFAULT NULL COMMENT '疾病编码',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '疾病名称',
  `label_codes` varchar(255) DEFAULT NULL COMMENT '标签编码',
  `label_names` varchar(500) DEFAULT NULL COMMENT '标签名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT NULL COMMENT '删除标识',
  `desc` varchar(255) DEFAULT NULL COMMENT '处方描述',
  `is_circulation` int DEFAULT NULL COMMENT '循环判断1：循环 0：不循环',
  `form_id` varchar(32) DEFAULT NULL,
  `baseline_type_code` varchar(20) DEFAULT NULL,
  `baseline_type_name` varchar(50) DEFAULT NULL,
  `baseline_count` int DEFAULT NULL,
  `baseline_unit_code` varchar(20) DEFAULT NULL,
  `baseline_unit_name` varchar(50) DEFAULT NULL,
  `therapy_type_code` varchar(50) DEFAULT NULL COMMENT '治疗类型编码',
  `therapy_type_name` varchar(50) DEFAULT NULL COMMENT '治疗类型名称',
  `circulation_prescription_ids` varchar(9000) DEFAULT NULL COMMENT '同循环关联处方编码',
  `circulation_prescription_names` varchar(9000) DEFAULT NULL COMMENT '同循环关联处方名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_abnormal
-- ----------------------------
DROP TABLE IF EXISTS `prescription_abnormal`;
CREATE TABLE `prescription_abnormal` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `prescription_id` varchar(32) DEFAULT NULL COMMENT '处方id',
  `abnormal_type_code` varchar(255) DEFAULT NULL COMMENT '表单类型编码 1: 表单异常，2 检验异常，3复诊异常',
  `abnormal_type_name` varchar(255) DEFAULT NULL COMMENT '表单类型名称',
  `abnormal_low_type_code` varchar(255) DEFAULT NULL COMMENT '异常子类型编码 表单异常',
  `abnormal_low_type_name` varchar(255) DEFAULT NULL COMMENT '异常子类型名称',
  `abnormal_json` text,
  `is_delete` int DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `editor_id` varchar(50) DEFAULT NULL,
  `editor_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_compliance_judge_record
-- ----------------------------
DROP TABLE IF EXISTS `prescription_compliance_judge_record`;
CREATE TABLE `prescription_compliance_judge_record` (
  `id` varchar(50) NOT NULL,
  `compliance_id` varchar(50) NOT NULL COMMENT '处方依从性id',
  `condition_data` varchar(50) DEFAULT NULL COMMENT '符合条件的任务日期',
  `pat_index` varchar(50) DEFAULT NULL COMMENT '患者索引号',
  `condition_value` varchar(2000) DEFAULT NULL COMMENT '条件值',
  `basic_type` int DEFAULT NULL,
  `second_type` int DEFAULT NULL,
  `condition_detail` varchar(3000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_compliance_new
-- ----------------------------
DROP TABLE IF EXISTS `prescription_compliance_new`;
CREATE TABLE `prescription_compliance_new` (
  `id` varchar(50) NOT NULL,
  `prescription_id` varchar(50) DEFAULT NULL,
  `prescription_condition` text COMMENT '处方条件',
  `prescription_content` text COMMENT '处方内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_condition
-- ----------------------------
DROP TABLE IF EXISTS `prescription_condition`;
CREATE TABLE `prescription_condition` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `prescription_id` varchar(32) DEFAULT NULL COMMENT '处方id',
  `prescription_name` varchar(50) DEFAULT NULL COMMENT '处方名称',
  `sex_code` varchar(1) DEFAULT NULL COMMENT '性别编码',
  `sex_name` varchar(10) DEFAULT NULL COMMENT '性别名称',
  `age_years_low` varchar(20) DEFAULT NULL COMMENT '年龄年下限值',
  `age_years_high` varchar(20) DEFAULT NULL COMMENT '年龄年上限值',
  `age_month_low` varchar(20) DEFAULT NULL COMMENT '年龄月下限值',
  `age_month_high` varchar(20) DEFAULT NULL COMMENT '年龄月上限值',
  `age_day_low` varchar(20) DEFAULT NULL COMMENT '年龄天下限值',
  `age_day_high` varchar(20) DEFAULT NULL COMMENT '年龄天上限值',
  `contains_drug_code` varchar(2000) DEFAULT NULL COMMENT '包含药品',
  `contains_drug_name` varchar(500) DEFAULT NULL COMMENT '包含药品名称',
  `contains_disease_code` varchar(200) DEFAULT NULL COMMENT '包含疾病编码',
  `contains_disease_name` varchar(500) DEFAULT NULL COMMENT '包含疾病名称',
  `contains_surgery_code` varchar(2000) DEFAULT NULL COMMENT '包含手术',
  `contains_surgery_name` varchar(500) DEFAULT NULL COMMENT '包含手术名称',
  `contains_therapy_codes` varchar(500) DEFAULT NULL COMMENT '包含治疗方式编码',
  `pack_id` varchar(50) DEFAULT NULL COMMENT '路径Id',
  `cut_prescription_ids` text COMMENT '处方ids',
  `cut_type` varchar(20) DEFAULT NULL COMMENT '切换标志 1:stop',
  `cut_type_name` varchar(20) DEFAULT NULL COMMENT '切换标志名称 1：停止',
  `cut_prescription_names` text COMMENT '切换处方names',
  `therapy_stage_code` varchar(50) DEFAULT NULL,
  `therapy_stage_name` varchar(50) DEFAULT NULL,
  `contains_diagnosis` text COMMENT '包含疾病json',
  `check_include_text` text COMMENT '检查包含文字(逗号隔开)',
  `check_code` varchar(50) DEFAULT NULL COMMENT '检查编码',
  `check_name` varchar(255) DEFAULT NULL COMMENT '检查名称',
  `check_not_include_text` text COMMENT '检查不包含文字(逗号隔开)',
  `dept_codes` varchar(500) DEFAULT NULL COMMENT '科室编码（逗号隔开）',
  `dept_names` varchar(500) DEFAULT NULL COMMENT '科室名称（逗号隔开）',
  `diagnosis_include_text` varchar(1000) DEFAULT NULL COMMENT '诊断包含文字',
  `diagnosis_not_include_text` varchar(1000) DEFAULT NULL COMMENT '诊断不包含文字',
  `this_time` int DEFAULT NULL COMMENT '只使用本次数据 0：不是 1：是',
  `surgery_include_text` varchar(1000) DEFAULT NULL COMMENT '手术包含文字',
  `surgery_not_include_text` varchar(1000) DEFAULT NULL COMMENT '手术不包含文字',
  `gestation_week_low` int DEFAULT NULL COMMENT '孕周下限值',
  `gestation_week_high` int DEFAULT NULL COMMENT '孕周上限值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_condition_compliance
-- ----------------------------
DROP TABLE IF EXISTS `prescription_condition_compliance`;
CREATE TABLE `prescription_condition_compliance` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT 'id',
  `prescription_id` varchar(64) DEFAULT NULL COMMENT 'prescription_id 处方id',
  `rule` varchar(2000) DEFAULT NULL COMMENT 'diet_rule 饮食规则无记录',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT=' ';

-- ----------------------------
-- Table structure for prescription_condition_evaluate
-- ----------------------------
DROP TABLE IF EXISTS `prescription_condition_evaluate`;
CREATE TABLE `prescription_condition_evaluate` (
  `id` varchar(64) NOT NULL COMMENT 'id',
  `prescription_id` varchar(64) DEFAULT NULL COMMENT 'prescription_id',
  `form_question_rule` varchar(3300) DEFAULT NULL COMMENT 'form_question_rule 题目规则',
  `form_question_scope` int DEFAULT NULL COMMENT 'form_question_scope 题目规则范围',
  `scale_score_rule` varchar(1024) DEFAULT NULL COMMENT 'scale_score_rule 量表评分规则',
  `scale_score_scope` int DEFAULT NULL COMMENT 'scale_score_scope 量表评分范围',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='处方条件评估量表 ';

-- ----------------------------
-- Table structure for prescription_condition_examine
-- ----------------------------
DROP TABLE IF EXISTS `prescription_condition_examine`;
CREATE TABLE `prescription_condition_examine` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `prescription_condition_id` varchar(32) DEFAULT NULL,
  `examine_code` varchar(20) DEFAULT NULL,
  `examine_name` varchar(255) DEFAULT NULL COMMENT '名称包含大项 范围和单位。',
  `range_low_numerical` varchar(255) DEFAULT NULL,
  `range_low_code` varchar(255) DEFAULT NULL,
  `range_low_name` varchar(255) DEFAULT NULL,
  `range_high_numerical` varchar(255) DEFAULT NULL,
  `range_high_code` varchar(255) DEFAULT NULL,
  `range_high_name` varchar(255) DEFAULT NULL,
  `abnormal_fluctuation` int DEFAULT NULL COMMENT '波动范围',
  `number_consecutive` int DEFAULT NULL COMMENT '连续异常次数',
  `abnormal_count_code` varchar(20) DEFAULT NULL COMMENT '异常值符号编码',
  `abnormal_count_name` varchar(50) DEFAULT NULL COMMENT '异常值符号名称',
  `abnormal_count_value` int DEFAULT NULL COMMENT '异常值范围值',
  `number_fluctuation` int DEFAULT NULL COMMENT '连续波动次数',
  `standard_low_value` int DEFAULT NULL,
  `standard_high_value` int DEFAULT NULL,
  `include_text` varchar(500) DEFAULT NULL COMMENT '包含文字',
  `not_include_text` varchar(500) DEFAULT NULL COMMENT '不包含文字',
  `standard` int DEFAULT NULL COMMENT '标准:1:医院 2：自定义',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_condition_label
-- ----------------------------
DROP TABLE IF EXISTS `prescription_condition_label`;
CREATE TABLE `prescription_condition_label` (
  `id` varchar(64) NOT NULL DEFAULT '' COMMENT 'id',
  `prescription_id` varchar(64) DEFAULT NULL COMMENT 'prescription_id 处方id',
  `rule` varchar(2000) DEFAULT NULL COMMENT 'diet_rule 饮食规则无记录',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT=' ';

-- ----------------------------
-- Table structure for prescription_copy
-- ----------------------------
DROP TABLE IF EXISTS `prescription_copy`;
CREATE TABLE `prescription_copy` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(50) DEFAULT NULL COMMENT '处方名称',
  `prescription_type_id` varchar(32) DEFAULT NULL COMMENT '处方类型',
  `prescription_type_name` varchar(50) DEFAULT NULL COMMENT '处方类型名称',
  `diag_codes` varchar(200) DEFAULT NULL COMMENT '疾病编码',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '疾病名称',
  `label_codes` varchar(255) DEFAULT NULL COMMENT '标签编码',
  `label_names` varchar(500) DEFAULT NULL COMMENT '标签名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` int DEFAULT NULL COMMENT '删除标识',
  `desc` varchar(255) DEFAULT NULL COMMENT '处方描述',
  `is_circulation` int DEFAULT NULL COMMENT '循环判断1：循环 0：不循环',
  `form_id` varchar(32) DEFAULT NULL,
  `baseline_type_code` varchar(20) DEFAULT NULL,
  `baseline_type_name` varchar(50) DEFAULT NULL,
  `baseline_count` int DEFAULT NULL,
  `baseline_unit_code` varchar(20) DEFAULT NULL,
  `baseline_unit_name` varchar(50) DEFAULT NULL,
  `therapy_type_code` varchar(50) DEFAULT NULL COMMENT '治疗类型编码',
  `therapy_type_name` varchar(50) DEFAULT NULL COMMENT '治疗类型名称',
  `circulation_prescription_ids` varchar(9000) DEFAULT NULL COMMENT '同循环关联处方编码',
  `circulation_prescription_names` varchar(9000) DEFAULT NULL COMMENT '同循环关联处方名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_education
-- ----------------------------
DROP TABLE IF EXISTS `prescription_education`;
CREATE TABLE `prescription_education` (
  `id` varchar(255) NOT NULL COMMENT '主键',
  `prescription_id` varchar(50) DEFAULT NULL COMMENT '处方宣教id',
  `education_id` varchar(255) DEFAULT NULL COMMENT '宣讲id',
  `education_name` varchar(255) DEFAULT NULL COMMENT '宣讲名称',
  `course_id` varchar(255) DEFAULT NULL COMMENT '课程id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_followup
-- ----------------------------
DROP TABLE IF EXISTS `prescription_followup`;
CREATE TABLE `prescription_followup` (
  `id` varchar(255) NOT NULL COMMENT '主键',
  `prescription_id` varchar(32) DEFAULT NULL COMMENT '处方id',
  `followup_name` varchar(255) DEFAULT NULL COMMENT '随访名称',
  `followup_form_id` varchar(32) DEFAULT NULL COMMENT '关联表单id',
  `followup_form_title_ids` text COMMENT '随访题目ids',
  `followup_form_title_names` text COMMENT '随访题目名称',
  `followup_scale_id` text COMMENT '量表id',
  `followup_scale_name` text COMMENT '量表名称',
  `editor_id` varchar(32) DEFAULT NULL,
  `editor_name` varchar(50) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT NULL,
  `followup_form_component_keys` varchar(500) DEFAULT NULL,
  `repeat_active_rule` varchar(500) DEFAULT NULL COMMENT '重复规则',
  `multi_form_id` varchar(500) DEFAULT NULL COMMENT '多中心表单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_issue
-- ----------------------------
DROP TABLE IF EXISTS `prescription_issue`;
CREATE TABLE `prescription_issue` (
  `id` varchar(255) NOT NULL,
  `issue_prescription_id` varchar(50) DEFAULT NULL COMMENT '处方id',
  `issue_update_time` datetime DEFAULT NULL COMMENT '处方更新时间',
  `issue_hosp_code` varchar(60) DEFAULT NULL COMMENT '下发医院编码',
  `issue_hosp_name` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_program
-- ----------------------------
DROP TABLE IF EXISTS `prescription_program`;
CREATE TABLE `prescription_program` (
  `id` varchar(64) NOT NULL COMMENT 'id',
  `prescription_id` varchar(64) DEFAULT NULL COMMENT 'prescription_id',
  `program_type` int DEFAULT NULL COMMENT 'program_type',
  `program_id` varchar(64) DEFAULT NULL COMMENT 'program_id',
  `program_name` varchar(1000) DEFAULT NULL COMMENT 'program_name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT=' ';

-- ----------------------------
-- Table structure for prescription_remind
-- ----------------------------
DROP TABLE IF EXISTS `prescription_remind`;
CREATE TABLE `prescription_remind` (
  `id` varchar(255) NOT NULL COMMENT '主键',
  `prescription_id` varchar(32) DEFAULT NULL COMMENT '处方id',
  `remind_time` varchar(50) DEFAULT NULL COMMENT '提醒时间',
  `remind_content` text COMMENT '题目内容',
  `remind_type_code` varchar(50) DEFAULT NULL COMMENT '提醒类型编码',
  `remind_type_name` varchar(50) DEFAULT NULL COMMENT '提醒类型名称',
  `reminder_type` varchar(10) DEFAULT NULL COMMENT '提醒对象 1:医生2：患者',
  `reminder_type_name` varchar(10) DEFAULT NULL COMMENT '提醒对象名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for prescription_repeat_active
-- ----------------------------
DROP TABLE IF EXISTS `prescription_repeat_active`;
CREATE TABLE `prescription_repeat_active` (
  `id` varchar(50) NOT NULL,
  `prescription_id` varchar(50) DEFAULT NULL,
  `repeat_rule` text,
  `task` text,
  `is_delete` int DEFAULT NULL,
  `create_time` varchar(255) DEFAULT NULL,
  `update_time` varchar(255) DEFAULT NULL,
  `empid` varchar(50) DEFAULT NULL,
  `execute_count` int DEFAULT NULL,
  `task_data` varchar(50) DEFAULT NULL,
  `pat_index` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for program_catalog
-- ----------------------------
DROP TABLE IF EXISTS `program_catalog`;
CREATE TABLE `program_catalog` (
  `id` varchar(32) NOT NULL COMMENT '主键id',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '父结构id ',
  `user_id` varchar(32) DEFAULT NULL COMMENT '用户id',
  `user_name` varchar(20) DEFAULT NULL COMMENT '用户',
  `program_monitor_main_code` varchar(20) DEFAULT NULL COMMENT '疾病方案code，饮食方案code，运动方案code，监测方案code',
  `program_name` varchar(100) DEFAULT NULL COMMENT '方案名称',
  `program_desc` text COMMENT '方案描述',
  `delete_flag` int DEFAULT '0' COMMENT '0:不删除；1：删除',
  `program_selected_code` varchar(200) DEFAULT NULL COMMENT '饮食code,运动code,监测方案code',
  `program_monitor_detail_code` varchar(200) DEFAULT NULL COMMENT '血糖监测方案code，血压监测方案code，胎心监测方案code,体温监测方案code，心率、血氧监测方案code',
  `rule_type` varchar(10) DEFAULT NULL COMMENT '1:每周2：每几天',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `scheme_id` varchar(32) DEFAULT NULL COMMENT '方案id (同一个方案不同版本)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='慢病管理方案库表';

-- ----------------------------
-- Table structure for program_dic
-- ----------------------------
DROP TABLE IF EXISTS `program_dic`;
CREATE TABLE `program_dic` (
  `id` varchar(32) NOT NULL COMMENT '主键id',
  `major_rule_name` varchar(30) DEFAULT NULL COMMENT '主监测规则名称',
  `major_rule_code` varchar(50) DEFAULT NULL COMMENT '主监测规则code ，包括饮食、运动、监测方案',
  `detail_rule_name` varchar(30) DEFAULT NULL COMMENT '明细监测规则名称 ',
  `detail_rule_code` varchar(50) DEFAULT NULL COMMENT '子监测规则code ，包括监测方案下面的细则',
  `assemble_way` varchar(30) DEFAULT NULL COMMENT '布局方式1:饮食样式2:运动样式3：监测方案每周样式4:监测方案每天样式',
  `rule_type` varchar(20) DEFAULT NULL COMMENT '1:每周2：每几天',
  `dic_order` int DEFAULT NULL,
  `level_type` int DEFAULT NULL COMMENT '方案级别，疾病方案：0；随访、饮食、运动、监测：1；血糖、血压，胎心...:2;',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for program_diet_sport
-- ----------------------------
DROP TABLE IF EXISTS `program_diet_sport`;
CREATE TABLE `program_diet_sport` (
  `id` varchar(32) NOT NULL COMMENT '主键id',
  `monitor_time_id` varchar(32) DEFAULT NULL COMMENT '监测时间点id',
  `diet_sport_name` varchar(30) DEFAULT NULL COMMENT '饮食和运动名称',
  `diet_sport_code` varchar(50) NOT NULL COMMENT '饮食和运动方式code',
  `picture_id` varchar(100) DEFAULT NULL COMMENT '图片名称',
  `picture_name` varchar(250) DEFAULT NULL COMMENT '图片详情地址蓝牛url',
  `food_amount` varchar(30) DEFAULT NULL COMMENT '食物数量',
  `sport_duration_code` varchar(30) DEFAULT NULL COMMENT '运动时长编码',
  `diet_unit_value` varchar(30) DEFAULT NULL COMMENT '饮食运动：每多少能量单位值，例如每100g食物含有200kcal热量中的100',
  `diet_unit` varchar(30) DEFAULT NULL COMMENT '饮食运动:例如每100g食物含有200kcal热量中的g',
  `diet_unit_code` varchar(32) DEFAULT NULL COMMENT '饮食运动：例如每100g食物含有200kcal热量中的g的编码',
  `energy` varchar(30) DEFAULT NULL COMMENT '单位能量',
  `delete_flag` int DEFAULT NULL COMMENT '是否删除',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for program_monitor_rule
-- ----------------------------
DROP TABLE IF EXISTS `program_monitor_rule`;
CREATE TABLE `program_monitor_rule` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `program_id` varchar(32) NOT NULL COMMENT '方案id',
  `monitor_rule_name` varchar(50) DEFAULT NULL COMMENT '规则名称 ',
  `monitor_rule_code` varchar(50) DEFAULT NULL COMMENT '规则code ',
  `delete_flag` int DEFAULT NULL COMMENT '0:不删除，1：删除',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `rule_value` varchar(20) DEFAULT NULL COMMENT '监测规则项字典表中的value',
  `dic_order` int DEFAULT NULL COMMENT '规则顺序order',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for program_monitor_time
-- ----------------------------
DROP TABLE IF EXISTS `program_monitor_time`;
CREATE TABLE `program_monitor_time` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `program_id` varchar(32) NOT NULL COMMENT '方案id',
  `monitor_time_name` varchar(20) DEFAULT NULL COMMENT '监测时间名称',
  `monitor_time_code` varchar(20) DEFAULT NULL COMMENT '监测时间code',
  `week` varchar(20) DEFAULT NULL COMMENT '1,2,3,4,5,6,7周一、周二、周三',
  `delete_flag` int DEFAULT NULL COMMENT '是否删除',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `monitor_time_begin` varchar(20) DEFAULT NULL COMMENT '监测时间点起始,饮食运动共用',
  `monitor_time_end` varchar(20) DEFAULT NULL COMMENT '监测时间点结束，饮食运动共用',
  `times` varchar(20) DEFAULT NULL COMMENT '例如起床后1次，随机两次',
  `unfold_flag` int DEFAULT NULL COMMENT '输入框是否展开，0：不展开，1：展开',
  `dic_order` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for program_rule_dic
-- ----------------------------
DROP TABLE IF EXISTS `program_rule_dic`;
CREATE TABLE `program_rule_dic` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `program_dic_id` varchar(32) DEFAULT NULL COMMENT '方案字典表主键',
  `monitor_rule_name` varchar(50) DEFAULT NULL COMMENT '监测规则名称',
  `monitor_rule_code` varchar(50) DEFAULT NULL COMMENT '监测规则code ',
  `rule_value` varchar(20) DEFAULT NULL COMMENT '每隔几天，1代表1天',
  `selected_flag` int DEFAULT NULL COMMENT '0：不选中，1：默认选中',
  `dic_order` int DEFAULT NULL COMMENT '顺序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for program_select
-- ----------------------------
DROP TABLE IF EXISTS `program_select`;
CREATE TABLE `program_select` (
  `select_id` varchar(32) DEFAULT NULL COMMENT 'Select标签ID',
  `select_name` varchar(45) DEFAULT NULL COMMENT 'Select标签名称',
  `option_value` varchar(15) DEFAULT NULL COMMENT 'Option值代码',
  `option_key` varchar(50) DEFAULT NULL COMMENT 'Option域名称',
  `sort_no` int DEFAULT '0' COMMENT '顺序号',
  `parent_select_id` varchar(32) DEFAULT NULL COMMENT '父节点ID',
  `parent_option_value` varchar(15) DEFAULT NULL COMMENT '父节点下的对应VALUE值',
  `select_desc` varchar(200) DEFAULT NULL COMMENT '当前下拉选对应的说明(目前仅仅给AI配置用)',
  UNIQUE KEY `idx_manage_select_uniq` (`select_id`,`option_value`) USING BTREE,
  KEY `idx_manage_select` (`select_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='文档定义好的系统中固定下拉选项值';

-- ----------------------------
-- Table structure for program_time_dic
-- ----------------------------
DROP TABLE IF EXISTS `program_time_dic`;
CREATE TABLE `program_time_dic` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `program_dic_id` varchar(32) DEFAULT NULL COMMENT '方案字典表主键',
  `monitor_time_name` varchar(50) DEFAULT NULL COMMENT '监测时间名称',
  `monitor_time_code` varchar(50) DEFAULT NULL COMMENT '监测时间',
  `monitor_time_begin` varchar(20) DEFAULT NULL COMMENT '监测时间起始时间',
  `monitor_time_end` varchar(20) DEFAULT NULL COMMENT '监测时间结束时间',
  `selected_flag` int DEFAULT NULL COMMENT '默认选择1:选择，0：不选择',
  `times` varchar(20) DEFAULT NULL COMMENT '每个选择的监测时间对应的次数',
  `unfold_flag` int DEFAULT NULL COMMENT '次数输入框是否展开1:展开，0：不展开',
  `dic_order` int DEFAULT NULL COMMENT '顺序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for program_version
-- ----------------------------
DROP TABLE IF EXISTS `program_version`;
CREATE TABLE `program_version` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '主键id  版本id (云端方案库id)',
  `scheme_id` varchar(32) DEFAULT NULL COMMENT '方案id (同一个方案不同版本)',
  `scheme_name` varchar(100) DEFAULT NULL COMMENT '方案名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '创建者id',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '创建者姓名',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院机构编码',
  `version_number` varchar(20) DEFAULT NULL COMMENT '版本号',
  `version_desc` varchar(100) DEFAULT NULL COMMENT '版本描述',
  `data_type` int DEFAULT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `release_flag` int DEFAULT '0' COMMENT '方案库版本 封板发布标记  1 已封板  0 未封板',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_scheme_id` (`scheme_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='云端方案库版本';

-- ----------------------------
-- Table structure for repository_form_layout
-- ----------------------------
DROP TABLE IF EXISTS `repository_form_layout`;
CREATE TABLE `repository_form_layout` (
  `id` char(32) NOT NULL COMMENT '主键',
  `form_id` char(32) NOT NULL COMMENT '关联表单ID(表t_repository_form的主键)',
  `layout_prop` tinyint NOT NULL COMMENT '布局属性(1:单题布局 2:父布局 3:子布局) ',
  `sort_index` int DEFAULT NULL COMMENT '布局排序号(组装表单时布局根据此序号排列)',
  `parent_layout_id` varchar(32) DEFAULT NULL COMMENT '父布局ID(子布局属性有值)',
  `layout_index` varchar(10) DEFAULT NULL COMMENT 'index存储',
  `layout_order` varchar(10) DEFAULT NULL COMMENT 'order存储',
  `component_key` varchar(50) DEFAULT NULL COMMENT '布局控件key(表格:TableLayout,TdLayout 行列:ColumnPanel)',
  `size` varchar(10) DEFAULT NULL COMMENT '布局控件size(1:最外层;2:一行两列;3:一行三列)',
  `table_th_array` varchar(200) DEFAULT NULL COMMENT '表格每列宽度',
  `table_cols` varchar(10) DEFAULT NULL COMMENT '表格总列数',
  `table_rows` varchar(10) DEFAULT NULL COMMENT '表格总行数',
  `td_height` varchar(10) DEFAULT NULL COMMENT 'TD高度',
  `td_width` varchar(10) DEFAULT NULL COMMENT 'TD宽度',
  `col_span` varchar(10) DEFAULT NULL COMMENT 'TD列合并数',
  `row_span` varchar(10) DEFAULT NULL COMMENT 'TD行合并数',
  `coordinate` varchar(10) DEFAULT NULL COMMENT 'TD坐标',
  `window_width` varchar(10) DEFAULT NULL COMMENT '保存表单时，屏幕的宽度',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `from_data` varchar(10) DEFAULT NULL COMMENT '题目是否来自数据中心  1:是  0:否',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='布局控件布局描述';

-- ----------------------------
-- Table structure for repository_form_layout_cloud
-- ----------------------------
DROP TABLE IF EXISTS `repository_form_layout_cloud`;
CREATE TABLE `repository_form_layout_cloud` (
  `id` char(32) NOT NULL COMMENT '主键',
  `form_id` char(32) NOT NULL COMMENT '关联表单ID(表t_repository_form的主键)',
  `layout_prop` tinyint NOT NULL COMMENT '布局属性(1:单题布局 2:父布局 3:子布局) ',
  `sort_index` int DEFAULT NULL COMMENT '布局排序号(组装表单时布局根据此序号排列)',
  `parent_layout_id` varchar(32) DEFAULT NULL COMMENT '父布局ID(子布局属性有值)',
  `layout_index` varchar(10) DEFAULT NULL COMMENT 'index存储',
  `layout_order` varchar(10) DEFAULT NULL COMMENT 'order存储',
  `component_key` varchar(50) DEFAULT NULL COMMENT '布局控件key(表格:TableLayout,TdLayout 行列:ColumnPanel)',
  `size` varchar(10) DEFAULT NULL COMMENT '布局控件size(1:最外层;2:一行两列;3:一行三列)',
  `table_th_array` varchar(200) DEFAULT NULL COMMENT '表格每列宽度',
  `table_cols` varchar(10) DEFAULT NULL COMMENT '表格总列数',
  `table_rows` varchar(10) DEFAULT NULL COMMENT '表格总行数',
  `td_height` varchar(10) DEFAULT NULL COMMENT 'TD高度',
  `td_width` varchar(20) DEFAULT NULL COMMENT 'TD宽度',
  `col_span` varchar(10) DEFAULT NULL COMMENT 'TD列合并数',
  `row_span` varchar(10) DEFAULT NULL COMMENT 'TD行合并数',
  `coordinate` varchar(10) DEFAULT NULL COMMENT 'TD坐标',
  `window_width` varchar(10) DEFAULT NULL COMMENT '保存表单时，屏幕的宽度',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `from_data` varchar(10) DEFAULT NULL COMMENT '题目是否来自数据中心  1:是  0:否',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='布局控件布局描述';

-- ----------------------------
-- Table structure for repository_form_option
-- ----------------------------
DROP TABLE IF EXISTS `repository_form_option`;
CREATE TABLE `repository_form_option` (
  `id` char(32) NOT NULL COMMENT '主键',
  `form_id` char(32) NOT NULL,
  `question_id` char(32) NOT NULL COMMENT '关联题目ID',
  `sort_index` int DEFAULT NULL COMMENT '选项排序号',
  `option_other` varchar(10) DEFAULT NULL COMMENT '选择题是否有其他项(false否; true是)',
  `option_index` varchar(10) DEFAULT NULL COMMENT 'index存储',
  `option_order` varchar(10) DEFAULT NULL COMMENT 'order存储',
  `option_name` varchar(1000) DEFAULT NULL COMMENT '选项名',
  `component_key` varchar(50) DEFAULT NULL COMMENT '选项控件key(option:选项)',
  `except` varchar(10) DEFAULT NULL COMMENT '是否异常选项(false,否;true,是)',
  `except_tip` varchar(1000) DEFAULT NULL COMMENT '异常提示说明',
  `obj_id` varchar(40) DEFAULT NULL COMMENT '图片ID(云端的有些图片ID带了后缀，扩大一点长度)',
  `file_path` varchar(500) DEFAULT NULL COMMENT '图片路径',
  `score` double(6,3) DEFAULT '0.000' COMMENT '评分单选框有分值',
  `quote_option_id` varchar(32) DEFAULT NULL COMMENT '引用选项ID(题库选项表主键ID)',
  `satisfaction_level` int DEFAULT NULL COMMENT '满意度级别(字典下拉表获取, 5:满意 4:较满意 3:一般 2:不满意 1:很不满意)',
  `send_education_ids` varchar(330) DEFAULT NULL COMMENT '选项需要推送宣教ID(逗号隔开，上限10个)',
  `required` varchar(10) DEFAULT NULL COMMENT '选项附加文本输入框必填(true 是, false 否)',
  `self_id` varchar(32) DEFAULT NULL COMMENT '逻辑跳题-选项标志ID',
  `jump_id` varchar(3000) DEFAULT NULL COMMENT '逻辑跳题-选项所跳题目标志ID||选项子题 多个的话逗号隔开',
  `mutex` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `education_names` varchar(1000) DEFAULT NULL COMMENT '宣教名称',
  `supply` varchar(255) DEFAULT NULL,
  `supply_tip` varchar(500) DEFAULT NULL,
  `plus_form_ids` varchar(500) DEFAULT NULL COMMENT '选项需要推送表单ID(逗号隔开，上限10个)',
  `plus_form_titles` varchar(500) DEFAULT NULL COMMENT '表单名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_question_id` (`question_id`) USING BTREE,
  KEY `idx_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='表单控件内部选项';

-- ----------------------------
-- Table structure for repository_form_option_cloud
-- ----------------------------
DROP TABLE IF EXISTS `repository_form_option_cloud`;
CREATE TABLE `repository_form_option_cloud` (
  `id` char(32) NOT NULL COMMENT '主键',
  `form_id` char(32) NOT NULL,
  `question_id` char(32) NOT NULL COMMENT '关联题目ID',
  `sort_index` int DEFAULT NULL COMMENT '选项排序号',
  `option_other` varchar(10) DEFAULT NULL COMMENT '选择题是否有其他项(false否; true是)',
  `option_index` varchar(10) DEFAULT NULL COMMENT 'index存储',
  `option_order` varchar(10) DEFAULT NULL COMMENT 'order存储',
  `option_name` varchar(1000) DEFAULT NULL COMMENT '选项名',
  `component_key` varchar(50) DEFAULT NULL COMMENT '选项控件key(option:选项)',
  `except` varchar(10) DEFAULT NULL COMMENT '是否异常选项(false,否;true,是)',
  `except_tip` varchar(1000) DEFAULT NULL COMMENT '异常提示说明',
  `obj_id` varchar(40) DEFAULT NULL COMMENT '图片ID(云端的有些图片ID带了后缀，扩大一点长度)',
  `file_path` varchar(500) DEFAULT NULL COMMENT '图片路径',
  `score` double(6,3) DEFAULT '0.000' COMMENT '评分单选框有分值',
  `quote_option_id` varchar(32) DEFAULT NULL COMMENT '引用选项ID(题库选项表主键ID)',
  `satisfaction_level` int DEFAULT NULL COMMENT '满意度级别(字典下拉表获取, 5:满意 4:较满意 3:一般 2:不满意 1:很不满意)',
  `send_education_ids` varchar(330) DEFAULT NULL COMMENT '选项需要推送宣教ID(逗号隔开，上限10个)',
  `required` varchar(10) DEFAULT NULL COMMENT '选项附加文本输入框必填(true 是, false 否)',
  `self_id` varchar(32) DEFAULT NULL COMMENT '逻辑跳题-选项标志ID',
  `jump_id` varchar(3000) DEFAULT NULL COMMENT '逻辑跳题-选项所跳题目标志ID||选项子题 多个的话逗号隔开',
  `mutex` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `education_names` varchar(1000) DEFAULT NULL COMMENT '宣教名称',
  `supply` varchar(255) DEFAULT NULL,
  `supply_tip` varchar(500) DEFAULT NULL,
  `plus_form_ids` varchar(500) DEFAULT NULL COMMENT '选项需要推送表单ID(逗号隔开，上限10个)',
  `plus_form_titles` varchar(500) DEFAULT NULL COMMENT '表单名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_question_id` (`question_id`) USING BTREE,
  KEY `idx_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='表单控件内部选项';

-- ----------------------------
-- Table structure for repository_form_question
-- ----------------------------
DROP TABLE IF EXISTS `repository_form_question`;
CREATE TABLE `repository_form_question` (
  `id` char(32) NOT NULL COMMENT '主键(fieldId)',
  `form_id` char(32) NOT NULL COMMENT '关联表单ID(表t_repository_form的主键)',
  `layout_id` char(32) NOT NULL COMMENT '关联布局ID(布局属性1和3的主键ID)',
  `question_type` tinyint NOT NULL COMMENT '题目类型(1:文本描述题(含单行/多行) 2:单选题 3:多选题 4:矩阵题(主题目) 5:矩阵题(副题目) 6:分值单选题 7:填空题(主题目) 8:填空题(副题目) 9:图文选择题 10:下拉题 11:日期 12:手机 13:图片)',
  `sort_index` int DEFAULT NULL COMMENT '题目排序号',
  `parent_question_id` varchar(32) DEFAULT NULL COMMENT '父题目ID(矩阵题/填空题副题目时此属性有效)',
  `question_title` varchar(1000) NOT NULL COMMENT '题目标题',
  `component_key` varchar(50) DEFAULT NULL COMMENT '字段控件类型(Text,TextArea,RadioBox,CheckBox....)',
  `question_index` varchar(10) DEFAULT NULL COMMENT 'index存储',
  `question_order` varchar(10) DEFAULT NULL COMMENT 'order存储',
  `title_layout` varchar(20) DEFAULT NULL COMMENT '控件标题布局(,横;,列)',
  `required` varchar(10) DEFAULT NULL COMMENT '是否必填(false,否;true,是)',
  `component_size` varchar(10) DEFAULT NULL COMMENT '控件尺寸',
  `hide_question` int DEFAULT '0' COMMENT '隐藏题目(1:是,0:否)',
  `no_statistical` int DEFAULT '0' COMMENT '不纳入统计(1:是,0:否)',
  `hide_title` varchar(10) DEFAULT NULL COMMENT '控件标题是否显示(false,否;true,显示)',
  `hide_border` varchar(10) DEFAULT NULL COMMENT '控件边框是否显示(false,否;true,显示)',
  `text_default` varchar(10) DEFAULT NULL COMMENT '文本输入框是否设置默认值(false,否;true,是)',
  `text_content` varchar(1000) DEFAULT NULL COMMENT '文本输入框默认值',
  `read_only` varchar(10) DEFAULT NULL COMMENT '是否只读(false,读写;true,只读)',
  `select_layout` varchar(50) DEFAULT NULL COMMENT '选项布局(,横向排列;,纵向排列)',
  `single` varchar(10) DEFAULT NULL COMMENT '是否单图片上传',
  `date_format` varchar(30) DEFAULT NULL COMMENT '日期控件时间类型(yyyy-MM-dd HH:mm:年月日时分;yyyy-MM-dd:;年月日; yyyy-MM年月)',
  `system_date` varchar(10) DEFAULT NULL COMMENT '是否使用系统时间(false,否;true,是;)',
  `quote_question_id` varchar(32) DEFAULT NULL COMMENT '引用题目ID(题库单题表主键ID)',
  `satisfaction_type` int DEFAULT NULL COMMENT '满意度调查类型(字典下拉表获取, 1:医德医风 2:护理 3:客服 4:后勤)',
  `text_align` varchar(50) DEFAULT NULL COMMENT '文字位置',
  `alias` varchar(100) DEFAULT NULL COMMENT '题目标题别名(通俗易懂的标题名供患者看)',
  `hide_for_mobile` varchar(10) DEFAULT NULL COMMENT '移动端隐藏标识(true:隐藏 false:显示) 页面叫不发送手机端',
  `weight` decimal(6,2) DEFAULT NULL COMMENT '权重指标',
  `weight_two` decimal(6,2) DEFAULT NULL COMMENT '权重指标2',
  `self_id` varchar(32) DEFAULT NULL COMMENT '逻辑跳题-题目标志ID',
  `label_width` varchar(10) DEFAULT NULL COMMENT '标题宽度',
  `jump_prop` int DEFAULT NULL COMMENT '题目属性(2,子题属性)',
  `reply_for_once` varchar(10) DEFAULT NULL COMMENT '限制手动修改(true:是 false:否)',
  `dic_type_id` varchar(32) DEFAULT NULL COMMENT '题目表单下拉框引用，对应关联字典表大项主键id  (字典表下拉框引用必填)',
  `dic_type_name` varchar(100) DEFAULT NULL COMMENT '对应关联字典表大项名称',
  `parent_dic_field_id` varchar(32) DEFAULT NULL COMMENT '同表单下 搜索下拉框外部关联题目id',
  `only_one_choice` varchar(10) DEFAULT NULL COMMENT '是否为单选组件 前端引用  true  false',
  `multiple_choice` varchar(10) DEFAULT NULL COMMENT '下拉框多选标志 false:单选 true:多选',
  `expression_list` varchar(500) DEFAULT NULL COMMENT '运算控件表达式',
  `decimal_digits` varchar(20) DEFAULT NULL COMMENT '保留小数位',
  `title_color` varchar(10) DEFAULT NULL COMMENT '表单题目标题颜色',
  `default_chosen` varchar(100) DEFAULT NULL COMMENT '单题默认值',
  `expression_type` varchar(50) DEFAULT NULL COMMENT '表达式关联题型',
  `date_type` varchar(10) DEFAULT NULL COMMENT '日期计算 答案格式',
  `fill_type` tinyint DEFAULT '1' COMMENT '自动填充类型 1.基本数据类型 2.CDR数据来源',
  `option_mutex` varchar(500) DEFAULT NULL COMMENT '选项互斥',
  `error_notice` varchar(500) DEFAULT NULL COMMENT '异常提醒',
  `no_repetition_tips` varchar(500) DEFAULT NULL COMMENT '防止重复提醒字段',
  `value_size` varchar(50) DEFAULT NULL COMMENT '表单输入框校验间距',
  `value_rules` varchar(1000) DEFAULT NULL COMMENT '表单输入框规则',
  `show_num_flag` int DEFAULT NULL COMMENT '是否显示题目序号标记  1显示 0不显示 ',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `prescription_type_ids` varchar(500) DEFAULT NULL,
  `prescription_type_names` varchar(500) DEFAULT NULL,
  `prescription_ids` varchar(500) DEFAULT NULL,
  `prescription_names` varchar(500) DEFAULT NULL,
  `describe_for_question` varchar(1000) DEFAULT NULL,
  `form_single_id` varchar(32) DEFAULT NULL COMMENT '单题singleId',
  `form_single_group_id` varchar(32) DEFAULT NULL COMMENT '单题组id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='字段控件表(相当于题目)';

-- ----------------------------
-- Table structure for repository_form_question_cloud
-- ----------------------------
DROP TABLE IF EXISTS `repository_form_question_cloud`;
CREATE TABLE `repository_form_question_cloud` (
  `id` char(32) NOT NULL COMMENT '主键(fieldId)',
  `form_id` char(32) NOT NULL COMMENT '关联表单ID(表t_repository_form的主键)',
  `layout_id` char(32) NOT NULL COMMENT '关联布局ID(布局属性1和3的主键ID)',
  `question_type` tinyint NOT NULL COMMENT '题目类型(1:文本描述题(含单行/多行) 2:单选题 3:多选题 4:矩阵题(主题目) 5:矩阵题(副题目) 6:分值单选题 7:填空题(主题目) 8:填空题(副题目) 9:图文选择题 10:下拉题 11:日期 12:手机 13:图片)',
  `sort_index` int DEFAULT NULL COMMENT '题目排序号',
  `parent_question_id` varchar(32) DEFAULT NULL COMMENT '父题目ID(矩阵题/填空题副题目时此属性有效)',
  `question_title` varchar(1000) NOT NULL COMMENT '题目标题',
  `component_key` varchar(50) DEFAULT NULL COMMENT '字段控件类型(Text,TextArea,RadioBox,CheckBox....)',
  `question_index` varchar(10) DEFAULT NULL COMMENT 'index存储',
  `question_order` varchar(10) DEFAULT NULL COMMENT 'order存储',
  `title_layout` varchar(20) DEFAULT NULL COMMENT '控件标题布局(,横;,列)',
  `required` varchar(10) DEFAULT NULL COMMENT '是否必填(false,否;true,是)',
  `component_size` varchar(10) DEFAULT NULL COMMENT '控件尺寸',
  `hide_question` int DEFAULT '0' COMMENT '隐藏题目(1:是,0:否)',
  `no_statistical` int DEFAULT '0' COMMENT '不纳入统计(1:是,0:否)',
  `hide_title` varchar(10) DEFAULT NULL COMMENT '控件标题是否显示(false,否;true,显示)',
  `hide_border` varchar(10) DEFAULT NULL COMMENT '控件边框是否显示(false,否;true,显示)',
  `text_default` varchar(10) DEFAULT NULL COMMENT '文本输入框是否设置默认值(false,否;true,是)',
  `text_content` varchar(1000) DEFAULT NULL COMMENT '文本输入框默认值',
  `read_only` varchar(10) DEFAULT NULL COMMENT '是否只读(false,读写;true,只读)',
  `select_layout` varchar(50) DEFAULT NULL COMMENT '选项布局(,横向排列;,纵向排列)',
  `single` varchar(10) DEFAULT NULL COMMENT '是否单图片上传',
  `date_format` varchar(30) DEFAULT NULL COMMENT '日期控件时间类型(yyyy-MM-dd HH:mm:年月日时分;yyyy-MM-dd:;年月日; yyyy-MM年月)',
  `system_date` varchar(10) DEFAULT NULL COMMENT '是否使用系统时间(false,否;true,是;)',
  `quote_question_id` varchar(32) DEFAULT NULL COMMENT '引用题目ID(题库单题表主键ID)',
  `satisfaction_type` int DEFAULT NULL COMMENT '满意度调查类型(字典下拉表获取, 1:医德医风 2:护理 3:客服 4:后勤)',
  `text_align` varchar(50) DEFAULT NULL COMMENT '文字位置',
  `alias` varchar(100) DEFAULT NULL COMMENT '题目标题别名(通俗易懂的标题名供患者看)',
  `hide_for_mobile` varchar(10) DEFAULT NULL COMMENT '移动端隐藏标识(true:隐藏 false:显示) 页面叫不发送手机端',
  `weight` decimal(6,2) DEFAULT NULL COMMENT '权重指标',
  `weight_two` decimal(6,2) DEFAULT NULL COMMENT '权重指标2',
  `self_id` varchar(32) DEFAULT NULL COMMENT '逻辑跳题-题目标志ID',
  `label_width` varchar(10) DEFAULT NULL COMMENT '标题宽度',
  `jump_prop` int DEFAULT NULL COMMENT '题目属性(2,子题属性)',
  `reply_for_once` varchar(10) DEFAULT NULL COMMENT '限制手动修改(true:是 false:否)',
  `dic_type_id` varchar(32) DEFAULT NULL COMMENT '题目表单下拉框引用，对应关联字典表大项主键id  (字典表下拉框引用必填)',
  `dic_type_name` varchar(100) DEFAULT NULL COMMENT '对应关联字典表大项名称',
  `parent_dic_field_id` varchar(32) DEFAULT NULL COMMENT '同表单下 搜索下拉框外部关联题目id',
  `only_one_choice` varchar(10) DEFAULT NULL COMMENT '是否为单选组件 前端引用  true  false',
  `multiple_choice` varchar(10) DEFAULT NULL COMMENT '下拉框多选标志 false:单选 true:多选',
  `expression_list` varchar(500) DEFAULT NULL COMMENT '运算控件表达式',
  `decimal_digits` varchar(20) DEFAULT NULL COMMENT '保留小数位',
  `title_color` varchar(10) DEFAULT NULL COMMENT '表单题目标题颜色',
  `default_chosen` varchar(100) DEFAULT NULL COMMENT '单题默认值',
  `expression_type` varchar(50) DEFAULT NULL COMMENT '表达式关联题型',
  `date_type` varchar(10) DEFAULT NULL COMMENT '日期计算 答案格式',
  `fill_type` tinyint DEFAULT '1' COMMENT '自动填充类型 1.基本数据类型 2.CDR数据来源',
  `option_mutex` varchar(500) DEFAULT NULL COMMENT '选项互斥',
  `error_notice` varchar(1500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '异常提醒',
  `no_repetition_tips` varchar(500) DEFAULT NULL COMMENT '防止重复提醒字段',
  `value_size` varchar(50) DEFAULT NULL COMMENT '表单输入框校验间距',
  `value_rules` varchar(1000) DEFAULT NULL COMMENT '表单输入框规则',
  `show_num_flag` int DEFAULT NULL COMMENT '是否显示题目序号标记  1显示 0不显示 ',
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `prescription_type_ids` varchar(500) DEFAULT NULL,
  `prescription_type_names` varchar(500) DEFAULT NULL,
  `prescription_ids` varchar(500) DEFAULT NULL,
  `prescription_names` varchar(500) DEFAULT NULL,
  `describe_for_question` varchar(1000) DEFAULT NULL,
  `form_single_id` varchar(32) DEFAULT NULL COMMENT '单题singleId',
  `form_single_group_id` varchar(32) DEFAULT NULL COMMENT '单题组id',
  `unit` varchar(200) DEFAULT NULL COMMENT '单位',
  `content_label_code` varchar(800) DEFAULT NULL COMMENT '内容标签',
  `content_label_name` varchar(800) DEFAULT NULL COMMENT '内容标签',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_form_id` (`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='字段控件表(相当于题目)';

-- ----------------------------
-- Table structure for resources_qr
-- ----------------------------
DROP TABLE IF EXISTS `resources_qr`;
CREATE TABLE `resources_qr` (
  `id` varchar(32) NOT NULL,
  `qr_relation_id` varchar(32) DEFAULT NULL,
  `data_type` int DEFAULT NULL COMMENT '数据类型 0服务 1随访',
  `resources_type` int DEFAULT NULL COMMENT '资源类型0宣教,1表单',
  `resources_id` varchar(32) DEFAULT NULL COMMENT '资源id',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '发布资源关联id',
  `release_type` int DEFAULT NULL COMMENT '0待发布1发布',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `is_old` int DEFAULT '0' COMMENT '1老0新',
  `qr_url` varchar(150) DEFAULT NULL COMMENT '二维码地址',
  `edit_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `edit_id` varchar(32) DEFAULT NULL,
  `edit_name` varchar(100) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `create_id` varchar(32) DEFAULT NULL,
  `create_name` varchar(100) DEFAULT NULL,
  `create_account` varchar(100) DEFAULT NULL COMMENT '创建人账号',
  `edit_account` varchar(100) DEFAULT NULL COMMENT '编辑人账号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='资源二维码';

-- ----------------------------
-- Table structure for resources_qr_log
-- ----------------------------
DROP TABLE IF EXISTS `resources_qr_log`;
CREATE TABLE `resources_qr_log` (
  `id` varchar(32) NOT NULL,
  `qr_id` varchar(32) DEFAULT NULL,
  `operate_type` int DEFAULT NULL COMMENT '0新增2修改3作废',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `edit_id` varchar(32) DEFAULT NULL,
  `edit_name` varchar(100) DEFAULT NULL,
  `edit_account` varchar(100) DEFAULT NULL COMMENT '编辑人账号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='资源二维码日志';

-- ----------------------------
-- Table structure for resources_qr_track_log
-- ----------------------------
DROP TABLE IF EXISTS `resources_qr_track_log`;
CREATE TABLE `resources_qr_track_log` (
  `id` varchar(32) NOT NULL,
  `qr_id` varchar(32) DEFAULT NULL,
  `scan_area` varchar(100) DEFAULT NULL COMMENT '扫码地区',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `network_name` varchar(32) DEFAULT NULL COMMENT '网络线路',
  `scan_dev` varchar(100) DEFAULT NULL COMMENT '扫码环境',
  `scan_remark` varchar(800) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='资源二维码日志';

-- ----------------------------
-- Table structure for rule
-- ----------------------------
DROP TABLE IF EXISTS `rule`;
CREATE TABLE `rule` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `rule_id` varchar(32) NOT NULL COMMENT '规则ID',
  `rule_version` decimal(7,1) NOT NULL COMMENT '规则版本',
  `rule_version_desc` varchar(100) DEFAULT NULL COMMENT '规则版本描述',
  `rule_title` varchar(100) NOT NULL COMMENT '规则标题',
  `rule_desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则描述/应用场景说明',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` text,
  `diag_names` text,
  `rule_form_id` varchar(8000) DEFAULT NULL COMMENT '规则内所有表单ID，逗号分隔',
  `rule_form_title` varchar(1000) DEFAULT NULL COMMENT '表单名称',
  `rule_json` longtext NOT NULL COMMENT '随访规则完整json串，增加任务疾病补充说明字段',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `rule_type` int NOT NULL DEFAULT '2' COMMENT '规则类型 2院级随访 4专科随访 5宣教规则 13:服务规则',
  `rule_education_id` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则内所有宣教ID，逗号分隔',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `edu_rule_category_id` varchar(100) DEFAULT NULL COMMENT '类别编码',
  `edu_rule_category_name` varchar(100) DEFAULT NULL COMMENT '类别名称',
  `rule_pat_source` varchar(20) DEFAULT NULL COMMENT '患者来源',
  `rule_pat_source_name` varchar(100) DEFAULT NULL COMMENT '患者来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `pack_rule_type_code` varchar(20) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `pack_rule_type_name` varchar(50) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `is_pack_rule` varchar(10) DEFAULT NULL COMMENT '路径标志：0:规则 1：路径',
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `diagnosis_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '普通版 regular, 高血压版 hypertension,糖尿病版 diabetes,人流、产后版 abortionPostpartum,饮食建议版 dietAdvice;',
  `edu_library` text COMMENT '宣教',
  `form_library` text COMMENT '表单',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `release_notes` varchar(500) DEFAULT NULL COMMENT '发布说明',
  `phone_task_nums` int DEFAULT NULL COMMENT '电话数量搜索用',
  `edu_num` int DEFAULT NULL COMMENT '宣教数量',
  `form_num` int DEFAULT NULL COMMENT '表单数据',
  `remind_num` int DEFAULT NULL COMMENT '患者提醒的数量',
  `label_codes_old` text,
  `label_names_old` text,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ruleId` (`rule_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规则表';

-- ----------------------------
-- Table structure for rule_0506
-- ----------------------------
DROP TABLE IF EXISTS `rule_0506`;
CREATE TABLE `rule_0506` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `rule_id` varchar(32) NOT NULL COMMENT '规则ID',
  `rule_version` decimal(7,1) NOT NULL COMMENT '规则版本',
  `rule_version_desc` varchar(100) DEFAULT NULL COMMENT '规则版本描述',
  `rule_title` varchar(100) NOT NULL COMMENT '规则标题',
  `rule_desc` varchar(200) DEFAULT NULL COMMENT '规则描述/应用场景说明',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` text,
  `diag_names` text,
  `rule_form_id` varchar(8000) DEFAULT NULL COMMENT '规则内所有表单ID，逗号分隔',
  `rule_form_title` varchar(1000) DEFAULT NULL COMMENT '表单名称',
  `rule_json` longtext NOT NULL COMMENT '随访规则完整json串，增加任务疾病补充说明字段',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `rule_type` int NOT NULL DEFAULT '2' COMMENT '规则类型 2院级随访 4专科随访 5宣教规则 13:服务规则',
  `rule_education_id` varchar(4000) DEFAULT NULL COMMENT '规则内所有宣教ID，逗号分隔',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `edu_rule_category_id` varchar(100) DEFAULT NULL COMMENT '类别编码',
  `edu_rule_category_name` varchar(100) DEFAULT NULL COMMENT '类别名称',
  `rule_pat_source` varchar(20) DEFAULT NULL COMMENT '患者来源',
  `rule_pat_source_name` varchar(100) DEFAULT NULL COMMENT '患者来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `pack_rule_type_code` varchar(20) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `pack_rule_type_name` varchar(50) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `is_pack_rule` varchar(10) DEFAULT NULL COMMENT '路径标志：0:规则 1：路径',
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `diagnosis_type` varchar(32) DEFAULT '' COMMENT '普通版 regular, 高血压版 hypertension,糖尿病版 diabetes,人流、产后版 abortionPostpartum,饮食建议版 dietAdvice;',
  `edu_library` text COMMENT '宣教',
  `form_library` text COMMENT '表单',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `release_notes` varchar(500) DEFAULT NULL COMMENT '发布说明',
  `phone_task_nums` int DEFAULT NULL COMMENT '电话数量搜索用',
  `edu_num` int DEFAULT NULL COMMENT '宣教数量',
  `form_num` int DEFAULT NULL COMMENT '表单数据',
  `remind_num` int DEFAULT NULL COMMENT '患者提醒的数量',
  `label_codes_old` text,
  `label_names_old` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规则表';

-- ----------------------------
-- Table structure for rule_back20240321
-- ----------------------------
DROP TABLE IF EXISTS `rule_back20240321`;
CREATE TABLE `rule_back20240321` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `rule_id` varchar(32) NOT NULL COMMENT '规则ID',
  `rule_version` decimal(7,1) NOT NULL COMMENT '规则版本',
  `rule_version_desc` varchar(100) DEFAULT NULL COMMENT '规则版本描述',
  `rule_title` varchar(100) NOT NULL COMMENT '规则标题',
  `rule_desc` varchar(200) DEFAULT NULL COMMENT '规则描述/应用场景说明',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(2000) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(2000) DEFAULT NULL COMMENT '关联疾病名称',
  `rule_form_id` varchar(7000) DEFAULT NULL,
  `rule_form_title` varchar(1000) DEFAULT NULL,
  `rule_json` longtext,
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `rule_type` int NOT NULL DEFAULT '2' COMMENT '规则类型 2院级随访 4专科随访 5宣教规则',
  `rule_education_id` varchar(3200) DEFAULT NULL,
  `dept_codes` varchar(1000) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `edu_rule_category_id` varchar(100) DEFAULT NULL COMMENT '类别编码',
  `edu_rule_category_name` varchar(100) DEFAULT NULL COMMENT '类别名称',
  `rule_pat_source` varchar(20) DEFAULT NULL COMMENT '患者来源',
  `rule_pat_source_name` varchar(100) DEFAULT NULL COMMENT '患者来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `diagnosis_type` varchar(32) DEFAULT '' COMMENT '普通版 regular, 高血压版 hypertension,糖尿病版 diabetes,人流、产后版 abortionPostpartum,饮食建议版 dietAdvice;',
  `edu_library` text COMMENT '宣教',
  `form_library` text COMMENT '表单',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `pack_rule_type_code` varchar(32) DEFAULT NULL,
  `pack_rule_type_name` varchar(32) DEFAULT NULL,
  `is_pack_rule` varchar(32) DEFAULT NULL,
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `release_notes` varchar(500) DEFAULT NULL COMMENT '发布说明',
  `phone_task_nums` int DEFAULT NULL COMMENT '电话数量搜索用',
  `edu_num` int DEFAULT NULL COMMENT '宣教数量',
  `form_num` int DEFAULT NULL COMMENT '表单数据',
  `remind_num` int DEFAULT NULL COMMENT '患者提醒的数量',
  `label_codes_old` text,
  `label_names_old` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='规则表';

-- ----------------------------
-- Table structure for rule_copy1
-- ----------------------------
DROP TABLE IF EXISTS `rule_copy1`;
CREATE TABLE `rule_copy1` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `rule_id` varchar(32) NOT NULL COMMENT '规则ID',
  `rule_version` decimal(7,1) NOT NULL COMMENT '规则版本',
  `rule_version_desc` varchar(100) DEFAULT NULL COMMENT '规则版本描述',
  `rule_title` varchar(100) NOT NULL COMMENT '规则标题',
  `rule_desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则描述/应用场景说明',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` text,
  `diag_names` text,
  `rule_form_id` varchar(8000) DEFAULT NULL COMMENT '规则内所有表单ID，逗号分隔',
  `rule_form_title` varchar(1000) DEFAULT NULL COMMENT '表单名称',
  `rule_json` longtext NOT NULL COMMENT '随访规则完整json串，增加任务疾病补充说明字段',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `rule_type` int NOT NULL DEFAULT '2' COMMENT '规则类型 2院级随访 4专科随访 5宣教规则 13:服务规则',
  `rule_education_id` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则内所有宣教ID，逗号分隔',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `edu_rule_category_id` varchar(20) DEFAULT NULL COMMENT '类别编码',
  `edu_rule_category_name` varchar(100) DEFAULT NULL COMMENT '类别名称',
  `rule_pat_source` varchar(20) DEFAULT NULL COMMENT '患者来源',
  `rule_pat_source_name` varchar(100) DEFAULT NULL COMMENT '患者来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `pack_rule_type_code` varchar(20) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `pack_rule_type_name` varchar(50) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `is_pack_rule` varchar(10) DEFAULT NULL COMMENT '路径标志：0:规则 1：路径',
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `diagnosis_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '普通版 regular, 高血压版 hypertension,糖尿病版 diabetes,人流、产后版 abortionPostpartum,饮食建议版 dietAdvice;',
  `edu_library` text COMMENT '宣教',
  `form_library` text COMMENT '表单',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `release_notes` varchar(500) DEFAULT NULL COMMENT '发布说明',
  `phone_task_nums` int DEFAULT NULL COMMENT '电话数量搜索用',
  `edu_num` int DEFAULT NULL COMMENT '宣教数量',
  `form_num` int DEFAULT NULL COMMENT '表单数据',
  `remind_num` int DEFAULT NULL COMMENT '患者提醒的数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ruleId` (`rule_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规则表';

-- ----------------------------
-- Table structure for rule_share_link
-- ----------------------------
DROP TABLE IF EXISTS `rule_share_link`;
CREATE TABLE `rule_share_link` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `rule_id` varchar(64) NOT NULL COMMENT '规则主键',
  `rule_title` varchar(256) NOT NULL COMMENT '规则名称',
  `rule_rule_id` varchar(64) NOT NULL COMMENT '规则rule_id',
  `rule_version` varchar(64) NOT NULL COMMENT '规则版本',
  `share_user_id` varchar(64) NOT NULL COMMENT '分享人id',
  `share_user_name` varchar(64) NOT NULL COMMENT '分享人名字',
  `share_link` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '链接',
  `share_link_key` varchar(64) NOT NULL COMMENT '链接密钥',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `expires_time` datetime DEFAULT NULL COMMENT '失效时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='规则分享链接表';

-- ----------------------------
-- Table structure for rule_备份
-- ----------------------------
DROP TABLE IF EXISTS `rule_备份`;
CREATE TABLE `rule_备份` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `rule_id` varchar(32) NOT NULL COMMENT '规则ID',
  `rule_version` decimal(7,1) NOT NULL COMMENT '规则版本',
  `rule_version_desc` varchar(100) DEFAULT NULL COMMENT '规则版本描述',
  `rule_title` varchar(100) NOT NULL COMMENT '规则标题',
  `rule_desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则描述/应用场景说明',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` text,
  `diag_names` text,
  `rule_form_id` varchar(8000) DEFAULT NULL COMMENT '规则内所有表单ID，逗号分隔',
  `rule_form_title` varchar(1000) DEFAULT NULL COMMENT '表单名称',
  `rule_json` longtext NOT NULL COMMENT '随访规则完整json串，增加任务疾病补充说明字段',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `rule_type` int NOT NULL DEFAULT '2' COMMENT '规则类型 2院级随访 4专科随访 5宣教规则 13:服务规则',
  `rule_education_id` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则内所有宣教ID，逗号分隔',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `edu_rule_category_id` varchar(20) DEFAULT NULL COMMENT '类别编码',
  `edu_rule_category_name` varchar(100) DEFAULT NULL COMMENT '类别名称',
  `rule_pat_source` varchar(20) DEFAULT NULL COMMENT '患者来源',
  `rule_pat_source_name` varchar(100) DEFAULT NULL COMMENT '患者来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `pack_rule_type_code` varchar(20) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `pack_rule_type_name` varchar(50) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `is_pack_rule` varchar(10) DEFAULT NULL COMMENT '路径标志：0:规则 1：路径',
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `diagnosis_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '普通版 regular, 高血压版 hypertension,糖尿病版 diabetes,人流、产后版 abortionPostpartum,饮食建议版 dietAdvice;',
  `edu_library` text COMMENT '宣教',
  `form_library` text COMMENT '表单',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `release_notes` varchar(500) DEFAULT NULL COMMENT '发布说明',
  `phone_task_nums` int DEFAULT NULL COMMENT '电话数量搜索用',
  `edu_num` int DEFAULT NULL COMMENT '宣教数量',
  `form_num` int DEFAULT NULL COMMENT '表单数据',
  `remind_num` int DEFAULT NULL COMMENT '患者提醒的数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ruleId` (`rule_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规则表';

-- ----------------------------
-- Table structure for rule_备份09271733
-- ----------------------------
DROP TABLE IF EXISTS `rule_备份09271733`;
CREATE TABLE `rule_备份09271733` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `rule_id` varchar(32) NOT NULL COMMENT '规则ID',
  `rule_version` decimal(7,1) NOT NULL COMMENT '规则版本',
  `rule_version_desc` varchar(100) DEFAULT NULL COMMENT '规则版本描述',
  `rule_title` varchar(100) NOT NULL COMMENT '规则标题',
  `rule_desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则描述/应用场景说明',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` text,
  `diag_names` text,
  `rule_form_id` varchar(8000) DEFAULT NULL COMMENT '规则内所有表单ID，逗号分隔',
  `rule_form_title` varchar(1000) DEFAULT NULL COMMENT '表单名称',
  `rule_json` longtext NOT NULL COMMENT '随访规则完整json串，增加任务疾病补充说明字段',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `rule_type` int NOT NULL DEFAULT '2' COMMENT '规则类型 2院级随访 4专科随访 5宣教规则 13:服务规则',
  `rule_education_id` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则内所有宣教ID，逗号分隔',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `edu_rule_category_id` varchar(20) DEFAULT NULL COMMENT '类别编码',
  `edu_rule_category_name` varchar(100) DEFAULT NULL COMMENT '类别名称',
  `rule_pat_source` varchar(20) DEFAULT NULL COMMENT '患者来源',
  `rule_pat_source_name` varchar(100) DEFAULT NULL COMMENT '患者来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `pack_rule_type_code` varchar(20) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `pack_rule_type_name` varchar(50) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `is_pack_rule` varchar(10) DEFAULT NULL COMMENT '路径标志：0:规则 1：路径',
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `diagnosis_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '普通版 regular, 高血压版 hypertension,糖尿病版 diabetes,人流、产后版 abortionPostpartum,饮食建议版 dietAdvice;',
  `edu_library` text COMMENT '宣教',
  `form_library` text COMMENT '表单',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `release_notes` varchar(500) DEFAULT NULL COMMENT '发布说明',
  `phone_task_nums` int DEFAULT NULL COMMENT '电话数量搜索用',
  `edu_num` int DEFAULT NULL COMMENT '宣教数量',
  `form_num` int DEFAULT NULL COMMENT '表单数据',
  `remind_num` int DEFAULT NULL COMMENT '患者提醒的数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ruleId` (`rule_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规则表';

-- ----------------------------
-- Table structure for rule废弃
-- ----------------------------
DROP TABLE IF EXISTS `rule废弃`;
CREATE TABLE `rule废弃` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `rule_id` varchar(32) NOT NULL COMMENT '规则ID',
  `rule_version` decimal(7,1) NOT NULL COMMENT '规则版本',
  `rule_version_desc` varchar(100) DEFAULT NULL COMMENT '规则版本描述',
  `rule_title` varchar(100) NOT NULL COMMENT '规则标题',
  `rule_desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则描述/应用场景说明',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` text,
  `diag_names` text,
  `rule_form_id` varchar(8000) DEFAULT NULL COMMENT '规则内所有表单ID，逗号分隔',
  `rule_form_title` varchar(1000) DEFAULT NULL COMMENT '表单名称',
  `rule_json` longtext NOT NULL COMMENT '随访规则完整json串，增加任务疾病补充说明字段',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `rule_type` int NOT NULL DEFAULT '2' COMMENT '规则类型 2院级随访 4专科随访 5宣教规则 13:服务规则',
  `rule_education_id` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '规则内所有宣教ID，逗号分隔',
  `dept_codes` varchar(255) DEFAULT NULL,
  `dept_names` varchar(1000) DEFAULT NULL,
  `edu_rule_category_id` varchar(20) DEFAULT NULL COMMENT '类别编码',
  `edu_rule_category_name` varchar(100) DEFAULT NULL COMMENT '类别名称',
  `rule_pat_source` varchar(20) DEFAULT NULL COMMENT '患者来源',
  `rule_pat_source_name` varchar(100) DEFAULT NULL COMMENT '患者来源名称',
  `creator_id` varchar(32) DEFAULT NULL,
  `category_id` varchar(32) DEFAULT NULL,
  `source_hosp_id` varchar(150) DEFAULT NULL,
  `pack_rule_type_code` varchar(20) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `pack_rule_type_name` varchar(50) DEFAULT NULL COMMENT '路径类型 1全院随访、2病区随访、3病区宣教、4通用宣教',
  `is_pack_rule` varchar(10) DEFAULT NULL COMMENT '路径标志：0:规则 1：路径',
  `synch_hosp_flag` int DEFAULT NULL,
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `is_delete_cloud` int DEFAULT NULL COMMENT '云端删除',
  `diagnosis_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '普通版 regular, 高血压版 hypertension,糖尿病版 diabetes,人流、产后版 abortionPostpartum,饮食建议版 dietAdvice;',
  `edu_library` text COMMENT '宣教',
  `form_library` text COMMENT '表单',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `release_notes` varchar(500) DEFAULT NULL COMMENT '发布说明',
  `phone_task_nums` int DEFAULT NULL COMMENT '电话数量搜索用',
  `edu_num` int DEFAULT NULL COMMENT '宣教数量',
  `form_num` int DEFAULT NULL COMMENT '表单数据',
  `remind_num` int DEFAULT NULL COMMENT '患者提醒的数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ruleId` (`rule_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规则表';

-- ----------------------------
-- Table structure for sdt_goods_hosp_distribution
-- ----------------------------
DROP TABLE IF EXISTS `sdt_goods_hosp_distribution`;
CREATE TABLE `sdt_goods_hosp_distribution` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院机构代码',
  `content_type` int DEFAULT NULL COMMENT '内容类型  0-商品  1-宣教  2-表单',
  `content_id` varchar(32) NOT NULL COMMENT '内容id',
  `content_name` varchar(200) DEFAULT NULL COMMENT '内容名称',
  `success_flag` int DEFAULT NULL COMMENT '0:失败，1成功  2:等待',
  `reason_type` int DEFAULT NULL COMMENT '理由类型 1：映射 2医院网络异常',
  `reason_desc` varchar(2000) DEFAULT NULL COMMENT '同步失败原因',
  `success_time` datetime DEFAULT NULL COMMENT '下发成功时间',
  `distribution_time` datetime DEFAULT NULL COMMENT '分配时间',
  `distribution_content` mediumtext COMMENT '下发内容',
  `distribution_count` int DEFAULT '0' COMMENT '下发次数',
  `is_delete` int DEFAULT '0' COMMENT '删除标记',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `content_label_code` varchar(1000) DEFAULT NULL COMMENT '内容标签code',
  `content_label_name` varchar(1000) DEFAULT NULL COMMENT '内容标签name',
  `issuer` varchar(1000) DEFAULT NULL COMMENT '下发人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规范化诊疗商品下发表';

-- ----------------------------
-- Table structure for sdt_goods_hosp_distribution_record
-- ----------------------------
DROP TABLE IF EXISTS `sdt_goods_hosp_distribution_record`;
CREATE TABLE `sdt_goods_hosp_distribution_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `relation_id` varchar(32) NOT NULL COMMENT '关联id',
  `success_flag` int DEFAULT NULL COMMENT '0:失败，1成功  2:等待',
  `reason_type` int DEFAULT NULL COMMENT '理由类型 1：映射 2医院网络异常',
  `reason_desc` varchar(2000) DEFAULT NULL COMMENT '下发失败原因',
  `distribution_time` datetime DEFAULT NULL COMMENT '下发时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标记',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='规范化诊疗商品下发记录表';

-- ----------------------------
-- Table structure for service_products
-- ----------------------------
DROP TABLE IF EXISTS `service_products`;
CREATE TABLE `service_products` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `product_id` varchar(32) DEFAULT NULL,
  `version` decimal(7,1) DEFAULT NULL COMMENT '自增长版本',
  `business_version` varchar(100) DEFAULT NULL COMMENT '业务版本',
  `open_status` int DEFAULT NULL COMMENT '1开0关',
  `release_status` int DEFAULT NULL COMMENT '1发布0未发布',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '1删除0未删除',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `out_title` varchar(100) DEFAULT NULL COMMENT '对外展示名称',
  `inner_title` varchar(100) DEFAULT NULL COMMENT '对内展示名称',
  `description` varchar(800) DEFAULT NULL COMMENT '描述说明',
  `diag_codes` varchar(800) DEFAULT NULL COMMENT '适用疾病编码多个,分隔',
  `diag_names` varchar(800) DEFAULT NULL COMMENT '适用疾病名称多个,分隔',
  `dept_codes` varchar(800) DEFAULT NULL COMMENT '科室编码多个,分隔',
  `dept_names` varchar(800) DEFAULT NULL COMMENT '科室名称多个,分隔',
  `label_codes` varchar(800) DEFAULT NULL COMMENT '内容标签编码多个,分隔',
  `label_names` varchar(800) DEFAULT NULL COMMENT '内容标签名称多个,分隔',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  `stop_reason` varchar(600) DEFAULT NULL COMMENT '关闭理由',
  `release_instruction` varchar(600) DEFAULT NULL COMMENT '发布说明',
  `authorized_hospital_status` int DEFAULT NULL COMMENT '授权医院状态0全部可见,1排除医院，2包含医院',
  `authorized_hosp_names` varchar(2000) DEFAULT NULL COMMENT '授权医院状态对应医院',
  `authorized_hosp_codes` varchar(1000) DEFAULT NULL COMMENT '授权医院状态对应医院',
  `specific_medical_codes` varchar(200) DEFAULT NULL COMMENT '专项医疗数据编码',
  `specific_medical_names` varchar(1000) DEFAULT NULL,
  `preach_education_name` varchar(255) DEFAULT NULL,
  `preach_education_preview_url` varchar(200) DEFAULT NULL,
  `preach_education_id` varchar(32) DEFAULT NULL COMMENT '宣讲宣教id',
  `special_disease_archives_id` varchar(32) DEFAULT NULL COMMENT '专病档案id',
  `special_disease_archives_name` varchar(255) DEFAULT NULL,
  `package_server_list` blob,
  `phone_task_base_time_name` varchar(60) DEFAULT NULL,
  `phone_task_base_time_code` varchar(32) DEFAULT NULL COMMENT '电话任务基线',
  `phone_task_num` int DEFAULT NULL COMMENT '电话任务数量',
  `phone_task_list` text,
  `management_time_type` varchar(3) DEFAULT NULL,
  `is_other_management_time` int DEFAULT NULL COMMENT '1其他管理时常',
  `recommend_charge_type` varchar(3) DEFAULT NULL,
  `is_other_recommend_charge` int DEFAULT NULL,
  `consult_open_status` tinyint(1) DEFAULT NULL COMMENT '咨询1开0关',
  `protective_medical_status` tinyint(1) DEFAULT NULL COMMENT '保护性医疗1是0否',
  `team_set_type` varchar(32) DEFAULT NULL COMMENT '鍥㈤槦璁剧疆',
  `exception_rule_type_name` varchar(255) DEFAULT NULL,
  `exception_rule_type` varchar(32) DEFAULT NULL COMMENT '异常规则类型',
  `ai_comment_type` varchar(32) DEFAULT NULL COMMENT 'ai点评类型',
  `ai_comment_type_name` varchar(255) DEFAULT NULL,
  `close_reason` varchar(800) DEFAULT NULL COMMENT '关闭理由',
  `use_hosp_codes` varchar(1200) DEFAULT NULL COMMENT '使用医院code',
  `use_hosp_names` varchar(1200) DEFAULT NULL COMMENT '使用医院name',
  `serve_patient_num` int DEFAULT NULL COMMENT '服务患者数',
  `accumulate_patient_num` int DEFAULT NULL COMMENT '累计患者数',
  `editor_id` varchar(32) DEFAULT NULL,
  `editor_name` varchar(128) DEFAULT NULL,
  `creator_id` varchar(32) DEFAULT NULL,
  `creator_name` varchar(255) DEFAULT NULL,
  `dept_codes_list` varchar(1500) DEFAULT NULL COMMENT '科室编码前端用',
  `diag_level_compilation` text,
  `rule_ids` text COMMENT '服务包id',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `hide_status` int DEFAULT '0' COMMENT '1隐藏0不隐藏',
  `authorize_hospital_extend` varchar(800) DEFAULT NULL COMMENT '授权医院结构前端扩展用',
  `update_level` int DEFAULT NULL COMMENT '更新级别0',
  `nutrition_program_open_status` int DEFAULT '0' COMMENT '个性化营养方案1开0关',
  `nutrition_program_value_rule` int DEFAULT NULL COMMENT '个性化营养方案取值规则0向上1向下',
  `label_codes_old` varchar(300) DEFAULT NULL,
  `label_names_old` varchar(300) DEFAULT NULL,
  `drug_remind_flag` tinyint DEFAULT '0' COMMENT '用药闹钟设置 0:关 1:开',
  `report_type_config` varchar(500) DEFAULT NULL COMMENT '报告类型配置',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products1
-- ----------------------------
DROP TABLE IF EXISTS `service_products1`;
CREATE TABLE `service_products1` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `product_id` varchar(32) DEFAULT NULL,
  `inner_title` varchar(100) DEFAULT NULL COMMENT '对内展示名称',
  `out_title` varchar(100) DEFAULT NULL COMMENT '对外展示名称',
  `description` varchar(800) DEFAULT NULL COMMENT '描述说明',
  `version` decimal(7,1) DEFAULT NULL COMMENT '自增长版本',
  `business_version` varchar(100) DEFAULT NULL COMMENT '业务版本',
  `diag_codes` varchar(800) DEFAULT NULL COMMENT '适用疾病编码多个,分隔',
  `diag_names` varchar(800) DEFAULT NULL COMMENT '适用疾病名称多个,分隔',
  `dept_codes` varchar(800) DEFAULT NULL COMMENT '科室编码多个,分隔',
  `dept_names` varchar(800) DEFAULT NULL COMMENT '科室名称多个,分隔',
  `label_codes` varchar(800) DEFAULT NULL COMMENT '内容标签编码多个,分隔',
  `label_names` varchar(800) DEFAULT NULL COMMENT '内容标签名称多个,分隔',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  `open_status` int DEFAULT NULL COMMENT '1开0关',
  `stop_reason` varchar(600) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '关闭理由',
  `release_status` int DEFAULT NULL COMMENT '1发布0未发布',
  `release_instruction` varchar(600) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '发布说明',
  `authorized_hospital_status` int DEFAULT NULL COMMENT '授权医院状态0全部可见,1排除医院，2包含医院',
  `authorized_hosp_names` varchar(2000) DEFAULT NULL COMMENT '授权医院状态对应医院',
  `authorized_hosp_codes` varchar(1000) DEFAULT NULL COMMENT '授权医院状态对应医院',
  `specific_medical_codes` varchar(200) DEFAULT NULL COMMENT '专项医疗数据编码',
  `specific_medical_names` varchar(1000) DEFAULT NULL,
  `preach_education_name` varchar(255) DEFAULT NULL,
  `preach_education_id` varchar(32) DEFAULT NULL COMMENT '宣讲宣教id',
  `special_disease_archives_id` varchar(32) DEFAULT NULL COMMENT '专病档案id',
  `special_disease_archives_name` varchar(255) DEFAULT NULL,
  `package_server_list` varchar(800) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '服务专题包id',
  `phone_task_base_time_name` varchar(60) DEFAULT NULL,
  `phone_task_base_time_code` varchar(32) DEFAULT NULL COMMENT '电话任务基线',
  `phone_task_num` int DEFAULT NULL COMMENT '电话任务数量',
  `phone_task_list` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '电话任务详情',
  `management_time_type` int DEFAULT NULL,
  `is_other_management_time` int DEFAULT NULL COMMENT '1其他管理时常',
  `recommend_charge_type` int DEFAULT NULL,
  `is_other_recommend_charge` int DEFAULT NULL,
  `consult_open_status` tinyint(1) DEFAULT NULL COMMENT '咨询1开0关',
  `protective_medical_status` tinyint(1) DEFAULT NULL COMMENT '保护性医疗1是0否',
  `team_set_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '鍥㈤槦璁剧疆',
  `exception_rule_type_name` varchar(255) DEFAULT NULL,
  `exception_rule_type` varchar(32) DEFAULT NULL COMMENT '异常规则类型',
  `ai_comment_type` varchar(32) DEFAULT NULL COMMENT 'ai点评类型',
  `ai_comment_type_name` varchar(255) DEFAULT NULL,
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '1删除0未删除',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) DEFAULT NULL,
  `editor_name` varchar(128) DEFAULT NULL,
  `close_reason` varchar(800) DEFAULT NULL COMMENT '关闭理由',
  `use_hosp_codes` varchar(1200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '使用医院code',
  `use_hosp_names` varchar(1200) DEFAULT NULL COMMENT '使用医院name',
  `serve_patient_num` int DEFAULT NULL COMMENT '服务患者数',
  `accumulate_patient_num` int DEFAULT NULL COMMENT '累计患者数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_attr
-- ----------------------------
DROP TABLE IF EXISTS `service_products_attr`;
CREATE TABLE `service_products_attr` (
  `id` varchar(32) NOT NULL,
  `attr_type` int DEFAULT NULL COMMENT '0适用疾病1适用科室2适用标签3授权医院4编辑人',
  `attr_code` varchar(255) DEFAULT NULL COMMENT '属性编码',
  `attr_name` varchar(255) DEFAULT NULL COMMENT '属性名称',
  `product_id` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_attr1
-- ----------------------------
DROP TABLE IF EXISTS `service_products_attr1`;
CREATE TABLE `service_products_attr1` (
  `id` varchar(32) NOT NULL,
  `attr_type` int DEFAULT NULL COMMENT '0适用疾病1适用科室2适用标签3授权医院4编辑人',
  `attr_code` varchar(255) DEFAULT NULL COMMENT '属性编码',
  `attr_name` varchar(255) DEFAULT NULL COMMENT '属性名称',
  `product_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_back20240321
-- ----------------------------
DROP TABLE IF EXISTS `service_products_back20240321`;
CREATE TABLE `service_products_back20240321` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `product_id` varchar(32) DEFAULT NULL,
  `version` decimal(7,1) DEFAULT NULL COMMENT '自增长版本',
  `business_version` varchar(100) DEFAULT NULL COMMENT '业务版本',
  `open_status` int DEFAULT NULL COMMENT '1开0关',
  `release_status` int DEFAULT NULL COMMENT '1发布0未发布',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '1删除0未删除',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `out_title` varchar(100) DEFAULT NULL COMMENT '对外展示名称',
  `inner_title` varchar(100) DEFAULT NULL COMMENT '对内展示名称',
  `description` varchar(800) DEFAULT NULL COMMENT '描述说明',
  `diag_codes` varchar(800) DEFAULT NULL COMMENT '适用疾病编码多个,分隔',
  `diag_names` varchar(800) DEFAULT NULL COMMENT '适用疾病名称多个,分隔',
  `dept_codes` varchar(800) DEFAULT NULL COMMENT '科室编码多个,分隔',
  `dept_names` varchar(800) DEFAULT NULL COMMENT '科室名称多个,分隔',
  `label_codes` varchar(800) DEFAULT NULL COMMENT '内容标签编码多个,分隔',
  `label_names` varchar(800) DEFAULT NULL COMMENT '内容标签名称多个,分隔',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  `stop_reason` varchar(600) DEFAULT NULL COMMENT '关闭理由',
  `release_instruction` varchar(600) DEFAULT NULL COMMENT '发布说明',
  `authorized_hospital_status` int DEFAULT NULL COMMENT '授权医院状态0全部可见,1排除医院，2包含医院',
  `authorized_hosp_names` varchar(2000) DEFAULT NULL COMMENT '授权医院状态对应医院',
  `authorized_hosp_codes` varchar(1000) DEFAULT NULL COMMENT '授权医院状态对应医院',
  `specific_medical_codes` varchar(200) DEFAULT NULL COMMENT '专项医疗数据编码',
  `specific_medical_names` varchar(1000) DEFAULT NULL,
  `preach_education_name` varchar(255) DEFAULT NULL,
  `preach_education_preview_url` varchar(200) DEFAULT NULL,
  `preach_education_id` varchar(32) DEFAULT NULL COMMENT '宣讲宣教id',
  `special_disease_archives_id` varchar(32) DEFAULT NULL COMMENT '专病档案id',
  `special_disease_archives_name` varchar(255) DEFAULT NULL,
  `package_server_list` blob,
  `phone_task_base_time_name` varchar(60) DEFAULT NULL,
  `phone_task_base_time_code` varchar(32) DEFAULT NULL COMMENT '电话任务基线',
  `phone_task_num` int DEFAULT NULL COMMENT '电话任务数量',
  `phone_task_list` text,
  `management_time_type` varchar(3) DEFAULT NULL,
  `is_other_management_time` int DEFAULT NULL COMMENT '1其他管理时常',
  `recommend_charge_type` varchar(3) DEFAULT NULL,
  `is_other_recommend_charge` int DEFAULT NULL,
  `consult_open_status` tinyint(1) DEFAULT NULL COMMENT '咨询1开0关',
  `protective_medical_status` tinyint(1) DEFAULT NULL COMMENT '保护性医疗1是0否',
  `team_set_type` varchar(32) DEFAULT NULL COMMENT '鍥㈤槦璁剧疆',
  `exception_rule_type_name` varchar(255) DEFAULT NULL,
  `exception_rule_type` varchar(32) DEFAULT NULL COMMENT '异常规则类型',
  `ai_comment_type` varchar(32) DEFAULT NULL COMMENT 'ai点评类型',
  `ai_comment_type_name` varchar(255) DEFAULT NULL,
  `close_reason` varchar(800) DEFAULT NULL COMMENT '关闭理由',
  `use_hosp_codes` varchar(1200) DEFAULT NULL COMMENT '使用医院code',
  `use_hosp_names` varchar(1200) DEFAULT NULL COMMENT '使用医院name',
  `serve_patient_num` int DEFAULT NULL COMMENT '服务患者数',
  `accumulate_patient_num` int DEFAULT NULL COMMENT '累计患者数',
  `editor_id` varchar(32) DEFAULT NULL,
  `editor_name` varchar(128) DEFAULT NULL,
  `creator_id` varchar(32) DEFAULT NULL,
  `creator_name` varchar(255) DEFAULT NULL,
  `dept_codes_list` varchar(1500) DEFAULT NULL COMMENT '科室编码前端用',
  `diag_level_compilation` text,
  `rule_ids` text COMMENT '服务包id',
  `use_time` decimal(10,2) DEFAULT NULL COMMENT '消耗时间',
  `total_use_time` decimal(10,2) DEFAULT '0.00' COMMENT '总消耗时间',
  `hide_status` int DEFAULT '0' COMMENT '1隐藏0不隐藏',
  `update_level` int DEFAULT NULL COMMENT '更新级别0',
  `nutrition_program_open_status` int DEFAULT '0' COMMENT '个性化营养方案1开0关',
  `nutrition_program_value_rule` int DEFAULT NULL COMMENT '个性化营养方案取值规则0向上1向下',
  `label_codes_old` varchar(300) DEFAULT NULL,
  `label_names_old` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_base_time_specific_relation
-- ----------------------------
DROP TABLE IF EXISTS `service_products_base_time_specific_relation`;
CREATE TABLE `service_products_base_time_specific_relation` (
  `base_time_code` varchar(60) DEFAULT NULL COMMENT '专题包基线code',
  `base_time_name` varchar(150) DEFAULT NULL COMMENT '专题包基线名称',
  `specific_medical_code` varchar(60) DEFAULT NULL COMMENT '专项医疗数据项编码',
  `specific_medical_name` varchar(150) DEFAULT NULL COMMENT '专项医疗数据项名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_base_time_specific_relation1
-- ----------------------------
DROP TABLE IF EXISTS `service_products_base_time_specific_relation1`;
CREATE TABLE `service_products_base_time_specific_relation1` (
  `base_time_code` varchar(60) DEFAULT NULL COMMENT '专题包基线code',
  `base_time_name` varchar(150) DEFAULT NULL COMMENT '专题包基线名称',
  `specific_medical_code` varchar(60) DEFAULT NULL COMMENT '专项医疗数据项编码',
  `specific_medical_name` varchar(150) DEFAULT NULL COMMENT '专项医疗数据项名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_close_plan
-- ----------------------------
DROP TABLE IF EXISTS `service_products_close_plan`;
CREATE TABLE `service_products_close_plan` (
  `id` varchar(32) NOT NULL,
  `hosp_name` varchar(255) DEFAULT NULL,
  `plan_id` varchar(32) DEFAULT NULL,
  `plan_name` varchar(255) DEFAULT NULL,
  `rule_id` varchar(32) DEFAULT NULL,
  `rule_title` varchar(255) DEFAULT NULL,
  `close_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `product_primary_id` varchar(32) DEFAULT NULL,
  `product_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_distribute_history
-- ----------------------------
DROP TABLE IF EXISTS `service_products_distribute_history`;
CREATE TABLE `service_products_distribute_history` (
  `id` varchar(32) NOT NULL,
  `product_id` varchar(32) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `business_version` varchar(50) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `distribute_status` int DEFAULT NULL COMMENT '0待下发1下发成功2下发失败',
  `distribute_response` varchar(2000) DEFAULT NULL,
  `is_auto_update` int DEFAULT NULL COMMENT '1自动更新其他非自动更新',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_pack_convert
-- ----------------------------
DROP TABLE IF EXISTS `service_products_pack_convert`;
CREATE TABLE `service_products_pack_convert` (
  `id` varchar(32) NOT NULL,
  `products_id` varchar(32) DEFAULT NULL COMMENT '产品id',
  `pack_name` varchar(255) DEFAULT NULL COMMENT '路径名',
  `pack_id` varchar(32) DEFAULT NULL COMMENT '路径id',
  `server_pack_id` varchar(32) DEFAULT NULL COMMENT '服务路径id',
  `rule_name` varchar(255) DEFAULT NULL COMMENT '专题包名称',
  `rule_id` varchar(32) DEFAULT NULL COMMENT '专题包id',
  `data_type` varchar(255) DEFAULT NULL COMMENT '产品或商品',
  `relate_pack_name` varchar(255) DEFAULT NULL COMMENT '对应路径名',
  `relate_rule_name` varchar(255) DEFAULT NULL COMMENT '对应专题包',
  `relate_rule_id` varchar(32) DEFAULT NULL COMMENT '对应专题包id',
  `relate_products_id` varchar(32) DEFAULT NULL COMMENT '商品对应产品id',
  `inner_title` varchar(255) DEFAULT NULL COMMENT '内部名',
  `out_title` varchar(255) DEFAULT NULL COMMENT '外部名',
  `authorized_hosp_names` varchar(255) DEFAULT NULL COMMENT '适用医院',
  `protective_medical_status` varchar(10) DEFAULT NULL COMMENT '保护性医疗',
  `phone_task_base_time_name` varchar(50) DEFAULT NULL COMMENT '电话任务触发基线',
  `management_time_type` varchar(50) DEFAULT NULL COMMENT '管理时长',
  `recommend_charge_type` varchar(50) DEFAULT NULL COMMENT '推荐价格',
  `team_set_type` varchar(50) DEFAULT NULL COMMENT '服务类别',
  `consult_open_status` varchar(50) DEFAULT NULL COMMENT '咨询服务开关',
  `exception_rule_type_name` varchar(50) DEFAULT NULL COMMENT '异常规则',
  `ai_comment_type_name` varchar(50) DEFAULT NULL COMMENT '点评规则',
  `remark` varchar(2000) DEFAULT NULL COMMENT '备注（选填）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='路径转产品表';

-- ----------------------------
-- Table structure for service_products_pack_convert1
-- ----------------------------
DROP TABLE IF EXISTS `service_products_pack_convert1`;
CREATE TABLE `service_products_pack_convert1` (
  `id` varchar(32) NOT NULL,
  `products_id` varchar(32) DEFAULT NULL COMMENT '产品id',
  `pack_name` varchar(255) DEFAULT NULL COMMENT '路径名',
  `pack_id` varchar(32) DEFAULT NULL COMMENT '路径id',
  `server_pack_id` varchar(32) DEFAULT NULL COMMENT '服务路径id',
  `rule_name` varchar(255) DEFAULT NULL COMMENT '专题包名称',
  `rule_id` varchar(32) DEFAULT NULL COMMENT '专题包id',
  `data_type` varchar(255) DEFAULT NULL COMMENT '产品或商品',
  `relate_pack_name` varchar(255) DEFAULT NULL COMMENT '对应路径名',
  `relate_rule_name` varchar(255) DEFAULT NULL COMMENT '对应专题包',
  `relate_rule_id` varchar(32) DEFAULT NULL COMMENT '对应专题包id',
  `relate_products_id` varchar(0) DEFAULT NULL COMMENT '商品对应产品id',
  `inner_title` varchar(255) DEFAULT NULL COMMENT '内部名',
  `out_title` varchar(255) DEFAULT NULL COMMENT '外部名',
  `authorized_hosp_names` varchar(255) DEFAULT NULL COMMENT '适用医院',
  `protective_medical_status` varchar(10) DEFAULT NULL COMMENT '保护性医疗',
  `phone_task_base_time_name` varchar(50) DEFAULT NULL COMMENT '电话任务触发基线',
  `management_time_type` varchar(50) DEFAULT NULL COMMENT '管理时长',
  `recommend_charge_type` varchar(50) DEFAULT NULL COMMENT '推荐价格',
  `team_set_type` varchar(50) DEFAULT NULL COMMENT '服务类别',
  `consult_open_status` varchar(50) DEFAULT NULL COMMENT '咨询服务开关',
  `exception_rule_type_name` varchar(50) DEFAULT NULL COMMENT '异常规则',
  `ai_comment_type_name` varchar(50) DEFAULT NULL COMMENT '点评规则',
  `remark` varchar(2000) DEFAULT NULL COMMENT '备注（选填）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='路径转产品表';

-- ----------------------------
-- Table structure for service_products_quote_statistics
-- ----------------------------
DROP TABLE IF EXISTS `service_products_quote_statistics`;
CREATE TABLE `service_products_quote_statistics` (
  `product_id` varchar(32) NOT NULL COMMENT '主键',
  `use_hosp_num` int DEFAULT NULL COMMENT '使用医院数量',
  `serve_patient_num` int DEFAULT NULL COMMENT '服务患者数',
  `accumulate_patient_num` int DEFAULT NULL COMMENT '累计患者数',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='产品被引用统计数据';

-- ----------------------------
-- Table structure for service_products_resources
-- ----------------------------
DROP TABLE IF EXISTS `service_products_resources`;
CREATE TABLE `service_products_resources` (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `product_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `resources_id` varchar(32) DEFAULT NULL,
  `resources_name` varchar(800) DEFAULT NULL,
  `resources_type_name` varchar(255) DEFAULT NULL,
  `resources_type` int DEFAULT NULL COMMENT '0表单1宣教2宣教资料3专病档案',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_same_name
-- ----------------------------
DROP TABLE IF EXISTS `service_products_same_name`;
CREATE TABLE `service_products_same_name` (
  `same_name` varchar(2000) DEFAULT NULL COMMENT '同名'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_same_name1
-- ----------------------------
DROP TABLE IF EXISTS `service_products_same_name1`;
CREATE TABLE `service_products_same_name1` (
  `same_name` varchar(2000) DEFAULT NULL COMMENT '同名'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_products_sop_path
-- ----------------------------
DROP TABLE IF EXISTS `service_products_sop_path`;
CREATE TABLE `service_products_sop_path` (
  `id` varchar(32) COLLATE utf8mb3_general_ci NOT NULL,
  `product_id` varchar(32) COLLATE utf8mb3_general_ci NOT NULL COMMENT '产品id',
  `product_version_id` varchar(32) COLLATE utf8mb3_general_ci NOT NULL COMMENT '产品版本id',
  `time_node_type` int NOT NULL COMMENT '路径时间节点类型 0-开始服务后 1-加好友后',
  `time_node_day` int NOT NULL COMMENT '路径时间节点-天',
  `path_topic` varchar(50) COLLATE utf8mb3_general_ci NOT NULL COMMENT '话题',
  `push_content` text COLLATE utf8mb3_general_ci COMMENT '推送话术',
  `education_id` varchar(32) COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教id',
  `education_name` varchar(200) COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '宣教名称',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `operate_id` varchar(32) COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人id',
  `operate_name` varchar(225) COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人name',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='产品sop路径配置';

-- ----------------------------
-- Table structure for service_term
-- ----------------------------
DROP TABLE IF EXISTS `service_term`;
CREATE TABLE `service_term` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(255) DEFAULT NULL,
  `desc` varchar(2000) DEFAULT NULL COMMENT '描述',
  `label_codes` varchar(1000) DEFAULT NULL,
  `label_names` varchar(1000) DEFAULT NULL,
  `diag_codes` varchar(500) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_term_answer
-- ----------------------------
DROP TABLE IF EXISTS `service_term_answer`;
CREATE TABLE `service_term_answer` (
  `id` varchar(32) NOT NULL,
  `service_term_id` varchar(32) NOT NULL,
  `service_term_condition_id` varchar(32) NOT NULL,
  `form_id` varchar(32) NOT NULL,
  `form_name` varchar(255) DEFAULT NULL,
  `form_title_id` varchar(32) DEFAULT NULL COMMENT '题目',
  `form_title_name` varchar(255) DEFAULT NULL,
  `title_answer_json` text COMMENT 'json',
  `type` int DEFAULT NULL COMMENT '操作类型',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `form_version_id` varchar(32) NOT NULL COMMENT '表单升级版本id',
  `approach` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_term_condition
-- ----------------------------
DROP TABLE IF EXISTS `service_term_condition`;
CREATE TABLE `service_term_condition` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `service_term_id` varchar(32) DEFAULT NULL COMMENT '服务条件id',
  `service_term_name` varchar(255) DEFAULT NULL,
  `sex_code` varchar(1) DEFAULT NULL COMMENT '性别编码',
  `sex_name` varchar(10) DEFAULT NULL COMMENT '性别名称',
  `age_years_low` varchar(20) DEFAULT NULL COMMENT '年龄年下限值',
  `age_years_high` varchar(20) DEFAULT NULL COMMENT '年龄年上限值',
  `age_month_low` varchar(20) DEFAULT NULL COMMENT '年龄月下限值',
  `age_month_high` varchar(20) DEFAULT NULL COMMENT '年龄月上限值',
  `age_day_low` varchar(20) DEFAULT NULL COMMENT '年龄天下限值',
  `age_day_high` varchar(20) DEFAULT NULL COMMENT '年龄天上限值',
  `is_prescribe` varchar(2) DEFAULT NULL COMMENT '是否开药 0：没开 1：有开药',
  `contains_drug_code` varchar(200) DEFAULT NULL COMMENT '包含药品编码',
  `contains_drug_name` varchar(500) DEFAULT NULL COMMENT '包含药品名称',
  `contains_one_drug_code` varchar(200) DEFAULT NULL COMMENT '包含任一药品编码',
  `contains_one_drug_name` varchar(500) DEFAULT NULL COMMENT '包含任一药品名称',
  `not_contains_drug_code` varchar(200) DEFAULT NULL COMMENT '不包含药品编码',
  `not_contains_drug_name` varchar(500) DEFAULT NULL COMMENT '不包含药品名称',
  `not_contains_one_drug_code` varchar(200) DEFAULT NULL COMMENT '不包含任一药品编码',
  `not_contains_one_drug_name` varchar(500) DEFAULT NULL COMMENT '不包含任一药品名称',
  `contains_diagnosis_code` varchar(200) DEFAULT NULL COMMENT '包含诊断编码',
  `contains_diagnosis_name` varchar(500) DEFAULT NULL COMMENT '包含诊断名称',
  `contains_one_diagnosis_code` varchar(200) DEFAULT NULL COMMENT '包含任一诊断编码',
  `contains_one_diagnosis_name` varchar(500) DEFAULT NULL COMMENT '包含任一诊断名称',
  `not_contains_diagnosis_code` varchar(200) DEFAULT NULL COMMENT '不包含诊断编码',
  `not_contains_diagnosis_name` varchar(500) DEFAULT NULL COMMENT '不包含诊断名称',
  `not_contains_one_diagnosis_code` varchar(200) DEFAULT NULL COMMENT '不包含任一诊断编码',
  `not_contains_one_diagnosis_name` varchar(500) DEFAULT NULL COMMENT '不包含任一诊断名称',
  `contains_surgery_code` varchar(200) DEFAULT NULL COMMENT '包含手术编码',
  `contains_surgery_name` varchar(500) DEFAULT NULL COMMENT '包含手术名称',
  `contains_one_surgery_code` varchar(200) DEFAULT NULL COMMENT '包含任一手术编码',
  `contains_one_surgery_name` varchar(500) DEFAULT NULL COMMENT '包含任一手术名称',
  `not_contains_surgery_code` varchar(200) DEFAULT NULL COMMENT '不包含手术编码',
  `not_contains_surgery_name` varchar(500) DEFAULT NULL COMMENT '不包含手术名称',
  `not_contains_one_surgery_code` varchar(200) DEFAULT NULL COMMENT '不包含任一手术编码',
  `not_contains_one_surgery_name` varchar(500) DEFAULT NULL COMMENT '不包含任一手术名称',
  `surgery_name_include_text` varchar(500) DEFAULT NULL COMMENT '手术名称包含文字',
  `check_include_text` text COMMENT '检查包含文字(逗号隔开)',
  `check_code` varchar(50) DEFAULT NULL COMMENT '检查编码',
  `check_name` varchar(255) DEFAULT NULL COMMENT '检查名称',
  `check_not_include_text` text COMMENT '检查不包含文字(逗号隔开)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for service_term_condition_examine
-- ----------------------------
DROP TABLE IF EXISTS `service_term_condition_examine`;
CREATE TABLE `service_term_condition_examine` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `service_term_condition_id` varchar(32) DEFAULT NULL,
  `examine_code` varchar(20) DEFAULT NULL,
  `examine_name` varchar(255) DEFAULT NULL COMMENT '名称包含大项 范围和单位。',
  `range_low_numerical` varchar(255) DEFAULT NULL,
  `range_low_code` varchar(255) DEFAULT NULL,
  `range_low_name` varchar(255) DEFAULT NULL,
  `range_high_numerical` varchar(255) DEFAULT NULL,
  `range_high_code` varchar(255) DEFAULT NULL,
  `range_high_name` varchar(255) DEFAULT NULL,
  `abnormal_fluctuation` int DEFAULT NULL COMMENT '波动范围',
  `number_consecutive` int DEFAULT NULL COMMENT '连续异常次数',
  `abnormal_count_code` varchar(20) DEFAULT NULL COMMENT '异常值符号编码',
  `abnormal_count_name` varchar(50) DEFAULT NULL COMMENT '异常值符号名称',
  `abnormal_count_value` int DEFAULT NULL COMMENT '异常值范围值',
  `number_fluctuation` int DEFAULT NULL COMMENT '连续波动次数',
  `standard_low_value` int DEFAULT NULL,
  `standard_high_value` int DEFAULT NULL,
  `include_text` varchar(500) DEFAULT NULL COMMENT '包含文字',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for special_archive
-- ----------------------------
DROP TABLE IF EXISTS `special_archive`;
CREATE TABLE `special_archive` (
  `id` varchar(32) NOT NULL,
  `pack_id` varchar(32) NOT NULL COMMENT '路径id',
  `special_archive_type_code` varchar(20) DEFAULT NULL COMMENT '专病档案类型编码',
  `special_archive_type_name` varchar(50) DEFAULT NULL COMMENT '专病档案类型名称',
  `target_codes` varchar(500) DEFAULT NULL COMMENT '指标codes（上限10个）',
  `target_names` varchar(500) DEFAULT NULL COMMENT '指标names',
  `create_time` datetime DEFAULT NULL,
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for statistical_record
-- ----------------------------
DROP TABLE IF EXISTS `statistical_record`;
CREATE TABLE `statistical_record` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(15) NOT NULL COMMENT '医院编码',
  `statistical_type` int NOT NULL COMMENT '统计类型 1下载次数 2发送次数',
  `relation_type` int NOT NULL COMMENT '类型 1表单 2规则 3方案 4单题',
  `relation_id` varchar(32) NOT NULL COMMENT '表单、规则、方案等表主键ID',
  `statistical_count` int DEFAULT '0' COMMENT '统计数量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `statistical_date` varchar(20) DEFAULT NULL COMMENT '统计日期 yyyy-MM-dd',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='统计表';

-- ----------------------------
-- Table structure for surgery_library
-- ----------------------------
DROP TABLE IF EXISTS `surgery_library`;
CREATE TABLE `surgery_library` (
  `id` varchar(32) NOT NULL DEFAULT '0',
  `code` varchar(20) DEFAULT '' COMMENT '编码',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `additional_code` varchar(50) DEFAULT NULL COMMENT '附加名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `relation_type` int DEFAULT NULL COMMENT '1:适用于智宣教',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for surgery_library_h
-- ----------------------------
DROP TABLE IF EXISTS `surgery_library_h`;
CREATE TABLE `surgery_library_h` (
  `id` varchar(32) NOT NULL,
  `code` varchar(20) DEFAULT '' COMMENT '编码',
  `name` varchar(50) DEFAULT NULL,
  `additional_code` varchar(50) DEFAULT NULL COMMENT '附加名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `editor_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`,`hosp_code`) USING BTREE,
  KEY `idx_surgery_name_h` (`name`) USING BTREE,
  KEY `idx_surgery_code_h` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- ----------------------------
-- Table structure for surgery_library_map
-- ----------------------------
DROP TABLE IF EXISTS `surgery_library_map`;
CREATE TABLE `surgery_library_map` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` text,
  `hosp_surgery_code` text,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `editor_id` varchar(50) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_surgery_map` (`std_id`,`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for surgery_library_map_revert
-- ----------------------------
DROP TABLE IF EXISTS `surgery_library_map_revert`;
CREATE TABLE `surgery_library_map_revert` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '映射关系主键',
  `std_id` varchar(32) NOT NULL COMMENT '国标主键',
  `std_code` varchar(255) NOT NULL COMMENT '国标编码',
  `hosp_id` varchar(100) DEFAULT NULL,
  `hosp_surgery_code` varchar(100) DEFAULT NULL,
  `hosp_code` varchar(30) NOT NULL COMMENT '机构代码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_surgery_map` (`std_id`,`hosp_code`,`hosp_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for surgery_record
-- ----------------------------
DROP TABLE IF EXISTS `surgery_record`;
CREATE TABLE `surgery_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '机构代码',
  `inhosp_id` varchar(32) DEFAULT NULL COMMENT '住院记录ID',
  `organ_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pat_index_no` varchar(50) DEFAULT NULL COMMENT '患者索引号',
  `outhosp_no` varchar(50) DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '门诊流水号',
  `inhosp_no` varchar(50) DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '住院流水号',
  `surgery_no` varchar(50) DEFAULT NULL COMMENT '手术流水号',
  `surgery_seq_no` int DEFAULT NULL COMMENT '手术序号',
  `surgery_oper_code` varchar(50) DEFAULT NULL COMMENT '手术(操作)代码',
  `surgery_oper_name` varchar(50) DEFAULT NULL COMMENT '手术(操作)名称',
  `surgery_wound_categ_code` varchar(50) DEFAULT NULL COMMENT '手术切口类别代码',
  `surgery_wound_categ_name` varchar(50) DEFAULT NULL COMMENT '手术切口类别名称',
  `wound_healing_level_code` varchar(50) DEFAULT NULL COMMENT '手术切口愈合等级代码',
  `wound_healing_level_name` varchar(50) DEFAULT NULL COMMENT '手术切口愈合等级名称',
  `surgery_begin_date` varchar(25) DEFAULT NULL COMMENT '手术开始日期',
  `surgery_end_date` varchar(25) DEFAULT NULL COMMENT '手术结束日期',
  `surgery_dr_code` varchar(50) DEFAULT NULL COMMENT '手术医生工号',
  `surgery_dr_name` varchar(50) DEFAULT NULL COMMENT '手术医生姓名',
  `anes_method_code` varchar(50) DEFAULT NULL COMMENT '麻醉方式代码',
  `anes_method_name` varchar(50) DEFAULT NULL COMMENT '麻醉方式名称',
  `anes_dr_code` varchar(50) DEFAULT NULL COMMENT '麻醉医生工号',
  `anes_dr_name` varchar(50) DEFAULT NULL COMMENT '麻醉医生姓名',
  `surgery_level_code` varchar(50) DEFAULT NULL COMMENT '手术等级代码',
  `surgery_level_name` varchar(50) DEFAULT NULL COMMENT '手术登记名称',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `AK_surgery_record_index` (`inhosp_serial_no`,`surgery_no`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE,
  KEY `IDX_PATIENT_MAIN_ID` (`patient_main_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='手术记录';

-- ----------------------------
-- Table structure for sync_time
-- ----------------------------
DROP TABLE IF EXISTS `sync_time`;
CREATE TABLE `sync_time` (
  `id` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `function_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '功能代码',
  `function_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '功能名',
  `last_sync_time` datetime DEFAULT NULL COMMENT '最近一次同步时间',
  `sync_status` int NOT NULL COMMENT '初始化状态 0正常同步 1初始化',
  `quantity` int DEFAULT NULL COMMENT '每次处理条数',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin COMMENT='oss同步时间';

-- ----------------------------
-- Table structure for synch_hosp_record
-- ----------------------------
DROP TABLE IF EXISTS `synch_hosp_record`;
CREATE TABLE `synch_hosp_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院机构代码',
  `type` int DEFAULT NULL COMMENT '1，表单，2，宣讲，3，随访规则，4,：专科规则，5：表单总结',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联id',
  `relation_name` varchar(255) DEFAULT NULL COMMENT '关联名称',
  `create_time` timestamp DEFAULT NULL COMMENT '执行时间',
  `success_flag` int DEFAULT NULL COMMENT '0:失败，1成功',
  `synch_count` int DEFAULT NULL COMMENT '同步次数限制',
  `deal_count` int DEFAULT NULL COMMENT '执行次数',
  `reason_desc` varchar(2000) DEFAULT NULL COMMENT '同步失败原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_disease
-- ----------------------------
DROP TABLE IF EXISTS `t_disease`;
CREATE TABLE `t_disease` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `disease_id` varchar(32) NOT NULL COMMENT '历次编辑不变的ID',
  `name` varchar(50) DEFAULT NULL COMMENT '专病名称',
  `disease_version` decimal(7,1) NOT NULL COMMENT '升级版本号',
  `path_id` varchar(32) DEFAULT NULL COMMENT '关联路径id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `invalid_flag` int DEFAULT '1' COMMENT '作废标识(0:作废 1:有效) 2待发布',
  `platform_type` int DEFAULT NULL COMMENT '1:增值服务 ',
  `label_codes` varchar(500) DEFAULT NULL COMMENT '标签',
  `label_names` varchar(500) DEFAULT NULL COMMENT '标签名称',
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `desc` varchar(500) DEFAULT NULL COMMENT '说明',
  `dept_codes` varchar(255) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(1000) DEFAULT NULL COMMENT '科室名称',
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `label_codes_old` varchar(100) DEFAULT NULL,
  `label_names_old` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='新专科随访专病档案病种表';

-- ----------------------------
-- Table structure for t_disease_back20240321
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_back20240321`;
CREATE TABLE `t_disease_back20240321` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `disease_id` varchar(32) NOT NULL COMMENT '历次编辑不变的ID',
  `name` varchar(50) DEFAULT NULL COMMENT '专病名称',
  `disease_version` decimal(7,1) NOT NULL COMMENT '升级版本号',
  `path_id` varchar(32) DEFAULT NULL COMMENT '关联路径id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `invalid_flag` int DEFAULT '1' COMMENT '作废标识(0:作废 1:有效) 2待发布',
  `platform_type` int DEFAULT NULL COMMENT '1:增值服务 ',
  `label_codes` varchar(500) DEFAULT NULL COMMENT '标签',
  `label_names` varchar(500) DEFAULT NULL COMMENT '标签名称',
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `desc` varchar(500) DEFAULT NULL COMMENT '说明',
  `dept_codes` varchar(255) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(1000) DEFAULT NULL COMMENT '科室名称',
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `label_codes_old` varchar(100) DEFAULT NULL,
  `label_names_old` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='新专科随访专病档案病种表';

-- ----------------------------
-- Table structure for t_disease_category
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_category`;
CREATE TABLE `t_disease_category` (
  `id` varchar(32) NOT NULL,
  `disease_id` varchar(32) DEFAULT NULL COMMENT '关联病种id主键',
  `category_name` varchar(50) DEFAULT NULL COMMENT '菜单名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `sort_no` tinyint DEFAULT NULL COMMENT '顺序号',
  `status` int DEFAULT NULL COMMENT '0:无变化1:新增 2：修改 3：删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='新专科随访专病档案病种菜单表';

-- ----------------------------
-- Table structure for t_disease_category_cloud
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_category_cloud`;
CREATE TABLE `t_disease_category_cloud` (
  `id` varchar(32) NOT NULL,
  `disease_id` varchar(32) DEFAULT NULL COMMENT '关联病种id主键',
  `category_name` varchar(50) DEFAULT NULL COMMENT '菜单名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `sort_no` tinyint DEFAULT NULL COMMENT '顺序号',
  `status` int DEFAULT NULL COMMENT '0:无变化1:新增 2：修改 3：删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='新专科随访专病档案病种菜单表';

-- ----------------------------
-- Table structure for t_disease_category_form
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_category_form`;
CREATE TABLE `t_disease_category_form` (
  `id` varchar(32) NOT NULL,
  `category_id` varchar(32) DEFAULT NULL COMMENT '关联病种id',
  `form_key_id` varchar(32) DEFAULT NULL COMMENT '表单的主键',
  `form_id` varchar(32) DEFAULT NULL COMMENT '表单的formId',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='新专科随访专病档案病种菜单表单表';

-- ----------------------------
-- Table structure for t_disease_category_form_cloud
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_category_form_cloud`;
CREATE TABLE `t_disease_category_form_cloud` (
  `id` varchar(32) NOT NULL,
  `category_id` varchar(32) DEFAULT NULL COMMENT '关联病种id',
  `form_key_id` varchar(32) DEFAULT NULL COMMENT '表单的主键',
  `form_id` varchar(32) DEFAULT NULL COMMENT '表单的formId',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='新专科随访专病档案病种菜单表单表';

-- ----------------------------
-- Table structure for t_disease_cloud
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_cloud`;
CREATE TABLE `t_disease_cloud` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `disease_id` varchar(32) NOT NULL COMMENT '历次编辑不变的ID',
  `name` varchar(50) DEFAULT NULL COMMENT '专病名称',
  `disease_version` decimal(7,1) NOT NULL COMMENT '升级版本号',
  `path_id` varchar(32) DEFAULT NULL COMMENT '关联路径id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `invalid_flag` int DEFAULT '1' COMMENT '作废标识(0:作废 1:有效) 2待发布',
  `platform_type` int DEFAULT NULL COMMENT '1:增值服务 ',
  `label_codes` varchar(500) DEFAULT NULL COMMENT '标签',
  `label_names` varchar(500) DEFAULT NULL COMMENT '标签名称',
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `desc` varchar(500) DEFAULT NULL COMMENT '说明',
  `dept_codes` varchar(255) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(1000) DEFAULT NULL COMMENT '科室名称',
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `editor_name` varchar(255) DEFAULT NULL COMMENT '编辑人名称',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `label_codes_old` varchar(100) DEFAULT NULL,
  `label_names_old` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='新专科随访专病档案病种表';

-- ----------------------------
-- Table structure for t_disease_cloud_back20240321
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_cloud_back20240321`;
CREATE TABLE `t_disease_cloud_back20240321` (
  `id` varchar(32) NOT NULL,
  `data_type` int NOT NULL COMMENT '数据类型(1,基础库 2,医院库)',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `disease_id` varchar(32) NOT NULL COMMENT '历次编辑不变的ID',
  `name` varchar(50) DEFAULT NULL COMMENT '专病名称',
  `disease_version` decimal(7,1) NOT NULL COMMENT '升级版本号',
  `path_id` varchar(32) DEFAULT NULL COMMENT '关联路径id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `invalid_flag` int DEFAULT '1' COMMENT '作废标识(0:作废 1:有效) 2待发布',
  `platform_type` int DEFAULT NULL COMMENT '1:增值服务 ',
  `label_codes` varchar(500) DEFAULT NULL COMMENT '标签',
  `label_names` varchar(500) DEFAULT NULL COMMENT '标签名称',
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '关联疾病代码(逗号分隔，上限10个)',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '关联疾病名称',
  `desc` varchar(500) DEFAULT NULL COMMENT '说明',
  `dept_codes` varchar(255) DEFAULT NULL COMMENT '科室编码',
  `dept_names` varchar(1000) DEFAULT NULL COMMENT '科室名称',
  `hosp_source_code` varchar(100) DEFAULT NULL COMMENT '来源医院',
  `hosp_source_name` varchar(100) DEFAULT NULL COMMENT '来源医院名称',
  `editor_id` varchar(32) DEFAULT NULL COMMENT '编辑人ID',
  `editor_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(64) DEFAULT NULL COMMENT '创建人名称',
  `label_codes_old` varchar(100) DEFAULT NULL,
  `label_names_old` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPACT COMMENT='新专科随访专病档案病种表';

-- ----------------------------
-- Table structure for t_disease_hosp
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_hosp`;
CREATE TABLE `t_disease_hosp` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL,
  `disease_id` varchar(32) NOT NULL COMMENT '专病档案不变id',
  `disease_name` varchar(255) DEFAULT NULL COMMENT '专病档案名称',
  `disease_version` decimal(7,1) NOT NULL COMMENT '版本号',
  `disease_hosp_id` varchar(32) NOT NULL COMMENT '专病档案院端主键id',
  `pack_id` varchar(32) DEFAULT NULL,
  `pack_name` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `system_type` int DEFAULT NULL COMMENT '系统标记 0、随访 1、慢病',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_drug_label
-- ----------------------------
DROP TABLE IF EXISTS `t_drug_label`;
CREATE TABLE `t_drug_label` (
  `id` varchar(64) NOT NULL COMMENT '主键id',
  `drug_id` varchar(64) DEFAULT '' COMMENT '用药id',
  `label_id` varchar(191) DEFAULT '' COMMENT '用药关联标签id',
  `label_name` varchar(255) DEFAULT '' COMMENT '用药关联标签name',
  `label_type` tinyint(1) DEFAULT '1' COMMENT '标签类型：1适宜，2不适宜，3特性，4禁忌药物，5适用疾病，6不适用疾病',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `grade` int DEFAULT NULL COMMENT '层级',
  PRIMARY KEY (`id`),
  KEY `idx_food_id` (`drug_id`) USING BTREE,
  KEY `idx_label_id` (`label_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='用药-标签关联表';

-- ----------------------------
-- Table structure for t_h_hosp_url
-- ----------------------------
DROP TABLE IF EXISTS `t_h_hosp_url`;
CREATE TABLE `t_h_hosp_url` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hosp_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hosp_simple_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '缩写名',
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `platform_code` varchar(5) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `platform_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `intranet_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mobile_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '号码',
  `qr_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '患者永久二维码地址',
  `pat_qr_code` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '患者个人二维码',
  `in_operation` int DEFAULT NULL COMMENT '运营医院标识 1：运营中',
  `price_open_status` int DEFAULT NULL COMMENT '物价开通标识 0：未开通 1：开通 ',
  `pay_open_status` int DEFAULT NULL COMMENT '推荐支付开通标识  0：未开通 1：开通 ',
  `enterprise_wechat` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '企业微信号',
  `dr_qr_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '医生永久二维码地址',
  `pat_sop_qr_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '患者sop二维码',
  `control_center_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '中心名称',
  `in_service_status` int DEFAULT '1' COMMENT '该医院是否正在服务中 服务状态 0：未在服务 1：正常',
  `hosp_code_mapping` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '映射机构代码',
  `enterprise_wechat_identify` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '企业微信id',
  `classify_id_pat` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '患者公众号编码',
  `open_bed_sort` tinyint(1) DEFAULT '0' COMMENT '是否开放床位排序0否1是',
  `excel_flag` tinyint(1) DEFAULT '0' COMMENT '科室维护是否对接飞书 0:否 1:是',
  `sur_flag` tinyint(1) DEFAULT '0' COMMENT '是否对接手术信息 0:否 1:是',
  `hosp_sms_type` tinyint DEFAULT NULL COMMENT '医院短信特殊 1：北肿 2：心归律',
  `hosp_operation_type` tinyint DEFAULT NULL COMMENT '医院运营类型 0：服务医院 1：北肿科研医院 2：心归律医院 9：测试/演示医院 99：其他医院',
  `sys_in_hosp` tinyint(1) DEFAULT '0' COMMENT '出院同步状态 0:关闭 1:开启',
  `discharge_order_flag` tinyint(1) DEFAULT '0' COMMENT '是否对接出院医嘱 0:否 1:是',
  `token_pwd` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '获取token密码',
  `repeat_order_define` tinyint(1) DEFAULT '0' COMMENT '重复开单定义 0标准1严格',
  `charge_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '收费方式 1:HIS收费 2:公众号收费 3:pad收费 4:其他收费登记',
  `inhosp_record_open_state` tinyint(1) DEFAULT '0' COMMENT '手术病程记录 0不开启,1开启',
  `is_permission` tinyint(1) DEFAULT '0' COMMENT '知情同意书 0非必填 1必填',
  `sign_status_flag` tinyint(1) DEFAULT '0' COMMENT '签约状态回写 0不支持1支持',
  `service_end_buffer` int DEFAULT '0' COMMENT '续单授权缓冲时间',
  `mobile_auth_flag` int DEFAULT '0' COMMENT '联系方式验证 0-关闭 1-开启',
  `service_mobile_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '服务总台电话',
  `doctor_flag` tinyint(1) DEFAULT '0' COMMENT '是否支持医生查询 0 否 1 是',
  `informed_consent_form_send` tinyint(1) DEFAULT '0' COMMENT '知情同意书发送 0-不发送 1-出院后 2-宣讲后 3-收案后',
  `door_flag` tinyint(1) DEFAULT '0' COMMENT '是否支持医生上门 0 否 1 是',
  `recommend_pat_export` tinyint(1) DEFAULT '1' COMMENT '是否支持推荐患者导出 0 否 1 是',
  PRIMARY KEY (`id`),
  KEY `syhc` (`hosp_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for t_h_patient_manage_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_patient_manage_record`;
CREATE TABLE `t_h_patient_manage_record` (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '主键',
  `empi_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `type` int DEFAULT NULL COMMENT '类型，1, 随访任务;2, 宣教任务,3, 提醒任务 等等',
  `type_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `manage_model_id` int DEFAULT NULL COMMENT '模板id',
  `manage_model_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '模板name',
  `manage_time` datetime DEFAULT NULL COMMENT '管理时间，可能带时分秒 也可能不带',
  `manage_content` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '管理内容，包括类型',
  `run_type` int DEFAULT NULL COMMENT '运行类型',
  `execute_user` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '执行人 可以是AI,微信等等',
  `execute_status` int DEFAULT NULL COMMENT '执行的状态   1已回复 -1未回复',
  `is_exception` int DEFAULT NULL COMMENT '患者是否有异常情况',
  `update_time` datetime DEFAULT NULL,
  `is_delete` int DEFAULT NULL COMMENT '是否删除标识 0 正常 1删除状态',
  `relation_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '关联id 开单主键、宣讲内容主键、方案制定主键、任务主键',
  `pay_id` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `manage_content_htm` text CHARACTER SET utf8 COLLATE utf8_bin,
  `hosp_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '机构代码',
  `create_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `img_url` varchar(1024) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '图片地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_jzcw
-- ----------------------------
DROP TABLE IF EXISTS `t_jzcw`;
CREATE TABLE `t_jzcw` (
  `id` varchar(255) NOT NULL,
  `resulto` varchar(2000) DEFAULT NULL,
  `resultt` varchar(2000) DEFAULT NULL,
  `resultth` varchar(2000) DEFAULT NULL,
  `create_time` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_path_followup_form
-- ----------------------------
DROP TABLE IF EXISTS `t_path_followup_form`;
CREATE TABLE `t_path_followup_form` (
  `id` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键（顺便直接当表单版本号给云端）',
  `relation_id` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'path_followup_task表主键',
  `cloud_id` char(32) NOT NULL COMMENT '关联表单表主键id',
  `form_id` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '关联表单表form_id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `show_question_id` varchar(3300) DEFAULT NULL COMMENT '表单内容题目ids',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_relation_id_form_id` (`relation_id`,`form_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='表单内容表（每条任务过来都会往该表插一条记录保存表单内容）';

-- ----------------------------
-- Table structure for t_patient_label
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_label`;
CREATE TABLE `t_patient_label` (
  `id` int NOT NULL AUTO_INCREMENT,
  `label_category_code` int DEFAULT NULL,
  `label_category_code_name` varchar(200) DEFAULT NULL,
  `label_code` int DEFAULT NULL,
  `label_code_name` varchar(200) DEFAULT NULL,
  `rule` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_repository_education
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_education`;
CREATE TABLE `t_repository_education` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '机构代码',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人ID',
  `creator_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `category_id` varchar(32) DEFAULT NULL COMMENT '宣教分类ID',
  `cover_img_src` varchar(200) DEFAULT NULL COMMENT '宣教封面图片路径',
  `title` varchar(100) DEFAULT NULL COMMENT '宣教标题',
  `content` mediumtext COMMENT '宣教内容/内容外网URL',
  `ppt_src` varchar(200) DEFAULT NULL COMMENT '宣教PPT路径',
  `share_status` int DEFAULT '0' COMMENT '共享状态(0:不共享 1:本科室共享 2:全院(需引用后可使用) 3全院(全院用户可使用) 4 指定科室共享',
  `invalid_flag` int DEFAULT '1' COMMENT '作废标识(0:作废 1:有效)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `share_dept_code` varchar(2000) DEFAULT NULL COMMENT '分享科室代码(多选 '',''分隔)',
  `share_dept_name` varchar(5000) DEFAULT NULL COMMENT '分享科室名(多选 '',''分隔)',
  `app_version` varchar(32) DEFAULT NULL COMMENT '宣教编辑版本号(For App)',
  `review_status` int DEFAULT '1' COMMENT '审核状态(0:审核中 1:通过  -1:未通过)',
  `review_content` mediumtext COMMENT '审核缓存内容',
  `refuse_reason` varchar(100) DEFAULT NULL COMMENT '审核未通过原因',
  `review_user_id` varchar(32) DEFAULT NULL COMMENT '审核人ID',
  `review_user_name` varchar(50) DEFAULT NULL COMMENT '审核人姓名',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `hosp_course_id` varchar(50) DEFAULT NULL COMMENT '医院课程ID',
  `data_type` int DEFAULT NULL COMMENT '数据类型(1自建 2随访后台 3知识库大脑)',
  `pack_education_id` varchar(32) DEFAULT NULL COMMENT '宣教在场景中的id',
  `pack_education_name` varchar(200) DEFAULT NULL COMMENT '宣教在场景中的名称',
  `self_flag` int DEFAULT '1' COMMENT '自建标识 1自建 2收费',
  `diag_codes` varchar(200) DEFAULT NULL COMMENT '疾病编码(逗号分隔,上限10个)',
  `diag_names` varchar(200) DEFAULT NULL COMMENT '疾病名称',
  `label_codes` varchar(200) DEFAULT NULL COMMENT '标签编码(逗号分隔,上限10个)',
  `label_names` varchar(200) DEFAULT NULL COMMENT '标签名称',
  `education_desc` varchar(500) DEFAULT NULL COMMENT '宣教描述',
  `qr_code_flag` tinyint DEFAULT '0' COMMENT '是否有二维码图片，0，否  1，是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='健康宣教库表';

-- ----------------------------
-- Table structure for t_repository_education-tp
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_education-tp`;
CREATE TABLE `t_repository_education-tp` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '机构代码',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人ID',
  `creator_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `category_id` varchar(32) DEFAULT NULL COMMENT '宣教分类ID',
  `cover_img_src` varchar(200) DEFAULT NULL COMMENT '宣教封面图片路径',
  `title` varchar(100) DEFAULT NULL COMMENT '宣教标题',
  `content` mediumtext COMMENT '宣教内容/内容外网URL',
  `ppt_src` varchar(200) DEFAULT NULL COMMENT '宣教PPT路径',
  `share_status` int DEFAULT '0' COMMENT '共享状态(0:不共享 1:本科室共享 2:全院(需引用后可使用) 3全院(全院用户可使用) 4 指定科室共享',
  `invalid_flag` int DEFAULT '1' COMMENT '作废标识(0:作废 1:有效)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `share_dept` varchar(300) DEFAULT NULL COMMENT '分享科室(多选 '',''分隔)',
  `share_dept_code` varchar(2000) DEFAULT NULL COMMENT '分享科室代码(多选 '',''分隔)',
  `share_dept_name` varchar(5000) DEFAULT NULL COMMENT '分享科室名(多选 '',''分隔)',
  `app_version` varchar(32) DEFAULT NULL COMMENT '宣教编辑版本号(For App)',
  `review_status` int DEFAULT '1' COMMENT '审核状态(0:审核中 1:通过  -1:未通过)',
  `review_content` mediumtext COMMENT '审核缓存内容',
  `refuse_reason` varchar(100) DEFAULT NULL COMMENT '审核未通过原因',
  `review_user_id` varchar(32) DEFAULT NULL COMMENT '审核人ID',
  `review_user_name` varchar(50) DEFAULT NULL COMMENT '审核人姓名',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `hosp_course_id` varchar(50) DEFAULT NULL COMMENT '医院课程ID',
  `data_type` int DEFAULT NULL COMMENT '数据类型(1自建 2随访后台 3知识库大脑)',
  `pack_education_id` varchar(32) DEFAULT NULL COMMENT '宣教在场景中的id',
  `pack_education_name` varchar(200) DEFAULT NULL COMMENT '宣教在场景中的名称',
  `self_flag` int DEFAULT '1' COMMENT '自建标识 1自建 2收费',
  `diag_codes` varchar(200) DEFAULT NULL COMMENT '疾病编码(逗号分隔,上限10个)',
  `diag_names` varchar(200) DEFAULT NULL COMMENT '疾病名称',
  `label_codes` varchar(200) DEFAULT NULL COMMENT '标签编码(逗号分隔,上限10个)',
  `label_names` varchar(200) DEFAULT NULL COMMENT '标签名称',
  `education_desc` varchar(500) DEFAULT NULL COMMENT '宣教描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='健康宣教库表';

-- ----------------------------
-- Table structure for t_repository_form
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form`;
CREATE TABLE `t_repository_form` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `form_id` varchar(32) DEFAULT NULL COMMENT '表单各版本的唯一ID',
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '机构代码',
  `user_id` varchar(32) DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(50) DEFAULT NULL COMMENT '用户姓名',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `form_title` varchar(100) DEFAULT NULL COMMENT '表单名称',
  `begin_content` varchar(500) DEFAULT NULL COMMENT '表单开始语',
  `end_content` varchar(500) DEFAULT NULL COMMENT '表单结束语',
  `category_id` varchar(32) DEFAULT NULL COMMENT '表单所属分类ID',
  `init_category_id` varchar(32) DEFAULT NULL COMMENT '表单原分类ID(初始化分类,不可变)',
  `form_type` int DEFAULT NULL COMMENT '表单功能类型(0:普通表单 1:分值表单)',
  `form_source` int DEFAULT '1' COMMENT '表单来源(1:院内 2:随访后台 3:知识库大脑)',
  `share_status` int DEFAULT '0' COMMENT '共享状态(0:不共享 1:本科室共享 2:全院共享)',
  `form_version` decimal(8,1) DEFAULT '1.0' COMMENT '表单版本号(1.0开始,每次加0.1)',
  `form_status` int DEFAULT '0' COMMENT '表单启停状态(0:停用 1:启用)',
  `user_defined_func` varchar(100) DEFAULT NULL COMMENT '分值表单用户自定义函数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `app_version` varchar(32) DEFAULT NULL COMMENT '表单编辑版本号(For App)',
  `jump_type` int DEFAULT '1' COMMENT '表单属性区分(1,跳题属性 2,子题属性)',
  `association_logic` varchar(5000) DEFAULT NULL COMMENT '逻辑关联',
  `question_margin` varchar(10) DEFAULT NULL COMMENT '题目行间距',
  `data_type` int DEFAULT NULL COMMENT '数据类型(1, 基础库  2,医院库)仅form_source为3的时候才区分',
  `cloud_id` varchar(32) DEFAULT NULL COMMENT '表单在知识库大脑中的主键id',
  `cloud_form_id` varchar(32) DEFAULT NULL COMMENT '表单在知识库大脑中的form_id',
  `cloud_pack_id` varchar(32) DEFAULT NULL COMMENT '云端场景ID',
  `cloud_pack_name` varchar(50) DEFAULT NULL COMMENT '云端场景名称',
  `form_desc` varchar(500) DEFAULT NULL COMMENT '表单说明',
  `update_desc` varchar(500) DEFAULT NULL COMMENT '版本说明',
  `label_codes` varchar(150) DEFAULT NULL COMMENT '标签代码',
  `label_names` varchar(500) DEFAULT NULL COMMENT '标签名称',
  `diag_codes` varchar(150) DEFAULT NULL COMMENT '疾病代码',
  `diag_names` varchar(500) DEFAULT NULL COMMENT '疾病名称',
  `remark` varchar(32) DEFAULT NULL COMMENT '迁移数据说明',
  `share_dept_codes` varchar(1000) DEFAULT NULL COMMENT '科研共享科室编码',
  `share_dept_names` varchar(1000) DEFAULT NULL COMMENT '科研共享科室名称',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `test_rules` varchar(2000) DEFAULT NULL COMMENT '自定义表单验证json串',
  `except_warning_flag` tinyint(1) DEFAULT NULL COMMENT '异常提醒flag 1:是  2:否',
  `pat_source_type` int DEFAULT NULL COMMENT '病人来源',
  `pat_source_type_name` varchar(20) DEFAULT NULL COMMENT '病人来源名称',
  `repository_share_dept_codes` varchar(1000) DEFAULT NULL COMMENT '知识库共享科室编码',
  `repository_share_dept_names` varchar(1000) DEFAULT NULL COMMENT '知识库共享科室名称',
  `mobile_judg_flag` int DEFAULT '0' COMMENT '手机端总结展示标识 0不展示 1展示',
  `show_source_json` varchar(100) DEFAULT NULL COMMENT '展示表单分值头内容',
  `qr_code_flag` tinyint DEFAULT '0' COMMENT '是否有二维码图片，0，否  1，是',
  `preview_url` varchar(200) DEFAULT NULL COMMENT '表单手机端预览URL',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `idx_form_id` (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='随访表单库(主表)';

-- ----------------------------
-- Table structure for t_repository_form_layout
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form_layout`;
CREATE TABLE `t_repository_form_layout` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `form_id` varchar(32) DEFAULT NULL COMMENT '关联表单ID(表t_repository_form的主键)',
  `layout_prop` int DEFAULT NULL COMMENT '布局属性(1:单题布局 2:父布局 3:子布局) ',
  `sort_index` int DEFAULT NULL COMMENT '布局排序号(组装表单时布局根据此序号排列)',
  `parent_layout_id` varchar(32) DEFAULT NULL COMMENT '父布局ID(子布局属性有值)',
  `layout_index` varchar(10) DEFAULT NULL COMMENT 'index存储',
  `layout_order` varchar(10) DEFAULT NULL COMMENT 'order存储',
  `component_key` varchar(50) DEFAULT NULL COMMENT '布局控件key(表格:TableLayout,TdLayout 行列:ColumnPanel)',
  `size` varchar(10) DEFAULT NULL COMMENT '布局控件size(1:最外层;2:一行两列;3:一行三列)',
  `table_th_array` varchar(200) DEFAULT NULL COMMENT '表格每列宽度',
  `table_cols` varchar(10) DEFAULT NULL COMMENT '表格总列数',
  `table_rows` varchar(10) DEFAULT NULL COMMENT '表格总行数',
  `td_height` varchar(10) DEFAULT NULL COMMENT 'TD高度',
  `td_width` varchar(10) DEFAULT NULL COMMENT 'TD宽度',
  `col_span` varchar(10) DEFAULT NULL COMMENT 'TD列合并数',
  `row_span` varchar(10) DEFAULT NULL COMMENT 'TD行合并数',
  `coordinate` varchar(10) DEFAULT NULL COMMENT 'TD坐标',
  `window_width` varchar(10) DEFAULT NULL COMMENT '保存表单时，屏幕的宽度',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `idx_form_id` (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='布局控件布局描述';

-- ----------------------------
-- Table structure for t_repository_form_option
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form_option`;
CREATE TABLE `t_repository_form_option` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `question_id` varchar(32) DEFAULT NULL COMMENT '关联题目ID',
  `sort_index` int DEFAULT NULL COMMENT '选项排序号',
  `option_other` varchar(10) DEFAULT NULL COMMENT '选择题是否有其他项(false否; true是)',
  `option_index` varchar(10) DEFAULT NULL COMMENT 'index存储',
  `option_order` varchar(10) DEFAULT NULL COMMENT 'order存储',
  `option_name` varchar(1000) DEFAULT NULL COMMENT '选项名',
  `component_key` varchar(50) DEFAULT NULL COMMENT '选项控件key(option:选项)',
  `except` varchar(10) DEFAULT NULL COMMENT '是否异常选项(false,否;true,是)',
  `except_tip` varchar(1000) DEFAULT NULL COMMENT '异常提示说明',
  `obj_id` varchar(40) DEFAULT NULL COMMENT '图片ID(云端的有些图片ID带了后缀，扩大一点长度)',
  `file_path` varchar(500) DEFAULT NULL COMMENT '图片路径',
  `score` double(6,3) DEFAULT '0.000' COMMENT '评分单选框有分值',
  `quote_option_id` varchar(32) DEFAULT NULL COMMENT '引用选项ID(题库选项表主键ID)',
  `satisfaction_level` int DEFAULT NULL COMMENT '满意度级别(字典下拉表获取, 5:满意 4:较满意 3:一般 2:不满意 1:很不满意)',
  `send_education_ids` varchar(330) DEFAULT NULL COMMENT '选项需要推送宣教ID(逗号隔开，上限10个)',
  `required` varchar(10) DEFAULT NULL COMMENT '选项附加文本输入框必填(true 是, false 否)',
  `self_id` varchar(32) DEFAULT NULL COMMENT '逻辑跳题-选项标志ID',
  `jump_id` varchar(330) DEFAULT NULL COMMENT '逻辑跳题-选项所跳题目标志ID||选项子题 多个的话逗号隔开',
  `supply_tip` varchar(1000) DEFAULT NULL COMMENT '选项补充说明',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `idx_question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表单控件内部选项';

-- ----------------------------
-- Table structure for t_repository_form_question
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form_question`;
CREATE TABLE `t_repository_form_question` (
  `id` varchar(32) NOT NULL COMMENT '主键(fieldId)',
  `form_id` varchar(32) DEFAULT NULL COMMENT '关联表单ID(表t_repository_form的主键)',
  `layout_id` varchar(32) DEFAULT NULL COMMENT '关联布局ID(布局属性1和3的主键ID)',
  `question_type` int DEFAULT NULL COMMENT '题目类型(1:文本描述题(含单行/多行) 2:单选题 3:多选题 4:矩阵题(主题目) 5:矩阵题(副题目) 6:分值单选题 7:填空题(主题目) 8:填空题(副题目) 9:图文选择题 10:下拉题 11:日期 12:手机 13:图片)',
  `sort_index` int DEFAULT NULL COMMENT '题目排序号',
  `parent_question_id` varchar(32) DEFAULT NULL COMMENT '父题目ID(矩阵题/填空题副题目时此属性有效)',
  `question_title` varchar(200) DEFAULT NULL COMMENT '题目标题',
  `component_key` varchar(50) DEFAULT NULL COMMENT '字段控件类型(Text,TextArea,RadioBox,CheckBox....)',
  `question_index` varchar(10) DEFAULT NULL COMMENT 'index存储',
  `question_order` varchar(10) DEFAULT NULL COMMENT 'order存储',
  `title_layout` varchar(20) DEFAULT NULL COMMENT '控件标题布局(,横;,列)',
  `required` varchar(10) DEFAULT NULL COMMENT '是否必填(false,否;true,是)',
  `component_size` varchar(10) DEFAULT NULL COMMENT '控件尺寸',
  `hide_question` int DEFAULT '0' COMMENT '隐藏题目(1:是,0:否)',
  `no_statistical` int DEFAULT '0' COMMENT '不纳入统计(1:是,0:否)',
  `hide_title` varchar(10) DEFAULT NULL COMMENT '控件标题是否显示(false,否;true,显示)',
  `hide_border` varchar(10) DEFAULT NULL COMMENT '控件边框是否显示(false,否;true,显示)',
  `text_default` varchar(10) DEFAULT NULL COMMENT '文本输入框是否设置默认值(false,否;true,是)',
  `text_content` varchar(1000) DEFAULT NULL COMMENT '文本输入框默认值',
  `read_only` varchar(10) DEFAULT NULL COMMENT '是否只读(false,读写;true,只读)',
  `select_layout` varchar(50) DEFAULT NULL COMMENT '选项布局(,横向排列;,纵向排列)',
  `single` varchar(10) DEFAULT NULL COMMENT '是否单图片上传',
  `date_format` varchar(30) DEFAULT NULL COMMENT '日期控件时间类型(yyyy-MM-dd HH:mm:年月日时分;yyyy-MM-dd:;年月日; yyyy-MM年月)',
  `system_date` varchar(10) DEFAULT NULL COMMENT '是否使用系统时间(false,否;true,是;)',
  `quote_question_id` varchar(32) DEFAULT NULL COMMENT '引用题目ID(题库单题表主键ID)',
  `satisfaction_type` int DEFAULT NULL COMMENT '满意度调查类型(字典下拉表获取, 1:医德医风 2:护理 3:客服 4:后勤)',
  `text_align` varchar(50) DEFAULT NULL COMMENT '文字位置',
  `alias` varchar(100) DEFAULT NULL COMMENT '题目标题别名(通俗易懂的标题名供患者看)',
  `hide_for_mobile` varchar(10) DEFAULT NULL COMMENT '移动端隐藏标识(true:隐藏 false:显示) 页面叫不发送手机端',
  `weight` decimal(6,2) DEFAULT NULL COMMENT '权重指标',
  `weight_two` decimal(6,2) DEFAULT NULL COMMENT '权重指标2',
  `self_id` varchar(32) DEFAULT NULL COMMENT '逻辑跳题-题目标志ID',
  `label_width` varchar(10) DEFAULT NULL COMMENT '标题宽度',
  `jump_prop` int DEFAULT NULL COMMENT '题目属性(2,子题属性)',
  `reply_for_once` varchar(10) DEFAULT NULL COMMENT '限制手动修改(true:是 false:否)',
  `multiple_choice` varchar(10) DEFAULT NULL COMMENT '下拉框多选标志 false:单选 true:多选',
  `dic_type_id` varchar(32) DEFAULT NULL COMMENT '题目表单下拉框引用，对应关联字典表大项主键id  (字典表下拉框引用必填)',
  `dic_type_name` varchar(100) DEFAULT NULL COMMENT '对应关联字典表大项名称',
  `parent_dic_field_id` varchar(32) DEFAULT NULL COMMENT '同表单下 搜索下拉框外部关联题目id',
  `only_one_choice` varchar(10) DEFAULT NULL COMMENT '是否为单选组件 前端引用  true  false',
  `expression_list` varchar(500) DEFAULT NULL COMMENT '运算控件表达式',
  `decimal_digits` varchar(20) DEFAULT NULL COMMENT '保留小数位',
  `title_color` varchar(10) DEFAULT NULL COMMENT '表单题目标题颜色',
  `default_chosen` varchar(100) DEFAULT NULL COMMENT '单题默认值',
  `expression_type` varchar(50) DEFAULT NULL COMMENT '表达式关联题型',
  `date_type` varchar(10) DEFAULT NULL COMMENT '日期计算 答案格式',
  `fill_type` int DEFAULT '1' COMMENT '自动填充类型 1.基本数据类型 2.CDR数据来源',
  `option_mutex` varchar(500) DEFAULT NULL COMMENT '选项互斥',
  `error_notice` varchar(500) DEFAULT NULL COMMENT '异常提醒',
  `no_repetition_tips` varchar(500) DEFAULT NULL COMMENT '防止重复提醒字段',
  `value_size` varchar(50) DEFAULT NULL COMMENT '表单输入框校验间距',
  `value_rules` varchar(1000) DEFAULT NULL COMMENT '表单输入框规则',
  `show_num_flag` int DEFAULT NULL COMMENT '是否显示题目序号标记  1显示 0不显示 ',
  `hidden_submit_flag` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '隐藏题目答案是否提交(1:是,0:否)',
  `max_chosen` int DEFAULT NULL COMMENT '选择题目上限',
  `describe_for_question` varchar(500) DEFAULT NULL COMMENT '题目说明',
  `become_title` varchar(1) DEFAULT NULL COMMENT '是否为大标题(0:不是大标题 1:是大标题)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `idx_form_id` (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='字段控件表(相当于题目)';

-- ----------------------------
-- Table structure for t_repository_form_select_detail_dic
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form_select_detail_dic`;
CREATE TABLE `t_repository_form_select_detail_dic` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dic_type_id` varchar(32) DEFAULT NULL COMMENT '对应表单字典表大项类型主键',
  `select_code` varchar(100) DEFAULT NULL COMMENT '下拉框编码(值)',
  `select_name` varchar(200) DEFAULT NULL COMMENT '下拉框名称 （域）',
  `relation_select_code` varchar(100) DEFAULT NULL COMMENT '关联查询编码',
  `creat_time` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77159 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_repository_form_select_dic
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_form_select_dic`;
CREATE TABLE `t_repository_form_select_dic` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '主键id',
  `dic_type_name` varchar(100) DEFAULT NULL COMMENT '下拉框数据总类型名称',
  `parent_dic_id` varchar(32) DEFAULT NULL COMMENT '关联上级id',
  `allow_delete` varchar(2) DEFAULT NULL COMMENT '是否允许否删除标记  1是 0否',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院机构代码',
  `user_id` varchar(32) DEFAULT NULL COMMENT '段创建用户id',
  `search_type` varchar(2) DEFAULT NULL COMMENT '子级查询条件 1 准确查询  2 模糊查寻(父级默认准确查询)',
  `back_relation_status` varchar(2) DEFAULT NULL COMMENT '是否返回关联编码类型  1是 0不是',
  `creat_time` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建医生',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for t_sdt_disease_manage_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_sdt_disease_manage_patient`;
CREATE TABLE `t_sdt_disease_manage_patient` (
  `id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键',
  `disease_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '疾病表主键id',
  `empi_id` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者主索引',
  `pat_index_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者索引号',
  `pat_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者姓名',
  `id_card` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证',
  `mobile_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号',
  `sex_code` tinyint DEFAULT NULL COMMENT '性别代码 1男2女',
  `sex_name` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '性别名称',
  `age` tinyint DEFAULT NULL COMMENT '年龄（岁）',
  `diag_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断代码',
  `diag_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '诊断名称',
  `pat_source_type` tinyint DEFAULT NULL COMMENT '患者来源',
  `serial_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '业务流水号',
  `business_date` datetime NOT NULL COMMENT '业务日期（门诊日期、出院日期、体检日期）',
  `dept_code` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `doc_code` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生工号',
  `doc_name` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '医生姓名',
  `filter_keyword` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '筛选关键词',
  `filter_detail` json DEFAULT NULL,
  `history_diag_name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '历史诊断',
  `is_inclusion` tinyint NOT NULL DEFAULT '0' COMMENT '是否纳入管理 -1剔除 0待处理 1纳入',
  `inclusion_exclusion_time` datetime DEFAULT NULL COMMENT '纳入/排除时间',
  `exclusion_reason` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '剔除原因',
  `exclusion_type` tinyint DEFAULT NULL COMMENT '剔除范围：1仅剔除本次 2永久剔除 3时间范围内剔除',
  `exclusion_deadline` int DEFAULT NULL COMMENT '剔除时间范围',
  `inclusion_exclusion_user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '纳入管理 用户ID',
  `inclusion_exclusion_user_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '纳入管理 用户姓名',
  `is_finish_visit` tinyint NOT NULL DEFAULT '0' COMMENT '是否完成就诊 0否 1是',
  `finish_visit_date` datetime DEFAULT NULL COMMENT '完成就诊日期',
  `finish_visit_serial_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊 流水号',
  `finish_visit_doc_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊 医生工号',
  `finish_visit_doc_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊 医生姓名',
  `is_finish_surgery` tinyint NOT NULL DEFAULT '0' COMMENT '是否完成手术 0否 1是',
  `finish_surgery_date` datetime DEFAULT NULL COMMENT '完成手术日期',
  `finish_surgery_serial_no` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成手术 流水号',
  `finish_surgery_doc_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成手术 医生工号',
  `finish_surgery_doc_name` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成手术 医生姓名',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除 0否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `finish_surgery_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成手术名称',
  `finish_visit_dept_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊科室编码',
  `finish_visit_dept_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊科室名称',
  `visit_card_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '就诊卡号',
  `out_hosp_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊号',
  `out_hosp_serial_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '门诊流水号',
  `in_hosp_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院号',
  `in_hosp_num` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院次数',
  `in_hosp_serial_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '住院流水号',
  `hosp_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机构代码',
  `close_case_type` int DEFAULT '0' COMMENT '结案类型 1、正常结案 2、中途退出',
  `close_case_reason` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '结案原因',
  `close_editor_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '结案人',
  `synch_flag` int DEFAULT NULL COMMENT '1、同步成功 2、同步失败',
  `cull_flag` int DEFAULT '0' COMMENT '0、正常 1、精筛后剔除数据',
  `cull_reason` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '精筛剔除原因',
  `is_finish_inhosp` int DEFAULT '0' COMMENT '是否完成住院 0否 1是',
  `finish_inhosp_date` datetime DEFAULT NULL COMMENT '完成就诊住院日期',
  `finish_inhosp_serial_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊住院 流水号',
  `finish_inhosp_doc_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊住院 医生工号',
  `finish_inhosp_doc_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊住院 医生姓名',
  `finish_inhosp_dept_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊科室编码',
  `finish_inhosp_dept_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '完成就诊科室名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE,
  KEY `idx_serial_no` (`serial_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC COMMENT='规范化诊疗--疾病管理--患者表';

-- ----------------------------
-- Table structure for t_tips_library
-- ----------------------------
DROP TABLE IF EXISTS `t_tips_library`;
CREATE TABLE `t_tips_library` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `tip_title` varchar(30) DEFAULT NULL COMMENT '标题',
  `tip_content` varchar(500) DEFAULT NULL COMMENT '内容',
  `diag_codes` varchar(1500) DEFAULT NULL COMMENT '适用疾病代码',
  `diag_names` varchar(2000) DEFAULT NULL COMMENT '适用疾病名称',
  `diag_level` varchar(1000) DEFAULT NULL COMMENT '适用疾病层级',
  `dept_codes` varchar(1000) DEFAULT NULL COMMENT '适用科室code',
  `dept_names` varchar(1500) DEFAULT NULL COMMENT '适用科室name',
  `content_label_code` varchar(800) DEFAULT NULL COMMENT '内容标签code',
  `content_label_name` varchar(800) DEFAULT NULL COMMENT '内容标签name',
  `operate_id` varchar(32) DEFAULT NULL COMMENT '操作人id',
  `operate_name` varchar(225) DEFAULT NULL COMMENT '操作人name',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间',
  `tip_cover` varchar(100) DEFAULT NULL COMMENT '封面',
  `is_publish` tinyint(1) DEFAULT '0' COMMENT '是否发布 0.未发布 1.已发布',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `label_codes_old` varchar(400) DEFAULT NULL,
  `label_names_old` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='健康小贴士';

-- ----------------------------
-- Table structure for t_tips_library_back20240321
-- ----------------------------
DROP TABLE IF EXISTS `t_tips_library_back20240321`;
CREATE TABLE `t_tips_library_back20240321` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `tip_title` varchar(30) DEFAULT NULL COMMENT '标题',
  `tip_content` varchar(500) DEFAULT NULL COMMENT '内容',
  `diag_codes` varchar(1500) DEFAULT NULL COMMENT '适用疾病代码',
  `diag_names` varchar(2000) DEFAULT NULL COMMENT '适用疾病名称',
  `diag_level` varchar(1000) DEFAULT NULL COMMENT '适用疾病层级',
  `dept_codes` varchar(1000) DEFAULT NULL COMMENT '适用科室code',
  `dept_names` varchar(1500) DEFAULT NULL COMMENT '适用科室name',
  `content_label_code` varchar(800) DEFAULT NULL COMMENT '内容标签code',
  `content_label_name` varchar(800) DEFAULT NULL COMMENT '内容标签name',
  `operate_id` varchar(32) DEFAULT NULL COMMENT '操作人id',
  `operate_name` varchar(225) DEFAULT NULL COMMENT '操作人name',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间',
  `tip_cover` varchar(100) DEFAULT NULL COMMENT '封面',
  `is_publish` tinyint(1) DEFAULT '0' COMMENT '是否发布 0.未发布 1.已发布',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `label_codes_old` varchar(400) DEFAULT NULL,
  `label_names_old` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='健康小贴士';

-- ----------------------------
-- Table structure for test_report
-- ----------------------------
DROP TABLE IF EXISTS `test_report`;
CREATE TABLE `test_report` (
  `report_no` varchar(50) NOT NULL,
  `organ_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pat_index_no` varchar(50) DEFAULT NULL COMMENT '患者索引号',
  `outhosp_no` varchar(50) DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '门诊流水号',
  `inhosp_no` varchar(50) DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(50) DEFAULT NULL COMMENT '住院流水号',
  `requisition_no` varchar(50) DEFAULT NULL,
  `requisition_no_item` varchar(50) DEFAULT NULL COMMENT '申请单分项目序号',
  `barcode_no` varchar(50) DEFAULT NULL COMMENT '条码号',
  `report_name` varchar(50) DEFAULT NULL COMMENT '报告名称',
  `sample_type_code` varchar(50) DEFAULT NULL COMMENT '样本类型代码',
  `sample_type_name` varchar(50) DEFAULT NULL COMMENT '样本类型名称',
  `test_item_code` varchar(50) DEFAULT NULL COMMENT '检验大类代码',
  `test_item_name` varchar(50) DEFAULT NULL COMMENT '检验大类名称',
  `microbe_test_flag` varchar(50) DEFAULT NULL COMMENT '微生物检验标志',
  `equipment_code` varchar(50) DEFAULT NULL COMMENT '设备代码',
  `equipment_name` varchar(50) DEFAULT NULL COMMENT '设备名称',
  `apply_date` datetime DEFAULT NULL COMMENT '申请日期',
  `apply_dept_code` varchar(50) DEFAULT NULL COMMENT '申请科室代码',
  `apply_dept_name` varchar(50) DEFAULT NULL COMMENT '申请科室名称',
  `apply_dr_code` varchar(50) DEFAULT NULL COMMENT '申请医生工号',
  `apply_dr_name` varchar(50) DEFAULT NULL COMMENT '申请医生姓名',
  `execute_date` datetime DEFAULT NULL COMMENT '执行日期',
  `report_date` datetime DEFAULT NULL COMMENT '报告日期',
  `note` varchar(500) DEFAULT NULL COMMENT '备注',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `sync_result_flag` varchar(10) DEFAULT '0' COMMENT '检验结果同步标识，0：未同步，1：已同步',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`report_no`) USING BTREE,
  UNIQUE KEY `report_no_organ_code` (`report_no`,`organ_code`) USING BTREE,
  KEY `IDX_BARCODE_NO` (`barcode_no`) USING BTREE,
  KEY `TTT` (`empi_id`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='检验报告';

-- ----------------------------
-- Table structure for test_result
-- ----------------------------
DROP TABLE IF EXISTS `test_result`;
CREATE TABLE `test_result` (
  `test_result_no` varchar(50) NOT NULL,
  `organ_code` varchar(50) DEFAULT NULL,
  `report_no` varchar(50) DEFAULT NULL COMMENT '报告单编号',
  `test_item_code` varchar(50) DEFAULT NULL COMMENT '检验项目代码',
  `test_item_name` varchar(50) DEFAULT NULL COMMENT '检验项目名称',
  `test_result_value` varchar(50) DEFAULT NULL COMMENT '检验结果值',
  `test_result_value_unit` varchar(50) DEFAULT NULL COMMENT '检验结果值单位',
  `reference_ranges` varchar(100) DEFAULT NULL COMMENT '参考范围',
  `reference_upper_limit` varchar(100) DEFAULT NULL COMMENT '参考上限',
  `reference_lower_limit` varchar(100) DEFAULT NULL COMMENT '参考下限',
  `normal_flag` varchar(50) DEFAULT NULL COMMENT '正常标志',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`test_result_no`) USING BTREE,
  UNIQUE KEY `test_result_no_organ_code` (`test_result_no`,`organ_code`) USING BTREE,
  KEY `IDX_REPORT_NO` (`report_no`) USING BTREE,
  KEY `idx_empi_id` (`empi_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='检验结果';

-- ----------------------------
-- Table structure for therapy_library
-- ----------------------------
DROP TABLE IF EXISTS `therapy_library`;
CREATE TABLE `therapy_library` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `therapy_name` varchar(50) DEFAULT NULL COMMENT '治疗名称',
  `therapy_type_code` varchar(50) DEFAULT NULL COMMENT '治疗类型编码',
  `diag_code` varchar(50) DEFAULT NULL COMMENT '疾病编码',
  `diag_name` varchar(50) DEFAULT NULL COMMENT '疾病名称',
  `create_time` timestamp DEFAULT NULL COMMENT '创建时间',
  `therapy_type_name` varchar(50) DEFAULT NULL COMMENT '治疗类型名称',
  `therapy_stage_code` varchar(50) DEFAULT NULL COMMENT '（当前）治疗阶段编码',
  `therapy_stage_name` varchar(50) DEFAULT NULL COMMENT '（当前）治疗阶段名称',
  `stage_time` int DEFAULT NULL COMMENT '阶段期限',
  `stage_time_unit` varchar(20) DEFAULT NULL COMMENT '阶段期限单位',
  `is_parent` varchar(1) DEFAULT NULL COMMENT '是否有子类型 1:有子类，文件夹 2：无子类 文件',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '父节点id',
  `diag_flag` int DEFAULT NULL COMMENT '疾病类型表示 ：1：疾病类型，只有疾病。0：表示非疾病类型，有触发条件。',
  `sort_num` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for therapy_stage_condition
-- ----------------------------
DROP TABLE IF EXISTS `therapy_stage_condition`;
CREATE TABLE `therapy_stage_condition` (
  `id` varchar(50) NOT NULL COMMENT '主键',
  `therapy_stage_code` varchar(50) DEFAULT NULL COMMENT '治疗阶段编码',
  `therapy_stage_name` varchar(50) DEFAULT NULL COMMENT '治疗阶段名称',
  `clinic_data_code` varchar(20) DEFAULT NULL COMMENT '诊疗数据编码',
  `clinic_data_name` varchar(20) DEFAULT NULL COMMENT '诊疗数据名称',
  `last_stage_code` varchar(50) DEFAULT NULL COMMENT '上次阶段编码',
  `last_stage_name` varchar(50) DEFAULT NULL COMMENT '上次阶段名称',
  `last_drug_codes` text COMMENT '上次药品编码',
  `last_drug_names` text COMMENT '上次药品名称',
  `drug_codes` varchar(2000) DEFAULT NULL COMMENT '包含药品',
  `drug_names` text COMMENT '药品名称',
  `not_contains_drug_codes` varchar(255) DEFAULT NULL COMMENT '不包含药品编码',
  `not_contains_drug_names` varchar(500) DEFAULT NULL COMMENT '不包含药品名称',
  `include_diagnosis` text COMMENT '包含诊断',
  `diagnosis_include_text` varchar(1000) DEFAULT NULL COMMENT '诊断包含文字',
  `not_contains_diagnosis_codes` varchar(255) DEFAULT NULL COMMENT '不包含诊断编码',
  `not_contains_diagnosis_names` varchar(500) DEFAULT NULL COMMENT '不包含诊断名称',
  `diagnosis_not_include_text` varchar(1000) DEFAULT NULL COMMENT '诊断不包含文字',
  `surgery_codes` varchar(2000) DEFAULT NULL COMMENT '包含手术',
  `surgery_names` varchar(1000) DEFAULT NULL COMMENT '包含手术名称',
  `discharge_time_days` int DEFAULT NULL COMMENT '出院天数',
  `discharge_time_symbol` varchar(10) DEFAULT NULL COMMENT '出院天数比较符号',
  `dept_codes` varchar(500) DEFAULT NULL COMMENT '科室编码（逗号隔开）',
  `dept_names` varchar(500) DEFAULT NULL COMMENT '科室名称（逗号隔开）',
  `surgery_include_text` varchar(1000) DEFAULT NULL COMMENT '手术包含文字',
  `surgery_not_include_text` varchar(1000) DEFAULT NULL COMMENT '手术不包含文字',
  `check_code` varchar(50) DEFAULT NULL COMMENT '检查编码',
  `check_name` varchar(255) DEFAULT NULL COMMENT '检查名称',
  `check_include_text` varchar(1000) DEFAULT NULL COMMENT '检查包含文字(逗号隔开)',
  `check_not_include_text` varchar(1000) DEFAULT NULL COMMENT '检查不包含文字(逗号隔开)',
  `gestation_week_low` int DEFAULT NULL COMMENT '孕周下限值',
  `gestation_week_high` int DEFAULT NULL COMMENT '孕周上限值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for therapy_stage_condition_drug
-- ----------------------------
DROP TABLE IF EXISTS `therapy_stage_condition_drug`;
CREATE TABLE `therapy_stage_condition_drug` (
  `id` varchar(35) NOT NULL,
  `therapy_stage_code` varchar(50) NOT NULL COMMENT '治疗阶段编码',
  `therapy_stage_condition_id` varchar(35) NOT NULL COMMENT '治疗阶段触发条件主键',
  `drug_code` varchar(50) NOT NULL COMMENT '药品编码（一个）',
  `drug_name` varchar(50) DEFAULT NULL COMMENT '药品名称',
  `symbol` varchar(10) DEFAULT NULL COMMENT '比较符号',
  `drug_quantity` double DEFAULT NULL COMMENT '药品剂量值',
  `drug_quantity_unit` varchar(10) DEFAULT NULL COMMENT '药品剂量单位',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for visit_info
-- ----------------------------
DROP TABLE IF EXISTS `visit_info`;
CREATE TABLE `visit_info` (
  `outhosp_serial_no` varchar(50) NOT NULL,
  `organ_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pat_index_no` varchar(50) DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(50) DEFAULT NULL COMMENT '就诊卡号',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) DEFAULT NULL COMMENT '身份证号码',
  `sex_code` varchar(20) DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(50) DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(30) DEFAULT NULL COMMENT '手机号码',
  `company` varchar(100) DEFAULT NULL COMMENT '工作单位',
  `outhosp_no` varchar(50) DEFAULT NULL COMMENT '门诊号',
  `pat_type_code` varchar(50) DEFAULT NULL COMMENT '患者类型代码',
  `pat_type_name` varchar(50) DEFAULT NULL COMMENT '患者类型名称',
  `regist_no` varchar(50) DEFAULT NULL COMMENT '挂号流水号',
  `regist_date` datetime DEFAULT NULL COMMENT '挂号日期时间',
  `visit_date` datetime DEFAULT NULL COMMENT '就诊日期时间',
  `visit_start_date` datetime DEFAULT NULL COMMENT '就诊开始时间',
  `visit_end_date` datetime DEFAULT NULL COMMENT '就诊结束时间',
  `chief_descr` varchar(500) DEFAULT NULL COMMENT '主诉',
  `curr_disease_history` varchar(500) DEFAULT NULL COMMENT '现病史',
  `past_disease_history` varchar(500) DEFAULT NULL COMMENT '既往史',
  `recept_treat_dr_code` varchar(50) DEFAULT NULL COMMENT '接诊医生工号',
  `recept_treat_dr_name` varchar(50) DEFAULT NULL COMMENT '接诊医生姓名',
  `visit_dept_code` varchar(50) DEFAULT NULL COMMENT '就诊科室代码',
  `visit_dept_name` varchar(50) DEFAULT NULL COMMENT '就诊科室名称',
  `diag_code` varchar(100) DEFAULT NULL,
  `diag_name` varchar(100) DEFAULT NULL,
  `allergy_history` varchar(500) DEFAULT NULL,
  `physical_exam` varchar(500) DEFAULT NULL COMMENT '体格检查',
  `treatment_advice` varchar(1000) DEFAULT NULL COMMENT '处理意见',
  `diseases_reported_flag` varchar(50) DEFAULT NULL COMMENT '疾病报卡标志',
  `brief_disease_situation` varchar(500) DEFAULT NULL COMMENT '简要病情',
  `contact_phone_no` varchar(20) DEFAULT NULL COMMENT '联系人电话',
  `repeat_flag` varchar(10) DEFAULT NULL COMMENT '已收案标志  1:是 0:否',
  `age` varchar(10) DEFAULT NULL COMMENT '年龄',
  `sync_diag_flag` varchar(10) DEFAULT '0' COMMENT '诊断同步标识，0：未同步，1：已同步',
  `sync_order_flag` varchar(10) DEFAULT '0' COMMENT '处方同步标识，0：未同步，1：已同步',
  `sync_fee_flag` varchar(10) DEFAULT '0' COMMENT '费用同步标识，0：未同步，1：已同步',
  `sync_patientinfo_flag` varchar(10) DEFAULT '0' COMMENT '患者信息同步标识，0：未同步，1：已同步',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '主索引号',
  `empi_id_flag` varchar(10) DEFAULT '0' COMMENT '主索引号同步标识，0：未同步，1：已同步',
  `patient_core_id` varchar(32) DEFAULT NULL COMMENT '患者计划表主键id',
  `patient_main_id` varchar(32) DEFAULT NULL COMMENT '患者头数据id',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '数据被用于生成任务标识，0：未使用，1：已使用',
  PRIMARY KEY (`outhosp_serial_no`) USING BTREE,
  KEY `IDX_VISIT_CARD_NO` (`visit_card_no`) USING BTREE,
  KEY `IDX_EMPI_ID` (`empi_id`) USING BTREE,
  KEY `IDX_PATIENT_CORE_ID` (`patient_core_id`) USING BTREE,
  KEY `IDX_PATIENT_MAIN_ID` (`patient_main_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='就诊信息（门、急诊）';

-- ----------------------------
-- Table structure for wechat_relation
-- ----------------------------
DROP TABLE IF EXISTS `wechat_relation`;
CREATE TABLE `wechat_relation` (
  `id` varchar(32) NOT NULL,
  `wechat_name` varchar(64) NOT NULL COMMENT '公众号名称',
  `relation_id` varchar(64) NOT NULL COMMENT '公众号关联id',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='公众号的关系表';

SET FOREIGN_KEY_CHECKS = 1;
