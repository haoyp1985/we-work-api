/*
 Navicat MySQL Data Transfer

 Source Server         : 健海测试-3.88
 Source Server Type    : MySQL
 Source Server Version : 80034
 Source Host           : 192.168.3.88:3306
 Source Schema         : dtx-diet-prod

 Target Server Type    : MySQL
 Target Server Version : 80034
 File Encoding         : 65001

 Date: 17/07/2025 15:13:10
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
-- Table structure for allergen
-- ----------------------------
DROP TABLE IF EXISTS `allergen`;
CREATE TABLE `allergen` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类别id',
  `category_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类别名称',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建者名称',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改者名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='过敏原表';

-- ----------------------------
-- Table structure for allergen_food
-- ----------------------------
DROP TABLE IF EXISTS `allergen_food`;
CREATE TABLE `allergen_food` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `allergen_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '过敏原表id',
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食材id',
  `food_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食材名称',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建者名称',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改者名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='过敏原食材关联表';

-- ----------------------------
-- Table structure for allergen_food_v2
-- ----------------------------
DROP TABLE IF EXISTS `allergen_food_v2`;
CREATE TABLE `allergen_food_v2` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `allergen_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '过敏原表id',
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食材id',
  `food_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食材名称',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建者名称',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改者名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `release_status` int DEFAULT '4' COMMENT '食材状态  0：停用  1：待提审  2：未通过 3：待审核   4：已发布',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='过敏原食材关联表V2';

-- ----------------------------
-- Table structure for allergen_v2
-- ----------------------------
DROP TABLE IF EXISTS `allergen_v2`;
CREATE TABLE `allergen_v2` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类别id',
  `category_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类别名称',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建者名称',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改者名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='过敏原表';

-- ----------------------------
-- Table structure for databasechangelog
-- ----------------------------
DROP TABLE IF EXISTS `databasechangelog`;
CREATE TABLE `databasechangelog` (
  `ID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `AUTHOR` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `FILENAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `MD5SUM` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TAG` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LIQUIBASE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CONTEXTS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LABELS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for databasechangeloglock
-- ----------------------------
DROP TABLE IF EXISTS `databasechangeloglock`;
CREATE TABLE `databasechangeloglock` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for diet_template
-- ----------------------------
DROP TABLE IF EXISTS `diet_template`;
CREATE TABLE `diet_template` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述',
  `calories_level_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '能量级',
  `cho_ratio` decimal(8,2) NOT NULL COMMENT '碳水比例',
  `protein_ratio` decimal(8,2) NOT NULL COMMENT '蛋白质比例',
  `fat_ratio` decimal(8,2) NOT NULL COMMENT '脂肪比例',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint NOT NULL COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='饮食结构模板';

-- ----------------------------
-- Table structure for diet_template_label
-- ----------------------------
DROP TABLE IF EXISTS `diet_template_label`;
CREATE TABLE `diet_template_label` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `diet_template_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模板id',
  `label_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签id',
  `label_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方案关联标签name',
  `label_type` tinyint DEFAULT NULL COMMENT '标签类型：1适宜，2不适宜',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_diet_template_id` (`diet_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='饮食结构模板标签';

-- ----------------------------
-- Table structure for diet_template_meal
-- ----------------------------
DROP TABLE IF EXISTS `diet_template_meal`;
CREATE TABLE `diet_template_meal` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `diet_template_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模板id',
  `recommend_start_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '推荐开始时间',
  `recommend_end_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '推荐结束时间',
  `min_energy_ratio` decimal(8,2) DEFAULT NULL COMMENT '推荐最小占比',
  `max_energy_ratio` decimal(8,2) DEFAULT NULL COMMENT '推荐最大占比',
  `meal` tinyint DEFAULT NULL COMMENT '餐次 0早餐1上午加餐2午餐3下午加餐4晚餐5晚上加餐',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_diet_template_id` (`diet_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='饮食结构模板餐次';

-- ----------------------------
-- Table structure for diet_template_meal_structure
-- ----------------------------
DROP TABLE IF EXISTS `diet_template_meal_structure`;
CREATE TABLE `diet_template_meal_structure` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `diet_template_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '饮食结构模板id',
  `diet_template_meal_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '饮食结构模板餐次id',
  `meal` tinyint DEFAULT NULL COMMENT '餐次 0早餐1上午加餐2午餐3下午加餐4晚餐5晚上加餐',
  `category_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类id',
  `amount` decimal(10,4) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_diet_template_id` (`diet_template_id`),
  KEY `idx_diet_template_meal_id` (`diet_template_meal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='饮食结构模板餐次结构';

-- ----------------------------
-- Table structure for dish
-- ----------------------------
DROP TABLE IF EXISTS `dish`;
CREATE TABLE `dish` (
  `id` varchar(32) NOT NULL,
  `dish_name` varchar(64) NOT NULL COMMENT '菜肴名称',
  `pic_url` varchar(512) DEFAULT NULL COMMENT '菜肴图片链接',
  `category_id` varchar(32) DEFAULT NULL COMMENT '分类id',
  `label_id` varchar(512) DEFAULT NULL COMMENT '标签id',
  `source` int DEFAULT NULL COMMENT '来源，1：手动创建，2：模板导入，3：患者上传',
  `description` varchar(1024) DEFAULT NULL COMMENT '描述',
  `taboos` varchar(512) DEFAULT NULL COMMENT '禁忌，疾病id，多个用,分隔',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人名称',
  `update_by` varchar(32) DEFAULT NULL COMMENT '修改人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `status` int DEFAULT '1' COMMENT '状态，0：停用，1：启用',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `release_status` int DEFAULT '1' COMMENT '发布状态，1：待审核，2：已发布',
  `dish_num` bigint(8) unsigned zerofill NOT NULL AUTO_INCREMENT COMMENT '食材编码',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联id',
  `create_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `characteristic` varchar(512) DEFAULT NULL COMMENT '特性',
  `no_label_id` varchar(512) DEFAULT NULL COMMENT '禁忌标签id',
  `rejection_reason` varchar(512) DEFAULT NULL COMMENT '拒绝原因',
  `audit_date` datetime DEFAULT NULL COMMENT '审核日期',
  `audit_name` varchar(32) DEFAULT NULL COMMENT '审核人',
  `recommend_meal_id` varchar(200) DEFAULT NULL COMMENT '推荐餐次id',
  PRIMARY KEY (`id`),
  KEY `dish_num` (`dish_num`)
) ENGINE=InnoDB AUTO_INCREMENT=1474 DEFAULT CHARSET=utf8mb3 COMMENT='菜肴';

-- ----------------------------
-- Table structure for dish_composition
-- ----------------------------
DROP TABLE IF EXISTS `dish_composition`;
CREATE TABLE `dish_composition` (
  `id` varchar(32) NOT NULL,
  `dish_id` varchar(32) NOT NULL COMMENT '菜肴id',
  `food_id` varchar(32) NOT NULL COMMENT '食品id',
  `unit_id` varchar(32) DEFAULT NULL COMMENT '食品规格id',
  `amount` decimal(8,2) DEFAULT NULL COMMENT '数量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_dish_id` (`dish_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='菜肴-食品组成';

-- ----------------------------
-- Table structure for dish_label
-- ----------------------------
DROP TABLE IF EXISTS `dish_label`;
CREATE TABLE `dish_label` (
  `id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `dish_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜肴id',
  `label_id` varchar(191) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜肴关联标签id',
  `label_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜肴关联标签name',
  `label_type` tinyint(1) DEFAULT '1' COMMENT '标签类型：1适宜，2不适宜，3特性',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_dish_id` (`dish_id`),
  KEY `idx_label_id` (`label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜肴-标签关联表';

-- ----------------------------
-- Table structure for dish_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `dish_operation_log`;
CREATE TABLE `dish_operation_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `dish_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '菜肴id',
  `operation_person` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人员',
  `operation_content` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='菜肴操作记录表';

-- ----------------------------
-- Table structure for field_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `field_dictionary`;
CREATE TABLE `field_dictionary` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `field_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '字段代码',
  `field_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '字段名称',
  `field_type` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '字段类别,type表的id',
  `parent_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '父系id',
  `remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `status` int DEFAULT '1' COMMENT '状态',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建者名称',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改者名称',
  `sort` int DEFAULT NULL COMMENT '排序字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='字典表';

-- ----------------------------
-- Table structure for field_dictionary_type
-- ----------------------------
DROP TABLE IF EXISTS `field_dictionary_type`;
CREATE TABLE `field_dictionary_type` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `type_code` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类型编码',
  `type_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类型名称',
  `remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `status` int DEFAULT '1' COMMENT '状态',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建者名称',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改者名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='字典类型表';

-- ----------------------------
-- Table structure for food
-- ----------------------------
DROP TABLE IF EXISTS `food`;
CREATE TABLE `food` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `food_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '食品名称',
  `food_nickname` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食品别称',
  `pic_url` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食品图片地址',
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分类id',
  `label_id` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标签id',
  `source` int DEFAULT NULL COMMENT '来源，1：手动创建，2：模板导入，3：患者上传',
  `description` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `calories` decimal(12,2) DEFAULT NULL COMMENT '热量（千卡）',
  `gi` decimal(8,2) DEFAULT NULL COMMENT 'gi值',
  `gl` decimal(8,2) DEFAULT NULL COMMENT 'gl值',
  `taboos` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '禁忌，疾病id，多个用,分隔',
  `replace_foods` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '替换食物json',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建者名称',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改者名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `status` int DEFAULT '1' COMMENT '状态，0：停用，1：启用',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `release_status` int DEFAULT '1' COMMENT '发布状态，1：待审核，2：已发布',
  `purine` decimal(8,2) DEFAULT NULL COMMENT '嘌呤',
  `anti_inflammatory_index` decimal(8,2) DEFAULT NULL COMMENT '抗炎指数',
  `allergen_ids` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '过敏原ids',
  `label_gi` int DEFAULT NULL COMMENT '标签gi等级 1：低 2：中 3：高',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联id',
  `create_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人id',
  `rejection_reason` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '拒绝原因',
  `audit_date` datetime DEFAULT NULL COMMENT '审核日期',
  `food_num` bigint(8) unsigned zerofill NOT NULL AUTO_INCREMENT COMMENT '食材编码',
  `characteristic` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '特性',
  `no_label_id` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '禁忌标签id',
  `suit` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用疾病ID',
  `contraindications` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '禁忌药物ID',
  `audit_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '审核人',
  `pic_weight` decimal(8,2) DEFAULT NULL COMMENT '图片含量',
  `allergen_id` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '过敏原id',
  `choose_num` int DEFAULT '0' COMMENT '选择次数',
  PRIMARY KEY (`id`),
  KEY `food_num` (`food_num`)
) ENGINE=InnoDB AUTO_INCREMENT=10156 DEFAULT CHARSET=utf8mb3 COMMENT='审核日期';

-- ----------------------------
-- Table structure for food_allergen_food
-- ----------------------------
DROP TABLE IF EXISTS `food_allergen_food`;
CREATE TABLE `food_allergen_food` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食材id',
  `allergen_food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '过敏替换食材id',
  `food_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食材名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='食材过敏原食材关联表';

-- ----------------------------
-- Table structure for food_copy
-- ----------------------------
DROP TABLE IF EXISTS `food_copy`;
CREATE TABLE `food_copy` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `food_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '食品名称',
  `food_nickname` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食品别称',
  `pic_url` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食品图片地址',
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分类id',
  `label_id` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标签id',
  `source` int DEFAULT NULL COMMENT '来源，1：手动创建，2：模板导入，3：患者上传',
  `description` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `calories` decimal(12,2) DEFAULT NULL COMMENT '热量（千卡）',
  `gi` decimal(8,2) DEFAULT NULL COMMENT 'gi值',
  `gl` decimal(8,2) DEFAULT NULL COMMENT 'gl值',
  `taboos` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '禁忌，疾病id，多个用,分隔',
  `replace_foods` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '替换食物json',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建者名称',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改者名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `status` int DEFAULT '1' COMMENT '状态，0：停用，1：启用',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `release_status` int DEFAULT '1' COMMENT '发布状态，1：待审核，2：已发布',
  `purine` decimal(8,2) DEFAULT NULL COMMENT '嘌呤',
  `anti_inflammatory_index` decimal(8,2) DEFAULT NULL COMMENT '抗炎指数',
  `allergen_ids` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '过敏原ids',
  `label_gi` int DEFAULT NULL COMMENT '标签gi等级 1：低 2：中 3：高',
  `relation_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '关联id',
  `create_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人id',
  `rejection_reason` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '拒绝原因',
  `audit_date` datetime DEFAULT NULL COMMENT '审核日期',
  `food_num` bigint(8) unsigned zerofill NOT NULL AUTO_INCREMENT COMMENT '食材编码',
  `characteristic` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '特性',
  `no_label_id` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '禁忌标签id',
  `suit` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '适用疾病ID',
  `contraindications` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '禁忌药物ID',
  `audit_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '审核人',
  `pic_weight` decimal(8,2) DEFAULT NULL COMMENT '图片含量',
  `allergen_id` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '过敏原id',
  `choose_num` int DEFAULT '0' COMMENT '选择次数',
  PRIMARY KEY (`id`),
  KEY `food_num` (`food_num`)
) ENGINE=InnoDB AUTO_INCREMENT=10138 DEFAULT CHARSET=utf8mb3 COMMENT='审核日期';

-- ----------------------------
-- Table structure for food_favorite
-- ----------------------------
DROP TABLE IF EXISTS `food_favorite`;
CREATE TABLE `food_favorite` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `hug_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '蓝牛号',
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食物id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='食物收藏';

-- ----------------------------
-- Table structure for food_label
-- ----------------------------
DROP TABLE IF EXISTS `food_label`;
CREATE TABLE `food_label` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `food_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '食材id',
  `label_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '食材关联标签id',
  `label_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '食材关联标签name',
  `label_type` tinyint(1) DEFAULT '1' COMMENT '标签类型：1适宜，2不适宜，3特性，4禁忌药物，5适用疾病，6不适用疾病',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `grade` int DEFAULT NULL COMMENT '层级',
  PRIMARY KEY (`id`),
  KEY `idx_label_id` (`label_id`),
  KEY `idx_food_id` (`food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='食材-标签关联表';

-- ----------------------------
-- Table structure for food_nutrient
-- ----------------------------
DROP TABLE IF EXISTS `food_nutrient`;
CREATE TABLE `food_nutrient` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '食品id',
  `food_protein` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '蛋白质(克)',
  `food_cho` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '碳水化合物(克)',
  `food_fat` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT '脂肪(克)',
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
  `anti_inflammatory_index` decimal(8,2) DEFAULT NULL COMMENT '抗炎指数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_food_id` (`food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='食品-营养素';

-- ----------------------------
-- Table structure for food_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `food_operation_log`;
CREATE TABLE `food_operation_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食材id',
  `operation_person` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作人员',
  `operation_content` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作内容',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='食材操作记录表';

-- ----------------------------
-- Table structure for food_pic_weight
-- ----------------------------
DROP TABLE IF EXISTS `food_pic_weight`;
CREATE TABLE `food_pic_weight` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食材id',
  `pic_url` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '图片url',
  `pic_weight` decimal(8,2) DEFAULT NULL COMMENT '图片重量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='食材图片重量表';

-- ----------------------------
-- Table structure for food_unit
-- ----------------------------
DROP TABLE IF EXISTS `food_unit`;
CREATE TABLE `food_unit` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '食品id',
  `unit_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '单位名称',
  `unit_weight` decimal(12,2) DEFAULT NULL COMMENT '单位重量',
  `unit_cal` decimal(16,2) DEFAULT NULL COMMENT '单位对应热量',
  `unit_pic_url` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食品规格图片',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_food_id` (`food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='食品-度量单位';

-- ----------------------------
-- Table structure for label
-- ----------------------------
DROP TABLE IF EXISTS `label`;
CREATE TABLE `label` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `label_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '标签名称',
  `description` varchar(1200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标签说明',
  `style` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '样式',
  `parent_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分类id',
  `grade` int DEFAULT NULL COMMENT '层级',
  `status` int DEFAULT '1' COMMENT '状态 0停用 1启用',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `label_type` tinyint DEFAULT NULL COMMENT '标签类别 负向：-1  正向:1  中性:0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='标签';

-- ----------------------------
-- Table structure for nutrient_template
-- ----------------------------
DROP TABLE IF EXISTS `nutrient_template`;
CREATE TABLE `nutrient_template` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `nut_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '说明',
  `nut_protein` decimal(8,2) NOT NULL COMMENT '蛋白质(克)',
  `nut_cho` decimal(8,2) NOT NULL COMMENT '碳水化合物(克)',
  `nut_fat` decimal(8,2) NOT NULL COMMENT '脂肪(克)',
  `nut_fiber` decimal(8,2) DEFAULT NULL COMMENT '膳食纤维(克)',
  `nut_va` decimal(8,2) DEFAULT NULL COMMENT '维生素A(微克)',
  `nut_vb1` decimal(8,2) DEFAULT NULL COMMENT '维生素B1(毫克)',
  `nut_vb2` decimal(8,2) DEFAULT NULL COMMENT '维生素B2(毫克)',
  `nut_vb6` decimal(8,2) DEFAULT NULL COMMENT '维生素B6(毫克)',
  `nut_vb12` decimal(8,2) DEFAULT NULL COMMENT '维生素B12(毫克)',
  `nut_vc` decimal(8,2) DEFAULT NULL COMMENT '维生素C(毫克)',
  `nut_ve` decimal(8,2) DEFAULT NULL COMMENT '维生素E(毫克)',
  `nut_folic_acid` decimal(8,2) DEFAULT NULL COMMENT '叶酸(毫克)',
  `nut_niacin` decimal(8,2) DEFAULT NULL COMMENT '烟酸(毫克)',
  `nut_na` decimal(8,2) DEFAULT NULL COMMENT '钠(毫克)',
  `nut_p` decimal(8,2) DEFAULT NULL COMMENT '磷(毫克)',
  `nut_ca` decimal(8,2) DEFAULT NULL COMMENT '钙(毫克)',
  `nut_fe` decimal(8,2) DEFAULT NULL COMMENT '铁(毫克)',
  `nut_k` decimal(8,2) DEFAULT NULL COMMENT '钾(毫克)',
  `nut_i` decimal(8,2) DEFAULT NULL COMMENT '碘(毫克)',
  `nut_zn` decimal(8,2) DEFAULT NULL COMMENT '锌(毫克)',
  `nut_se` decimal(8,2) DEFAULT NULL COMMENT '硒(微克)',
  `nut_mg` decimal(8,2) DEFAULT NULL COMMENT '镁(毫克)',
  `nut_cu` decimal(8,2) DEFAULT NULL COMMENT '铜(毫克)',
  `nut_mn` decimal(8,2) DEFAULT NULL COMMENT '锰(毫克)',
  `nut_cholesterol` decimal(8,2) DEFAULT NULL COMMENT '胆固醇(毫克)',
  `nut_moisture` decimal(8,2) DEFAULT NULL COMMENT '水分(克)',
  `release_status` int DEFAULT '2' COMMENT '发布状态 1待审核 2已发布',
  `status` int DEFAULT '1' COMMENT '状态 0停用 1启用',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_nut_name` (`nut_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='基础库-营养素模板';

-- ----------------------------
-- Table structure for plan_allergen_deal
-- ----------------------------
DROP TABLE IF EXISTS `plan_allergen_deal`;
CREATE TABLE `plan_allergen_deal` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_diet_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '饮食方案id',
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食物id',
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '食物分类id',
  `allergen_ids` varchar(600) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '过敏原ids',
  `replace_food_ids` varchar(600) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '替换食品ids',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `remark` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='食物过敏处理表';

-- ----------------------------
-- Table structure for plan_diet
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet`;
CREATE TABLE `plan_diet` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_no` int NOT NULL AUTO_INCREMENT COMMENT '方案编号',
  `plan_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '计划名称',
  `description` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `energy_level` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '能量级',
  `cycle_recommend` tinyint(1) DEFAULT NULL COMMENT '循环推荐 0否1是',
  `release_status` int DEFAULT NULL COMMENT '状态： 0.停用,1.待提审,2.未通过,3.待审核,4.已发布',
  `not_recommended_ids` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '不推荐id',
  `status` int DEFAULT '1' COMMENT '0未启用1已启用',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `expression` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '触发表达式',
  `audit_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '审核人',
  `audit_rejection_reason` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '审核不通过原因',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `org_ids` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组织机构ids,逗号隔开',
  `version` decimal(6,1) unsigned DEFAULT '1.0' COMMENT '方案版本',
  `plan_basis` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '方案依据',
  `ref_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '引用方案id',
  `create_by_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建人id',
  `update_by_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新人id',
  `audit_by_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '审核人id',
  PRIMARY KEY (`id`),
  KEY `idx_plan_no` (`plan_no`),
  KEY `idx_release_status` (`release_status`),
  KEY `idx_plan_name` (`plan_name`)
) ENGINE=InnoDB AUTO_INCREMENT=102024 DEFAULT CHARSET=utf8mb3 COMMENT='饮食-方案';

-- ----------------------------
-- Table structure for plan_diet_copy1
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet_copy1`;
CREATE TABLE `plan_diet_copy1` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_no` int NOT NULL AUTO_INCREMENT COMMENT '方案编号',
  `plan_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '计划名称',
  `description` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `cycle_recommend` tinyint(1) DEFAULT NULL COMMENT '循环推荐 0否1是',
  `release_status` int DEFAULT NULL COMMENT '状态： 0.停用,1.待提审,2.未通过,3.待审核,4.已发布',
  `not_recommended_ids` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '不推荐id',
  `status` int DEFAULT '1' COMMENT '0未启用1已启用',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `expression` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '触发表达式',
  `audit_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '审核人',
  `audit_rejection_reason` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '审核不通过原因',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `version` decimal(6,1) unsigned DEFAULT '1.0' COMMENT '方案版本',
  `ref_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '引用方案id',
  `create_by_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建人id',
  `update_by_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新人id',
  `audit_by_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '审核人id',
  PRIMARY KEY (`id`),
  KEY `idx_plan_no` (`plan_no`),
  KEY `idx_release_status` (`release_status`),
  KEY `idx_plan_name` (`plan_name`)
) ENGINE=InnoDB AUTO_INCREMENT=100297 DEFAULT CHARSET=utf8mb3 COMMENT='饮食-方案';

-- ----------------------------
-- Table structure for plan_diet_day
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet_day`;
CREATE TABLE `plan_diet_day` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_diet_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者饮食id',
  `day` int DEFAULT NULL COMMENT '第几天',
  `recommend_range` decimal(8,2) DEFAULT NULL COMMENT '能量波动范围',
  `min_calories` decimal(8,2) DEFAULT NULL COMMENT '最小能量值',
  `max_calories` decimal(8,2) DEFAULT NULL COMMENT '最大能量值',
  `description` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '说明',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_plan_diet_id` (`plan_diet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='方案饮食第几天';

-- ----------------------------
-- Table structure for plan_diet_day_overview
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet_day_overview`;
CREATE TABLE `plan_diet_day_overview` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `day_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '饮食方案天id',
  `meal` int DEFAULT NULL COMMENT '餐次 0早餐1上午加餐2午餐3下午加餐4晚餐5晚上加餐',
  `recommend_start_time` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推荐开始时间',
  `plan_diet_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '患者饮食id',
  `recommend_end_time` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '推荐结束时间',
  `min_energy_ratio` decimal(8,2) DEFAULT NULL COMMENT '推荐最小占比',
  `max_energy_ratio` decimal(8,2) DEFAULT NULL COMMENT '推荐最大占比',
  `min_calories` decimal(8,2) DEFAULT NULL COMMENT '最小能量值',
  `max_calories` decimal(8,2) DEFAULT NULL COMMENT '最大能量值',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_day_id` (`day_id`),
  KEY `idx_plan_diet_id` (`plan_diet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='方案饮食天概';

-- ----------------------------
-- Table structure for plan_diet_disease
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet_disease`;
CREATE TABLE `plan_diet_disease` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `diet_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方案饮食id',
  `dictionary_code` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方案关联疾病code,/分隔',
  `dictionary_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方案关联疾病name',
  `grade` tinyint(1) DEFAULT '0' COMMENT '层级',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_dietid` (`diet_id`),
  KEY `idx_dictionary_code` (`dictionary_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='饮食方案-疾病关联表';

-- ----------------------------
-- Table structure for plan_diet_label
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet_label`;
CREATE TABLE `plan_diet_label` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `diet_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方案饮食id',
  `label_id` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方案关联标签id,/分隔',
  `label_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '方案关联标签name',
  `label_type` tinyint(1) DEFAULT '1' COMMENT '标签类型：1适宜，2不适宜',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_diet_id` (`diet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='饮食方案-标签关联表';

-- ----------------------------
-- Table structure for plan_diet_nutrient
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet_nutrient`;
CREATE TABLE `plan_diet_nutrient` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_diet_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '饮食方案id',
  `nut_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '营养素id',
  `diet_protein` decimal(8,2) DEFAULT NULL COMMENT '蛋白质(克)',
  `diet_cho` decimal(8,2) DEFAULT NULL COMMENT '碳水化合物(克)',
  `diet_fat` decimal(8,2) DEFAULT NULL COMMENT '脂肪(克)',
  `diet_fiber` decimal(8,2) DEFAULT NULL COMMENT '膳食纤维(克)',
  `diet_va` decimal(8,2) DEFAULT NULL COMMENT '维生素A(微克)',
  `diet_vb1` decimal(8,2) DEFAULT NULL COMMENT '维生素B1(毫克)',
  `diet_vb2` decimal(8,2) DEFAULT NULL COMMENT '维生素B2(毫克)',
  `diet_vb6` decimal(8,2) DEFAULT NULL COMMENT '维生素B6(毫克)',
  `diet_vb12` decimal(8,2) DEFAULT NULL COMMENT '维生素B12(毫克)',
  `diet_vc` decimal(8,2) DEFAULT NULL COMMENT '维生素C(毫克)',
  `diet_ve` decimal(8,2) DEFAULT NULL COMMENT '维生素E(毫克)',
  `diet_folic_acid` decimal(8,2) DEFAULT NULL COMMENT '叶酸(毫克)',
  `diet_niacin` decimal(8,2) DEFAULT NULL COMMENT '烟酸(毫克)',
  `diet_na` decimal(8,2) DEFAULT NULL COMMENT '钠(毫克)',
  `diet_p` decimal(8,2) DEFAULT NULL COMMENT '磷(毫克)',
  `diet_ca` decimal(8,2) DEFAULT NULL COMMENT '钙(毫克)',
  `diet_fe` decimal(8,2) DEFAULT NULL COMMENT '铁(毫克)',
  `diet_k` decimal(8,2) DEFAULT NULL COMMENT '钾(毫克)',
  `diet_i` decimal(8,2) DEFAULT NULL COMMENT '碘(毫克)',
  `diet_zn` decimal(8,2) DEFAULT NULL COMMENT '锌(毫克)',
  `diet_se` decimal(8,2) DEFAULT NULL COMMENT '硒(微克)',
  `diet_mg` decimal(8,2) DEFAULT NULL COMMENT '镁(毫克)',
  `diet_cu` decimal(8,2) DEFAULT NULL COMMENT '铜(毫克)',
  `diet_mn` decimal(8,2) DEFAULT NULL COMMENT '锰(毫克)',
  `diet_cholesterol` decimal(8,2) DEFAULT NULL COMMENT '胆固醇(毫克)',
  `diet_moisture` decimal(8,2) DEFAULT NULL COMMENT '水分(克)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_plan_diet_id` (`plan_diet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='方案-饮食营养素';

-- ----------------------------
-- Table structure for plan_diet_pat
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet_pat`;
CREATE TABLE `plan_diet_pat` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `module_type` int DEFAULT NULL COMMENT '0GDM，1减重，2PCOS',
  `pat_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '患者id',
  `plan_no` int NOT NULL AUTO_INCREMENT COMMENT '方案编号',
  `plan_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '' COMMENT '计划名称',
  `description` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `energy_level` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '能量级',
  `cycle_recommend` tinyint(1) DEFAULT NULL COMMENT '循环推荐 0否1是',
  `release_status` int DEFAULT NULL COMMENT '状态： 0.停用,1.待提审,2.未通过,3.待审核,4.已发布',
  `not_recommended_ids` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '不推荐id',
  `status` int DEFAULT '1' COMMENT '0未启用1已启用',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `expression` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '触发表达式',
  `audit_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '审核人',
  `audit_rejection_reason` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '审核不通过原因',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `org_ids` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组织机构ids,逗号隔开',
  `version` decimal(6,1) unsigned DEFAULT '1.0' COMMENT '方案版本',
  `plan_basis` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '方案依据',
  `ref_plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '引用方案id',
  `create_by_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '创建人id',
  `update_by_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '更新人id',
  `audit_by_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '' COMMENT '审核人id',
  PRIMARY KEY (`id`),
  KEY `idx_plan_no` (`plan_no`),
  KEY `idx_release_status` (`release_status`),
  KEY `idx_plan_name` (`plan_name`),
  KEY `idx_pat_id` (`pat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112325 DEFAULT CHARSET=utf8mb3 COMMENT='饮食-方案';

-- ----------------------------
-- Table structure for plan_diet_recipe
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet_recipe`;
CREATE TABLE `plan_diet_recipe` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_diet_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '方案饮食id',
  `day_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '第几天主键',
  `meal` int DEFAULT NULL COMMENT '餐次',
  `dish_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '菜肴id',
  `food_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '食物id',
  `unit_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '单位id',
  `unit_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '单位名称',
  `amount` decimal(8,2) DEFAULT NULL COMMENT '数量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_day_id` (`day_id`),
  KEY `idx_plan_diet_id` (`plan_diet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='方案-饮食食谱';

-- ----------------------------
-- Table structure for plan_diet_structure
-- ----------------------------
DROP TABLE IF EXISTS `plan_diet_structure`;
CREATE TABLE `plan_diet_structure` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `plan_diet_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '方案饮食id',
  `meal` int DEFAULT NULL COMMENT '餐次 0早餐1上午加餐2午餐3下午加餐4晚餐5晚上加餐',
  `category_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '分类id',
  `amount` decimal(10,4) DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  KEY `idx_plan_diet_id` (`plan_diet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='方案饮食结构';

-- ----------------------------
-- Table structure for plan_exception_deal
-- ----------------------------
DROP TABLE IF EXISTS `plan_exception_deal`;
CREATE TABLE `plan_exception_deal` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `type` int DEFAULT NULL COMMENT '方案类型 0饮食1运动2监测',
  `plan_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划id',
  `is_immediately_remind` int DEFAULT '0' COMMENT '是否立即提醒0 否 1 是',
  `is_concurrently_remind` int DEFAULT '0' COMMENT '是否同时提醒 0 否 1 是',
  `remind_start_time` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒开始时间',
  `remind_end_time` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒结束时间',
  `remind_recipient` int DEFAULT NULL COMMENT '提醒接收者 0患者1医生2健管师',
  `remind_type` int DEFAULT NULL COMMENT '提醒形式 0文字1复诊2宣教',
  `remind_send_type` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒发送方式 0AI 1APP 2 微信 3短信 多个用,隔开',
  `remind_content` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '提醒内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='方案异常处理表';

-- ----------------------------
-- Table structure for plan_monitor
-- ----------------------------
DROP TABLE IF EXISTS `plan_monitor`;
CREATE TABLE `plan_monitor` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `plan_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '方案名称',
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '说明',
  `cycle_recommend` tinyint(1) DEFAULT '0' COMMENT '循环推荐 0否1是',
  `release_status` int DEFAULT NULL COMMENT '发布状态 1待审核 2已发布',
  `status` int DEFAULT '1' COMMENT '状态 0停用 1启用',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '更新人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `expression` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '触发表达式',
  `scheme_basis` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '方案依据',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='方案-监测';

-- ----------------------------
-- Table structure for plan_monitor_body_round
-- ----------------------------
DROP TABLE IF EXISTS `plan_monitor_body_round`;
CREATE TABLE `plan_monitor_body_round` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `monitor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '方案-监测id',
  `monitor_count` int DEFAULT NULL COMMENT '监测次数',
  `monitor_count_unit` int DEFAULT NULL COMMENT '监测次数单位 0天/次 1周/次 2月/次 3年/次',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `week_detail` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '星期几 数字几代表周几 多个用 ，隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='方案-监测体围';

-- ----------------------------
-- Table structure for plan_monitor_body_temperature
-- ----------------------------
DROP TABLE IF EXISTS `plan_monitor_body_temperature`;
CREATE TABLE `plan_monitor_body_temperature` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `monitor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '方案-监测id',
  `monitor_count` int DEFAULT NULL COMMENT '监测次数',
  `monitor_count_unit` int DEFAULT NULL COMMENT '监测次数单位 0天/次 1周/次 2月/次 3年/次',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `week_detail` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '星期几 数字几代表周几 多个用 ，隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='方案-监测体温';

-- ----------------------------
-- Table structure for plan_monitor_drainage_tube
-- ----------------------------
DROP TABLE IF EXISTS `plan_monitor_drainage_tube`;
CREATE TABLE `plan_monitor_drainage_tube` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `monitor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '方案-监测id',
  `monitor_count` int DEFAULT NULL COMMENT '监测次数',
  `monitor_count_unit` int DEFAULT NULL COMMENT '监测次数单位 0天/次 1周/次 2月/次 3年/次',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `week_detail` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '星期几 数字几代表周几 多个用 ，隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='方案-监测引流管';

-- ----------------------------
-- Table structure for plan_monitor_ovulation
-- ----------------------------
DROP TABLE IF EXISTS `plan_monitor_ovulation`;
CREATE TABLE `plan_monitor_ovulation` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `monitor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '方案-监测id',
  `monitor_count` int DEFAULT NULL COMMENT '监测次数',
  `monitor_count_unit` int DEFAULT NULL COMMENT '监测次数单位 0天/次 1周/次 2月/次 3年/次',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `week_detail` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '星期几 数字几代表周几 多个用 ，隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='方案-监测排卵';

-- ----------------------------
-- Table structure for plan_monitor_pressure
-- ----------------------------
DROP TABLE IF EXISTS `plan_monitor_pressure`;
CREATE TABLE `plan_monitor_pressure` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `monitor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '方案-监测id',
  `monitor_count` int DEFAULT NULL COMMENT '监测次数',
  `monitor_count_unit` int DEFAULT NULL COMMENT '监测次数单位 0天/次 1周/次 2月/次 3年/次',
  `measuring_point` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '监测点0凌晨1早餐前2早餐后3午餐前4午餐后5晚餐前6晚餐后7睡前',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `week_detail` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '星期几 数字几代表周几 多个用 ，隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='方案-监测血压';

-- ----------------------------
-- Table structure for plan_monitor_sugar
-- ----------------------------
DROP TABLE IF EXISTS `plan_monitor_sugar`;
CREATE TABLE `plan_monitor_sugar` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `monitor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '方案-监测id',
  `monitor_count` int DEFAULT NULL COMMENT '监测次数',
  `monitor_count_unit` int DEFAULT NULL COMMENT '监测次数单位 0天/次 1周/次 2月/次 3年/次',
  `measuring_point` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '监测点0凌晨1早餐前2早餐后3午餐前4午餐后5晚餐前6晚餐后7睡前',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `week_detail` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '星期几 数字几代表周几 多个用 ，隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='方案-监测血糖';

-- ----------------------------
-- Table structure for plan_monitor_weight
-- ----------------------------
DROP TABLE IF EXISTS `plan_monitor_weight`;
CREATE TABLE `plan_monitor_weight` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `monitor_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '方案-监测id',
  `monitor_count` int DEFAULT NULL COMMENT '监测次数',
  `monitor_count_unit` int DEFAULT NULL COMMENT '监测次数单位 0天/次 1周/次 2月/次 3年/次',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `week_detail` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '星期几 数字几代表周几 多个用 ，隔开',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='方案-监测体重';

-- ----------------------------
-- Table structure for t_food_nut_standard
-- ----------------------------
DROP TABLE IF EXISTS `t_food_nut_standard`;
CREATE TABLE `t_food_nut_standard` (
  `id` bigint NOT NULL COMMENT '主键id',
  `category_id` tinyint NOT NULL COMMENT '类别',
  `unit_weight` decimal(8,2) NOT NULL COMMENT '标准重量',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '创建人',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '修改人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0否 1是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='营养素标准';

SET FOREIGN_KEY_CHECKS = 1;
