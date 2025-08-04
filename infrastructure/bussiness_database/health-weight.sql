/*
 Navicat MySQL Data Transfer

 Source Server         : 192.168.3.31
 Source Server Type    : MySQL
 Source Server Version : 50650
 Source Host           : 192.168.3.31:3306
 Source Schema         : health-weight

 Target Server Type    : MySQL
 Target Server Version : 50650
 File Encoding         : 65001

 Date: 17/07/2025 09:59:48
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
-- Table structure for comment_config
-- ----------------------------
DROP TABLE IF EXISTS `comment_config`;
CREATE TABLE `comment_config` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `disease_type` tinyint(3) NOT NULL COMMENT '疾病类别：1减重 2妊糖',
  `disease_name` varchar(255) NOT NULL DEFAULT '' COMMENT '疾病名称',
  `meal` tinyint(1) DEFAULT NULL COMMENT '餐次：0早餐 1早加餐 2午餐 3午加餐 4晚餐 5晚加餐 6加餐',
  `food_category` tinyint(2) DEFAULT NULL COMMENT '食材类型：2蔬菜类 3水果类 5奶类 7坚果类 8油脂类 9其他 11蛋类 13谷薯类 14豆类（豆奶豆浆等）15畜禽肉、水产、豆类',
  `food_category_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '食材名称',
  `food_order` tinyint(2) DEFAULT NULL COMMENT '食材排序',
  `recommend` int(5) DEFAULT '0' COMMENT '推荐量(单位g)：0不推荐',
  `recommend_min` int(5) DEFAULT NULL COMMENT '推荐量最小值',
  `recommend_max` int(5) DEFAULT NULL COMMENT '推荐量最大值',
  `type` tinyint(2) DEFAULT '1' COMMENT '点评类型：1饮食',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '修改人名称',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_dm` (`disease_type`,`meal`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点评配置(排序及推荐)表';

-- ----------------------------
-- Table structure for comment_msg
-- ----------------------------
DROP TABLE IF EXISTS `comment_msg`;
CREATE TABLE `comment_msg` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `comment_rule_id` varchar(32) NOT NULL COMMENT 'comment_rule表id',
  `msg_type` tinyint(2) DEFAULT NULL COMMENT '描述语类型：1现象描述语 2理由描述语 3做法推荐描述语 4鼓励语',
  `msg` varchar(500) DEFAULT '' COMMENT '描述语',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '修改人名称',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '现象规则',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点评描述语表';

-- ----------------------------
-- Table structure for comment_rule
-- ----------------------------
DROP TABLE IF EXISTS `comment_rule`;
CREATE TABLE `comment_rule` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `disease_type` varchar(32) NOT NULL COMMENT '适用疾病类别：减重(JZ)，pcos(PCOS)，妊糖(RT)',
  `disease_name` varchar(255) NOT NULL DEFAULT '' COMMENT '适用疾病名称',
  `meal` varchar(10) DEFAULT NULL COMMENT '餐次：0早餐 1早加餐 2午餐 3午加餐 4晚餐 5晚加餐 6加餐',
  `food_category` tinyint(2) DEFAULT NULL COMMENT '食材类型：2蔬菜类 3水果类 5奶类 7坚果类 8油脂类 9其他 11蛋类 13谷薯类 14豆类（豆奶豆浆等）15畜禽肉、水产、豆类',
  `food_category_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '食材名称',
  `rule` varchar(100) NOT NULL COMMENT '现象规则',
  `result` tinyint(1) DEFAULT '0' COMMENT '结果：0正常 1偏低 2偏高',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '修改人名称',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '现象规则',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_dm` (`disease_type`,`meal`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点评规则表';

-- ----------------------------
-- Table structure for pat_diet_personalized_advice
-- ----------------------------
DROP TABLE IF EXISTS `pat_diet_personalized_advice`;
CREATE TABLE `pat_diet_personalized_advice` (
  `id` bigint(20) NOT NULL,
  `diet_template_id` varchar(36) NOT NULL COMMENT '饮食结构模板id',
  `advice_id` varchar(36) NOT NULL COMMENT '管理建议id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `edu_url` varchar(512) DEFAULT NULL COMMENT '建议文章url',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='个性化饮食建议';

-- ----------------------------
-- Table structure for pat_diet_personalized_meal
-- ----------------------------
DROP TABLE IF EXISTS `pat_diet_personalized_meal`;
CREATE TABLE `pat_diet_personalized_meal` (
  `id` bigint(20) NOT NULL,
  `plan_id` bigint(20) NOT NULL COMMENT '患者个性化饮食方案id',
  `diet_date` date NOT NULL COMMENT '日期',
  `meal` int(11) NOT NULL COMMENT '餐次',
  `dish_id` varchar(32) NOT NULL COMMENT '菜肴id',
  `dish_name` varchar(32) NOT NULL COMMENT '菜肴名称',
  `category_id` varchar(32) NOT NULL COMMENT '菜肴分类id',
  `category_name` varchar(32) NOT NULL COMMENT '菜肴分类名称',
  `amount` decimal(8,2) DEFAULT NULL,
  `unit_name` varchar(3) NOT NULL COMMENT '数量名称',
  `template_gram` decimal(8,2) NOT NULL COMMENT '模板克',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `pic_url` varchar(256) DEFAULT NULL COMMENT '菜肴图片',
  `recipe_benefits` varchar(32) DEFAULT NULL COMMENT '食谱功效',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for pat_diet_personalized_plan
-- ----------------------------
DROP TABLE IF EXISTS `pat_diet_personalized_plan`;
CREATE TABLE `pat_diet_personalized_plan` (
  `id` bigint(20) NOT NULL,
  `pay_id` varchar(36) NOT NULL COMMENT '开单id',
  `empi_id` varchar(36) DEFAULT NULL COMMENT '患者id',
  `diet_template_id` varchar(36) NOT NULL COMMENT '饮食结构模板id',
  `label` varchar(36) DEFAULT NULL COMMENT '标签',
  `calorie` decimal(8,2) NOT NULL COMMENT '能量',
  `grease_gram` decimal(8,2) NOT NULL COMMENT '油脂克数',
  `diet_template_json` text COMMENT '饮食模板内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `begin_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NOT NULL COMMENT '结束日期',
  `state` int(11) DEFAULT '2' COMMENT '状态 1已过期 2预览 3使用中',
  `pat_id` varchar(128) DEFAULT NULL COMMENT '数据中心id',
  `reference_recipe` bit(1) DEFAULT b'0' COMMENT '是否参考食谱',
  PRIMARY KEY (`id`),
  KEY `idx_pay_id` (`pay_id`),
  KEY `idx_pat_id` (`pat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_body_temp_record
-- ----------------------------
DROP TABLE IF EXISTS `t_body_temp_record`;
CREATE TABLE `t_body_temp_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '患者id-数据中心',
  `body_temp_value` decimal(3,1) NOT NULL COMMENT '体温测量值',
  `measure_time` datetime NOT NULL COMMENT '测量时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `creator_id` varchar(32) DEFAULT '' COMMENT '创建人id',
  `creator_name` varchar(32) DEFAULT '' COMMENT '创建人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者体温记录表';

-- ----------------------------
-- Table structure for t_competition_diet_record
-- ----------------------------
DROP TABLE IF EXISTS `t_competition_diet_record`;
CREATE TABLE `t_competition_diet_record` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `execution_date` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '发生日期',
  `hug_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '蓝牛号',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者id-数据中心',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `pic_url` varchar(500) CHARACTER SET utf8 DEFAULT NULL COMMENT '饮食照片',
  `meal` tinyint(2) NOT NULL COMMENT '餐次',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `ai_review_content` varchar(1024) DEFAULT '' COMMENT 'ai点评',
  `text_desc` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '饮食文字描述',
  `ai_message_id` varchar(100) CHARACTER SET utf8 DEFAULT '' COMMENT 'ai消息id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='减重大赛用户饮食记录表';

-- ----------------------------
-- Table structure for t_competition_pat_sport_record
-- ----------------------------
DROP TABLE IF EXISTS `t_competition_pat_sport_record`;
CREATE TABLE `t_competition_pat_sport_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id-数据中心',
  `execution_date` varchar(20) NOT NULL COMMENT '发生时间',
  `hug_id` varchar(32) NOT NULL COMMENT '蓝牛号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者运动记录';

-- ----------------------------
-- Table structure for t_competition_sport_record_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_competition_sport_record_detail`;
CREATE TABLE `t_competition_sport_record_detail` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id-数据中心',
  `hug_id` varchar(32) NOT NULL COMMENT '患者在医院的唯一id',
  `execution_date` varchar(20) NOT NULL COMMENT '发生时间',
  `sport_id` varchar(50) NOT NULL DEFAULT '-1' COMMENT '发生时间',
  `sport_name` varchar(100) NOT NULL DEFAULT '' COMMENT '发生时间',
  `burn_calories` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '消耗卡路里',
  `sport_time` int(4) NOT NULL DEFAULT '0' COMMENT '运动时间',
  `record_id` varchar(32) NOT NULL COMMENT '运动记录id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `calories_unit` decimal(8,3) NOT NULL DEFAULT '0.000' COMMENT '消耗卡路里单位',
  PRIMARY KEY (`id`),
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE,
  KEY `idx_recordId` (`record_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='大赛运动记录详情';

-- ----------------------------
-- Table structure for t_competition_sport_statistics
-- ----------------------------
DROP TABLE IF EXISTS `t_competition_sport_statistics`;
CREATE TABLE `t_competition_sport_statistics` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `hug_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '运动时间',
  `execution_date` varchar(16) NOT NULL COMMENT '执行日期',
  `wechat_step` int(6) NOT NULL DEFAULT '0' COMMENT '微信步数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='减重大赛每日运动情况统计';

-- ----------------------------
-- Table structure for t_config
-- ----------------------------
DROP TABLE IF EXISTS `t_config`;
CREATE TABLE `t_config` (
  `id` varchar(32) NOT NULL COMMENT '配置id',
  `module_code` varchar(32) NOT NULL COMMENT '配置模块code',
  `module_name` varchar(32) NOT NULL COMMENT '配置模块code',
  `config_type_code` varchar(32) NOT NULL COMMENT '配置类型code',
  `config_type_name` varchar(32) NOT NULL COMMENT '配置类型名称',
  `content` text NOT NULL COMMENT '配置内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ctc` (`config_type_code`) USING BTREE,
  KEY `idx_mc` (`module_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公共配置表';

-- ----------------------------
-- Table structure for t_customize_sugar_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_customize_sugar_plan`;
CREATE TABLE `t_customize_sugar_plan` (
  `id` varchar(32) NOT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建人',
  `update_id` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `cycle_plan` tinyint(1) NOT NULL DEFAULT '0' COMMENT '循环方案 0 否 1是',
  `after_meal_one_hour` tinyint(1) DEFAULT '0' COMMENT '餐后1小时，0：未选择，1：已选择',
  `after_meal_two_hour` tinyint(1) DEFAULT '0' COMMENT '餐后2小时，0：未选择，1：已选择',
  `plan_day_qty` tinyint(3) NOT NULL COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='自定义血糖计划';

-- ----------------------------
-- Table structure for t_customize_sugar_plan_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_customize_sugar_plan_detail`;
CREATE TABLE `t_customize_sugar_plan_detail` (
  `id` varchar(32) NOT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建人',
  `update_id` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `plan_id` varchar(32) NOT NULL COMMENT '自定义方案id',
  `plan_day` tinyint(3) NOT NULL COMMENT '方案天数',
  `plan_points` varchar(50) NOT NULL COMMENT '血糖点位',
  PRIMARY KEY (`id`),
  KEY `idx_plan_day_point` (`plan_id`,`plan_day`,`plan_points`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='自定义血糖计划详情';

-- ----------------------------
-- Table structure for t_diet_personalized_plan_send
-- ----------------------------
DROP TABLE IF EXISTS `t_diet_personalized_plan_send`;
CREATE TABLE `t_diet_personalized_plan_send` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '健管云患者id',
  `diet_plan_id` varchar(32) NOT NULL COMMENT 'PatDietPersonalizedPlan表id',
  `send_type` tinyint(4) DEFAULT NULL COMMENT '发送类型 1-短信',
  `send_date` date DEFAULT NULL COMMENT '发送日期',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_error_sugar_record
-- ----------------------------
DROP TABLE IF EXISTS `t_error_sugar_record`;
CREATE TABLE `t_error_sugar_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `execution_date` varchar(32) DEFAULT NULL COMMENT '发生时间',
  `measure_point` tinyint(1) NOT NULL COMMENT '监测点',
  `sugar_value` decimal(8,2) NOT NULL,
  `deal_by` varchar(32) DEFAULT NULL COMMENT '处理人',
  `deal_name` varchar(32) DEFAULT NULL COMMENT '处理人',
  `deal_time` datetime DEFAULT NULL COMMENT '处理时间',
  `deal_suggestion` varchar(2048) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '处理意见',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `deal_status` tinyint(1) NOT NULL COMMENT '处理状态 0未处理 1已处理',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '处理人',
  `sex_code` tinyint(1) NOT NULL COMMENT '性别 1男 2女',
  `team_id` varchar(32) NOT NULL COMMENT '分组id',
  `team_name` varchar(32) NOT NULL COMMENT '分组名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='服务管理记录';

-- ----------------------------
-- Table structure for t_food_review_record
-- ----------------------------
DROP TABLE IF EXISTS `t_food_review_record`;
CREATE TABLE `t_food_review_record` (
  `id` varchar(32) NOT NULL,
  `pat_diet_record_id` varchar(40) NOT NULL COMMENT '用户饮食记录表id',
  `comment_type` tinyint(4) NOT NULL COMMENT '类别 1-点赞 0-不推荐',
  `food_id` varchar(40) NOT NULL COMMENT '食材id',
  `food_name` varchar(40) NOT NULL COMMENT '食材名称',
  `reason` varchar(500) DEFAULT NULL COMMENT '理由',
  `create_by` varchar(20) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='食材点评记录表(点赞/不推荐)';

-- ----------------------------
-- Table structure for t_h_monthly_record
-- ----------------------------
DROP TABLE IF EXISTS `t_h_monthly_record`;
CREATE TABLE `t_h_monthly_record` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) NOT NULL COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `generate_date` date NOT NULL COMMENT '月报生成日期',
  `monthly_json` text CHARACTER SET utf8 NOT NULL COMMENT '月报json',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id-数据中心',
  `send_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '发送状态 0未发送  1已发送 -1 发送失败',
  `monthly_generate_times` int(10) unsigned NOT NULL COMMENT '月报生成次数',
  `pat_read_status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '患者已读',
  `empi_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '定单id',
  `send_count` int(5) NOT NULL DEFAULT '0' COMMENT '发送次数',
  `update_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '修改状态  0未修改  1已修改',
  `record_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '类型 1系统  2手动',
  `editor_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '编辑人id',
  `editor_name` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '编辑人姓名',
  `send_time` varchar(32) NOT NULL DEFAULT '' COMMENT '发送时间',
  `content_type` tinyint(4) DEFAULT '1' COMMENT '内容类型 1月报  2结案小结',
  `close_summary_type` tinyint(4) DEFAULT NULL COMMENT '结案小结类型 1：标准版 2：手动版  (contentType=2时必填',
  `close_summary_tpl_id` varchar(40) DEFAULT NULL COMMENT '结案小结模板id',
  PRIMARY KEY (`id`),
  KEY `idx` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='月报记录表';

-- ----------------------------
-- Table structure for t_h_monthly_record_addr
-- ----------------------------
DROP TABLE IF EXISTS `t_h_monthly_record_addr`;
CREATE TABLE `t_h_monthly_record_addr` (
  `record_id` varchar(32) NOT NULL COMMENT 't_h_monthly_record.id',
  `html_oss_key` varchar(500) NOT NULL COMMENT 'html页面OSS地址',
  `image_oss_key` varchar(500) NOT NULL COMMENT 'html转图片OSS地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`record_id`),
  KEY `idx_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_monitor_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_monitor_plan`;
CREATE TABLE `t_monitor_plan` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `monitor_name` varchar(200) NOT NULL COMMENT '监测方案名称',
  `monitor_desc` varchar(1024) DEFAULT NULL COMMENT '监测方案描述',
  `sugar_frequency` tinyint(2) NOT NULL DEFAULT '0' COMMENT '血糖监测任务 0 否 1 选中默认方案',
  `weight_frequency` tinyint(2) NOT NULL DEFAULT '0' COMMENT '体重监测频次 0 否',
  `create_id` varchar(32) NOT NULL COMMENT '创建时间',
  `update_id` varchar(32) NOT NULL COMMENT '修改时间',
  `create_name` varchar(32) NOT NULL COMMENT '创建时间',
  `update_name` varchar(32) NOT NULL COMMENT '修改时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者-监测身高';

-- ----------------------------
-- Table structure for t_nut_comparative
-- ----------------------------
DROP TABLE IF EXISTS `t_nut_comparative`;
CREATE TABLE `t_nut_comparative` (
  `id` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `first_nut_date` varchar(16) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '第一份日期',
  `first_nut_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '第一份日期',
  `second_nut_date` varchar(16) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '第二份日期',
  `second_nut_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '第二份日期',
  `patient_id` varchar(32) COLLATE utf8mb4_bin NOT NULL COMMENT '患者id',
  `target_weight` decimal(8,2) DEFAULT NULL COMMENT '目标体重',
  `weight_control` decimal(8,2) DEFAULT NULL COMMENT '体重控制',
  `fat_control` decimal(8,2) DEFAULT NULL COMMENT '脂肪控制',
  `muscle_control` decimal(8,2) DEFAULT NULL COMMENT '肌肉控制',
  `height_change` decimal(8,2) DEFAULT NULL COMMENT '身高变化',
  `weight_change` decimal(8,2) DEFAULT NULL COMMENT '体重变化',
  `inbody_change` decimal(8,2) DEFAULT NULL COMMENT 'inbody变化',
  `bmi_change` decimal(8,2) DEFAULT NULL COMMENT 'bmi变化',
  `neck_change` decimal(8,2) DEFAULT NULL COMMENT '劲围变化',
  `waist_change` decimal(8,2) DEFAULT NULL COMMENT '腰围变化',
  `hip_change` decimal(8,2) DEFAULT NULL COMMENT '臀围变化',
  `skeletal_muscle_change` decimal(8,2) DEFAULT NULL COMMENT '骨骼肌变化',
  `body_fat_change` decimal(8,2) DEFAULT NULL COMMENT '体脂肪变化',
  `waist_to_hip_ratio_change` decimal(8,2) DEFAULT NULL COMMENT '腰臀比变化',
  `body_fat_per_change` decimal(8,3) DEFAULT NULL COMMENT '体脂百分比变化',
  `basal_metabolic_rate_change` decimal(8,2) DEFAULT NULL COMMENT '基础代谢率变化',
  `visceral_fat_change` decimal(8,2) DEFAULT NULL COMMENT '内脏脂肪变化',
  `omron_visceral_fat_change` decimal(8,2) DEFAULT NULL COMMENT '欧姆龙内脏脂肪变化',
  `abdomen_subcutaneous_fat_change` decimal(8,2) DEFAULT NULL COMMENT '腹部皮下脂肪变化',
  `create_by` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '修改人名称',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPACT COMMENT='患者营养学科对比分析记录表';

-- ----------------------------
-- Table structure for t_ovulation_record
-- ----------------------------
DROP TABLE IF EXISTS `t_ovulation_record`;
CREATE TABLE `t_ovulation_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '患者id-数据中心',
  `is_ovulate` tinyint(1) NOT NULL COMMENT '检测结果 0:阴性 1：阳性',
  `measure_time` datetime NOT NULL COMMENT '测量时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `creator_id` varchar(32) DEFAULT '' COMMENT '创建人id',
  `creator_name` varchar(32) DEFAULT '' COMMENT '创建人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者排卵记录表';

-- ----------------------------
-- Table structure for t_pat_active_track
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_active_track`;
CREATE TABLE `t_pat_active_track` (
  `id` bigint(11) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `pat_name` varchar(30) DEFAULT NULL COMMENT '患者名称',
  `sex_code` tinyint(1) NOT NULL COMMENT '性别 1男 2女',
  `team_id` varchar(50) DEFAULT '' COMMENT '患者分组id',
  `team_name` varchar(50) DEFAULT '' COMMENT '患者分组',
  `group_id` varchar(32) DEFAULT '' COMMENT '团队id',
  `execution_date` varchar(30) NOT NULL COMMENT '执行日期',
  `track_msg` varchar(1024) NOT NULL COMMENT '追踪数据',
  `track_type` tinyint(3) NOT NULL COMMENT '追踪类型',
  `source_id` varchar(32) DEFAULT '' COMMENT '来源记录id',
  `unusual_level` tinyint(1) NOT NULL COMMENT '异常类型',
  `deal_status` tinyint(1) NOT NULL COMMENT '处理状态 0未处理 1已处理',
  `deal_handler` varchar(32) DEFAULT '' COMMENT '处理人',
  `deal_msg` varchar(1024) DEFAULT '' COMMENT '处理意见',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `mobile_no` varchar(20) DEFAULT '' COMMENT '手机号',
  `unusual_msg` varchar(50) DEFAULT '' COMMENT '异常描述',
  `hosp_code` varchar(50) NOT NULL DEFAULT '' COMMENT '医院编码',
  `manage_user_id` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员id',
  `manage_user_name` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员id',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者消息通知表';

-- ----------------------------
-- Table structure for t_pat_blood_pressure_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_blood_pressure_record`;
CREATE TABLE `t_pat_blood_pressure_record` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者id-数据中心',
  `measure_time` date NOT NULL COMMENT '记录时间',
  `systolic_pressure` int(3) NOT NULL COMMENT '收缩压',
  `diastolic_pressure` int(3) NOT NULL COMMENT '舒张压',
  `empi_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `creator_id` varchar(32) CHARACTER SET utf8 DEFAULT '' COMMENT '创建人id',
  `creator_name` varchar(32) CHARACTER SET utf8 DEFAULT '' COMMENT '创建人姓名',
  `update_id` varchar(32) CHARACTER SET utf8 DEFAULT '' COMMENT '编辑人id',
  `update_name` varchar(32) CHARACTER SET utf8 DEFAULT '' COMMENT '编辑人姓名',
  `time_division` datetime DEFAULT NULL COMMENT '监测时间点',
  PRIMARY KEY (`id`),
  KEY `idx_pat_id` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者血压记录表';

-- ----------------------------
-- Table structure for t_pat_blood_sugar_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_blood_sugar_record`;
CREATE TABLE `t_pat_blood_sugar_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '患者id-数据中心',
  `measure_date` date NOT NULL COMMENT '测量日期',
  `measure_point` tinyint(4) NOT NULL COMMENT '监测点',
  `sugar_value` decimal(3,1) NOT NULL COMMENT '血糖记录值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `creator_id` varchar(32) DEFAULT '' COMMENT '创建人id',
  `creator_name` varchar(32) DEFAULT '' COMMENT '创建人姓名',
  `update_id` varchar(32) DEFAULT '' COMMENT '编辑人id',
  `update_name` varchar(32) DEFAULT '' COMMENT '编辑人姓名',
  `time_division` datetime DEFAULT NULL COMMENT '监测时间点',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='血糖记录表';

-- ----------------------------
-- Table structure for t_pat_cards
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_cards`;
CREATE TABLE `t_pat_cards` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '健管云患者id',
  `task_type` varchar(32) DEFAULT NULL COMMENT '要展示的任务卡片集合,多个以,分割，与任务类型枚举保持一致',
  `effect_date` date DEFAULT NULL COMMENT '有效日期',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='首页患者任务卡片展示表';

-- ----------------------------
-- Table structure for t_pat_diet_info
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_diet_info`;
CREATE TABLE `t_pat_diet_info` (
  `id` varchar(32) NOT NULL,
  `pay_id` varchar(40) NOT NULL DEFAULT '' COMMENT '开单id',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pat_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者ID',
  `height` decimal(4,1) NOT NULL DEFAULT '0.0' COMMENT '身高',
  `weight` decimal(4,1) NOT NULL DEFAULT '0.0' COMMENT '体重',
  `age` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '年龄',
  `diet_custom` tinyint(4) DEFAULT '0' COMMENT '饮食习俗',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `diseases` varchar(20) DEFAULT NULL COMMENT '疾病, 肾病、高尿酸血症、慢阻肺、支持多选',
  `allergic_foods` text NOT NULL COMMENT '过敏食物',
  `optional_foods` varchar(100) DEFAULT NULL COMMENT '找不到过敏食物,在此填写',
  `not_suitable` tinyint(1) NOT NULL DEFAULT '0' COMMENT '患者不适合饮食方案',
  `is_latest` tinyint(1) NOT NULL DEFAULT '1' COMMENT '最新版本 1表示最新',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `old_data_flag` tinyint(4) DEFAULT '0' COMMENT '老数据, 需要显示疾病三选一',
  `lactation_period` tinyint(4) DEFAULT '0' COMMENT '是否母乳喂养',
  PRIMARY KEY (`id`),
  KEY `idx_pay_empi` (`pay_id`,`empi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者饮食信息';

-- ----------------------------
-- Table structure for t_pat_diet_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_diet_plan`;
CREATE TABLE `t_pat_diet_plan` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `plan_diet_id` varchar(32) NOT NULL COMMENT '饮食方案id',
  `pat_id` varchar(32) DEFAULT NULL COMMENT '患者id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建时间',
  `update_id` varchar(32) NOT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `un_management_flag` tinyint(2) NOT NULL DEFAULT '0' COMMENT '不管理表示 0 否\n            1 是',
  `un_management_reason` varchar(500) NOT NULL DEFAULT '' COMMENT '不管理原因',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者饮食方案';

-- ----------------------------
-- Table structure for t_pat_diet_plan_copy
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_diet_plan_copy`;
CREATE TABLE `t_pat_diet_plan_copy` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `plan_diet_id` varchar(32) NOT NULL COMMENT '饮食方案id',
  `pat_id` varchar(32) DEFAULT NULL COMMENT '患者id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建时间',
  `update_id` varchar(32) NOT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `un_management_flag` tinyint(2) NOT NULL DEFAULT '0' COMMENT '不管理表示 0 否\n            1 是',
  `un_management_reason` varchar(500) NOT NULL DEFAULT '' COMMENT '不管理原因',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者饮食方案';

-- ----------------------------
-- Table structure for t_pat_diet_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_diet_record`;
CREATE TABLE `t_pat_diet_record` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `execution_date` varchar(32) NOT NULL COMMENT '发生日期',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id-数据中心',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `pic_url` varchar(500) DEFAULT NULL COMMENT '饮食照片',
  `record_desc` varchar(1024) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '记录描述',
  `meal` tinyint(2) NOT NULL COMMENT '餐次',
  `abandon_record` tinyint(2) NOT NULL DEFAULT '0' COMMENT '放弃记录 0 可以 1 不可以',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `ai_review_content` varchar(1024) NOT NULL DEFAULT '' COMMENT 'ai点评',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `text_desc` varchar(50) DEFAULT NULL COMMENT '饮食文字描述',
  `record_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '记录类型 1:饮食照片 2：饮食文字',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者饮食方案';

-- ----------------------------
-- Table structure for t_pat_diet_record_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_diet_record_detail`;
CREATE TABLE `t_pat_diet_record_detail` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) NOT NULL COMMENT '是否删除 0 否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者id-数据中心',
  `execution_date` varchar(10) NOT NULL COMMENT '执行日期',
  `meal` tinyint(3) NOT NULL COMMENT '餐次',
  `diet_category` int(3) NOT NULL COMMENT '食物类别',
  `amount` decimal(7,2) NOT NULL COMMENT '数量（单位：克）',
  `record_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '关联饮食记录id',
  `empi_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='饮食记录详情';

-- ----------------------------
-- Table structure for t_pat_height_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_height_record`;
CREATE TABLE `t_pat_height_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '患者id-数据中心',
  `measure_date` date NOT NULL COMMENT '测量日期',
  `height_value` decimal(4,1) NOT NULL COMMENT '身高记录值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `creator_id` varchar(32) NOT NULL DEFAULT '' COMMENT '创建人',
  `creator_name` varchar(32) NOT NULL DEFAULT '' COMMENT '创建人',
  `update_name` varchar(32) NOT NULL DEFAULT '' COMMENT '编辑人',
  `update_id` varchar(32) NOT NULL DEFAULT '' COMMENT '编辑人id',
  `time_division` datetime DEFAULT NULL COMMENT '监测时间点',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者身高记录表';

-- ----------------------------
-- Table structure for t_pat_individualization_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_individualization_plan`;
CREATE TABLE `t_pat_individualization_plan` (
  `id` varchar(32) NOT NULL COMMENT '个性化方案id',
  `pat_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者id-数据中心',
  `pay_id` varchar(32) DEFAULT '' COMMENT '开单id',
  `plan_diet_id` varchar(32) DEFAULT '' COMMENT '饮食方案id',
  `service_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '服务包类型：1减重,2精细化',
  `plan_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '方案类型，1在线版,2手动上传版',
  `plan_date` datetime NOT NULL COMMENT '方案确认时间',
  `content` text NOT NULL COMMENT '方案内容',
  `is_send` tinyint(1) DEFAULT '0' COMMENT '是否发送模板消息：0未发送,1已发送',
  `send_time` datetime DEFAULT NULL COMMENT '方案发送时间',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '是否已读：0未读,1已读',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0未删除,1已删除',
  `enable` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用：0未启用,1启用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `editor_name` varchar(32) CHARACTER SET utf8 DEFAULT '' COMMENT '编辑人名称',
  `editor_id` varchar(32) CHARACTER SET utf8 DEFAULT '' COMMENT '编辑人id',
  `edit_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `empi_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `source_type` tinyint(1) NOT NULL DEFAULT '3' COMMENT '来源类型类型 3 饮食  6运动',
  PRIMARY KEY (`id`),
  KEY `idx_pat_pt` (`pat_id`,`plan_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='个性化方案';

-- ----------------------------
-- Table structure for t_pat_medications_remind
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_medications_remind`;
CREATE TABLE `t_pat_medications_remind` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者id-数据中心',
  `drug_name` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '药品名称',
  `medications_timing` varchar(36) CHARACTER SET utf8 NOT NULL COMMENT '用药时间',
  `once_dosage` varchar(32) CHARACTER SET utf8 DEFAULT '' COMMENT '一次用量',
  `is_remind` tinyint(1) unsigned DEFAULT '1' COMMENT '提醒标识，0：未开启提醒，1：开启提醒',
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT '' COMMENT '备注',
  `empi_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `medication_way` int(11) DEFAULT NULL COMMENT '服药方式 1.口服 2.外用 3.皮下注射 4.舌下含服 5.咀嚼',
  `medication_requirement` int(11) DEFAULT NULL COMMENT '服药要求 1.空腹 2.餐前 3.餐后',
  `medication_frequency` int(11) DEFAULT NULL COMMENT '用药频率 1每晨一次 2每日一次 3每日两次 4每日三次 5每日四次 6睡前服用 7每6小时一次 8每8小时一次 9每12小时一次',
  PRIMARY KEY (`id`),
  KEY `idx_pat_id` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用药提醒配置表';

-- ----------------------------
-- Table structure for t_pat_medications_remind_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_medications_remind_record`;
CREATE TABLE `t_pat_medications_remind_record` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `medication_remind_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '用药提醒配置id',
  `medication_time` varchar(5) CHARACTER SET utf8 NOT NULL COMMENT '用药时间',
  `send_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '-1 发送失败  0 未发送  1已发送',
  PRIMARY KEY (`id`),
  KEY `idx_medication_info` (`medication_remind_id`,`medication_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用药提醒发送记录表';

-- ----------------------------
-- Table structure for t_pat_monitor_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_monitor_plan`;
CREATE TABLE `t_pat_monitor_plan` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `sugar_frequency` tinyint(2) NOT NULL DEFAULT '0' COMMENT '血糖监测任务 0 否 1 选中默认方案',
  `weight_frequency` tinyint(2) NOT NULL DEFAULT '0' COMMENT '体重监测频次 0 否',
  `create_id` varchar(32) NOT NULL COMMENT '创建时间',
  `update_id` varchar(32) NOT NULL COMMENT '修改时间',
  `create_name` varchar(32) NOT NULL COMMENT '创建时间',
  `update_name` varchar(32) NOT NULL COMMENT '修改时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `sugar_plan_update_time` varchar(32) NOT NULL COMMENT '血糖方案修改时间',
  `weight_plan_update_time` varchar(32) NOT NULL COMMENT '体重方案修改时间',
  `blood_pressure_frequency` tinyint(2) NOT NULL DEFAULT '0' COMMENT '血压监测任务 0 否 1 通用合并高血压方案',
  `nwh_frequency` tinyint(2) NOT NULL DEFAULT '0' COMMENT '体围监测任务 0 否 1\n            选中默认方案',
  `body_temperature_frequency` tinyint(2) NOT NULL DEFAULT '0' COMMENT '体温监测任务 0 否 1 选中默认方案 99 自主监测',
  `ovulation_frequency` tinyint(2) NOT NULL DEFAULT '0' COMMENT '排卵监测任务 0 否\n            1 选中默认方案 99 自主监测',
  `blood_pressure_update_time` varchar(32) NOT NULL COMMENT '血压方案修改时间',
  `nwh_update_time` varchar(32) NOT NULL COMMENT '体围方案修改时间',
  `body_temperature_update_time` varchar(32) NOT NULL COMMENT '体温方案修改时间',
  `ovulation_update_time` varchar(32) NOT NULL COMMENT '排卵方案修改时间',
  `un_management_flag` tinyint(2) NOT NULL DEFAULT '0' COMMENT '不管理表示\n            0 否 1 是',
  `un_management_reason` varchar(500) NOT NULL DEFAULT '' COMMENT '不管理原因',
  `height_frequency` tinyint(4) NOT NULL DEFAULT '0' COMMENT '身高监测频次 0-未开启方案 99-自主选择监测 30:每1个月',
  `height_plan_update_time` varchar(30) NOT NULL COMMENT '身高方案修改时间',
  `pregnancy_nwh_frequency` tinyint(3) NOT NULL DEFAULT '0' COMMENT '孕周体围频次',
  `pregnancy_nwh_frequency_update_time` varchar(32) NOT NULL COMMENT '孕周体围方案修改时间',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  `pulse_frequency` tinyint(3) NOT NULL DEFAULT '0' COMMENT '脉率监测频次',
  `pulse_update_time` varchar(30) NOT NULL DEFAULT '' COMMENT '脉率监测更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者-监测身高';

-- ----------------------------
-- Table structure for t_pat_msg_notify
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_msg_notify`;
CREATE TABLE `t_pat_msg_notify` (
  `id` bigint(11) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `execution_date` varchar(10) NOT NULL COMMENT '执行日期',
  `notify_msg` varchar(1024) DEFAULT '' COMMENT '追踪数据',
  `track_type` tinyint(3) NOT NULL COMMENT '追踪类型',
  `read_status` tinyint(2) NOT NULL COMMENT '阅读状态 0 未读 1 已读',
  `source_id` varchar(32) NOT NULL COMMENT '来源记录id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者消息通知表';

-- ----------------------------
-- Table structure for t_pat_pregnancy_nwh_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_pregnancy_nwh_record`;
CREATE TABLE `t_pat_pregnancy_nwh_record` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者id-数据中心',
  `execution_date` datetime NOT NULL COMMENT '记录时间',
  `abdominal_circumference` decimal(4,1) NOT NULL COMMENT '腹围',
  `palace_height` decimal(4,1) NOT NULL COMMENT '宫高',
  `empi_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `creator_id` varchar(32) DEFAULT '' COMMENT '创建人id',
  `creator_name` varchar(32) DEFAULT '' COMMENT '创建人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者体围记录表';

-- ----------------------------
-- Table structure for t_pat_pulse_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_pulse_record`;
CREATE TABLE `t_pat_pulse_record` (
  `id` varchar(32) NOT NULL,
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `pat_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者id-数据中心',
  `measure_time` datetime NOT NULL COMMENT '记录时间',
  `pulse` int(3) NOT NULL COMMENT '脉率',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '订单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `creator_id` varchar(32) DEFAULT '' COMMENT '创建者id',
  `creator_name` varchar(32) DEFAULT '' COMMENT '创建人姓名',
  `update_id` varchar(32) DEFAULT '' COMMENT '修改者id',
  `update_name` varchar(32) DEFAULT '' COMMENT '修改者姓名',
  `time_division` datetime DEFAULT NULL COMMENT '监测时间点',
  PRIMARY KEY (`id`),
  KEY `idx_pat_id` (`pat_id`(8)) USING BTREE,
  KEY `idx_measure_time` (`measure_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者脉率记录表';

-- ----------------------------
-- Table structure for t_pat_sport_favorite
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_sport_favorite`;
CREATE TABLE `t_pat_sport_favorite` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `sport_id` varchar(50) NOT NULL COMMENT '运动id',
  `sport_name` varchar(16) NOT NULL COMMENT '运动名称',
  `calories_unit` decimal(8,3) DEFAULT NULL,
  `sport_pic` varchar(200) NOT NULL COMMENT '运动照片',
  `record_qty` int(6) NOT NULL DEFAULT '0' COMMENT '记录数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者喜爱运动';

-- ----------------------------
-- Table structure for t_pat_sport_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_sport_plan`;
CREATE TABLE `t_pat_sport_plan` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `plan_sport_id` varchar(32) DEFAULT NULL COMMENT '运动方案id',
  `data_version` decimal(8,2) DEFAULT NULL COMMENT '运动方案版本号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建人',
  `update_id` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `show_sport_action` tinyint(2) NOT NULL DEFAULT '1' COMMENT '活动消耗展示',
  `un_management_flag` tinyint(2) NOT NULL DEFAULT '0' COMMENT '不管理表示 0\n            否 1 是',
  `un_management_reason` varchar(500) NOT NULL DEFAULT '' COMMENT '不管理原因',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者饮食方案';

-- ----------------------------
-- Table structure for t_pat_sport_plan_change_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_sport_plan_change_record`;
CREATE TABLE `t_pat_sport_plan_change_record` (
  `id` bigint(11) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `pat_name` varchar(30) NOT NULL COMMENT '患者名称',
  `sex_code` tinyint(1) NOT NULL COMMENT '性别 1男 2女',
  `sport_time` int(5) NOT NULL COMMENT '运动时间',
  `sport_day` int(5) NOT NULL COMMENT '运动天数',
  `team_id` varchar(32) NOT NULL COMMENT '分组id',
  `team_name` varchar(32) NOT NULL COMMENT '分组名称',
  `group_id` varchar(32) DEFAULT '' COMMENT '团队id',
  `execution_date` varchar(10) NOT NULL COMMENT '执行日期',
  `deal_status` tinyint(1) NOT NULL COMMENT '处理状态 0未处理 1已处理',
  `hosp_code` varchar(50) NOT NULL DEFAULT '' COMMENT '医院编码',
  `manage_user_id` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员id',
  `manage_user_name` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员id',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  `deal_handler` varchar(32) DEFAULT '' COMMENT '处理人',
  `deal_handler_id` varchar(32) DEFAULT '' COMMENT '处理人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `sport_duration` int(5) NOT NULL COMMENT '运动时长',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者消息通知表';

-- ----------------------------
-- Table structure for t_pat_sport_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_sport_record`;
CREATE TABLE `t_pat_sport_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id-数据中心',
  `execution_date` varchar(20) NOT NULL COMMENT '发生时间',
  `sport_type` tinyint(2) NOT NULL COMMENT '患者id',
  `fatigue_status` varchar(20) NOT NULL DEFAULT '-1' COMMENT '疲劳程度',
  `discomfort_desc` varchar(200) NOT NULL DEFAULT '' COMMENT '不适描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `record_status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '运动状态',
  `desc_url` varchar(1024) DEFAULT '' COMMENT '运动照片或视频',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者运动记录';

-- ----------------------------
-- Table structure for t_pat_sport_record_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_sport_record_detail`;
CREATE TABLE `t_pat_sport_record_detail` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id-数据中心',
  `execution_date` varchar(20) NOT NULL COMMENT '发生时间',
  `sport_id` varchar(50) NOT NULL DEFAULT '-1' COMMENT '发生时间',
  `sport_name` varchar(100) NOT NULL DEFAULT '' COMMENT '发生时间',
  `burn_calories` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '消耗卡路里',
  `sport_time` int(4) NOT NULL DEFAULT '0' COMMENT '运动时间',
  `record_id` varchar(32) NOT NULL COMMENT '运动记录id',
  `sport_pic` varchar(200) NOT NULL COMMENT '运动照片',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `calories_unit` decimal(8,3) NOT NULL DEFAULT '0.000' COMMENT '消耗卡路里单位',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE,
  KEY `idx_recordId` (`record_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者运动记录详情';

-- ----------------------------
-- Table structure for t_pat_sport_statistics
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_sport_statistics`;
CREATE TABLE `t_pat_sport_statistics` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `execution_date` varchar(16) NOT NULL COMMENT '执行日期',
  `burn_calories` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '消耗卡路里',
  `wechat_step` int(6) NOT NULL DEFAULT '0' COMMENT '微信步数',
  `sport_time` int(6) NOT NULL DEFAULT '0' COMMENT '运动时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `step_update_time` datetime DEFAULT NULL COMMENT '运动更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者每日运动情况统计';

-- ----------------------------
-- Table structure for t_pat_sport_week_split_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_sport_week_split_record`;
CREATE TABLE `t_pat_sport_week_split_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `execution_begin_date` varchar(16) DEFAULT NULL COMMENT '执行开始时间',
  `execution_end_date` varchar(16) DEFAULT NULL COMMENT '执行结束时间',
  `sport_plan_id` varchar(50) DEFAULT NULL COMMENT '方案id',
  `data_version` decimal(8,2) DEFAULT NULL COMMENT '运动方案版本号',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(40) DEFAULT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) DEFAULT NULL COMMENT '订单id',
  `sport_duration` int(4) NOT NULL DEFAULT '0' COMMENT '运动时长',
  `current_week_duration` int(5) NOT NULL DEFAULT '0' COMMENT '运动时长',
  `next_time_length` int(11) DEFAULT NULL COMMENT '下周运动时间调整值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pid_date` (`pat_id`,`execution_begin_date`,`execution_end_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务-运动';

-- ----------------------------
-- Table structure for t_pat_sugar_task_info
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_sugar_task_info`;
CREATE TABLE `t_pat_sugar_task_info` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `create_time` varchar(32) NOT NULL COMMENT '创建时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者血糖任务提交信息表';

-- ----------------------------
-- Table structure for t_pat_surrounded_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_surrounded_record`;
CREATE TABLE `t_pat_surrounded_record` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者id-数据中心',
  `measure_time` datetime NOT NULL COMMENT '记录时间',
  `waist_circumference` int(3) NOT NULL COMMENT '收缩压',
  `hip_circumference` int(3) NOT NULL COMMENT '舒张压',
  `empi_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `creator_id` varchar(32) DEFAULT '' COMMENT '创建人id',
  `creator_name` varchar(32) DEFAULT '' COMMENT '创建人姓名',
  PRIMARY KEY (`id`),
  KEY `idx_pat_id` (`pat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者体围记录表';

-- ----------------------------
-- Table structure for t_pat_task_blood_pressure
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_task_blood_pressure`;
CREATE TABLE `t_pat_task_blood_pressure` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) NOT NULL COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者id',
  `frequency` tinyint(2) NOT NULL COMMENT '频次',
  `execution_date` date NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='血压任务检测';

-- ----------------------------
-- Table structure for t_pat_task_split_error_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_task_split_error_record`;
CREATE TABLE `t_pat_task_split_error_record` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `task_type` tinyint(2) NOT NULL COMMENT '任务类型',
  `execution_date` varchar(20) NOT NULL COMMENT '执行时间',
  `err_msg` varchar(1024) NOT NULL COMMENT '异常原因',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者-监测身高';

-- ----------------------------
-- Table structure for t_pat_task_split_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_task_split_record`;
CREATE TABLE `t_pat_task_split_record` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `frequency` tinyint(2) NOT NULL COMMENT '点评频次 1次或者6次',
  `execution_date` varchar(20) NOT NULL COMMENT '执行时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `task_type` tinyint(1) NOT NULL COMMENT '任务类别 1 饮食 2 体重',
  `plan_id` varchar(32) NOT NULL DEFAULT '' COMMENT '方案id',
  `start_date` varchar(20) DEFAULT NULL COMMENT '运动开始时间',
  `end_date` varchar(20) DEFAULT NULL COMMENT '运动结束时间',
  `frequency_value` int(11) DEFAULT NULL COMMENT '饮食点评频次单位',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者-监测身高';

-- ----------------------------
-- Table structure for t_pat_task_surrounded
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_task_surrounded`;
CREATE TABLE `t_pat_task_surrounded` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) NOT NULL COMMENT '删除标识，0：未删除，1：已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者id',
  `frequency` tinyint(2) NOT NULL COMMENT '频次',
  `execution_date` date NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='体围任务检测';

-- ----------------------------
-- Table structure for t_pat_weight_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pat_weight_record`;
CREATE TABLE `t_pat_weight_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '患者id-数据中心',
  `measure_date` date DEFAULT NULL COMMENT '测量日期',
  `weight_value` decimal(4,1) DEFAULT NULL COMMENT '体重记录值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `empi_id` varchar(32) NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '定单id',
  `source_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '记录来源 0 患者 1医生',
  `creator_id` varchar(32) DEFAULT '' COMMENT '创建人',
  `creator_name` varchar(32) DEFAULT '' COMMENT '创建人',
  `update_name` varchar(32) DEFAULT '' COMMENT '编辑人',
  `update_id` varchar(32) DEFAULT '' COMMENT '编辑人id',
  `time_division` datetime DEFAULT NULL COMMENT '监测时间点',
  PRIMARY KEY (`id`),
  KEY `idx_pat_date` (`pat_id`,`measure_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='体重记录表';

-- ----------------------------
-- Table structure for t_patient_consultation
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_consultation`;
CREATE TABLE `t_patient_consultation` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `consultation_suggestion` varchar(1024) DEFAULT NULL COMMENT '建议',
  `attachment` varchar(1024) DEFAULT NULL COMMENT '附件',
  `registration_date` varchar(16) DEFAULT NULL COMMENT '登记日期',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `review_num` int(11) DEFAULT NULL COMMENT '复查记录',
  `review_date` datetime DEFAULT NULL COMMENT '复查记录',
  `is_stander` tinyint(1) DEFAULT '0' COMMENT '是否标准检查',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='患者会诊建议记录表';

-- ----------------------------
-- Table structure for t_patient_drug_record
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_drug_record`;
CREATE TABLE `t_patient_drug_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `drug_name` varchar(32) NOT NULL COMMENT '药品名称',
  `once_dosage` varchar(32) NOT NULL COMMENT '一次用量',
  `total_dosage` varchar(32) NOT NULL COMMENT '总量',
  `frequency` varchar(512) NOT NULL COMMENT '使用频次',
  `drug_way` varchar(512) DEFAULT NULL COMMENT '用药方式',
  `prescription_date` varchar(16) NOT NULL COMMENT '开药日期',
  `doc_name` varchar(32) DEFAULT NULL COMMENT '开嘱医生',
  `registration_date` varchar(16) DEFAULT NULL COMMENT '登记日期',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `withdrawal_date` varchar(16) DEFAULT NULL COMMENT '停药日期',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者用药记录表';

-- ----------------------------
-- Table structure for t_patient_endocrine
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_endocrine`;
CREATE TABLE `t_patient_endocrine` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `attachment` varchar(1024) DEFAULT NULL,
  `registration_date` varchar(16) DEFAULT NULL COMMENT '登记日期',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `review_num` int(11) DEFAULT NULL COMMENT '复查记录',
  `review_date` datetime DEFAULT NULL COMMENT '复查记录',
  `acth_8am` decimal(8,2) DEFAULT NULL COMMENT '促肾上腺皮质激素8am',
  `acth_4pm` decimal(8,2) DEFAULT NULL COMMENT '促肾上腺皮质激素4pm',
  `cor_8am` decimal(8,2) DEFAULT NULL COMMENT '皮质醇8am',
  `cor_4pm` decimal(8,2) DEFAULT NULL COMMENT '皮质醇4pm',
  `blood_wbc` decimal(8,2) DEFAULT NULL COMMENT '白细胞',
  `blood_n` decimal(8,2) DEFAULT NULL COMMENT '中性粒细胞',
  `blood_hb` decimal(8,2) DEFAULT NULL COMMENT '血红蛋白',
  `blood_plt` decimal(8,2) DEFAULT NULL COMMENT '血小板',
  `blood_sfa` decimal(8,2) DEFAULT NULL COMMENT '叶酸',
  `blood_vb12` decimal(8,2) DEFAULT NULL COMMENT '维生素B12',
  `blood_sf` decimal(8,2) DEFAULT NULL COMMENT '血清铁蛋白',
  `upper_abdominal_ultrasound` varchar(1024) DEFAULT NULL COMMENT '上腹部B超',
  `gynecology_ultrasound` varchar(1024) DEFAULT NULL COMMENT '妇科B超',
  `carotid_artery_ultrasound` varchar(1024) DEFAULT NULL COMMENT '颈动脉B超',
  `bone_density` varchar(1024) DEFAULT NULL COMMENT '骨密度',
  `adrenal_ultrasound` varchar(1024) DEFAULT NULL COMMENT '肾上腺B超',
  `sleep_breathing` varchar(1024) DEFAULT NULL COMMENT '睡眠呼吸',
  `ecg` varchar(1024) DEFAULT NULL COMMENT '心电图',
  `body_fat` varchar(1024) DEFAULT NULL COMMENT '体脂',
  `subcutaneous_fat` varchar(1024) DEFAULT NULL COMMENT '皮下脂肪',
  `visceral_fat` varchar(1024) DEFAULT NULL COMMENT '内脏脂肪',
  `lk_alt` decimal(8,2) DEFAULT NULL COMMENT '谷丙转氨酶',
  `lk_ast` decimal(8,2) DEFAULT NULL COMMENT '谷草转氨酶',
  `lk_y_gt` decimal(8,2) DEFAULT NULL COMMENT 'y-谷氨酰转肽酶',
  `lk_tb` decimal(8,2) DEFAULT NULL COMMENT '总胆红素',
  `lk_db` decimal(8,2) DEFAULT NULL COMMENT '直接胆红素',
  `lk_ib` decimal(8,2) DEFAULT NULL COMMENT '间接胆红素',
  `lk_tg` decimal(8,2) DEFAULT NULL COMMENT '甘油三酯',
  `lk_tc` decimal(8,2) DEFAULT NULL COMMENT '总胆固醇',
  `lk_hdl_c` decimal(8,2) DEFAULT NULL COMMENT '高密度脂蛋白',
  `lk_ldl_c` decimal(8,2) DEFAULT NULL COMMENT '低密度脂蛋白',
  `lk_ua` decimal(8,2) DEFAULT NULL COMMENT '尿酸',
  `pressure_sp` decimal(8,2) DEFAULT NULL COMMENT '收缩压',
  `pressure_bp` decimal(8,2) DEFAULT NULL COMMENT '舒张压',
  `body_condition` varchar(1024) DEFAULT NULL COMMENT '身体状况',
  `hormone_fsh` decimal(8,2) DEFAULT NULL COMMENT '卵泡刺激素',
  `hormone_lh` decimal(8,2) DEFAULT NULL COMMENT '黄体生成素',
  `hormone_p` decimal(8,2) DEFAULT NULL COMMENT '孕酮',
  `hormone_prl` decimal(8,2) DEFAULT NULL COMMENT '催乳素',
  `hormone_e2` decimal(8,2) DEFAULT NULL COMMENT '雌二醇',
  `hormone_t` decimal(8,2) DEFAULT NULL COMMENT '睾酮',
  `glu_0h` decimal(8,2) DEFAULT NULL COMMENT '葡萄糖0h',
  `glu_1h` decimal(8,2) DEFAULT NULL COMMENT '葡萄糖1h',
  `glu_2h` decimal(8,2) DEFAULT NULL COMMENT '葡萄糖2h',
  `glu_3h` decimal(8,2) DEFAULT NULL COMMENT '葡萄糖3h',
  `ins_0h` decimal(8,2) DEFAULT NULL COMMENT '胰岛素0h',
  `ins_1h` decimal(8,2) DEFAULT NULL COMMENT '胰岛素1h',
  `ins_2h` decimal(8,2) DEFAULT NULL COMMENT '胰岛素2h',
  `ins_3h` decimal(8,2) DEFAULT NULL COMMENT '胰岛素3h',
  `c_p_0h` decimal(8,2) DEFAULT NULL COMMENT 'C-肽0h',
  `c_p_1h` decimal(8,2) DEFAULT NULL COMMENT 'C-肽1h',
  `c_p_2h` decimal(8,2) DEFAULT NULL COMMENT 'C-肽2h',
  `c_p_3h` decimal(8,2) DEFAULT NULL COMMENT 'C-肽3h',
  `hba1c` decimal(8,2) DEFAULT NULL COMMENT '糖化血红蛋白',
  `thyroid_t3` decimal(8,2) DEFAULT NULL COMMENT '三碘甲腺原氨酸',
  `thyroid_ft3` decimal(8,2) DEFAULT NULL COMMENT '游离三碘甲腺原氨酸',
  `thyroid_t4` decimal(8,2) DEFAULT NULL COMMENT '甲状腺素',
  `thyroid_tsh` decimal(8,2) DEFAULT NULL COMMENT '促甲状腺素',
  `thyroid_ft4` decimal(8,2) DEFAULT NULL COMMENT '游离甲状腺素',
  `thyroid_tgab` decimal(8,2) DEFAULT NULL COMMENT '甲状腺球蛋白抗体',
  `thyroid_tpoab` decimal(8,2) DEFAULT NULL COMMENT '甲状腺过氧化酶抗体',
  `ut_uma` decimal(8,2) DEFAULT NULL COMMENT '尿微量白蛋白',
  `ut_tru` decimal(8,2) DEFAULT NULL COMMENT '尿转铁蛋白',
  `ut_a1_m` decimal(8,2) DEFAULT NULL COMMENT '尿α1-微球蛋白',
  `ut_ulgg` decimal(8,2) DEFAULT NULL COMMENT '尿免疫球蛋白G',
  `ut_ma_cr` decimal(8,2) DEFAULT NULL COMMENT '尿微量蛋白/肌酐',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者内分泌科记录表';

-- ----------------------------
-- Table structure for t_patient_nut_science
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_nut_science`;
CREATE TABLE `t_patient_nut_science` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `weight` decimal(8,2) DEFAULT NULL COMMENT '体重',
  `height` decimal(8,2) DEFAULT NULL COMMENT '身高',
  `bmi` decimal(8,2) DEFAULT NULL COMMENT 'bmi',
  `neck_circum` decimal(8,2) DEFAULT NULL COMMENT '颈围',
  `waist_circum` decimal(8,2) DEFAULT NULL COMMENT '腰围',
  `hip_circum` decimal(8,2) DEFAULT NULL COMMENT '臀围',
  `inbody_rate` decimal(8,2) DEFAULT NULL COMMENT 'inbody评分',
  `skeletal_muscle` decimal(8,2) DEFAULT NULL COMMENT '骨骼肌',
  `body_fat` decimal(8,2) DEFAULT NULL COMMENT '体脂肪',
  `visceral_fat` decimal(8,2) DEFAULT NULL COMMENT '内脏脂肪',
  `body_mass_index` decimal(8,2) DEFAULT NULL COMMENT '身体质量指数',
  `body_fat_per` decimal(8,2) DEFAULT NULL COMMENT '体脂百分比',
  `extracellular_water_ratio` decimal(8,3) DEFAULT NULL,
  `basal_metabolic_rate` decimal(8,2) DEFAULT NULL COMMENT '基础代谢率',
  `waist_to_hip_ratio` decimal(8,2) DEFAULT NULL COMMENT '腰臀比',
  `nut_suggestion` varchar(1024) DEFAULT NULL COMMENT '营养师意见',
  `attachment` varchar(2048) DEFAULT NULL COMMENT '附件',
  `registration_date` varchar(16) DEFAULT NULL COMMENT '登记日期',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `omron_visceral_fat` decimal(8,2) DEFAULT NULL COMMENT '欧姆龙内脏脂肪',
  `abdomen_subcutaneous_fat` decimal(8,2) DEFAULT NULL COMMENT '腹部皮下脂肪',
  `review_num` int(11) DEFAULT NULL COMMENT '复查记录',
  `review_date` datetime DEFAULT NULL COMMENT '复查记录',
  `body_water` decimal(8,2) DEFAULT NULL COMMENT '身体水分',
  `is_stander` tinyint(1) DEFAULT '0' COMMENT '是否标准检查',
  `target_weight` decimal(8,2) DEFAULT NULL COMMENT '目标体重',
  `weight_control` decimal(8,2) DEFAULT NULL COMMENT '体重控制',
  `fat_control` decimal(8,2) DEFAULT NULL COMMENT '脂肪控制',
  `inbody_neck` decimal(8,2) DEFAULT NULL COMMENT '颈围(I)',
  `inbody_waist` decimal(8,2) DEFAULT NULL COMMENT '腰围(I)',
  `inbody_hip` decimal(8,2) DEFAULT NULL COMMENT '臀围(I)',
  `muscle_control` decimal(8,2) DEFAULT NULL COMMENT '肌肉控制',
  `analysis_result` varchar(30) DEFAULT NULL COMMENT '对比分析结果',
  `muscle_kg` decimal(8,2) DEFAULT NULL COMMENT '肌肉kg',
  `visceral_fat_kg` decimal(8,2) DEFAULT NULL COMMENT '内脏脂肪kg',
  `visceral_fat_level` decimal(8,2) DEFAULT NULL COMMENT '内脏脂肪等级',
  `front_side_photo` varchar(1024) DEFAULT NULL COMMENT '正侧面照片',
  `resting_heart_rate` int(4) DEFAULT NULL COMMENT '静息心率',
  `health_score` decimal(8,2) DEFAULT NULL COMMENT '健康评分',
  `lean_body_mass` decimal(8,2) DEFAULT NULL COMMENT '去脂体重',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  `total_cholesterol` decimal(8,2) DEFAULT NULL COMMENT '总胆固醇',
  `triglyceride` decimal(8,2) DEFAULT NULL COMMENT '甘油三酯',
  `ldl` decimal(8,2) DEFAULT NULL COMMENT '低密度胆固醇',
  `hdl` decimal(8,2) DEFAULT NULL COMMENT '高密度胆固醇',
  `uric_acid` decimal(8,2) DEFAULT NULL COMMENT '尿酸',
  `fasting_blood_glucose` decimal(8,2) DEFAULT NULL COMMENT '空腹血糖',
  `ast` decimal(8,2) DEFAULT NULL COMMENT '门冬氨酸氨基转移酶',
  `alp` decimal(8,2) DEFAULT NULL COMMENT '碱性磷酸酶',
  `ygt` decimal(8,2) DEFAULT NULL COMMENT 'γ-谷氨酰转肽酶',
  `alt` decimal(8,2) DEFAULT NULL COMMENT '丙氨酸氨基转移酶',
  `is_change` tinyint(4) DEFAULT NULL COMMENT '评估结果是否维持原方案 0:维持原方案  1:重新给与方案',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `is_wechat` tinyint(4) DEFAULT NULL COMMENT '是否小程序录入 0:否 1:是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者营养学科记录表';

-- ----------------------------
-- Table structure for t_patient_psychology
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_psychology`;
CREATE TABLE `t_patient_psychology` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `problem` varchar(1024) DEFAULT NULL COMMENT '现存问题',
  `psy_suggestion` varchar(1024) DEFAULT NULL COMMENT '建议',
  `attachment` varchar(1024) DEFAULT NULL COMMENT '附件',
  `registration_date` varchar(16) DEFAULT NULL COMMENT '登记日期',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `review_num` int(11) DEFAULT NULL COMMENT '复查记录',
  `review_date` datetime DEFAULT NULL COMMENT '复查记录',
  `is_stander` tinyint(1) DEFAULT '0' COMMENT '是否标准检查',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者心理学科记录表';

-- ----------------------------
-- Table structure for t_patient_sport_science
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_sport_science`;
CREATE TABLE `t_patient_sport_science` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `sport_suggestion` varchar(1024) DEFAULT NULL COMMENT '运动指导意见',
  `attachment` varchar(1024) DEFAULT NULL COMMENT '附件',
  `registration_date` varchar(16) DEFAULT NULL COMMENT '登记日期',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `hr` decimal(8,2) DEFAULT NULL COMMENT '脉率',
  `sbp` decimal(8,2) DEFAULT NULL COMMENT '收缩压',
  `dbp` decimal(8,2) DEFAULT NULL COMMENT '舒张压',
  `sevr` decimal(8,2) DEFAULT NULL COMMENT '心内膜下心肌活力率',
  `cre` decimal(8,2) DEFAULT NULL COMMENT '心肺耐力',
  `cre_score` decimal(8,2) DEFAULT NULL COMMENT '心肺耐力评分',
  `cre_evaluation` int(11) DEFAULT NULL COMMENT '心肺耐力评价 1优秀2良好3一般4较弱',
  `sport_project` varchar(1024) DEFAULT NULL COMMENT '运动项目\n            1快走2慢跑3游泳...',
  `sport_intensity` decimal(8,2) DEFAULT NULL COMMENT '运动强度',
  `sport_effective_time` decimal(8,2) DEFAULT NULL COMMENT '运动有效时间',
  `sport_frequency` decimal(8,2) DEFAULT NULL COMMENT '运动频率',
  `max_sport_intensity` decimal(8,2) DEFAULT NULL COMMENT '最大运动强度',
  `max_sport_effective_time` decimal(8,2) DEFAULT NULL COMMENT '最大运动有效时间',
  `max_sport_frequency` decimal(8,2) DEFAULT NULL COMMENT '最大运动频率',
  `min_sport_intensity` decimal(8,2) DEFAULT NULL COMMENT '最小运动强度',
  `min_sport_effective_time` decimal(8,2) DEFAULT NULL COMMENT '最小有效时间',
  `min_sport_frequency` decimal(8,2) DEFAULT NULL COMMENT '最小运动频率',
  `review_num` int(11) DEFAULT NULL COMMENT '复查记录',
  `review_date` datetime DEFAULT NULL COMMENT '复查记录',
  `is_stander` tinyint(1) DEFAULT '0' COMMENT '是否标准检查',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者运动学科记录表';

-- ----------------------------
-- Table structure for t_patient_tcm_science
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_tcm_science`;
CREATE TABLE `t_patient_tcm_science` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `tcm_suggestion` varchar(1024) DEFAULT NULL COMMENT '建议',
  `attachment` varchar(1024) DEFAULT NULL COMMENT '附件',
  `registration_date` varchar(16) DEFAULT NULL COMMENT '登记日期',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `review_num` int(11) DEFAULT NULL COMMENT '复查记录',
  `review_date` datetime DEFAULT NULL COMMENT '复查记录',
  `is_stander` tinyint(1) DEFAULT '0' COMMENT '是否标准检查',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者中医学科记录表';

-- ----------------------------
-- Table structure for t_plan_card
-- ----------------------------
DROP TABLE IF EXISTS `t_plan_card`;
CREATE TABLE `t_plan_card` (
  `id` bigint(20) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '用户id',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '用户在院id',
  `pay_id` varchar(32) DEFAULT NULL COMMENT '用户开单id',
  `task_type` tinyint(3) DEFAULT NULL COMMENT '任务类型',
  `title` varchar(10) DEFAULT NULL COMMENT '标题',
  `unit` varchar(10) DEFAULT NULL COMMENT '单位',
  `current_value` varchar(32) DEFAULT NULL COMMENT '当前值',
  `current_date_str` varchar(32) DEFAULT NULL COMMENT '当前日期',
  `current_point` varchar(32) DEFAULT NULL COMMENT '当前点数据点',
  `current_status` varchar(32) DEFAULT NULL COMMENT '当前状态值 0 ok 1 error',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `hosp_code` varchar(40) NOT NULL COMMENT '医院编码',
  `source_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '来源类型 1 高净价 2 精细化',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='患者卡片';

-- ----------------------------
-- Table structure for t_review_comment_config
-- ----------------------------
DROP TABLE IF EXISTS `t_review_comment_config`;
CREATE TABLE `t_review_comment_config` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `category` varchar(100) CHARACTER SET utf8 NOT NULL COMMENT '类别(参考枚举)多个以逗号分隔',
  `intake_situation` int(11) NOT NULL COMMENT '摄入情况(参考枚举)',
  `description` varchar(500) DEFAULT NULL COMMENT '文案描述',
  `create_by` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8 DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点评评语配置表';

-- ----------------------------
-- Table structure for t_review_comment_config2
-- ----------------------------
DROP TABLE IF EXISTS `t_review_comment_config2`;
CREATE TABLE `t_review_comment_config2` (
  `id` varchar(32) NOT NULL,
  `category` varchar(32) NOT NULL COMMENT '类别(参考枚举)多个以逗号分隔',
  `intake_situation` int(11) NOT NULL COMMENT '摄入情况(参考枚举)',
  `description` varchar(500) DEFAULT NULL COMMENT '文案描述',
  `create_by` varchar(20) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_by` varchar(20) DEFAULT NULL COMMENT '更新人',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='点评评语配置表';

-- ----------------------------
-- Table structure for t_review_reply
-- ----------------------------
DROP TABLE IF EXISTS `t_review_reply`;
CREATE TABLE `t_review_reply` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `is_delete` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除 0未删除，1已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `review_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '点评id',
  `sender_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '发送人id',
  `recipient_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '接收人id',
  `reply_content` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '回复内容',
  `is_deal_with` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否已读/已处理  0否 1是',
  `next_reply_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '对应回复id',
  `reply_date` datetime NOT NULL COMMENT '回复日期',
  `review_type` tinyint(1) NOT NULL COMMENT '点评类型 饮食/运动',
  `hosp_code` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '机构代码',
  `team_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '分组id',
  `pat_name` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '患者名称',
  `is_wait_deal` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否稍后处理 0 否 1是',
  `wait_deal_add_time` datetime DEFAULT NULL COMMENT '稍后处理添加时间',
  `reply_type` tinyint(1) unsigned DEFAULT NULL COMMENT '回复类型 1 患者  2 营养师（pc/医助）',
  `empi_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者id-数据中心',
  `pay_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '定单id',
  `group_id` varchar(50) DEFAULT '' COMMENT '团队id',
  `manage_user_id` varchar(200) DEFAULT '' COMMENT '管理人员id',
  `manage_user_name` varchar(200) DEFAULT '' COMMENT '管理人员id',
  PRIMARY KEY (`id`),
  KEY `idx_reply_date` (`reply_date`) USING BTREE,
  KEY `idx_sender_id` (`sender_id`(8)) USING BTREE,
  KEY `idx_recipient_id` (`recipient_id`(8)) USING BTREE,
  KEY `idx_review_i` (`review_id`(8)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点评回复表';

-- ----------------------------
-- Table structure for t_review_template
-- ----------------------------
DROP TABLE IF EXISTS `t_review_template`;
CREATE TABLE `t_review_template` (
  `id` varchar(32) NOT NULL,
  `group_id` varchar(32) NOT NULL COMMENT '模板类别id',
  `temp_name` varchar(64) DEFAULT NULL COMMENT '模板名称',
  `temp_content` varchar(1024) DEFAULT NULL COMMENT '模板内容',
  `create_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `create_name` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_id` varchar(32) DEFAULT NULL COMMENT '更新人id',
  `update_name` varchar(32) DEFAULT NULL COMMENT '更新人名称',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='点评模板表';

-- ----------------------------
-- Table structure for t_review_template_group
-- ----------------------------
DROP TABLE IF EXISTS `t_review_template_group`;
CREATE TABLE `t_review_template_group` (
  `id` varchar(32) NOT NULL,
  `group_name` varchar(32) DEFAULT NULL COMMENT '类别名称',
  `group_type` tinyint(1) DEFAULT NULL COMMENT '模板类别 1：饮食 2：运动',
  `org_ids` varchar(200) DEFAULT NULL COMMENT '适用医院',
  `template_num` int(11) DEFAULT '0' COMMENT '所含模板个数',
  `create_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `create_name` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_id` varchar(32) DEFAULT NULL COMMENT '更新人id',
  `update_name` varchar(32) DEFAULT NULL COMMENT '更新人名称',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='点评模板分组表';

-- ----------------------------
-- Table structure for t_server_management_record
-- ----------------------------
DROP TABLE IF EXISTS `t_server_management_record`;
CREATE TABLE `t_server_management_record` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `management_date` varchar(32) NOT NULL COMMENT '管理时间',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人',
  `type` tinyint(1) NOT NULL COMMENT '管理类型 0点评 1面访 2电话记录',
  `management_content` varchar(2048) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '管理内容',
  `user_id` varchar(32) DEFAULT NULL COMMENT '营养师id',
  `update_id` varchar(32) DEFAULT NULL COMMENT '修改营养师id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(11) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='服务管理记录';

-- ----------------------------
-- Table structure for t_soap_management_report
-- ----------------------------
DROP TABLE IF EXISTS `t_soap_management_report`;
CREATE TABLE `t_soap_management_report` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `is_delete` tinyint(1) unsigned DEFAULT '1' COMMENT '是否删除  1是 2否',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `pat_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者id-数据中心',
  `title` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '顶部标题',
  `pat_name` varchar(32) CHARACTER SET utf8 DEFAULT '' COMMENT '患者姓名',
  `age` int(3) DEFAULT NULL COMMENT '年龄',
  `sex` tinyint(1) DEFAULT NULL COMMENT '性别',
  `height` int(3) DEFAULT NULL COMMENT '身高',
  `target_weight_loss` int(3) DEFAULT NULL COMMENT '目标减重',
  `disease` varchar(1200) CHARACTER SET utf8 DEFAULT '' COMMENT '疾病',
  `management_start_time` datetime DEFAULT NULL COMMENT '管理开始时间',
  `management_end_time` datetime DEFAULT NULL COMMENT '管理结束时间',
  `days_managed` int(255) DEFAULT NULL COMMENT '已管理天数',
  `evaluation_details_json` text CHARACTER SET utf8 NOT NULL COMMENT '评估详情json',
  `evaluation_time` datetime NOT NULL COMMENT '评估时间',
  `editor_name` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '编辑人',
  `editor_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '编辑人id',
  `edit_time` datetime DEFAULT NULL COMMENT '编辑时间',
  `empi_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '患者在医院的唯一id',
  `pay_id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '定单id',
  `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否新版',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Soap管理报告';

-- ----------------------------
-- Table structure for t_soap_management_task
-- ----------------------------
DROP TABLE IF EXISTS `t_soap_management_task`;
CREATE TABLE `t_soap_management_task` (
  `id` bigint(11) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `pat_name` varchar(30) NOT NULL COMMENT '患者名称',
  `sex_code` tinyint(1) NOT NULL COMMENT '性别 1男 2女',
  `team_id` varchar(32) NOT NULL COMMENT '分组id',
  `team_name` varchar(32) NOT NULL COMMENT '分组名称',
  `group_id` varchar(32) DEFAULT '' COMMENT '团队id',
  `task_start_date` varchar(10) NOT NULL COMMENT '开始时间',
  `task_end_date` varchar(10) NOT NULL COMMENT '结束时间',
  `execution_date` varchar(10) NOT NULL COMMENT '执行日期',
  `manage_day` tinyint(3) NOT NULL COMMENT '管理时间',
  `deal_status` tinyint(1) NOT NULL COMMENT '处理状态 0未处理 1已处理',
  `ref_soap_id` varchar(32) NOT NULL DEFAULT '' COMMENT 'soap报告id',
  `hosp_code` varchar(50) NOT NULL DEFAULT '' COMMENT '医院编码',
  `hosp_name` varchar(150) NOT NULL DEFAULT '' COMMENT '医院名称',
  `manage_user_id` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员id',
  `manage_user_name` varchar(200) NOT NULL DEFAULT '' COMMENT '管理人员id',
  `empi_id` varchar(40) NOT NULL COMMENT '患者在医院的唯一id',
  `pay_id` varchar(40) NOT NULL COMMENT '订单id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `service_period` varchar(32) NOT NULL DEFAULT '' COMMENT '管理周期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='soap任务填写表';

-- ----------------------------
-- Table structure for t_sport_comment_model
-- ----------------------------
DROP TABLE IF EXISTS `t_sport_comment_model`;
CREATE TABLE `t_sport_comment_model` (
  `id` varchar(32) NOT NULL,
  `start_count` int(11) DEFAULT NULL,
  `end_count` int(11) DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_unusual_matters
-- ----------------------------
DROP TABLE IF EXISTS `t_unusual_matters`;
CREATE TABLE `t_unusual_matters` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '处理人',
  `execution_date` varchar(32) DEFAULT NULL COMMENT '发生时间',
  `unusual_point` tinyint(1) DEFAULT NULL COMMENT '异常点',
  `unusual_type` tinyint(1) NOT NULL COMMENT '异常类型',
  `unusual_value` varchar(64) DEFAULT NULL,
  `deal_status` tinyint(1) DEFAULT NULL COMMENT '处理状态 0未处理 1已处理',
  `deal_time` datetime DEFAULT NULL COMMENT '创建时间',
  `sex_code` tinyint(1) DEFAULT NULL COMMENT '性别 1男 2女',
  `team_id` varchar(32) DEFAULT NULL COMMENT '分组id',
  `team_name` varchar(32) DEFAULT NULL COMMENT '分组名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `unusual_level` tinyint(1) DEFAULT NULL COMMENT '异常等级',
  `deal_remark` varchar(500) DEFAULT NULL COMMENT '处理跟进备注',
  `deal_user_name` varchar(20) DEFAULT NULL COMMENT '处理人用户名',
  `mobile_no` varchar(20) DEFAULT NULL COMMENT '手机号码',
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '机构代码',
  `group_id` varchar(32) DEFAULT NULL COMMENT '团队id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_hosp_code` (`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='服务管理记录';

-- ----------------------------
-- Table structure for t_wechat_step_refuse
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_step_refuse`;
CREATE TABLE `t_wechat_step_refuse` (
  `id` varchar(32) NOT NULL,
  `pat_id` varchar(32) NOT NULL COMMENT '患者id',
  `execution_date` varchar(16) NOT NULL COMMENT '执行日期',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_pid` (`pat_id`,`execution_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者喜爱运动';

SET FOREIGN_KEY_CHECKS = 1;
