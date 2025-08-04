/*
 Navicat MySQL Data Transfer

 Source Server         : 健海测试-3.31
 Source Server Type    : MySQL
 Source Server Version : 50650
 Source Host           : 192.168.3.31:3306
 Source Schema         : dtx-sport

 Target Server Type    : MySQL
 Target Server Version : 50650
 File Encoding         : 65001

 Date: 17/07/2025 15:12:27
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
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for field_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `field_dictionary`;
CREATE TABLE `field_dictionary` (
  `id` varchar(32) NOT NULL,
  `field_code` varchar(32) DEFAULT NULL COMMENT '字段代码',
  `field_name` varchar(32) DEFAULT NULL COMMENT '字段名称',
  `field_type` varchar(32) DEFAULT NULL COMMENT '字段类别,type表的id',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '父系id',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典表';

-- ----------------------------
-- Table structure for food
-- ----------------------------
DROP TABLE IF EXISTS `food`;
CREATE TABLE `food` (
  `id` varchar(32) NOT NULL,
  `food_name` varchar(64) NOT NULL COMMENT '食品名称',
  `food_nickname` varchar(64) DEFAULT NULL COMMENT '食品别称',
  `pic_url` varchar(512) DEFAULT NULL COMMENT '食品图片地址',
  `category_id` varchar(32) DEFAULT NULL COMMENT '分类id',
  `label_id` varchar(512) DEFAULT NULL COMMENT '标签id',
  `source` int(11) DEFAULT NULL COMMENT '来源，1：手动创建，2：模板导入，3：患者上传',
  `description` varchar(1024) DEFAULT NULL COMMENT '描述',
  `calories` decimal(12,2) DEFAULT NULL COMMENT '热量（千卡）',
  `gi` decimal(8,2) DEFAULT NULL COMMENT 'gi值',
  `gl` decimal(8,2) DEFAULT NULL COMMENT 'gl值',
  `taboos` varchar(512) DEFAULT NULL COMMENT '禁忌，疾病id，多个用,分隔',
  `replace_foods` varchar(1024) DEFAULT NULL COMMENT '替换食物json',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建者名称',
  `update_by` varchar(32) DEFAULT NULL COMMENT '修改者名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `status` int(11) DEFAULT '1' COMMENT '状态，0：停用，1：启用',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `release_status` int(11) DEFAULT '1' COMMENT '发布状态，1：待审核，2：已发布',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='食品';

-- ----------------------------
-- Table structure for food_favorite
-- ----------------------------
DROP TABLE IF EXISTS `food_favorite`;
CREATE TABLE `food_favorite` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(32) NOT NULL COMMENT '蓝牛号',
  `food_id` varchar(32) DEFAULT NULL COMMENT '食物id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='食物收藏';

-- ----------------------------
-- Table structure for food_nutrient
-- ----------------------------
DROP TABLE IF EXISTS `food_nutrient`;
CREATE TABLE `food_nutrient` (
  `id` varchar(32) NOT NULL,
  `food_id` varchar(32) NOT NULL COMMENT '食品id',
  `food_protein` decimal(8,2) NOT NULL COMMENT '蛋白质(克)',
  `food_cho` decimal(8,2) NOT NULL COMMENT '碳水化合物(克)',
  `food_fat` decimal(8,2) NOT NULL COMMENT '脂肪(克)',
  `food_fiber` decimal(8,2) DEFAULT NULL COMMENT '膳食纤维(克)',
  `food_va` decimal(8,2) DEFAULT NULL COMMENT '维生素A(微克)',
  `food_vb1` decimal(8,2) DEFAULT NULL COMMENT '维生素B1(毫克)',
  `food_vb2` decimal(8,2) DEFAULT NULL COMMENT '维生素B2(毫克)',
  `food_vb6` decimal(8,2) DEFAULT NULL COMMENT '维生素B6(毫克)',
  `food_vb12` decimal(8,2) DEFAULT NULL COMMENT '维生素B12(毫克)',
  `food_vc` decimal(8,2) DEFAULT NULL COMMENT '维生素C(毫克)',
  `food_ve` decimal(8,2) DEFAULT NULL COMMENT '维生素E(毫克)',
  `food_folic_acid` decimal(8,2) DEFAULT NULL COMMENT '叶酸(毫克)',
  `food_niacin` decimal(8,2) DEFAULT NULL COMMENT '烟酸(毫克)',
  `food_na` decimal(8,2) DEFAULT NULL COMMENT '钠(毫克)',
  `food_p` decimal(8,2) DEFAULT NULL COMMENT '磷(毫克)',
  `food_ca` decimal(8,2) DEFAULT NULL COMMENT '钙(毫克)',
  `food_fe` decimal(8,2) DEFAULT NULL COMMENT '铁(毫克)',
  `food_k` decimal(8,2) DEFAULT NULL COMMENT '钾(毫克)',
  `food_i` decimal(8,2) DEFAULT NULL COMMENT '碘(毫克)',
  `food_zn` decimal(8,2) DEFAULT NULL COMMENT '锌(毫克)',
  `food_se` decimal(8,2) DEFAULT NULL COMMENT '硒(微克)',
  `food_mg` decimal(8,2) DEFAULT NULL COMMENT '镁(毫克)',
  `food_cu` decimal(8,2) DEFAULT NULL COMMENT '铜(毫克)',
  `food_mn` decimal(8,2) DEFAULT NULL COMMENT '锰(毫克)',
  `food_cholesterol` decimal(8,2) DEFAULT NULL COMMENT '胆固醇(毫克)',
  `food_moisture` decimal(8,2) DEFAULT NULL COMMENT '水分(克)',
  `food_sfa` decimal(8,2) DEFAULT NULL COMMENT '饱和脂肪酸',
  `food_mufa` decimal(8,2) DEFAULT NULL COMMENT '单不饱和脂肪酸',
  `food_pfa` decimal(8,2) DEFAULT NULL COMMENT '多不饱和脂肪酸',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_food_id` (`food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='食品-营养素';

-- ----------------------------
-- Table structure for food_unit
-- ----------------------------
DROP TABLE IF EXISTS `food_unit`;
CREATE TABLE `food_unit` (
  `id` varchar(32) NOT NULL,
  `food_id` varchar(32) NOT NULL COMMENT '食品id',
  `unit_name` varchar(32) DEFAULT NULL COMMENT '单位名称',
  `unit_weight` decimal(12,2) DEFAULT NULL COMMENT '单位重量',
  `unit_cal` decimal(16,2) DEFAULT NULL COMMENT '单位对应热量',
  `unit_pic_url` varchar(512) DEFAULT NULL COMMENT '食品规格图片',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_food_id` (`food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='食品-度量单位';

-- ----------------------------
-- Table structure for label
-- ----------------------------
DROP TABLE IF EXISTS `label`;
CREATE TABLE `label` (
  `id` varchar(32) NOT NULL,
  `label_name` varchar(32) NOT NULL COMMENT '标签名称',
  `description` varchar(1024) DEFAULT NULL COMMENT '标签说明',
  `style` varchar(32) DEFAULT NULL COMMENT '样式',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '分类id',
  `grade` int(11) DEFAULT NULL COMMENT '层级',
  `status` int(11) DEFAULT '1' COMMENT '状态 0停用 1启用',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标签';

-- ----------------------------
-- Table structure for sport_point
-- ----------------------------
DROP TABLE IF EXISTS `sport_point`;
CREATE TABLE `sport_point` (
  `id` varchar(50) NOT NULL,
  `task_sport_id` varchar(50) DEFAULT NULL COMMENT '运动任务id',
  `pat_id` varchar(50) DEFAULT NULL COMMENT '患者id',
  `pat_type` int(2) DEFAULT NULL COMMENT '患者类型4BC',
  `data_type` int(2) DEFAULT NULL COMMENT '0最近动作记录点1身体不适退出记录点',
  `pat_sport_id` varchar(60) DEFAULT NULL COMMENT '患者运动方案id',
  `execution_date` varchar(60) DEFAULT NULL COMMENT '任务执行日期',
  `course_id` varchar(60) DEFAULT NULL COMMENT '课程id',
  `action_id` varchar(60) DEFAULT NULL COMMENT '动作id',
  `action_num` int(2) DEFAULT NULL COMMENT '当前动作次序',
  `sport_time` int(3) DEFAULT NULL COMMENT '当前运动时长秒',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '0未删除1删除',
  `action_index` int(11) DEFAULT NULL COMMENT '动作下标',
  `over_question` text COMMENT '异常提问',
  `sport_total_time` text COMMENT '课程总时间秒',
  `course_name` varchar(500) DEFAULT NULL COMMENT '课程名称',
  `course_record_time` datetime DEFAULT NULL COMMENT '课程记录时间',
  `sport_angle_list` text COMMENT '运动过程角度',
  `calorie` decimal(8,1) DEFAULT NULL COMMENT '热量',
  `target_heart_percentage` decimal(8,1) DEFAULT NULL COMMENT '靶向心率占比',
  `heart_data` text COMMENT '心率数据',
  `preview_url` varchar(200) DEFAULT NULL COMMENT '课程封面',
  `feel_state` varchar(2000) DEFAULT NULL COMMENT '运动感受',
  `push_state` int(11) NOT NULL DEFAULT '1' COMMENT '空表示待推送,1推送成功,0失败',
  `fail_num` int(11) DEFAULT NULL COMMENT '失败次数',
  `push_response` varchar(2000) DEFAULT NULL COMMENT '推送返回',
  `sport_malaise` varchar(200) DEFAULT NULL COMMENT '运动感受',
  PRIMARY KEY (`id`),
  KEY `index_patid` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运动感受';

-- ----------------------------
-- Table structure for t_assistant_client
-- ----------------------------
DROP TABLE IF EXISTS `t_assistant_client`;
CREATE TABLE `t_assistant_client` (
  `id` varchar(32) NOT NULL,
  `client_ip` varchar(255) DEFAULT NULL,
  `client_mac` varchar(255) DEFAULT NULL,
  `hosp_code` varchar(255) DEFAULT NULL,
  `staff_index` varchar(255) DEFAULT NULL,
  `third_party` varchar(255) DEFAULT NULL,
  `third_visit_type` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `online_state` int(2) DEFAULT NULL,
  `last_online_time` datetime DEFAULT NULL,
  `last_offline_time` datetime DEFAULT NULL,
  `channel_id` varchar(255) DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `asst_version` varchar(255) DEFAULT NULL,
  `doc_info` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_course_report
-- ----------------------------
DROP TABLE IF EXISTS `t_course_report`;
CREATE TABLE `t_course_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) DEFAULT NULL,
  `source_type` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `data_type` int(11) DEFAULT NULL,
  `course_report` varchar(2000) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dtx_category_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `t_dtx_category_dictionary`;
CREATE TABLE `t_dtx_category_dictionary` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id 主键',
  `category_type` int(11) DEFAULT NULL COMMENT 'category_type 分类类型0动作1消耗',
  `category_code` int(11) DEFAULT NULL COMMENT 'category_code 分类编码',
  `category_name` varchar(128) DEFAULT NULL COMMENT 'category_name 分类名称',
  `parent_category_code` int(11) DEFAULT NULL COMMENT 'parent_category_code 父类编码',
  `edit_id` varchar(128) DEFAULT NULL COMMENT 'edit_id 编辑人id',
  `edit_name` varchar(128) DEFAULT NULL COMMENT 'edit_name 编辑人姓名',
  `create_time` datetime DEFAULT NULL COMMENT 'create_time 创建时间',
  `update_time` datetime DEFAULT NULL COMMENT 'update_time 更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT 'delete_time 删除时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8mb4 COMMENT='分类字典库 ';

-- ----------------------------
-- Table structure for t_dtx_programme
-- ----------------------------
DROP TABLE IF EXISTS `t_dtx_programme`;
CREATE TABLE `t_dtx_programme` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `data_version` decimal(32,1) DEFAULT NULL COMMENT 'data_version 版本',
  `program_type` varchar(32) DEFAULT NULL COMMENT 'program_type 方案类型:0运动1饮食',
  `program_name` varchar(128) DEFAULT NULL COMMENT 'program_name 方案名称',
  `data_id` varchar(64) DEFAULT NULL COMMENT 'data_id 数据id',
  `data_type` int(11) DEFAULT NULL COMMENT 'data_type 数据类型:0动作1课程2活动3方案库',
  `data_json` longtext COMMENT 'data_json 数据',
  `is_enable` int(11) DEFAULT NULL COMMENT 'is_enable 0未启用1启用',
  `is_release` int(11) DEFAULT NULL COMMENT 'is_release 0未发布1发布',
  `diag_codes` varchar(1024) DEFAULT NULL COMMENT 'diag_codes 疾病编码逗号分隔',
  `diag_names` varchar(1024) DEFAULT NULL COMMENT 'diag_names 疾病名称',
  `category_codes` varchar(1024) DEFAULT NULL COMMENT 'category_codes 分类编码',
  `category_names` varchar(1024) DEFAULT NULL COMMENT 'category_names 分类名称',
  `edit_id` varchar(128) DEFAULT NULL COMMENT 'edit_id 编辑人id',
  `edit_name` varchar(128) DEFAULT NULL COMMENT 'edit_name 编辑人名称',
  `create_time` datetime DEFAULT NULL COMMENT 'create_time 创建时间',
  `update_time` datetime DEFAULT NULL COMMENT 'update_time 更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT 'delete_time 删除时间',
  `is_current_version` int(11) DEFAULT NULL COMMENT '是否是最新展示版本',
  `program_time` int(11) DEFAULT NULL COMMENT '课程时间秒',
  `preview_url` varchar(500) DEFAULT NULL COMMENT '预览url',
  `symptom_ids` varchar(1500) DEFAULT NULL COMMENT '症状id',
  `symptom_names` varchar(1500) DEFAULT NULL COMMENT '症状名称',
  `action_ids` varchar(1500) DEFAULT NULL COMMENT '症状名称',
  `symptom_code` bigint(20) DEFAULT NULL,
  `hosp_code` varchar(2000) DEFAULT NULL COMMENT '医院编码',
  `hosp_name` varchar(2000) DEFAULT NULL COMMENT '医院名称',
  PRIMARY KEY (`id`),
  KEY `program_type_` (`program_type`) USING BTREE,
  KEY `data_type_` (`data_type`) USING BTREE,
  KEY `datat_p` (`program_type`,`data_type`) USING BTREE,
  KEY `sy1` (`data_id`) USING BTREE,
  KEY `sy2` (`delete_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='症状名称';

-- ----------------------------
-- Table structure for t_dtx_programme_business
-- ----------------------------
DROP TABLE IF EXISTS `t_dtx_programme_business`;
CREATE TABLE `t_dtx_programme_business` (
  `id` varchar(32) NOT NULL COMMENT 'id 主键',
  `business_type` int(2) DEFAULT NULL COMMENT '业务类型0GDM',
  `pat_id` varchar(50) DEFAULT NULL,
  `data_version` decimal(32,1) DEFAULT NULL COMMENT 'data_version 版本',
  `program_type` varchar(32) DEFAULT NULL COMMENT 'program_type 方案类型:0运动1饮食',
  `program_name` varchar(128) DEFAULT NULL COMMENT 'program_name 方案名称',
  `data_id` varchar(64) DEFAULT NULL COMMENT 'data_id 数据id',
  `data_type` int(11) DEFAULT NULL COMMENT 'data_type 数据类型:0动作1课程2活动3方案库',
  `data_json` longtext COMMENT 'data_json 数据',
  `is_enable` int(11) DEFAULT NULL COMMENT 'is_enable 0未启用1启用',
  `is_release` int(11) DEFAULT NULL COMMENT 'is_release 0未发布1发布',
  `diag_codes` varchar(1024) DEFAULT NULL COMMENT 'diag_codes 疾病编码逗号分隔',
  `diag_names` varchar(1024) DEFAULT NULL COMMENT 'diag_names 疾病名称',
  `category_codes` varchar(1024) DEFAULT NULL COMMENT 'category_codes 分类编码',
  `category_names` varchar(1024) DEFAULT NULL COMMENT 'category_names 分类名称',
  `edit_id` varchar(128) DEFAULT NULL COMMENT 'edit_id 编辑人id',
  `edit_name` varchar(128) DEFAULT NULL COMMENT 'edit_name 编辑人名称',
  `create_time` datetime DEFAULT NULL COMMENT 'create_time 创建时间',
  `update_time` datetime DEFAULT NULL COMMENT 'update_time 更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT 'delete_time 删除时间',
  `is_current_version` int(11) DEFAULT NULL COMMENT '是否是最新展示版本',
  `program_time` int(11) DEFAULT NULL COMMENT '课程时间秒',
  `preview_url` varchar(500) DEFAULT NULL COMMENT '预览url',
  `symptom_ids` varchar(1500) DEFAULT NULL COMMENT '症状id',
  `symptom_names` varchar(1500) DEFAULT NULL COMMENT '症状名称',
  `action_ids` varchar(1500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sy1` (`program_type`) USING BTREE,
  KEY `sy2` (`data_type`) USING BTREE,
  KEY `sy4` (`program_type`,`data_type`) USING BTREE,
  KEY `sy5` (`data_id`) USING BTREE,
  KEY `sy6` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务方案库';

-- ----------------------------
-- Table structure for t_dtx_programme_business_copy
-- ----------------------------
DROP TABLE IF EXISTS `t_dtx_programme_business_copy`;
CREATE TABLE `t_dtx_programme_business_copy` (
  `id` varchar(32) NOT NULL COMMENT 'id 主键',
  `business_type` int(2) DEFAULT NULL COMMENT '业务类型0GDM',
  `pat_id` varchar(50) DEFAULT NULL,
  `data_version` decimal(32,1) DEFAULT NULL COMMENT 'data_version 版本',
  `program_type` varchar(32) DEFAULT NULL COMMENT 'program_type 方案类型:0运动1饮食',
  `program_name` varchar(128) DEFAULT NULL COMMENT 'program_name 方案名称',
  `data_id` varchar(64) DEFAULT NULL COMMENT 'data_id 数据id',
  `data_type` int(11) DEFAULT NULL COMMENT 'data_type 数据类型:0动作1课程2活动3方案库',
  `data_json` longtext COMMENT 'data_json 数据',
  `is_enable` int(11) DEFAULT NULL COMMENT 'is_enable 0未启用1启用',
  `is_release` int(11) DEFAULT NULL COMMENT 'is_release 0未发布1发布',
  `diag_codes` varchar(1024) DEFAULT NULL COMMENT 'diag_codes 疾病编码逗号分隔',
  `diag_names` varchar(1024) DEFAULT NULL COMMENT 'diag_names 疾病名称',
  `category_codes` varchar(1024) DEFAULT NULL COMMENT 'category_codes 分类编码',
  `category_names` varchar(1024) DEFAULT NULL COMMENT 'category_names 分类名称',
  `edit_id` varchar(128) DEFAULT NULL COMMENT 'edit_id 编辑人id',
  `edit_name` varchar(128) DEFAULT NULL COMMENT 'edit_name 编辑人名称',
  `create_time` datetime DEFAULT NULL COMMENT 'create_time 创建时间',
  `update_time` datetime DEFAULT NULL COMMENT 'update_time 更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT 'delete_time 删除时间',
  `is_current_version` int(11) DEFAULT NULL COMMENT '是否是最新展示版本',
  `program_time` int(11) DEFAULT NULL COMMENT '课程时间秒',
  `preview_url` varchar(500) DEFAULT NULL COMMENT '预览url',
  `symptom_ids` varchar(1500) DEFAULT NULL COMMENT '症状id',
  `symptom_names` varchar(1500) DEFAULT NULL COMMENT '症状名称',
  `action_ids` varchar(1500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sy1` (`program_type`) USING BTREE,
  KEY `sy2` (`data_type`) USING BTREE,
  KEY `sy4` (`program_type`,`data_type`) USING BTREE,
  KEY `sy5` (`data_id`) USING BTREE,
  KEY `sy6` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务方案库';

-- ----------------------------
-- Table structure for t_dtx_programme_copy
-- ----------------------------
DROP TABLE IF EXISTS `t_dtx_programme_copy`;
CREATE TABLE `t_dtx_programme_copy` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id 主键',
  `data_version` decimal(32,1) DEFAULT NULL COMMENT 'data_version 版本',
  `program_type` varchar(32) DEFAULT NULL COMMENT 'program_type 方案类型:0运动1饮食',
  `program_name` varchar(128) DEFAULT NULL COMMENT 'program_name 方案名称',
  `data_id` varchar(64) DEFAULT NULL COMMENT 'data_id 数据id',
  `data_type` int(11) DEFAULT NULL COMMENT 'data_type 数据类型:0动作1课程2活动3方案库',
  `data_json` longtext COMMENT 'data_json 数据',
  `is_enable` int(11) DEFAULT NULL COMMENT 'is_enable 0未启用1启用',
  `is_release` int(11) DEFAULT NULL COMMENT 'is_release 0未发布1发布',
  `diag_codes` varchar(1024) DEFAULT NULL COMMENT 'diag_codes 疾病编码逗号分隔',
  `diag_names` varchar(1024) DEFAULT NULL COMMENT 'diag_names 疾病名称',
  `category_codes` varchar(1024) DEFAULT NULL COMMENT 'category_codes 分类编码',
  `category_names` varchar(1024) DEFAULT NULL COMMENT 'category_names 分类名称',
  `edit_id` varchar(128) DEFAULT NULL COMMENT 'edit_id 编辑人id',
  `edit_name` varchar(128) DEFAULT NULL COMMENT 'edit_name 编辑人名称',
  `create_time` datetime DEFAULT NULL COMMENT 'create_time 创建时间',
  `update_time` datetime DEFAULT NULL COMMENT 'update_time 更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT 'delete_time 删除时间',
  `is_current_version` int(11) DEFAULT NULL COMMENT '是否是最新展示版本',
  `program_time` int(11) DEFAULT NULL COMMENT '课程时间秒',
  `preview_url` varchar(500) DEFAULT NULL COMMENT '预览url',
  `symptom_ids` varchar(1500) DEFAULT NULL COMMENT '症状id',
  `symptom_names` varchar(1500) DEFAULT NULL COMMENT '症状名称',
  `action_ids` varchar(1500) DEFAULT NULL COMMENT '症状名称',
  `symptom_code` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `program_type_` (`program_type`) USING BTREE,
  KEY `data_type_` (`data_type`) USING BTREE,
  KEY `datat_p` (`program_type`,`data_type`) USING BTREE,
  KEY `sy1` (`data_id`) USING BTREE,
  KEY `sy2` (`delete_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3334689 DEFAULT CHARSET=utf8mb4 COMMENT='症状名称';

-- ----------------------------
-- Table structure for t_dtx_voice
-- ----------------------------
DROP TABLE IF EXISTS `t_dtx_voice`;
CREATE TABLE `t_dtx_voice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(2000) DEFAULT NULL,
  `voice_url` varchar(1000) DEFAULT NULL,
  `voice_type` varchar(11) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dtx_voice_copy
-- ----------------------------
DROP TABLE IF EXISTS `t_dtx_voice_copy`;
CREATE TABLE `t_dtx_voice_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(2000) DEFAULT NULL,
  `voice_url` varchar(1000) DEFAULT NULL,
  `voice_type` varchar(11) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_equ_config
-- ----------------------------
DROP TABLE IF EXISTS `t_equ_config`;
CREATE TABLE `t_equ_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eq_name` varchar(500) DEFAULT NULL COMMENT '设备名称',
  `brand` varchar(500) DEFAULT NULL COMMENT '设备品牌',
  `eq_type` int(11) DEFAULT NULL COMMENT '设备类型0=血糖',
  `eq_type_name` varchar(500) DEFAULT NULL COMMENT '设备类型名称 血糖仪',
  `need_send_cmd` tinyint(1) DEFAULT NULL COMMENT '否需要发送命令，需要向服务获取',
  `close_cmd` varchar(500) DEFAULT NULL COMMENT '关闭命令值',
  `blue_name` varchar(500) DEFAULT NULL COMMENT '蓝牙名称',
  `main_service` varchar(500) DEFAULT NULL,
  `write_service` varchar(500) DEFAULT NULL,
  `read_service` varchar(500) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `need_judge_result_effect` tinyint(4) DEFAULT NULL COMMENT ' 需要判断设备返回结果合法性',
  `eff_data_length` int(11) DEFAULT NULL COMMENT '总数据长度',
  `result_data` varchar(500) DEFAULT NULL,
  `need_server_result` tinyint(4) DEFAULT NULL COMMENT '需要上传服务解析结果',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_health
-- ----------------------------
DROP TABLE IF EXISTS `t_health`;
CREATE TABLE `t_health` (
  `health_id` varchar(64) NOT NULL COMMENT '主键',
  `health_type` int(2) DEFAULT NULL COMMENT '类型 1胎心2血压3血糖4体温5心率',
  `health_value` text COMMENT '数值',
  `health_unit` varchar(5000) DEFAULT NULL,
  `health_status` int(2) DEFAULT NULL COMMENT '健康状态',
  `measuring_time` varchar(20) DEFAULT NULL COMMENT '测量时间 yyyy-MM-dd HH:mm:ss',
  `instruction` longtext,
  `measuring_point` int(2) DEFAULT NULL COMMENT '测量点 1早餐前2早餐后3午餐前4午餐后5晚餐前6晚餐后7睡前',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `resource_id` varchar(64) DEFAULT NULL COMMENT '文件id',
  `hug_id` varchar(64) DEFAULT NULL COMMENT '用户id',
  `member_id` varchar(64) DEFAULT NULL COMMENT '成员id',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效1有效',
  `upload_flag` int(11) NOT NULL DEFAULT '0' COMMENT '0未上传 1已上传',
  `measure_period_type` int(1) DEFAULT NULL COMMENT '测量时长类型 1短期2长期',
  `relation_id` varchar(64) DEFAULT NULL COMMENT '数据关联 8心电为FTP文件名前缀',
  `manufacturer` int(1) DEFAULT NULL COMMENT '健康设备厂商 1百惠心电设备2竹信心电设备',
  `health_code` varchar(32) DEFAULT NULL COMMENT '健康编码',
  `health_name` varchar(64) DEFAULT NULL COMMENT '健康名称',
  `energy` double DEFAULT NULL,
  `device_type` int(11) DEFAULT NULL COMMENT '设备类型',
  `third_id` varchar(50) DEFAULT NULL COMMENT '第三方数据id值',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医生所属医院编码',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '医生id',
  `doc_name` varchar(20) DEFAULT NULL COMMENT '医生姓名',
  `source_type` int(2) DEFAULT NULL COMMENT '来源(1门诊2出院3在院13建档（其他）99健康小屋(新附一个性化需求)',
  `remark` varchar(250) DEFAULT NULL COMMENT '备注',
  `update_person_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `update_person_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `update_dept_code` varchar(20) DEFAULT NULL COMMENT '编辑人科室编码',
  `update_dept_name` varchar(25) DEFAULT NULL COMMENT '编辑人科室名称',
  PRIMARY KEY (`health_id`),
  KEY `health_hug_id` (`hug_id`),
  KEY `idx_measuring_time` (`measuring_time`),
  KEY `health_type_hug_id` (`health_type`,`hug_id`,`status`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_healthid_measuretime` (`health_id`,`measuring_time`) USING BTREE,
  KEY `idx_health_id` (`health_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康数据';

-- ----------------------------
-- Table structure for t_huawei_oauth
-- ----------------------------
DROP TABLE IF EXISTS `t_huawei_oauth`;
CREATE TABLE `t_huawei_oauth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oauth_name` varchar(500) DEFAULT NULL COMMENT 'oauth权限名称',
  `atom_sample_type` varchar(500) DEFAULT NULL COMMENT '原子采样数据类型',
  `statistics_type` varchar(500) DEFAULT NULL COMMENT '统计数据类型',
  `mark` varchar(500) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  `health_type` int(11) DEFAULT NULL COMMENT '健康数据类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='健康数据类型';

-- ----------------------------
-- Table structure for t_huawei_token
-- ----------------------------
DROP TABLE IF EXISTS `t_huawei_token`;
CREATE TABLE `t_huawei_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ln_account` varchar(255) DEFAULT NULL,
  `access_token` varchar(1500) DEFAULT NULL,
  `expires_in` int(11) DEFAULT NULL,
  `id_token` text,
  `refresh_token` varchar(1500) DEFAULT NULL,
  `scope` text,
  `token_type` varchar(500) DEFAULT NULL,
  `token_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  `refresh_token_expires_in` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_sport_config
-- ----------------------------
DROP TABLE IF EXISTS `t_sport_config`;
CREATE TABLE `t_sport_config` (
  `id` varchar(64) NOT NULL,
  `config_name` varchar(255) DEFAULT NULL,
  `config_code` varchar(20) DEFAULT NULL,
  `config_type` int(2) DEFAULT NULL,
  `is_delete` int(1) DEFAULT NULL,
  `create_time` date DEFAULT NULL,
  `update_time` date DEFAULT NULL,
  `config_cover` varchar(255) DEFAULT NULL,
  `config_detail` longtext COMMENT '配置详情',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_symptom
-- ----------------------------
DROP TABLE IF EXISTS `t_symptom`;
CREATE TABLE `t_symptom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `symptom_diag_id` varchar(64) DEFAULT NULL,
  `symptom_id` varchar(50) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `delete_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=768 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_target_heart_adjust
-- ----------------------------
DROP TABLE IF EXISTS `t_target_heart_adjust`;
CREATE TABLE `t_target_heart_adjust` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(50) DEFAULT NULL,
  `adjust` varchar(300) DEFAULT NULL COMMENT '靶向心率调整值',
  `sport_id` varchar(50) DEFAULT NULL COMMENT '对应调整的记录id',
  `create_time` datetime DEFAULT NULL,
  `is_delete` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
