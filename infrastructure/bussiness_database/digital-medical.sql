/*
 Navicat MySQL Data Transfer

 Source Server         : 健海测试-3.88
 Source Server Type    : MySQL
 Source Server Version : 80034
 Source Host           : 192.168.3.88:3306
 Source Schema         : digital-medical

 Target Server Type    : MySQL
 Target Server Version : 80034
 File Encoding         : 65001

 Date: 17/07/2025 10:04:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for DATABASECHANGELOG
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOG`;
CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `AUTHOR` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `FILENAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `MD5SUM` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `TAG` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `LIQUIBASE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `CONTEXTS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `LABELS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for DATABASECHANGELOGLOCK
-- ----------------------------
DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for agent
-- ----------------------------
DROP TABLE IF EXISTS `agent`;
CREATE TABLE `agent` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `des` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述',
  `type` tinyint(1) NOT NULL COMMENT '类型 1功能型 2专科型',
  `status` tinyint(1) NOT NULL COMMENT '状态 1维护中 2测试中 3已发布',
  `category` tinyint NOT NULL COMMENT '类别 1dify 2coze',
  `api_status` tinyint(1) DEFAULT '0' COMMENT '是否启用api 0未启用 1启用',
  `api_endpoint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'api端点',
  `api_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'api秘钥',
  `chat_status` tinyint(1) DEFAULT '0' COMMENT '是否启用对话 0未启用 1启用',
  `chat_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '对话页面链接',
  `chat_welcome_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '对话欢迎消息',
  `chat_recommend_question` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '对话建议问题',
  `version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '版本',
  `version_date` datetime DEFAULT NULL COMMENT '版本发布时间',
  `version_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '版本发布描述',
  `version_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '版本id，记录版本历史',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_name` (`name`) USING BTREE,
  KEY `idx_version_id` (`version_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='智能体表';

-- ----------------------------
-- Table structure for ai_conversation_record
-- ----------------------------
DROP TABLE IF EXISTS `ai_conversation_record`;
CREATE TABLE `ai_conversation_record` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `user_type` tinyint NOT NULL COMMENT '用户类型 0-机器人 1-客服 ',
  `pay_id` varchar(40) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'payId',
  `relation_question_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对应的问题id',
  `content` varchar(2000) COLLATE utf8mb4_bin NOT NULL COMMENT '内容',
  `platform` tinyint NOT NULL COMMENT '平台（1企微 2健管云）',
  `customer_account` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '健管师账号 健管云userId/企微userId',
  `message_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '消息id',
  `conversation_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对话id',
  `evaluate` tinyint NOT NULL DEFAULT '0' COMMENT '0-初始值 1-点赞 2-点踩',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `files` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '文件地址,分割',
  `empi_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云EmpiId',
  `tags_ai` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'tagsAI',
  `pat_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'patId',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='ai对话记录';

-- ----------------------------
-- Table structure for allergy_dict
-- ----------------------------
DROP TABLE IF EXISTS `allergy_dict`;
CREATE TABLE `allergy_dict` (
  `id` int NOT NULL AUTO_INCREMENT,
  `allergy_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '过敏源',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sort_no` int DEFAULT '0' COMMENT '排序',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='过敏字典表';

-- ----------------------------
-- Table structure for applets_config
-- ----------------------------
DROP TABLE IF EXISTS `applets_config`;
CREATE TABLE `applets_config` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `app_identify` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '标识符',
  `hosp_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构代码 0-全选',
  `service_mode` tinyint DEFAULT NULL,
  `sp_id` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL,
  `welcome_page_img` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '欢迎页图片oss地址,多张图片以逗号分隔',
  `warm_up_period_img` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '预热期图片oss地址,多张图片以逗号分隔',
  `course_banner_img` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '课程banner图oss地址,多张图片以逗号分隔',
  `course_head_img` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '课程头图oss地址,多张图片以逗号分隔',
  `core_data_sorting` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '核心数据排序,任务类型以逗号分割',
  `labels` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '适用标签id列表(来源大脑,多个以逗号分隔',
  `course_package_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '课程包id列表,多个以逗号分隔',
  `edit_time` datetime NOT NULL COMMENT '编辑时间',
  `editor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '编辑人id',
  `editor_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '编辑人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `symptoms` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '疾病id列表，多个以,隔开',
  `subjects` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '专题id列表，多个以逗号分隔',
  `goods_id` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL,
  `course_banner_ids` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '课程bannerId列表，多个以逗号分割',
  `healthy_life_id` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='小程序配置表';

-- ----------------------------
-- Table structure for banner_config
-- ----------------------------
DROP TABLE IF EXISTS `banner_config`;
CREATE TABLE `banner_config` (
  `id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `app_identify` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '标识符',
  `image_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'banner图地址',
  `jump_type` tinyint NOT NULL DEFAULT '0' COMMENT '跳转类型 0-无跳转 1-小程序(内部) 2-H5 3-文字弹窗 4-小程序(外部)',
  `app_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转小程序(外部)的AppId',
  `jump_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转路径 公众号文章地址或小程序路由',
  `sort_no` int NOT NULL COMMENT 'banner排序 数值小的排前面',
  `page_id` tinyint NOT NULL DEFAULT '1' COMMENT '展示页面 1-首页 2-个人中心',
  `online_time` datetime(6) NOT NULL COMMENT 'banner上线时间',
  `offline_time` datetime(6) NOT NULL COMMENT 'banner下线时间',
  `state` tinyint NOT NULL DEFAULT '1' COMMENT '状态 0-未启用 1-已启用',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(6) NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='banner配置表';

-- ----------------------------
-- Table structure for case_summary
-- ----------------------------
DROP TABLE IF EXISTS `case_summary`;
CREATE TABLE `case_summary` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '数据中心患者id',
  `hosp_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云患者id',
  `user_source_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `pay_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '服务包开单id',
  `third_case_summary_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '健管患者结案小结表主键',
  `conclusion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '结束语',
  `jump_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '结案报告h5跳转地址',
  `report_push_date` date DEFAULT NULL COMMENT '结案报告推送日期',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户结案小结报告表';

-- ----------------------------
-- Table structure for child_archive
-- ----------------------------
DROP TABLE IF EXISTS `child_archive`;
CREATE TABLE `child_archive` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号',
  `nick_name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '昵称',
  `birthday` date NOT NULL COMMENT '出生日期',
  `sex` tinyint NOT NULL COMMENT '性别 1：男，2：女',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='儿童档案表';

-- ----------------------------
-- Table structure for child_growth_standards
-- ----------------------------
DROP TABLE IF EXISTS `child_growth_standards`;
CREATE TABLE `child_growth_standards` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sex` tinyint DEFAULT NULL COMMENT '性别 1：男，2：女',
  `standard_type` tinyint NOT NULL COMMENT '类型 1:身高 2:体重 3:头围',
  `month_age` int DEFAULT NULL COMMENT '月龄',
  `three_value` decimal(4,1) NOT NULL COMMENT '3%标准值',
  `fifty_value` decimal(4,1) NOT NULL COMMENT '50%标准值',
  `ninety_seven_value` decimal(4,1) NOT NULL COMMENT '97%标准值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='儿童生长标准表';

-- ----------------------------
-- Table structure for competition_body_composition
-- ----------------------------
DROP TABLE IF EXISTS `competition_body_composition`;
CREATE TABLE `competition_body_composition` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `is_delete` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否已删除 0否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `pat_id` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者数据中心id',
  `conpetition_type` int DEFAULT NULL COMMENT '参赛类型1.全民大赛2.减重大赛',
  `pic_url` varchar(2000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '体成分图片地址，多个以英文逗号分隔',
  `execute_date` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '上传日期 yyyy-MM-dd',
  PRIMARY KEY (`id`),
  KEY `idx_patId` (`pat_id`(8)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='大赛人体成分信息';

-- ----------------------------
-- Table structure for competition_body_info
-- ----------------------------
DROP TABLE IF EXISTS `competition_body_info`;
CREATE TABLE `competition_body_info` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `is_delete` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否已删除 0否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `pat_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者数据中心id',
  `height` decimal(4,1) NOT NULL COMMENT '自测自高(cm)',
  `weight` decimal(4,1) NOT NULL COMMENT '自测体重(kg)',
  `bmi` decimal(4,1) NOT NULL COMMENT 'BMI',
  `body_fat_rate` decimal(4,1) DEFAULT NULL COMMENT '体脂率',
  `waist_circumference` decimal(4,1) NOT NULL COMMENT '腰围(cm)',
  `serious_organic_diseases` int NOT NULL COMMENT '是否有严重器质性疾病  0-否 1-是',
  `special_phy` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '特殊生理/病理状态 枚举类型',
  `special_phy_other` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '特殊生理/病理状态 其它说明',
  `take_special_med` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '服用特殊药物 枚举类型',
  `take_special_med_other` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '服用特殊药物 其它说明',
  `complete_basic_exercises` int NOT NULL COMMENT '是否能配合完成基础运动 0-否 1-是',
  PRIMARY KEY (`id`),
  KEY `idx_hugId` (`bmi`) USING BTREE,
  KEY `idx_patId` (`pat_id`(8)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='大赛患者身体信息(纳排)';

-- ----------------------------
-- Table structure for competition_enroll_info
-- ----------------------------
DROP TABLE IF EXISTS `competition_enroll_info`;
CREATE TABLE `competition_enroll_info` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `is_delete` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否已删除 0否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `pat_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者数据中心id',
  `mobile` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '报名电话',
  `nick_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '昵称',
  `pat_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '报名姓名',
  `hug_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '绑定的小程序账号',
  `identity_card` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '身份证',
  `sex` tinyint NOT NULL COMMENT '性别',
  `age` int NOT NULL COMMENT '年龄',
  `hosp_code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `conpetition_type` tinyint NOT NULL COMMENT '参赛类型1.全民大赛2.减重大赛',
  `weight_enroll_status` int NOT NULL COMMENT '大赛报名状态：-1:不符合条件 1已报名完成',
  `is_physical_test` int DEFAULT '0' COMMENT '体重管理大赛是否提测 0-未体测 1-已体测',
  `empi_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'empi_id',
  `pay_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '开单id',
  PRIMARY KEY (`id`),
  KEY `idx_hugId` (`hug_id`(8)) USING BTREE,
  KEY `idx_patId` (`pat_id`(8)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='大赛报名信息';

-- ----------------------------
-- Table structure for competition_link_share
-- ----------------------------
DROP TABLE IF EXISTS `competition_link_share`;
CREATE TABLE `competition_link_share` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `is_delete` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否已删除 0否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `link_share_hug_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '链接分享者hugId',
  `link_open_hug_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '链接打开者hugId',
  `link_open_pat_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '链接打开者patId',
  PRIMARY KEY (`id`),
  KEY `idx_hugId` (`link_open_pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='链接打开记录表';

-- ----------------------------
-- Table structure for course_config
-- ----------------------------
DROP TABLE IF EXISTS `course_config`;
CREATE TABLE `course_config` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `source` int NOT NULL COMMENT '来源 17:健管服务',
  `course_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '课程名称',
  `image_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '封面图地址',
  `jump_type` tinyint NOT NULL DEFAULT '0' COMMENT '跳转类型 0-无跳转 1-小程序(内部) 2-H5 3-文字弹窗 4-小程序(外部)',
  `jump_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转路径 公众号文章地址或小程序路由',
  `app_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转小程序(外部)的AppId',
  `online_time` datetime(6) NOT NULL COMMENT '上线时间',
  `offline_time` datetime(6) NOT NULL COMMENT '下线时间',
  `apply_group` tinyint NOT NULL DEFAULT '0' COMMENT '适用群体枚举 0:全部',
  `state` tinyint NOT NULL DEFAULT '1' COMMENT '状态 0-未启用 1-已启用',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(6) NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='课程配置表';

-- ----------------------------
-- Table structure for disease_dict
-- ----------------------------
DROP TABLE IF EXISTS `disease_dict`;
CREATE TABLE `disease_dict` (
  `id` int NOT NULL AUTO_INCREMENT,
  `disease_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '疾病名称',
  `pid` int DEFAULT NULL COMMENT '父级id 0:无父级的二级疾病项,null:父级疾病项',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sort_no` int DEFAULT '0' COMMENT '排序',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='疾病字典表';

-- ----------------------------
-- Table structure for edu_recommend_config
-- ----------------------------
DROP TABLE IF EXISTS `edu_recommend_config`;
CREATE TABLE `edu_recommend_config` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `edu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '宣教id',
  `sort_no` int DEFAULT '0' COMMENT '排序',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `hosp_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '医院标识',
  `dictionary_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '科室标识',
  `hosp_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '全部' COMMENT '医院名称',
  `dictionary_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '全部' COMMENT '科室名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='宣教推荐配置表';

-- ----------------------------
-- Table structure for enter_record
-- ----------------------------
DROP TABLE IF EXISTS `enter_record`;
CREATE TABLE `enter_record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '数据中心患者id',
  `hug_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '蓝牛号',
  `page_code` tinyint DEFAULT NULL COMMENT '1.欢迎页 2.知情同意书',
  `user_source_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `entered` tinyint(1) DEFAULT '0' COMMENT '0-未进入过 1-进入过',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='页面进入记录表';

-- ----------------------------
-- Table structure for follow_up_phone_kept_record
-- ----------------------------
DROP TABLE IF EXISTS `follow_up_phone_kept_record`;
CREATE TABLE `follow_up_phone_kept_record` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '数据中心患者id',
  `empi_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '健管云患者唯一标识',
  `user_phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户手机号',
  `hosp_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构代码',
  `is_saved` tinyint(1) DEFAULT NULL COMMENT '是否已保存机构随访电话',
  `follow_up_phone` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '保存的随访电话',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户保存随访电话记录表';

-- ----------------------------
-- Table structure for growth_record_history
-- ----------------------------
DROP TABLE IF EXISTS `growth_record_history`;
CREATE TABLE `growth_record_history` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `child_archive_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '档案表id',
  `measuring_date` date NOT NULL COMMENT '记录日期',
  `month_age` int NOT NULL COMMENT '月龄_身高体重',
  `month_age_head_cm` int NOT NULL COMMENT '月龄_头围',
  `height` decimal(4,1) DEFAULT NULL COMMENT '身高',
  `weight` decimal(4,1) DEFAULT NULL COMMENT '体重',
  `head_cm` decimal(4,1) DEFAULT NULL COMMENT '头围',
  `height_flag` tinyint DEFAULT NULL COMMENT '身高异常标识 -1:偏低 NULL:正常 1:偏高',
  `weight_flag` tinyint DEFAULT NULL COMMENT '体重异常标识 -1:偏低 NULL:正常 1:偏高',
  `head_cm_flag` tinyint DEFAULT NULL COMMENT '头围异常标识 -1:偏低 NULL:正常 1:偏高',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='儿童生长记录表';

-- ----------------------------
-- Table structure for health_tip
-- ----------------------------
DROP TABLE IF EXISTS `health_tip`;
CREATE TABLE `health_tip` (
  `id` bigint NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '患者id',
  `execution_date` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行日期',
  `create_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '创建时间',
  `update_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '修改时间',
  `read_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '阅读状态 0 未读 1 已读',
  `tip_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '健康贴士id',
  `task_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '健康贴士id',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0 未删除 1 已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for message_record
-- ----------------------------
DROP TABLE IF EXISTS `message_record`;
CREATE TABLE `message_record` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hosp_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '医院编码',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '手机号',
  `subject` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '主体',
  `scene_type` int NOT NULL COMMENT '场景类型 1血糖 2运动 3饮食 4体重 5预约挂号 6宣教 7随访 8未接通电话 9满意度问卷 10档案填写 11复诊提醒 12用药提醒 13未读提醒 14文字提醒 15打卡提醒 16补卡提醒 17自定义提醒 18随访提醒',
  `scene_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '场景名称',
  `content` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '内容',
  `treatment_method` int NOT NULL COMMENT '处理方式 1跳转小程序 2跳转h5 3仅阅读',
  `app_type` int DEFAULT NULL COMMENT '小程序类型',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转路径',
  `treatment_status` int DEFAULT '1' COMMENT '处理状态 1未处理 2已处理',
  `third_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '第三方唯一号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='消息记录';

-- ----------------------------
-- Table structure for pat_allergy_history
-- ----------------------------
DROP TABLE IF EXISTS `pat_allergy_history`;
CREATE TABLE `pat_allergy_history` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号',
  `allergy_dict_ids` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '过敏字典表id,多项以,分隔',
  `other_allergens` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '其它过敏源',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户过敏史';

-- ----------------------------
-- Table structure for pat_disease_history
-- ----------------------------
DROP TABLE IF EXISTS `pat_disease_history`;
CREATE TABLE `pat_disease_history` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号',
  `relation` int NOT NULL COMMENT '关系 1本人 2父亲 3母亲 4兄弟姐妹 5祖父母 6子女',
  `disease_dict_ids` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '疾病字典表id,多项以,分隔',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户疾病史';

-- ----------------------------
-- Table structure for pat_remind
-- ----------------------------
DROP TABLE IF EXISTS `pat_remind`;
CREATE TABLE `pat_remind` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '数据中心患者id',
  `hosp_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构代码',
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云患者id',
  `third_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '第三方唯一主键',
  `pay_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '第三方服务包开单id',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `source_type` int NOT NULL COMMENT '来源  1：妊娠',
  `start_time` datetime DEFAULT NULL COMMENT '展示开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '展示结束时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='患者提醒表';

-- ----------------------------
-- Table structure for program_binding
-- ----------------------------
DROP TABLE IF EXISTS `program_binding`;
CREATE TABLE `program_binding` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `is_delete` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否已删除 0否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `pat_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '患者数据中心id',
  `pat_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '姓名',
  `mobile` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '手机号',
  `relationship` tinyint(1) NOT NULL COMMENT '亲属关系',
  `hug_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '绑定的小程序账号',
  `identity_card` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '身份证',
  `is_current_patient` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为当前就诊人  0否 1是',
  `access_token` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '数据中心请求令牌',
  `expire_time` datetime DEFAULT NULL COMMENT '令牌过期时间',
  `refresh_token` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '刷新token',
  `hosp_code` varchar(40) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构代码',
  `dept_code` varchar(40) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '科室代码',
  `empi_id` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云患者id',
  `user_source` int DEFAULT NULL COMMENT '用户来源 10-未开单扫码绑定',
  `dept_type` int DEFAULT NULL COMMENT '科室类型 1:门诊科室 2:住院科室',
  `source_type` int DEFAULT NULL COMMENT '业务数据来源(1:门诊 2:出院 3:在院',
  `serial_no` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '业务数据流水号(住院流水号/门诊流水号等)',
  `card_no` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '住院号/门诊号',
  `is_reg_competition` int DEFAULT NULL COMMENT '用户是否注册减重大赛小程序  0否 1是',
  `nick_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '微信昵称',
  `account_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '企微账号id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_patId` (`pat_id`(8)) USING BTREE,
  KEY `idx_hugId` (`hug_id`(8)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='就诊人绑定关系表';

-- ----------------------------
-- Table structure for prompt_info
-- ----------------------------
DROP TABLE IF EXISTS `prompt_info`;
CREATE TABLE `prompt_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `is_first` tinyint(1) DEFAULT NULL COMMENT '是否首次记录 0:不是 1:是',
  `prompt_type` tinyint NOT NULL COMMENT '提示类型 1:身高 2:体重 3:头围',
  `last_level` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '上一次记录评级',
  `present_level` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '本次记录评级',
  `judge` tinyint NOT NULL COMMENT '标准评判 -1:偏低 0:正常 1：偏高',
  `title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '提示标题',
  `advice` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '建议',
  `jump_path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转路径',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='儿童生长情况提示表';

-- ----------------------------
-- Table structure for psy_patient
-- ----------------------------
DROP TABLE IF EXISTS `psy_patient`;
CREATE TABLE `psy_patient` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `hug_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '绑定的小程序账号',
  `phone` varchar(11) COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号对应的手机号',
  `pat_name` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '姓名',
  `mobile` varchar(11) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '咨询人手机号',
  `relationship` tinyint(1) DEFAULT NULL COMMENT '亲属关系',
  `identity_card` varchar(18) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '身份证',
  `contact_mobile` varchar(11) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '联系人手机号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `age` tinyint DEFAULT NULL COMMENT '年龄',
  `sex_code` tinyint(1) DEFAULT NULL COMMENT '性别，1：男，2：女',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='心理小程序就诊人表';

-- ----------------------------
-- Table structure for push_config
-- ----------------------------
DROP TABLE IF EXISTS `push_config`;
CREATE TABLE `push_config` (
  `id` bigint NOT NULL,
  `pat_id` bigint NOT NULL COMMENT '患者id',
  `empi_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '主索引',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 1开启 2关闭',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='推送设置';

-- ----------------------------
-- Table structure for reading_record
-- ----------------------------
DROP TABLE IF EXISTS `reading_record`;
CREATE TABLE `reading_record` (
  `id` bigint NOT NULL,
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号',
  `type` tinyint NOT NULL COMMENT '类型 1-推荐宣教 2-复诊提醒',
  `primary_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '推荐宣教或复诊提醒主键id',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '阅读时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `read_once_idx` (`hug_id`,`type`,`primary_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='首次阅读(推荐宣教和复诊提醒)记录表';

-- ----------------------------
-- Table structure for retry_record
-- ----------------------------
DROP TABLE IF EXISTS `retry_record`;
CREATE TABLE `retry_record` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `retry_type` tinyint NOT NULL COMMENT '事件类型',
  `err_time` datetime NOT NULL COMMENT '报错时间',
  `req_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '请求参数',
  `retry_count` int NOT NULL DEFAULT '0' COMMENT '重试次数',
  `err_content` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '报错内容',
  `third_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '第三方id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='任务重试记录表';

-- ----------------------------
-- Table structure for service_info
-- ----------------------------
DROP TABLE IF EXISTS `service_info`;
CREATE TABLE `service_info` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `service_code` int NOT NULL COMMENT '服务编码',
  `service_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '服务名称',
  `app_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '小程序appId',
  `path` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '页面路径',
  `sort_no` int DEFAULT NULL COMMENT '排序号',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='服务信息';

-- ----------------------------
-- Table structure for service_pack_info
-- ----------------------------
DROP TABLE IF EXISTS `service_pack_info`;
CREATE TABLE `service_pack_info` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `source` int NOT NULL COMMENT '来源 17:健管服务',
  `sp_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '第三方服务包id',
  `sp_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '第三方服务包名称',
  `sp_desc_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '服务包描述跳转路径',
  `date_type` tinyint DEFAULT NULL COMMENT '日期类型(1:天2:周3:月4:年)',
  `service_period` int DEFAULT NULL COMMENT '服务周期',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `service_days` int DEFAULT NULL COMMENT '服务天数',
  `plan_complete` int DEFAULT NULL COMMENT '静态路径完成适配小程序 1:是',
  `page_flag` tinyint DEFAULT NULL COMMENT '页面展示标志',
  `app_identify` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'slfw' COMMENT '标识符',
  `app_exhibit_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '服务包展示名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='服务包信息表';

-- ----------------------------
-- Table structure for subject_config
-- ----------------------------
DROP TABLE IF EXISTS `subject_config`;
CREATE TABLE `subject_config` (
  `id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `app_identify` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '标识符',
  `subject_title` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '标题',
  `subject_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '专题描述',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '图标地址',
  `jump_type` tinyint NOT NULL DEFAULT '0' COMMENT '跳转类型 0-无跳转 1-小程序(内部) 2-H5 3-文字弹窗 4-小程序(外部)',
  `app_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转小程序(外部)的AppId',
  `jump_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转路径 公众号文章地址或小程序路由',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(6) NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `app_jump_show_type` tinyint DEFAULT NULL COMMENT '跳转的小程序展示类型 1-全屏 2-半屏展示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='专题配置表';

-- ----------------------------
-- Table structure for t_h_dr_auto_confirm
-- ----------------------------
DROP TABLE IF EXISTS `t_h_dr_auto_confirm`;
CREATE TABLE `t_h_dr_auto_confirm` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `hosp_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '机构代码',
  `dr_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '医生代码',
  `confirm_type` tinyint NOT NULL COMMENT '确认类型 1:路径确认2:结案确认',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='医生设置自动确认表';

-- ----------------------------
-- Table structure for t_healthy_life
-- ----------------------------
DROP TABLE IF EXISTS `t_healthy_life`;
CREATE TABLE `t_healthy_life` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `inner_title` varchar(20) COLLATE utf8mb4_bin NOT NULL COMMENT '内部名称',
  `description` varchar(200) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '说明',
  `editor_id` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '编辑者id',
  `editor_name` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '编辑者名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已删除，1表示已删除，0表示未删除',
  PRIMARY KEY (`id`),
  KEY `idx_c_time` (`create_time`),
  KEY `idx_u_time` (`update_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for t_healthy_life_content
-- ----------------------------
DROP TABLE IF EXISTS `t_healthy_life_content`;
CREATE TABLE `t_healthy_life_content` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `content_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '内容id',
  `title` varchar(200) COLLATE utf8mb4_bin NOT NULL COMMENT '内容名称',
  `read_time` int unsigned NOT NULL DEFAULT '0' COMMENT '阅读量',
  `order` int unsigned NOT NULL DEFAULT '0' COMMENT '顺序',
  `healthy_life_module_id` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '从属于哪个模块',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已删除，1表示已删除，0表示未删除',
  `image_url` varchar(200) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '封面地址',
  `course_count` int NOT NULL DEFAULT '0' COMMENT '课程有几节课',
  `preview_url` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '预览地址',
  `read_init_time` int NOT NULL DEFAULT '0' COMMENT '初始阅读量',
  PRIMARY KEY (`id`),
  KEY `idx_c_time` (`create_time`),
  KEY `idx_u_time` (`update_time`),
  KEY `idx_module_id` (`healthy_life_module_id`,`order`),
  KEY `idx_c_id` (`content_id`,`is_delete`,`read_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for t_healthy_life_module
-- ----------------------------
DROP TABLE IF EXISTS `t_healthy_life_module`;
CREATE TABLE `t_healthy_life_module` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `title` varchar(6) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '模块名称，最多6字符',
  `description` varchar(200) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '说明',
  `type` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '模块类型',
  `order` int unsigned NOT NULL DEFAULT '0' COMMENT '模块类型',
  `healthy_life_id` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '从属于哪个健康生活页面',
  `editor_id` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '编辑者id',
  `editor_name` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '编辑者名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已删除，1表示已删除，0表示未删除',
  `icon_url` varchar(128) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '图标地址',
  PRIMARY KEY (`id`),
  KEY `idx_c_time` (`create_time`),
  KEY `idx_u_time` (`update_time`),
  KEY `idx_healthy_life_id` (`healthy_life_id`,`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for t_informed_task_config
-- ----------------------------
DROP TABLE IF EXISTS `t_informed_task_config`;
CREATE TABLE `t_informed_task_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '机构代码',
  `hosp_name` varchar(150) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构名称',
  `dept_code` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '科室名称',
  `in_hosp_day` int DEFAULT NULL COMMENT '入院几天',
  `is_pay` tinyint(1) DEFAULT NULL COMMENT '是否开单 0否 1是',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除 0.未删除 1.已删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='企微知情同意书签署任务配置表';

-- ----------------------------
-- Table structure for t_psy_clinic_room_schedule
-- ----------------------------
DROP TABLE IF EXISTS `t_psy_clinic_room_schedule`;
CREATE TABLE `t_psy_clinic_room_schedule` (
  `id` bigint NOT NULL COMMENT '诊室排班id',
  `date` date NOT NULL COMMENT '排班日期',
  `start_time` datetime NOT NULL COMMENT '排班开始时间',
  `end_time` datetime NOT NULL COMMENT '排班结束时间',
  `time_interval` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时间区间',
  `capacity` int NOT NULL COMMENT '诊室容量',
  `repeat_type` tinyint(1) NOT NULL COMMENT '重复类型（0不重复 1每天重复 2每周重复）',
  `deadline` date DEFAULT NULL COMMENT '重复截止日期，为空不截止',
  `service_method` tinyint(1) NOT NULL DEFAULT '2' COMMENT '履约方式（1线上 2线下 3全部）',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_date` (`date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='诊室排班表';

-- ----------------------------
-- Table structure for t_psy_consult_task
-- ----------------------------
DROP TABLE IF EXISTS `t_psy_consult_task`;
CREATE TABLE `t_psy_consult_task` (
  `id` bigint NOT NULL COMMENT '任务id',
  `order_no` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `hug_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '患者id',
  `pat_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '患者姓名',
  `age` tinyint NOT NULL COMMENT '年龄',
  `sex` tinyint NOT NULL COMMENT '性别（1男 2女）',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号',
  `contact_phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系人手机号',
  `service_item` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务项目',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `task_completion_time` datetime DEFAULT NULL COMMENT '任务完成时间',
  `status` tinyint NOT NULL COMMENT '任务状态（1待完成 2已完成 3已取消）',
  `counselor_id` bigint NOT NULL COMMENT '咨询师id',
  `counselor_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '咨询师姓名',
  `informed_consent_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '知情同意书地址',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `date` date DEFAULT NULL COMMENT '预约日期',
  `start_time` datetime DEFAULT NULL COMMENT '预约开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '预约结束时间',
  `service_method` tinyint(1) DEFAULT NULL COMMENT '咨询方式（1线上 2线下 3全部）',
  `schedule_id` bigint DEFAULT NULL COMMENT '排班id',
  `change_status` tinyint DEFAULT '0' COMMENT '修改状态（0未修改 1已修改）',
  `clinic_room_schedule_id` bigint DEFAULT NULL COMMENT '诊室排班id',
  `psychological_channel` tinyint(1) DEFAULT NULL COMMENT '心理渠道 1、杭州市第七人民医院 2、杭州星潼潜能教育科技有限公司 3、杭州琅悦月子会所（杭州旗舰店） 4、杭州健海',
  PRIMARY KEY (`id`),
  KEY `idx_name` (`pat_name`) USING BTREE,
  KEY `idx_phone` (`phone`) USING BTREE,
  KEY `idx_counselor_id` (`counselor_id`) USING BTREE,
  KEY `idx_contact_phone` (`contact_phone`) USING BTREE,
  KEY `idx_order_no` (`order_no`) USING BTREE,
  KEY `idx_schedule_id` (`schedule_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='心理-咨询任务表';

-- ----------------------------
-- Table structure for t_psy_consult_task_record
-- ----------------------------
DROP TABLE IF EXISTS `t_psy_consult_task_record`;
CREATE TABLE `t_psy_consult_task_record` (
  `id` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `task_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `channel_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `app_key` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `app_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `token` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `client_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `download_url` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `template_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `layout_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `record_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `talk_length` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for t_psy_counselor
-- ----------------------------
DROP TABLE IF EXISTS `t_psy_counselor`;
CREATE TABLE `t_psy_counselor` (
  `id` bigint NOT NULL COMMENT '咨询师id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '姓名',
  `sex` tinyint NOT NULL COMMENT '性别（1男 2女）',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号',
  `pic` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '照片',
  `working_years` tinyint NOT NULL COMMENT '从业时间（年）',
  `consultation_experience` int NOT NULL COMMENT '咨询经验（小时）',
  `service_category` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务分类',
  `service_method` tinyint NOT NULL COMMENT '履约方式（1线上 2线下 3全部）',
  `specification_price` int NOT NULL COMMENT '服务规格-价格',
  `specification_time` int NOT NULL COMMENT '服务规格-时长',
  `intro` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '个人介绍',
  `experience` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '受训经历',
  `qualification` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '专业资质',
  `skilled_fields` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '擅长领域',
  `style` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '咨询风格',
  `sign` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '电子签名',
  `status` tinyint NOT NULL COMMENT '状态（0停用 1启用）',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `qualifications_flag` int DEFAULT NULL COMMENT '是否有院内资质（0否 1是）',
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`) USING BTREE,
  KEY `idx_phone` (`phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='心理-咨询师';

-- ----------------------------
-- Table structure for t_psy_counselor_schedule
-- ----------------------------
DROP TABLE IF EXISTS `t_psy_counselor_schedule`;
CREATE TABLE `t_psy_counselor_schedule` (
  `id` bigint NOT NULL COMMENT '排班id',
  `counselor_id` bigint NOT NULL COMMENT '咨询师id',
  `date` date NOT NULL COMMENT '排班日期',
  `start_time` datetime NOT NULL COMMENT '排班开始时间',
  `end_time` datetime NOT NULL COMMENT '排班结束时间',
  `time_interval` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时间区间',
  `repeat_type` tinyint(1) NOT NULL COMMENT '重复类型（0不重复 1每天重复 2每周重复）',
  `deadline` date DEFAULT NULL COMMENT '重复截止日期，为空不截止',
  `service_method` tinyint(1) NOT NULL COMMENT '履约方式（1线上 2线下 3全部）',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_counselor_id` (`counselor_id`) USING BTREE,
  KEY `idx_date` (`date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='咨询师排班表';

-- ----------------------------
-- Table structure for task_diet
-- ----------------------------
DROP TABLE IF EXISTS `task_diet`;
CREATE TABLE `task_diet` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `task_date` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '任务日期 yyyy-MM-dd',
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '蓝牛号',
  `third_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '第三方唯一号',
  `source_type` int NOT NULL COMMENT '来源 1妊娠',
  `need_number` int DEFAULT '0' COMMENT '需要餐次(饮食次数)',
  `complete_number` int DEFAULT NULL COMMENT '完成餐次',
  `need_calories` decimal(8,2) DEFAULT NULL COMMENT '需要卡路里',
  `complete_calories` decimal(8,2) DEFAULT NULL COMMENT '完成卡路里',
  `complete_time` datetime DEFAULT NULL COMMENT '任务完成时间',
  `diet_time` datetime DEFAULT NULL COMMENT '最近一次饮食时间',
  `normal_flag` int DEFAULT NULL COMMENT '正常标识 1正常 2不正常',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `complete_flag` int DEFAULT '2' COMMENT '完成标志 1完成 2未完成',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='饮食任务';

-- ----------------------------
-- Table structure for task_monitor
-- ----------------------------
DROP TABLE IF EXISTS `task_monitor`;
CREATE TABLE `task_monitor` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `task_date` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '任务日期 yyyy-MM-dd',
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '蓝牛号',
  `third_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '第三方唯一号',
  `source_type` int NOT NULL COMMENT '来源 1妊娠',
  `need_number` int DEFAULT '0' COMMENT '需要次数',
  `complete_number` int DEFAULT NULL COMMENT '完成次数',
  `monitor_type` int NOT NULL COMMENT '监测类型 1体重 2血糖 3血压 4胰岛素 5胎动 6症状',
  `monitor_value` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `monitor_unit` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '监测单位',
  `measure_time` datetime DEFAULT NULL COMMENT '测量时间',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `normal_flag` int DEFAULT NULL COMMENT '正常标识 1正常 2不正常',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `complete_flag` int DEFAULT '2' COMMENT '完成标志 1完成 2未完成',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='监测任务';

-- ----------------------------
-- Table structure for task_record
-- ----------------------------
DROP TABLE IF EXISTS `task_record`;
CREATE TABLE `task_record` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '主键',
  `task_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '提醒任务第三方id,宣教/随访任务id',
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '蓝牛号',
  `task_error_type` int DEFAULT NULL COMMENT '任务失败类型1.上传提醒任务 2.表单宣教任务3.表单宣教-微信模板消息推送4.上传表单宣教-短信推送5.提醒-微信模板消息推送6.提醒-短信推送'',',
  `error_msg` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `req_param` varchar(14096) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '请求参数',
  `state` tinyint(1) DEFAULT NULL COMMENT '任务状态 0-成功 1-失败',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='任务记录表';

-- ----------------------------
-- Table structure for task_sport
-- ----------------------------
DROP TABLE IF EXISTS `task_sport`;
CREATE TABLE `task_sport` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '蓝牛号',
  `third_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '第三方唯一号',
  `source_type` int NOT NULL COMMENT '来源 1妊娠',
  `begin_date` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '开始日期',
  `end_date` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '结束日期',
  `need_number` int DEFAULT '0' COMMENT '需要运动次数',
  `complete_number` int DEFAULT NULL COMMENT '完成运动次数',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `sport_time` datetime DEFAULT NULL COMMENT '最近一次运动时间',
  `normal_flag` int DEFAULT NULL COMMENT '正常标识 1正常 2不正常',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `complete_flag` int DEFAULT '2' COMMENT '完成标志 1完成 2未完成',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='运动任务';

-- ----------------------------
-- Table structure for tool_box_config
-- ----------------------------
DROP TABLE IF EXISTS `tool_box_config`;
CREATE TABLE `tool_box_config` (
  `id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `app_identify` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '标识符',
  `title` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '标题',
  `image_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '图标地址',
  `jump_type` tinyint NOT NULL DEFAULT '0' COMMENT '跳转类型 0-无跳转 1-小程序(内部) 2-H5 3-文字弹窗 4-小程序(外部)',
  `app_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转小程序(外部)的AppId',
  `jump_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转路径 公众号文章地址或小程序路由',
  `sort_no` int NOT NULL COMMENT '排序 由小到大',
  `page_id` tinyint NOT NULL DEFAULT '1' COMMENT '所在页面 展示页面 1-首页 2-个人中心',
  `state` tinyint NOT NULL DEFAULT '1' COMMENT '状态 0-未启用 1-已启用',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人',
  `create_time` datetime(6) NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='工具配置表';

-- ----------------------------
-- Table structure for user_article_collect
-- ----------------------------
DROP TABLE IF EXISTS `user_article_collect`;
CREATE TABLE `user_article_collect` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号',
  `resource_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '资源id',
  `type` tinyint NOT NULL COMMENT '1：智宣教随访消息 2：运营宣教',
  `jump_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转路径 type为1时保存',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `title` varchar(200) COLLATE utf8mb4_bin DEFAULT '' COMMENT '宣教标题',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户文章收藏表';

-- ----------------------------
-- Table structure for user_article_collect_1
-- ----------------------------
DROP TABLE IF EXISTS `user_article_collect_1`;
CREATE TABLE `user_article_collect_1` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号',
  `resource_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '资源id',
  `type` tinyint NOT NULL COMMENT '1：智宣教随访消息 2：运营宣教',
  `jump_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '跳转路径 type为1时保存',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户文章收藏表';

-- ----------------------------
-- Table structure for user_feedback_record
-- ----------------------------
DROP TABLE IF EXISTS `user_feedback_record`;
CREATE TABLE `user_feedback_record` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '数据中心患者id',
  `hosp_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '健管云患者id',
  `app_identify` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '标识符',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '手机号',
  `source` int DEFAULT NULL COMMENT '来源 17:健管服务',
  `user_source_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'user_source表主键id',
  `contact_mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '联系电话',
  `feedback_type` tinyint DEFAULT NULL COMMENT '用户反馈类型 1:病情反馈 2:表扬 3:投诉',
  `context` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户反馈内容',
  `desc_imgs` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `state` tinyint(1) DEFAULT '0' COMMENT '状态 0:待处理 1:已解决2:无法解决',
  `reply_type` tinyint DEFAULT NULL COMMENT '回复类型 0:文本',
  `reply_content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `reply_time` datetime DEFAULT NULL COMMENT '回复时间',
  `is_read` tinyint(1) DEFAULT NULL COMMENT '回复内容是否已读 0:未读 1:已读',
  `solved` tinyint(1) DEFAULT NULL COMMENT '是否解决问题 0:未解决 1.已解决',
  `edit_time` datetime DEFAULT NULL COMMENT '用户编辑时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `hug_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛id',
  `primary_feedback_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '父问题id',
  `goods_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '商品id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='反馈记录表';

-- ----------------------------
-- Table structure for user_feedback_reply
-- ----------------------------
DROP TABLE IF EXISTS `user_feedback_reply`;
CREATE TABLE `user_feedback_reply` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `feedback_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `reply_type` tinyint DEFAULT NULL COMMENT '回复类型 0:文本',
  `reply_content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '回复内容',
  `reply_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='咨询回复表';

-- ----------------------------
-- Table structure for user_original_info
-- ----------------------------
DROP TABLE IF EXISTS `user_original_info`;
CREATE TABLE `user_original_info` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `source` int NOT NULL COMMENT '来源 17:健管服务 18:云南昭通惠民保',
  `pat_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '第三方患者id',
  `pat_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '患者姓名',
  `birthday` date DEFAULT NULL COMMENT '出生日期',
  `sex` tinyint DEFAULT NULL COMMENT '性别 1：男，2：女',
  `relation` int DEFAULT NULL COMMENT '关系 1本人 2配偶 3父亲 4母亲 5儿子 6女儿 7朋友 8其他',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '手机号',
  `id_card` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '身份证',
  `age` int DEFAULT NULL COMMENT '年龄',
  `disease_variety` tinyint DEFAULT NULL COMMENT '疾病种类枚举 1:乳腺癌 2:前列腺癌3:肝癌4:淋巴癌5:少儿白血病6:卵巢癌7:肺癌8:胃癌9:结肠癌10:甲状腺癌',
  `is_surgery` tinyint(1) DEFAULT NULL COMMENT '是否手术',
  `operation_time` tinyint DEFAULT NULL COMMENT '手术时间(1:一周内，2:一月内，3:三个月内，4:六个月内，5:一年内，6:一年以上)',
  `fill_in_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '填写时间',
  `hosp_record` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '入院记录',
  `discharge_summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '出院小结',
  `inspection_report` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '检查报告',
  `added_material` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '补充材料',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户信息表(首次记录)';

-- ----------------------------
-- Table structure for user_patient
-- ----------------------------
DROP TABLE IF EXISTS `user_patient`;
CREATE TABLE `user_patient` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pat_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '患者姓名',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '手机号',
  `hug_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号',
  `relation` int DEFAULT NULL COMMENT '关系 1子女 2父母 3本人 4爱人 5亲戚 6朋友',
  `mission_reminder` tinyint(1) DEFAULT '1' COMMENT '宣教提醒 0关闭 1开启',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='患者信息';

-- ----------------------------
-- Table structure for user_phone
-- ----------------------------
DROP TABLE IF EXISTS `user_phone`;
CREATE TABLE `user_phone` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '手机号',
  `hug_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户绑定手机号';

-- ----------------------------
-- Table structure for user_source
-- ----------------------------
DROP TABLE IF EXISTS `user_source`;
CREATE TABLE `user_source` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hug_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '蓝牛号',
  `hosp_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '医院编码',
  `source` int NOT NULL COMMENT '来源 17:健管服务',
  `pat_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '第三方患者id',
  `pat_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '患者姓名',
  `pat_type` tinyint DEFAULT NULL COMMENT '患者类型 1-服务开单 2-妊娠病程开单 3-减重 4-SOP开单 5-保险开单 6-咏柳开单',
  `birthday` date DEFAULT NULL COMMENT '出生日期',
  `sex` tinyint DEFAULT NULL COMMENT '性别 1：男，2：女',
  `relation` int DEFAULT NULL COMMENT '关系 1子女 2父母 3本人 4爱人 5亲戚 6朋友',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '手机号',
  `id_card` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '身份证',
  `age` int DEFAULT NULL COMMENT '年龄',
  `disease_variety` tinyint DEFAULT NULL COMMENT '疾病种类枚举 1:乳腺癌 2:前列腺癌3:肝癌4:淋巴癌5:少儿白血病6:卵巢癌7:肺癌8:胃癌9:结肠癌10:甲状腺癌',
  `is_surgery` tinyint(1) DEFAULT NULL COMMENT '是否手术',
  `operation_time` tinyint DEFAULT NULL COMMENT '手术时间(1:一周内，2:一月内，3:三个月内，4:六个月内，5:一年内，6:一年以上)',
  `fill_in_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '填写时间',
  `hosp_record` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '入院记录',
  `discharge_summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '出院小结',
  `inspection_report` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '检查报告',
  `added_material` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '补充材料',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户来源表';

-- ----------------------------
-- Table structure for user_sp_rel
-- ----------------------------
DROP TABLE IF EXISTS `user_sp_rel`;
CREATE TABLE `user_sp_rel` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_source_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `spi_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `pay_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '第三方服务包开单id',
  `baseline_time` datetime DEFAULT NULL COMMENT '基线时间(手术/出单/出院时间)',
  `entered_welcome_page` tinyint(1) DEFAULT '0' COMMENT '是否进入过欢迎页 0:未进入过 1:进入过',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `baseline_type` int DEFAULT NULL COMMENT '基线类型 1手术时间',
  `date_type` tinyint DEFAULT NULL COMMENT '日期类型(1:天2:周3:月4:年)',
  `service_period` int DEFAULT NULL COMMENT '服务周期',
  `service_days` int DEFAULT NULL COMMENT '服务天数',
  `status_flag` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '单子状态 1、全部 2、服务中 3、方案待制定 4、待宣讲 5、正常结案 6、中途退出 7 中途退费 8：未服务退费 9取消开单',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='用户服务包关联表';

-- ----------------------------
-- Table structure for xinyong_user
-- ----------------------------
DROP TABLE IF EXISTS `xinyong_user`;
CREATE TABLE `xinyong_user` (
  `id` char(32) COLLATE utf8mb4_bin NOT NULL,
  `pat_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT 'patId',
  `watch_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '手表设备id',
  `status` int NOT NULL COMMENT '状态 1-待标定 2-已标定 3-已绑定 4-已解绑',
  `xinyong_binding_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '心永bindingId',
  `banding_time` datetime(6) DEFAULT NULL COMMENT '绑定时间',
  `unbind_time` datetime(6) DEFAULT NULL COMMENT '解绑时间',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_time` datetime(6) NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='心永手表用户记录表';

SET FOREIGN_KEY_CHECKS = 1;
