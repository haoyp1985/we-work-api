/*
 Navicat MySQL Data Transfer

 Source Server         : 健海测试-3
 Source Server Type    : MySQL
 Source Server Version : 50616
 Source Host           : rm-bp1rlhj38wp2e6h135o.mysql.rds.aliyuncs.com:3306
 Source Schema         : jianhaihug

 Target Server Type    : MySQL
 Target Server Version : 50616
 File Encoding         : 65001

 Date: 16/07/2025 17:47:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for databasechangelog
-- ----------------------------
DROP TABLE IF EXISTS `databasechangelog`;
CREATE TABLE `databasechangelog` (
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
-- Table structure for databasechangeloglock
-- ----------------------------
DROP TABLE IF EXISTS `databasechangeloglock`;
CREATE TABLE `databasechangeloglock` (
  `ID` int(11) NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for ids
-- ----------------------------
DROP TABLE IF EXISTS `ids`;
CREATE TABLE `ids` (
  `id` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for medical_report_shorturl
-- ----------------------------
DROP TABLE IF EXISTS `medical_report_shorturl`;
CREATE TABLE `medical_report_shorturl` (
  `id` varchar(6) NOT NULL COMMENT '短链主键',
  `medical_report_id` varchar(32) DEFAULT NULL COMMENT '体检号',
  `mobile` varchar(12) DEFAULT NULL COMMENT '体检人手机号',
  `name` varchar(50) DEFAULT NULL COMMENT '体检人姓名',
  `abnormal_info` varchar(500) DEFAULT NULL COMMENT '体检异常信息',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_arteriosclerosis_abi_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_arteriosclerosis_abi_forth`;
CREATE TABLE `mk_advice_arteriosclerosis_abi_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `left_min_abi` double DEFAULT NULL COMMENT '左侧abi下限',
  `left_max_abi` double DEFAULT NULL COMMENT '左侧abi上限',
  `right_min_abi` double DEFAULT NULL COMMENT '右侧abi下限',
  `right_max_abi` double DEFAULT NULL COMMENT '右侧abi上限',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_evaluate` varchar(200) DEFAULT NULL COMMENT '专家评估',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_arteriosclerosis_bv_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_arteriosclerosis_bv_forth`;
CREATE TABLE `mk_advice_arteriosclerosis_bv_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `min_bv` double DEFAULT NULL COMMENT '血液在体流动性指数下限',
  `max_bv` double DEFAULT NULL COMMENT '血液在体流动性指数上限',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_blood_fat_complex_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_blood_fat_complex_forth`;
CREATE TABLE `mk_advice_blood_fat_complex_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `min_chol_val` double DEFAULT NULL COMMENT '总胆固醇下限',
  `max_chol_val` double DEFAULT NULL COMMENT '总胆固醇上限',
  `min_trig_val` double DEFAULT NULL COMMENT '甘油三脂下限',
  `max_trig_val` double DEFAULT NULL COMMENT '甘油三脂上限',
  `min_hdl_chol_val` double DEFAULT NULL COMMENT '高密度脂蛋白下限',
  `max_hdl_chol_val` double DEFAULT NULL COMMENT '高密度脂蛋白上限',
  `min_ldl_chol_val` double DEFAULT NULL COMMENT '低密度脂蛋白下限',
  `max_ldl_chol_val` double DEFAULT NULL COMMENT '低密度脂蛋白上限',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_bmi_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_bmi_forth`;
CREATE TABLE `mk_advice_bodycomposition_bmi_forth` (
  `id` int(36) NOT NULL COMMENT '主键',
  `states` varchar(10) DEFAULT NULL COMMENT '状态',
  `race` varchar(1) DEFAULT NULL COMMENT '人种(1:亚洲人群 2：西方人群)',
  `min_age` int(11) DEFAULT NULL COMMENT '年龄下限',
  `max_age` int(11) DEFAULT NULL COMMENT '年龄上限',
  `min_bmi` double DEFAULT NULL COMMENT 'bmi下限',
  `max_bmi` double DEFAULT NULL COMMENT 'bmi上限',
  `doc_tip` varchar(500) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_bodyfat_percent_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_bodyfat_percent_forth`;
CREATE TABLE `mk_advice_bodycomposition_bodyfat_percent_forth` (
  `id` varchar(36) NOT NULL COMMENT '体脂肪百分比主键id',
  `gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `min_fat_val` double DEFAULT NULL COMMENT '体脂肪百分比下限',
  `max_fat_val` double DEFAULT NULL COMMENT '体脂肪百分比上限',
  `state` varchar(10) DEFAULT NULL COMMENT '状态：偏瘦、正常、超重等',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_fat_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_fat_forth`;
CREATE TABLE `mk_advice_bodycomposition_fat_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `min_fat` double DEFAULT NULL COMMENT '脂肪下限',
  `max_fat` double DEFAULT NULL COMMENT '脂肪上限',
  `level` varchar(20) DEFAULT NULL COMMENT '等级',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_muscle_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_muscle_forth`;
CREATE TABLE `mk_advice_bodycomposition_muscle_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `min_age` int(11) DEFAULT NULL COMMENT '年龄下限',
  `max_age` int(11) DEFAULT NULL COMMENT '年龄上限',
  `min_muscle` double DEFAULT NULL COMMENT '肌肉量下限',
  `max_muscle` double DEFAULT NULL COMMENT '肌肉量上限',
  `states` varchar(20) DEFAULT NULL COMMENT '状态',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_nutrition_bodyfat_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_nutrition_bodyfat_forth`;
CREATE TABLE `mk_advice_bodycomposition_nutrition_bodyfat_forth` (
  `id` varchar(36) NOT NULL COMMENT '营养分析-体内脂肪含量主键',
  `min_age` int(11) DEFAULT NULL COMMENT '年龄下限',
  `max_age` int(11) DEFAULT NULL COMMENT '年龄上限',
  `min_fat_val` double DEFAULT NULL COMMENT '脂肪含量下限',
  `max_fat_val` double DEFAULT NULL COMMENT '脂肪含量上限',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_protein_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_protein_forth`;
CREATE TABLE `mk_advice_bodycomposition_protein_forth` (
  `id` varchar(36) NOT NULL COMMENT '蛋白质含量主键',
  `min_age` int(11) DEFAULT NULL COMMENT '年龄下限',
  `max_age` int(11) DEFAULT NULL COMMENT '年龄上限',
  `min_protein_val` double DEFAULT NULL COMMENT '蛋白质含量下限',
  `max_protein_val` double DEFAULT NULL COMMENT '蛋白质含量上限',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活试建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_salt_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_salt_forth`;
CREATE TABLE `mk_advice_bodycomposition_salt_forth` (
  `id` varchar(36) NOT NULL COMMENT '营养分析-无机盐含量主键',
  `min_salt_ratio` double DEFAULT NULL COMMENT '无机盐含量占体重的比下限',
  `max_salt_ratio` double DEFAULT NULL COMMENT '无机盐含量占体重的比上限',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_score_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_score_forth`;
CREATE TABLE `mk_advice_bodycomposition_score_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `min_score` int(11) DEFAULT NULL COMMENT '分数下限',
  `max_score` int(11) DEFAULT NULL COMMENT '分数上限',
  `doc_tip` varchar(50) DEFAULT NULL COMMENT '专家评估',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_visceralfat_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_visceralfat_forth`;
CREATE TABLE `mk_advice_bodycomposition_visceralfat_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `min_visceralfat` double DEFAULT NULL COMMENT '内脏脂肪指数下限',
  `max_visceralfat` double DEFAULT NULL COMMENT '内脏脂肪指数上限',
  `level` varchar(30) DEFAULT NULL COMMENT '等级',
  `notice` varchar(200) DEFAULT NULL COMMENT '注意事项',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_waist_butt_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_waist_butt_forth`;
CREATE TABLE `mk_advice_bodycomposition_waist_butt_forth` (
  `id` varchar(36) NOT NULL COMMENT '腰臀比主键id',
  `gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `min_waist_butt_ratio` double DEFAULT NULL COMMENT '腰臀比下限',
  `max_waist_butt_ratio` double DEFAULT NULL COMMENT '腰臀比上限',
  `property` varchar(10) DEFAULT NULL COMMENT '属性',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bodycomposition_water_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bodycomposition_water_forth`;
CREATE TABLE `mk_advice_bodycomposition_water_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `min_age` int(11) DEFAULT NULL COMMENT '年龄下限',
  `max_age` int(11) DEFAULT NULL COMMENT '年龄上限',
  `min_water` double DEFAULT NULL COMMENT '水分率下限',
  `max_water` double DEFAULT NULL COMMENT '水分率上限',
  `states` varchar(20) DEFAULT NULL COMMENT '状态',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bone_tvalue_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bone_tvalue_forth`;
CREATE TABLE `mk_advice_bone_tvalue_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `min_tvalue` double DEFAULT NULL COMMENT 'T值下限',
  `max_tvalue` double DEFAULT NULL COMMENT 'T值上限',
  `bone_quality` varchar(20) DEFAULT NULL COMMENT '骨质质量',
  `doc_tip` varchar(2000) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_bone_zvalue_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_bone_zvalue_forth`;
CREATE TABLE `mk_advice_bone_zvalue_forth` (
  `id` varchar(36) NOT NULL COMMENT '主键',
  `min_zvalue` double DEFAULT NULL COMMENT 'Z值下限',
  `max_zvalue` double DEFAULT NULL COMMENT 'Z值上限',
  `bone_level` varchar(20) DEFAULT NULL COMMENT '等级',
  `doc_tip` varchar(2000) DEFAULT NULL COMMENT '专家提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '专家建议编码',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议编码',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心理建议编码',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议编码',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议编码',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mk_advice_lungs_forth
-- ----------------------------
DROP TABLE IF EXISTS `mk_advice_lungs_forth`;
CREATE TABLE `mk_advice_lungs_forth` (
  `id` varchar(36) NOT NULL COMMENT '肺功能建议id-第四版',
  `fvc_min` double DEFAULT NULL COMMENT '用力肺活量下限forced vital capacity;FVC;',
  `fvc_max` double DEFAULT NULL COMMENT '用力肺活量下限forced vital capacity;FVC;',
  `rate_min` double DEFAULT NULL COMMENT '一秒率下限',
  `rate_max` double DEFAULT NULL COMMENT '一秒率上限',
  `states` varchar(100) DEFAULT NULL COMMENT '简单提示状态',
  `doc_tip` varchar(200) DEFAULT NULL COMMENT '医生建议提示',
  `doc_sug` varchar(10) DEFAULT NULL COMMENT '医生建议',
  `doc_diet` varchar(10) DEFAULT NULL COMMENT '膳食建议',
  `doc_sport` varchar(10) DEFAULT NULL COMMENT '运动建议',
  `doc_mental` varchar(10) DEFAULT NULL COMMENT '心里建议',
  `doc_lifestyle` varchar(10) DEFAULT NULL COMMENT '生活方式建议',
  `dr` varchar(1) DEFAULT NULL COMMENT '是否删除，0-未删除，1-已删除',
  `memo` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_articlescrap
-- ----------------------------
DROP TABLE IF EXISTS `t_articlescrap`;
CREATE TABLE `t_articlescrap` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `title` varchar(50) DEFAULT NULL,
  `keywords` varchar(500) DEFAULT NULL,
  `content` text,
  `original_content` text NOT NULL,
  `short_desc` varchar(500) DEFAULT NULL,
  `c_update` bigint(19) DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `image` varchar(32) DEFAULT NULL,
  `type_id` varchar(32) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `click_count` int(2) DEFAULT '0' COMMENT '健康知识点击量 默认为0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Table structure for t_baby_birth_record
-- ----------------------------
DROP TABLE IF EXISTS `t_baby_birth_record`;
CREATE TABLE `t_baby_birth_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `baby_birth_time` varchar(32) DEFAULT NULL COMMENT '宝宝出生时间',
  `baby_birth_addr` varchar(96) DEFAULT NULL COMMENT '出生地点',
  `delivery_organization` varchar(96) DEFAULT NULL COMMENT '接生机构',
  `baby_birth_gestation` int(11) DEFAULT NULL COMMENT '出生孕周',
  `baby_birth_weight` double DEFAULT NULL COMMENT '宝宝出生体重',
  `baby_height` double DEFAULT NULL COMMENT '宝宝身长',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宝宝出生记录';

-- ----------------------------
-- Table structure for t_baby_info
-- ----------------------------
DROP TABLE IF EXISTS `t_baby_info`;
CREATE TABLE `t_baby_info` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(20) NOT NULL COMMENT '儿童姓名',
  `sex` int(11) NOT NULL COMMENT '宝宝性别,1:男2：女',
  `birth_time` date NOT NULL COMMENT '出生日期',
  `parity` int(11) NOT NULL COMMENT '胎次',
  `birth_certificate` varchar(20) NOT NULL COMMENT '出生医学证明号',
  `id_card` varchar(20) NOT NULL COMMENT '身份证号',
  `registered_residence_code` varchar(20) NOT NULL COMMENT '户口所在地代码',
  `registered_residence_province` varchar(50) NOT NULL COMMENT '户口所在地省',
  `registered_residence_city` varchar(50) NOT NULL COMMENT '户口市',
  `registered_residence_country` varchar(50) NOT NULL COMMENT '户口所在地区',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_baby_mark
-- ----------------------------
DROP TABLE IF EXISTS `t_baby_mark`;
CREATE TABLE `t_baby_mark` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `baby_name_origin` varchar(960) DEFAULT NULL COMMENT '宝贝姓名来历',
  `parents_message` varchar(960) DEFAULT NULL COMMENT '爸爸妈妈寄语',
  `baby_handprint_picture_url` varchar(255) DEFAULT NULL COMMENT '宝贝小手印',
  `baby_footprint_picture_url` varchar(255) DEFAULT NULL COMMENT '宝贝小脚印',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息id',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宝宝印记';

-- ----------------------------
-- Table structure for t_baby_tooth_date_record
-- ----------------------------
DROP TABLE IF EXISTS `t_baby_tooth_date_record`;
CREATE TABLE `t_baby_tooth_date_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `start_teeth_month` double DEFAULT NULL COMMENT '开始长牙月龄',
  `one_teeth_date` varchar(32) DEFAULT NULL COMMENT '一号牙',
  `two_teeth_date` varchar(32) DEFAULT NULL COMMENT '二号牙',
  `three_teeth_date` varchar(32) DEFAULT NULL COMMENT '三号牙',
  `four_teeth_date` varchar(32) DEFAULT NULL COMMENT '四号牙',
  `five_teeth_date` varchar(32) DEFAULT NULL COMMENT '五号牙',
  `six_teeth_date` varchar(32) DEFAULT NULL COMMENT '六号牙',
  `seven_teeth_date` varchar(32) DEFAULT NULL COMMENT '七号牙',
  `eight_teeth_date` varchar(32) DEFAULT NULL COMMENT '八号牙',
  `nine_teeth_date` varchar(32) DEFAULT NULL COMMENT '九号牙',
  `ten_teeth_date` varchar(32) DEFAULT NULL COMMENT '十号牙',
  `eleven_teeth_date` varchar(32) DEFAULT NULL COMMENT '十一号牙',
  `twelve_teeth_date` varchar(32) DEFAULT NULL COMMENT '十二号牙',
  `thirteen_teeth_date` varchar(32) DEFAULT NULL COMMENT '十三号牙',
  `fourteen_teeth_date` varchar(32) DEFAULT NULL COMMENT '十四号牙',
  `fifteen_teeth_date` varchar(32) DEFAULT NULL COMMENT '十五号牙',
  `sixteen_teeth_date` varchar(32) DEFAULT NULL COMMENT '十六号牙',
  `seventeen_teeth_date` varchar(32) DEFAULT NULL COMMENT '十七号牙',
  `eighteen_teeth_date` varchar(32) DEFAULT NULL COMMENT '十八号牙',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宝宝出牙日期记录';

-- ----------------------------
-- Table structure for t_call_record
-- ----------------------------
DROP TABLE IF EXISTS `t_call_record`;
CREATE TABLE `t_call_record` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '机构代码',
  `user_id` varchar(32) DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(50) DEFAULT NULL COMMENT '用户姓名',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '用户科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '用户科室名称',
  `patient_id` varchar(50) DEFAULT NULL COMMENT '患者ID(住院号/门诊号)',
  `patient_name` varchar(50) DEFAULT NULL COMMENT '患者姓名',
  `patient_idcard` varchar(18) DEFAULT NULL COMMENT '患者身份证号',
  `patient_mobile` varchar(15) DEFAULT NULL COMMENT '患者手机号',
  `start_time` varchar(20) DEFAULT NULL COMMENT '通话开始时间',
  `end_time` varchar(20) DEFAULT NULL COMMENT '通话结束时间',
  `call_type` int(11) DEFAULT NULL COMMENT '呼叫类型(1:外线呼入 2:内部呼出)',
  `call_status` int(11) DEFAULT NULL COMMENT '接通状态(1:已接通 2:未接通 3:正在通话中)',
  `talk_time` varchar(50) DEFAULT NULL COMMENT '通话时长',
  `file_field` varchar(500) DEFAULT NULL COMMENT '录音文件地址',
  `mobile_from` varchar(50) DEFAULT NULL COMMENT '号码归属地',
  `task_id` varchar(32) DEFAULT NULL COMMENT '随访任务ID',
  `show_status` int(11) DEFAULT '1' COMMENT '呼叫管理我的通话显示标识(1:显示 0:不显示)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  `relation_type` int(11) DEFAULT NULL COMMENT '关联类型：1、领先科技',
  `relation_id` varchar(45) DEFAULT NULL COMMENT '关联id',
  `call_mode` int(11) DEFAULT '1' COMMENT '通话模式(1、普通通话 2、AI语音通话)',
  `call_record_status` int(11) DEFAULT NULL COMMENT '通话状态(取下拉字典表)',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '计划id',
  `plan_name` varchar(200) DEFAULT NULL COMMENT '计划名称',
  `patient_age` int(11) DEFAULT NULL COMMENT '患者年龄',
  `patient_sex` int(11) DEFAULT NULL COMMENT '患者性别',
  `form_id` varchar(4000) DEFAULT NULL COMMENT '表单ids，用,分隔',
  `form_name` varchar(4000) DEFAULT NULL COMMENT '表单名称，用,分隔',
  `oss_path` varchar(150) DEFAULT NULL COMMENT 'oss地址',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '医院名称',
  `success_flag` int(1) DEFAULT NULL COMMENT '成功标识 0不成功 1成功',
  `error_code` varchar(10) DEFAULT NULL COMMENT '错误代码',
  `error_name` varchar(200) DEFAULT NULL COMMENT '错误描述',
  PRIMARY KEY (`id`),
  KEY `idx_hosp_code` (`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通话记录表';

-- ----------------------------
-- Table structure for t_cash
-- ----------------------------
DROP TABLE IF EXISTS `t_cash`;
CREATE TABLE `t_cash` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛医生号',
  `name` varchar(50) DEFAULT NULL COMMENT '医生姓名',
  `opera_name2` varchar(50) DEFAULT NULL COMMENT '操作管理员',
  `opera_time2` bigint(19) DEFAULT NULL COMMENT '打款员操作时间',
  `money` int(11) DEFAULT NULL COMMENT '金额',
  `apply_time` bigint(19) DEFAULT NULL COMMENT '申请时间',
  `opera_name` varchar(50) DEFAULT NULL COMMENT '操作管理员（客户端隐藏）',
  `opera_time` bigint(19) DEFAULT NULL COMMENT '管理员操作时间',
  `status` int(2) DEFAULT NULL COMMENT '操作结果 0 初始化 1 已经审核，2已经打款  -1 失败打回 -2审核未通过',
  `apply_refuse_reason` varchar(500) DEFAULT NULL COMMENT '审核不通过原因',
  `faile_reason` varchar(500) DEFAULT NULL COMMENT '打款失败原因',
  `card_type` int(2) DEFAULT NULL COMMENT '银行卡类型',
  `bank_card` varchar(50) DEFAULT NULL COMMENT '银行卡号（隐藏信息）',
  `bname` varchar(50) DEFAULT NULL COMMENT '卡持有人',
  `subbranch` varchar(200) DEFAULT NULL COMMENT '支行',
  `money_cash` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_charge
-- ----------------------------
DROP TABLE IF EXISTS `t_charge`;
CREATE TABLE `t_charge` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hug_id` varchar(32) DEFAULT NULL,
  `dr_hug_id` varchar(32) DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  `create_time` bigint(19) DEFAULT NULL,
  `tuifei_time` bigint(19) DEFAULT NULL,
  `money` int(11) DEFAULT NULL,
  `ping_id` varchar(32) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `url` text,
  `nick` varchar(50) DEFAULT NULL,
  `dr_name` varchar(50) DEFAULT NULL,
  `type` int(1) DEFAULT NULL COMMENT '支付类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_chat_record
-- ----------------------------
DROP TABLE IF EXISTS `t_chat_record`;
CREATE TABLE `t_chat_record` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hug_id` varchar(32) DEFAULT NULL,
  `dr_hug_id` varchar(32) DEFAULT NULL,
  `zx_id` varchar(32) DEFAULT NULL,
  `chat_time` varchar(50) DEFAULT NULL,
  `type` int(1) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='弃用';

-- ----------------------------
-- Table structure for t_chat_records
-- ----------------------------
DROP TABLE IF EXISTS `t_chat_records`;
CREATE TABLE `t_chat_records` (
  `chat_id` varchar(32) NOT NULL COMMENT '主键',
  `hug_id` varchar(16) DEFAULT NULL COMMENT '蓝牛号',
  `target_hug_id` varchar(16) DEFAULT NULL COMMENT '目标蓝牛号',
  `chat_type` int(1) DEFAULT NULL COMMENT '聊天类型 1好友聊天2粉丝聊天',
  `msg_type` int(1) DEFAULT NULL COMMENT '消息类型 0图片1音频2视频3文字',
  `content` varchar(1024) DEFAULT NULL COMMENT '聊天内容',
  `msg_id` varchar(32) DEFAULT NULL COMMENT '多媒体主键',
  `first_image` varchar(32) DEFAULT NULL COMMENT '首帧图',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `group_id` varchar(32) DEFAULT NULL COMMENT '关联t_consult_charge group_id 用于关联哪次咨询',
  PRIMARY KEY (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='聊天记录';

-- ----------------------------
-- Table structure for t_checkme_user
-- ----------------------------
DROP TABLE IF EXISTS `t_checkme_user`;
CREATE TABLE `t_checkme_user` (
  `hug_id` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '用户蓝牛号id',
  `checkme_user_id` varchar(255) DEFAULT NULL COMMENT '编号',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_chronic_dic_hospcode_orgcode
-- ----------------------------
DROP TABLE IF EXISTS `t_chronic_dic_hospcode_orgcode`;
CREATE TABLE `t_chronic_dic_hospcode_orgcode` (
  `org_code` varchar(50) NOT NULL COMMENT '机构代码',
  `org_name` varchar(255) DEFAULT NULL COMMENT '机构名称',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `hosp_name` varchar(255) DEFAULT NULL COMMENT '医院名称',
  PRIMARY KEY (`org_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_chronic_service_packages
-- ----------------------------
DROP TABLE IF EXISTS `t_chronic_service_packages`;
CREATE TABLE `t_chronic_service_packages` (
  `id` varchar(100) NOT NULL,
  `crowd` varchar(255) DEFAULT NULL COMMENT '适用人群',
  `significance` varchar(255) DEFAULT NULL COMMENT '套餐意义',
  `price` double DEFAULT NULL COMMENT '套餐服务价格',
  `service_time` varchar(255) DEFAULT NULL COMMENT '服务期限',
  `main_item` varchar(255) DEFAULT NULL COMMENT '主要项目',
  `contents` text COMMENT '套餐内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='服务套餐';

-- ----------------------------
-- Table structure for t_chronic_team
-- ----------------------------
DROP TABLE IF EXISTS `t_chronic_team`;
CREATE TABLE `t_chronic_team` (
  `id` varchar(100) NOT NULL,
  `name` varchar(255) DEFAULT NULL COMMENT '团队名称',
  `image_id` varchar(50) DEFAULT NULL COMMENT '团队图片',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院代码',
  `hosp_name` varchar(255) DEFAULT NULL COMMENT '医院名称',
  `dept_code` varchar(50) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(255) DEFAULT NULL COMMENT '科室名称',
  `leader_hug_id` varchar(50) DEFAULT NULL COMMENT '医生负责人hug_id',
  `leader_name` varchar(255) DEFAULT NULL COMMENT '医生负责人姓名',
  `trait` text COMMENT '团队特点',
  `remarks` text COMMENT '团队简介',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `score` double DEFAULT NULL COMMENT '评分',
  `fans` int(11) DEFAULT NULL COMMENT '粉丝数',
  `services` varchar(100) DEFAULT NULL COMMENT '服务类型',
  `topic_id` varchar(255) DEFAULT NULL COMMENT '资讯分类ID',
  `topic_name` varchar(255) DEFAULT NULL COMMENT '资讯分类名称',
  `service_package_id` varchar(255) DEFAULT NULL COMMENT '服务套餐ID',
  `service_package_name` varchar(255) DEFAULT NULL COMMENT '服务套餐名称',
  `is_delete` int(11) DEFAULT NULL COMMENT '删除 0:未删除 1:已删除',
  `group_id` varchar(100) DEFAULT NULL COMMENT '群聊分組ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健管团队列表';

-- ----------------------------
-- Table structure for t_chronic_team_members
-- ----------------------------
DROP TABLE IF EXISTS `t_chronic_team_members`;
CREATE TABLE `t_chronic_team_members` (
  `id` varchar(100) NOT NULL,
  `team_id` varchar(100) DEFAULT NULL COMMENT '团队ID',
  `hug_id` varchar(255) DEFAULT NULL COMMENT '成员hug_id',
  `name` varchar(255) DEFAULT NULL COMMENT '成员姓名',
  `type` int(11) DEFAULT NULL COMMENT '成员类别',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队成员列表';

-- ----------------------------
-- Table structure for t_chronic_user_concern_diseases
-- ----------------------------
DROP TABLE IF EXISTS `t_chronic_user_concern_diseases`;
CREATE TABLE `t_chronic_user_concern_diseases` (
  `id` varchar(100) NOT NULL,
  `hug_id` varchar(255) DEFAULT NULL COMMENT '成员hug_id',
  `disease_name` varchar(1000) DEFAULT NULL COMMENT '疾病名称',
  `disease_id` varchar(1000) DEFAULT NULL COMMENT '疾病ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者所关注的疾病';

-- ----------------------------
-- Table structure for t_cloud_hosp_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_cloud_hosp_relation`;
CREATE TABLE `t_cloud_hosp_relation` (
  `id` varchar(32) NOT NULL,
  `cloud_code` varchar(32) DEFAULT NULL COMMENT '云医院编码',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='云医院医院关联表';

-- ----------------------------
-- Table structure for t_common_param
-- ----------------------------
DROP TABLE IF EXISTS `t_common_param`;
CREATE TABLE `t_common_param` (
  `id` varchar(64) NOT NULL COMMENT '参数ID',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `module` varchar(20) NOT NULL COMMENT '模块',
  `name` varchar(50) DEFAULT NULL COMMENT '参数名称',
  `param_code` varchar(40) NOT NULL DEFAULT '' COMMENT '参数代码',
  `value1` varchar(512) DEFAULT NULL COMMENT '值1',
  `value2` varchar(512) DEFAULT NULL COMMENT '值2',
  `value3` varchar(100) DEFAULT NULL COMMENT '值3',
  `value4` text,
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(50) DEFAULT NULL COMMENT '备注',
  `status` tinyint(4) NOT NULL COMMENT '状态:0无效,1有效',
  `channel` tinyint(4) DEFAULT NULL COMMENT '渠道:1服务器,2手机功能,3手机提示,4服务器和手机通用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `common_unique` (`hosp_code`,`module`,`param_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='通用参数表';

-- ----------------------------
-- Table structure for t_cons_statistics
-- ----------------------------
DROP TABLE IF EXISTS `t_cons_statistics`;
CREATE TABLE `t_cons_statistics` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '机构代码',
  `pv_num` int(11) DEFAULT '0' COMMENT '页面访问量',
  `service_num` int(11) DEFAULT '0' COMMENT '服务人次',
  `service_num_peo` int(11) DEFAULT '0' COMMENT '服务人数',
  `is_delete` int(11) DEFAULT '0' COMMENT '是否删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='咨询页面访问量';

-- ----------------------------
-- Table structure for t_consult
-- ----------------------------
DROP TABLE IF EXISTS `t_consult`;
CREATE TABLE `t_consult` (
  `consult_id` varchar(32) NOT NULL COMMENT '主键',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `free_consultation` int(4) DEFAULT '-1' COMMENT '免费咨询天数 -1.不开通',
  `effect_on` int(2) DEFAULT NULL COMMENT '作用于 0所有 1关注患者 2收藏患者',
  `graphic_consulting` int(4) DEFAULT '-1' COMMENT '图文咨询价格 -1.不开通',
  `telephone_consultation` int(4) DEFAULT '-1' COMMENT '电话咨询价格 -1.不开通',
  `video_consulting` int(4) DEFAULT '-1' COMMENT '视频咨询价格 -1.不开通',
  `consultation_time` text COMMENT '咨询时间',
  `outpatient_time` varchar(10240) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '门诊时间',
  `outpatient_details` text CHARACTER SET utf8mb4 COMMENT '门诊详情',
  `remark` varchar(1024) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `fetalheart_consultation` int(4) DEFAULT '-1' COMMENT '胎心解读咨询价格 -1.不开通',
  `graphic_lower_limit` int(4) DEFAULT NULL COMMENT '图文咨询下限',
  `graphic_higher_limit` int(4) DEFAULT NULL COMMENT '图文咨询上限',
  `fetalheart_lower_limit` int(4) DEFAULT NULL COMMENT '胎心解读下限',
  `fetalheart_higher_limit` int(4) DEFAULT NULL COMMENT '胎心解读上限',
  PRIMARY KEY (`consult_id`),
  KEY `consult_hug_id_index` (`hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='咨询服务';

-- ----------------------------
-- Table structure for t_consult_charge
-- ----------------------------
DROP TABLE IF EXISTS `t_consult_charge`;
CREATE TABLE `t_consult_charge` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hug_id` varchar(16) DEFAULT NULL COMMENT '蓝牛号（患者）',
  `target_hug_id` varchar(16) DEFAULT NULL COMMENT '目标蓝牛号（医生）',
  `remain` int(2) DEFAULT NULL COMMENT '剩余咨询次数',
  `total` int(2) DEFAULT NULL COMMENT '一共能咨询',
  `consult_type` int(1) DEFAULT NULL COMMENT '咨询类别 1 图文咨询 2 电话咨询 3 包月咨询',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `consult_status` int(1) DEFAULT '1' COMMENT '咨询状态 1 未回复 2 过期无效  3 已经到账 4 已经到账并且已经关闭',
  `open_flag` int(1) DEFAULT '1' COMMENT '是否打开 0否1是',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效1有效',
  `expiration_time` datetime DEFAULT NULL COMMENT '过期时间',
  `group_id` varchar(32) DEFAULT NULL COMMENT '分组id 判断是否是同一次咨询',
  `charge_id` varchar(32) DEFAULT NULL COMMENT '支付单号',
  PRIMARY KEY (`id`),
  KEY `idx_hug_id` (`hug_id`),
  KEY `idx_target_hug_id` (`target_hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='咨询收费记录';

-- ----------------------------
-- Table structure for t_consult_configure
-- ----------------------------
DROP TABLE IF EXISTS `t_consult_configure`;
CREATE TABLE `t_consult_configure` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号(患者)',
  `target_hug_id` varchar(32) DEFAULT NULL COMMENT '目标蓝牛号（医生）',
  `pat_source_type` int(1) DEFAULT NULL COMMENT '病人来源 0关注 1收藏',
  `begin_time` datetime DEFAULT NULL COMMENT '开始时间',
  `free_day` int(11) DEFAULT NULL COMMENT '免费天数',
  `index_nos` text COMMENT '开放的医疗数据主键',
  `medical_auth` int(11) DEFAULT NULL COMMENT '医疗-1默认 0关闭 1所有2医院数据3自定义',
  `health_auth` int(11) DEFAULT NULL COMMENT '健康 0关闭1打开',
  `referral_auth` int(11) DEFAULT NULL COMMENT '转介 0关闭 1打开',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效 1有效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='咨询服务免费配置';

-- ----------------------------
-- Table structure for t_consult_dept
-- ----------------------------
DROP TABLE IF EXISTS `t_consult_dept`;
CREATE TABLE `t_consult_dept` (
  `id` varchar(32) NOT NULL,
  `graphic_lower_limit` int(4) DEFAULT NULL COMMENT '图文咨询价格下限',
  `graphic_higher_limit` int(4) DEFAULT NULL COMMENT '图文咨询价格上限',
  `fetalheart_lower_limit` int(4) DEFAULT NULL COMMENT '胎心解读价格下限',
  `fetalheart_higher_limit` int(4) DEFAULT NULL COMMENT '胎心解读价格上限',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `dept_code` varchar(50) NOT NULL COMMENT '科室代码',
  `dr_title` varchar(50) NOT NULL COMMENT '职称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='咨询费用职称配置表';

-- ----------------------------
-- Table structure for t_consult_package
-- ----------------------------
DROP TABLE IF EXISTS `t_consult_package`;
CREATE TABLE `t_consult_package` (
  `package_id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '组织机构代码',
  `package_name` varchar(50) NOT NULL COMMENT '套餐名称',
  `service_time` int(3) NOT NULL COMMENT '服务时间',
  `creater_hug_id` varchar(32) DEFAULT NULL COMMENT '创建人蓝牛号',
  `creater_sourse_id` varchar(32) NOT NULL COMMENT '创建人随访帐号',
  `creater_name` varchar(50) NOT NULL COMMENT '创建人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `type` int(4) DEFAULT NULL COMMENT '类型，1：个人，2：团队',
  `scope` int(4) DEFAULT '0' COMMENT '使用范围，0：所有人/团队，1：本人/本人负责的团队',
  `open_flag` int(4) NOT NULL DEFAULT '0' COMMENT '套餐开启标识 0：已开启，1：已关闭',
  `is_delete` int(4) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='咨询套餐表';

-- ----------------------------
-- Table structure for t_consult_package_config
-- ----------------------------
DROP TABLE IF EXISTS `t_consult_package_config`;
CREATE TABLE `t_consult_package_config` (
  `id` varchar(32) NOT NULL,
  `package_id` varchar(32) NOT NULL COMMENT '套餐id',
  `type` int(4) NOT NULL COMMENT '类型，1：图文咨询，2：胎心解读',
  `value` int(4) NOT NULL COMMENT '数值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='套餐配置表';

-- ----------------------------
-- Table structure for t_consult_package_fee
-- ----------------------------
DROP TABLE IF EXISTS `t_consult_package_fee`;
CREATE TABLE `t_consult_package_fee` (
  `id` varchar(32) NOT NULL,
  `package_id` varchar(32) NOT NULL COMMENT '套餐id',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联团队或个人id',
  `package_fee` int(4) DEFAULT NULL COMMENT '套餐费用',
  `package_lower_limit` int(4) DEFAULT NULL COMMENT '套餐费用下限',
  `package_higher_limit` int(4) DEFAULT NULL COMMENT '套餐费用上限',
  `type` int(4) DEFAULT NULL COMMENT '类型，1：个人，2：团队',
  `is_delete` int(4) DEFAULT '0' COMMENT '删除标识， 0：未删除，1：已删除',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '机构代码',
  `dept_code` varchar(50) DEFAULT NULL COMMENT '科室代码',
  `dr_title` varchar(50) DEFAULT NULL COMMENT '职称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='套餐费用配置表';

-- ----------------------------
-- Table structure for t_consult_team
-- ----------------------------
DROP TABLE IF EXISTS `t_consult_team`;
CREATE TABLE `t_consult_team` (
  `team_id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '组织机构代码',
  `team_name` varchar(100) NOT NULL COMMENT '团队名称',
  `team_hug_id` varchar(32) NOT NULL COMMENT '团队蓝牛号，关联用户表',
  `incharge_hug_id` varchar(32) NOT NULL COMMENT '团队负责人蓝牛号',
  `incharge_name` varchar(50) NOT NULL COMMENT '团队负责人姓名',
  `creater_sourse_id` varchar(32) NOT NULL COMMENT '创建人随访账号',
  `creater_name` varchar(50) NOT NULL COMMENT '团队创建人姓名',
  `introduction` varchar(1024) DEFAULT NULL COMMENT '团队简介',
  `team_total_num` int(2) NOT NULL COMMENT '团队人数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='咨询团队表';

-- ----------------------------
-- Table structure for t_consult_team_user
-- ----------------------------
DROP TABLE IF EXISTS `t_consult_team_user`;
CREATE TABLE `t_consult_team_user` (
  `id` varchar(32) NOT NULL,
  `team_id` varchar(32) NOT NULL COMMENT '咨询团队id',
  `hug_id` varchar(32) NOT NULL COMMENT '成员蓝牛号',
  `name` varchar(50) NOT NULL COMMENT '姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='咨询团队成员表';

-- ----------------------------
-- Table structure for t_consulting_time
-- ----------------------------
DROP TABLE IF EXISTS `t_consulting_time`;
CREATE TABLE `t_consulting_time` (
  `id` varchar(32) NOT NULL,
  `hg_id` varchar(32) NOT NULL,
  `day` varchar(5) NOT NULL,
  `start_time` varchar(5) NOT NULL,
  `end_time` varchar(5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_course_discern_result
-- ----------------------------
DROP TABLE IF EXISTS `t_course_discern_result`;
CREATE TABLE `t_course_discern_result` (
  `id` varchar(32) NOT NULL COMMENT 'ID',
  `items` varchar(50) DEFAULT NULL COMMENT '检验项目',
  `result` varchar(50) DEFAULT NULL COMMENT '结果',
  `state` varchar(50) DEFAULT NULL COMMENT '状态',
  `reference_range` varchar(50) DEFAULT NULL COMMENT '参考范围',
  `unit` varchar(50) DEFAULT NULL COMMENT '单位',
  `descern_id` varchar(32) DEFAULT NULL COMMENT '识别记录id',
  `sort_no` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '排序',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `test` (`sort_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1595 DEFAULT CHARSET=utf8 COMMENT='病程图片识别结果';

-- ----------------------------
-- Table structure for t_dc_course
-- ----------------------------
DROP TABLE IF EXISTS `t_dc_course`;
CREATE TABLE `t_dc_course` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `type` int(2) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `member_id` varchar(32) DEFAULT NULL,
  `index_no_id` varchar(500) DEFAULT NULL,
  `descr` varchar(1000) DEFAULT NULL,
  `discern_ids` varchar(500) DEFAULT NULL COMMENT '图片识别记录ids',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dc_course_discern
-- ----------------------------
DROP TABLE IF EXISTS `t_dc_course_discern`;
CREATE TABLE `t_dc_course_discern` (
  `id` varchar(32) NOT NULL COMMENT 'ID',
  `report_name` varchar(50) DEFAULT NULL COMMENT '报告名称',
  `img_id` varchar(32) DEFAULT NULL COMMENT '图片id',
  `course_id` varchar(32) DEFAULT NULL COMMENT '病程id',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='病程图片识别记录';

-- ----------------------------
-- Table structure for t_dc_image
-- ----------------------------
DROP TABLE IF EXISTS `t_dc_image`;
CREATE TABLE `t_dc_image` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `image_id` varchar(128) DEFAULT NULL,
  `dc_id` varchar(32) DEFAULT NULL,
  `time` varchar(50) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `member_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_delivery_condition_doctor_record
-- ----------------------------
DROP TABLE IF EXISTS `t_delivery_condition_doctor_record`;
CREATE TABLE `t_delivery_condition_doctor_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `delivery_time` date NOT NULL COMMENT '分娩日期',
  `delivery_way` varchar(20) DEFAULT NULL COMMENT '分娩方式',
  `delivery_cost_hour` int(11) DEFAULT NULL COMMENT '分娩所用小时',
  `delivery_cost_minute` int(11) DEFAULT NULL COMMENT '分娩所用分钟',
  `bleeding_amount` int(11) DEFAULT NULL COMMENT '出血量大小选择',
  `specific_bleeding_amount` double DEFAULT NULL COMMENT '具体出血量',
  `transfuse_bleeding_flag` tinyint(1) DEFAULT NULL COMMENT '有无输血',
  `specific_transfuse_bleeding` double DEFAULT NULL COMMENT '输血具体量',
  `delivery_abnormal_condition_flag` tinyint(1) DEFAULT NULL COMMENT '分娩中有无异常',
  `delivery_abnormal_condition_content` varchar(2000) DEFAULT NULL COMMENT '具体异常情况',
  `process_advice` varchar(2000) DEFAULT NULL COMMENT '处理及建议',
  `guidance` varchar(2000) DEFAULT NULL COMMENT '指导事项',
  `delivery_agencies` varchar(20) DEFAULT NULL COMMENT '分娩机构',
  `doctor_signature` varchar(20) DEFAULT NULL COMMENT '医生签名',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_delivery_condition_record
-- ----------------------------
DROP TABLE IF EXISTS `t_delivery_condition_record`;
CREATE TABLE `t_delivery_condition_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `delivery_time` datetime DEFAULT NULL COMMENT '分娩时间',
  `delivery_address` varchar(20) DEFAULT NULL COMMENT '分娩地点',
  `delivery_accompany` varchar(20) DEFAULT NULL COMMENT '分娩陪同人',
  `baby_birth_time` datetime DEFAULT NULL COMMENT '宝宝出生时间',
  `baby_birth_address` varchar(20) DEFAULT NULL COMMENT '宝宝出生地点',
  `baby_birth_accompany` varchar(20) DEFAULT NULL COMMENT '宝宝出生陪同人',
  `mother_feel` varchar(2000) DEFAULT NULL COMMENT '妈妈的感受',
  `father_feel` varchar(2000) DEFAULT NULL COMMENT '爸爸的感受',
  `predelivery_delivery_baby_feel` varchar(2000) DEFAULT NULL COMMENT '待产、分娩、看到宝宝感受',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_device_exception
-- ----------------------------
DROP TABLE IF EXISTS `t_device_exception`;
CREATE TABLE `t_device_exception` (
  `exception_id` varchar(40) NOT NULL,
  `serial_number` varchar(40) DEFAULT NULL COMMENT '设备imei',
  `notification_type` varchar(40) DEFAULT NULL COMMENT '报警类型',
  `message` varchar(20) DEFAULT NULL COMMENT '信息',
  `exception_name` varchar(40) DEFAULT NULL COMMENT '报警信息',
  `deleted` varchar(40) DEFAULT NULL COMMENT '删除标志位 0未删除 1已删除',
  `device_name` varchar(40) DEFAULT NULL COMMENT '设备名称',
  `model_name` varchar(40) DEFAULT NULL COMMENT '设备型号',
  `create_date` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间 数据入表',
  `send_flag` varchar(40) DEFAULT NULL COMMENT '发送医生标志位 1已发送 0未发送',
  PRIMARY KEY (`exception_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备报警信息记录';

-- ----------------------------
-- Table structure for t_dict_area
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_area`;
CREATE TABLE `t_dict_area` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `area_name` varchar(32) NOT NULL COMMENT '院区名称',
  `area_pic` varchar(512) DEFAULT NULL COMMENT '院区链接',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_dict_cloud
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_cloud`;
CREATE TABLE `t_dict_cloud` (
  `id` varchar(32) NOT NULL,
  `cloud_code` varchar(32) DEFAULT NULL COMMENT '云医院编码',
  `cloud_name` varchar(32) DEFAULT NULL COMMENT '云医院名称',
  `introduce` varchar(1024) DEFAULT NULL COMMENT '简介',
  `image` varchar(32) DEFAULT NULL COMMENT '图片',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `cloud_type` int(2) DEFAULT '1' COMMENT '关系类型 1云医院 2就诊卡共享',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='云医院';

-- ----------------------------
-- Table structure for t_dict_dept
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_dept`;
CREATE TABLE `t_dict_dept` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT NULL,
  `dept_code` varchar(50) DEFAULT NULL,
  `dept_name` varchar(50) DEFAULT NULL,
  `parent_dept_code` varchar(50) DEFAULT NULL,
  `parent_dept_name` varchar(50) DEFAULT NULL,
  `pinyin_code` varchar(50) DEFAULT NULL,
  `invalid_flag` varchar(5) DEFAULT NULL,
  `curr_use_code` varchar(1) DEFAULT '0' COMMENT '当前科室应用状态,0 同步科室，未开通，1 同步科室开通 2随访自建',
  `ward_flag` varchar(2) DEFAULT NULL COMMENT '1科室 2病区',
  `dept_phone` varchar(50) DEFAULT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `section_id` varchar(32) DEFAULT NULL COMMENT '部门id',
  `cycle` int(4) DEFAULT '1' COMMENT '预约周期默认为1个周期',
  `updateName` varchar(20) DEFAULT NULL COMMENT '编辑人姓名',
  `updateTime` varchar(20) DEFAULT NULL COMMENT '编辑时间',
  `update_name` varchar(20) DEFAULT NULL COMMENT '编辑人姓名',
  `update_time` varchar(20) DEFAULT NULL COMMENT '编辑时间',
  `area_id` varchar(32) DEFAULT NULL COMMENT '院区id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `dict_dept` (`hosp_code`,`dept_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='从医院抽取初始科室字典数据';

-- ----------------------------
-- Table structure for t_dict_hosp
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hosp`;
CREATE TABLE `t_dict_hosp` (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT '' COMMENT '医院编码',
  `level` varchar(10) DEFAULT '' COMMENT '等级',
  `address` varchar(200) DEFAULT '' COMMENT '地址',
  `homepage` varchar(100) DEFAULT '' COMMENT '主页',
  `open_cloud` varchar(1) DEFAULT '' COMMENT '是否开放云随访 0 未开放 1 开放',
  `region_code` varchar(10) DEFAULT NULL,
  `image` varchar(32) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `abbreviation` varchar(100) DEFAULT NULL COMMENT '医院简称',
  `introduce` text,
  `special` text,
  `specialdepar` text,
  `honor` text,
  `location` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `open_appoint` int(1) DEFAULT '0',
  `appoint_thing` varchar(200) DEFAULT NULL,
  `noon_flag` int(1) DEFAULT '0',
  `hour` int(4) DEFAULT '0',
  `reg_instruction` text,
  `partner_type` int(2) DEFAULT '0',
  `prefix` varchar(10) DEFAULT NULL COMMENT '前缀',
  `app_id` varchar(64) DEFAULT NULL COMMENT '云通讯子id',
  `image_banner` varchar(32) DEFAULT NULL COMMENT '医院图片banner',
  `ip` varchar(128) DEFAULT NULL COMMENT 'IP',
  `port` varchar(8) DEFAULT NULL COMMENT '端口',
  `parent_hosp_code` varchar(50) DEFAULT NULL COMMENT '父医院机构代码',
  `disease_manage_flag` varchar(10) DEFAULT '0' COMMENT '疾病管理标志位 0为管理 1已关理',
  `receive_im` int(11) DEFAULT '0' COMMENT '是否接收IM 0否1是',
  PRIMARY KEY (`id`),
  KEY `hospIndex` (`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dict_hug_care_before_visit
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hug_care_before_visit`;
CREATE TABLE `t_dict_hug_care_before_visit` (
  `id` varchar(32) NOT NULL,
  `type` varchar(50) DEFAULT NULL COMMENT '类型',
  `type_id` varchar(50) DEFAULT NULL COMMENT '类型ID',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `content` varchar(256) DEFAULT NULL COMMENT '内容',
  `create_time` datetime(3) NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `pinyin` varchar(50) DEFAULT NULL COMMENT '拼音码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识库-诊前注意事项';

-- ----------------------------
-- Table structure for t_dict_hug_device
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hug_device`;
CREATE TABLE `t_dict_hug_device` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `thumbnail` varchar(32) DEFAULT NULL COMMENT '缩略图',
  `device_name` varchar(255) DEFAULT NULL COMMENT '设备名称',
  `introduce` varchar(255) DEFAULT NULL COMMENT '介绍',
  `image_id` varchar(32) DEFAULT NULL COMMENT '图片主键',
  `price` decimal(10,0) DEFAULT NULL COMMENT '价格',
  `model` varchar(64) DEFAULT NULL COMMENT '型号',
  `function` varchar(255) DEFAULT NULL COMMENT '功能',
  `application_scope` varchar(255) DEFAULT NULL COMMENT '适用范围',
  `attention` varchar(255) DEFAULT NULL COMMENT '注意事项',
  `url` varchar(255) DEFAULT NULL COMMENT '链接地址',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效1有效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康设备';

-- ----------------------------
-- Table structure for t_dict_hug_disease
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hug_disease`;
CREATE TABLE `t_dict_hug_disease` (
  `id` varchar(32) NOT NULL,
  `title` varchar(50) NOT NULL COMMENT '标题',
  `deptname` varchar(50) DEFAULT NULL,
  `position` varchar(20) DEFAULT NULL,
  `agegroup` varchar(20) DEFAULT NULL,
  `checking` text NOT NULL COMMENT '检查',
  `concurrent` text,
  `diagnosis` text,
  `image_onclick` varchar(32) DEFAULT NULL COMMENT '图片已点击',
  `image_unclick` varchar(32) DEFAULT NULL COMMENT '图片未点击',
  `image_onclick_dept` varchar(32) DEFAULT NULL COMMENT '图片已点击',
  `image_unclick_dept` varchar(32) DEFAULT NULL COMMENT '图片未点击',
  `introduction` text,
  `morbidity` varchar(100) DEFAULT NULL,
  `name` varchar(100) NOT NULL COMMENT '疾病名称',
  `prevention` text NOT NULL COMMENT '预防',
  `reasondescription` text NOT NULL COMMENT '病因描述',
  `symptomdescription` text NOT NULL COMMENT '症状描述',
  `treatment` text NOT NULL COMMENT '治疗',
  `dept_type` varchar(40) DEFAULT NULL COMMENT '疾病所属部位',
  `position_type` varchar(40) DEFAULT NULL COMMENT '疾病所属科室',
  PRIMARY KEY (`id`),
  UNIQUE KEY `diseasekey` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dict_hug_disease_image
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hug_disease_image`;
CREATE TABLE `t_dict_hug_disease_image` (
  `id` varchar(32) NOT NULL,
  `type` varchar(10) DEFAULT NULL COMMENT '1 部位 2科室 ',
  `name` varchar(20) DEFAULT NULL COMMENT '名称 ',
  `image_onclick` varchar(32) DEFAULT NULL COMMENT '未点击',
  `image_unclick` varchar(32) DEFAULT NULL COMMENT '已点击',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `operator_id` int(11) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='疾病图片表';

-- ----------------------------
-- Table structure for t_dict_hug_drug
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hug_drug`;
CREATE TABLE `t_dict_hug_drug` (
  `id` varchar(32) NOT NULL,
  `title` varchar(50) NOT NULL COMMENT '标题',
  `type` varchar(50) DEFAULT NULL,
  `FDA` varchar(100) DEFAULT NULL,
  `commonname` varchar(1000) NOT NULL COMMENT '药品名称',
  `component` varchar(1000) NOT NULL COMMENT '药品成分',
  `contraindications` text NOT NULL COMMENT '禁忌',
  `dosage` text NOT NULL COMMENT '药物剂量',
  `indication` text NOT NULL COMMENT '适应症',
  `precautions` text NOT NULL COMMENT '注意事项',
  `adversereactions` text NOT NULL COMMENT '不良反应',
  `image_unclick` varchar(32) DEFAULT NULL COMMENT '图片未点击',
  `image_onclick` varchar(32) DEFAULT NULL COMMENT '图片已点击',
  `type_id` varchar(40) DEFAULT NULL COMMENT '所属类别id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dict_hug_emergency
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hug_emergency`;
CREATE TABLE `t_dict_hug_emergency` (
  `id` varchar(32) NOT NULL,
  `title` varchar(300) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `content` text NOT NULL COMMENT '内容',
  `image_unclick` varchar(255) DEFAULT NULL,
  `image_onclick` varchar(255) DEFAULT NULL,
  `type_id` varchar(40) DEFAULT NULL COMMENT '所属类别id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dict_hug_hospital
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hug_hospital`;
CREATE TABLE `t_dict_hug_hospital` (
  `id` varchar(32) NOT NULL DEFAULT 'auto_increment',
  `hospital_name` varchar(255) NOT NULL COMMENT ' 医院名称',
  `hospital_introduce` text NOT NULL COMMENT '医院介绍',
  `hospital_special` text NOT NULL COMMENT '特色',
  `hospital_special_depar` text NOT NULL COMMENT '特殊科室',
  `hospital_honor` text NOT NULL COMMENT ' 医院荣誉',
  `hospital_location` text NOT NULL COMMENT '地理位置',
  `part` text,
  `hospital_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dict_hug_hospital_copy
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hug_hospital_copy`;
CREATE TABLE `t_dict_hug_hospital_copy` (
  `hospital_name` varchar(255) DEFAULT NULL COMMENT ' 医院名称',
  `hospital_introduce` text COMMENT '医院介绍',
  `hospital_special` text COMMENT '特色',
  `hospital_special_depar` text COMMENT '特殊科室',
  `hospital_honor` text COMMENT ' 医院荣誉',
  `hospital_location` text COMMENT '地理位置',
  `part` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dict_hug_hospital_deptname
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_hug_hospital_deptname`;
CREATE TABLE `t_dict_hug_hospital_deptname` (
  `deptname` varchar(30) NOT NULL,
  `hospital_name` varchar(40) NOT NULL,
  `sn` varchar(2) NOT NULL,
  `image_unclick` varchar(255) DEFAULT NULL,
  `image_onclick` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dict_image
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_image`;
CREATE TABLE `t_dict_image` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `image_id` varchar(50) DEFAULT NULL,
  `company_name` varchar(200) DEFAULT NULL,
  `create_time` bigint(19) DEFAULT NULL,
  `to_url` varchar(200) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  `time` bigint(19) DEFAULT NULL,
  `sequence` int(10) DEFAULT NULL,
  `type` int(2) DEFAULT '1',
  `hosp_code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dict_section
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_section`;
CREATE TABLE `t_dict_section` (
  `id` varchar(32) NOT NULL COMMENT '部门ID 主键',
  `sect_name` varchar(50) DEFAULT NULL COMMENT '部门名称',
  `tel_no` varchar(50) DEFAULT NULL COMMENT '科室电话',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `sect_summary` text COMMENT '部门简介',
  `remark` varchar(256) DEFAULT NULL COMMENT '备注',
  `sort` int(11) DEFAULT NULL COMMENT '排序顺序(数值越大越靠前 即desc顺序)',
  `create_time` bigint(19) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(19) DEFAULT NULL COMMENT '更新时间',
  `sect_addr` varchar(255) DEFAULT NULL COMMENT '科室地址',
  `status` tinyint(2) DEFAULT '1' COMMENT '状态：冻结(0)，有效(1)，撤销(2)，删除(-1)等',
  `area_id` varchar(32) DEFAULT NULL COMMENT '院区id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='部门信息';

-- ----------------------------
-- Table structure for t_dict_staff
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_staff`;
CREATE TABLE `t_dict_staff` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT NULL,
  `staff_index` varchar(50) DEFAULT NULL,
  `staff_code` varchar(50) DEFAULT NULL,
  `staff_name` varchar(50) DEFAULT NULL,
  `dept_code` varchar(50) DEFAULT NULL,
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `pinyin_code` varchar(50) DEFAULT NULL,
  `disabled` varchar(5) DEFAULT NULL COMMENT '0:正常；1:作废',
  `id_card` varchar(50) DEFAULT NULL COMMENT '身份证',
  `sex_code` varchar(10) DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(10) DEFAULT NULL COMMENT '性别名称',
  `title_code` varchar(20) DEFAULT NULL COMMENT '职称编码',
  `title_name` varchar(50) DEFAULT NULL COMMENT '职称名称',
  `mobile_no` varchar(30) DEFAULT NULL COMMENT '手机号码',
  `email` varchar(50) DEFAULT NULL COMMENT '邮件',
  `birth_date` varchar(50) DEFAULT NULL COMMENT '生日',
  `briefing` varchar(500) DEFAULT NULL COMMENT '职工简介',
  `good_desc` varchar(500) DEFAULT NULL COMMENT '擅长说明',
  PRIMARY KEY (`id`),
  UNIQUE KEY `staff_index` (`hosp_code`,`staff_index`),
  KEY `index_id_card` (`id_card`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='从医院抽取初始职工字典数据';

-- ----------------------------
-- Table structure for t_diet_repository_custom
-- ----------------------------
DROP TABLE IF EXISTS `t_diet_repository_custom`;
CREATE TABLE `t_diet_repository_custom` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '用户蓝牛号id',
  `diet_sport_picture_name` varchar(255) DEFAULT NULL COMMENT '图片',
  `diet_sport_code` varchar(128) DEFAULT NULL COMMENT '食物编码',
  `diet_sport_name` varchar(128) DEFAULT NULL COMMENT '食物名',
  `diet_sport_unit_value` varchar(128) DEFAULT NULL COMMENT '摄入量',
  `diet_sport_unit` varchar(64) DEFAULT NULL COMMENT '摄入单位',
  `energy` varchar(64) DEFAULT NULL COMMENT '热量',
  `protein` varchar(64) DEFAULT NULL COMMENT '蛋白质',
  `fat` varchar(64) DEFAULT NULL COMMENT '脂肪',
  `carbohydrate` varchar(64) DEFAULT NULL COMMENT '碳水化合物',
  `create_time` datetime DEFAULT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(2) DEFAULT '0' COMMENT '是否被删除 0 未删除 1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dingtalk_app
-- ----------------------------
DROP TABLE IF EXISTS `t_dingtalk_app`;
CREATE TABLE `t_dingtalk_app` (
  `id` varchar(32) NOT NULL,
  `suite_key` varchar(128) NOT NULL COMMENT '微应用套件key',
  `app_id` int(20) NOT NULL COMMENT 'appid,此id来自于开发者中心',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='isv创建的app';

-- ----------------------------
-- Table structure for t_dingtalk_corp
-- ----------------------------
DROP TABLE IF EXISTS `t_dingtalk_corp`;
CREATE TABLE `t_dingtalk_corp` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(128) NOT NULL COMMENT '钉钉企业ID',
  `invite_code` varchar(64) DEFAULT NULL COMMENT '企业邀请码',
  `industry` varchar(256) DEFAULT NULL COMMENT '企业所属行业',
  `corp_name` varchar(256) DEFAULT NULL COMMENT '企业名称',
  `invite_url` varchar(1024) DEFAULT NULL COMMENT '企业邀请链接',
  `corp_logo_url` varchar(1024) DEFAULT NULL COMMENT '企业logo链接',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='企业信息表';

-- ----------------------------
-- Table structure for t_dingtalk_corp_app
-- ----------------------------
DROP TABLE IF EXISTS `t_dingtalk_corp_app`;
CREATE TABLE `t_dingtalk_corp_app` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(255) NOT NULL COMMENT '企业corpid',
  `agent_id` int(20) NOT NULL COMMENT '钉钉企业使用的微应用ID',
  `agent_name` varchar(128) NOT NULL COMMENT '钉钉企业使用的微应用名称',
  `logo_url` varchar(1024) NOT NULL COMMENT '钉钉企业使用的微应用图标',
  `app_id` int(20) NOT NULL COMMENT '钉钉企业使用的微应用原始ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='企业微应用信息表';

-- ----------------------------
-- Table structure for t_dingtalk_corp_suite_auth
-- ----------------------------
DROP TABLE IF EXISTS `t_dingtalk_corp_suite_auth`;
CREATE TABLE `t_dingtalk_corp_suite_auth` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(255) NOT NULL COMMENT '企业corpid',
  `suite_key` varchar(100) NOT NULL COMMENT '套件key',
  `permanent_code` varchar(255) NOT NULL COMMENT '临时授权码或永久授权码value',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='企业对套件的授权记录';

-- ----------------------------
-- Table structure for t_dingtalk_suite
-- ----------------------------
DROP TABLE IF EXISTS `t_dingtalk_suite`;
CREATE TABLE `t_dingtalk_suite` (
  `id` varchar(32) NOT NULL,
  `suite_key` varchar(100) DEFAULT NULL COMMENT 'suite 的唯一key',
  `suite_secret` varchar(256) DEFAULT NULL COMMENT 'suite的唯一secrect，与key对应',
  `aes_key` varchar(256) DEFAULT NULL COMMENT '回调信息加解密参数',
  `token` varchar(128) DEFAULT NULL COMMENT '已填写用于生成签名和校验毁掉请求的合法性',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='钉钉套餐表';

-- ----------------------------
-- Table structure for t_dingtalk_user
-- ----------------------------
DROP TABLE IF EXISTS `t_dingtalk_user`;
CREATE TABLE `t_dingtalk_user` (
  `id` varchar(32) NOT NULL,
  `corp_id` varchar(128) NOT NULL COMMENT '钉钉企业ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '员工在企业内的UserID',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='钉钉用户表';

-- ----------------------------
-- Table structure for t_disease_dept_blue_money
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_dept_blue_money`;
CREATE TABLE `t_disease_dept_blue_money` (
  `id` varchar(40) NOT NULL,
  `record_id` varchar(40) DEFAULT NULL COMMENT '蓝牛币计算配置id',
  `pay_disease_id` varchar(40) DEFAULT NULL COMMENT '开单id',
  `hosp_code` varchar(40) DEFAULT NULL COMMENT '医院代码',
  `dept_code` varchar(40) DEFAULT NULL COMMENT '科室代码',
  `dept_money` varchar(20) DEFAULT '0' COMMENT '科室当前的蓝牛币',
  `dept_total_money` varchar(20) DEFAULT '0' COMMENT '科室总蓝牛币',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标志位 0未删除 1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='存储科室蓝牛币总额及余额';

-- ----------------------------
-- Table structure for t_disease_manage_contract
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_manage_contract`;
CREATE TABLE `t_disease_manage_contract` (
  `id` varchar(50) NOT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `user_name` varchar(50) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院机构编码',
  `empi_id` varchar(50) DEFAULT NULL,
  `pat_name` varchar(50) DEFAULT NULL,
  `contract_user_info` varchar(3000) DEFAULT NULL COMMENT '签约医生JSON',
  `notice_user_info` varchar(3000) DEFAULT NULL COMMENT '通知医生JSON',
  `service_item_code` varchar(50) DEFAULT NULL COMMENT '服务项目id',
  `service_item_name` varchar(50) DEFAULT NULL COMMENT '服务项目名称',
  `sign_date` varchar(50) DEFAULT NULL COMMENT '签约日期',
  `start_service_date` varchar(50) DEFAULT NULL COMMENT '起始服务日期',
  `end_service_date` varchar(50) DEFAULT NULL COMMENT '到期服务日期',
  `notice_type` int(4) DEFAULT NULL COMMENT '通知方式',
  `file_address` varchar(1000) DEFAULT NULL COMMENT '附件地址',
  `create_time` varchar(20) DEFAULT NULL COMMENT '创建日期',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '修改日期',
  `status` int(4) DEFAULT NULL COMMENT '使用状态',
  `send_status` int(4) DEFAULT NULL COMMENT '是否发送 0代表未发送  1代表已发送',
  `service_status` int(4) DEFAULT NULL COMMENT '0 代表未开始 1代表服务中 2代表已结束',
  `remind_flag` int(4) DEFAULT NULL COMMENT '服务提醒状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='服务记录表';

-- ----------------------------
-- Table structure for t_disease_patient_process
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_patient_process`;
CREATE TABLE `t_disease_patient_process` (
  `id` varchar(50) NOT NULL,
  `process_code` int(11) DEFAULT NULL COMMENT '过程编码',
  `process_name` varchar(50) DEFAULT NULL COMMENT '过程名称',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `send_type` int(11) DEFAULT NULL COMMENT '执行方式 0:不发送 1:APP/短信 2:仅短信 3:仅APP',
  `status` int(11) DEFAULT NULL COMMENT '状态 0：未完成 1：已完成',
  `creator_id` varchar(50) DEFAULT NULL COMMENT '执行人',
  `creator_name` varchar(50) DEFAULT NULL COMMENT '执行人姓名',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `source_type` int(11) DEFAULT NULL COMMENT '任务来源 1：手动 2：自动',
  `content_id` varchar(50) DEFAULT NULL COMMENT '关联内容ID',
  `url` varchar(255) DEFAULT NULL COMMENT '关联内容url',
  `empi_id` varchar(100) DEFAULT NULL COMMENT '患者索引号',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '患者姓名',
  `id_card` varchar(20) DEFAULT NULL COMMENT '身份证号',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `type` int(11) DEFAULT NULL COMMENT '类别 1：主动（健管师或系统主动发起）2：被动（患者发起）',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `business_time` timestamp NULL DEFAULT NULL COMMENT '关联业务时间',
  `is_valid` int(11) DEFAULT '1' COMMENT '是否有效 0:无效 1：有效',
  `content_parent_id` varchar(50) DEFAULT NULL COMMENT '是关联内容父ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者管理过程表';

-- ----------------------------
-- Table structure for t_disease_pay_calculate
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_pay_calculate`;
CREATE TABLE `t_disease_pay_calculate` (
  `id` varchar(40) NOT NULL,
  `record_id` varchar(40) DEFAULT NULL COMMENT '蓝牛币计算配置id',
  `pay_disease_id` varchar(40) DEFAULT NULL COMMENT '开单id',
  `hosp_code` varchar(40) DEFAULT NULL COMMENT '医院代码',
  `dept_code` varchar(40) DEFAULT NULL COMMENT '科室代码',
  `exchange_rate` varchar(40) DEFAULT NULL COMMENT '汇率',
  `streamline_price` varchar(40) DEFAULT NULL COMMENT '精细化单价',
  `specialist_price` varchar(40) DEFAULT NULL COMMENT '专科单价',
  `dept_scale` varchar(40) DEFAULT NULL COMMENT '科室比例',
  `manager_scale` varchar(40) DEFAULT NULL COMMENT '主任比例',
  `doc_scale` varchar(40) DEFAULT NULL COMMENT '医生比例',
  `else_scale` varchar(40) DEFAULT NULL COMMENT '其他比例',
  `my_scale` varchar(40) DEFAULT NULL COMMENT '剩余比例',
  `dept_doc_list` varchar(500) DEFAULT NULL COMMENT '当前科室医生随访账号列表用,分隔',
  `dept_manager_list` varchar(500) DEFAULT NULL COMMENT '当前科室主任随访账号列表用，分隔',
  `server_type` int(1) DEFAULT NULL COMMENT '（1， 院后精细化服务；2，专科随访服务',
  `specialist_num` int(11) DEFAULT NULL COMMENT '专科随访次数',
  `dept_money` varchar(20) DEFAULT NULL COMMENT '科室分配的蓝牛币',
  `manager_money` varchar(20) DEFAULT NULL COMMENT '每个主任分配的蓝牛币',
  `doc_money` varchar(20) DEFAULT NULL COMMENT '每个医生分配的蓝牛币',
  `else_money` varchar(40) DEFAULT NULL COMMENT '其他蓝牛币',
  `my_money` varchar(40) DEFAULT NULL COMMENT '其他蓝牛币',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` int(1) DEFAULT NULL COMMENT '删除标志位 0未删除 1已删除(退费)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='医院科室蓝牛币分配表';

-- ----------------------------
-- Table structure for t_disease_pay_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_disease_pay_patient`;
CREATE TABLE `t_disease_pay_patient` (
  `id` varchar(40) NOT NULL,
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '机构代码',
  `pat_index_no` varchar(40) DEFAULT NULL COMMENT '患者索引号',
  `visit_card_no` varchar(40) DEFAULT NULL COMMENT '就诊卡号',
  `outhosp_no` varchar(40) DEFAULT NULL COMMENT '门诊号',
  `outhosp_serial_no` varchar(40) DEFAULT NULL COMMENT '门诊流水号',
  `visit_date` timestamp NULL DEFAULT NULL COMMENT '就诊日期时间',
  `inhosp_no` varchar(40) DEFAULT NULL COMMENT '住院号',
  `inhosp_num` int(11) DEFAULT NULL COMMENT '住院次数',
  `inhosp_serial_no` varchar(40) DEFAULT NULL COMMENT '住院流水号',
  `admit_date` timestamp NULL DEFAULT NULL COMMENT '入院日期',
  `discharge_date` timestamp NULL DEFAULT NULL COMMENT '出院日期时间',
  `pat_name` varchar(20) DEFAULT NULL COMMENT '患者姓名',
  `id_number` varchar(20) DEFAULT NULL COMMENT '身份证号码',
  `sex_code` int(1) DEFAULT NULL COMMENT '性别代码',
  `sex_name` varchar(20) DEFAULT NULL COMMENT '性别名称',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `mobile_no` varchar(20) DEFAULT NULL COMMENT '手机号码',
  `charge_item_code` varchar(40) DEFAULT NULL COMMENT '收费项目代码',
  `charge_item_name` varchar(40) DEFAULT NULL COMMENT '收费项目名称',
  `total_money` varchar(20) DEFAULT NULL COMMENT '缴费金额',
  `charge_date` timestamp NULL DEFAULT NULL COMMENT '缴费时间',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `repeat_flag` int(1) DEFAULT NULL COMMENT '是否收案(0:否 1:是)',
  `collector_id` varchar(40) DEFAULT NULL COMMENT '收案人id',
  `collector_name` varchar(40) DEFAULT NULL COMMENT '收案人姓名',
  `order_open_dept_code` varchar(40) DEFAULT NULL COMMENT '医嘱开立科室代码',
  `order_open_dept_name` varchar(40) DEFAULT NULL COMMENT '医嘱开立科室名称',
  `order_open_dr_code` varchar(40) DEFAULT NULL COMMENT '医嘱开立医生工号',
  `order_open_dr_name` varchar(40) DEFAULT NULL COMMENT '医嘱开立医生姓名',
  `order_order_date` timestamp NULL DEFAULT NULL COMMENT '医嘱开立日期',
  `drug_use_frequency_code` varchar(20) DEFAULT NULL COMMENT '药品使用频次代码',
  `drug_use_frequency_name` varchar(40) DEFAULT NULL COMMENT '药品使用频次名称',
  `note` varchar(200) DEFAULT NULL COMMENT '备注',
  `drug_unit_price` varchar(20) DEFAULT NULL COMMENT '药品单价',
  `drug_amount` varchar(20) DEFAULT NULL COMMENT '药品数量',
  `add_plan_flag` int(1) DEFAULT NULL COMMENT '是否添加至计划(0:否 1:是)',
  `add_plan_id` varchar(40) DEFAULT NULL COMMENT '计划id',
  `add_plan_name` varchar(40) DEFAULT NULL COMMENT '计划名称',
  `source_type` int(1) DEFAULT NULL COMMENT '患者来源(1:门诊 2:出院 3:在院)',
  `pat_address` varchar(200) DEFAULT NULL COMMENT '患者家庭地址',
  `diag_code` varchar(40) DEFAULT NULL COMMENT '患者诊断代码',
  `diag_name` varchar(100) DEFAULT NULL COMMENT '患者诊断名称',
  `empi_id` varchar(40) DEFAULT NULL COMMENT '患者主索引号',
  `order_no` varchar(40) DEFAULT NULL COMMENT '医嘱号',
  `code_list_split` varchar(200) DEFAULT NULL COMMENT '项目代码',
  `server_type` int(1) DEFAULT NULL COMMENT '（1， 院后精细化服务；2，专科随访服务',
  `is_refund` int(1) DEFAULT NULL COMMENT '1:已退费',
  `refund_time` timestamp NULL DEFAULT NULL COMMENT '缴费时间',
  `refund_finish_status` int(1) DEFAULT NULL COMMENT '退费完成状态(0:未完成,1:已完成)',
  `report_no` varchar(40) DEFAULT NULL COMMENT '体检号',
  `exam_date` varchar(40) DEFAULT NULL COMMENT '体检日期',
  `report_date` varchar(40) DEFAULT NULL COMMENT '报告日期',
  `recheck_handle_status` int(1) DEFAULT NULL COMMENT ' 复查处理状态(0:未处理 1:已处理)',
  `false_data` int(11) DEFAULT NULL COMMENT '种子计划',
  `preach_status` int(1) DEFAULT NULL COMMENT '宣讲状态 0未宣讲 1已宣讲',
  `manage_status` int(1) DEFAULT NULL COMMENT '管理状态 0未收案/未添加计划 1已收案/已添加计划',
  `charge_item_count` int(11) DEFAULT NULL COMMENT '收费项目数量',
  `pack_id` varchar(40) DEFAULT NULL COMMENT '路径(场景)id',
  `pack_name` varchar(40) DEFAULT NULL COMMENT '路径(场景)名称',
  `is_deal` int(1) DEFAULT NULL COMMENT '处理标志位 0未处理 1已经处理',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `doctor_id` varchar(32) DEFAULT NULL COMMENT '院端医生id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='随访开单记录表';

-- ----------------------------
-- Table structure for t_drug_remind_record
-- ----------------------------
DROP TABLE IF EXISTS `t_drug_remind_record`;
CREATE TABLE `t_drug_remind_record` (
  `id` varchar(32) NOT NULL,
  `interview_id` varchar(32) DEFAULT NULL COMMENT '随访id',
  `organ_code` varchar(32) DEFAULT NULL COMMENT '医院代码',
  `mobile_no` varchar(32) DEFAULT NULL COMMENT '患者手机号',
  `drug_code` varchar(32) DEFAULT NULL COMMENT '药品代码',
  `drug_name` varchar(50) DEFAULT NULL COMMENT '药品名称',
  `drug_use_dosage` varchar(200) DEFAULT NULL COMMENT '药品使用剂量',
  `understand` int(2) DEFAULT NULL COMMENT '是否理解 0未读 1未理解 2已理解',
  `hot_tip` varchar(500) DEFAULT NULL COMMENT '注意事项',
  `head_content` varchar(200) DEFAULT NULL COMMENT '短链接头部内容',
  `tail_content` varchar(200) DEFAULT NULL COMMENT '短链接尾部内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用药提醒记录表';

-- ----------------------------
-- Table structure for t_dynamic
-- ----------------------------
DROP TABLE IF EXISTS `t_dynamic`;
CREATE TABLE `t_dynamic` (
  `dynamic_id` varchar(32) NOT NULL COMMENT '动态主键',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `images` varchar(255) DEFAULT NULL COMMENT '图片JsonArray格式',
  `first_image` varchar(32) DEFAULT NULL COMMENT '首帧图',
  `video` varchar(32) DEFAULT NULL COMMENT '视频',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `see_type` int(2) DEFAULT NULL COMMENT '谁可以看 1公开2医护好友3患者可见4自己可见',
  `dynamic_flag` int(2) DEFAULT '1' COMMENT '动态标识 1纯文本2带图片3带视频',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int(2) DEFAULT '1' COMMENT '状态 0无效1有效',
  `content` text CHARACTER SET utf8mb4 COMMENT '动态内容',
  PRIMARY KEY (`dynamic_id`),
  KEY `index_hug_id` (`hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='动态';

-- ----------------------------
-- Table structure for t_dynamic_like
-- ----------------------------
DROP TABLE IF EXISTS `t_dynamic_like`;
CREATE TABLE `t_dynamic_like` (
  `like_id` varchar(32) NOT NULL COMMENT '主键',
  `dynamic_id` varchar(32) NOT NULL COMMENT '动态编码',
  `hug_id` varchar(32) NOT NULL COMMENT '点赞人蓝牛号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`like_id`),
  UNIQUE KEY `unique_dh` (`dynamic_id`,`hug_id`),
  KEY `index_dynamic_id` (`dynamic_id`),
  KEY `index_hug_id` (`hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='动态点赞';

-- ----------------------------
-- Table structure for t_early_child_health_check_record
-- ----------------------------
DROP TABLE IF EXISTS `t_early_child_health_check_record`;
CREATE TABLE `t_early_child_health_check_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `record_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `body_temperature` double DEFAULT NULL COMMENT '体温',
  `breath_time` int(11) DEFAULT NULL COMMENT '呼吸',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL,
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL,
  `next_check_time` varchar(32) DEFAULT NULL,
  `check_unit` varchar(96) DEFAULT NULL,
  `checker` varchar(96) DEFAULT NULL,
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='新生儿早期健康检查记录';

-- ----------------------------
-- Table structure for t_education_drug
-- ----------------------------
DROP TABLE IF EXISTS `t_education_drug`;
CREATE TABLE `t_education_drug` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '机构代码',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `serial_no` varchar(50) DEFAULT NULL COMMENT '业务流水号',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '患者姓名',
  `content` mediumtext COMMENT '用药教育单内容',
  `first_remind` varchar(200) DEFAULT NULL COMMENT '用药教育单提醒开头语',
  `end_remind` varchar(200) DEFAULT NULL COMMENT '用药教育单提醒结束语',
  `short_url` varchar(200) DEFAULT NULL COMMENT '短链接url',
  `saveFlag` tinyint(4) DEFAULT NULL COMMENT '是否已保存 1是 0否',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_KEY` (`hosp_code`,`serial_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='宣教用药教育单';

-- ----------------------------
-- Table structure for t_education_lib
-- ----------------------------
DROP TABLE IF EXISTS `t_education_lib`;
CREATE TABLE `t_education_lib` (
  `id` varchar(32) NOT NULL,
  `title` varchar(32) NOT NULL COMMENT '标题',
  `content` text NOT NULL COMMENT '内容',
  `begin_content` text COMMENT '头内容',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `questionnaire_id` varchar(32) NOT NULL COMMENT '问卷id',
  `questionnaire_version` varchar(32) DEFAULT NULL COMMENT '问卷版本号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `url_flag` varchar(2) DEFAULT NULL COMMENT '内容是url标识 1是 其他不是',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_questionnaire_id_and_version` (`questionnaire_id`,`questionnaire_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宣教库表';

-- ----------------------------
-- Table structure for t_education_patient_push
-- ----------------------------
DROP TABLE IF EXISTS `t_education_patient_push`;
CREATE TABLE `t_education_patient_push` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `scene_id` varchar(16) NOT NULL COMMENT '场景id',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院代码',
  `staff_index` varchar(64) DEFAULT NULL COMMENT '职工id',
  `source_type` int(10) NOT NULL COMMENT '患者来源',
  `serial_no` varchar(64) NOT NULL COMMENT '业务流水号',
  `keyword` text COMMENT '关键字',
  `business_time` varchar(32) DEFAULT NULL COMMENT '业务发生时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_education_record
-- ----------------------------
DROP TABLE IF EXISTS `t_education_record`;
CREATE TABLE `t_education_record` (
  `id` varchar(32) NOT NULL,
  `lib_id` varchar(32) NOT NULL COMMENT '宣教库表id（关联作用）',
  `pat_name` varchar(32) NOT NULL COMMENT '姓名',
  `inhosp_no` varchar(20) DEFAULT NULL COMMENT '住院号',
  `receive_hug` varchar(20) DEFAULT NULL COMMENT '蓝牛号',
  `phone` varchar(20) DEFAULT NULL,
  `id_card` varchar(20) DEFAULT NULL COMMENT '身份证',
  `relation_type` int(2) DEFAULT NULL COMMENT '患者关联任务类型',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '患者关联任务id',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `is_back` int(1) DEFAULT NULL COMMENT '是否回复',
  `back_time` datetime DEFAULT NULL COMMENT '回复时间',
  `back_msg` text COMMENT '回复内容',
  `send_hug` varchar(32) DEFAULT NULL COMMENT '发送者蓝牛号',
  `send_name` varchar(32) DEFAULT NULL COMMENT '发送者姓名',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '发送者随访id',
  `dept_code` varchar(32) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(32) DEFAULT NULL COMMENT '科室名称',
  `ward_code` varchar(32) DEFAULT NULL COMMENT '病区代码',
  `ward_name` varchar(32) DEFAULT NULL COMMENT '病区名称',
  `send_from` int(1) NOT NULL COMMENT '发送来源（1 app  2随访 ）',
  `record_id` varchar(32) DEFAULT NULL COMMENT 'IM消息记录主键',
  `valid_days` int(2) DEFAULT NULL,
  `no_juge` varchar(5) DEFAULT NULL COMMENT '是否直接查看答案',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院代码',
  `url` varchar(500) DEFAULT NULL COMMENT '宣教url',
  PRIMARY KEY (`id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_inhosp_no` (`inhosp_no`),
  KEY `idx_id_card` (`id_card`),
  KEY `idx_lib_id` (`lib_id`),
  KEY `idx_relation_id` (`relation_id`),
  KEY `idx_pat_name` (`pat_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宣教记录表';

-- ----------------------------
-- Table structure for t_education_statistics_v1
-- ----------------------------
DROP TABLE IF EXISTS `t_education_statistics_v1`;
CREATE TABLE `t_education_statistics_v1` (
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '医院名称',
  `education_total` bigint(20) DEFAULT '1' COMMENT '宣教发送数',
  `education_read` bigint(20) DEFAULT '0' COMMENT '宣教已读数',
  `education_click` bigint(20) DEFAULT '0' COMMENT '宣教点击数',
  `send_date` date NOT NULL COMMENT '发送日期',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE KEY `idx_unique` (`hosp_code`,`send_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_education_statistics_v2
-- ----------------------------
DROP TABLE IF EXISTS `t_education_statistics_v2`;
CREATE TABLE `t_education_statistics_v2` (
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '医院名称',
  `lib_id` varchar(32) NOT NULL COMMENT '宣教库id',
  `title` varchar(32) DEFAULT NULL COMMENT '宣教标题',
  `education_total` bigint(20) DEFAULT '1' COMMENT '宣教发送数',
  `education_read` bigint(20) DEFAULT '0' COMMENT '宣教已读数',
  `education_click` bigint(20) DEFAULT '0' COMMENT '宣教点击数',
  `send_date` date NOT NULL COMMENT '发送日期',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE KEY `idx_unique` (`hosp_code`,`lib_id`,`send_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_eight_months_record
-- ----------------------------
DROP TABLE IF EXISTS `t_eight_months_record`;
CREATE TABLE `t_eight_months_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `add_meat_month` int(11) DEFAULT NULL COMMENT '给宝宝添加肉类的时间',
  `add_egg_month` int(11) DEFAULT NULL COMMENT '给宝宝添加蛋类的时间',
  `first_teeth_month` int(11) DEFAULT NULL COMMENT '宝宝出第一颗牙的时间',
  `play_game_flag` tinyint(1) DEFAULT NULL COMMENT '是否与宝宝玩“躲猫猫”游戏',
  `sound_response_flag` tinyint(1) DEFAULT NULL COMMENT '听到声音有应答',
  `distinguish_stranger_acquaintance_flag` tinyint(1) DEFAULT NULL COMMENT '会区分生人和熟人',
  `both_hands_toy_flag` tinyint(1) DEFAULT NULL COMMENT '双手间会传递玩具',
  `sit_alone_flag` tinyint(1) DEFAULT NULL COMMENT '会独坐',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `head_circumference` double DEFAULT NULL COMMENT '头围',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL,
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL,
  `next_check_time` varchar(32) DEFAULT NULL,
  `check_unit` varchar(96) DEFAULT NULL,
  `checker` varchar(976) DEFAULT NULL,
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='八个月记录';

-- ----------------------------
-- Table structure for t_electronic_prescribe
-- ----------------------------
DROP TABLE IF EXISTS `t_electronic_prescribe`;
CREATE TABLE `t_electronic_prescribe` (
  `id` varchar(40) NOT NULL,
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '机构代码',
  `health_manage_user_id` varchar(40) DEFAULT NULL COMMENT '健康管理师id',
  `health_manage_user_name` varchar(20) DEFAULT NULL COMMENT '健康管理师姓名',
  `doctor_id` varchar(40) DEFAULT NULL COMMENT '开处方医生id',
  `doctor_name` varchar(20) DEFAULT NULL COMMENT '开处方医生姓名',
  `doctor_dept_code` varchar(40) DEFAULT NULL COMMENT '医生所属科室编码',
  `doctor_dept_name` varchar(20) DEFAULT NULL COMMENT '医生所属科室名称',
  `electronic_prescribe_info` varchar(2000) DEFAULT NULL COMMENT '处方笺信息',
  `pat_name` varchar(20) DEFAULT NULL COMMENT '患者姓名',
  `id_card` varchar(22) DEFAULT NULL COMMENT '患者身份证号',
  `mobile_no` varchar(20) DEFAULT NULL COMMENT '患者手机号',
  `create_date` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间 数据入表',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='在线开处方笺记录表';

-- ----------------------------
-- Table structure for t_equ_topic
-- ----------------------------
DROP TABLE IF EXISTS `t_equ_topic`;
CREATE TABLE `t_equ_topic` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `equ_id` varchar(100) DEFAULT NULL,
  `type_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_esb_discharge_count
-- ----------------------------
DROP TABLE IF EXISTS `t_esb_discharge_count`;
CREATE TABLE `t_esb_discharge_count` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(30) NOT NULL COMMENT '医院编码',
  `discharge_count` int(11) NOT NULL DEFAULT '0' COMMENT '出院人次',
  `discharge_date` date NOT NULL COMMENT '出院日期',
  `call_date` date NOT NULL COMMENT '调用日期',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_hosp_code_discharge_date` (`hosp_code`,`discharge_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='医院接口出院人次表（数据延迟）';

-- ----------------------------
-- Table structure for t_esb_monitor_field_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_esb_monitor_field_rule`;
CREATE TABLE `t_esb_monitor_field_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `interface_code` varchar(10) NOT NULL COMMENT '接口代码',
  `field_code` varchar(45) NOT NULL COMMENT '字段code',
  `rule_code` tinyint(4) NOT NULL COMMENT '规则代码 RuleEnum 1、非空 2、唯一 3、枚举 4、长度 5、类型 6、字典',
  `rule_name` varchar(10) NOT NULL COMMENT '规则名称',
  `salt_field_code` varchar(64) DEFAULT NULL COMMENT '唯一属性比对盐列',
  `max_length` int(11) DEFAULT NULL COMMENT '最大长度',
  `range_type_code` varchar(20) DEFAULT NULL COMMENT '值域类型代码',
  `range_type_name` varchar(45) DEFAULT NULL COMMENT '值域类型名称',
  `field_type` tinyint(4) DEFAULT NULL COMMENT '字段类型 FieldEnum (1、整数 2、日期yyyy-MM-dd 3、时间 yyyy-MM-dd HH:mm:ss 4、身份证 5、手机号码 6、不含空格)\n\n                                                            字段字典 FieldDict (11、科室字典 12、疾病字典 13、药品字典 14、职工字典 15、手术字典)',
  `field_type_name` varchar(40) DEFAULT NULL COMMENT '字段类型名称',
  `level` tinyint(4) NOT NULL COMMENT '级别 LevelEnum 1、异常 2、警告 3、诊断信息',
  `level_name` varchar(10) NOT NULL COMMENT '级别名称 LevelEnum 1、异常 2、警告 3、诊断信息',
  `is_acquiescent` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否默认 0否 1是',
  `is_efficacious` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否有效 0无效 1有效',
  `is_force` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否强制更新 0不强制更新 1强制更新',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1126 DEFAULT CHARSET=utf8 COMMENT='ESB数据校验字段规则表';

-- ----------------------------
-- Table structure for t_esb_monitor_warn
-- ----------------------------
DROP TABLE IF EXISTS `t_esb_monitor_warn`;
CREATE TABLE `t_esb_monitor_warn` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hosp_code` varchar(100) NOT NULL COMMENT '机构代码',
  `hosp_name` varchar(255) DEFAULT NULL COMMENT '机构名称',
  `inform_value` varchar(255) DEFAULT NULL COMMENT '通知内容',
  `inform_time` datetime NOT NULL COMMENT '通知时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='esb-monitor 预警表';

-- ----------------------------
-- Table structure for t_exam_register
-- ----------------------------
DROP TABLE IF EXISTS `t_exam_register`;
CREATE TABLE `t_exam_register` (
  `id` varchar(32) NOT NULL COMMENT '体检预约编号',
  `hosp_code` varchar(50) NOT NULL COMMENT '医院编码',
  `reg_status` int(1) DEFAULT '1' COMMENT '预约状态无效(-1)，已预约(1)，已确认（2），已取消（3），已过期（4），预约未成功（5）',
  `hg_id` varchar(32) NOT NULL COMMENT '用户ID',
  `family_id` varchar(32) DEFAULT NULL COMMENT '成员ID',
  `card_id` varchar(200) DEFAULT NULL COMMENT '卡号ID',
  `category_name` varchar(32) DEFAULT NULL COMMENT '类别名称',
  `package_no` varchar(32) DEFAULT NULL COMMENT '套餐标号',
  `package_price` varchar(32) DEFAULT NULL COMMENT '套餐价格',
  `applicable_sex` varchar(32) DEFAULT NULL COMMENT '适合性别',
  `applicable_crowd` varchar(32) DEFAULT NULL COMMENT '适合人群',
  `exam_item` varchar(200) DEFAULT NULL COMMENT '体检项目',
  `create_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `package_name` varchar(32) DEFAULT NULL COMMENT '套餐名称',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '病人姓名',
  `card` varchar(64) DEFAULT NULL COMMENT '身份证号',
  `phone` varchar(32) DEFAULT NULL COMMENT '电话号码',
  `description` varchar(255) DEFAULT NULL COMMENT '说明',
  `exam_date` varchar(20) DEFAULT NULL COMMENT '体检日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='体检预约';

-- ----------------------------
-- Table structure for t_family_tree
-- ----------------------------
DROP TABLE IF EXISTS `t_family_tree`;
CREATE TABLE `t_family_tree` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `grandfather_path` varchar(96) DEFAULT NULL COMMENT '爷爷',
  `grandmother_path` varchar(96) DEFAULT NULL COMMENT '奶奶',
  `grandpa_path` varchar(96) DEFAULT NULL COMMENT '姥爷',
  `grandma_path` varchar(96) DEFAULT NULL COMMENT '姥姥',
  `father_path` varchar(96) DEFAULT NULL COMMENT '爸爸',
  `mother_path` varchar(96) DEFAULT NULL COMMENT '妈妈',
  `child_path_one` varchar(96) DEFAULT NULL COMMENT '孩子1',
  `child_path_two` varchar(96) DEFAULT NULL COMMENT '孩子2',
  `child_path_three` varchar(96) DEFAULT NULL COMMENT '孩子3',
  `child_path_four` varchar(96) DEFAULT NULL COMMENT '孩子4',
  `child_path_five` varchar(96) DEFAULT NULL COMMENT '孩子5',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='家庭树';

-- ----------------------------
-- Table structure for t_faq
-- ----------------------------
DROP TABLE IF EXISTS `t_faq`;
CREATE TABLE `t_faq` (
  `id` varchar(32) NOT NULL,
  `question` text COMMENT '问题',
  `answer` text COMMENT '答案',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客服常见问题表';

-- ----------------------------
-- Table structure for t_faq_category
-- ----------------------------
DROP TABLE IF EXISTS `t_faq_category`;
CREATE TABLE `t_faq_category` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '随访账号id',
  `category_name` varchar(50) DEFAULT NULL COMMENT '分类名称',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='常见问题分类表';

-- ----------------------------
-- Table structure for t_faq_hosp
-- ----------------------------
DROP TABLE IF EXISTS `t_faq_hosp`;
CREATE TABLE `t_faq_hosp` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `category_id` varchar(32) DEFAULT NULL COMMENT '分类id',
  `question` varchar(50) DEFAULT NULL COMMENT '问题',
  `answer` varchar(500) DEFAULT NULL COMMENT '答案',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sourse_name` varchar(32) DEFAULT NULL COMMENT '随访名',
  `download_number` int(11) DEFAULT NULL COMMENT '下载次数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='医院常见问题';

-- ----------------------------
-- Table structure for t_faq_person
-- ----------------------------
DROP TABLE IF EXISTS `t_faq_person`;
CREATE TABLE `t_faq_person` (
  `id` varchar(32) NOT NULL,
  `relation_id` varchar(32) DEFAULT NULL COMMENT 't_faq_hosp 主键id',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '随访账号id',
  `category_id` varchar(32) DEFAULT NULL COMMENT '分类id',
  `question` varchar(50) DEFAULT NULL COMMENT '问题',
  `answer` varchar(500) DEFAULT NULL COMMENT '答案',
  `click` int(1) DEFAULT '0' COMMENT '点击次数',
  `helpful` int(1) DEFAULT '0' COMMENT '有帮助',
  `not_helpful` int(1) DEFAULT '0' COMMENT '没有帮助',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sort_no` int(11) DEFAULT NULL COMMENT '排序',
  `sourse_name` varchar(32) DEFAULT NULL COMMENT '随访名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='个人常见问题';

-- ----------------------------
-- Table structure for t_fee_his
-- ----------------------------
DROP TABLE IF EXISTS `t_fee_his`;
CREATE TABLE `t_fee_his` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hug_id` varchar(32) DEFAULT NULL,
  `nick` varchar(50) DEFAULT NULL,
  `target_hug_id` varchar(32) DEFAULT NULL,
  `target_name` varchar(50) DEFAULT NULL,
  `type` int(2) DEFAULT NULL,
  `money` int(11) DEFAULT NULL,
  `time` bigint(19) DEFAULT NULL,
  `state` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_fee_recording
-- ----------------------------
DROP TABLE IF EXISTS `t_fee_recording`;
CREATE TABLE `t_fee_recording` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hug_id` varchar(32) DEFAULT NULL,
  `target_hug_id` varchar(32) DEFAULT NULL,
  `target_name` varchar(50) DEFAULT NULL,
  `c_left` int(8) DEFAULT NULL,
  `total` int(8) DEFAULT NULL,
  `type` int(2) DEFAULT NULL,
  `begin_time` bigint(19) DEFAULT NULL,
  `success_back` int(1) DEFAULT NULL,
  `c_open` int(1) DEFAULT NULL,
  `end_time` bigint(19) DEFAULT NULL,
  `money` int(1) DEFAULT NULL,
  `money_end` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_fetal_movement_record
-- ----------------------------
DROP TABLE IF EXISTS `t_fetal_movement_record`;
CREATE TABLE `t_fetal_movement_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `record_time` date DEFAULT NULL COMMENT '记录胎动日期',
  `morning_fetalmovement_num` int(11) DEFAULT NULL COMMENT '早上胎动次数',
  `nooning_fetalmovement_num` int(11) DEFAULT NULL COMMENT '中午胎动次数',
  `evening_fetalmovement_num` int(11) DEFAULT NULL COMMENT '晚上胎动次数',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_fetalheart_fetusposition
-- ----------------------------
DROP TABLE IF EXISTS `t_fetalheart_fetusposition`;
CREATE TABLE `t_fetalheart_fetusposition` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `fetal_heart_sound` int(11) DEFAULT NULL COMMENT '胎位',
  `fetus_position` varchar(32) DEFAULT NULL COMMENT '胎心',
  `pregnant_fourten_month_check_record_id` varchar(32) NOT NULL COMMENT '孕4-10月健康检查主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_five_years_record
-- ----------------------------
DROP TABLE IF EXISTS `t_five_years_record`;
CREATE TABLE `t_five_years_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hold_painting_flag` tinyint(1) DEFAULT NULL COMMENT '每天握笔画画吗',
  `distinguish_colors_flag` tinyint(1) DEFAULT NULL COMMENT '能辨别红、黄、绿、蓝颜色吗',
  `adapt_kindergarten_life_flag` tinyint(1) DEFAULT NULL COMMENT '习惯幼儿园的集体生活',
  `wear_off_clothes_flag` tinyint(1) DEFAULT NULL COMMENT '能自己穿脱衣服吗',
  `simply_tell_things_flag` tinyint(1) DEFAULT NULL COMMENT '简单叙说事情经过',
  `know_own_sex_flag` tinyint(1) DEFAULT NULL COMMENT '知道自己的性别',
  `eat_with_chopsticks_flag` tinyint(1) DEFAULT NULL COMMENT '用筷子吃饭',
  `jump_alone_flag` tinyint(1) DEFAULT NULL COMMENT '单脚跳',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `five_year_old_message` varchar(2048) DEFAULT NULL COMMENT '五岁生日寄语',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `left_eye_vision` double DEFAULT NULL COMMENT '左眼视力',
  `right_eye_vision` double DEFAULT NULL COMMENT '右眼视力',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL COMMENT '异常描述',
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL COMMENT '需要关注的事情',
  `next_check_time` varchar(32) DEFAULT NULL COMMENT '下次检查时间',
  `check_unit` varchar(96) DEFAULT NULL COMMENT '检查单位',
  `checker` varchar(976) DEFAULT NULL COMMENT '检查者',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='五岁记录';

-- ----------------------------
-- Table structure for t_follow
-- ----------------------------
DROP TABLE IF EXISTS `t_follow`;
CREATE TABLE `t_follow` (
  `follow_id` varchar(32) NOT NULL COMMENT '主键',
  `hug_id` varchar(32) NOT NULL COMMENT '蓝牛号',
  `target_hug_id` varchar(32) NOT NULL COMMENT '目标蓝牛号',
  `remark_name` varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '备注名',
  `message_disturb` int(1) DEFAULT '0' COMMENT '消息免打扰 0关闭1开启',
  `pinyin_code` varchar(20) DEFAULT NULL COMMENT '拼音码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效 1有效',
  PRIMARY KEY (`follow_id`),
  KEY `follow_hug_id` (`hug_id`),
  KEY `follow_target_hug_id` (`target_hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='关注表';

-- ----------------------------
-- Table structure for t_followup_push_record
-- ----------------------------
DROP TABLE IF EXISTS `t_followup_push_record`;
CREATE TABLE `t_followup_push_record` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `dept_code` varchar(32) NOT NULL COMMENT '科室代码',
  `dept_name` varchar(128) NOT NULL COMMENT '科室名称',
  `user_id` varchar(32) NOT NULL COMMENT '用户名ID',
  `user_name` varchar(32) NOT NULL COMMENT '用户姓名',
  `work_number` varchar(32) NOT NULL COMMENT '用户工号',
  `push_type` tinyint(4) NOT NULL COMMENT '推送类型，昨日随访情况：1',
  `start_time` varchar(32) DEFAULT NULL COMMENT '记录查询开始时间',
  `end_time` varchar(32) DEFAULT NULL COMMENT '记录查询结束时间',
  `content` varchar(255) NOT NULL COMMENT '推送内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='随访情况推送记录表';

-- ----------------------------
-- Table structure for t_form_ai
-- ----------------------------
DROP TABLE IF EXISTS `t_form_ai`;
CREATE TABLE `t_form_ai` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '组织机构代码',
  `phone` varchar(32) DEFAULT NULL COMMENT '手机号',
  `id_card_no` varchar(20) DEFAULT NULL COMMENT '身份证',
  `hug_id` varchar(50) DEFAULT NULL COMMENT '蓝牛号',
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `task_id` varchar(32) NOT NULL COMMENT '任务id',
  `questionnaire_id` varchar(32) NOT NULL COMMENT '问卷id',
  `questionnaire_version` varchar(32) DEFAULT NULL COMMENT '问卷版本号',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `doc_hug_id` varchar(20) DEFAULT NULL COMMENT '医生蓝牛号',
  `doc_name` varchar(20) DEFAULT NULL COMMENT '医生姓名',
  `sourse_id` varchar(32) NOT NULL COMMENT '随访医生主键',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `sex` int(2) DEFAULT NULL COMMENT '性别 1女2男',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ai表单';

-- ----------------------------
-- Table structure for t_form_lib
-- ----------------------------
DROP TABLE IF EXISTS `t_form_lib`;
CREATE TABLE `t_form_lib` (
  `id` varchar(32) NOT NULL,
  `title` varchar(32) NOT NULL COMMENT '标题',
  `content` mediumtext NOT NULL COMMENT '内容',
  `begin_content` text COMMENT '头内容',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `questionnaire_id` varchar(32) NOT NULL COMMENT '问卷id',
  `questionnaire_version` varchar(32) DEFAULT NULL COMMENT '问卷版本号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_questionnaire_id_and_version` (`questionnaire_id`,`questionnaire_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='问卷库表';

-- ----------------------------
-- Table structure for t_form_record
-- ----------------------------
DROP TABLE IF EXISTS `t_form_record`;
CREATE TABLE `t_form_record` (
  `id` varchar(32) NOT NULL,
  `lib_id` varchar(32) NOT NULL COMMENT '宣教库表id（关联作用）',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '姓名',
  `inhosp_no` varchar(20) DEFAULT NULL COMMENT '住院号',
  `receive_hug` varchar(20) DEFAULT NULL COMMENT '蓝牛号',
  `phone` varchar(20) DEFAULT NULL,
  `id_card` varchar(20) DEFAULT NULL COMMENT '身份证',
  `relation_type` int(2) DEFAULT NULL COMMENT '患者关联任务类型',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '患者关联任务id',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `is_back` int(1) DEFAULT NULL COMMENT '是否回复',
  `back_time` datetime DEFAULT NULL COMMENT '回复时间',
  `back_msg` text COMMENT '回复内容',
  `send_hug` varchar(32) DEFAULT NULL COMMENT '发送者蓝牛号',
  `send_name` varchar(32) DEFAULT NULL COMMENT '发送者姓名',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '发送者随访id',
  `dept_code` varchar(32) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(32) DEFAULT NULL COMMENT '科室名称',
  `ward_code` varchar(32) DEFAULT NULL COMMENT '病区代码',
  `ward_name` varchar(32) DEFAULT NULL COMMENT '病区名称',
  `send_from` int(1) NOT NULL COMMENT '发送来源（1 app  2随访 ）',
  `record_id` varchar(32) DEFAULT NULL COMMENT 'IM消息记录主键',
  `valid_days` int(2) DEFAULT NULL,
  `no_juge` varchar(5) DEFAULT NULL COMMENT '是否直接查看答案',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `url` varchar(500) DEFAULT NULL COMMENT '表单url',
  `summary` text COMMENT '表单总结',
  PRIMARY KEY (`id`),
  KEY `idx_lib_id` (`lib_id`),
  KEY `index_inter_phone` (`phone`) USING BTREE,
  KEY `idx_id_card` (`id_card`) USING BTREE,
  KEY `idx_inhosp_no` (`inhosp_no`) USING BTREE,
  KEY `idx_pat_name` (`pat_name`) USING BTREE,
  KEY `idx_relation_id` (`relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='问卷记录表';

-- ----------------------------
-- Table structure for t_form_statistics_v1
-- ----------------------------
DROP TABLE IF EXISTS `t_form_statistics_v1`;
CREATE TABLE `t_form_statistics_v1` (
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '医院名称',
  `form_total` bigint(20) DEFAULT '1' COMMENT '表单发送数',
  `form_back` bigint(20) DEFAULT '0' COMMENT '表单回复数',
  `send_date` date NOT NULL COMMENT '发送日期',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE KEY `idx_unique` (`hosp_code`,`send_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_form_statistics_v2
-- ----------------------------
DROP TABLE IF EXISTS `t_form_statistics_v2`;
CREATE TABLE `t_form_statistics_v2` (
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '医院名称',
  `lib_id` varchar(32) NOT NULL COMMENT '表单库id',
  `title` varchar(32) DEFAULT NULL COMMENT '表单标题',
  `form_total` bigint(20) DEFAULT '1' COMMENT '表单发送数',
  `form_back` bigint(20) DEFAULT '0' COMMENT '表单回复数',
  `relation_type` int(11) DEFAULT NULL COMMENT '患者关联任务类型',
  `send_date` date NOT NULL COMMENT '发送日期',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE KEY `idx_unique` (`hosp_code`,`lib_id`,`relation_type`,`send_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_four_years_record
-- ----------------------------
DROP TABLE IF EXISTS `t_four_years_record`;
CREATE TABLE `t_four_years_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `kindergarten_flag` tinyint(1) DEFAULT NULL COMMENT '入幼儿园了',
  `use_scissor_flag` tinyint(1) DEFAULT NULL COMMENT '使用儿童剪刀剪东西',
  `wc_alone_flag` tinyint(1) DEFAULT NULL COMMENT '能独立上厕所',
  `tell_simple_story_flag` tinyint(1) DEFAULT NULL COMMENT '讲简单的小故事',
  `electronic_video_time` double DEFAULT NULL COMMENT '每天看电子视频产品的时间',
  `outdoor_activities_time` double DEFAULT NULL COMMENT '每天户外活动的时间',
  `say_adjective_sentence_flag` tinyint(1) DEFAULT NULL COMMENT '会说带形容词的句子',
  `required_wait_rotate_flag` tinyint(1) DEFAULT NULL COMMENT '能按要求等待或轮流',
  `dress_alone_flag` tinyint(1) DEFAULT NULL COMMENT '会独立穿衣',
  `stand_alone_flag` tinyint(1) DEFAULT NULL COMMENT '会单脚站立',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `four_year_old_message` varchar(2048) DEFAULT NULL COMMENT '四岁生日寄语',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `left_eye_vision` double DEFAULT NULL COMMENT '左眼视力',
  `right_eye_vision` double DEFAULT NULL COMMENT '右眼视力',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL COMMENT '异常描述',
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL COMMENT '需要关注的事情',
  `next_check_time` varchar(32) DEFAULT NULL COMMENT '下次检查时间',
  `check_unit` varchar(96) DEFAULT NULL COMMENT '检查单位',
  `checker` varchar(976) DEFAULT NULL COMMENT '检查者',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='四岁记录';

-- ----------------------------
-- Table structure for t_friend
-- ----------------------------
DROP TABLE IF EXISTS `t_friend`;
CREATE TABLE `t_friend` (
  `friend_id` varchar(32) NOT NULL,
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `target_hug_id` varchar(32) DEFAULT NULL COMMENT '目标蓝牛号',
  `remark_name` varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '备注名',
  `been_see_dynamics` int(2) DEFAULT '1' COMMENT '他看我的动态 0否1是',
  `see_dynamics` int(2) DEFAULT '1' COMMENT '看他动态 0否1是',
  `message_disturb` int(2) DEFAULT NULL COMMENT '消息免打扰 0关闭1开启',
  `pinyin_code` varchar(20) DEFAULT NULL COMMENT '拼音码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int(2) DEFAULT '1' COMMENT '状态 0无效 1有效',
  PRIMARY KEY (`friend_id`),
  KEY `index_hug_id` (`hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='好友关系';

-- ----------------------------
-- Table structure for t_friend_apply
-- ----------------------------
DROP TABLE IF EXISTS `t_friend_apply`;
CREATE TABLE `t_friend_apply` (
  `apply_id` varchar(32) NOT NULL COMMENT '主键',
  `apply_hug_id` varchar(32) DEFAULT NULL COMMENT '申请者hugId',
  `target_hug_id` varchar(32) DEFAULT NULL COMMENT '目标hugId',
  `apply_status` int(1) DEFAULT '0' COMMENT '申请状态 0申请中1通过2不通过',
  `apply_desc` varchar(255) DEFAULT NULL COMMENT '申请说明',
  `refuse_reason` varchar(255) DEFAULT NULL COMMENT '拒绝原因',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效1有效',
  PRIMARY KEY (`apply_id`),
  KEY `index_apply_hug_id` (`apply_hug_id`),
  KEY `index_target_hug_id` (`target_hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='好友申请表';

-- ----------------------------
-- Table structure for t_global_id
-- ----------------------------
DROP TABLE IF EXISTS `t_global_id`;
CREATE TABLE `t_global_id` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `server_sequence` varchar(32) DEFAULT NULL COMMENT '服务器序列',
  `prefixion` varchar(20) DEFAULT NULL COMMENT '前缀字母',
  `curr_no` bigint(30) DEFAULT NULL COMMENT '当前所用的序号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_health
-- ----------------------------
DROP TABLE IF EXISTS `t_health`;
CREATE TABLE `t_health` (
  `health_id` varchar(64) NOT NULL COMMENT '主键',
  `health_type` int(2) DEFAULT NULL COMMENT '类型 1胎心2血压3血糖4体温5心率',
  `health_value` text COMMENT '数值',
  `health_unit` varchar(500) DEFAULT NULL,
  `health_status` int(2) DEFAULT NULL COMMENT '健康状态',
  `measuring_time` varchar(20) DEFAULT NULL COMMENT '测量时间 yyyy-MM-dd HH:mm:ss',
  `instruction` mediumtext,
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
  `energy` double(11,5) DEFAULT NULL COMMENT '能量',
  `device_type` int(11) DEFAULT NULL COMMENT '设备类型',
  `third_id` varchar(50) DEFAULT NULL COMMENT '第三方数据id值',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医生所属医院编码',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '医生id',
  `doc_name` varchar(20) DEFAULT NULL COMMENT '医生姓名',
  `remark` varchar(250) DEFAULT NULL COMMENT '备注',
  `update_person_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `update_person_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `update_dept_code` varchar(20) DEFAULT NULL COMMENT '编辑人科室编码',
  `update_dept_name` varchar(25) DEFAULT NULL COMMENT '编辑人科室名称',
  `source_type` int(2) DEFAULT NULL COMMENT '来源(1门诊2出院3在院13建档（其他）99健康小屋(新附一个性化需求)',
  PRIMARY KEY (`health_id`),
  KEY `health_hug_id` (`hug_id`) USING BTREE,
  KEY `idx_measuring_time` (`measuring_time`) USING BTREE,
  KEY `health_type_hug_id` (`health_type`,`hug_id`,`status`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_healthid_measuretime` (`health_id`,`measuring_time`) USING BTREE,
  KEY `idx_health_id` (`health_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康数据';

-- ----------------------------
-- Table structure for t_health_abnormal
-- ----------------------------
DROP TABLE IF EXISTS `t_health_abnormal`;
CREATE TABLE `t_health_abnormal` (
  `id` varchar(32) NOT NULL,
  `health_id` varchar(32) DEFAULT NULL COMMENT '健康主键',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `doc_hug_id` varchar(32) DEFAULT NULL COMMENT '医生蓝牛号',
  `health_status` int(2) DEFAULT NULL COMMENT '健康状态 0正常 -1偏低 1偏高 -2偏廋2偏胖3肥胖10偏低/偏低11偏低/正常12偏低/偏高13正常/偏低/14正常/正常15正常/偏高16偏高/偏低17偏高/正常18偏高/偏高',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康监测异常表';

-- ----------------------------
-- Table structure for t_health_abnormal_app
-- ----------------------------
DROP TABLE IF EXISTS `t_health_abnormal_app`;
CREATE TABLE `t_health_abnormal_app` (
  `family_id` varchar(60) DEFAULT NULL,
  `rule` varchar(5000) DEFAULT NULL,
  `ct` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `card` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_health_abnormal_level
-- ----------------------------
DROP TABLE IF EXISTS `t_health_abnormal_level`;
CREATE TABLE `t_health_abnormal_level` (
  `hosp_code` varchar(255) DEFAULT NULL COMMENT '医院机构编码',
  `ssy_level1_min_value` int(10) DEFAULT NULL COMMENT '收缩压轻度异常最小值',
  `ssy_level1_max_value` int(10) DEFAULT NULL COMMENT '收缩压轻度异常最大值',
  `ssy_level2_min_value` int(10) DEFAULT NULL COMMENT '收缩压中度异常最小值',
  `ssy_level2_max_value` int(10) DEFAULT NULL COMMENT '收缩压中度异常最大值',
  `ssy_level3_min_value` int(10) DEFAULT NULL COMMENT '收缩压重度异常最小值',
  `ssy_level3_max_value` int(10) DEFAULT NULL COMMENT '收缩压重度异常最大值',
  `szy_level1_min_value` int(10) DEFAULT NULL COMMENT '舒张压轻度异常最小值',
  `szy_level1_max_value` int(10) DEFAULT NULL COMMENT '舒张压轻度异常最大值',
  `szy_level2_min_value` int(10) DEFAULT NULL COMMENT '舒张压中度异常最小值',
  `szy_level2_max_value` int(10) DEFAULT NULL COMMENT '舒张压中度异常最大值',
  `szy_level3_min_value` int(10) DEFAULT NULL COMMENT '舒张压重度异常最小值',
  `szy_level3_max_value` int(10) DEFAULT NULL COMMENT '舒张压重度异常最大值',
  `fkf_level1_min_value` double(10,1) DEFAULT NULL COMMENT '非空腹轻度异常最小值',
  `fkf_level1_max_value` double(10,1) DEFAULT NULL COMMENT '非空腹轻度异常最大值',
  `fkf_level2_min_value` double(10,1) DEFAULT NULL COMMENT '非空腹中度异常最小值',
  `fkf_level2_max_value` double(10,1) DEFAULT NULL COMMENT '非空腹中度异常最大值',
  `fkf_level3_min_value` double(10,1) DEFAULT NULL COMMENT '非空腹重度异常最小值',
  `fkf_level3_max_value` double(10,1) DEFAULT NULL COMMENT '非空腹重度异常最大值',
  `kf_level1_min_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)轻度异常最小值',
  `kf_level1_max_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)轻度异常最大值',
  `kf_level2_min_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)中度异常最小值',
  `kf_level2_max_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)中度异常最大值',
  `kf_level3_min_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)重度异常最小值',
  `kf_level3_max_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)重度异常最大值',
  `xl_level1_min_value` double(10,1) DEFAULT NULL COMMENT '心率轻度异常最小值',
  `xl_level1_max_value` double(10,1) DEFAULT NULL COMMENT '心率轻度异常最大值',
  `xl_level2_min_value` double(10,1) DEFAULT NULL COMMENT '心率中度异常最小值',
  `xl_level2_max_value` double(10,1) DEFAULT NULL COMMENT '心率中度异常最大值',
  `xl_level3_min_value` double(10,1) DEFAULT NULL COMMENT '心率重度异常最小值',
  `xl_level3_max_value` double(10,1) DEFAULT NULL COMMENT '心率重度异常最大值',
  `xy_level1_min_value` double(10,1) DEFAULT NULL COMMENT '血氧轻度异常最小值',
  `xy_level1_max_value` double(10,1) DEFAULT NULL COMMENT '血氧轻度异常最大值',
  `xy_level2_min_value` double(10,1) DEFAULT NULL COMMENT '血氧中度异常最小值',
  `xy_level2_max_value` double(10,1) DEFAULT NULL COMMENT '血氧中度异常最大值',
  `xy_level3_min_value` double(10,1) DEFAULT NULL COMMENT '血氧重度异常最小值',
  `xy_level3_max_value` double(10,1) DEFAULT NULL COMMENT '血氧重度异常最大值',
  `ssy_level1_age_min_value` int(10) DEFAULT NULL COMMENT '收缩压轻度异常大于65岁最小值',
  `ssy_level1_age_max_value` int(10) DEFAULT NULL COMMENT '收缩压轻度异常大于65岁最大值',
  `szy_level1_age_min_value` int(10) DEFAULT NULL COMMENT '舒张压轻度异常大于65岁最小值',
  `szy_level1_age_max_value` int(10) DEFAULT NULL COMMENT '舒张压轻度异常大于65岁最大值',
  `fkf_level3_age_min_value` double(10,1) DEFAULT NULL COMMENT '非空腹重度异常大于60岁最小值',
  `fkf_level3_age_max_value` double(10,1) DEFAULT NULL COMMENT '非空腹重度异常大于60岁最大值',
  `kf_level3_age_min_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)重度异常大于60岁最小值',
  `kf_level3_age_max_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)重度异常大于60岁最大值',
  `fkf_level2_age_min_value` double(10,1) DEFAULT NULL COMMENT '非空腹中度异常大于60岁最小值',
  `fkf_level2_age_max_value` double(10,1) DEFAULT NULL COMMENT '非空腹中度异常大于60岁最大值',
  `kf_level2_age_min_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)中度异常大于60岁最小值 ',
  `kf_level2_age_max_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)中度异常大于60岁最大值',
  `fkf_level1_age_min_value` double(10,1) DEFAULT NULL COMMENT '非空腹轻度异常大于60岁最小值',
  `fkf_level1_age_max_value` double(10,1) DEFAULT NULL COMMENT '非空腹轻度异常大于60岁最大值',
  `kf_level1_age_min_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)轻度异常大于60岁最小值',
  `kf_level1_age_max_value` double(10,1) DEFAULT NULL COMMENT '空腹(早餐前)轻度异常大于60岁最大值'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='异常等级表';

-- ----------------------------
-- Table structure for t_health_assessment_record
-- ----------------------------
DROP TABLE IF EXISTS `t_health_assessment_record`;
CREATE TABLE `t_health_assessment_record` (
  `id` varchar(10) NOT NULL COMMENT '主键id',
  `pat_name` varchar(10) NOT NULL COMMENT '姓名',
  `id_number` varchar(32) DEFAULT NULL COMMENT '身份证',
  `mobile_no` varchar(20) DEFAULT NULL COMMENT '手机号',
  `relation_id` varchar(32) NOT NULL COMMENT '关联id',
  `url` varchar(100) DEFAULT NULL COMMENT '评估url',
  `content` text NOT NULL COMMENT '评估内容',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `quarter` int(11) DEFAULT NULL COMMENT '季度',
  `is_quarterly_report` int(11) DEFAULT NULL COMMENT '年报/季报标识  1:季报  2:年报',
  PRIMARY KEY (`id`),
  KEY `index_relation_id` (`relation_id`) USING BTREE,
  KEY `index_send_time` (`send_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康评估记录表';

-- ----------------------------
-- Table structure for t_health_breath_record
-- ----------------------------
DROP TABLE IF EXISTS `t_health_breath_record`;
CREATE TABLE `t_health_breath_record` (
  `id` varchar(32) NOT NULL,
  `user_id` varchar(32) DEFAULT NULL COMMENT '医生id',
  `user_name` varchar(32) DEFAULT NULL COMMENT '医生姓名',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `measuring_date` varchar(32) DEFAULT NULL COMMENT '测量日期',
  `suggestion` varchar(1000) DEFAULT NULL COMMENT '医生建议',
  `health_list` text COMMENT '勾选的呼吸数据的健康id',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '患者蓝牛号',
  `reporter_id` varchar(50) DEFAULT NULL COMMENT '报告id',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `health_type` varchar(50) DEFAULT NULL COMMENT '健康数据类型',
  `level` varchar(50) DEFAULT NULL COMMENT '数据等级 A B C',
  `value` varchar(50) DEFAULT NULL COMMENT '数据的值 FEV1/FVC',
  `is_delete` int(4) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_health_configure
-- ----------------------------
DROP TABLE IF EXISTS `t_health_configure`;
CREATE TABLE `t_health_configure` (
  `configure_id` varchar(64) NOT NULL COMMENT '主键',
  `name` varchar(12) DEFAULT NULL COMMENT '姓名',
  `age` int(11) DEFAULT NULL COMMENT '年龄',
  `sex` int(11) DEFAULT NULL COMMENT '性别 1女 2男',
  `id_card` varchar(32) DEFAULT NULL COMMENT '身份证',
  `phone` varchar(11) NOT NULL COMMENT '手机号',
  `card_type` int(11) DEFAULT NULL COMMENT '卡类型',
  `card_no` varchar(64) DEFAULT NULL COMMENT '卡号',
  `health_type` int(11) NOT NULL COMMENT '类型 1胎心2血压3血糖4体温5心率6体重',
  `hosp_code` varchar(64) NOT NULL COMMENT '医院编码',
  `value` varchar(255) NOT NULL COMMENT '值',
  `status` int(11) DEFAULT '1' COMMENT '状态 0无效 1有效',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE KEY `health_configure_unique` (`phone`,`hosp_code`,`health_type`),
  KEY `index_phone` (`phone`),
  KEY `index_hospCode` (`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_health_configure_record
-- ----------------------------
DROP TABLE IF EXISTS `t_health_configure_record`;
CREATE TABLE `t_health_configure_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `value` int(11) DEFAULT NULL COMMENT '次数',
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '医院编码',
  `configure_id` varchar(64) DEFAULT NULL COMMENT 'configure_id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `operator_id` int(11) DEFAULT NULL COMMENT '操作员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='胎心次数修改记录表';

-- ----------------------------
-- Table structure for t_health_data
-- ----------------------------
DROP TABLE IF EXISTS `t_health_data`;
CREATE TABLE `t_health_data` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `data_type` int(4) DEFAULT NULL,
  `data_value2` varchar(50) DEFAULT NULL,
  `data_value` varchar(50) DEFAULT NULL,
  `data_time` varchar(50) DEFAULT NULL,
  `sub_data_type` int(4) DEFAULT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  `sourse_type` int(4) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `normal_flag` varchar(50) DEFAULT NULL,
  `normal_flag2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_health_data_sync_record
-- ----------------------------
DROP TABLE IF EXISTS `t_health_data_sync_record`;
CREATE TABLE `t_health_data_sync_record` (
  `id` varchar(32) NOT NULL,
  `type` int(1) NOT NULL COMMENT '类型 1智汇鞋',
  `device_code` varchar(128) NOT NULL COMMENT '设备代码',
  `hug_id` varchar(64) DEFAULT NULL COMMENT '蓝牛号',
  `success_flag` int(1) NOT NULL COMMENT '成功标识 0不成功 1成功',
  `sync_time` datetime NOT NULL COMMENT '同步数据时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `health_type` int(11) DEFAULT NULL COMMENT '健康类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康数据同步记录表';

-- ----------------------------
-- Table structure for t_health_device
-- ----------------------------
DROP TABLE IF EXISTS `t_health_device`;
CREATE TABLE `t_health_device` (
  `health_device_id` varchar(32) NOT NULL,
  `type` int(1) NOT NULL COMMENT '设备类型 1心电设备',
  `device_code` varchar(128) NOT NULL COMMENT '设备代码',
  `source_id` varchar(32) NOT NULL COMMENT '设备使用者-蓝牛号hugID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `member_id` varchar(64) DEFAULT NULL COMMENT '成员id',
  `third_index_no` varchar(128) DEFAULT NULL COMMENT '第三方主索引',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `source_name` varchar(50) DEFAULT NULL COMMENT '用户姓名',
  `source_phone` varchar(50) DEFAULT NULL COMMENT '用户手机号',
  `equip_name` varchar(50) DEFAULT NULL COMMENT '设备名称',
  `doc_name` varchar(50) DEFAULT NULL COMMENT '医生姓名',
  `device_type` varchar(50) DEFAULT NULL COMMENT '设备类型 PF286 RBP-9801等',
  PRIMARY KEY (`health_device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康设备表';

-- ----------------------------
-- Table structure for t_health_device_distrub
-- ----------------------------
DROP TABLE IF EXISTS `t_health_device_distrub`;
CREATE TABLE `t_health_device_distrub` (
  `id` varchar(40) NOT NULL,
  `device_type` varchar(40) DEFAULT NULL COMMENT '设备类型',
  `device_code` varchar(40) DEFAULT NULL COMMENT '设备编码',
  `pat_hug_id` varchar(20) DEFAULT NULL COMMENT '患者蓝牛号',
  `doc_hug_id` varchar(40) DEFAULT NULL COMMENT '医生蓝牛号',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` int(1) DEFAULT NULL COMMENT '删除标志位 0未删除 1已删除',
  `function_flag` int(1) DEFAULT NULL COMMENT '屏蔽标志位  0不屏蔽 1启用屏蔽',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备报警信息记录';

-- ----------------------------
-- Table structure for t_health_disease
-- ----------------------------
DROP TABLE IF EXISTS `t_health_disease`;
CREATE TABLE `t_health_disease` (
  `id` varchar(100) DEFAULT NULL COMMENT '主键ID',
  `team_id` varchar(100) DEFAULT NULL COMMENT '团队ID',
  `disease_name` varchar(255) DEFAULT NULL COMMENT '疾病名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` int(11) DEFAULT NULL COMMENT '删除 0:未删除 1:已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='擅长疾病列表';

-- ----------------------------
-- Table structure for t_health_disease_path
-- ----------------------------
DROP TABLE IF EXISTS `t_health_disease_path`;
CREATE TABLE `t_health_disease_path` (
  `id` varchar(100) DEFAULT NULL COMMENT '主键ID',
  `team_id` varchar(100) DEFAULT NULL COMMENT '团队ID',
  `path_name` varchar(255) DEFAULT NULL COMMENT '疾病名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` int(11) DEFAULT NULL COMMENT '删除 0:未删除 1:已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='疾病路径列表';

-- ----------------------------
-- Table structure for t_health_doc_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `t_health_doc_evaluation`;
CREATE TABLE `t_health_doc_evaluation` (
  `id` varchar(40) NOT NULL,
  `health_type` varchar(40) DEFAULT NULL COMMENT '健康数据类型',
  `doc_hug_id` varchar(40) DEFAULT NULL COMMENT '医生蓝牛号',
  `doc_name` varchar(40) DEFAULT NULL COMMENT '医生姓名',
  `pat_hug_id` varchar(20) DEFAULT NULL COMMENT '患者蓝牛号',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` int(1) DEFAULT NULL COMMENT '删除标志位 0未删除 1已删除',
  `evaluation` varchar(500) DEFAULT NULL COMMENT '医生评价',
  `health_id` varchar(32) DEFAULT NULL COMMENT '健康数据id',
  `doc_head` varchar(256) DEFAULT NULL COMMENT '医生头像',
  `health_date` varchar(32) DEFAULT NULL COMMENT '健康数据日期 年月日',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康数据医生建议';

-- ----------------------------
-- Table structure for t_health_expect
-- ----------------------------
DROP TABLE IF EXISTS `t_health_expect`;
CREATE TABLE `t_health_expect` (
  `id` varchar(50) DEFAULT NULL COMMENT '预计值表id',
  `value` text,
  `hug_id` varchar(50) DEFAULT NULL COMMENT '蓝牛号 蓝牛健康id',
  `measuring_time` varchar(50) DEFAULT NULL COMMENT '测量日期 yyyy-MM-dd',
  `device_type` int(4) DEFAULT NULL COMMENT '设备类型 ',
  `is_delete` int(4) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_health_handle_abnormal
-- ----------------------------
DROP TABLE IF EXISTS `t_health_handle_abnormal`;
CREATE TABLE `t_health_handle_abnormal` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(20) DEFAULT NULL COMMENT '蓝牛号',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `id_card_no` varchar(32) DEFAULT NULL COMMENT '身份证',
  `phone` varchar(50) DEFAULT NULL COMMENT '手机号',
  `name` varchar(20) DEFAULT NULL COMMENT '患者姓名',
  `doc_hug_id` varchar(20) DEFAULT NULL COMMENT '医生蓝牛号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '1' COMMENT '删除标识 0 删除 1未删除',
  `health_type` int(2) NOT NULL COMMENT '类型 1胎心2血压3血糖4体温5心率38运动视频',
  `handle_status` tinyint(4) DEFAULT '0' COMMENT '异常状态 0 未处理 1 已处理',
  `days` varchar(50) DEFAULT '0' COMMENT '连续未观看视频时间',
  `monitor_time` datetime DEFAULT NULL COMMENT '监测时间',
  `last_time` datetime DEFAULT NULL COMMENT '上一次观看视频时间',
  `doc_name` varchar(50) DEFAULT NULL COMMENT '医生姓名',
  `handle_time` datetime DEFAULT NULL COMMENT '处理时间',
  `handle_hug_id` varchar(50) DEFAULT NULL COMMENT '处理人hugId',
  `handle_name` varchar(50) DEFAULT NULL COMMENT '处理人姓名',
  PRIMARY KEY (`id`),
  KEY `t_doc_hug_id_index` (`doc_hug_id`,`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='异常处理记录';

-- ----------------------------
-- Table structure for t_health_handle_record
-- ----------------------------
DROP TABLE IF EXISTS `t_health_handle_record`;
CREATE TABLE `t_health_handle_record` (
  `id` varchar(32) NOT NULL,
  `health_id` varchar(32) DEFAULT NULL COMMENT '健康数据主键',
  `hosp_code` varchar(255) DEFAULT NULL,
  `doc_hug_id` varchar(32) DEFAULT NULL COMMENT '医生hugid',
  `handle_hug_id` varchar(32) DEFAULT NULL COMMENT '处理医生hugid',
  `doc_name` varchar(30) DEFAULT NULL COMMENT '医生姓名',
  `handle_id` varchar(400) DEFAULT NULL COMMENT '处理id',
  `handle_name` varchar(400) DEFAULT NULL COMMENT '处理名称',
  `value` text COMMENT '处理结果',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_health_hospital
-- ----------------------------
DROP TABLE IF EXISTS `t_health_hospital`;
CREATE TABLE `t_health_hospital` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `health_type` int(2) DEFAULT NULL COMMENT '类型 1胎心2血压3血糖4体温5心率6身高体重',
  `health_value` text COMMENT '数值',
  `health_unit` varchar(10) DEFAULT NULL COMMENT '单位',
  `health_status` int(2) DEFAULT NULL COMMENT '健康状态',
  `measuring_time` varchar(20) DEFAULT NULL COMMENT '测量时间 yyyy-MM-dd HH:mm:ss',
  `instruction` text COMMENT '说明',
  `measuring_point` int(2) DEFAULT NULL COMMENT '测量点 1早餐前2早餐后3午餐前4午餐后5晚餐前6晚餐后7睡前',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `resource_id` varchar(64) DEFAULT NULL COMMENT '文件id',
  `pat_id` varchar(64) DEFAULT NULL COMMENT '病人id',
  `visit_card_no` varchar(64) DEFAULT NULL COMMENT '就诊卡号',
  `visit_no` varchar(64) DEFAULT NULL COMMENT '就诊序号',
  `hosp_code` varchar(64) DEFAULT NULL COMMENT '医院编码',
  `id_card_no` varchar(18) DEFAULT NULL COMMENT '身份证号',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效1有效',
  `artificial_flag` int(11) DEFAULT '0' COMMENT '人工上传标志(1:是0:否)',
  `source_id` varchar(32) DEFAULT NULL COMMENT '医生随访帐号id',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `birth_date` date DEFAULT NULL COMMENT '出生日期',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室编码',
  `dept_name` varchar(30) DEFAULT NULL COMMENT '科室名称',
  `ward_code` varchar(30) DEFAULT NULL COMMENT '病区编码',
  `ward_name` varchar(30) DEFAULT NULL COMMENT '病区名称',
  `bed_no` varchar(20) DEFAULT NULL COMMENT '床号',
  `remark` varchar(250) DEFAULT NULL COMMENT '备注',
  `update_person_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `update_person_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `update_dept_code` varchar(20) DEFAULT NULL COMMENT '编辑人科室编码',
  `update_dept_name` varchar(25) DEFAULT NULL COMMENT '编辑人科室名称',
  `device_type` int(2) DEFAULT NULL COMMENT '设备类型',
  `source_type` int(2) DEFAULT NULL COMMENT '来源(1门诊2出院3在院13建档（其他）99健康小屋(新附一个性化需求) 88院内血糖',
  `false_data` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_name_phone_createtime` (`name`,`phone`,`create_time`) COMMENT 'create by DAS-3556743d-dcc4-4e9c-a753-e6564e506e14'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康数据院内';

-- ----------------------------
-- Table structure for t_health_hospital2
-- ----------------------------
DROP TABLE IF EXISTS `t_health_hospital2`;
CREATE TABLE `t_health_hospital2` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `health_type` int(2) DEFAULT NULL COMMENT '类型 1胎心2血压3血糖4体温5心率6身高体重',
  `health_value` text COMMENT '数值',
  `health_unit` varchar(10) DEFAULT NULL COMMENT '单位',
  `health_status` int(2) DEFAULT NULL COMMENT '健康状态',
  `measuring_time` varchar(20) DEFAULT NULL COMMENT '测量时间 yyyy-MM-dd HH:mm:ss',
  `instruction` text COMMENT '说明',
  `measuring_point` int(2) DEFAULT NULL COMMENT '测量点 1早餐前2早餐后3午餐前4午餐后5晚餐前6晚餐后7睡前',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `resource_id` varchar(64) DEFAULT NULL COMMENT '文件id',
  `pat_id` varchar(64) DEFAULT NULL COMMENT '病人id',
  `visit_card_no` varchar(64) DEFAULT NULL COMMENT '就诊卡号',
  `visit_no` varchar(64) DEFAULT NULL COMMENT '就诊序号',
  `hosp_code` varchar(64) DEFAULT NULL COMMENT '医院编码',
  `id_card_no` varchar(18) DEFAULT NULL COMMENT '身份证号',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效1有效',
  `artificial_flag` int(11) DEFAULT '0' COMMENT '人工上传标志(1:是0:否)',
  `source_id` varchar(32) DEFAULT NULL COMMENT '医生随访帐号id',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `birth_date` date DEFAULT NULL COMMENT '出生日期',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室编码',
  `dept_name` varchar(30) DEFAULT NULL COMMENT '科室名称',
  `ward_code` varchar(30) DEFAULT NULL COMMENT '病区编码',
  `ward_name` varchar(30) DEFAULT NULL COMMENT '病区名称',
  `bed_no` varchar(20) DEFAULT NULL COMMENT '床号',
  `remark` varchar(250) DEFAULT NULL COMMENT '备注',
  `update_person_id` varchar(32) DEFAULT NULL COMMENT '编辑人id',
  `update_person_name` varchar(50) DEFAULT NULL COMMENT '编辑人姓名',
  `update_dept_code` varchar(20) DEFAULT NULL COMMENT '编辑人科室编码',
  `update_dept_name` varchar(25) DEFAULT NULL COMMENT '编辑人科室名称',
  `device_type` int(2) DEFAULT NULL COMMENT '设备类型',
  `source_type` int(2) DEFAULT NULL COMMENT '来源(1门诊2出院3在院13建档（其他）99健康小屋(新附一个性化需求) 88院内血糖',
  `false_data` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康数据院内';

-- ----------------------------
-- Table structure for t_health_hospital_xfy_fjsl
-- ----------------------------
DROP TABLE IF EXISTS `t_health_hospital_xfy_fjsl`;
CREATE TABLE `t_health_hospital_xfy_fjsl` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `heath_id` varchar(64) NOT NULL COMMENT 't_health_hospital 主键',
  `id_card_no` varchar(18) DEFAULT NULL COMMENT '患者身份证号',
  `files` varchar(300) DEFAULT NULL COMMENT 'pdf附件',
  `evaluation_result` text COMMENT '评估结果',
  PRIMARY KEY (`id`),
  KEY `heath_id` (`heath_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康数据院内-福建省立心肺仪';

-- ----------------------------
-- Table structure for t_health_monitor_on_time
-- ----------------------------
DROP TABLE IF EXISTS `t_health_monitor_on_time`;
CREATE TABLE `t_health_monitor_on_time` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(20) DEFAULT NULL COMMENT '蓝牛号',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `id_card_no` varchar(32) DEFAULT NULL COMMENT '身份证',
  `phone` varchar(50) DEFAULT NULL COMMENT '手机号',
  `name` varchar(20) DEFAULT NULL COMMENT '患者姓名',
  `doc_hug_id` varchar(20) DEFAULT NULL COMMENT '医生蓝牛号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '1' COMMENT '删除标识 0删除 1未删除',
  `health_type` int(2) NOT NULL COMMENT '类型 1胎心2血压3血糖4体温5心率38运动视频',
  `days` tinyint(4) DEFAULT '0' COMMENT '设置天数',
  `doc_name` varchar(50) DEFAULT NULL COMMENT '医生姓名',
  `handle_time` datetime DEFAULT NULL COMMENT '处理时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `t_doc_hug_id_index` (`doc_hug_id`,`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='按时监测设置表';

-- ----------------------------
-- Table structure for t_health_monitor_remind_record
-- ----------------------------
DROP TABLE IF EXISTS `t_health_monitor_remind_record`;
CREATE TABLE `t_health_monitor_remind_record` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(64) NOT NULL COMMENT '医院编码',
  `pat_name` varchar(32) NOT NULL COMMENT '患者姓名',
  `id_card` varchar(32) DEFAULT NULL COMMENT '患者身份证号码',
  `mobile_no` varchar(32) NOT NULL COMMENT '患者手机号',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '患者索引',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联记录ID',
  `param_ext` varchar(255) DEFAULT NULL COMMENT '拓展参数',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_relation_id` (`relation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康监测提醒记录';

-- ----------------------------
-- Table structure for t_health_program
-- ----------------------------
DROP TABLE IF EXISTS `t_health_program`;
CREATE TABLE `t_health_program` (
  `pro_id` varchar(32) NOT NULL,
  `pro_code` varchar(32) NOT NULL COMMENT '方案编码',
  `pro_name` varchar(64) DEFAULT NULL COMMENT '方案名称',
  `pro_img` varchar(512) DEFAULT NULL COMMENT '方案图片',
  `phone` varchar(32) NOT NULL COMMENT '手机号',
  `id_card_no` varchar(32) DEFAULT NULL COMMENT '身份证',
  `doc_code` varchar(32) NOT NULL COMMENT '医生编码',
  `doc_name` varchar(32) NOT NULL COMMENT '医生名称',
  `doc_title` varchar(32) DEFAULT NULL COMMENT '医生职称',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `pro_status` int(1) DEFAULT '1' COMMENT '方案状态 1进行中 2已暂停 3已结束',
  `pro_date` varchar(32) DEFAULT NULL COMMENT '方案日期',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `program_desc` text COMMENT '方案描述',
  PRIMARY KEY (`pro_id`),
  KEY `idx_hospcode` (`hosp_code`) COMMENT 'create by DAS-2e836b33-b993-44aa-9a73-9102b15a27e1-0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康方案表';

-- ----------------------------
-- Table structure for t_health_push_share
-- ----------------------------
DROP TABLE IF EXISTS `t_health_push_share`;
CREATE TABLE `t_health_push_share` (
  `id` varchar(32) NOT NULL,
  `shared_sourse_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `group_id` varchar(32) DEFAULT NULL COMMENT '分组id',
  `doc_hug_id` varchar(20) DEFAULT NULL COMMENT '医生蓝牛号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康监测异常推送共享配置';

-- ----------------------------
-- Table structure for t_health_push_user
-- ----------------------------
DROP TABLE IF EXISTS `t_health_push_user`;
CREATE TABLE `t_health_push_user` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(20) DEFAULT NULL COMMENT '蓝牛号',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '主索引号',
  `id_card_no` varchar(32) DEFAULT NULL COMMENT '身份证',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `name` varchar(20) DEFAULT NULL COMMENT '患者姓名',
  `doc_hug_id` varchar(20) DEFAULT NULL COMMENT '医生蓝牛号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `operator_id` int(11) DEFAULT NULL COMMENT '操作员',
  `threshold` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '阈值',
  `doc_name` varchar(50) DEFAULT NULL COMMENT '医生姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='健康监测异常推送用户配置';

-- ----------------------------
-- Table structure for t_health_report
-- ----------------------------
DROP TABLE IF EXISTS `t_health_report`;
CREATE TABLE `t_health_report` (
  `report_id` varchar(32) NOT NULL COMMENT '健康报告主键',
  `health_id` text,
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `name` varchar(12) DEFAULT NULL COMMENT '姓名',
  `age` int(11) DEFAULT NULL COMMENT '年龄',
  `gestational_weeks` varchar(12) DEFAULT NULL COMMENT '孕周',
  `phone` varchar(18) DEFAULT NULL COMMENT '手机号',
  `start_time` varchar(30) DEFAULT NULL COMMENT '开始时间 yyyy-mm-dd HH:mm:ss',
  `end_time` varchar(30) DEFAULT NULL COMMENT '结束时间 yyyy-mm-dd HH:mm:ss',
  `doc_name` varchar(30) DEFAULT NULL COMMENT '监测医生',
  `take_time` varchar(10) DEFAULT NULL COMMENT '时长',
  `value` text COMMENT '结果',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` int(11) DEFAULT '1' COMMENT '状态 0无效1有效',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `report_time` varchar(32) DEFAULT NULL COMMENT '监测时间',
  `min_width` int(11) DEFAULT NULL COMMENT ' 走纸速度',
  `doc_hug_id` varchar(32) DEFAULT NULL COMMENT '医生编码',
  `upload_id` varchar(32) DEFAULT NULL COMMENT 'upload表主键',
  `health_type` int(4) DEFAULT NULL COMMENT '健康类型   TAIXIN(1, ‘胎心’)  SLEEP_INPUT(14, ’手工录入睡眠信息‘);',
  `hug_id` varchar(50) DEFAULT NULL COMMENT '患者蓝牛号',
  PRIMARY KEY (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康监测报告';

-- ----------------------------
-- Table structure for t_health_sports_record
-- ----------------------------
DROP TABLE IF EXISTS `t_health_sports_record`;
CREATE TABLE `t_health_sports_record` (
  `id` char(32) NOT NULL,
  `hug_id` varchar(32) DEFAULT NULL COMMENT '客户蓝牛号',
  `id_card` char(18) DEFAULT NULL COMMENT '身份证',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '患者姓名',
  `mobile_no` varchar(20) DEFAULT NULL COMMENT '手机',
  `event_date` date DEFAULT NULL COMMENT '活动日期',
  `sedentary` decimal(6,2) DEFAULT NULL COMMENT '久坐时间（分钟/天）',
  `light_physical_activity` decimal(6,2) DEFAULT NULL COMMENT '轻度体力活动（分钟/天）',
  `moderate_physical_activity` decimal(6,2) DEFAULT NULL COMMENT '中度体力活动（分钟/天）',
  `step` smallint(6) DEFAULT NULL COMMENT '步数/天',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `phone_patname_eventdate_idcard_index` (`mobile_no`,`pat_name`,`event_date`,`id_card`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康监测-体动记录仪监测数据';

-- ----------------------------
-- Table structure for t_health_task
-- ----------------------------
DROP TABLE IF EXISTS `t_health_task`;
CREATE TABLE `t_health_task` (
  `task_id` varchar(32) NOT NULL,
  `task_code` varchar(32) NOT NULL COMMENT '任务编码',
  `task_name` varchar(64) DEFAULT NULL COMMENT '任务名称',
  `health_code` varchar(32) NOT NULL COMMENT '健康编码',
  `health_name` varchar(64) NOT NULL COMMENT '健康名称',
  `health_type` int(1) NOT NULL COMMENT '健康类型 1胎心2血压3血糖4体温5心率6体重7运动8心电9饮食',
  `task_date` varchar(32) NOT NULL COMMENT '任务日期',
  `pro_id` varchar(32) NOT NULL COMMENT '方案主键',
  `phone` varchar(16) NOT NULL COMMENT '手机号',
  `task_value` text NOT NULL COMMENT '任务内容',
  `energy` double DEFAULT NULL,
  `finish_flag` int(1) DEFAULT '0' COMMENT '是否完成 0否1是',
  `health_id` varchar(32) DEFAULT NULL COMMENT '健康主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `task_detail_title` varchar(64) DEFAULT NULL COMMENT '任务详情标题',
  `protein` double DEFAULT NULL COMMENT '蛋白质',
  `fat` double DEFAULT NULL COMMENT '脂肪',
  `carbohydrate` double DEFAULT NULL COMMENT '碳水化合物',
  `monitor_type` varchar(2) DEFAULT NULL COMMENT '1随机测量 2固定时间段测量',
  `period` varchar(200) DEFAULT NULL COMMENT '测量时间段',
  `sort_no` int(11) DEFAULT NULL COMMENT '排序号',
  PRIMARY KEY (`task_id`),
  KEY `idx_pro_id` (`pro_id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_taskdate_proid_finishflag_isdelete` (`task_date`,`pro_id`,`finish_flag`,`is_delete`) COMMENT 'create by DAS-2e836b33-b993-44aa-9a73-9102b15a27e1-0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康任务表';

-- ----------------------------
-- Table structure for t_health_task_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_health_task_detail`;
CREATE TABLE `t_health_task_detail` (
  `video_id` varchar(32) NOT NULL,
  `task_id` varchar(32) NOT NULL COMMENT '任务id',
  `video_name` varchar(50) DEFAULT NULL COMMENT '视频名称',
  `video_url` varchar(255) DEFAULT NULL COMMENT '视频地址',
  `img_url` varchar(255) DEFAULT NULL COMMENT '封面地址',
  `video_level` tinyint(4) DEFAULT NULL COMMENT '视频难度 1 2 3星',
  `video_length` int(11) DEFAULT NULL COMMENT '视频长度 以秒为单位',
  `target_length` int(11) DEFAULT NULL COMMENT '目标长度 以秒为单位',
  `play_length` int(11) DEFAULT '0' COMMENT '播放长度 以秒为单位',
  `target_times` tinyint(4) DEFAULT NULL COMMENT '目标次数',
  `finish_times` tinyint(4) DEFAULT '0' COMMENT '已完成次数',
  `finish_status` tinyint(4) DEFAULT '0' COMMENT '完成状态 0未完成 1已完成',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `sort_no` int(11) DEFAULT NULL COMMENT '排序号',
  `phone` varchar(16) DEFAULT NULL COMMENT '手机号',
  PRIMARY KEY (`video_id`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_update_time` (`update_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运动任务视频详情表';

-- ----------------------------
-- Table structure for t_health_team
-- ----------------------------
DROP TABLE IF EXISTS `t_health_team`;
CREATE TABLE `t_health_team` (
  `id` varchar(100) NOT NULL,
  `name` varchar(255) DEFAULT NULL COMMENT '团队名称',
  `image_id` varchar(50) DEFAULT NULL COMMENT '团队图片',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院代码',
  `hosp_name` varchar(255) DEFAULT NULL COMMENT '医院名称',
  `dept_code` varchar(50) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(255) DEFAULT NULL COMMENT '科室名称',
  `leader_hug_id` varchar(50) DEFAULT NULL COMMENT '医生负责人hug_id',
  `leader_name` varchar(255) DEFAULT NULL COMMENT '医生负责人姓名',
  `region_code` varchar(50) DEFAULT NULL COMMENT '地区编码',
  `trait` varchar(500) DEFAULT NULL COMMENT '团队特点',
  `remarks` varchar(500) DEFAULT NULL COMMENT '团队简介',
  `score` varchar(50) DEFAULT NULL COMMENT '评分',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `fans` int(11) DEFAULT NULL COMMENT '粉丝',
  `is_delete` int(11) DEFAULT NULL COMMENT '删除 0:未删除 1:已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健管团队列表';

-- ----------------------------
-- Table structure for t_health_third
-- ----------------------------
DROP TABLE IF EXISTS `t_health_third`;
CREATE TABLE `t_health_third` (
  `id` varchar(40) NOT NULL,
  `value` text COMMENT '健康数据',
  `type` int(2) DEFAULT NULL COMMENT '健康数据类型',
  `hug_id` varchar(20) DEFAULT NULL COMMENT '患者蓝牛号',
  `measuring_time` varchar(40) DEFAULT NULL COMMENT '测量时间',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `sign` varchar(40) DEFAULT NULL COMMENT '数据唯一值',
  `source_type` int(2) DEFAULT NULL COMMENT '数据来源',
  PRIMARY KEY (`id`),
  KEY `idx_sign` (`sign`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='第三方健康数据已同步表';

-- ----------------------------
-- Table structure for t_health_upload
-- ----------------------------
DROP TABLE IF EXISTS `t_health_upload`;
CREATE TABLE `t_health_upload` (
  `upload_id` varchar(32) NOT NULL COMMENT '主键',
  `health_id` varchar(32) NOT NULL COMMENT '健康数据主键',
  `hosp_code` varchar(32) DEFAULT NULL,
  `status` int(11) DEFAULT '1' COMMENT '状态 0无效1有效',
  `data_status` int(11) DEFAULT NULL COMMENT '数据状态  1 未处理 2 已处理 ',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `doc_hug_id` varchar(32) DEFAULT NULL COMMENT '医生蓝牛号',
  `charge_id` varchar(32) DEFAULT NULL COMMENT 'charge表主键',
  PRIMARY KEY (`upload_id`),
  KEY `index_healthId` (`health_id`),
  KEY `index_hospCode` (`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='健康数据上传';

-- ----------------------------
-- Table structure for t_hosp_card
-- ----------------------------
DROP TABLE IF EXISTS `t_hosp_card`;
CREATE TABLE `t_hosp_card` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构id',
  `hosp_name` varchar(200) NOT NULL COMMENT '机构name',
  `tel_num_arr` varchar(1024) NOT NULL COMMENT '手机号码',
  `media_id` varchar(300) NOT NULL DEFAULT '' COMMENT '资源id',
  `qr_url` varchar(300) NOT NULL DEFAULT '' COMMENT '二维码地址',
  `class_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建id',
  `update_id` varchar(32) NOT NULL COMMENT '修改id',
  `create_by` varchar(32) NOT NULL COMMENT '创建人',
  `update_by` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1831585389521575938 DEFAULT CHARSET=utf8 COMMENT='医院电话名片表';

-- ----------------------------
-- Table structure for t_hosp_im_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_hosp_im_relation`;
CREATE TABLE `t_hosp_im_relation` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '组织机构代码',
  `voip_amount` varchar(50) NOT NULL COMMENT '云通讯账号',
  `voip_pwd` varchar(50) NOT NULL COMMENT '云通讯密码',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ai表单';

-- ----------------------------
-- Table structure for t_hosp_interface_statistical
-- ----------------------------
DROP TABLE IF EXISTS `t_hosp_interface_statistical`;
CREATE TABLE `t_hosp_interface_statistical` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(30) NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '医院名称',
  `interface_code` varchar(30) NOT NULL COMMENT '接口代码',
  `interface_name` varchar(100) NOT NULL COMMENT '接口名称',
  `interface_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '接口状态(0:无效;1:启用)',
  `statistical_type_code` tinyint(1) NOT NULL DEFAULT '0' COMMENT '接口统计分类Code(1-A:基础接口;2-B:扩展接口;3-C:预约挂号接口)',
  `interface_res` int(11) NOT NULL DEFAULT '0' COMMENT '调用接口返回状态',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_hosp_code_interface_code_name` (`hosp_code`,`interface_code`,`interface_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='统计接口达标情况';

-- ----------------------------
-- Table structure for t_im_group
-- ----------------------------
DROP TABLE IF EXISTS `t_im_group`;
CREATE TABLE `t_im_group` (
  `group_id` varchar(32) NOT NULL,
  `group_name` varchar(100) DEFAULT NULL COMMENT '群聊名称',
  `group_admin_hug_id` varchar(50) NOT NULL COMMENT '群主蓝牛号',
  `group_icon` varchar(32) DEFAULT NULL COMMENT '群图标',
  `group_total_number` int(4) NOT NULL COMMENT '群总人数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `group_type` varchar(32) DEFAULT '1' COMMENT '1-普通 2-健康团队 ',
  `power_view_type` varchar(32) DEFAULT '1' COMMENT '1-所有人可见 2-患者本人可见',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='群聊表';

-- ----------------------------
-- Table structure for t_im_group_at
-- ----------------------------
DROP TABLE IF EXISTS `t_im_group_at`;
CREATE TABLE `t_im_group_at` (
  `id` varchar(32) NOT NULL,
  `group_id` varchar(32) DEFAULT NULL COMMENT '群聊id',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '@发送人',
  `target_hug_id` varchar(32) DEFAULT NULL COMMENT '@接收人',
  `record_id` varchar(32) DEFAULT NULL COMMENT '消息id',
  `message_content` varchar(500) DEFAULT NULL COMMENT '文字内容',
  `read_flag` int(1) DEFAULT '0' COMMENT '已读标识 0:未读 1:已读',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='群聊@消息记录表';

-- ----------------------------
-- Table structure for t_im_group_delete
-- ----------------------------
DROP TABLE IF EXISTS `t_im_group_delete`;
CREATE TABLE `t_im_group_delete` (
  `group_id` varchar(32) NOT NULL,
  `group_name` varchar(100) DEFAULT NULL COMMENT '群聊名称',
  `group_admin_hug_id` varchar(50) NOT NULL COMMENT '群主蓝牛号',
  `group_icon` varchar(32) DEFAULT NULL COMMENT '群图标',
  `group_total_number` int(4) NOT NULL COMMENT '群总人数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='被删除群聊表';

-- ----------------------------
-- Table structure for t_im_group_user
-- ----------------------------
DROP TABLE IF EXISTS `t_im_group_user`;
CREATE TABLE `t_im_group_user` (
  `id` varchar(32) NOT NULL,
  `group_id` varchar(32) NOT NULL COMMENT '群聊id',
  `user_nick_name` varchar(50) DEFAULT NULL COMMENT '昵称',
  `user_empid` varchar(50) DEFAULT NULL COMMENT '患者主索引号',
  `user_hug_id` varchar(50) DEFAULT NULL COMMENT '蓝牛号',
  `user_role` int(1) DEFAULT NULL COMMENT '用户角色',
  `phone` varchar(18) DEFAULT NULL COMMENT '手机号',
  `idcard` varchar(18) DEFAULT NULL COMMENT '身份证',
  `voip_amount` varchar(50) DEFAULT NULL COMMENT '云通讯账号',
  `sex` int(1) DEFAULT NULL COMMENT '性别',
  `user_type` int(1) NOT NULL COMMENT '患者医生标志, 0 患者 3 医生',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `back_time` timestamp NULL DEFAULT NULL COMMENT '退群时间',
  `machine_code` varchar(200) DEFAULT NULL COMMENT '机器码',
  `im_push_flag` int(1) DEFAULT '1' COMMENT '是否推送消息 1是 2否',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='群聊用户表';

-- ----------------------------
-- Table structure for t_im_group_user_delete
-- ----------------------------
DROP TABLE IF EXISTS `t_im_group_user_delete`;
CREATE TABLE `t_im_group_user_delete` (
  `id` varchar(32) NOT NULL,
  `group_id` varchar(32) NOT NULL COMMENT '群聊id',
  `user_nick_name` varchar(50) DEFAULT NULL COMMENT '昵称',
  `user_empid` varchar(50) DEFAULT NULL COMMENT '患者主索引号',
  `user_hug_id` varchar(50) DEFAULT NULL COMMENT '蓝牛号',
  `user_role` int(1) DEFAULT NULL COMMENT '用户角色',
  `phone` varchar(18) DEFAULT NULL COMMENT '手机号',
  `idcard` varchar(18) DEFAULT NULL COMMENT '身份证',
  `voip_amount` varchar(50) DEFAULT NULL COMMENT '云通讯账号',
  `sex` int(1) DEFAULT NULL COMMENT '性别',
  `user_type` int(1) NOT NULL COMMENT '患者医生标志, 0 患者 3 医生',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `back_time` timestamp NULL DEFAULT NULL COMMENT '退群时间',
  `machine_code` varchar(50) DEFAULT NULL COMMENT '机器码',
  `im_push_flag` int(1) DEFAULT '1' COMMENT '是否推送消息 1是 2否',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='被删除群聊用户表';

-- ----------------------------
-- Table structure for t_im_group_user_move
-- ----------------------------
DROP TABLE IF EXISTS `t_im_group_user_move`;
CREATE TABLE `t_im_group_user_move` (
  `move_id` varchar(32) NOT NULL,
  `im_group_user_id` varchar(32) NOT NULL COMMENT '群聊用户主键',
  `user_hug_id` varchar(50) DEFAULT NULL COMMENT '蓝牛号',
  `enter_time` datetime DEFAULT NULL COMMENT '进群时间',
  `out_time` datetime DEFAULT NULL COMMENT '出群时间',
  `out_type` int(1) DEFAULT '1' COMMENT '出群类型 1在群 2被踢 3主动退群',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`move_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='群聊用户进出群记录表';

-- ----------------------------
-- Table structure for t_im_h5_record
-- ----------------------------
DROP TABLE IF EXISTS `t_im_h5_record`;
CREATE TABLE `t_im_h5_record` (
  `id` varchar(32) NOT NULL,
  `receive_hug` varchar(32) DEFAULT NULL COMMENT '患者蓝牛号',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '患者姓名',
  `pat_idcard` varchar(20) DEFAULT NULL COMMENT '患者身份证',
  `send_name` varchar(32) DEFAULT NULL COMMENT '发送者姓名',
  `send_hug` varchar(32) DEFAULT NULL COMMENT '医生蓝牛号',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '发送者随访id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `valid_days` int(10) DEFAULT NULL COMMENT '有效天数',
  `valid_time` datetime DEFAULT NULL COMMENT '有效截至时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='h5聊天url记录表';

-- ----------------------------
-- Table structure for t_im_list
-- ----------------------------
DROP TABLE IF EXISTS `t_im_list`;
CREATE TABLE `t_im_list` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `target_hug_id` varchar(32) DEFAULT NULL COMMENT '目标蓝牛号',
  `recent_im_id` varchar(32) DEFAULT NULL COMMENT '最近一条消息id',
  `unread_messages` int(11) DEFAULT '1' COMMENT '未读消息数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='im列表';

-- ----------------------------
-- Table structure for t_im_record
-- ----------------------------
DROP TABLE IF EXISTS `t_im_record`;
CREATE TABLE `t_im_record` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `target_hug_id` varchar(32) DEFAULT NULL COMMENT '目标蓝牛号',
  `protocol` varchar(32) DEFAULT NULL COMMENT '协议号',
  `msg_content` varchar(1024) DEFAULT NULL COMMENT '文本内容',
  `msg_domain` varchar(2048) DEFAULT NULL COMMENT '扩展字段',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `duration` int(11) DEFAULT '0' COMMENT '时长(单位：秒)',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `type` int(4) DEFAULT NULL COMMENT '类型 1.医患 2.患医 3.医医 4.系统消息',
  `dept_code` varchar(50) DEFAULT NULL COMMENT '科室编码',
  `third_id` varchar(64) DEFAULT NULL COMMENT '第三方主键',
  `reply_flag` varchar(32) DEFAULT '0' COMMENT '回复标志位 0未回复 1已回复',
  `reply_hug_id` varchar(32) DEFAULT NULL COMMENT '回复的蓝牛号',
  PRIMARY KEY (`id`),
  KEY `i_hug_id` (`hug_id`,`target_hug_id`,`is_delete`) USING BTREE,
  KEY `i2` (`hug_id`),
  KEY `i3` (`target_hug_id`),
  KEY `i4` (`is_delete`),
  KEY `i5` (`third_id`) USING BTREE,
  KEY `idx_isdelete_createtime_targethugid_hugid` (`is_delete`,`create_time`,`target_hug_id`,`hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='im历史记录';

-- ----------------------------
-- Table structure for t_im_record_old
-- ----------------------------
DROP TABLE IF EXISTS `t_im_record_old`;
CREATE TABLE `t_im_record_old` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `target_hug_id` varchar(32) DEFAULT NULL COMMENT '目标蓝牛号',
  `protocol` varchar(32) DEFAULT NULL COMMENT '协议号',
  `msg_content` varchar(1024) DEFAULT NULL COMMENT '文本内容',
  `msg_domain` varchar(2048) DEFAULT NULL COMMENT '扩展字段',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `duration` int(11) DEFAULT '0' COMMENT '时长(单位：秒)',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `type` int(4) DEFAULT NULL COMMENT '类型 1.医患 2.患医 3.医医 4.系统消息',
  `dept_code` varchar(50) DEFAULT NULL COMMENT '科室编码',
  `third_id` varchar(64) DEFAULT NULL COMMENT '第三方主键',
  `reply_flag` varchar(32) DEFAULT '0' COMMENT '回复标志位 0未回复 1已回复',
  `reply_hug_id` varchar(32) DEFAULT NULL COMMENT '回复的蓝牛号',
  PRIMARY KEY (`id`),
  KEY `i_hug_id` (`hug_id`,`target_hug_id`,`is_delete`) USING BTREE,
  KEY `i2` (`hug_id`),
  KEY `i3` (`target_hug_id`),
  KEY `i4` (`is_delete`),
  KEY `i5` (`third_id`) USING BTREE,
  KEY `idx_isdelete_createtime_targethugid_hugid` (`is_delete`,`create_time`,`target_hug_id`,`hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='im历史记录';

-- ----------------------------
-- Table structure for t_in_hospital_form
-- ----------------------------
DROP TABLE IF EXISTS `t_in_hospital_form`;
CREATE TABLE `t_in_hospital_form` (
  `id` varchar(32) NOT NULL,
  `form_url_id` varchar(32) DEFAULT NULL COMMENT '表单id',
  `form_url` varchar(32) DEFAULT NULL COMMENT '表单url',
  `send_time` varchar(50) DEFAULT NULL COMMENT '发送时间',
  `is_back` int(11) DEFAULT '0' COMMENT '是否已答',
  `is_send` int(11) DEFAULT '0' COMMENT '是否提交答案',
  `title` varchar(1024) DEFAULT NULL COMMENT '标题',
  `doctor_hgId` varchar(32) DEFAULT NULL COMMENT '医生hugId',
  `pat_phone` varchar(32) DEFAULT NULL COMMENT '患者手机号',
  `id_card` varchar(32) DEFAULT NULL COMMENT '患者身份证',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='在院随访可以直接填写表单记录';

-- ----------------------------
-- Table structure for t_informed_consent_record
-- ----------------------------
DROP TABLE IF EXISTS `t_informed_consent_record`;
CREATE TABLE `t_informed_consent_record` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(64) NOT NULL COMMENT '医院编码',
  `pat_name` varchar(32) NOT NULL COMMENT '患者姓名',
  `id_card` varchar(32) DEFAULT NULL COMMENT '患者身份证号码',
  `mobile_no` varchar(32) NOT NULL COMMENT '患者手机号',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '患者索引',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联记录ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_relation_id` (`relation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康监测提醒记录';

-- ----------------------------
-- Table structure for t_inquiry_hurry_record
-- ----------------------------
DROP TABLE IF EXISTS `t_inquiry_hurry_record`;
CREATE TABLE `t_inquiry_hurry_record` (
  `id` varchar(32) NOT NULL,
  `time` timestamp NULL DEFAULT NULL COMMENT '催一下时间',
  `phone` varchar(20) DEFAULT NULL COMMENT '医生手机号',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '医生蓝牛号',
  `name` varchar(50) DEFAULT NULL COMMENT '医生姓名',
  `manage_user_id` varchar(32) DEFAULT NULL COMMENT '管理员id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='在线问诊催一下记录表';

-- ----------------------------
-- Table structure for t_interface_add_friend
-- ----------------------------
DROP TABLE IF EXISTS `t_interface_add_friend`;
CREATE TABLE `t_interface_add_friend` (
  `id` varchar(32) NOT NULL,
  `pat_name` varchar(32) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `id_card` varchar(18) DEFAULT NULL,
  `send_time` bigint(20) NOT NULL,
  `info` varchar(1000) DEFAULT NULL,
  `hg_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_interface_message
-- ----------------------------
DROP TABLE IF EXISTS `t_interface_message`;
CREATE TABLE `t_interface_message` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `phone` varchar(30) DEFAULT NULL COMMENT '手机号码',
  `questionnaire_id` varchar(32) DEFAULT NULL COMMENT '关联问卷表的id',
  `relation_type` int(2) DEFAULT NULL COMMENT '相关类别',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '相关id',
  `is_send` int(1) DEFAULT NULL COMMENT '是否发送',
  `send_time` bigint(19) DEFAULT NULL,
  `send_hug` varchar(32) DEFAULT NULL COMMENT '发送者账号',
  `call_back_time` bigint(19) DEFAULT NULL,
  `interview_id` varchar(32) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `is_back` int(1) DEFAULT NULL,
  `back_msg` mediumtext,
  `title` varchar(100) DEFAULT NULL,
  `send_time_str` varchar(20) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `categ_type` varchar(4) DEFAULT NULL,
  `sourse_id` varchar(50) DEFAULT NULL,
  `receive_hug` varchar(50) DEFAULT NULL,
  `dept_code` varchar(50) DEFAULT NULL,
  `dept_name` varchar(50) DEFAULT NULL,
  `id_card` varchar(50) DEFAULT NULL,
  `pat_name` varchar(50) DEFAULT NULL,
  `send_name` varchar(50) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  `surl` varchar(200) DEFAULT NULL,
  `durl` varchar(200) DEFAULT NULL,
  `yurl` varchar(200) DEFAULT NULL,
  `appflag` int(2) DEFAULT NULL COMMENT '值为1代表是app发送，  为空是随访发送的。',
  `valid_days` int(1) DEFAULT NULL COMMENT '表单链接有效天数',
  `no_juge` int(1) DEFAULT NULL COMMENT '是否直接查看答案',
  `record_id` varchar(40) DEFAULT NULL COMMENT '消息记录表主键',
  `urlFlag` varchar(2) DEFAULT NULL COMMENT '内容是url标识 1是 其他不是',
  PRIMARY KEY (`id`),
  KEY `index_phone` (`phone`),
  KEY `index_categ_type` (`categ_type`),
  KEY `index_receive_hug` (`receive_hug`),
  KEY `index_interview_id` (`interview_id`),
  KEY `index_relation_id` (`relation_id`),
  KEY `index_questionnaire_id` (`questionnaire_id`),
  KEY `index_inter_hosp_code` (`hosp_code`),
  KEY `index_inter_dept_code` (`dept_code`),
  KEY `index_inter_pat_name` (`pat_name`),
  KEY `index_inter_inhosp_no` (`inhosp_no`),
  KEY `index_inter_id_card` (`id_card`),
  KEY `index_record_id` (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_interface_message1
-- ----------------------------
DROP TABLE IF EXISTS `t_interface_message1`;
CREATE TABLE `t_interface_message1` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `phone` varchar(30) DEFAULT NULL COMMENT '手机号码',
  `questionnaire_id` varchar(32) DEFAULT NULL COMMENT '关联问卷表的id',
  `relation_type` int(2) DEFAULT NULL COMMENT '相关类别',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '相关id',
  `is_send` int(1) DEFAULT NULL COMMENT '是否发送',
  `send_time` bigint(19) DEFAULT NULL,
  `send_hug` varchar(32) DEFAULT NULL COMMENT '发送者账号',
  `call_back_time` bigint(19) DEFAULT NULL,
  `interview_id` varchar(32) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `is_back` int(1) DEFAULT NULL,
  `back_msg` mediumtext,
  `title` varchar(100) DEFAULT NULL,
  `send_time_str` varchar(20) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `categ_type` varchar(4) DEFAULT NULL,
  `sourse_id` varchar(50) DEFAULT NULL,
  `receive_hug` varchar(50) DEFAULT NULL,
  `dept_code` varchar(50) DEFAULT NULL,
  `dept_name` varchar(50) DEFAULT NULL,
  `id_card` varchar(50) DEFAULT NULL,
  `pat_name` varchar(50) DEFAULT NULL,
  `send_name` varchar(50) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  `surl` varchar(200) DEFAULT NULL,
  `durl` varchar(200) DEFAULT NULL,
  `yurl` varchar(200) DEFAULT NULL,
  `appflag` int(2) DEFAULT NULL COMMENT '值为1代表是app发送，  为空是随访发送的。',
  `valid_days` int(1) DEFAULT NULL COMMENT '表单链接有效天数',
  `no_juge` int(1) DEFAULT NULL COMMENT '是否直接查看答案',
  `record_id` varchar(40) DEFAULT NULL COMMENT '消息记录表主键',
  PRIMARY KEY (`id`),
  KEY `index_phone` (`phone`),
  KEY `index_categ_type` (`categ_type`),
  KEY `index_receive_hug` (`receive_hug`),
  KEY `index_interview_id` (`interview_id`),
  KEY `index_relation_id` (`relation_id`),
  KEY `index_questionnaire_id` (`questionnaire_id`),
  KEY `index_inter_hosp_code` (`hosp_code`),
  KEY `index_inter_dept_code` (`dept_code`),
  KEY `index_inter_pat_name` (`pat_name`),
  KEY `index_inter_inhosp_no` (`inhosp_no`),
  KEY `index_inter_id_card` (`id_card`),
  KEY `index_record_id` (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_interface_questionnaire
-- ----------------------------
DROP TABLE IF EXISTS `t_interface_questionnaire`;
CREATE TABLE `t_interface_questionnaire` (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `questionnaire` mediumtext,
  `hosp_code` varchar(50) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `send_time` bigint(19) DEFAULT NULL,
  `questionnaire_id` varchar(32) DEFAULT NULL,
  `begincontent` mediumtext COMMENT '内容头文字',
  `url_flag` varchar(2) DEFAULT NULL COMMENT '内容是url标识 1是 其他不是',
  PRIMARY KEY (`id`),
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_interface_referral_reminder
-- ----------------------------
DROP TABLE IF EXISTS `t_interface_referral_reminder`;
CREATE TABLE `t_interface_referral_reminder` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `sourse_id` varchar(32) DEFAULT NULL,
  `hosp_code` varchar(20) DEFAULT NULL,
  `hosp_name` varchar(40) DEFAULT NULL,
  `dept_name` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `id_card` varchar(20) DEFAULT NULL,
  `reminder_date` varchar(30) DEFAULT NULL,
  `referral_date` varchar(50) DEFAULT NULL,
  `referral_time` varchar(20) DEFAULT NULL,
  `referral_type` varchar(1) DEFAULT NULL,
  `referral_explanation` text,
  `type` varchar(4) DEFAULT NULL,
  `week` varchar(4) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_job
-- ----------------------------
DROP TABLE IF EXISTS `t_job`;
CREATE TABLE `t_job` (
  `id` varchar(32) NOT NULL,
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `content` varchar(4000) DEFAULT NULL COMMENT '内容',
  `location` varchar(10) DEFAULT NULL COMMENT '位置',
  `email` varchar(30) DEFAULT NULL COMMENT '邮箱',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ号码',
  `creator` varchar(50) DEFAULT NULL COMMENT '创建人',
  `operator` varchar(50) DEFAULT NULL COMMENT '修改人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_manage_maintenance
-- ----------------------------
DROP TABLE IF EXISTS `t_manage_maintenance`;
CREATE TABLE `t_manage_maintenance` (
  `id` char(32) NOT NULL,
  `hosp_code` varchar(20) NOT NULL COMMENT '机构代码',
  `status_code` tinyint(4) NOT NULL DEFAULT '0' COMMENT '维保状态代码',
  `start_date` date NOT NULL COMMENT '维保开始日期',
  `end_date` date NOT NULL COMMENT '维保结束日期',
  `valid_year` int(11) DEFAULT NULL COMMENT '维保有效年份',
  `overdue_processing_code` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逾期处理代码',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `latest_end_date` date DEFAULT NULL COMMENT '维保结束日期',
  PRIMARY KEY (`id`),
  KEY `idx_hosp_code` (`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='维保管理表';

-- ----------------------------
-- Table structure for t_manage_maintenance_record
-- ----------------------------
DROP TABLE IF EXISTS `t_manage_maintenance_record`;
CREATE TABLE `t_manage_maintenance_record` (
  `id` char(32) NOT NULL,
  `relation_id` char(32) NOT NULL COMMENT 't_manage_maintenance.id',
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '机构代码',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `start_date` date NOT NULL COMMENT '维保开始日期',
  `end_date` date NOT NULL COMMENT '维保结束日期',
  `valid_year` int(11) DEFAULT NULL COMMENT '维保有效年份',
  `overdue_processing_code` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逾期处理 默认建设中 MaintenanceConstants.OverdueProcessing',
  `overdue_processing_name` varchar(20) DEFAULT NULL COMMENT '逾期处理名称',
  `operator_id` char(32) NOT NULL COMMENT '操作人',
  `operator_name` varchar(20) NOT NULL COMMENT '操作人姓名',
  `operation_datetime` datetime NOT NULL COMMENT '操作人时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_relation_id` (`relation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='维保管理记录表';

-- ----------------------------
-- Table structure for t_material_info
-- ----------------------------
DROP TABLE IF EXISTS `t_material_info`;
CREATE TABLE `t_material_info` (
  `material_type` int(11) NOT NULL COMMENT '物料类型',
  `material_name` varchar(32) NOT NULL COMMENT '物料名称',
  PRIMARY KEY (`material_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='物料表';

-- ----------------------------
-- Table structure for t_maternalchild_health_book
-- ----------------------------
DROP TABLE IF EXISTS `t_maternalchild_health_book`;
CREATE TABLE `t_maternalchild_health_book` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `create_book_time` varchar(20) NOT NULL COMMENT '建册时间',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `name` varchar(20) DEFAULT NULL COMMENT '用户名字',
  `id_card` varchar(20) DEFAULT NULL COMMENT '身份证',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话号码',
  `source` int(11) NOT NULL COMMENT '请求来源',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_maternalchild_health_book_institution_dic
-- ----------------------------
DROP TABLE IF EXISTS `t_maternalchild_health_book_institution_dic`;
CREATE TABLE `t_maternalchild_health_book_institution_dic` (
  `id` varchar(32) NOT NULL COMMENT '主键id',
  `issuing_institution_code` varchar(255) DEFAULT NULL COMMENT '组织结构编码',
  `issuing_institution_name` varchar(255) DEFAULT NULL COMMENT '组织结构名称',
  `issuing_institution_desc` varchar(1000) DEFAULT NULL COMMENT '组织机构描述',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '父节点id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_maternalchild_health_book_statistics
-- ----------------------------
DROP TABLE IF EXISTS `t_maternalchild_health_book_statistics`;
CREATE TABLE `t_maternalchild_health_book_statistics` (
  `id` varchar(32) NOT NULL COMMENT '主键id',
  `times` int(11) DEFAULT '0' COMMENT '阅读量所对应的次数',
  `issuing_institution_code` varchar(255) DEFAULT NULL COMMENT '组织结构编码',
  `issuing_institution_name` varchar(255) DEFAULT NULL COMMENT '组织结构名称',
  `user_status_code` varchar(255) DEFAULT NULL COMMENT '用户身份，1:待孕妇女 2:孕妇 3:儿童   ',
  `reading_time` varchar(255) DEFAULT NULL COMMENT '阅读时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_mattress_sleep_time
-- ----------------------------
DROP TABLE IF EXISTS `t_mattress_sleep_time`;
CREATE TABLE `t_mattress_sleep_time` (
  `id` varchar(50) NOT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  `bracelet_code` varchar(50) DEFAULT NULL,
  `create_time` varchar(50) DEFAULT NULL COMMENT '创建日期',
  `update_time` varchar(50) DEFAULT NULL COMMENT '修改日期',
  `to_sleep_time` varchar(50) DEFAULT NULL COMMENT '入睡日期',
  `out_sleep_time` varchar(50) DEFAULT NULL COMMENT '起床日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能床垫睡眠时间';

-- ----------------------------
-- Table structure for t_medical_card
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_card`;
CREATE TABLE `t_medical_card` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编号',
  `hosp_card` varchar(64) DEFAULT NULL,
  `card_type` char(1) DEFAULT NULL COMMENT '卡号类别 1 就诊卡号 2 医保卡号',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '用户id',
  `card_time` bigint(19) DEFAULT NULL COMMENT '办卡时间',
  `is_family` int(1) DEFAULT NULL COMMENT '是否成员的卡',
  `family_user_id` varchar(32) DEFAULT NULL COMMENT '关联家庭成员id',
  `last_syn_time` bigint(19) DEFAULT NULL COMMENT '最后同步时间',
  `hosp_name` varchar(50) DEFAULT NULL,
  `image` varchar(32) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  `is_online` int(1) DEFAULT NULL COMMENT '是否在线建档',
  `last_bind_time` timestamp NULL DEFAULT NULL COMMENT '最近一次绑定时间',
  `phone` varchar(11) DEFAULT NULL COMMENT '电话号码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_card3
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_card3`;
CREATE TABLE `t_medical_card3` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编号',
  `hosp_card` varchar(50) DEFAULT NULL COMMENT '就诊卡号',
  `card_type` char(1) DEFAULT NULL COMMENT '卡号类别 1 就诊卡号 2 医保卡号',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '用户id',
  `card_time` bigint(19) DEFAULT NULL COMMENT '办卡时间',
  `is_family` int(1) DEFAULT NULL COMMENT '是否成员的卡',
  `family_user_id` varchar(32) DEFAULT NULL COMMENT '关联家庭成员id',
  `last_syn_time` bigint(19) DEFAULT NULL COMMENT '最后同步时间',
  `hosp_name` varchar(50) DEFAULT NULL,
  `image` varchar(32) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  `is_online` int(1) DEFAULT NULL COMMENT '是否在线建档',
  `last_bind_time` timestamp NULL DEFAULT NULL COMMENT '最近一次绑定时间',
  `phone` varchar(11) DEFAULT NULL COMMENT '就诊卡绑定的电话号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_day_surgery_out_upload
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_day_surgery_out_upload`;
CREATE TABLE `t_medical_day_surgery_out_upload` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '组织机构代码',
  `patient_id` char(32) NOT NULL COMMENT '关联院内t_day_surgery_patient表主键ID',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '患者姓名',
  `serial_no` varchar(50) DEFAULT NULL COMMENT '业务流水号',
  `phone` varchar(50) DEFAULT NULL COMMENT '患者手机号',
  `item_name` varchar(200) DEFAULT NULL COMMENT '项目名称中文顿号分隔串',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `submit_url` varchar(500) NOT NULL COMMENT '提交url链接',
  `is_submit` tinyint(1) DEFAULT '0' COMMENT '是否提交（1，是  0，否）',
  `submit_time` datetime DEFAULT NULL COMMENT '提交时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `type` tinyint(4) DEFAULT NULL COMMENT '类型 1:院外检查检验 2:会诊病历',
  PRIMARY KEY (`id`),
  KEY `idx_patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日间手术上传院外报告图片记录';

-- ----------------------------
-- Table structure for t_medical_dr
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_dr`;
CREATE TABLE `t_medical_dr` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `name` varchar(50) DEFAULT NULL,
  `dept_code` varchar(50) DEFAULT NULL,
  `dept_name` varchar(100) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `staff_code` varchar(50) DEFAULT NULL,
  `sex` int(1) DEFAULT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_examreport
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_examreport`;
CREATE TABLE `t_medical_examreport` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `index_no_id` varchar(200) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `outhosp_no` varchar(50) DEFAULT NULL,
  `outhosp_serial_no` varchar(50) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `inhosp_num` varchar(20) DEFAULT NULL,
  `inhosp_serial_no` varchar(50) DEFAULT NULL,
  `requisition_no` varchar(50) DEFAULT NULL,
  `report_no` varchar(50) DEFAULT NULL,
  `requipment_name` varchar(50) DEFAULT NULL,
  `requipment_code` varchar(50) DEFAULT NULL,
  `report_name` varchar(500) DEFAULT NULL,
  `req_id` varchar(100) DEFAULT NULL,
  `oper_part_code` varchar(250) DEFAULT NULL,
  `oper_part_name` varchar(250) DEFAULT NULL,
  `exam_categ_name` varchar(250) DEFAULT NULL,
  `exam_item_code` varchar(250) DEFAULT NULL,
  `exam_item_name` varchar(250) DEFAULT NULL,
  `apply_date` varchar(50) DEFAULT NULL,
  `apply_dept_code` varchar(250) DEFAULT NULL,
  `apply_dept_name` varchar(250) DEFAULT NULL,
  `apply_dr_code` varchar(250) DEFAULT NULL,
  `apply_dr_name` varchar(250) DEFAULT NULL,
  `execute_date` varchar(50) DEFAULT NULL,
  `picture` text,
  `picture_web` text,
  `exam_result` text,
  `exam_desc` text,
  `report_date` varchar(1000) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `only_index` varchar(200) DEFAULT NULL,
  `exam_categ_code` varchar(250) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_examreq
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_examreq`;
CREATE TABLE `t_medical_examreq` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `index_no_id` varchar(200) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `outhosp_no` varchar(50) DEFAULT NULL,
  `outhosp_serial_no` varchar(50) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `inhosp_num` varchar(20) DEFAULT NULL,
  `inhosp_serial_no` varchar(50) DEFAULT NULL,
  `requisition_no` varchar(50) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `only_index` varchar(200) DEFAULT NULL,
  `apply_date` varchar(1000) DEFAULT NULL,
  `exam_apply_item_code` varchar(50) DEFAULT NULL,
  `exam_apply_item_name` varchar(1000) DEFAULT NULL,
  `finish_date` varchar(30) DEFAULT NULL,
  `oper_part_code` varchar(50) DEFAULT NULL,
  `oper_part_name` varchar(50) DEFAULT NULL,
  `requisition_status` varchar(2) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `local_finish` int(1) DEFAULT NULL,
  `requisition_no_item` varchar(50) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `EXAM_REQ_INDEX` (`only_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_history
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_history`;
CREATE TABLE `t_medical_history` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hug_id` varchar(16) DEFAULT NULL COMMENT '蓝牛号',
  `member_id` varchar(32) DEFAULT NULL COMMENT '成员号',
  `medical_history_type` int(1) DEFAULT NULL COMMENT '病史类型 0婚育史1既往史 2手术史 3家族史 4过敏史',
  `value` varchar(2048) DEFAULT NULL COMMENT '病史内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效 1有效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='病史（云端）';

-- ----------------------------
-- Table structure for t_medical_history_self_build
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_history_self_build`;
CREATE TABLE `t_medical_history_self_build` (
  `medical_history_id` varchar(32) NOT NULL,
  `hg_id` varchar(32) NOT NULL COMMENT '患者hgId',
  `doc_hg_id` varchar(32) DEFAULT NULL COMMENT '医生hgId',
  `disease_desc` varchar(1000) DEFAULT NULL COMMENT '病情描述',
  `img_ids` varchar(1000) DEFAULT NULL COMMENT '图片id，多张图逗号分隔',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`medical_history_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自建病历表';

-- ----------------------------
-- Table structure for t_medical_hosp
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_hosp`;
CREATE TABLE `t_medical_hosp` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `last_syn_time` bigint(19) DEFAULT NULL COMMENT '最近一次访问时间',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '用户id',
  `hosp_name` varchar(50) DEFAULT NULL,
  `health_syn_time` bigint(19) DEFAULT '0',
  `physical_syn_time` bigint(19) DEFAULT '0',
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `hug_hosptial_index` (`hosp_code`,`hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_index_no
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_index_no`;
CREATE TABLE `t_medical_index_no` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `hosp_short_name` varchar(50) DEFAULT NULL COMMENT '医院简称',
  `medical_no` varchar(50) DEFAULT NULL COMMENT '流水号',
  `medical_type` char(1) DEFAULT NULL COMMENT '流水号类型 1 门诊 2 住院',
  `hug_id` varchar(32) DEFAULT NULL COMMENT 'hugId',
  `dr_code` varchar(50) DEFAULT NULL COMMENT '医生工号',
  `dr_name` varchar(30) DEFAULT NULL COMMENT '医生名称',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室工号',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `begin_time` varchar(30) DEFAULT NULL,
  `end_time` varchar(30) DEFAULT NULL,
  `last_syn_time` bigint(19) DEFAULT NULL,
  `local_finish` int(1) DEFAULT NULL COMMENT '是否数据库完全同步到本地',
  `only_index` varchar(200) DEFAULT NULL,
  `detail_time` bigint(19) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `diag_name` varchar(100) DEFAULT NULL,
  `image` varchar(32) DEFAULT NULL,
  `card_no` varchar(50) DEFAULT NULL,
  `card_type` varchar(10) DEFAULT NULL,
  `self_type` int(2) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_no_index` (`only_index`),
  KEY `index_hug_id` (`hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='头数据';

-- ----------------------------
-- Table structure for t_medical_inhosp_balance
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_inhosp_balance`;
CREATE TABLE `t_medical_inhosp_balance` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `deal_no` varchar(50) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `balance_no` varchar(50) DEFAULT NULL,
  `fee_categ_code` varchar(50) DEFAULT NULL,
  `fee_categ_name` varchar(50) DEFAULT NULL,
  `total_money` varchar(20) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `index_no_id` varchar(200) DEFAULT NULL COMMENT '头数据主键',
  `fee_id` varchar(200) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  `local_finish` int(1) DEFAULT '0' COMMENT '是否本地化了',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_inhospfee
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_inhospfee`;
CREATE TABLE `t_medical_inhospfee` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `is_family` varchar(50) DEFAULT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  `index_no_id` varchar(200) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `inhosp_num` varchar(50) DEFAULT NULL,
  `inhosp_serial_no` varchar(50) DEFAULT NULL,
  `order_no` varchar(50) DEFAULT NULL,
  `deal_no` varchar(50) DEFAULT NULL,
  `mfs_method_code` varchar(50) DEFAULT NULL,
  `mfs_method_name` varchar(50) DEFAULT NULL,
  `medical_total_fee` varchar(50) DEFAULT NULL,
  `self_expence_fee` varchar(50) DEFAULT NULL,
  `self_payment_fee` varchar(50) DEFAULT NULL,
  `settlement_date` varchar(50) DEFAULT NULL,
  `charge_date` varchar(50) DEFAULT NULL,
  `update_time` varchar(50) DEFAULT NULL,
  `local_finish` varchar(50) DEFAULT NULL,
  `self_negative_fee` varchar(50) DEFAULT NULL,
  `medical_category` varchar(50) DEFAULT NULL,
  `reduce_fee` varchar(50) DEFAULT NULL,
  `medical_fee` varchar(50) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_inhospfeedetail
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_inhospfeedetail`;
CREATE TABLE `t_medical_inhospfeedetail` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hug_id` varchar(50) DEFAULT NULL,
  `fee_id` varchar(200) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `order_no` varchar(50) DEFAULT NULL,
  `deal_no` varchar(50) DEFAULT NULL,
  `deal_sub_no` varchar(50) DEFAULT NULL,
  `charge_item_code` varchar(250) DEFAULT NULL,
  `charge_item_name` varchar(250) DEFAULT NULL,
  `fee_charge_code` varchar(50) DEFAULT NULL,
  `fee_charge_name` varchar(50) DEFAULT NULL,
  `drug_amount` varchar(50) DEFAULT NULL,
  `drug_unit` varchar(50) DEFAULT NULL,
  `drug_unit_price` varchar(50) DEFAULT NULL,
  `total_price` varchar(50) DEFAULT NULL,
  `drug_catalog_type` varchar(50) DEFAULT NULL,
  `self_percent` varchar(50) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_inhosporder
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_inhosporder`;
CREATE TABLE `t_medical_inhosporder` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `index_no_id` varchar(200) DEFAULT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `inhosp_num` varchar(50) DEFAULT NULL,
  `inhosp_serial_no` varchar(50) DEFAULT NULL,
  `order_no` varchar(50) DEFAULT NULL,
  `order_group_no` varchar(50) DEFAULT NULL,
  `order_plan_begin_date` varchar(50) DEFAULT NULL,
  `order_plan_end_date` varchar(50) DEFAULT NULL,
  `order_begin_date` varchar(50) DEFAULT NULL,
  `order_end_date` varchar(50) DEFAULT NULL,
  `order_date` varchar(20) DEFAULT NULL,
  `open_dept_code` varchar(50) DEFAULT NULL,
  `open_dept_name` varchar(50) DEFAULT NULL,
  `open_dr_code` varchar(250) DEFAULT NULL,
  `open_dr_name` varchar(250) DEFAULT NULL,
  `execute_date` varchar(20) DEFAULT NULL,
  `categ_code` varchar(50) DEFAULT NULL,
  `categ_name` varchar(100) DEFAULT NULL,
  `item_code` varchar(250) DEFAULT NULL,
  `item_name` varchar(500) DEFAULT NULL,
  `drug_code` varchar(250) DEFAULT NULL,
  `drug_name` varchar(500) DEFAULT NULL,
  `drug_spe` varchar(250) DEFAULT NULL,
  `dose_way_code` varchar(250) DEFAULT NULL,
  `dose_way_name` varchar(250) DEFAULT NULL,
  `one_dosage` varchar(50) DEFAULT NULL,
  `one_dosage_unit` varchar(50) DEFAULT NULL,
  `frequency_code` varchar(50) DEFAULT NULL,
  `frequency_name` varchar(50) DEFAULT NULL,
  `drug_form_code` varchar(50) DEFAULT NULL,
  `drug_form_name` varchar(50) DEFAULT NULL,
  `drug_unit` varchar(50) DEFAULT NULL,
  `drug_unit_price` varchar(50) DEFAULT NULL,
  `drug_abbrev` varchar(500) DEFAULT NULL,
  `drug_desc` varchar(250) DEFAULT NULL,
  `drug_amount` varchar(20) DEFAULT NULL,
  `order_duration` varchar(100) DEFAULT NULL,
  `order_duration_unit` varchar(20) DEFAULT NULL,
  `base_aux_flag` varchar(20) DEFAULT NULL,
  `dr_entrust` varchar(500) DEFAULT NULL,
  `note` text,
  `item_type_code` varchar(250) DEFAULT NULL,
  `item_type_name` varchar(250) DEFAULT NULL,
  `dis_charge_order_flag` varchar(50) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_inhosprecord
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_inhosprecord`;
CREATE TABLE `t_medical_inhosprecord` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `visit_card_no` varchar(50) DEFAULT NULL,
  `pat_name` varchar(250) DEFAULT NULL,
  `sex_code` varchar(50) DEFAULT NULL,
  `sex_name` varchar(50) DEFAULT NULL,
  `birth_date` varchar(50) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `inhosp_num` varchar(20) DEFAULT NULL,
  `inhosp_serial_no` varchar(50) DEFAULT NULL,
  `dept_code` varchar(250) DEFAULT NULL,
  `dept_name` varchar(250) DEFAULT NULL,
  `ward_name` varchar(250) DEFAULT NULL,
  `sick_room_no` varchar(250) DEFAULT NULL,
  `bed_no` varchar(250) DEFAULT NULL,
  `admit_date` varchar(50) DEFAULT NULL,
  `admit_situation` text,
  `admit_way_code` varchar(250) DEFAULT NULL,
  `admit_way_name` varchar(250) DEFAULT NULL,
  `pat_chief_desc` text,
  `brief_dis_sit` varchar(1000) DEFAULT NULL,
  `brief_dis_situation` text,
  `treat_plan` varchar(1000) DEFAULT NULL,
  `disease_his` text,
  `surgery_his` text,
  `curr_disease_his` text,
  `metachysis_his` text,
  `infect_dis_his` text,
  `admit_diag_code` varchar(250) DEFAULT NULL,
  `admit_diag_name` varchar(250) DEFAULT NULL,
  `recept_treat_dr_code` varchar(250) DEFAULT NULL,
  `recept_treat_dr_name` varchar(250) DEFAULT NULL,
  `inhosp_dr_code` varchar(250) DEFAULT NULL,
  `inhosp_dr_name` varchar(250) DEFAULT NULL,
  `attend_dr_code` varchar(250) DEFAULT NULL,
  `attend_dr_name` varchar(250) DEFAULT NULL,
  `chief_dr_code` varchar(250) DEFAULT NULL,
  `chief_dr_name` varchar(250) DEFAULT NULL,
  `nursing_lv_code` varchar(50) DEFAULT NULL,
  `nursing_lv_name` varchar(50) DEFAULT NULL,
  `pri_nurse_name` varchar(50) DEFAULT NULL,
  `treat_pro_desc` text,
  `dis_charge_staus` varchar(1000) DEFAULT NULL,
  `dis_charge_date` varchar(30) DEFAULT NULL,
  `dis_charge_diag_code` varchar(250) DEFAULT NULL,
  `dis_charge_diag_name` varchar(250) DEFAULT NULL,
  `dis_charge_sym` varchar(500) DEFAULT NULL,
  `dis_charge_order` varchar(500) DEFAULT NULL,
  `out_come` varchar(500) DEFAULT NULL,
  `dis_charge_m_code` varchar(250) DEFAULT NULL,
  `dis_charge_m_name` varchar(250) DEFAULT NULL,
  `id_card` varchar(250) DEFAULT NULL,
  `mobile_no` varchar(250) DEFAULT NULL,
  `allergy_his` text,
  `update_time` bigint(19) DEFAULT NULL,
  `index_no_id` varchar(200) DEFAULT NULL,
  `physical_exam` text,
  `treatment_advice` text,
  `partner_type` int(2) DEFAULT '0',
  `discharge_summary` text COMMENT '出院小结汇总',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_microbetestresult
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_microbetestresult`;
CREATE TABLE `t_medical_microbetestresult` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hug_id` varchar(50) DEFAULT NULL,
  `is_family` int(2) DEFAULT NULL,
  `only_index` varchar(200) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `test_result_no` varchar(50) DEFAULT NULL,
  `report_id` varchar(200) DEFAULT NULL,
  `report_no` varchar(50) DEFAULT NULL,
  `microbe_name` varchar(500) DEFAULT NULL,
  `colony_count` varchar(250) DEFAULT NULL,
  `antibiotics` varchar(500) DEFAULT NULL,
  `test_result_value` varchar(250) DEFAULT NULL,
  `test_result_value_unit` varchar(500) DEFAULT NULL,
  `test_method` varchar(500) DEFAULT NULL,
  `refe_range` varchar(250) DEFAULT NULL,
  `refe_up_limit` varchar(250) DEFAULT NULL,
  `refe_low_limit` varchar(250) DEFAULT NULL,
  `note` text,
  `update_time` bigint(19) DEFAULT NULL,
  `partner_type` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_orderdetaiinfo
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_orderdetaiinfo`;
CREATE TABLE `t_medical_orderdetaiinfo` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `order_info_id` varchar(200) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `pres_no` varchar(50) DEFAULT NULL,
  `pres_sub_no` varchar(50) DEFAULT NULL,
  `pres_group_no` varchar(50) DEFAULT NULL,
  `drug_code` varchar(50) DEFAULT NULL,
  `drug_name` varchar(50) DEFAULT NULL,
  `drug_spe` varchar(50) DEFAULT NULL,
  `dose_way_code` varchar(50) DEFAULT NULL,
  `dose_way_name` varchar(50) DEFAULT NULL,
  `one_dosage` varchar(50) DEFAULT NULL,
  `one_dosage_unit` varchar(100) DEFAULT NULL,
  `frequency_code` varchar(50) DEFAULT NULL,
  `frequency_name` varchar(50) DEFAULT NULL,
  `form_code` varchar(50) DEFAULT NULL,
  `form_name` varchar(50) DEFAULT NULL,
  `drug_unit` varchar(50) DEFAULT NULL,
  `drug_unit_price` varchar(20) DEFAULT NULL,
  `drug_abbrev` varchar(1000) DEFAULT NULL,
  `drug_desc` varchar(1000) DEFAULT NULL,
  `pres_with_days` varchar(50) DEFAULT NULL,
  `drug_amount` varchar(50) DEFAULT NULL,
  `base_aux_flag` varchar(50) DEFAULT NULL,
  `self_flag` varchar(50) DEFAULT NULL,
  `group_flag` varchar(50) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_orderinfo
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_orderinfo`;
CREATE TABLE `t_medical_orderinfo` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `index_no_id` varchar(200) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `out_hosp_no` varchar(50) DEFAULT NULL,
  `out_hosp_serial_no` varchar(50) DEFAULT NULL,
  `pres_no` varchar(250) DEFAULT NULL,
  `pres_group_no` varchar(250) DEFAULT NULL,
  `pres_open_dept_code` varchar(250) DEFAULT NULL,
  `pres_open_dept_name` varchar(250) DEFAULT NULL,
  `pres_open_dr_code` varchar(250) DEFAULT NULL,
  `pres_open_dr_name` varchar(250) DEFAULT NULL,
  `pres_order_date` varchar(30) DEFAULT NULL,
  `pres_begin_date` varchar(30) DEFAULT NULL,
  `pres_end_date` varchar(30) DEFAULT NULL,
  `pres_valid_day` varchar(50) DEFAULT NULL,
  `pres_item_type_code` varchar(50) DEFAULT NULL,
  `pres_item_type_name` varchar(50) DEFAULT NULL,
  `pres_categ_code` varchar(250) DEFAULT NULL,
  `pres_categ_name` varchar(250) DEFAULT NULL,
  `pres_item_code` varchar(50) DEFAULT NULL,
  `pres_item_name` varchar(50) DEFAULT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `local_finish` int(1) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `only_index` varchar(100) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_only_index` (`only_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_outhosp_feedetail
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_outhosp_feedetail`;
CREATE TABLE `t_medical_outhosp_feedetail` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hug_id` varchar(32) DEFAULT NULL,
  `fee_id` varchar(200) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `deal_no` varchar(200) DEFAULT NULL,
  `deal_sub_no` varchar(50) DEFAULT NULL,
  `pres_no` varchar(50) DEFAULT NULL,
  `pres_sub_no` varchar(50) DEFAULT NULL,
  `charge_item_code` varchar(250) DEFAULT NULL,
  `charge_item_name` varchar(250) DEFAULT NULL,
  `drug_amount` varchar(50) DEFAULT NULL,
  `drug_unit` varchar(50) DEFAULT NULL,
  `drug_unit_price` varchar(30) DEFAULT NULL,
  `total_money` varchar(50) DEFAULT NULL,
  `valuation_flag` varchar(10) DEFAULT NULL,
  `fee_categ_code` varchar(30) DEFAULT NULL,
  `fee_categ_name` varchar(50) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `only_index` varchar(200) DEFAULT NULL,
  `drug_catalog_type` varchar(50) DEFAULT NULL,
  `self_percent` varchar(50) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fee_only_index` (`only_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_outhospfee
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_outhospfee`;
CREATE TABLE `t_medical_outhospfee` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hug_id` varchar(50) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `is_local_detail` int(1) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `out_hosp_no` varchar(50) DEFAULT NULL,
  `out_hosp_serial_no` varchar(50) DEFAULT NULL,
  `deal_no` varchar(200) DEFAULT NULL,
  `pres_no` varchar(50) DEFAULT NULL,
  `mfs_method_code` varchar(50) DEFAULT NULL,
  `mfs_method_name` varchar(50) DEFAULT NULL,
  `medical_total_fee` varchar(30) DEFAULT NULL,
  `medical_fee` varchar(30) DEFAULT NULL,
  `self_expense_fee` varchar(30) DEFAULT NULL,
  `self_payment_fee` varchar(30) DEFAULT NULL,
  `settlement_date` varchar(30) DEFAULT NULL,
  `charge_date` varchar(30) DEFAULT NULL,
  `refund_flag` varchar(5) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `index_no_id` varchar(200) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `only_index` varchar(200) DEFAULT NULL,
  `meidcal_category` varchar(30) DEFAULT NULL,
  `reduce_fee` varchar(50) DEFAULT NULL,
  `self_negative_fee` varchar(50) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `hosp_fee_only_index` (`only_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_physical_report
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_physical_report`;
CREATE TABLE `t_medical_physical_report` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `is_family` int(2) DEFAULT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `visit_card_no` varchar(50) DEFAULT NULL,
  `report_no` varchar(250) DEFAULT NULL,
  `pat_name` varchar(250) DEFAULT NULL,
  `id_number` varchar(250) DEFAULT NULL,
  `birth_date` varchar(50) DEFAULT NULL,
  `sex_code` varchar(20) DEFAULT NULL,
  `sex_name` varchar(20) DEFAULT NULL,
  `company` varchar(1000) DEFAULT NULL,
  `family_addr` text,
  `mobile_no` varchar(250) DEFAULT NULL,
  `exam_date` varchar(50) DEFAULT NULL,
  `exam_result` text,
  `exam_advice` text,
  `report_dr` varchar(100) DEFAULT NULL,
  `report_date` varchar(50) DEFAULT NULL,
  `check_dr` varchar(100) DEFAULT NULL,
  `check_date` varchar(50) DEFAULT NULL,
  `index_no_id` varchar(200) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_physical_result
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_physical_result`;
CREATE TABLE `t_medical_physical_result` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `is_family` int(1) DEFAULT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `report_no` varchar(50) DEFAULT NULL,
  `exam_date` varchar(50) DEFAULT NULL,
  `dept_code` varchar(50) DEFAULT NULL,
  `dept_name` varchar(50) DEFAULT NULL,
  `dr_code` varchar(250) DEFAULT NULL,
  `dr_name` varchar(250) DEFAULT NULL,
  `group_item_code` varchar(250) DEFAULT NULL,
  `group_item_name` varchar(250) DEFAULT NULL,
  `group_item_type_code` varchar(250) DEFAULT NULL,
  `group_item_type_name` varchar(250) DEFAULT NULL,
  `item_name` varchar(250) DEFAULT NULL,
  `item_result` varchar(250) DEFAULT NULL,
  `normal_flag` varchar(50) DEFAULT NULL,
  `unit` varchar(100) DEFAULT NULL,
  `reference_rages` varchar(250) DEFAULT NULL,
  `reference_updper_limit` varchar(250) DEFAULT NULL,
  `reference_lower_limit` varchar(250) DEFAULT NULL,
  `report_id` varchar(200) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_print_address
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_print_address`;
CREATE TABLE `t_medical_print_address` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `hug_id` varchar(32) NOT NULL COMMENT '患者id',
  `hug_name` varchar(20) NOT NULL COMMENT '患者姓名',
  `pat_user_name` varchar(20) NOT NULL COMMENT '取件人',
  `pat_phone` varchar(20) NOT NULL COMMENT '联系方式',
  `pat_region_code` varchar(20) DEFAULT NULL COMMENT '所在地区代码',
  `pat_region` varchar(50) DEFAULT NULL COMMENT '所在地区',
  `pat_address` varchar(100) DEFAULT NULL COMMENT '详细地址',
  `partrait_photo` varchar(100) DEFAULT NULL COMMENT '头像照片id',
  `identity_first_photo` varchar(100) DEFAULT NULL COMMENT '身份证人像面照片id',
  `identity_second_photo` varchar(100) DEFAULT NULL COMMENT '身份证国徽面照片id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_medical_print_address_uq` (`hosp_code`,`hug_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='病历复印患者地址表';

-- ----------------------------
-- Table structure for t_medical_print_record
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_print_record`;
CREATE TABLE `t_medical_print_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `open_id` varchar(32) DEFAULT NULL COMMENT '用户相对公众号唯一标识',
  `hug_id` varchar(32) NOT NULL COMMENT '患者id',
  `hug_name` varchar(20) NOT NULL COMMENT '患者姓名',
  `phone` varchar(30) NOT NULL COMMENT '联系方式',
  `card` varchar(50) DEFAULT NULL COMMENT '身份证号',
  `sex` int(1) DEFAULT NULL COMMENT '性别 1女2男',
  `inhosp_serial_no` varchar(32) NOT NULL COMMENT '住院流水号',
  `admit_date` datetime NOT NULL COMMENT '入院日期',
  `order_number` varchar(32) NOT NULL COMMENT '申请单号',
  `copy_detail_code` varchar(20) DEFAULT NULL COMMENT '复印内容项代码（","分隔）',
  `copy_detail_name` varchar(50) DEFAULT NULL COMMENT '复印内容项名称（","分隔）',
  `pat_user_name` varchar(20) NOT NULL COMMENT '取件人',
  `pat_phone` varchar(20) NOT NULL COMMENT '联系方式',
  `pat_region` varchar(50) DEFAULT NULL COMMENT '所在地区',
  `pat_address` varchar(100) DEFAULT NULL COMMENT '详细地址',
  `partrait_photo` varchar(100) DEFAULT NULL COMMENT '头像照片id',
  `identity_first_photo` varchar(100) DEFAULT NULL COMMENT '身份证人像面照片id',
  `identity_second_photo` varchar(100) DEFAULT NULL COMMENT '身份证国徽面照片id',
  `pay_number` varchar(64) DEFAULT NULL COMMENT '支付单号',
  `pay_amount` decimal(7,2) DEFAULT NULL COMMENT '支付金额',
  `pay_date` date DEFAULT NULL COMMENT '支付日期',
  `auditor_id` varchar(32) DEFAULT NULL COMMENT '审核人id',
  `auditor_name` varchar(20) DEFAULT NULL COMMENT '审核人姓名',
  `audit_date` date DEFAULT NULL COMMENT '审核日期',
  `account_user_id` varchar(32) DEFAULT NULL COMMENT '核算人id',
  `account_user_name` varchar(20) DEFAULT NULL COMMENT '核算人姓名',
  `account_date` date DEFAULT NULL COMMENT '核算日期',
  `close_user_id` varchar(32) DEFAULT NULL COMMENT '关闭人id',
  `close_user_name` varchar(20) DEFAULT NULL COMMENT '关闭人姓名',
  `close_date` date DEFAULT NULL COMMENT '关闭日期',
  `copy_identify_user_id` varchar(32) DEFAULT NULL COMMENT '复印确认人id',
  `copy_identify_user_name` varchar(20) DEFAULT NULL COMMENT '复印确认人姓名',
  `copy_identify_date` date DEFAULT NULL COMMENT '复印确认日期',
  `recevier_reject_user_id` varchar(32) DEFAULT NULL COMMENT '接收驳回人id',
  `recevier_reject_user_name` varchar(20) DEFAULT NULL COMMENT '接收驳回人姓名',
  `recevier_reject_date` date DEFAULT NULL COMMENT '接收驳回日期',
  `recevier_user_id` varchar(32) DEFAULT NULL COMMENT '接收人id',
  `recevier_user_name` varchar(20) DEFAULT NULL COMMENT '接收人姓名',
  `recevier_date` date DEFAULT NULL COMMENT '接收日期',
  `finish_identify_user_id` varchar(32) DEFAULT NULL COMMENT '完成确认人id',
  `finish_identify_user_name` varchar(20) DEFAULT NULL COMMENT '完成确认人姓名',
  `finish_identify_date` date DEFAULT NULL COMMENT '完成确认日期',
  `take_type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '收货方式（0:自取 1:快递到付）',
  `order_status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '复印单状态（0:待受理 -1:审核驳回 1:待核算 2:未缴费 3:已关闭 4:待复印 5:待接收 6:待发件 7:待自取 8:已完成）',
  `is_deleted` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否删除(0:否 1:是)',
  `reject_reason` varchar(500) DEFAULT NULL COMMENT '驳回理由',
  `recevier_reject_reason` varchar(500) DEFAULT NULL COMMENT '接收驳回理由',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `tracking_number` varchar(30) DEFAULT NULL COMMENT '快递单号',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `print_number` int(11) DEFAULT NULL COMMENT '快递单号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='病历复印订单表';

-- ----------------------------
-- Table structure for t_medical_surgery_record
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_surgery_record`;
CREATE TABLE `t_medical_surgery_record` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `outhosp_no` varchar(50) DEFAULT NULL,
  `outhosp_serial_no` varchar(50) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `inhosp_num` varchar(20) DEFAULT NULL,
  `inhosp_serial_no` varchar(50) DEFAULT NULL,
  `surger_no` varchar(50) DEFAULT NULL,
  `surgery_seq_no` varchar(50) DEFAULT NULL,
  `surgery_open_code` varchar(250) DEFAULT NULL,
  `surgery_open_name` varchar(250) DEFAULT NULL,
  `swcc` varchar(250) DEFAULT NULL,
  `swcn` varchar(250) DEFAULT NULL,
  `whlc` varchar(250) DEFAULT NULL,
  `whln` varchar(250) DEFAULT NULL,
  `surgery_begin_date` varchar(50) DEFAULT NULL,
  `surgery_end_date` varchar(50) DEFAULT NULL,
  `surgery_dr_code` varchar(250) DEFAULT NULL,
  `surgery_dr_name` varchar(250) DEFAULT NULL,
  `anes_method_code` varchar(250) DEFAULT NULL,
  `anes_method_name` varchar(250) DEFAULT NULL,
  `anes_dr_code` varchar(250) DEFAULT NULL,
  `anes_dr_name` varchar(250) DEFAULT NULL,
  `surgery_lv_code` varchar(250) DEFAULT NULL,
  `surgery_lv_name` varchar(250) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `index_no_id` varchar(200) DEFAULT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_testreport
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_testreport`;
CREATE TABLE `t_medical_testreport` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `index_no_id` varchar(200) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `outhosp_no` varchar(50) DEFAULT NULL,
  `outhosp_serial_no` varchar(50) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `inhosp_num` varchar(20) DEFAULT NULL,
  `inhosp_serial_no` varchar(20) DEFAULT NULL,
  `requisition_no` varchar(50) DEFAULT NULL,
  `report_no` varchar(100) DEFAULT NULL,
  `report_name` varchar(250) DEFAULT NULL,
  `test_item_code` varchar(250) DEFAULT NULL,
  `test_item_name` varchar(500) DEFAULT NULL,
  `microbe_test_flag` varchar(20) DEFAULT NULL,
  `equipment_code` varchar(250) DEFAULT NULL,
  `equipment_name` varchar(250) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `only_index` varchar(200) DEFAULT NULL,
  `apply_date` varchar(50) DEFAULT NULL,
  `apply_dept_code` varchar(250) DEFAULT NULL,
  `apply_dept_name` varchar(250) DEFAULT NULL,
  `apply_dr_code` varchar(250) DEFAULT NULL,
  `apply_dr_name` varchar(250) DEFAULT NULL,
  `execute_date` varchar(50) DEFAULT NULL,
  `report_date` varchar(50) DEFAULT NULL,
  `note` text,
  `sample_type_code` varchar(250) DEFAULT NULL,
  `sample_type_name` varchar(500) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `req_id` varchar(100) DEFAULT NULL,
  `bar_code` varchar(100) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `testreport_only_index` (`only_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_testreq
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_testreq`;
CREATE TABLE `t_medical_testreq` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `index_no_id` varchar(200) DEFAULT NULL,
  `pat_index_no` varchar(32) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `outhosp_no` varchar(50) DEFAULT NULL,
  `outhosp_serial_no` varchar(50) DEFAULT NULL,
  `inhosp_no` varchar(50) DEFAULT NULL,
  `inhosp_num` varchar(10) DEFAULT NULL,
  `inhosp_serial_no` varchar(50) DEFAULT NULL,
  `bar_code_no` varchar(100) DEFAULT NULL,
  `requisition_no` varchar(50) DEFAULT NULL,
  `apply_date` varchar(100) DEFAULT NULL,
  `test_apply_item_code` varchar(250) DEFAULT NULL,
  `test_apply_item_name` varchar(500) DEFAULT NULL,
  `finish_date` varchar(20) DEFAULT NULL,
  `sampling_date` varchar(20) DEFAULT NULL,
  `sampling_location` varchar(50) DEFAULT NULL,
  `take_report_date` varchar(20) DEFAULT NULL,
  `take_report_location` varchar(50) DEFAULT NULL,
  `requisition_print_date` varchar(20) DEFAULT NULL,
  `requisition_status` varchar(10) DEFAULT NULL,
  `note` text,
  `local_finish` int(1) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `only_index` varchar(200) DEFAULT NULL,
  `requisition_no_item` varchar(50) DEFAULT NULL,
  `report_id` varchar(100) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `testreq_only_index` (`only_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_testresult
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_testresult`;
CREATE TABLE `t_medical_testresult` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `hug_id` varchar(32) DEFAULT NULL,
  `index_no_id` varchar(200) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `report_no` varchar(50) DEFAULT NULL,
  `test_item_code` varchar(50) DEFAULT NULL,
  `test_item_name` varchar(100) DEFAULT NULL,
  `test_result_value` varchar(500) DEFAULT NULL,
  `test_result_value_unit` varchar(100) DEFAULT NULL,
  `refe_range` varchar(1000) DEFAULT NULL,
  `refe_uplimit` varchar(1000) DEFAULT NULL,
  `refe_lowlimit` varchar(1000) DEFAULT NULL,
  `nomal_flag` varchar(1000) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `only_index` varchar(200) DEFAULT NULL,
  `report_id` varchar(100) DEFAULT NULL,
  `partner_type` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_medical_title
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_title`;
CREATE TABLE `t_medical_title` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `medical_no` varchar(50) DEFAULT NULL COMMENT '流水号',
  `medical_type` char(1) DEFAULT NULL COMMENT '流水号类型 1 门诊 2 住院',
  `dr_code` varchar(50) DEFAULT NULL COMMENT '医生工号',
  `dr_name` varchar(30) DEFAULT NULL COMMENT '医生名称',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室工号',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `last_syn_time` datetime DEFAULT NULL COMMENT '上传同步时间',
  `local_finish` int(1) DEFAULT '0' COMMENT '是否数据库完全同步到本地',
  `detail_time` datetime DEFAULT NULL COMMENT '详情数据时间',
  `begin_time` varchar(100) DEFAULT NULL,
  `end_time` varchar(32) DEFAULT NULL COMMENT '结束时间',
  `diag_name` varchar(100) DEFAULT NULL COMMENT '诊断名称',
  `card_no` varchar(50) DEFAULT NULL COMMENT '卡片编号',
  `card_type` varchar(10) DEFAULT NULL COMMENT '卡片类型',
  `self_type` int(2) DEFAULT NULL COMMENT '自建病历类别  1 门诊 2 住院 3 体检 4 家庭康复护理',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int(1) DEFAULT '1' COMMENT '是否有效 0无效1有效',
  `short_hosp_name` varchar(50) DEFAULT NULL COMMENT '医院简介(自建病例)',
  PRIMARY KEY (`id`),
  KEY `index_title_hospCode` (`hosp_code`),
  KEY `index_title_begin_time` (`begin_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='医疗头数据';

-- ----------------------------
-- Table structure for t_medical_title_pat
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_title_pat`;
CREATE TABLE `t_medical_title_pat` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `title_id` varchar(32) NOT NULL COMMENT '头数据主键',
  `source_id` varchar(32) NOT NULL COMMENT '来源id 用户hugId 成员memberId 天使patId',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int(1) DEFAULT '1' COMMENT '状态 0无效1有效',
  PRIMARY KEY (`id`),
  KEY `index_soure_id` (`source_id`),
  KEY `index_title_id` (`title_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='医疗头数据-患者关系表';

-- ----------------------------
-- Table structure for t_medical_visitinfo
-- ----------------------------
DROP TABLE IF EXISTS `t_medical_visitinfo`;
CREATE TABLE `t_medical_visitinfo` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `index_no_id` varchar(200) DEFAULT NULL,
  `hosp_code` varchar(50) DEFAULT NULL,
  `pat_index_no` varchar(50) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `out_hosp_no` varchar(50) DEFAULT NULL,
  `out_hosp_serial_no` varchar(50) DEFAULT NULL,
  `pat_type_code` varchar(50) DEFAULT NULL,
  `pat_type_name` varchar(50) DEFAULT NULL,
  `regist_no` varchar(50) DEFAULT NULL,
  `regist_date` varchar(30) DEFAULT NULL,
  `visit_date` varchar(30) DEFAULT NULL,
  `visit_start_date` varchar(30) DEFAULT NULL,
  `visit_end_date` varchar(30) DEFAULT NULL,
  `chief_descr` varchar(1000) DEFAULT NULL,
  `curr_disease_his` text,
  `past_disease_his` text,
  `docotor_code` varchar(50) DEFAULT NULL,
  `docotor_name` varchar(30) DEFAULT NULL,
  `dept_code` varchar(200) DEFAULT NULL,
  `diag_code` varchar(200) DEFAULT NULL,
  `dept_name` varchar(200) DEFAULT NULL,
  `update_time` bigint(19) DEFAULT NULL,
  `diag_name` varchar(200) DEFAULT NULL,
  `is_family` int(1) DEFAULT NULL,
  `only_index` varchar(200) DEFAULT NULL,
  `physical_exam` text,
  `treatment_advice` text,
  `partner_type` int(2) DEFAULT '0',
  `brief_dis_situation` text,
  `visit_summary` text COMMENT '门诊汇总',
  PRIMARY KEY (`id`),
  UNIQUE KEY `visitinfo_index` (`only_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_menstrual_cycle_basal_temperature_record
-- ----------------------------
DROP TABLE IF EXISTS `t_menstrual_cycle_basal_temperature_record`;
CREATE TABLE `t_menstrual_cycle_basal_temperature_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `record_time` varchar(16) DEFAULT NULL COMMENT '记录日期',
  `body_temperature` double DEFAULT NULL COMMENT '体温',
  `menstruation_status_flag` tinyint(1) DEFAULT NULL COMMENT '大姨妈来了',
  `make_love_flag` tinyint(1) DEFAULT NULL COMMENT '当日同房',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='月经周期与基础体温自测记录';

-- ----------------------------
-- Table structure for t_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_menu`;
CREATE TABLE `t_menu` (
  `MENU_ID` varchar(32) NOT NULL COMMENT '菜单ID',
  `MENU_CODE` varchar(50) DEFAULT NULL COMMENT '菜单编号',
  `MENU_NAME` varchar(50) DEFAULT NULL COMMENT '菜单名称',
  `MENU_URL` varchar(255) DEFAULT NULL COMMENT '菜单url',
  `MENU_TYPE` int(2) DEFAULT NULL COMMENT '菜单类型 1 native 2 h5',
  `MENU_IMG` varchar(128) DEFAULT NULL COMMENT '图片',
  `MENU_POSITION` int(2) DEFAULT '1' COMMENT '位置 1 医院 2 百宝箱',
  `SORT` int(11) DEFAULT NULL COMMENT '排序(越小越前)',
  `STATUS` tinyint(4) DEFAULT '1' COMMENT '是否有效(0-无效 1-有效)',
  `CREATE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `UPDATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `version` varchar(6) DEFAULT '2.00' COMMENT '最低版本号',
  `big_image_id` varchar(128) DEFAULT NULL COMMENT '大图',
  `medium_image_id` varchar(128) DEFAULT NULL COMMENT '中图',
  `little_image_id` varchar(128) DEFAULT NULL COMMENT '小图',
  `menu_module` int(1) DEFAULT '1' COMMENT '菜单使用模块 1首页菜单2居家菜单',
  `is_accepted` int(1) DEFAULT NULL COMMENT '是否收案 1是 2否',
  `phone_type` int(1) NOT NULL DEFAULT '3' COMMENT '手机类型 1IOS 2安卓 3IOS和安卓',
  `app_id` varchar(64) DEFAULT NULL COMMENT '小程序appId',
  PRIMARY KEY (`MENU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单表';

-- ----------------------------
-- Table structure for t_menu_hos
-- ----------------------------
DROP TABLE IF EXISTS `t_menu_hos`;
CREATE TABLE `t_menu_hos` (
  `MENU_HOS_ID` varchar(32) NOT NULL,
  `MENU_ID` varchar(32) NOT NULL COMMENT 'APP菜单ID',
  `HOSP_CODE` varchar(32) NOT NULL COMMENT '医院编码',
  `CREATE_TIME` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `SORT` int(2) DEFAULT NULL COMMENT '排序(越小越前)',
  `STATUS` int(2) DEFAULT '1' COMMENT '是否有效(0-无效 1-有效)',
  `HOME_FLAG` int(2) DEFAULT NULL COMMENT '1首页2更多',
  `is_default` int(1) DEFAULT '0' COMMENT '是否默认 0不默认 1默认',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '父ID',
  PRIMARY KEY (`MENU_HOS_ID`),
  UNIQUE KEY `hos_menu_unique` (`MENU_ID`,`HOSP_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单医院关联表';

-- ----------------------------
-- Table structure for t_menu_user
-- ----------------------------
DROP TABLE IF EXISTS `t_menu_user`;
CREATE TABLE `t_menu_user` (
  `MENU_USER_ID` varchar(32) NOT NULL COMMENT '主键',
  `HOSP_CODE` varchar(32) DEFAULT NULL,
  `HUG_ID` varchar(32) NOT NULL COMMENT '用户id',
  `home_menu` varchar(1024) DEFAULT NULL,
  `more_menu` varchar(1024) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `UPDATE_TIME` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `STATUS` int(2) DEFAULT '1' COMMENT '是否有效(0-无效 1-有效)',
  `menu_user_module` int(1) DEFAULT '1' COMMENT '菜单使用模块 1首页菜单2居家菜单',
  PRIMARY KEY (`MENU_USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单用户关联表';

-- ----------------------------
-- Table structure for t_money_config
-- ----------------------------
DROP TABLE IF EXISTS `t_money_config`;
CREATE TABLE `t_money_config` (
  `id` varchar(32) NOT NULL,
  `record_id` varchar(32) DEFAULT NULL COMMENT '审核记录id',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(32) DEFAULT NULL COMMENT '机构名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_money_depart
-- ----------------------------
DROP TABLE IF EXISTS `t_money_depart`;
CREATE TABLE `t_money_depart` (
  `id` varchar(32) NOT NULL,
  `record_id` varchar(32) DEFAULT NULL COMMENT '审核记录id',
  `dept_code` varchar(32) DEFAULT NULL COMMENT '机构代码',
  `dept_name` varchar(32) DEFAULT NULL COMMENT '机构名称',
  `dept_scale` varchar(32) DEFAULT NULL COMMENT '科室比例',
  `manager_scale` varchar(32) DEFAULT NULL COMMENT '主任比例',
  `doc_scale` varchar(32) DEFAULT NULL COMMENT '医生比例',
  `else_scale` varchar(32) DEFAULT NULL COMMENT '其他比例',
  `remarks` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(2) DEFAULT '0' COMMENT '删除标志位 0未删除 1已删除',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_money_record
-- ----------------------------
DROP TABLE IF EXISTS `t_money_record`;
CREATE TABLE `t_money_record` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(32) DEFAULT NULL COMMENT '机构名称',
  `applicant_id` varchar(32) DEFAULT NULL COMMENT '申请人id',
  `applicant_name` varchar(32) DEFAULT NULL COMMENT '申请人姓名',
  `content` varchar(500) DEFAULT NULL COMMENT '摘要内容',
  `exchange_rate` varchar(32) DEFAULT NULL COMMENT '汇率',
  `streamline_price` varchar(32) DEFAULT NULL COMMENT '精细化单价',
  `specialist_price` varchar(32) DEFAULT NULL COMMENT '专科单价',
  `status` int(2) DEFAULT NULL COMMENT '申请状态 1暂存 2审核中 3审核失败 4审核通过',
  `remarks` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `commit_time` datetime DEFAULT NULL COMMENT '发起时间',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `is_delete` int(2) DEFAULT NULL COMMENT '删除标志位 0未删除 1已删除',
  `approval_name` varchar(32) DEFAULT NULL COMMENT '当前审核人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_money_reviewer
-- ----------------------------
DROP TABLE IF EXISTS `t_money_reviewer`;
CREATE TABLE `t_money_reviewer` (
  `id` varchar(32) NOT NULL,
  `record_id` varchar(32) DEFAULT NULL COMMENT '审核记录id',
  `source_id` varchar(32) DEFAULT NULL COMMENT '审核人id',
  `source_name` varchar(32) DEFAULT NULL COMMENT '审核人姓名',
  `suggest` varchar(500) DEFAULT NULL COMMENT '审核人建议',
  `review_status` int(2) DEFAULT NULL COMMENT '审核状态位 0未审核 1审核中 2审核通过 3审核不通过',
  `review_order` int(2) DEFAULT NULL COMMENT '审核顺序  1第一审核人 2第二审核人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(2) DEFAULT '0' COMMENT '删除标志位 0未删除 1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_news
-- ----------------------------
DROP TABLE IF EXISTS `t_news`;
CREATE TABLE `t_news` (
  `id` varchar(32) NOT NULL,
  `title` varchar(100) DEFAULT NULL COMMENT '新闻标题',
  `content` text COMMENT '内容',
  `originContent` text COMMENT '内容',
  `image` varchar(32) DEFAULT NULL COMMENT '图片主键',
  `creator` varchar(50) DEFAULT NULL COMMENT '创建人',
  `operator` varchar(50) DEFAULT NULL COMMENT '修改人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int(1) DEFAULT NULL COMMENT '新闻状态 0不展示1展示',
  `url` text COMMENT 'url地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='官网新闻资讯表';

-- ----------------------------
-- Table structure for t_notice
-- ----------------------------
DROP TABLE IF EXISTS `t_notice`;
CREATE TABLE `t_notice` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '医院编码',
  `dept_code` varchar(4000) DEFAULT NULL COMMENT '科室编码',
  `dept_name` varchar(4000) DEFAULT NULL COMMENT '科室名称',
  `title` varchar(50) NOT NULL COMMENT '标题',
  `content` text NOT NULL COMMENT '内容',
  `create_person` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `status` varchar(1) DEFAULT NULL COMMENT '状态 0无效 1-创建 2-发布',
  `type` int(1) DEFAULT NULL COMMENT '类型1-医院公告 2-蓝牛公告',
  `admin_flag` int(1) NOT NULL DEFAULT '0' COMMENT '管理员标识 0-不是管理员 1-管理员',
  `create_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_one_month_record
-- ----------------------------
DROP TABLE IF EXISTS `t_one_month_record`;
CREATE TABLE `t_one_month_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `umbilical_cord_shedding_time` int(11) DEFAULT NULL COMMENT '脐带脱落时间',
  `yellow_dye_subsided_time` int(11) DEFAULT NULL COMMENT '皮肤黄染消退的时间',
  `milk_times` int(11) DEFAULT NULL COMMENT '每天吃奶次数',
  `stool_times` int(11) DEFAULT NULL,
  `piss_times` int(11) DEFAULT NULL COMMENT '小便次数',
  `feeding_way` int(11) DEFAULT NULL COMMENT '喂养方式',
  `milk_status_flag` tinyint(1) DEFAULT NULL COMMENT '吃奶情况怎么样',
  `shock_move_cry_flag` tinyint(1) DEFAULT NULL COMMENT '有无因受惊伸动手脚或开始哭泣',
  `often_cry_flag` tinyint(1) DEFAULT NULL COMMENT '经常哭闹不易安慰',
  `vitamin_d_or_ad_flag` tinyint(1) DEFAULT NULL COMMENT '补维生素D或AD',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `head_circumference` double DEFAULT NULL COMMENT '头围',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL,
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL,
  `next_check_time` varchar(32) DEFAULT NULL,
  `check_unit` varchar(96) DEFAULT NULL,
  `checker` varchar(976) DEFAULT NULL,
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='一个月记录';

-- ----------------------------
-- Table structure for t_one_year_record
-- ----------------------------
DROP TABLE IF EXISTS `t_one_year_record`;
CREATE TABLE `t_one_year_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `breast_feeding_flag` tinyint(1) DEFAULT NULL COMMENT '是否继续母乳喂养',
  `feeding_status_flag` tinyint(1) DEFAULT NULL COMMENT '宝宝吃饭情况',
  `feeding_times` int(11) DEFAULT NULL COMMENT '每天吃饭次数',
  `teeth_nums` int(11) DEFAULT NULL COMMENT '宝宝出牙数',
  `call_name_respond_flag` tinyint(1) DEFAULT NULL COMMENT '呼唤名字有反应',
  `mock_goodbye_welcome_flag` tinyint(1) DEFAULT NULL COMMENT '会模仿“再见”或“欢迎”',
  `thumb_forefinger_thing_flag` tinyint(1) DEFAULT NULL COMMENT '会用拇食指对捏小物品',
  `lifting_stand_flag` tinyint(1) DEFAULT NULL COMMENT '会扶物站立',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `one_year_old_message` varchar(2048) DEFAULT NULL COMMENT '1岁生日寄语',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `head_circumference` double DEFAULT NULL COMMENT '头围',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL,
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL,
  `next_check_time` varchar(32) DEFAULT NULL,
  `check_unit` varchar(96) DEFAULT NULL,
  `checker` varchar(976) DEFAULT NULL,
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='一岁记录';

-- ----------------------------
-- Table structure for t_one_year_six_months_record
-- ----------------------------
DROP TABLE IF EXISTS `t_one_year_six_months_record`;
CREATE TABLE `t_one_year_six_months_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `eat_with_spoon_flag` tinyint(1) DEFAULT NULL COMMENT '自己拿勺学吃饭',
  `drink_with_cup_flag` tinyint(1) DEFAULT NULL COMMENT '能自己拿着杯子喝水',
  `play_game_flag` tinyint(1) DEFAULT NULL COMMENT '经常与宝宝玩游戏',
  `walk_self_month` int(11) DEFAULT NULL COMMENT '宝宝能独立行走的时间',
  `call_papa_mama_flag` tinyint(1) DEFAULT NULL COMMENT '会有意识地叫“爸爸”或“妈妈”',
  `point_person_thing_flag` tinyint(1) DEFAULT NULL COMMENT '会按要求指人或物',
  `eyes_exchange_flag` tinyint(1) DEFAULT NULL COMMENT '与人有目光交流',
  `walk_alone_flag` tinyint(1) DEFAULT NULL COMMENT '会独走',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `fontanelle_flag` tinyint(1) DEFAULT NULL COMMENT '囟门',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL,
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL,
  `next_check_time` varchar(32) DEFAULT NULL,
  `check_unit` varchar(96) DEFAULT NULL,
  `checker` varchar(976) DEFAULT NULL,
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='一岁六个月记录';

-- ----------------------------
-- Table structure for t_order
-- ----------------------------
DROP TABLE IF EXISTS `t_order`;
CREATE TABLE `t_order` (
  `order_id` varchar(32) NOT NULL,
  `order_no` varchar(32) NOT NULL COMMENT '订单号(自己)',
  `pay_no` varchar(64) DEFAULT NULL COMMENT '交易流水号（支付宝，微信）',
  `business_type` int(1) DEFAULT NULL COMMENT '业务类型 1设备租赁 2购买胎心次数 3图文咨询 4胎心咨询',
  `business_id` varchar(128) NOT NULL COMMENT '业务主键',
  `pay_by` int(1) NOT NULL COMMENT '支付渠道 1支付宝2微信',
  `total_amount` decimal(7,2) NOT NULL COMMENT '总金额',
  `pay_status` int(1) NOT NULL DEFAULT '0' COMMENT '支付状态0:未支付 1:支付中 2:支付完成 3:支付失败',
  `order_string` text COMMENT '支付内容',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `subject` varchar(32) DEFAULT NULL COMMENT '订单标题',
  `body` varchar(128) DEFAULT NULL COMMENT '订单描述',
  `auth_code` varchar(64) DEFAULT NULL COMMENT '支付授权码',
  `refund_status` int(1) DEFAULT NULL COMMENT '退款状态 1:退款中 2:退款成功 3:退款失败',
  `refund_time` datetime DEFAULT NULL COMMENT '退款时间',
  `refund_amount` decimal(7,2) DEFAULT NULL COMMENT '退款金额',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `pay_client_type` int(2) DEFAULT '1' COMMENT '支付客户端类型 1蓝牛 2锦欣',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单表';

-- ----------------------------
-- Table structure for t_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `t_order_refund`;
CREATE TABLE `t_order_refund` (
  `refund_id` varchar(32) NOT NULL,
  `order_id` varchar(32) NOT NULL COMMENT '订单主键',
  `refund_no` varchar(32) NOT NULL COMMENT '退款单号(自己)',
  `refund_status` int(1) NOT NULL COMMENT '退款状态 1:退款中 2:退款成功 3:退款失败',
  `refund_amount` decimal(7,2) NOT NULL COMMENT '退款金额',
  `refund_time` datetime NOT NULL COMMENT '退款时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`refund_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='退款信息表';

-- ----------------------------
-- Table structure for t_parenting_record
-- ----------------------------
DROP TABLE IF EXISTS `t_parenting_record`;
CREATE TABLE `t_parenting_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `feeding_day` int(11) DEFAULT NULL COMMENT '喂养日期',
  `feeding_way` int(11) DEFAULT NULL COMMENT '喂养方式',
  `feeding_times` int(11) DEFAULT NULL COMMENT '吃奶次数',
  `pee_times` int(11) DEFAULT NULL COMMENT '小便次数',
  `shit_times` int(11) DEFAULT NULL COMMENT '大便次数',
  `weight` double DEFAULT NULL COMMENT '体重',
  `skin_yellow_dye_flag` tinyint(1) DEFAULT NULL COMMENT '有无皮肤黄染',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='新生儿早期育儿记录育儿记录)';

-- ----------------------------
-- Table structure for t_patient_medical_param
-- ----------------------------
DROP TABLE IF EXISTS `t_patient_medical_param`;
CREATE TABLE `t_patient_medical_param` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `pat_id` varchar(32) DEFAULT NULL,
  `partner_type` int(2) DEFAULT NULL,
  `new_data_time` bigint(19) DEFAULT NULL,
  `refresh_time` bigint(19) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_phy_exam
-- ----------------------------
DROP TABLE IF EXISTS `t_phy_exam`;
CREATE TABLE `t_phy_exam` (
  `id` varchar(32) NOT NULL,
  `order_id` varchar(50) DEFAULT NULL COMMENT '预约唯一id',
  `hospital_id` varchar(10) DEFAULT NULL COMMENT '医院编码，如果上多个医院，则每个医院要有一个固定的编码',
  `id_number` varchar(25) DEFAULT NULL COMMENT '证件号码',
  `reg_date` datetime DEFAULT NULL COMMENT '预约时间',
  `name` varchar(10) DEFAULT NULL COMMENT '姓名',
  `mari` varchar(2) DEFAULT NULL COMMENT '婚姻状况，M，已婚；S，未婚；N，未知',
  `sex` varchar(2) DEFAULT NULL COMMENT '性别，1：男，2：女 ，9：其他',
  `birthday` varchar(20) DEFAULT NULL COMMENT '生日',
  `phone` varchar(15) DEFAULT NULL COMMENT '电话号码',
  `oper_date` datetime DEFAULT NULL COMMENT '操作时间',
  `set_id` varchar(300) DEFAULT NULL COMMENT '所选套餐ID，多个套餐以英文逗号分隔',
  `set_name` varchar(300) DEFAULT NULL COMMENT '所选套餐名称，多个套餐以英文逗号分隔',
  `order_state` tinyint(2) DEFAULT NULL COMMENT '订单状态，1，订单已取消；0，正常订单；2，转正',
  `fee_state` tinyint(2) DEFAULT NULL COMMENT '费用状态，2，APP退费；0，正常',
  `total_fee` varchar(15) DEFAULT NULL COMMENT '付费总金额',
  `cancel_reg_date` varchar(255) DEFAULT NULL COMMENT '取消预约时间',
  `phy_exam_type` tinyint(2) DEFAULT NULL COMMENT '体检类型 1：个人预约 2：团检预约',
  `item_count` tinyint(4) DEFAULT NULL COMMENT '套餐数量',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `cancel_reason` varchar(200) DEFAULT NULL COMMENT '取消理由',
  `company` varchar(30) DEFAULT NULL COMMENT '企业名称',
  `company_code` varchar(50) DEFAULT NULL COMMENT '企业编码',
  `set_info_parent_code` varchar(100) DEFAULT NULL COMMENT '套餐原始大项',
  `set_info_parent_name` varchar(100) DEFAULT NULL COMMENT '套餐原始大项名称',
  `set_info_child_code` varchar(500) DEFAULT NULL COMMENT '套餐原始小项编码',
  `set_info_child_name` varchar(500) DEFAULT NULL COMMENT '套餐原始小项名称',
  `set_info_pro_code` varchar(300) DEFAULT NULL COMMENT '套餐增加项编码',
  `set_info_pro_name` varchar(300) DEFAULT NULL COMMENT '套餐增加项名称',
  `hg_id` varchar(32) DEFAULT NULL COMMENT '蓝牛id',
  `clinic_code` varchar(50) DEFAULT NULL COMMENT '团检个人流水号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_postnatal_fortytwo_day_doctor_record
-- ----------------------------
DROP TABLE IF EXISTS `t_postnatal_fortytwo_day_doctor_record`;
CREATE TABLE `t_postnatal_fortytwo_day_doctor_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `datasource_from` varchar(20) NOT NULL COMMENT '数据来源',
  `check_time` date DEFAULT NULL COMMENT '检查时间',
  `postpartum_day` int(10) unsigned DEFAULT NULL COMMENT '产后天数',
  `chief_complaint` varchar(2000) DEFAULT NULL COMMENT '主诉',
  `systolic_pressure` int(11) DEFAULT NULL COMMENT '收缩压',
  `diastolic_pressure` int(11) DEFAULT NULL COMMENT '舒张压',
  `weight` double DEFAULT NULL COMMENT '体重',
  `breast_condition` varchar(2000) DEFAULT NULL COMMENT '乳房情况',
  `breast_milk_condition` varchar(2000) DEFAULT NULL COMMENT '乳汁情况',
  `lochia_condition` int(11) DEFAULT NULL COMMENT '恶露情况',
  `wound_condition` varchar(500) DEFAULT NULL COMMENT '伤口情况',
  `vulva_condition` varchar(500) DEFAULT NULL COMMENT '外阴情况',
  `vagina_condition` varchar(500) DEFAULT NULL COMMENT '阴道情况',
  `cervical_condition` varchar(500) DEFAULT NULL COMMENT '宫颈情况',
  `corpus_condition` varchar(500) DEFAULT NULL COMMENT '宫体情况',
  `adnexa_condition` varchar(500) DEFAULT NULL COMMENT '附件情况',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `urine_routines` varchar(500) DEFAULT NULL COMMENT '尿常规',
  `process_advice` varchar(2000) DEFAULT NULL COMMENT '处理及指导',
  `checker` varchar(20) DEFAULT NULL COMMENT '检查者',
  `hosp_name` varchar(30) DEFAULT NULL COMMENT '医院名字',
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '医院代码',
  `associated_hosp_record_id` varchar(255) DEFAULT NULL COMMENT '关联记录id',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `latest_hosp_flag` int(11) DEFAULT '0' COMMENT '标志是否为最新的医院，1位最新',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_postpartum_visit_doctor_record
-- ----------------------------
DROP TABLE IF EXISTS `t_postpartum_visit_doctor_record`;
CREATE TABLE `t_postpartum_visit_doctor_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `visit_time` date NOT NULL COMMENT '访视日期',
  `postpartum_day` int(11) DEFAULT NULL COMMENT '产后天数',
  `temperature` double DEFAULT NULL COMMENT '体温',
  `systolic_pressure` int(11) DEFAULT NULL COMMENT '收缩压',
  `diastolic_pressure` int(11) DEFAULT NULL COMMENT '舒张压',
  `milk` int(11) DEFAULT NULL COMMENT '乳汁',
  `breast_inflamed_flag` tinyint(1) DEFAULT NULL COMMENT '乳房红肿',
  `breast_cracked_flag` tinyint(1) DEFAULT NULL COMMENT '乳头皲裂',
  `uterus_fundus_height` double DEFAULT NULL COMMENT '宫底高度',
  `wound_heal` int(11) DEFAULT NULL COMMENT '伤口愈合',
  `lochia_color_amount` varchar(2000) DEFAULT NULL COMMENT '恶露色量',
  `lochia_abnormal_smell_flag` tinyint(1) DEFAULT NULL COMMENT '恶露异味',
  `other_content` varchar(2000) DEFAULT NULL COMMENT '其他内容',
  `advice_cure` varchar(2000) DEFAULT NULL COMMENT '指导及治疗',
  `appointment_time` datetime DEFAULT NULL COMMENT '预约时间',
  `checker` varchar(20) DEFAULT NULL COMMENT '检查者',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pregnancy_weight_measure
-- ----------------------------
DROP TABLE IF EXISTS `t_pregnancy_weight_measure`;
CREATE TABLE `t_pregnancy_weight_measure` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `record_time` date DEFAULT NULL COMMENT '记录体重日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `increase_weight` double DEFAULT NULL COMMENT '和上周比体重增量',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pregnancywomen_info
-- ----------------------------
DROP TABLE IF EXISTS `t_pregnancywomen_info`;
CREATE TABLE `t_pregnancywomen_info` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `profession` varchar(20) DEFAULT NULL COMMENT '职业',
  `work_environment` int(11) DEFAULT NULL COMMENT '工作环境',
  `vehicle` varchar(20) DEFAULT NULL COMMENT '上下班交通工具',
  `trip_time` double DEFAULT NULL COMMENT '上下班单程时间',
  `pregnant_professional_change` varchar(100) DEFAULT NULL COMMENT '怀孕后工作变更情况',
  `home_environment` int(11) DEFAULT NULL COMMENT '家庭居住环境',
  `doctor_phone` varchar(20) DEFAULT NULL COMMENT '保健医生电话',
  `create_book_time` date DEFAULT NULL COMMENT '建册时间',
  `plan_delivery_hospital` varchar(30) DEFAULT NULL COMMENT '计划分娩医院',
  `puerperal_rest_address` varchar(100) DEFAULT NULL COMMENT '产后计划修养地址',
  `puerperal_visit_phone` varchar(20) DEFAULT NULL COMMENT '产后访视单位电话',
  `pregnant_medical_security` varchar(20) DEFAULT NULL COMMENT '孕妇医疗保障类型',
  `prepare_pregnancy_feel` varchar(2000) DEFAULT NULL COMMENT '备孕感想',
  `health_book_id` varchar(32) NOT NULL COMMENT '所属健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pregnant_class_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pregnant_class_record`;
CREATE TABLE `t_pregnant_class_record` (
  `id` varchar(32) NOT NULL COMMENT '创建时间',
  `topic` varchar(20) DEFAULT NULL COMMENT '课目',
  `attend_class_time` date DEFAULT NULL COMMENT '听课日期',
  `content` varchar(2000) DEFAULT NULL COMMENT '听课内容',
  `remark` varchar(2000) DEFAULT NULL COMMENT '备注',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pregnant_eightten_month_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pregnant_eightten_month_record`;
CREATE TABLE `t_pregnant_eightten_month_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `plan_delivery_place` varchar(20) DEFAULT NULL COMMENT '准备分娩地点',
  `fetal_movement_flag` tinyint(1) DEFAULT NULL COMMENT '每天是否数胎动',
  `weight_increase_range` int(11) DEFAULT NULL COMMENT '体重增长范围',
  `risk_factor_flag` tinyint(1) DEFAULT NULL COMMENT '有无高危因素',
  `risk_factor_content` varchar(2000) DEFAULT NULL COMMENT '高危因素内容',
  `vaginal_bleeding_flag` tinyint(1) DEFAULT NULL COMMENT '阴道是否流血',
  `vaginal_bleeding_time` date DEFAULT NULL COMMENT '阴道流血出现时间',
  `bellyache_flag` tinyint(1) DEFAULT NULL COMMENT '是否腹痛',
  `bellyache_time` date DEFAULT NULL COMMENT '腹痛出现时间',
  `vaginal_water_flag` tinyint(1) DEFAULT NULL COMMENT '是否阴道流水',
  `vaginal_water_time` date DEFAULT NULL COMMENT '阴道流水出现时间',
  `edema_flag` tinyint(1) DEFAULT NULL COMMENT '是否浮肿',
  `edema_time` date DEFAULT NULL COMMENT '浮肿出现时间',
  `dizziness_headache_flag` tinyint(1) DEFAULT NULL COMMENT '是否头晕头疼',
  `dizziness_headache_time` date DEFAULT NULL COMMENT '头晕头疼出现时间',
  `flustered_breath_flag` tinyint(1) DEFAULT NULL COMMENT '是否心慌气短',
  `flustered_breath_time` date DEFAULT NULL COMMENT '心慌气短出现时间',
  `pressure_greater_140_90_falg` tinyint(1) DEFAULT NULL COMMENT '是否血压大于140/90',
  `pressure_greater_140_90_time` date DEFAULT NULL COMMENT '血压大于140/90出现时间',
  `abnormal_fetal_movement_flag` tinyint(1) DEFAULT NULL COMMENT '是否胎动异常',
  `abnormal_fetal_movement_time` date DEFAULT NULL COMMENT '胎动异常出现时间',
  `gestational_week_greater_41_flag` tinyint(1) DEFAULT NULL COMMENT '是否孕周大于41周',
  `gestational_week_greater_41_time` date DEFAULT NULL COMMENT '孕周大于41周时间',
  `consult_doctor_question` varchar(2000) DEFAULT NULL COMMENT '请教医生问题',
  `doctor_advice` varchar(2000) DEFAULT NULL COMMENT '医生建议',
  `pregnancywomen_essay` varchar(2000) DEFAULT NULL COMMENT '准妈妈随笔',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pregnant_fourseven_month_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pregnant_fourseven_month_record`;
CREATE TABLE `t_pregnant_fourseven_month_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `first_fetal_movement_time` date DEFAULT NULL COMMENT '胎动最早出现日期',
  `midtrimester_b_ultrasonic_time` date DEFAULT NULL COMMENT '孕中期做B超的日期',
  `weight_increase_range` int(11) DEFAULT NULL COMMENT '体重增长范围',
  `risk_factor_flag` tinyint(1) DEFAULT NULL COMMENT '是否有高危因素',
  `risk_factor_content` varchar(2000) DEFAULT NULL COMMENT '高危因素情况',
  `vaginal_bleeding_flag` tinyint(1) DEFAULT NULL COMMENT '阴道流血',
  `vaginal_bleeding_time` date DEFAULT NULL COMMENT '出现时间',
  `bellyache_flag` tinyint(1) DEFAULT NULL COMMENT '是否腹痛',
  `bellyache_time` date DEFAULT NULL COMMENT '腹痛出现时间',
  `fever_flag` tinyint(1) DEFAULT NULL COMMENT '是否发热',
  `fever_time` date DEFAULT NULL COMMENT '发热时间',
  `hyperemesis_flag` tinyint(1) DEFAULT NULL COMMENT '是否呕吐',
  `hyperemesis_time` date DEFAULT NULL COMMENT '呕吐出现时间',
  `dizziness_headache_flag` tinyint(1) DEFAULT NULL COMMENT '头晕头疼视物不清',
  `dizziness_headache_time` date DEFAULT NULL COMMENT '头晕头疼出现时间',
  `flustered_flag` tinyint(1) DEFAULT NULL COMMENT '心慌憋气',
  `flustered_time` date DEFAULT NULL COMMENT '心慌憋气时间',
  `pressure_greater_140_90_flag` tinyint(1) DEFAULT NULL COMMENT '血压大于140/90',
  `pressure_greater_140_90_time` date DEFAULT NULL COMMENT '血压大于140/90日期',
  `short_time_increase_weight_flag` tinyint(1) DEFAULT NULL COMMENT '短时间内体重增加过多',
  `short_time_increase_weight_time` date DEFAULT NULL COMMENT '短时间内体重增加过多出现时间',
  `consult_doctor_question` varchar(2000) DEFAULT NULL COMMENT '请教医生问题',
  `doctor_advice` varchar(2000) DEFAULT NULL COMMENT '医生建议',
  `pregnancywomen_essay` varchar(2000) DEFAULT NULL COMMENT '准妈妈随笔',
  `health_book_id` varchar(32) NOT NULL COMMENT 'health_book_id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pregnant_fourten_month_check_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pregnant_fourten_month_check_record`;
CREATE TABLE `t_pregnant_fourten_month_check_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `datasource_from` varchar(20) NOT NULL COMMENT '数据来源',
  `check_time` date DEFAULT NULL COMMENT '检查日期',
  `systolic_pressure` int(11) DEFAULT NULL COMMENT '收缩压',
  `diastolic_pressure` int(11) DEFAULT NULL COMMENT '舒张压',
  `weight` double DEFAULT NULL COMMENT '体重',
  `fundal_height` double DEFAULT NULL COMMENT '宫高',
  `albuminuria` varchar(20) DEFAULT NULL COMMENT '尿蛋白',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `risk_factor` varchar(2000) DEFAULT NULL COMMENT '高危因素',
  `process_advice` varchar(2000) DEFAULT NULL COMMENT '处理及建议',
  `appointment_time` date DEFAULT NULL COMMENT '预约日期',
  `checker` varchar(20) DEFAULT NULL COMMENT '检查者',
  `hosp_name` varchar(30) DEFAULT NULL COMMENT '医院名字',
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '医院代码',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `associated_hosp_record_id` varchar(255) DEFAULT NULL COMMENT '关联医院记录id',
  `latest_hosp_flag` int(255) DEFAULT '0' COMMENT '是不是最新的关联医院信息，0表示不是最新，1表示是最新',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pregnant_onethree_month_check_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pregnant_onethree_month_check_record`;
CREATE TABLE `t_pregnant_onethree_month_check_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `check_time` date DEFAULT NULL COMMENT '检查日期',
  `height` double DEFAULT NULL COMMENT '身高',
  `weight` double DEFAULT NULL COMMENT '体重',
  `systolic_pressure` int(11) DEFAULT NULL COMMENT '收缩压',
  `diastolic_pressure` int(11) DEFAULT NULL COMMENT '舒张压',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `platelet_count` double DEFAULT NULL COMMENT '血小板计数',
  `blood_routine_other` varchar(2000) DEFAULT NULL COMMENT '血常规其它',
  `albuminuria` varchar(20) DEFAULT NULL COMMENT '尿蛋白',
  `urine_sugar` varchar(20) DEFAULT NULL COMMENT '尿糖',
  `ketone` varchar(20) DEFAULT NULL COMMENT '	尿酮体',
  `urine_routine_other` varchar(2000) DEFAULT NULL COMMENT '其它内容',
  `abo_blood_type` varchar(10) DEFAULT NULL COMMENT 'ABO血型',
  `rh_blood_type` varchar(5) DEFAULT NULL COMMENT 'RH血型',
  `hbsag_flag` tinyint(1) DEFAULT NULL COMMENT '乙肝表面抗原',
  `liver_function_flag` tinyint(1) DEFAULT NULL COMMENT '肝功能',
  `syphilis_serum_test_flag` tinyint(1) DEFAULT NULL COMMENT '梅毒血清实验',
  `renal_function_flag` tinyint(1) DEFAULT NULL COMMENT '肾功能',
  `hiv_antibody_test_flag` tinyint(1) DEFAULT NULL COMMENT 'HIV抗体检测',
  `process_advice` varchar(2000) DEFAULT NULL COMMENT '处理及建议',
  `guidance` varchar(2000) DEFAULT NULL COMMENT '指导事项',
  `check_unit` varchar(50) DEFAULT NULL COMMENT '检查单位',
  `checker` varchar(20) DEFAULT NULL COMMENT '检查者',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_pregnant_onethree_month_record
-- ----------------------------
DROP TABLE IF EXISTS `t_pregnant_onethree_month_record`;
CREATE TABLE `t_pregnant_onethree_month_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `last_menstrual_time` date NOT NULL COMMENT '末次月经时间',
  `excepted_confinement_time` date DEFAULT NULL COMMENT '预产期',
  `height` double NOT NULL COMMENT '身高',
  `weight` double NOT NULL COMMENT '体重',
  `weight_increase_range` int(11) DEFAULT NULL COMMENT '体重增长范围',
  `attend_class_flag` tinyint(1) DEFAULT NULL COMMENT '是否上课',
  `risk_factor_flag` tinyint(1) DEFAULT NULL COMMENT '有无高危危险因素',
  `risk_content` varchar(2000) DEFAULT NULL COMMENT '	具体情况',
  `vaginal_bleeding_flag` tinyint(1) DEFAULT NULL COMMENT '有无阴道流血',
  `vaginal_bleeding_time` date DEFAULT NULL COMMENT '	阴道流血时间',
  `bellyache_flag` tinyint(1) DEFAULT NULL COMMENT '	有无腹痛',
  `bellyache_time` date DEFAULT NULL COMMENT '腹痛时间',
  `fever_flag` tinyint(1) DEFAULT NULL COMMENT '有无发热',
  `fever_time` date DEFAULT NULL COMMENT '发热出现时间',
  `hyperemesis_flag` tinyint(1) DEFAULT NULL COMMENT '是否剧烈呕吐',
  `hyperemesis_time` date DEFAULT NULL COMMENT '剧烈呕吐出现时间',
  `consult_doctor_question` varchar(2000) DEFAULT NULL COMMENT '请教医生问题',
  `doctor_advice` varchar(2000) DEFAULT NULL COMMENT '医生建议',
  `pregnancywomen_essay` varchar(2000) DEFAULT NULL COMMENT '准妈妈随笔',
  `health_book_id` varchar(32) NOT NULL COMMENT '创建时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_prenatal_eugenic_health_check_record
-- ----------------------------
DROP TABLE IF EXISTS `t_prenatal_eugenic_health_check_record`;
CREATE TABLE `t_prenatal_eugenic_health_check_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `check_time` varchar(16) NOT NULL COMMENT '检查日期',
  `mother_systolic_pressure` int(11) DEFAULT NULL COMMENT '收缩压',
  `mother_diastolic_pressure` int(11) DEFAULT NULL COMMENT '舒张压',
  `mother_reproductive_system_check_flag` tinyint(1) DEFAULT NULL COMMENT '生殖系统检查',
  `mother_abo_blood_type` varchar(10) DEFAULT NULL COMMENT 'ABO血型',
  `mother_rh_blood_type` varchar(5) DEFAULT NULL COMMENT 'RH血型',
  `mother_hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `mother_platelet_count` double DEFAULT NULL COMMENT '血小板计数',
  `mother_fasting_blood_sugar` double DEFAULT NULL COMMENT '空腹血糖',
  `mother_hypertension_flag` tinyint(1) DEFAULT NULL COMMENT '高血压',
  `mother_diabetes_flag` tinyint(1) DEFAULT NULL COMMENT '是否糖尿病',
  `mother_liver_function_flag` tinyint(1) DEFAULT NULL COMMENT '肝功能',
  `mother_renal_function_flag` tinyint(1) DEFAULT NULL COMMENT '肾功能',
  `mother_alt_value` double DEFAULT NULL COMMENT 'ALT',
  `mother_creatinine_value` double DEFAULT NULL COMMENT '肌酐',
  `mother_thyroid_hormone_level_flag` tinyint(1) DEFAULT NULL COMMENT '促甲状腺激素水平',
  `mother_tsh_value` double DEFAULT NULL COMMENT '促甲状腺素',
  `mother_bacterial_vaginosis_flag` tinyint(1) DEFAULT NULL COMMENT '细菌性阴道病',
  `mother_candida_infection_flag` tinyint(1) DEFAULT NULL COMMENT '假丝酵母菌感染',
  `mother_trichomonas_infection_flag` tinyint(1) DEFAULT NULL COMMENT '滴虫感染',
  `mother_chlamydia_trachomatis_screening_flag` tinyint(1) DEFAULT NULL COMMENT '沙眼衣原体筛查',
  `mother_neisseria_gonorrhoeae_infection_flag` tinyint(1) DEFAULT NULL COMMENT '淋球菌感染',
  `mother_hbsag_flag` tinyint(1) DEFAULT NULL COMMENT '乙肝表面抗原',
  `mother_treponema_pallidum_screening_flag` tinyint(1) DEFAULT NULL COMMENT '梅毒螺旋体筛查',
  `mother_hiv_antibody_test_flag` tinyint(1) DEFAULT NULL COMMENT 'HIV抗体检测',
  `mother_rcubella_virus_check_igg_antibody_flag` tinyint(1) DEFAULT NULL COMMENT '风疹病毒检查IgG抗体',
  `mother_cytomegalovirus_igm_antibody_flag` tinyint(1) DEFAULT NULL COMMENT '巨细胞病毒检查IgM抗体',
  `mother_cytomegalovirus_igg_antibody_flag` tinyint(1) DEFAULT NULL COMMENT '巨细胞病毒检查IgM抗体',
  `mother_toxoplasma_igm_antibody_flag` tinyint(1) DEFAULT NULL,
  `mother_toxoplasma_igg_antibody_flag` tinyint(1) DEFAULT NULL,
  `father_systolic_pressure` int(11) DEFAULT NULL COMMENT '收缩压',
  `father_diastolic_pressure` int(11) DEFAULT NULL COMMENT '舒张压',
  `father_reproductive_system_check_flag` tinyint(1) DEFAULT NULL COMMENT '生殖系统检查',
  `father_abo_blood_type` varchar(10) DEFAULT NULL COMMENT 'ABO血型',
  `father_rh_blood_type` varchar(5) DEFAULT NULL COMMENT 'RH血型',
  `father_hypertension_flag` tinyint(1) DEFAULT NULL COMMENT '高血压',
  `father_diabetes_flag` tinyint(1) DEFAULT NULL COMMENT '是否糖尿病',
  `father_liver_function_flag` tinyint(1) DEFAULT NULL COMMENT '肝功能',
  `father_renal_function_flag` tinyint(1) DEFAULT NULL COMMENT '肾功能',
  `father_alt_value` double DEFAULT NULL COMMENT 'ALT',
  `father_creatinine_value` double DEFAULT NULL COMMENT '肌酐',
  `father_hbsag_flag` tinyint(1) DEFAULT NULL COMMENT '乙肝表面抗原',
  `father_treponema_pallidum_screening_flag` tinyint(1) DEFAULT NULL COMMENT '梅毒螺旋体筛查',
  `father_hiv_antibody_test_flag` tinyint(1) DEFAULT NULL COMMENT 'HIV抗体检测',
  `guidance` varchar(2000) DEFAULT NULL COMMENT '指导事项',
  `check_unit` varchar(50) DEFAULT NULL COMMENT '检查单位',
  `checker` varchar(20) DEFAULT NULL COMMENT '检查者',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='孕前优生健康检查记录';

-- ----------------------------
-- Table structure for t_presc_drug
-- ----------------------------
DROP TABLE IF EXISTS `t_presc_drug`;
CREATE TABLE `t_presc_drug` (
  `id` varchar(32) NOT NULL,
  `presc_id` varchar(32) NOT NULL COMMENT '关联的处方id',
  `drug_name` varchar(32) NOT NULL COMMENT '药物标准名称',
  `drug_usual_name` varchar(32) DEFAULT NULL COMMENT '药物俗名',
  `drug_format` varchar(32) DEFAULT NULL COMMENT '药物规格',
  `drug_number` varchar(32) DEFAULT NULL COMMENT '药物数量',
  `drug_unit` varchar(32) DEFAULT NULL COMMENT '药物单位',
  `drug_usage` varchar(32) DEFAULT NULL COMMENT '用法',
  `drug_frequency` varchar(32) DEFAULT NULL COMMENT '用药频次',
  `drug_amount` varchar(32) DEFAULT NULL COMMENT '每次的用量',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='处方关联药物表';

-- ----------------------------
-- Table structure for t_presc_express
-- ----------------------------
DROP TABLE IF EXISTS `t_presc_express`;
CREATE TABLE `t_presc_express` (
  `id` varchar(32) NOT NULL,
  `presc_id` varchar(32) NOT NULL COMMENT '处方id 处方单号',
  `express_no` varchar(32) NOT NULL COMMENT '快递单号',
  `express_company` varchar(32) NOT NULL COMMENT '快递公司',
  `status` varchar(32) DEFAULT NULL COMMENT '快递状态',
  `traces` text,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='处方快递表';

-- ----------------------------
-- Table structure for t_presc_info
-- ----------------------------
DROP TABLE IF EXISTS `t_presc_info`;
CREATE TABLE `t_presc_info` (
  `id` varchar(32) NOT NULL,
  `date` varchar(32) NOT NULL COMMENT '处方日期',
  `type` varchar(32) NOT NULL COMMENT '处方类型 外延处方',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(32) NOT NULL COMMENT '医院名称',
  `hug_id` varchar(32) NOT NULL COMMENT '患者蓝牛号',
  `name` varchar(32) NOT NULL COMMENT '患者姓名',
  `sex` varchar(32) NOT NULL COMMENT '患者性别',
  `age` varchar(32) NOT NULL COMMENT '年龄',
  `phone` varchar(32) NOT NULL COMMENT '患者手机号',
  `doc_hug_id` varchar(32) NOT NULL COMMENT '医生蓝牛号',
  `doc_name` varchar(32) NOT NULL COMMENT '医生姓名',
  `dr_code` varchar(32) NOT NULL COMMENT '医生工号',
  `diagnosis` text NOT NULL COMMENT '医生诊断',
  `ask` text NOT NULL COMMENT '患者主诉（患者描述）',
  `fee` varchar(32) NOT NULL COMMENT '药品总费用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `pay_state` int(4) DEFAULT NULL COMMENT '支付状态 0失效 1未支付 2已支付',
  `state` int(4) DEFAULT NULL COMMENT '处方状态 1待确认 2待审核 3待发货 4已发货',
  `take_way` int(2) DEFAULT NULL COMMENT '取货方式 1快递 2自提',
  `address` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='在线续方表';

-- ----------------------------
-- Table structure for t_private_domain
-- ----------------------------
DROP TABLE IF EXISTS `t_private_domain`;
CREATE TABLE `t_private_domain` (
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
  `private_domain_status` int(11) NOT NULL DEFAULT '1' COMMENT '状态 0 启用 1 禁用',
  `create_id` varchar(32) NOT NULL COMMENT '创建人',
  `create_by` varchar(255) NOT NULL COMMENT '创建人名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_id` varchar(32) NOT NULL COMMENT '更新人',
  `update_by` varchar(255) NOT NULL COMMENT '更新人名称',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` int(11) NOT NULL DEFAULT '0' COMMENT '是否删除 0 否 1 是',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `hosp_name` varchar(255) NOT NULL COMMENT '医院名称',
  `class_code` varchar(32) NOT NULL DEFAULT '' COMMENT '科室编码',
  `class_name` varchar(255) NOT NULL DEFAULT '' COMMENT '科室名称',
  `identify` varchar(32) NOT NULL COMMENT '主体',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='私域运营';

-- ----------------------------
-- Table structure for t_puerperium_condition_record
-- ----------------------------
DROP TABLE IF EXISTS `t_puerperium_condition_record`;
CREATE TABLE `t_puerperium_condition_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `feeding_way` int(11) DEFAULT NULL COMMENT '喂养方式',
  `first_postpartum_lactating` int(11) DEFAULT NULL COMMENT '首次产后哺乳几小时',
  `postpartum_vagina_persist_blooding` int(11) DEFAULT NULL COMMENT '产后阴道持续流血天数',
  `postpartum_visit_condition_flag` tinyint(1) DEFAULT NULL COMMENT '产后访视情况',
  `postpartum_visit_condition_content` varchar(2000) DEFAULT NULL COMMENT '产后访视具体情况',
  `postpartum_fortytwo_check_result_flag` tinyint(1) DEFAULT NULL COMMENT '产后42天检查结果',
  `postpartum_fortytwo_check_content` varchar(2000) DEFAULT NULL COMMENT '产后42天检查具体描述',
  `postpartum_fortytwo_weight` double DEFAULT NULL COMMENT '产后42天体重',
  `menstrual_recover_flag` tinyint(1) DEFAULT NULL COMMENT '月经是否恢复',
  `menstrual_recover_time` date DEFAULT NULL COMMENT '月经恢复日期',
  `postpartum_contraception_flag` tinyint(1) DEFAULT NULL COMMENT '产后有无避孕',
  `contraception_way` varchar(30) DEFAULT NULL COMMENT '避孕措施',
  `postpartum_other_condition_flag` tinyint(1) DEFAULT NULL COMMENT '产后其它情况',
  `postpartum_other_condition_content` varchar(2000) DEFAULT NULL COMMENT '产后其它情况内容',
  `bellyache_flag` tinyint(1) DEFAULT NULL COMMENT '是否腹痛',
  `bellyache_time` date DEFAULT NULL COMMENT '腹痛时间',
  `fever_flag` tinyint(1) DEFAULT NULL COMMENT '是否发热',
  `fever_time` date DEFAULT NULL COMMENT '发热时间',
  `vagina_stink_flag` tinyint(1) DEFAULT NULL COMMENT '阴道分泌物是否发臭',
  `vagina_stink_time` date DEFAULT NULL COMMENT '阴道分泌物发臭时间',
  `breast_pain_flag` tinyint(1) DEFAULT NULL COMMENT '乳房是否红肿胀痛',
  `breast_pain_time` date DEFAULT NULL COMMENT '乳房红肿胀痛日期',
  `wound_heal_flag` tinyint(1) DEFAULT NULL COMMENT '是否伤口愈合不良感染',
  `wound_heal_time` date DEFAULT NULL COMMENT '伤口愈合不良感染日期',
  `mood_down_flag` tinyint(1) DEFAULT NULL COMMENT '是否情绪低落、哭泣',
  `mood_down_time` date DEFAULT NULL COMMENT '情绪低落、哭泣日期',
  `consult_doctor_question` varchar(2000) DEFAULT NULL COMMENT '请教医生问题',
  `doctor_advice` varchar(2000) DEFAULT NULL COMMENT '医生建议',
  `parenting_tips` varchar(2000) DEFAULT NULL COMMENT '育儿心得',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_qa_record
-- ----------------------------
DROP TABLE IF EXISTS `t_qa_record`;
CREATE TABLE `t_qa_record` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '机构代码',
  `mobile_no` varchar(20) DEFAULT NULL COMMENT '手机号',
  `visit_card_no` varchar(50) DEFAULT NULL COMMENT '卡号/病案号',
  `session_id` varchar(50) DEFAULT NULL COMMENT '会话ID',
  `ask_or_answer` tinyint(1) NOT NULL COMMENT '问或答(1,问 2,答)',
  `content` varchar(1000) DEFAULT NULL COMMENT '聊天内容',
  `create_time` datetime(3) NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QA聊天记录';

-- ----------------------------
-- Table structure for t_ready_pregnantparent_info
-- ----------------------------
DROP TABLE IF EXISTS `t_ready_pregnantparent_info`;
CREATE TABLE `t_ready_pregnantparent_info` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '主键',
  `mother_name` varchar(20) NOT NULL DEFAULT '' COMMENT '母亲姓名',
  `mother_age` int(11) NOT NULL DEFAULT '0' COMMENT '母亲年龄',
  `mother_profession` varchar(30) NOT NULL COMMENT '母亲职业',
  `mother_nation_code` varchar(255) NOT NULL COMMENT '母亲民族代码',
  `mother_nation` varchar(20) NOT NULL COMMENT '母亲民族',
  `mother_id_card` varchar(20) NOT NULL COMMENT '母亲身份证',
  `mother_residence_code` varchar(255) NOT NULL COMMENT '母亲户口代码',
  `mother_residence_country` varchar(255) NOT NULL COMMENT '备孕妈妈户口县市',
  `mother_residence_city` varchar(255) NOT NULL COMMENT '备孕妈妈户口城市',
  `mother_residence_province` varchar(100) NOT NULL COMMENT '备孕妈妈户口省份',
  `mother_company` varchar(100) NOT NULL COMMENT '备孕妈妈公司',
  `mother_address_code` varchar(255) NOT NULL COMMENT '母亲家庭地址代码',
  `mother_address_detail` varchar(255) NOT NULL COMMENT '备孕妈妈具体地址',
  `mother_address_country` varchar(255) NOT NULL COMMENT '备孕妈妈地址县市',
  `mother_address_city` varchar(255) NOT NULL COMMENT '备孕妈妈地址城市',
  `mother_address_province` varchar(100) NOT NULL COMMENT '备孕妈妈地址省份',
  `mother_phone` varchar(20) NOT NULL COMMENT '备孕妈妈手机号',
  `hosp_code` varchar(255) DEFAULT NULL COMMENT '关联医院代码',
  `hosp` varchar(255) DEFAULT NULL COMMENT '关联医院名字',
  `father_name` varchar(20) DEFAULT NULL COMMENT '备孕爸爸姓名',
  `father_age` int(11) DEFAULT NULL COMMENT '备孕爸爸年龄',
  `father_profession` varchar(30) DEFAULT NULL COMMENT '备孕爸爸职业',
  `father_nation_code` varchar(255) DEFAULT NULL COMMENT '爸爸民族代码',
  `father_nation` varchar(20) DEFAULT NULL COMMENT '备孕爸爸民族',
  `father_id_card` varchar(20) DEFAULT NULL COMMENT '备孕爸爸身份证',
  `father_company` varchar(100) DEFAULT NULL COMMENT '备孕爸爸公司',
  `father_phone` varchar(20) DEFAULT NULL COMMENT '备孕爸爸手机号',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `user_status_name` varchar(255) DEFAULT NULL COMMENT '用户身份',
  `user_status_code` varchar(255) DEFAULT NULL COMMENT '用户身份编码,1:待孕妇女 2:孕妇 3:儿童',
  `issuing_institution_code` varchar(255) DEFAULT NULL COMMENT '组织机构编码',
  `issuing_institution_name` varchar(255) DEFAULT NULL COMMENT '组织结构编码名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_ready_pregnantparent_record
-- ----------------------------
DROP TABLE IF EXISTS `t_ready_pregnantparent_record`;
CREATE TABLE `t_ready_pregnantparent_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `record_time` varchar(16) DEFAULT NULL COMMENT '记录日期',
  `mother_marry_age` int(11) DEFAULT NULL COMMENT '备孕妈妈结婚年龄',
  `father_marry_age` int(11) DEFAULT NULL COMMENT '备孕爸爸结婚年龄',
  `mother_plan_pregent_age` int(11) DEFAULT NULL COMMENT '备孕妈妈计划怀孕年龄',
  `father_plan_pregent_age` int(11) DEFAULT NULL COMMENT '备孕爸爸计划怀孕年龄',
  `mother_height` double DEFAULT NULL COMMENT '备孕妈妈身高',
  `mother_weight` double DEFAULT NULL COMMENT '备孕妈妈体重',
  `mother_check_result_flag` tinyint(1) DEFAULT NULL COMMENT '孕期检查结果',
  `mother_disease_name` varchar(255) DEFAULT NULL COMMENT '疾病名称',
  `father_height` double DEFAULT NULL COMMENT '备孕爸爸身高',
  `father_weight` double DEFAULT NULL COMMENT '备孕爸爸体重',
  `father_check_result_flag` tinyint(1) DEFAULT NULL COMMENT '孕期检查结果',
  `father_disease_name` varchar(64) DEFAULT NULL COMMENT '疾病名称',
  `prepare_pregnancy_feel` varchar(2000) DEFAULT NULL COMMENT '备孕感想',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='备孕爸妈自我记录';

-- ----------------------------
-- Table structure for t_register
-- ----------------------------
DROP TABLE IF EXISTS `t_register`;
CREATE TABLE `t_register` (
  `id` varchar(32) NOT NULL COMMENT '预约挂号ID',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `sch_id` varchar(32) NOT NULL COMMENT '排班ID',
  `reg_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '预约类型 0普通预约  1当日挂号',
  `reg_status` tinyint(1) DEFAULT NULL COMMENT '预约状态包括：预约中(0), 无效(-1)，预约(1)，自动取消/自动退号(2)，已取消/已退号(3)，违约(4)，已就诊(5), 过期(6)',
  `hg_id` varchar(32) DEFAULT NULL COMMENT '用户ID',
  `family_id` varchar(32) DEFAULT NULL COMMENT '成员ID',
  `card_id` varchar(200) DEFAULT NULL COMMENT '卡号ID',
  `sch_date` varchar(32) DEFAULT NULL COMMENT '排班日期',
  `expect_stime` varchar(32) DEFAULT NULL COMMENT '预约就诊开始时间',
  `expect_etime` varchar(32) DEFAULT NULL COMMENT '预约就诊结束时间',
  `expect_addr` varchar(64) DEFAULT NULL COMMENT '就诊地址',
  `take_password` varchar(20) DEFAULT NULL COMMENT '预约凭证',
  `take_index` varchar(12) DEFAULT NULL COMMENT '就诊序号',
  `reg_code` varchar(64) DEFAULT NULL COMMENT '对接挂号Code',
  `reg_fee` decimal(9,2) DEFAULT NULL COMMENT '挂号费用(self_fee+heal_fee)',
  `source_code` varchar(36) DEFAULT NULL COMMENT '(对接)号源Code',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `wait_addr` varchar(32) DEFAULT NULL COMMENT '候诊地址',
  `wait_time` varchar(32) DEFAULT NULL COMMENT '候诊时间',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：冻结(0)，有效(1)，撤销(2)，删除(-1)等',
  `dept_code` varchar(32) DEFAULT NULL COMMENT '科室code',
  `staff_code` varchar(32) DEFAULT NULL COMMENT '医生code',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '病人名称',
  `card` varchar(64) DEFAULT NULL COMMENT '身份证号',
  PRIMARY KEY (`id`),
  KEY `FK_Reference_1` (`sch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='预约信息';

-- ----------------------------
-- Table structure for t_remark
-- ----------------------------
DROP TABLE IF EXISTS `t_remark`;
CREATE TABLE `t_remark` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `target_hug_id` varchar(32) DEFAULT NULL COMMENT '目标蓝牛号',
  `remark_name` varchar(100) DEFAULT NULL COMMENT '备注名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_hug_id_target_hug_id` (`hug_id`,`target_hug_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='app备注表';

-- ----------------------------
-- Table structure for t_rental_sms
-- ----------------------------
DROP TABLE IF EXISTS `t_rental_sms`;
CREATE TABLE `t_rental_sms` (
  `id` varchar(255) DEFAULT NULL COMMENT '主键id',
  `mobile_no` varchar(255) DEFAULT NULL COMMENT '手机号',
  `create_time` varchar(255) DEFAULT NULL COMMENT '时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备购买短信提醒';

-- ----------------------------
-- Table structure for t_repository_account
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_account`;
CREATE TABLE `t_repository_account` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '主键',
  `account_name` varchar(100) DEFAULT NULL COMMENT '账户名称',
  `account_type` varchar(1) DEFAULT NULL COMMENT '账户类别 0医院 1社区',
  `create_time` datetime DEFAULT NULL COMMENT '账户创建时间',
  `effective_time` datetime DEFAULT NULL COMMENT '账户有效时间',
  `donate_balance` double(20,2) DEFAULT NULL COMMENT '赠送金余额',
  `recharge_balance` double(20,2) DEFAULT NULL COMMENT '充值金余额',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '机构代码',
  `donate_all` double(20,2) DEFAULT NULL COMMENT '赠送金总额',
  `recharge_all` double(20,2) DEFAULT NULL COMMENT '充值金总额',
  `account_manager` varchar(100) DEFAULT NULL COMMENT '账户管理员账号',
  `account_phone` varchar(100) DEFAULT NULL COMMENT '账户联系电话',
  `phone_status` varchar(1) DEFAULT NULL COMMENT '账户电话状况 0正常 1未使用',
  `package_type` varchar(20) DEFAULT NULL COMMENT '套餐类型',
  `sms_count` int(11) DEFAULT NULL COMMENT '剩余短信条数',
  `child_account_name` varchar(100) DEFAULT NULL COMMENT '关联子账号',
  `child_account_pwd` varchar(100) DEFAULT NULL COMMENT '关联子账号的密码',
  `hosp_prefix` varchar(50) DEFAULT NULL COMMENT '医院签名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_repository_education
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_education`;
CREATE TABLE `t_repository_education` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '机构代码',
  `dept_code` varchar(15) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人ID',
  `creator_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `category_id` varchar(32) DEFAULT NULL COMMENT '宣教分类ID',
  `cover_img_src` varchar(200) DEFAULT NULL COMMENT '宣教封面图片路径',
  `title` varchar(100) DEFAULT NULL COMMENT '宣教标题',
  `content` text COMMENT '宣教内容',
  `ppt_src` varchar(200) DEFAULT NULL COMMENT '宣教PPT路径',
  `share_status` int(11) DEFAULT '0' COMMENT '共享状态(0:不共享 1:本科室共享 2:全院共享)',
  `invalid_flag` int(11) DEFAULT '1' COMMENT '作废标识(0:作废 1:有效)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_repository_hospital
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_hospital`;
CREATE TABLE `t_repository_hospital` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '主键',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '机构编码',
  `server_code` varchar(50) DEFAULT NULL COMMENT '服务器编码',
  `app_id` varchar(50) DEFAULT NULL COMMENT '云通讯appId',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '机构名称',
  `hosp_abbr` varchar(50) DEFAULT NULL COMMENT '机构简称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_repository_server
-- ----------------------------
DROP TABLE IF EXISTS `t_repository_server`;
CREATE TABLE `t_repository_server` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '主键',
  `server_name` varchar(50) DEFAULT NULL COMMENT '服务器名称',
  `server_ip` varchar(50) DEFAULT NULL COMMENT '服务器ip',
  `server_port` varchar(10) DEFAULT NULL COMMENT '服务器端口',
  `interview_name` varchar(50) DEFAULT NULL COMMENT '随访名称',
  `interview_key` varchar(50) DEFAULT NULL COMMENT '随访密钥',
  `server_code` varchar(50) DEFAULT NULL COMMENT '服务器编码',
  `source_type` varchar(2) DEFAULT NULL COMMENT '厂商来源 1   健海科技 2 天使医生',
  `hosp_ip` varchar(50) DEFAULT NULL COMMENT '医院内网ip',
  `hosp_port` varchar(50) DEFAULT NULL COMMENT '医院内网端口',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_resource_file
-- ----------------------------
DROP TABLE IF EXISTS `t_resource_file`;
CREATE TABLE `t_resource_file` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `real_name` varchar(100) DEFAULT NULL COMMENT '存储文件名',
  `upload_name` varchar(150) DEFAULT NULL COMMENT '上传时的文件名',
  `file_type` varchar(10) DEFAULT NULL COMMENT '相关模块',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '相关模块id',
  `upload_time` bigint(19) DEFAULT NULL COMMENT '上传时间',
  `size` int(19) DEFAULT NULL COMMENT '文件大小',
  `upload_user` varchar(32) DEFAULT NULL COMMENT '上传者',
  `view_url` varchar(200) DEFAULT NULL,
  `thumbnail` varchar(150) DEFAULT NULL COMMENT '缩略图',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_resource_file_copy
-- ----------------------------
DROP TABLE IF EXISTS `t_resource_file_copy`;
CREATE TABLE `t_resource_file_copy` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `real_name` varchar(50) DEFAULT NULL COMMENT '存储文件名',
  `upload_name` varchar(150) DEFAULT NULL COMMENT '上传时的文件名',
  `file_type` varchar(10) DEFAULT NULL COMMENT '相关模块',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '相关模块id',
  `upload_time` bigint(19) DEFAULT NULL COMMENT '上传时间',
  `size` int(19) DEFAULT NULL COMMENT '文件大小',
  `upload_user` varchar(32) DEFAULT NULL COMMENT '上传者',
  `view_url` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_resource_region
-- ----------------------------
DROP TABLE IF EXISTS `t_resource_region`;
CREATE TABLE `t_resource_region` (
  `id` varchar(32) NOT NULL DEFAULT '' COMMENT '区域机构代码',
  `name` varchar(50) DEFAULT NULL COMMENT '区域名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_review_mission
-- ----------------------------
DROP TABLE IF EXISTS `t_review_mission`;
CREATE TABLE `t_review_mission` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '计划id',
  `record_id` varchar(32) DEFAULT NULL COMMENT '建议复查时间类型(1:出体检报告后)',
  `recheck_time_type` varchar(32) DEFAULT NULL COMMENT '建议复查时间类型名称',
  `recheck_time_type_name` varchar(32) DEFAULT NULL COMMENT '建议复查时间类型名称',
  `recheck_time_num` varchar(32) DEFAULT NULL COMMENT '建议复查时间天数',
  `recheck_time` varchar(32) DEFAULT NULL COMMENT '建议复查时间',
  `recheck_dept_code` varchar(500) DEFAULT NULL COMMENT '建议复查科室id',
  `recheck_dept_name` varchar(500) DEFAULT NULL COMMENT '建议复查科室名称',
  `recheck_project` varchar(32) DEFAULT NULL COMMENT '建议复查项目',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人ID',
  `creator_name` varchar(32) DEFAULT NULL COMMENT '创建人姓名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='复查计划任务表';

-- ----------------------------
-- Table structure for t_review_plan_record
-- ----------------------------
DROP TABLE IF EXISTS `t_review_plan_record`;
CREATE TABLE `t_review_plan_record` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '患者姓名',
  `pat_phone` varchar(32) DEFAULT NULL COMMENT '患者手机号',
  `creator_id` varchar(32) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `exam_date` varchar(32) NOT NULL COMMENT '体检日期',
  `report_no` varchar(32) NOT NULL COMMENT '体检编号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `head` varchar(32) DEFAULT NULL COMMENT '头像',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='复查计划记录表';

-- ----------------------------
-- Table structure for t_role
-- ----------------------------
DROP TABLE IF EXISTS `t_role`;
CREATE TABLE `t_role` (
  `role_id` varchar(32) NOT NULL,
  `role_name` varchar(64) DEFAULT NULL COMMENT '角色名',
  `hosp_code` varchar(64) DEFAULT NULL COMMENT '医院编码',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- ----------------------------
-- Table structure for t_role_per_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_role_per_relation`;
CREATE TABLE `t_role_per_relation` (
  `id` varchar(32) NOT NULL,
  `role_id` varchar(32) DEFAULT NULL,
  `per_id` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_role_perm
-- ----------------------------
DROP TABLE IF EXISTS `t_role_perm`;
CREATE TABLE `t_role_perm` (
  `id` varchar(32) NOT NULL,
  `role_id` varchar(32) DEFAULT NULL COMMENT '角色主键',
  `perm_code` varchar(64) DEFAULT NULL COMMENT '权限编码',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限表';

-- ----------------------------
-- Table structure for t_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `t_role_permission`;
CREATE TABLE `t_role_permission` (
  `id` varchar(32) NOT NULL COMMENT '主键(permission唯一标识)',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '父节点id',
  `parent_flag` varchar(1) DEFAULT NULL COMMENT '父节点标识(0:否 1:是)',
  `code` varchar(7) DEFAULT NULL COMMENT '权限编码',
  `name` varchar(50) DEFAULT NULL COMMENT '权限名称',
  `description` varchar(100) DEFAULT NULL COMMENT '权限描述',
  `sort_order` int(11) DEFAULT NULL COMMENT '节点排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_satisfaction_dept
-- ----------------------------
DROP TABLE IF EXISTS `t_satisfaction_dept`;
CREATE TABLE `t_satisfaction_dept` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '医院编码',
  `dept_code` varchar(50) NOT NULL COMMENT '科室编码',
  `dept_name` varchar(50) NOT NULL COMMENT '科室名称',
  `parent_dept_code` varchar(50) DEFAULT NULL COMMENT '上级科室编码',
  `parent_dept_name` varchar(50) DEFAULT NULL COMMENT '上级科室名称',
  `pinyin_code` varchar(50) DEFAULT NULL COMMENT '拼音码',
  `ward_flag` int(1) NOT NULL COMMENT '科室病区标志,1科室 2病区',
  `sort_no` int(3) DEFAULT NULL COMMENT '排序号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `belong_type` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='满意度科室表';

-- ----------------------------
-- Table structure for t_satisfaction_qr
-- ----------------------------
DROP TABLE IF EXISTS `t_satisfaction_qr`;
CREATE TABLE `t_satisfaction_qr` (
  `id` varchar(32) NOT NULL,
  `title` varchar(50) NOT NULL COMMENT '标题',
  `form_lib_id` varchar(50) NOT NULL COMMENT '表单库id',
  `pat_source` varchar(10) NOT NULL COMMENT '患者来源 门诊 住院  提交',
  `dept_code` varchar(30) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(30) DEFAULT NULL COMMENT '科室名称',
  `ward_code` varchar(30) DEFAULT NULL COMMENT '病区编码',
  `ward_name` varchar(30) DEFAULT NULL COMMENT '病区名称',
  `opt_id` varchar(32) DEFAULT NULL COMMENT '创建人id（随访用户id）',
  `opt_name` varchar(32) DEFAULT NULL COMMENT '创建人姓名（随访用户姓名）',
  `opt_deptCode` varchar(32) DEFAULT NULL COMMENT '创建人科室代码',
  `url` varchar(200) NOT NULL COMMENT '二维码链接',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `qr_type` int(2) DEFAULT '1' COMMENT '二维码类型 1为满意度  2为随访表单',
  `mandatory` int(2) DEFAULT '1' COMMENT '是否必填 0否 1是',
  `join_form_entry` int(2) DEFAULT '0' COMMENT '否是加入信息录入 0否 1是',
  `is_show_info` tinyint(1) DEFAULT NULL COMMENT '患者信息是否展示 0否 1是',
  `dept_mandatory` tinyint(1) DEFAULT NULL COMMENT '关联科室和病区是否可以让患者选择 0否 1是',
  `resubmit_days` int(11) DEFAULT NULL COMMENT '不能重复提交表单天数',
  `business_source` tinyint(1) DEFAULT '0' COMMENT '随访/慢病系统业务标志 随访：0 慢病：1',
  `dept_belong_type` tinyint(1) unsigned DEFAULT '1',
  `resubmit_cover_answer` tinyint(1) DEFAULT '0' COMMENT '重复提交覆盖答案(0:否;1:是)',
  `resubmit_cover_answer_days` int(11) DEFAULT '0' COMMENT '重复提交覆盖答案天数',
  `dept_must` tinyint(1) DEFAULT '0',
  `ward_must` tinyint(1) DEFAULT '0',
  `ward_mandatory` tinyint(1) DEFAULT NULL,
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联的诊间面访id',
  `auto_sync_form` tinyint(1) DEFAULT '0' COMMENT '扫描二维码的时候是否自动同步表单 0不同步 1同步',
  `relation_plan_id` varchar(3200) DEFAULT NULL COMMENT '关联的计划id',
  `relation_plan_name` varchar(3200) DEFAULT NULL COMMENT '关联的计划name',
  `max_relation_day` tinyint(1) DEFAULT NULL COMMENT '任务关联天数',
  `resubmit_days_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '不可重复提交时间类型（1：按24小时，2：按自然日）',
  `description` varchar(255) DEFAULT NULL COMMENT '标题',
  `visit_rang_days` int(11) DEFAULT NULL COMMENT '调查就诊范围天数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='满意度二维码表';

-- ----------------------------
-- Table structure for t_satisfaction_qr_link
-- ----------------------------
DROP TABLE IF EXISTS `t_satisfaction_qr_link`;
CREATE TABLE `t_satisfaction_qr_link` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `url` varchar(255) NOT NULL COMMENT '满意度调查链接地址',
  `create_user_id` varchar(32) NOT NULL COMMENT '创建人ID',
  `create_user_name` varchar(32) NOT NULL COMMENT '创建人姓名',
  `update_user_id` varchar(32) NOT NULL COMMENT '更新人ID',
  `update_user_name` varchar(32) NOT NULL COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `title` varchar(128) DEFAULT NULL COMMENT '标题',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='满意度调查链接配置';

-- ----------------------------
-- Table structure for t_satisfaction_qr_link_belong_type
-- ----------------------------
DROP TABLE IF EXISTS `t_satisfaction_qr_link_belong_type`;
CREATE TABLE `t_satisfaction_qr_link_belong_type` (
  `id` varchar(32) NOT NULL,
  `qr_link_id` varchar(32) NOT NULL COMMENT '满意度调查链接配置ID',
  `qr_link_title_id` varchar(32) NOT NULL COMMENT '计划二维码满意度标题配置ID',
  `belong_type` int(11) NOT NULL COMMENT '所属科室类别',
  `belong_type_name` varchar(64) NOT NULL COMMENT '所属科室类别名称',
  `sort_no` int(11) NOT NULL COMMENT '排序号',
  PRIMARY KEY (`id`),
  KEY `idx_qr_link_id` (`qr_link_id`),
  KEY `idx_qr_link_title_id` (`qr_link_title_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='计划二维码满意度所属类别';

-- ----------------------------
-- Table structure for t_satisfaction_qr_link_title
-- ----------------------------
DROP TABLE IF EXISTS `t_satisfaction_qr_link_title`;
CREATE TABLE `t_satisfaction_qr_link_title` (
  `id` varchar(32) NOT NULL,
  `qr_link_id` varchar(32) NOT NULL COMMENT '满意度调查链接配置ID',
  `satisfaction_qr_id` varchar(32) NOT NULL COMMENT '计划二维码配置ID',
  `satisfaction_qr_title` varchar(64) NOT NULL COMMENT '计划二维码配置标题',
  `sort_no` int(11) NOT NULL COMMENT '排序号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='计划二维码满意度标题配置';

-- ----------------------------
-- Table structure for t_scheduling
-- ----------------------------
DROP TABLE IF EXISTS `t_scheduling`;
CREATE TABLE `t_scheduling` (
  `id` varchar(32) NOT NULL COMMENT '排班Id',
  `total_no` bigint(10) DEFAULT NULL COMMENT '可分配挂号名额数',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `reg_fee` decimal(9,2) DEFAULT NULL COMMENT '挂号费用',
  `day_type` tinyint(2) DEFAULT NULL COMMENT '上下午标识 1上午2下午3晚上',
  `sch_date` varchar(32) DEFAULT NULL COMMENT '排班日期 YYYY-MM-DD',
  `start_time` varchar(32) DEFAULT NULL COMMENT '开始时间 HH:mm',
  `end_time` varchar(32) DEFAULT NULL COMMENT '结束时间 HH:mm',
  `status` tinyint(2) DEFAULT NULL COMMENT '状态：冻结(0)，有效(1)，撤销(2)，删除(-1)等',
  `sch_code` varchar(64) NOT NULL COMMENT '对接排班ID',
  `clinic_addr` varchar(64) DEFAULT NULL COMMENT '就诊地址',
  `num_src_type` tinyint(2) DEFAULT NULL COMMENT '排班号源类型: 0无需号源/不支持号源  1序号 2时间段 3序号+时间段  4时间点',
  `create_time` bigint(19) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(19) DEFAULT NULL COMMENT '更新时间',
  `staff_code` varchar(32) DEFAULT NULL COMMENT '医生code',
  `dept_code` varchar(32) NOT NULL COMMENT '科室code',
  PRIMARY KEY (`id`),
  UNIQUE KEY `scheduling_index` (`hosp_code`,`sch_code`,`sch_date`),
  KEY `dept_code` (`dept_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='排班信息';

-- ----------------------------
-- Table structure for t_shrj_satisfaction_warning
-- ----------------------------
DROP TABLE IF EXISTS `t_shrj_satisfaction_warning`;
CREATE TABLE `t_shrj_satisfaction_warning` (
  `id` char(32) NOT NULL,
  `hosp_code` varchar(64) DEFAULT NULL COMMENT '医院编码',
  `warning_type` tinyint(4) DEFAULT NULL COMMENT '预警类型 回信率预警：1，日常预警：2',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联ID，随访t_shrj_satisfaction_warning_user中的ID',
  `record_id` varchar(32) DEFAULT NULL COMMENT '关联ID，随访t_shrj_satisfaction_warning_record中的ID',
  `batch_id` varchar(32) NOT NULL COMMENT '预警批次ID',
  `admin_user_id` varchar(32) DEFAULT NULL COMMENT '管理员ID',
  `admin_user_name` varchar(64) DEFAULT NULL COMMENT '管理员姓名',
  `admin_staff_code` varchar(32) DEFAULT NULL COMMENT '管理员职工工号',
  `mobile_no` varchar(32) DEFAULT NULL COMMENT '手机号',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='上海瑞金满意度预警';

-- ----------------------------
-- Table structure for t_shuliao_app_user
-- ----------------------------
DROP TABLE IF EXISTS `t_shuliao_app_user`;
CREATE TABLE `t_shuliao_app_user` (
  `id` bigint(20) NOT NULL,
  `open_id` varchar(32) NOT NULL COMMENT '小程序openid',
  `union_id` varchar(32) NOT NULL COMMENT '开放平台的唯一标识',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `unique_sign` (`open_id`,`union_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数疗小程序用户表';

-- ----------------------------
-- Table structure for t_shuliao_login
-- ----------------------------
DROP TABLE IF EXISTS `t_shuliao_login`;
CREATE TABLE `t_shuliao_login` (
  `id` varchar(32) NOT NULL,
  `login_from` int(3) NOT NULL COMMENT '登陆来源 1:pc 2:wechat',
  `is_login` int(3) NOT NULL DEFAULT '1' COMMENT '登陆状态 0:登出 1:登陆',
  `user_id` varchar(32) NOT NULL COMMENT '用户id',
  `open_id` varchar(512) DEFAULT NULL COMMENT '微信openId',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `classify_id` int(20) DEFAULT '1000' COMMENT '对应微信的账号',
  `hosp_code` varchar(200) DEFAULT NULL COMMENT '医院编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数疗登陆表';

-- ----------------------------
-- Table structure for t_shuliao_user
-- ----------------------------
DROP TABLE IF EXISTS `t_shuliao_user`;
CREATE TABLE `t_shuliao_user` (
  `id` varchar(64) CHARACTER SET utf8mb4 NOT NULL COMMENT '主键id',
  `open_id` varchar(128) DEFAULT NULL COMMENT '微信openId',
  `union_id` varchar(128) DEFAULT NULL COMMENT '微信体系唯一标识',
  `head` varchar(1024) DEFAULT NULL COMMENT '头像',
  `nick` varchar(1024) DEFAULT NULL COMMENT '昵称',
  `first_channel` varchar(64) DEFAULT NULL COMMENT '来源渠道1',
  `second_channel` varchar(64) DEFAULT NULL COMMENT '来源渠道2',
  `phone` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '手机号',
  `name` varchar(1024) DEFAULT NULL COMMENT '姓名',
  `card` varchar(32) DEFAULT NULL COMMENT '身份证',
  `create_time` varchar(64) DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(64) DEFAULT NULL COMMENT '更新时间',
  `is_delete` int(11) DEFAULT '0' COMMENT '是否删除 0未删除，1删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_phone` (`phone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数疗用户表 ';

-- ----------------------------
-- Table structure for t_six_months_record
-- ----------------------------
DROP TABLE IF EXISTS `t_six_months_record`;
CREATE TABLE `t_six_months_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `stand_up_month` int(11) DEFAULT NULL COMMENT '宝宝会翻身月份',
  `start_food_month` int(11) DEFAULT NULL COMMENT '开始添加辅食月',
  `start_food_day` int(11) DEFAULT NULL COMMENT '开始添加辅食天',
  `stand_up_day` int(11) DEFAULT NULL COMMENT '宝宝会翻身日',
  `bady_toy` int(11) DEFAULT NULL COMMENT '为宝宝准备的玩具',
  `bady_often_play_flag` tinyint(1) DEFAULT NULL COMMENT '是否经常与宝宝玩耍',
  `pronunciation_smile_flag` tinyint(1) DEFAULT NULL COMMENT '会发音和笑出声',
  `grab_thing_flag` tinyint(1) DEFAULT NULL COMMENT '会伸手抓物品',
  `clenched_fist_flag` tinyint(1) DEFAULT NULL COMMENT '紧握拳',
  `bady_sit_flag` tinyint(1) DEFAULT NULL COMMENT '能扶坐',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `head_circumference` double DEFAULT NULL COMMENT '头围',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL COMMENT '异常描述',
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL COMMENT '需要关注的事情',
  `next_check_time` varchar(32) DEFAULT NULL COMMENT '下次检查时间',
  `check_unit` varchar(96) DEFAULT NULL COMMENT '检查单位',
  `checker` varchar(976) DEFAULT NULL COMMENT '检查者',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='六个月记录';

-- ----------------------------
-- Table structure for t_six_years_record
-- ----------------------------
DROP TABLE IF EXISTS `t_six_years_record`;
CREATE TABLE `t_six_years_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `help_simple_housework_flag` tinyint(1) DEFAULT NULL COMMENT '帮忙做简单的家务',
  `share_food_elders_flag` tinyint(1) DEFAULT NULL COMMENT '好吃的食物能分享给长辈',
  `game_with_rule_flag` tinyint(1) DEFAULT NULL COMMENT '游戏时能遵守规则或约定',
  `write_own_name_flag` tinyint(1) DEFAULT NULL COMMENT '写自己的名字',
  `express_own_feelings_flag` tinyint(1) DEFAULT NULL COMMENT '表达自己的感受或想法',
  `play_cosplay_game_flag` tinyint(1) DEFAULT NULL COMMENT '玩角色扮演的集体游戏',
  `painting_square_flag` tinyint(1) DEFAULT NULL COMMENT '画方形',
  `run_flag` tinyint(1) DEFAULT NULL COMMENT '单脚跳',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `six_year_old_message` varchar(2048) DEFAULT NULL COMMENT '六岁生日寄语',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `left_eye_vision` double DEFAULT NULL COMMENT '左眼视力',
  `right_eye_vision` double DEFAULT NULL COMMENT '右眼视力',
  `dental_caries_flag` tinyint(1) DEFAULT NULL COMMENT '有龋齿',
  `dental_caries_nums` varchar(11) DEFAULT NULL COMMENT '龋齿颗数',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL COMMENT '异常描述',
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL COMMENT '需要关注的事情',
  `next_check_time` varchar(32) DEFAULT NULL COMMENT '下次检查时间',
  `check_unit` varchar(96) DEFAULT NULL COMMENT '检查单位',
  `checker` varchar(976) DEFAULT NULL COMMENT '检查者',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='六岁记录';

-- ----------------------------
-- Table structure for t_sms_unsubscribe
-- ----------------------------
DROP TABLE IF EXISTS `t_sms_unsubscribe`;
CREATE TABLE `t_sms_unsubscribe` (
  `id` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '退订ID',
  `hosp_code` varchar(100) DEFAULT NULL COMMENT '医院编码',
  `hosp_name` varchar(100) DEFAULT NULL COMMENT '医院',
  `pat_name` varchar(100) DEFAULT NULL COMMENT '姓名',
  `phone` varchar(50) DEFAULT NULL COMMENT '手机号',
  `birth_date` varchar(50) DEFAULT NULL COMMENT '出生年月',
  `sex_code` varchar(50) DEFAULT NULL COMMENT '性别',
  `id_card` varchar(50) DEFAULT NULL COMMENT '身份证',
  `create_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_sms_vcode
-- ----------------------------
DROP TABLE IF EXISTS `t_sms_vcode`;
CREATE TABLE `t_sms_vcode` (
  `id` varchar(32) NOT NULL,
  `phone` varchar(20) NOT NULL COMMENT '手机号',
  `verification_code` varchar(10) NOT NULL COMMENT '验证码',
  `sms_type` int(11) DEFAULT NULL COMMENT '短信类型',
  `send_time` varchar(20) DEFAULT NULL COMMENT '发送时间',
  `send_num` int(11) DEFAULT NULL COMMENT '发送条数',
  `is_used` int(11) DEFAULT '0' COMMENT '是否使用 0否 1是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='短信验证码';

-- ----------------------------
-- Table structure for t_suggestion_category
-- ----------------------------
DROP TABLE IF EXISTS `t_suggestion_category`;
CREATE TABLE `t_suggestion_category` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '医院编码',
  `name` varchar(128) NOT NULL COMMENT '类别名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='建议反馈类型';

-- ----------------------------
-- Table structure for t_suggestion_feedback
-- ----------------------------
DROP TABLE IF EXISTS `t_suggestion_feedback`;
CREATE TABLE `t_suggestion_feedback` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) NOT NULL COMMENT '医院编码',
  `category_name` varchar(128) NOT NULL COMMENT '类别名称',
  `suggestion` text NOT NULL COMMENT '意见',
  `phone` varchar(30) DEFAULT NULL COMMENT '手机号',
  `user_name` varchar(50) DEFAULT NULL COMMENT '姓名',
  `type` int(1) NOT NULL COMMENT '处理标志 1.未处理，2已处理，3无效反馈',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `pat_med_no` varchar(50) DEFAULT NULL COMMENT '病案号',
  `images` varchar(1000) DEFAULT NULL COMMENT '图片地址',
  `operator_id` char(32) DEFAULT NULL COMMENT '操作人id（随访用户id）',
  `operator_name` varchar(20) DEFAULT NULL COMMENT '操作人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='意见反馈';

-- ----------------------------
-- Table structure for t_suggestion_handle_record
-- ----------------------------
DROP TABLE IF EXISTS `t_suggestion_handle_record`;
CREATE TABLE `t_suggestion_handle_record` (
  `id` char(32) NOT NULL,
  `suggestion_id` char(32) DEFAULT NULL COMMENT '意见反馈id',
  `transfer_id` char(32) DEFAULT NULL COMMENT '转交记录id',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '回复人hugId',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '随访账号',
  `name` varchar(32) DEFAULT NULL COMMENT '回复人姓名',
  `dept_code` varchar(64) DEFAULT NULL COMMENT '回复科室代码',
  `dept_name` varchar(64) DEFAULT NULL COMMENT '回复科室名称',
  `remarks` varchar(500) DEFAULT NULL COMMENT '处理备注',
  `hosp_code` varchar(64) DEFAULT NULL COMMENT '组织机构代码',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_handle_record_suggestion_id` (`suggestion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='意见反馈处理表';

-- ----------------------------
-- Table structure for t_suggestion_sms_record
-- ----------------------------
DROP TABLE IF EXISTS `t_suggestion_sms_record`;
CREATE TABLE `t_suggestion_sms_record` (
  `id` varchar(32) NOT NULL,
  `suggestion_id` varchar(32) DEFAULT NULL COMMENT '意见反馈id',
  `transfer_id` char(32) DEFAULT NULL COMMENT '转交记录id',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '回复人hugId',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '随访账号',
  `name` varchar(50) DEFAULT NULL COMMENT '回复人姓名',
  `dept_code` varchar(50) DEFAULT NULL COMMENT '回复科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '回复科室名称',
  `phone` varchar(11) DEFAULT NULL COMMENT '电话',
  `message` varchar(500) DEFAULT NULL COMMENT '短信内容',
  `status` varchar(1) DEFAULT NULL COMMENT '发送状态(0:发送成功，1:发送失败)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` varchar(1) DEFAULT '0' COMMENT '删除标识(0:未删除 ，1:已删除)',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '组织机构代码',
  `pat_name` varchar(50) DEFAULT NULL COMMENT '接收人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='意见反馈短信记录表';

-- ----------------------------
-- Table structure for t_suggestion_transfer_record
-- ----------------------------
DROP TABLE IF EXISTS `t_suggestion_transfer_record`;
CREATE TABLE `t_suggestion_transfer_record` (
  `id` char(32) NOT NULL,
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `suggestion_id` char(32) DEFAULT NULL COMMENT '意见反馈id',
  `transfer_category_name` varchar(128) DEFAULT NULL COMMENT '转交类别名称',
  `transfer_id` varchar(32) DEFAULT NULL COMMENT '转交人id',
  `transfer_name` varchar(20) DEFAULT NULL COMMENT '转交人姓名',
  `transfer_remark` varchar(500) DEFAULT NULL COMMENT '转交备注',
  `transfer_time` datetime DEFAULT NULL COMMENT '转交时间',
  `transfer_status` tinyint(4) DEFAULT '1' COMMENT '转交状态 1未处理 2已处理 3已回复 默认1',
  `is_delete` tinyint(4) DEFAULT '0' COMMENT '是否删除 0否 1是 默认0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `handle_id` varchar(32) DEFAULT NULL COMMENT '处理人id',
  `handle_name` varchar(20) DEFAULT NULL COMMENT '处理人姓名',
  `handle_time` datetime DEFAULT NULL COMMENT '处理时间',
  `is_revoke` tinyint(4) DEFAULT '0' COMMENT '是否撤销 0否 1是 默认0',
  `revoke_id` varchar(32) DEFAULT NULL COMMENT '撤销人id',
  `revoke_name` varchar(20) DEFAULT NULL COMMENT '撤销人姓名',
  `revoke_time` datetime DEFAULT NULL COMMENT '撤销时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='意见反馈--转交记录表';

-- ----------------------------
-- Table structure for t_surgery_exam_report
-- ----------------------------
DROP TABLE IF EXISTS `t_surgery_exam_report`;
CREATE TABLE `t_surgery_exam_report` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `name` varchar(10) DEFAULT NULL COMMENT '患者姓名',
  `sex` tinyint(4) DEFAULT NULL COMMENT '性别',
  `age` tinyint(4) DEFAULT NULL COMMENT '年龄',
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '医院机构编码',
  `surgery_name` varchar(30) DEFAULT NULL COMMENT '手术名称',
  `register_time` datetime DEFAULT NULL COMMENT '手术预约日期',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联id',
  `url` varchar(255) DEFAULT NULL COMMENT '短链接',
  `exam_report_json` varchar(2000) DEFAULT NULL COMMENT '检查报告json串',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邵逸夫 手术患者检查报告 ';

-- ----------------------------
-- Table structure for t_sweet_time
-- ----------------------------
DROP TABLE IF EXISTS `t_sweet_time`;
CREATE TABLE `t_sweet_time` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `mother_tobe_record_time` date DEFAULT NULL COMMENT '第一次听到当妈妈日期',
  `mother_tobe_mood_record` varchar(2000) DEFAULT NULL COMMENT '第一次听到当妈妈心情记录',
  `fetalmovement_heart_first_time` date DEFAULT NULL COMMENT '第一次听到胎心日期',
  `fetalmovement_heart_first_mood_record` varchar(2000) DEFAULT NULL COMMENT '第一次听到胎心音心情记录',
  `fetalmovement_feel_first_time` date DEFAULT NULL COMMENT '第一次感觉到胎动日期',
  `fetalmovement_feel_first_mood_record` varchar(2000) DEFAULT NULL COMMENT '第一次感觉胎动的心情记录',
  `health_book_id` varchar(32) NOT NULL COMMENT '所属健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_task_logs
-- ----------------------------
DROP TABLE IF EXISTS `t_task_logs`;
CREATE TABLE `t_task_logs` (
  `id` varchar(32) NOT NULL,
  `task_type` int(2) DEFAULT NULL COMMENT '定时器类型 1科室 2医生 3排班',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `task_time` datetime DEFAULT NULL COMMENT '定时器时间',
  `success_flag` int(1) DEFAULT '1' COMMENT '成功标识 0不成功 1成功',
  `error_message` varchar(256) DEFAULT NULL COMMENT '失败信息',
  `manual_execution_result` int(1) DEFAULT NULL COMMENT '手动执行结果 0不成功 1成功',
  `manual_execution_time` datetime DEFAULT NULL COMMENT '手动执行时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`),
  KEY `idx_hospcode_tasktype_tasktime` (`hosp_code`,`task_type`,`task_time`) COMMENT 'create by DAS-660b06b8-7cf4-4659-a7fd-a3162a32b369-0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='定时器日志';

-- ----------------------------
-- Table structure for t_team_members
-- ----------------------------
DROP TABLE IF EXISTS `t_team_members`;
CREATE TABLE `t_team_members` (
  `id` varchar(100) DEFAULT NULL COMMENT '主键ID',
  `team_id` varchar(100) DEFAULT NULL COMMENT '团队ID',
  `hug_id` varchar(255) DEFAULT NULL COMMENT '成员hug_id',
  `member_name` varchar(255) DEFAULT NULL COMMENT '成员姓名',
  `type` int(11) DEFAULT NULL COMMENT '成员类别',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `is_delete` int(11) DEFAULT NULL COMMENT '删除 0:未删除 1:已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队成员列表';

-- ----------------------------
-- Table structure for t_three_months_record
-- ----------------------------
DROP TABLE IF EXISTS `t_three_months_record`;
CREATE TABLE `t_three_months_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `feeding_way` int(11) DEFAULT NULL COMMENT '喂养方式',
  `milk_status_flag` tinyint(1) DEFAULT NULL COMMENT '吃奶情况怎么样',
  `vitamin_d_or_ad_flag` tinyint(1) DEFAULT NULL COMMENT '补维生素D或AD',
  `bady_talk_flag` tinyint(1) DEFAULT NULL COMMENT '是否经常和宝宝说话',
  `outdoor_activities_flag` double DEFAULT NULL COMMENT '每天户外活动时间',
  `great_sound_reaction_flag` tinyint(1) DEFAULT NULL COMMENT '对很大声音有反应',
  `pronunciation_smile_flag` tinyint(1) DEFAULT NULL COMMENT '逗引时发音或微笑吗',
  `look_face_track_moving_flag` tinyint(1) DEFAULT NULL COMMENT '会注视人脸或追视移动的人吗',
  `prone_rise_head_flag` tinyint(1) DEFAULT NULL COMMENT '俯卧位时会抬头吗',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `head_circumference` double DEFAULT NULL COMMENT '头围',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL,
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL,
  `next_check_time` varchar(32) DEFAULT NULL,
  `check_unit` varchar(96) DEFAULT NULL,
  `checker` varchar(976) DEFAULT NULL,
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='三个月记录';

-- ----------------------------
-- Table structure for t_three_years_record
-- ----------------------------
DROP TABLE IF EXISTS `t_three_years_record`;
CREATE TABLE `t_three_years_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `kindergarten` int(11) DEFAULT NULL COMMENT '入幼儿园了',
  `eat_chew_habit_flag` tinyint(1) DEFAULT NULL COMMENT '吃东西时有细嚼的习惯',
  `brush_tteeth_habit_flag` tinyint(1) DEFAULT NULL COMMENT '每天晚上睡前刷牙',
  `wash_before_meals_flag` tinyint(1) DEFAULT NULL COMMENT '每天饭前洗手',
  `squint_close_watch_flag` tinyint(1) DEFAULT NULL COMMENT '看东西时眯眼或靠的很近',
  `speak_own_name_flag` tinyint(1) DEFAULT NULL COMMENT '会说自己的名字',
  `play_stick_game_flag` tinyint(1) DEFAULT NULL COMMENT '会玩“拿棍当马骑”等假想游戏',
  `mock_painting_circle_flag` tinyint(1) DEFAULT NULL COMMENT '会模仿画圆吗',
  `jump_both_feet_flag` tinyint(1) DEFAULT NULL COMMENT '会双脚跳吗',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `three_year_old_message` varchar(2048) DEFAULT NULL COMMENT '三岁生日寄语',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `dental_caries_flag` tinyint(1) DEFAULT NULL COMMENT '有龋齿',
  `dental_caries_nums` varchar(11) DEFAULT NULL COMMENT '龋齿颗数',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL COMMENT '异常描述',
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL COMMENT '需要关注的事情',
  `next_check_time` varchar(32) DEFAULT NULL COMMENT '下次检查时间',
  `check_unit` varchar(96) DEFAULT NULL COMMENT '检查单位',
  `checker` varchar(976) DEFAULT NULL COMMENT '检查者',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='三岁记录';

-- ----------------------------
-- Table structure for t_topic
-- ----------------------------
DROP TABLE IF EXISTS `t_topic`;
CREATE TABLE `t_topic` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `name` varchar(50) DEFAULT NULL,
  `type` int(1) DEFAULT NULL,
  `parent_id` varchar(32) DEFAULT NULL,
  `is_default` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_topic_order
-- ----------------------------
DROP TABLE IF EXISTS `t_topic_order`;
CREATE TABLE `t_topic_order` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '医院代码',
  `order` text COMMENT '排序json(大类数组中包含小类数组)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_two_years_record
-- ----------------------------
DROP TABLE IF EXISTS `t_two_years_record`;
CREATE TABLE `t_two_years_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `milk_amount` int(11) DEFAULT NULL COMMENT '每天吃乳类的量',
  `meat_times` int(11) DEFAULT NULL COMMENT '每天吃肉的次数',
  `eat_vegetables_flag` tinyint(1) DEFAULT NULL COMMENT '每天吃蔬菜',
  `gargle_after_dinner_flag` tinyint(1) DEFAULT NULL COMMENT '饭后漱口',
  `teach_painting_flag` tinyint(1) DEFAULT NULL COMMENT '教孩子握笔画画玩儿',
  `say_three_items_flag` tinyint(1) DEFAULT NULL COMMENT '会说3个物品的名称',
  `follow_order_simple_flag` tinyint(1) DEFAULT NULL COMMENT '会按吩咐做简单的事情',
  `eat_with_spoon_flag` tinyint(1) DEFAULT NULL COMMENT '用勺吃饭',
  `handrail_stairs_steps_flag` tinyint(1) DEFAULT NULL COMMENT '扶栏上楼梯或台阶',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `two_year_old_message` varchar(2048) DEFAULT NULL COMMENT '二岁生日寄语',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL,
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL,
  `next_check_time` varchar(32) DEFAULT NULL,
  `check_unit` varchar(96) DEFAULT NULL,
  `checker` varchar(976) DEFAULT NULL,
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='二岁记录';

-- ----------------------------
-- Table structure for t_two_years_six_months_record
-- ----------------------------
DROP TABLE IF EXISTS `t_two_years_six_months_record`;
CREATE TABLE `t_two_years_six_months_record` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `picky_eaters_habit_flag` tinyint(1) DEFAULT NULL COMMENT '偏食、挑食的习惯吗',
  `picky_eaters_reason` varchar(2048) DEFAULT NULL COMMENT '为什么偏食挑食',
  `teeth_nums` int(11) DEFAULT NULL COMMENT '出牙数量',
  `say_body_parts` int(11) DEFAULT NULL COMMENT '能说出的身体部位的数量',
  `watch_picture_book_flag` tinyint(1) DEFAULT NULL COMMENT '经常给宝宝看图画书吗',
  `say_phrasesflag` tinyint(1) DEFAULT NULL COMMENT '会说2-3个字的短语',
  `single_rigid_interest_flag` tinyint(1) DEFAULT NULL COMMENT '兴趣单一、刻板',
  `declare_stool_piss_flag` tinyint(1) DEFAULT NULL COMMENT '示意大小便',
  `run_flag` tinyint(1) DEFAULT NULL COMMENT '会跑',
  `record_feel` varchar(2048) DEFAULT NULL COMMENT '育儿感想',
  `check_time` varchar(32) DEFAULT NULL COMMENT '检查日期',
  `weight` double DEFAULT NULL COMMENT '体重',
  `height` double DEFAULT NULL COMMENT '身长',
  `hemoglobin` double DEFAULT NULL COMMENT '血红蛋白',
  `check_result_flag` tinyint(1) DEFAULT NULL COMMENT '检查结果',
  `abnormal_description` varchar(960) DEFAULT NULL COMMENT '异常描述',
  `referral_flag` tinyint(1) DEFAULT NULL COMMENT '有无转诊',
  `attention_thing` varchar(2048) DEFAULT NULL COMMENT '需要关注的事情',
  `next_check_time` varchar(32) DEFAULT NULL COMMENT '下次检查时间',
  `check_unit` varchar(96) DEFAULT NULL COMMENT '检查单位',
  `checker` varchar(976) DEFAULT NULL COMMENT '检查者',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='二岁六个月记录';

-- ----------------------------
-- Table structure for t_unsigned_group_user
-- ----------------------------
DROP TABLE IF EXISTS `t_unsigned_group_user`;
CREATE TABLE `t_unsigned_group_user` (
  `id` varchar(32) NOT NULL,
  `group_id` varchar(32) NOT NULL COMMENT '群聊id',
  `user_nick_name` varchar(50) DEFAULT NULL COMMENT '昵称',
  `user_empid` varchar(50) DEFAULT NULL COMMENT '患者主索引号',
  `user_hug_id` varchar(50) DEFAULT NULL COMMENT '蓝牛号',
  `user_role` int(1) DEFAULT NULL COMMENT '用户角色',
  `phone` varchar(18) DEFAULT NULL COMMENT '手机号',
  `idcard` varchar(18) DEFAULT NULL COMMENT '身份证',
  `voip_amount` varchar(50) DEFAULT NULL COMMENT '云通讯账号',
  `sex` int(1) DEFAULT NULL COMMENT '性别',
  `user_type` int(1) NOT NULL COMMENT '患者医生标志, 0 患者 3 医生',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `back_time` timestamp NULL DEFAULT NULL COMMENT '退群时间',
  `machine_code` varchar(200) DEFAULT NULL COMMENT '机器码',
  `im_push_flag` int(1) DEFAULT '1' COMMENT '是否推送消息 1是 2否',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='群聊用户表(未注册蓝牛账号)  ';

-- ----------------------------
-- Table structure for t_url_redirect
-- ----------------------------
DROP TABLE IF EXISTS `t_url_redirect`;
CREATE TABLE `t_url_redirect` (
  `serial_no` varchar(32) DEFAULT NULL COMMENT '流水号',
  `hosp_code` varchar(15) DEFAULT NULL COMMENT '医院机构代码',
  `url` varchar(50) DEFAULT NULL COMMENT '重定向地址'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='根据流水号重定向url表';

-- ----------------------------
-- Table structure for t_url_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_url_relation`;
CREATE TABLE `t_url_relation` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(15) NOT NULL COMMENT '医院代码',
  `relation_type` int(2) DEFAULT NULL COMMENT '关联类型(1:投诉表扬)',
  `relation_id` varchar(32) DEFAULT NULL COMMENT '关联id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `detail_id` varchar(32) DEFAULT NULL COMMENT '详情id,邵逸夫投诉表扬单独流程',
  `read_only_flag` tinyint(1) DEFAULT NULL COMMENT '只读标识, 0:否 1:是',
  `content` longtext COMMENT '内容json',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='跳转短链接关联表';

-- ----------------------------
-- Table structure for t_user_address_auth
-- ----------------------------
DROP TABLE IF EXISTS `t_user_address_auth`;
CREATE TABLE `t_user_address_auth` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `patient_hug_id` varchar(50) DEFAULT NULL,
  `dr_hug_id` varchar(50) DEFAULT NULL,
  `health_auth` int(4) DEFAULT NULL,
  `referral_auth` int(1) DEFAULT NULL,
  `index_no_auth` int(4) DEFAULT NULL,
  `open_indexs` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_address_book
-- ----------------------------
DROP TABLE IF EXISTS `t_user_address_book`;
CREATE TABLE `t_user_address_book` (
  `id` varchar(32) NOT NULL,
  `hg_id` varchar(32) DEFAULT NULL,
  `address_book_hg_id` varchar(32) DEFAULT NULL,
  `alias` varchar(50) DEFAULT NULL COMMENT '别名',
  `time` bigint(19) DEFAULT NULL,
  `is_ban` int(1) DEFAULT NULL COMMENT '是否屏蔽 0 否 1 是',
  `update_time` bigint(20) DEFAULT NULL,
  `is_block` int(1) DEFAULT '0' COMMENT '是否屏蔽',
  `inhosp_no` varchar(50) DEFAULT NULL,
  `free_day` int(8) DEFAULT '0',
  `free_end` bigint(19) DEFAULT '0',
  `type_id` varchar(50) DEFAULT NULL,
  `medical_auth` int(4) DEFAULT '1',
  `health_auth` int(4) DEFAULT '1',
  `referral_auth` int(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_address_type
-- ----------------------------
DROP TABLE IF EXISTS `t_user_address_type`;
CREATE TABLE `t_user_address_type` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `name` varchar(50) DEFAULT NULL,
  `hug_id` varchar(50) DEFAULT NULL,
  `create_time` bigint(19) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_appointment
-- ----------------------------
DROP TABLE IF EXISTS `t_user_appointment`;
CREATE TABLE `t_user_appointment` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院代码',
  `dept_code` varchar(50) DEFAULT NULL COMMENT '科室代码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `age_high` varchar(10) DEFAULT NULL COMMENT '年龄上限',
  `age_low` varchar(10) DEFAULT NULL COMMENT '年龄下限',
  `sex` varchar(1) DEFAULT NULL COMMENT '性别限制 0不限1男2女',
  `sourse_id` varchar(32) DEFAULT NULL COMMENT '随访id',
  `sourse_name` varchar(32) DEFAULT NULL COMMENT '随访名',
  `update_time` varchar(20) DEFAULT NULL COMMENT '编辑时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_user_attention
-- ----------------------------
DROP TABLE IF EXISTS `t_user_attention`;
CREATE TABLE `t_user_attention` (
  `id` varchar(100) DEFAULT NULL COMMENT '主键ID',
  `team_id` varchar(100) DEFAULT NULL COMMENT '团队ID',
  `hug_id` varchar(255) DEFAULT NULL COMMENT '成员hug_id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `focus_on` int(11) DEFAULT NULL COMMENT '是否关注：0 未关注 1已关注',
  `group_id` varchar(32) DEFAULT NULL COMMENT '群聊分组id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队关注列表';

-- ----------------------------
-- Table structure for t_user_cancel
-- ----------------------------
DROP TABLE IF EXISTS `t_user_cancel`;
CREATE TABLE `t_user_cancel` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(32) NOT NULL COMMENT '蓝牛号',
  `cancel_state` int(11) DEFAULT '1' COMMENT '注销状态 1申请中 2注销完成',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者注销';

-- ----------------------------
-- Table structure for t_user_delivery_address
-- ----------------------------
DROP TABLE IF EXISTS `t_user_delivery_address`;
CREATE TABLE `t_user_delivery_address` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(32) NOT NULL COMMENT '蓝牛号',
  `name` varchar(20) NOT NULL COMMENT '姓名',
  `phone` varchar(20) NOT NULL COMMENT '联系方式',
  `province_code` varchar(15) DEFAULT NULL COMMENT '省份code',
  `province_name` varchar(32) DEFAULT NULL COMMENT '省份名称',
  `city_code` varchar(15) DEFAULT NULL COMMENT '市code',
  `city_name` varchar(32) DEFAULT NULL COMMENT '市名称',
  `county_code` varchar(15) DEFAULT NULL COMMENT '县/区code',
  `county_name` varchar(50) DEFAULT NULL COMMENT '县/区名称',
  `street` varchar(32) DEFAULT NULL COMMENT '街道名称',
  `detailed_address` varchar(100) DEFAULT NULL COMMENT '详细地址',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收货地址表';

-- ----------------------------
-- Table structure for t_user_device_id
-- ----------------------------
DROP TABLE IF EXISTS `t_user_device_id`;
CREATE TABLE `t_user_device_id` (
  `hug_id` varchar(50) DEFAULT NULL COMMENT '蓝牛号 蓝牛健康id',
  `patient_id` varchar(50) DEFAULT NULL COMMENT '第三方id',
  `device_type` int(4) DEFAULT NULL COMMENT '设备类型 ',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_user_family
-- ----------------------------
DROP TABLE IF EXISTS `t_user_family`;
CREATE TABLE `t_user_family` (
  `id` varchar(32) NOT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `relation` varchar(1500) DEFAULT NULL COMMENT '关系',
  `name` varchar(50) DEFAULT NULL COMMENT '成员身份证名称',
  `card` varchar(50) DEFAULT NULL COMMENT '身份证',
  `phone` varchar(50) DEFAULT NULL COMMENT '手机号码',
  `sex` int(1) DEFAULT NULL COMMENT '头像id',
  `create_time` bigint(19) DEFAULT NULL,
  `medical_syn_time` bigint(19) DEFAULT '0',
  `address` varchar(500) DEFAULT NULL COMMENT '家庭地址',
  `birth_date` datetime DEFAULT NULL COMMENT '出生日期',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_manage
-- ----------------------------
DROP TABLE IF EXISTS `t_user_manage`;
CREATE TABLE `t_user_manage` (
  `user_id` varchar(32) NOT NULL COMMENT '用户主键',
  `user_name` varchar(32) DEFAULT NULL COMMENT '用户名称',
  `user_pwd` varchar(32) NOT NULL COMMENT '用户密码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `name` varchar(32) DEFAULT NULL COMMENT '姓名',
  `phone` varchar(32) DEFAULT NULL COMMENT '电话',
  `email` varchar(32) DEFAULT NULL COMMENT '邮箱',
  `status` int(1) DEFAULT '1' COMMENT '状态(-1:无效    1：有效)',
  `remarks` varchar(1024) DEFAULT NULL,
  `hosp_code` varchar(20) DEFAULT NULL COMMENT '医院编码',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='蓝牛后台用户';

-- ----------------------------
-- Table structure for t_user_medical_auth
-- ----------------------------
DROP TABLE IF EXISTS `t_user_medical_auth`;
CREATE TABLE `t_user_medical_auth` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `hug_id` varchar(32) DEFAULT NULL,
  `target_hug_id` varchar(32) DEFAULT NULL,
  `index_no_id` varchar(200) DEFAULT NULL,
  `create_time` bigint(19) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for t_user_medical_share
-- ----------------------------
DROP TABLE IF EXISTS `t_user_medical_share`;
CREATE TABLE `t_user_medical_share` (
  `id` varchar(32) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `target_hug_id` varchar(32) DEFAULT NULL,
  `group_id` varchar(32) DEFAULT NULL,
  `index_no_id` varchar(200) DEFAULT NULL,
  `create_time` bigint(19) DEFAULT NULL,
  `is_hidden` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_message
-- ----------------------------
DROP TABLE IF EXISTS `t_user_message`;
CREATE TABLE `t_user_message` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `type` int(11) DEFAULT NULL COMMENT '消息类型 1 普通聊天 2 好友 3 问卷',
  `content` varchar(500) DEFAULT NULL COMMENT '邮件内容',
  `sender` varchar(32) DEFAULT NULL COMMENT '邮件发送者',
  `send_time` bigint(19) DEFAULT NULL COMMENT '邮件发送时间',
  `receiver` varchar(32) DEFAULT NULL COMMENT '邮件接收者',
  `read_time` bigint(19) DEFAULT NULL COMMENT '阅读时间',
  `param1` varchar(50) DEFAULT NULL COMMENT '参数1',
  `param2` varchar(50) DEFAULT NULL COMMENT '参数2',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_patient
-- ----------------------------
DROP TABLE IF EXISTS `t_user_patient`;
CREATE TABLE `t_user_patient` (
  `pat_id` varchar(64) NOT NULL COMMENT '病人信息主键',
  `pat_name` varchar(32) DEFAULT NULL COMMENT '病人名称',
  `id_card` varchar(20) DEFAULT NULL COMMENT '身份证',
  `pat_sex` int(2) DEFAULT NULL COMMENT '性别 1女 2男',
  `mobile_no` varchar(15) DEFAULT NULL COMMENT '手机号',
  `third_pat_id` varchar(64) DEFAULT NULL COMMENT '第三方病人编号',
  `partner_id` varchar(64) DEFAULT NULL COMMENT '合作伙伴编号 如果为蓝牛用户 此处对应hgId',
  `partner_type` int(2) DEFAULT NULL COMMENT '合作伙伴分类 1蓝牛 2天使',
  `status` int(2) DEFAULT NULL COMMENT '0无效1有效',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`pat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_permission
-- ----------------------------
DROP TABLE IF EXISTS `t_user_permission`;
CREATE TABLE `t_user_permission` (
  `per_id` varchar(32) NOT NULL COMMENT '权限主键',
  `parent_id` varchar(32) DEFAULT '' COMMENT '父节点',
  `is_parent` varchar(1) DEFAULT NULL COMMENT '判断节点是否是父节点',
  `per_code` varchar(50) DEFAULT NULL COMMENT '权限编码',
  `per_name` varchar(200) DEFAULT '' COMMENT '权限名称',
  `per_descript` varchar(250) DEFAULT '' COMMENT '权限描述',
  `sort_order` varchar(32) DEFAULT '' COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`per_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色对应权限';

-- ----------------------------
-- Table structure for t_user_permission_bak
-- ----------------------------
DROP TABLE IF EXISTS `t_user_permission_bak`;
CREATE TABLE `t_user_permission_bak` (
  `per_id` varchar(32) NOT NULL COMMENT '权限主键',
  `parent_id` varchar(32) DEFAULT '' COMMENT '父节点',
  `is_parent` varchar(1) DEFAULT NULL COMMENT '判断节点是否是父节点',
  `per_code` varchar(50) DEFAULT NULL COMMENT '权限编码',
  `per_name` varchar(200) DEFAULT '' COMMENT '权限名称',
  `per_descript` varchar(250) DEFAULT '' COMMENT '权限描述',
  `sort_order` varchar(32) DEFAULT '' COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`per_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色对应权限';

-- ----------------------------
-- Table structure for t_user_role
-- ----------------------------
DROP TABLE IF EXISTS `t_user_role`;
CREATE TABLE `t_user_role` (
  `role_id` varchar(32) NOT NULL COMMENT '主键',
  `role_name` varchar(20) DEFAULT NULL COMMENT '角色名',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `remarks` varchar(1024) DEFAULT NULL COMMENT '角色描述',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户权限';

-- ----------------------------
-- Table structure for t_user_role_manage
-- ----------------------------
DROP TABLE IF EXISTS `t_user_role_manage`;
CREATE TABLE `t_user_role_manage` (
  `id` varchar(32) NOT NULL,
  `role_id` varchar(32) DEFAULT NULL,
  `user_id` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_sickness
-- ----------------------------
DROP TABLE IF EXISTS `t_user_sickness`;
CREATE TABLE `t_user_sickness` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `client_id` varchar(50) DEFAULT NULL,
  `mh_type` int(8) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `member_id` varchar(32) DEFAULT NULL,
  `history` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_suggestion
-- ----------------------------
DROP TABLE IF EXISTS `t_user_suggestion`;
CREATE TABLE `t_user_suggestion` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `name` varchar(50) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `suggestion` text,
  `create_time` datetime DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL COMMENT '手机号',
  `type` int(1) DEFAULT NULL COMMENT '建议类型 ',
  `status` int(1) DEFAULT NULL COMMENT '建议状态 1待处理2处理中3已处理4无法处理',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `pics` varchar(2000) DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_sync
-- ----------------------------
DROP TABLE IF EXISTS `t_user_sync`;
CREATE TABLE `t_user_sync` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `sourse` int(4) DEFAULT NULL COMMENT '账号来源',
  `type` int(2) DEFAULT NULL COMMENT '账号类别',
  `sourse_id` varchar(50) DEFAULT NULL COMMENT '来源账号id',
  `hg_id` varchar(32) DEFAULT NULL COMMENT 'hugID',
  `nick` varchar(50) DEFAULT NULL COMMENT '昵称',
  `pwd` varchar(50) DEFAULT NULL COMMENT '密码',
  `check_status` int(2) DEFAULT NULL COMMENT '审核状态',
  `card` varchar(50) DEFAULT NULL COMMENT '身份证号',
  `phone` varchar(30) DEFAULT NULL COMMENT '手机号码',
  `mail` varchar(50) DEFAULT NULL COMMENT '邮件',
  `head` varchar(50) DEFAULT NULL COMMENT '头像id',
  `free_time` int(19) DEFAULT NULL COMMENT '解封时间',
  `name` varchar(50) DEFAULT NULL COMMENT '身份证姓名',
  `sex` int(1) DEFAULT NULL COMMENT '性别',
  `blood_type` varchar(10) DEFAULT NULL COMMENT '血型',
  `validata_code` int(10) DEFAULT NULL COMMENT '临时验证码(手机和邮件使用)',
  `validata_code_time` int(19) DEFAULT NULL COMMENT '验证码有限时间节点',
  `dr_title` varchar(50) DEFAULT NULL COMMENT '医生职称',
  `dr_professional` varchar(30) DEFAULT NULL COMMENT '医生专业',
  `og_code` varchar(50) DEFAULT NULL COMMENT '医院编号',
  `last_medical_syn_time` bigint(19) DEFAULT NULL COMMENT '医疗最近同步时间',
  `last_address_book_syn_time` bigint(19) DEFAULT NULL COMMENT '通讯录最近同步时间',
  `last_sport_syn_time` bigint(19) DEFAULT NULL,
  `create_time` bigint(19) DEFAULT NULL,
  `voip_amount` varchar(50) DEFAULT NULL,
  `voip_pwd` varchar(50) DEFAULT NULL,
  `machine_code` varchar(50) DEFAULT '' COMMENT '机器码',
  `member_time` bigint(40) NOT NULL DEFAULT '0',
  `hosp_code` varchar(50) DEFAULT NULL,
  `dept_name` varchar(50) DEFAULT NULL,
  `checkup_time` bigint(19) DEFAULT '0',
  `no_pass_reason` varchar(500) DEFAULT NULL,
  `ban_time` bigint(19) DEFAULT NULL,
  `dr_code` varchar(50) DEFAULT NULL,
  `money_cash` int(11) DEFAULT '0',
  `money` int(11) DEFAULT '0',
  `card_type` int(2) DEFAULT NULL,
  `bank_card` varchar(100) DEFAULT NULL,
  `bname` varchar(20) DEFAULT NULL,
  `subbranch` varchar(200) DEFAULT NULL,
  `total_money` int(11) DEFAULT '0',
  `default_indexs` text,
  `referral_default` int(1) DEFAULT '0',
  `health_default` int(1) DEFAULT '1',
  `medical_default` int(1) DEFAULT '1',
  `hosp` varchar(100) DEFAULT NULL,
  `verify` int(1) DEFAULT '1',
  `open_free` int(1) DEFAULT '0',
  `open_fee` int(1) DEFAULT '0',
  `free_day` int(11) DEFAULT '0',
  `fee_im` int(11) DEFAULT '0',
  `dept_code` varchar(100) DEFAULT NULL,
  `is_open` int(1) DEFAULT '0',
  `interview_user` varchar(50) DEFAULT NULL,
  `user_flag` int(2) DEFAULT NULL,
  `short_desc` varchar(1000) DEFAULT NULL,
  `last_medical_fresh_time` bigint(19) DEFAULT NULL,
  `version` double(20,0) unsigned DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user_user`;
CREATE TABLE `t_user_user` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `sourse` int(4) DEFAULT NULL COMMENT '账号来源',
  `type` int(2) DEFAULT NULL COMMENT '账号类别 0患者 3医生',
  `sourse_id` varchar(50) DEFAULT NULL COMMENT '来源账号id',
  `hg_id` varchar(32) DEFAULT NULL COMMENT 'hugID',
  `nick` varchar(50) DEFAULT NULL COMMENT '昵称',
  `pwd` varchar(50) DEFAULT NULL COMMENT '密码',
  `check_status` int(2) DEFAULT NULL COMMENT '审核状态 0未认证1认证中2认证失败3认证通过',
  `card` varchar(50) DEFAULT NULL COMMENT '身份证号',
  `birth_date` date DEFAULT NULL COMMENT '生日',
  `phone` varchar(30) DEFAULT NULL COMMENT '手机号码',
  `mail` varchar(50) DEFAULT NULL COMMENT '邮件',
  `head` varchar(1024) DEFAULT NULL,
  `free_time` int(19) DEFAULT NULL COMMENT '解封时间',
  `name` varchar(50) DEFAULT NULL COMMENT '身份证姓名',
  `sex` int(1) DEFAULT NULL COMMENT '性别 1女2男',
  `blood_type` varchar(10) DEFAULT NULL COMMENT '血型',
  `validata_code` int(10) DEFAULT NULL COMMENT '临时验证码(手机和邮件使用)',
  `validata_code_time` int(19) DEFAULT NULL COMMENT '验证码有限时间节点',
  `dr_title` varchar(50) DEFAULT NULL COMMENT '医生职称',
  `dr_professional` varchar(30) DEFAULT NULL COMMENT '医生专业',
  `og_code` varchar(50) DEFAULT NULL COMMENT '医院编号',
  `last_medical_syn_time` bigint(19) DEFAULT NULL COMMENT '医疗最近同步时间',
  `last_address_book_syn_time` bigint(19) DEFAULT NULL COMMENT '通讯录最近同步时间',
  `last_sport_syn_time` bigint(19) DEFAULT NULL,
  `create_time` bigint(19) DEFAULT NULL,
  `voip_amount` varchar(50) DEFAULT NULL COMMENT '云通讯账号',
  `voip_pwd` varchar(50) DEFAULT NULL COMMENT '云通讯密码',
  `machine_code` varchar(500) DEFAULT '' COMMENT '机器码',
  `member_time` bigint(40) NOT NULL DEFAULT '0',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `checkup_time` bigint(19) DEFAULT '0' COMMENT '审核时间',
  `no_pass_reason` varchar(500) DEFAULT NULL COMMENT '审核不通过原因',
  `ban_time` bigint(19) DEFAULT NULL COMMENT '禁止登录到某个时间',
  `dr_code` varchar(50) DEFAULT NULL COMMENT '医生编码',
  `money_cash` int(11) DEFAULT '0' COMMENT '余额+未结算',
  `money` int(11) DEFAULT '0' COMMENT '余额',
  `card_type` int(2) DEFAULT NULL COMMENT '银行卡类型',
  `bank_card` varchar(100) DEFAULT NULL COMMENT '银行卡号',
  `bname` varchar(20) DEFAULT NULL COMMENT '银行开户姓名',
  `subbranch` varchar(200) DEFAULT NULL COMMENT '支行名称',
  `total_money` int(11) DEFAULT '0' COMMENT '总金额',
  `default_indexs` mediumtext COMMENT '开放的病例数据',
  `referral_default` int(1) DEFAULT '0' COMMENT '转介 0关闭 1打开',
  `health_default` int(1) DEFAULT '1' COMMENT '0关闭1打开',
  `medical_default` int(1) DEFAULT '1' COMMENT '0关闭 1所有2医疗数据3自定义',
  `hosp` varchar(100) DEFAULT NULL COMMENT '医院名称',
  `verify` int(1) DEFAULT '1' COMMENT '加好友是否需要认证 0否1是',
  `open_online_consulta` int(1) DEFAULT '1' COMMENT '是否开放在线咨询 0不开放 1开放',
  `open_free` int(1) DEFAULT '0' COMMENT '是否开放免费咨询 0不开放 1开放',
  `open_fee` int(1) DEFAULT '0' COMMENT '是否开放收费咨询 0不开放 1开放',
  `free_day` int(11) DEFAULT '0' COMMENT '免费咨询天数',
  `fee_im` int(11) DEFAULT '0' COMMENT '收费咨询价格',
  `dept_code` varchar(100) DEFAULT NULL COMMENT '科室编码',
  `is_open` int(1) DEFAULT '0',
  `interview_user` varchar(50) DEFAULT NULL COMMENT '随访账号',
  `user_flag` int(2) DEFAULT NULL COMMENT '用户标识（1医生；0护士）',
  `short_desc` varchar(1000) DEFAULT NULL COMMENT '描述',
  `last_medical_fresh_time` bigint(19) DEFAULT NULL,
  `version` double(20,0) unsigned DEFAULT '1',
  `pinyin_code` varchar(20) DEFAULT NULL COMMENT '拼音码',
  `peer_query` int(2) DEFAULT '1' COMMENT '能否被同行查询 0否1是',
  `check_name` varchar(50) DEFAULT NULL COMMENT '审核人',
  `partner_type` varchar(10) DEFAULT NULL COMMENT '客户端类型',
  `key_department_flag` int(1) DEFAULT NULL COMMENT '0非重点科室用户1重点科室用户',
  `dept_desc` text COMMENT '科室介绍',
  `checkup_way` int(1) DEFAULT NULL COMMENT '提交认证方式 1普通认证 2快速认证 3自动认证',
  `role_id` varchar(32) DEFAULT NULL COMMENT '角色主键',
  `online_status` int(11) DEFAULT '1' COMMENT '在线状态 0离线 1在线',
  `region` varchar(50) DEFAULT NULL COMMENT '用户所在区域',
  `address` varchar(200) DEFAULT NULL COMMENT '用户详细地址',
  `is_delete` int(4) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `count_follow` int(11) DEFAULT '0' COMMENT '粉丝数',
  `blue_cow_money` varchar(10) DEFAULT '0' COMMENT '蓝牛币',
  `total_blue_cow_money` varchar(10) DEFAULT '0' COMMENT '总蓝牛币',
  `job_title` int(2) DEFAULT '0' COMMENT '职称 1医生 2主任',
  `money_dept_power` int(2) DEFAULT '0' COMMENT '蓝牛币科室权限 0无权限 1查看科室权限',
  `business_source` int(1) DEFAULT '0' COMMENT '业务来源',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `education_level` int(11) DEFAULT NULL COMMENT '教育程度 1未上过学 2小学 3初中 4高中/中专/技校/职校 5大学及以上 6不清楚',
  `job` varchar(32) DEFAULT NULL COMMENT '职业',
  `marital_status` int(11) DEFAULT NULL COMMENT '婚姻状况 1已婚 2未婚',
  `fertility_status` int(11) DEFAULT NULL COMMENT '生育状况 1未育 2已有一孩 3已有两孩 4已有2个以上孩子',
  `yx_token` varchar(64) DEFAULT NULL COMMENT '网易云信token',
  `user_source_id` varchar(32) DEFAULT NULL COMMENT '关联患者来源id',
  `qw_user_source_id` varchar(32) DEFAULT NULL COMMENT '轻舞小程序关联患者来源id',
  PRIMARY KEY (`id`),
  KEY `index_phone` (`phone`),
  KEY `index_card` (`card`),
  KEY `idx_qw_user_source_id` (`qw_user_source_id`),
  KEY `idx_sourseid_type_isdelete` (`sourse_id`,`type`,`is_delete`) COMMENT 'create by DAS-15b0a626-c0d8-4ec5-8695-e355ae4c7737',
  KEY `idx_hgid_isdelete` (`hg_id`,`is_delete`) COMMENT 'create by DAS-d63796d8-5d78-482b-b2af-cbff047b7838'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='轻舞小程序关联患者来源id';

-- ----------------------------
-- Table structure for t_user_user_copy1
-- ----------------------------
DROP TABLE IF EXISTS `t_user_user_copy1`;
CREATE TABLE `t_user_user_copy1` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `sourse` int(4) DEFAULT NULL COMMENT '账号来源',
  `type` int(2) DEFAULT NULL COMMENT '账号类别 0医生 3患者',
  `sourse_id` varchar(50) DEFAULT NULL COMMENT '来源账号id',
  `hg_id` varchar(32) DEFAULT NULL COMMENT 'hugID',
  `nick` varchar(50) DEFAULT NULL COMMENT '昵称',
  `pwd` varchar(50) DEFAULT NULL COMMENT '密码',
  `check_status` int(2) DEFAULT NULL COMMENT '审核状态 0未认证1认证中2认证失败3认证通过',
  `card` varchar(50) DEFAULT NULL COMMENT '身份证号',
  `birth_date` date DEFAULT NULL COMMENT '生日',
  `phone` varchar(30) DEFAULT NULL COMMENT '手机号码',
  `mail` varchar(50) DEFAULT NULL COMMENT '邮件',
  `head` varchar(1024) DEFAULT NULL,
  `free_time` int(19) DEFAULT NULL COMMENT '解封时间',
  `name` varchar(50) DEFAULT NULL COMMENT '身份证姓名',
  `sex` int(1) DEFAULT NULL COMMENT '性别 1女2男',
  `blood_type` varchar(10) DEFAULT NULL COMMENT '血型',
  `validata_code` int(10) DEFAULT NULL COMMENT '临时验证码(手机和邮件使用)',
  `validata_code_time` int(19) DEFAULT NULL COMMENT '验证码有限时间节点',
  `dr_title` varchar(50) DEFAULT NULL COMMENT '医生职称',
  `dr_professional` varchar(30) DEFAULT NULL COMMENT '医生专业',
  `og_code` varchar(50) DEFAULT NULL COMMENT '医院编号',
  `last_medical_syn_time` bigint(19) DEFAULT NULL COMMENT '医疗最近同步时间',
  `last_address_book_syn_time` bigint(19) DEFAULT NULL COMMENT '通讯录最近同步时间',
  `last_sport_syn_time` bigint(19) DEFAULT NULL,
  `create_time` bigint(19) DEFAULT NULL,
  `voip_amount` varchar(50) DEFAULT NULL COMMENT '云通讯账号',
  `voip_pwd` varchar(50) DEFAULT NULL COMMENT '云通讯密码',
  `machine_code` varchar(500) DEFAULT '' COMMENT '机器码',
  `member_time` bigint(40) NOT NULL DEFAULT '0',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院编码',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `checkup_time` bigint(19) DEFAULT '0' COMMENT '审核时间',
  `no_pass_reason` varchar(500) DEFAULT NULL COMMENT '审核不通过原因',
  `ban_time` bigint(19) DEFAULT NULL COMMENT '禁止登录到某个时间',
  `dr_code` varchar(50) DEFAULT NULL COMMENT '医生编码',
  `money_cash` int(11) DEFAULT '0' COMMENT '余额+未结算',
  `money` int(11) DEFAULT '0' COMMENT '余额',
  `card_type` int(2) DEFAULT NULL COMMENT '银行卡类型',
  `bank_card` varchar(100) DEFAULT NULL COMMENT '银行卡号',
  `bname` varchar(20) DEFAULT NULL COMMENT '银行开户姓名',
  `subbranch` varchar(200) DEFAULT NULL COMMENT '支行名称',
  `total_money` int(11) DEFAULT '0' COMMENT '总金额',
  `default_indexs` mediumtext COMMENT '开放的病例数据',
  `referral_default` int(1) DEFAULT '0' COMMENT '转介 0关闭 1打开',
  `health_default` int(1) DEFAULT '1' COMMENT '0关闭1打开',
  `medical_default` int(1) DEFAULT '1' COMMENT '0关闭 1所有2医疗数据3自定义',
  `hosp` varchar(100) DEFAULT NULL COMMENT '医院名称',
  `verify` int(1) DEFAULT '1' COMMENT '加好友是否需要认证 0否1是',
  `open_free` int(1) DEFAULT '0' COMMENT '是否开放免费咨询 0不开放 1开放',
  `open_fee` int(1) DEFAULT '0' COMMENT '是否开放收费咨询 0不开放 1开放',
  `free_day` int(11) DEFAULT '0' COMMENT '免费咨询天数',
  `fee_im` int(11) DEFAULT '0' COMMENT '收费咨询价格',
  `dept_code` varchar(100) DEFAULT NULL COMMENT '科室编码',
  `is_open` int(1) DEFAULT '0',
  `interview_user` varchar(50) DEFAULT NULL COMMENT '随访账号',
  `user_flag` int(2) DEFAULT NULL COMMENT '用户标识（1医生；0护士）',
  `short_desc` varchar(1000) DEFAULT NULL COMMENT '描述',
  `last_medical_fresh_time` bigint(19) DEFAULT NULL,
  `version` double(20,0) unsigned DEFAULT '1',
  `pinyin_code` varchar(20) DEFAULT NULL COMMENT '拼音码',
  `peer_query` int(2) DEFAULT '1' COMMENT '能否被同行查询 0否1是',
  `check_name` varchar(50) DEFAULT NULL COMMENT '审核人',
  `partner_type` varchar(10) DEFAULT NULL COMMENT '客户端类型',
  `key_department_flag` int(1) DEFAULT NULL COMMENT '0非重点科室用户1重点科室用户',
  `dept_desc` text COMMENT '科室介绍',
  `checkup_way` int(1) DEFAULT NULL COMMENT '提交认证方式 1普通认证 2快速认证 3自动认证',
  `role_id` varchar(32) DEFAULT NULL COMMENT '角色主键',
  `online_status` int(11) DEFAULT '1' COMMENT '在线状态 0离线 1在线',
  `region` varchar(50) DEFAULT NULL COMMENT '用户所在区域',
  `address` varchar(200) DEFAULT NULL COMMENT '用户详细地址',
  `is_delete` int(4) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `count_follow` int(11) DEFAULT '0' COMMENT '粉丝数',
  `blue_cow_money` varchar(10) DEFAULT '0' COMMENT '蓝牛币',
  `total_blue_cow_money` varchar(10) DEFAULT '0' COMMENT '总蓝牛币',
  `job_title` int(2) DEFAULT '0' COMMENT '职称 1医生 2主任',
  `money_dept_power` int(2) DEFAULT '0' COMMENT '蓝牛币科室权限 0无权限 1查看科室权限',
  `business_source` int(1) DEFAULT '0' COMMENT '业务来源',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `index_phone` (`phone`),
  KEY `index_card` (`card`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_user_user_examine_record
-- ----------------------------
DROP TABLE IF EXISTS `t_user_user_examine_record`;
CREATE TABLE `t_user_user_examine_record` (
  `id` varchar(32) NOT NULL,
  `name` varchar(50) DEFAULT NULL COMMENT 'hug用户姓名',
  `phone` varchar(50) DEFAULT NULL COMMENT 'hug用户账号',
  `card` varchar(50) DEFAULT NULL COMMENT 'hug用户身份证',
  `hg_id` varchar(50) DEFAULT NULL COMMENT 'hug用户id',
  `examine_person` varchar(50) DEFAULT NULL COMMENT '审核人',
  `examine_result` varchar(50) DEFAULT NULL COMMENT '审核结果',
  `refuse_reason` text COMMENT '不通过原因',
  `examine_date` datetime DEFAULT NULL COMMENT '审核时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='认证审核记录表';

-- ----------------------------
-- Table structure for t_user_user_system_message_record
-- ----------------------------
DROP TABLE IF EXISTS `t_user_user_system_message_record`;
CREATE TABLE `t_user_user_system_message_record` (
  `id` varchar(32) NOT NULL,
  `type` int(1) DEFAULT NULL COMMENT '1系统消息',
  `content` varchar(1000) DEFAULT NULL COMMENT '发送内容',
  `target_users` text COMMENT '发送用户name',
  `target_hgIds` text COMMENT '发送用户hgId',
  `target_type` int(1) DEFAULT NULL COMMENT '发送用户类型 1全部用户 2全部患者 3全部医生 4自选用户',
  `send_person` varchar(50) DEFAULT NULL COMMENT '发送人',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统消息记录';

-- ----------------------------
-- Table structure for t_vaccine_screening
-- ----------------------------
DROP TABLE IF EXISTS `t_vaccine_screening`;
CREATE TABLE `t_vaccine_screening` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hepatitis_b_vaccine_time` varchar(32) DEFAULT NULL COMMENT '宝宝第一针乙肝疫苗接种时间',
  `bcg_vaccination_time` varchar(32) DEFAULT NULL COMMENT '宝宝卡介苗接种时间',
  `neonatal_screening_flag` tinyint(1) DEFAULT NULL COMMENT '新生儿疾病筛查',
  `hearing_screening_flag` tinyint(1) DEFAULT NULL COMMENT '新生儿听力筛查',
  `parenting_record` varchar(2048) DEFAULT NULL COMMENT '育儿记录',
  `baby_id` varchar(32) NOT NULL COMMENT '宝宝基本信息主键',
  `health_book_id` varchar(32) NOT NULL COMMENT '健康手册主键',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='新生儿早期育儿记录(疫苗与筛选)';

-- ----------------------------
-- Table structure for t_warn_filter
-- ----------------------------
DROP TABLE IF EXISTS `t_warn_filter`;
CREATE TABLE `t_warn_filter` (
  `id` varchar(32) DEFAULT NULL COMMENT '主键id',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '计划id',
  `plan_name` varchar(200) DEFAULT NULL COMMENT '计划名称',
  `deal_date` datetime DEFAULT NULL COMMENT '执行日期',
  `plan_type` tinyint(3) DEFAULT NULL COMMENT '计划类型 1:院级随访 2:满意度 3:宣教 4:专科 5:专病',
  `filter_count` int(10) DEFAULT NULL COMMENT '新增数量',
  `filter_json` longtext COMMENT '筛选条件',
  `creator_dept_code` varchar(50) DEFAULT NULL COMMENT '创建人科室code',
  `creator_dept_name` varchar(50) DEFAULT NULL COMMENT '创建人科室名称',
  `creator_id` varchar(50) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(50) DEFAULT NULL COMMENT '创建人名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动筛选预警';

-- ----------------------------
-- Table structure for t_warn_form_submit
-- ----------------------------
DROP TABLE IF EXISTS `t_warn_form_submit`;
CREATE TABLE `t_warn_form_submit` (
  `id` varchar(32) DEFAULT NULL COMMENT '主键',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '机构名称',
  `failed_count` int(10) DEFAULT NULL COMMENT '失败记录数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  UNIQUE KEY `idx_hosp_code` (`hosp_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='表单答案提交失败预警';

-- ----------------------------
-- Table structure for t_warn_form_submit_copy2
-- ----------------------------
DROP TABLE IF EXISTS `t_warn_form_submit_copy2`;
CREATE TABLE `t_warn_form_submit_copy2` (
  `id` varchar(32) DEFAULT NULL COMMENT '主键',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '机构名称',
  `failed_count` int(10) DEFAULT NULL COMMENT '失败记录数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  KEY `idx_hosp_code` (`hosp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='表单答案提交失败预警';

-- ----------------------------
-- Table structure for t_warn_hidden_plan
-- ----------------------------
DROP TABLE IF EXISTS `t_warn_hidden_plan`;
CREATE TABLE `t_warn_hidden_plan` (
  `id` varchar(32) DEFAULT NULL COMMENT '主键id',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '计划id',
  `warn_type` tinyint(3) DEFAULT NULL COMMENT '预警类型 1:自动筛选预警 2:自动发送预警',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警隐藏计划';

-- ----------------------------
-- Table structure for t_warn_send
-- ----------------------------
DROP TABLE IF EXISTS `t_warn_send`;
CREATE TABLE `t_warn_send` (
  `id` varchar(32) DEFAULT NULL COMMENT '主键id',
  `hosp_code` varchar(30) DEFAULT NULL COMMENT '机构代码',
  `plan_id` varchar(32) DEFAULT NULL COMMENT '计划id',
  `plan_name` varchar(200) DEFAULT NULL COMMENT '计划名称',
  `deal_date` datetime DEFAULT NULL COMMENT '执行日期',
  `plan_type` tinyint(3) DEFAULT NULL COMMENT '计划类型 1:院级随访 2:满意度 3:宣教 4:专科 5:专病',
  `send_count` int(10) DEFAULT NULL COMMENT '实际发送数量',
  `should_send_count` int(10) DEFAULT NULL COMMENT '应发数量',
  `ai_send_count` int(10) DEFAULT NULL COMMENT 'ai发送数量',
  `app_send_count` int(10) DEFAULT NULL COMMENT 'app发送数量',
  `sms_send_count` int(10) DEFAULT NULL COMMENT '短信发送数量',
  `creator_dept_code` varchar(50) DEFAULT NULL COMMENT '创建人科室code',
  `creator_dept_name` varchar(50) DEFAULT NULL COMMENT '创建人科室名称',
  `creator_id` varchar(50) DEFAULT NULL COMMENT '创建人id',
  `creator_name` varchar(50) DEFAULT NULL COMMENT '创建人名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动发送预警';

-- ----------------------------
-- Table structure for t_webpage
-- ----------------------------
DROP TABLE IF EXISTS `t_webpage`;
CREATE TABLE `t_webpage` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院代码',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `url` varchar(256) DEFAULT NULL COMMENT '网址',
  `content` text COMMENT '内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `type` int(1) DEFAULT '1' COMMENT '1普通 2QA',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='网页表';

-- ----------------------------
-- Table structure for t_wechat_app_info
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_app_info`;
CREATE TABLE `t_wechat_app_info` (
  `id` varchar(32) NOT NULL,
  `app_id` varchar(64) NOT NULL COMMENT '小程序appId',
  `app_secret` varchar(64) NOT NULL COMMENT '小程序密钥',
  `app_name` varchar(32) DEFAULT NULL COMMENT '小程序名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `token` varchar(1024) DEFAULT NULL COMMENT '微信验证token',
  `classify_id` int(11) DEFAULT NULL COMMENT '微信账号短id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信小程序信息';

-- ----------------------------
-- Table structure for t_wechat_app_qr_transfer
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_app_qr_transfer`;
CREATE TABLE `t_wechat_app_qr_transfer` (
  `id` varchar(32) NOT NULL,
  `unique_code` varchar(32) DEFAULT NULL COMMENT '记录唯一键（可以根据uniqueCode查询params)',
  `business_params` varchar(255) NOT NULL COMMENT '业务系统参数',
  `oss_url` varchar(200) DEFAULT NULL COMMENT '小程序二维码oss地址',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_code` (`unique_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信小程序二维码请求参数与业务系统参数转换表';

-- ----------------------------
-- Table structure for t_wechat_app_user
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_app_user`;
CREATE TABLE `t_wechat_app_user` (
  `id` varchar(32) NOT NULL,
  `app_name` varchar(32) NOT NULL COMMENT '小程序名称',
  `hug_id` varchar(32) NOT NULL COMMENT '蓝牛号',
  `open_id` varchar(32) NOT NULL COMMENT 'openId',
  `union_id` varchar(32) DEFAULT NULL COMMENT '微信用户唯一号',
  `head_url` varchar(1024) DEFAULT NULL COMMENT '头像url',
  `nick_name` varchar(64) DEFAULT NULL COMMENT '微信昵称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `module` int(11) DEFAULT NULL COMMENT '模块 1智宣教 2医疗服务',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信小程序用户';

-- ----------------------------
-- Table structure for t_wechat_custom_message
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_custom_message`;
CREATE TABLE `t_wechat_custom_message` (
  `id` varchar(32) NOT NULL,
  `message_id` varchar(32) NOT NULL COMMENT '微信消息id 文本消息 事件消息id',
  `msg_type` varchar(16) NOT NULL COMMENT '消息类型，文本为text，图片为image，语音为voice，视频消息为video，音乐消息为music，图文消息（点击跳转到外链）为news，图文消息（点击跳转到图文消息页面）为mpnews，卡券为wxcard，小程序为miniprogrampage',
  `content` varchar(2048) DEFAULT NULL,
  `media_id` varchar(64) DEFAULT NULL COMMENT '发送的图片/语音/视频/图文消息（点击跳转到图文消息页）的媒体ID',
  `thumb_media_id` varchar(64) DEFAULT NULL COMMENT '缩略图/小程序卡片图片的媒体ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信客服消息内容';

-- ----------------------------
-- Table structure for t_wechat_event_message
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_event_message`;
CREATE TABLE `t_wechat_event_message` (
  `id` varchar(32) NOT NULL,
  `identify` varchar(32) NOT NULL COMMENT '标识符',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `event_type` int(11) DEFAULT NULL COMMENT '事件分类 1二维码',
  `events` varchar(64) NOT NULL COMMENT '事件类型 SCAN/SUBSCRIBE/UNSUBSCRIBE/CLICK/VIEW',
  `event_key` varchar(32) DEFAULT NULL COMMENT '事件KEY值',
  `qr_url` varchar(512) DEFAULT NULL COMMENT '二维码图片地址',
  `qr_type` tinyint(1) DEFAULT NULL COMMENT '二维码类型 0：永久，1：临时',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态 0：停用 1：启用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `subscribe_count` int(11) DEFAULT '0' COMMENT '关注数量',
  `scan_count` int(11) DEFAULT '0' COMMENT '扫码数量',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人',
  `use_scene` int(11) DEFAULT '0' COMMENT '使用场景 0公共 1精细化一人一码',
  `hosp_code` varchar(50) DEFAULT NULL COMMENT '医院code',
  `dictionary_code` varchar(50) DEFAULT NULL COMMENT '科室code',
  `hosp_name` varchar(50) DEFAULT NULL COMMENT '医院名称',
  `dictionary_name` varchar(50) DEFAULT NULL COMMENT '科室名称',
  `use_hosp_mobile` varchar(50) DEFAULT NULL COMMENT '是否使用医院号码 0 否 1 是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='事件消息';

-- ----------------------------
-- Table structure for t_wechat_hosp_app_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_hosp_app_relation`;
CREATE TABLE `t_wechat_hosp_app_relation` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `wechat_app_id` varchar(32) NOT NULL COMMENT '小程序id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `patient_type` varchar(32) DEFAULT NULL COMMENT '患者类型 ,分隔',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='医院微信小程序关联';

-- ----------------------------
-- Table structure for t_wechat_hosp_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_hosp_relation`;
CREATE TABLE `t_wechat_hosp_relation` (
  `id` varchar(32) NOT NULL,
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `identify` varchar(32) NOT NULL COMMENT '公众号标识符',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信公众号-医院关系表';

-- ----------------------------
-- Table structure for t_wechat_info
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_info`;
CREATE TABLE `t_wechat_info` (
  `id` varchar(32) NOT NULL,
  `appid` varchar(64) DEFAULT NULL COMMENT '微信appId',
  `secret` varchar(64) DEFAULT NULL COMMENT '微信钥匙',
  `hosp_code` varchar(64) NOT NULL COMMENT '医院编码',
  `status` int(11) DEFAULT NULL COMMENT '状态 0无效1有效',
  `create_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_wechat_pay_info
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_pay_info`;
CREATE TABLE `t_wechat_pay_info` (
  `id` varchar(32) NOT NULL,
  `pay_client_type` int(2) DEFAULT NULL COMMENT '支付客户端类型 1蓝牛 2锦欣 3公众号 4攀枝花(花城健康) 5米易智慧医养',
  `app_id` varchar(32) NOT NULL COMMENT '应用id',
  `mch_id` varchar(32) NOT NULL COMMENT '商户号',
  `wx_key` varchar(32) NOT NULL COMMENT '密钥',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` int(1) DEFAULT '0' COMMENT '删除标识 0未删除1已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信支付信息';

-- ----------------------------
-- Table structure for t_wechat_push_channel_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_push_channel_relation`;
CREATE TABLE `t_wechat_push_channel_relation` (
  `id` varchar(32) NOT NULL,
  `wechat_app_name` varchar(64) NOT NULL COMMENT '小程序名称',
  `wechat_sub_name` varchar(64) NOT NULL COMMENT '微信公众号名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `patient_type` varchar(32) DEFAULT NULL COMMENT '患者类型 ,分隔',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信推送通道关系';

-- ----------------------------
-- Table structure for t_wechat_push_record
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_push_record`;
CREATE TABLE `t_wechat_push_record` (
  `id` varchar(32) NOT NULL,
  `send_from` int(11) NOT NULL COMMENT '消息来源',
  `send_to` int(11) NOT NULL COMMENT '推送目的地',
  `open_id` varchar(64) DEFAULT NULL COMMENT 'openId',
  `template_type` int(11) NOT NULL COMMENT '模板类型',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `push_success` tinyint(1) DEFAULT NULL COMMENT '推送成功 0不成功 1成功',
  `send_content_type` tinyint(1) DEFAULT NULL COMMENT '发送内容类型0：其它 1：表单 2：宣教 3：提醒 4：饮食 5：体重\n            6：血糖 7：反馈回复 8:点评 9:点评待办提醒',
  `template_id` varchar(32) DEFAULT NULL COMMENT '模板主键',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模板主键';

-- ----------------------------
-- Table structure for t_wechat_push_template
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_push_template`;
CREATE TABLE `t_wechat_push_template` (
  `id` varchar(64) NOT NULL COMMENT 'id',
  `classify_id` varchar(64) DEFAULT NULL COMMENT '微信账号分类id',
  `event_key` varchar(32) DEFAULT NULL COMMENT '事件类型 SCAN,SUBSCRIBE,UNSUBSCRIBE',
  `scene_type` varchar(32) DEFAULT NULL COMMENT '场景类型',
  `type` int(11) DEFAULT NULL COMMENT '消息类型 0消息模板,1文本客服消息,2图文客服消息',
  `template_id` varchar(128) DEFAULT NULL COMMENT '消息模板id',
  `title` varchar(1024) DEFAULT NULL COMMENT '消息标题',
  `description` varchar(1024) DEFAULT NULL COMMENT '消息描述',
  `url` varchar(1024) DEFAULT NULL COMMENT '跳转url',
  `picurl` varchar(1024) DEFAULT NULL COMMENT '图片url',
  `content` varchar(3072) DEFAULT NULL COMMENT '消息内容',
  `is_default` int(11) DEFAULT '0' COMMENT '是否默认 1默认',
  `is_delete` int(11) DEFAULT '0' COMMENT '是删除 1删除',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `hosp_code` varchar(128) DEFAULT NULL COMMENT '医院编码',
  `media_id` varchar(32) DEFAULT NULL COMMENT '素材id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=' ';

-- ----------------------------
-- Table structure for t_wechat_qr
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_qr`;
CREATE TABLE `t_wechat_qr` (
  `id` varchar(64) DEFAULT NULL COMMENT 'id',
  `template_id` varchar(128) DEFAULT NULL COMMENT '推送模板id',
  `qr_url` varchar(1024) DEFAULT NULL COMMENT '二维码图片',
  `create_time` varchar(64) DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=' ';

-- ----------------------------
-- Table structure for t_wechat_self_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_self_menu`;
CREATE TABLE `t_wechat_self_menu` (
  `id` varchar(64) NOT NULL COMMENT '自定义菜单表主键',
  `classify_id` varchar(64) NOT NULL COMMENT '微信公众号标识（sl/slfe）',
  `event_key` varchar(32) DEFAULT NULL COMMENT '菜单对应的eventkey',
  `menu_name` varchar(32) NOT NULL COMMENT '菜单名称',
  `menu_type` varchar(32) DEFAULT NULL COMMENT '菜单类型(1 :回复文字消息,2:跳转url ,3:跳转小程序,4.回复图文消息）',
  `pid` varchar(64) DEFAULT NULL COMMENT '父级菜单id（0表示底层菜单）',
  `url` varchar(1024) DEFAULT NULL COMMENT 'view菜单对应的url或者是图片对应的url',
  `media_id` varchar(64) DEFAULT NULL COMMENT '调用新增永久素材接口返回的合法media_id',
  `app_id` varchar(64) DEFAULT NULL COMMENT '小程序的appid',
  `pagepath` varchar(1024) DEFAULT NULL COMMENT '小程序的页面路径',
  `w_order` int(11) DEFAULT NULL COMMENT '从左到右顺序1,2,3',
  `h_order` int(11) DEFAULT NULL COMMENT '从上到下顺序',
  `is_delete` int(4) DEFAULT '0' COMMENT '是否已删除（0：未删除，1：已删除）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信公众号自定义菜单表';

-- ----------------------------
-- Table structure for t_wechat_template
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_template`;
CREATE TABLE `t_wechat_template` (
  `id` varchar(32) NOT NULL,
  `template_id` varchar(64) NOT NULL COMMENT '模板id 去微信找',
  `template_type` int(11) NOT NULL COMMENT '模板类型 1 入院宣教 2出院宣教 3复诊提醒 4随访提醒',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `template_content` varchar(1024) DEFAULT NULL COMMENT '模板内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_wechat_text_message
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_text_message`;
CREATE TABLE `t_wechat_text_message` (
  `id` varchar(32) NOT NULL,
  `identify` varchar(32) NOT NULL COMMENT '标识符',
  `name` varchar(60) NOT NULL COMMENT '名称',
  `keywords` varchar(1024) NOT NULL COMMENT '关键字',
  `reply_method` tinyint(4) NOT NULL COMMENT '回复方式 1回复全部 2随机回复一条',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态 0：停用 1：启用',
  `req_count` int(11) DEFAULT '0' COMMENT '请求人次',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信普通消息';

-- ----------------------------
-- Table structure for t_wechat_user
-- ----------------------------
DROP TABLE IF EXISTS `t_wechat_user`;
CREATE TABLE `t_wechat_user` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院编码',
  `open_id` varchar(32) DEFAULT NULL,
  `hug_id` varchar(32) DEFAULT NULL,
  `status` int(11) DEFAULT NULL COMMENT '状态 0无效1有效',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `mini_open_id` varchar(32) DEFAULT NULL COMMENT '小程序openid',
  `union_id` varchar(32) DEFAULT NULL COMMENT '微信用户唯一号',
  `head_url` varchar(1024) DEFAULT NULL COMMENT '头像url',
  `nick_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '微信昵称',
  `is_subscribe` tinyint(1) DEFAULT '1' COMMENT '是否关注 0-已取关 1-关注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_wework_call_back_info
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_call_back_info`;
CREATE TABLE `t_wework_call_back_info` (
  `id` varchar(32) NOT NULL COMMENT '主键',
  `identify` varchar(32) DEFAULT NULL COMMENT '企业微信主体标识符',
  `user_id` varchar(32) DEFAULT NULL COMMENT '企业微信客服id',
  `event_code` int(11) DEFAULT NULL COMMENT '回调事件code',
  `detail_code` int(11) DEFAULT NULL COMMENT '额外的信息',
  `external_id` varchar(32) DEFAULT NULL COMMENT '外部事件id 客户id/tagId/群id',
  `execution_date` varchar(32) DEFAULT NULL COMMENT '发生日期',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `is_delete` int(11) DEFAULT NULL COMMENT '是否删除 0否 1是',
  `third_id` varchar(32) DEFAULT NULL COMMENT '可能会关联业务的id',
  `xml_json_info` varchar(1024) DEFAULT NULL COMMENT '完成的报文信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='企业微信回调信息表';

-- ----------------------------
-- Table structure for t_wework_contact_way
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_contact_way`;
CREATE TABLE `t_wework_contact_way` (
  `id` bigint(20) NOT NULL,
  `identify` varchar(16) NOT NULL COMMENT '标识符',
  `scene` int(11) NOT NULL COMMENT '场景，1-在小程序中联系，2-通过二维码联系',
  `remark` varchar(128) DEFAULT NULL COMMENT '备注',
  `state` varchar(30) DEFAULT NULL COMMENT '企业自定义的state参数',
  `user_id` varchar(32) NOT NULL COMMENT '使用该联系方式的用户userID',
  `config_id` varchar(32) DEFAULT NULL COMMENT '新增联系方式的配置id',
  `qr_code` varchar(255) DEFAULT NULL COMMENT '联系我二维码链接',
  `expires_in` int(11) DEFAULT NULL COMMENT '二维码有效期，以秒为单位',
  `expires_time` datetime DEFAULT NULL COMMENT '过期时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `hosp_code` varchar(32) DEFAULT NULL COMMENT '医院编码',
  `third_id` varchar(32) DEFAULT NULL COMMENT '第三方主键',
  `qr_code_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '二维码类型  0 临时二维码 1 永久二维码',
  `deptCode` varchar(32) DEFAULT NULL COMMENT '科室代码',
  `deptName` varchar(32) DEFAULT NULL COMMENT '科室名称',
  `hospName` varchar(32) DEFAULT NULL COMMENT '机构名称',
  `dept_code` varchar(32) DEFAULT '' COMMENT '科室代码',
  `dept_name` varchar(32) DEFAULT '' COMMENT '科室名称',
  `hosp_name` varchar(32) DEFAULT '' COMMENT '机构名称',
  `source_type` int(11) DEFAULT NULL COMMENT '创建二维码来源 1:先宣讲后开单',
  `rule_id` varchar(32) DEFAULT NULL COMMENT 't_wework_rule表主键id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企业微信联系我';

-- ----------------------------
-- Table structure for t_wework_external_user
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_external_user`;
CREATE TABLE `t_wework_external_user` (
  `id` bigint(20) NOT NULL,
  `identify` varchar(16) NOT NULL COMMENT '标识符',
  `name` varchar(32) DEFAULT NULL COMMENT '外部联系人的名称',
  `type` int(11) DEFAULT NULL COMMENT '外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户',
  `gender` int(11) DEFAULT NULL COMMENT '外部联系人性别 0-未知 1-男性 2-女性',
  `union_id` varchar(32) DEFAULT NULL COMMENT '外部联系人在微信开放平台的唯一身份标识',
  `user_id` varchar(32) NOT NULL COMMENT '企业成员userid',
  `external_user_id` varchar(32) NOT NULL COMMENT '外部联系人的userid',
  `third_id` varchar(32) DEFAULT NULL COMMENT '第三方服务id',
  `hug_id` varchar(32) DEFAULT NULL COMMENT '蓝牛号',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企业微信客户';

-- ----------------------------
-- Table structure for t_wework_info
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_info`;
CREATE TABLE `t_wework_info` (
  `id` bigint(20) NOT NULL,
  `wework_name` varchar(32) DEFAULT NULL COMMENT '企业微信名称',
  `identify` varchar(16) NOT NULL COMMENT '标识符',
  `corp_id` varchar(32) DEFAULT NULL COMMENT '企业id',
  `permanent_code` varchar(512) DEFAULT NULL COMMENT '企业微信永久授权码',
  `secret` varchar(64) DEFAULT NULL COMMENT '密钥',
  `kh_secret` varchar(64) DEFAULT NULL COMMENT '客户钥匙',
  `kh_token` varchar(32) DEFAULT NULL COMMENT '客户回调token',
  `kh_encoding_aes_key` varchar(64) DEFAULT NULL COMMENT '客户回调密钥',
  `txl_secret` varchar(32) DEFAULT NULL COMMENT '通讯录密钥',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企业微信信息';

-- ----------------------------
-- Table structure for t_wework_msg_consumption
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_msg_consumption`;
CREATE TABLE `t_wework_msg_consumption` (
  `id` bigint(19) NOT NULL,
  `msg_id` varchar(100) NOT NULL COMMENT '规则id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `user_id` varchar(50) NOT NULL DEFAULT '' COMMENT '管理人员id',
  `room_id` varchar(88) NOT NULL DEFAULT '' COMMENT '群聊id',
  `identify` varchar(16) NOT NULL DEFAULT 'sljk' COMMENT '企业微信主体',
  `content` varchar(1024) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '聊天内容',
  `msg_seq` bigint(19) DEFAULT NULL COMMENT '聊天内容',
  `empi_id` varchar(32) DEFAULT NULL COMMENT '患者医院id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='企微消息消费表';

-- ----------------------------
-- Table structure for t_wework_msg_seq
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_msg_seq`;
CREATE TABLE `t_wework_msg_seq` (
  `id` bigint(19) NOT NULL,
  `msg_seq` bigint(19) NOT NULL COMMENT '规则id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `identify` varchar(16) NOT NULL DEFAULT 'sljk' COMMENT '企业微信主体',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='企微消息seq';

-- ----------------------------
-- Table structure for t_wework_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_rule`;
CREATE TABLE `t_wework_rule` (
  `id` varchar(32) NOT NULL,
  `identify` varchar(32) NOT NULL COMMENT '企业微信主体',
  `rule_type` tinyint(1) NOT NULL COMMENT '规则类型 1 欢迎语',
  `rule_name` varchar(200) NOT NULL COMMENT '规则名称',
  `rule_content` varchar(1025) NOT NULL COMMENT '规则内容',
  `rule_status` tinyint(1) NOT NULL COMMENT '规则状态 O 启用 1 停用',
  `hosp_code` varchar(32) NOT NULL COMMENT '医院code',
  `hosp_name` varchar(32) NOT NULL COMMENT '医院名称',
  `class_code` varchar(40) DEFAULT '' COMMENT '科室id',
  `class_name` varchar(40) DEFAULT '' COMMENT '科室',
  `customer_service_id` varchar(32) NOT NULL COMMENT '客服id',
  `customer_service_name` varchar(32) NOT NULL COMMENT '客服名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建人id',
  `update_id` varchar(32) NOT NULL COMMENT '修改人id',
  `create_by` varchar(32) NOT NULL COMMENT '创建人',
  `update_by` varchar(32) NOT NULL COMMENT '修改人',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `doctor_id` varchar(50) NOT NULL DEFAULT '' COMMENT '医生id',
  `doctor_name` varchar(50) NOT NULL DEFAULT '' COMMENT '医生姓名',
  `material_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '物料类型',
  `qr_code_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '二维码类型  0 临时二维码 1 永久二维码',
  `add_qty` int(11) NOT NULL DEFAULT '0' COMMENT '规则使用数',
  `del_qty` int(11) NOT NULL DEFAULT '0' COMMENT '规则删除数',
  `treatment_stage` int(11) DEFAULT NULL COMMENT '诊疗阶段',
  `rule_scene` tinyint(2) NOT NULL DEFAULT '0' COMMENT '适用场景 0 pad  1 私域',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='企业微信规则配置';

-- ----------------------------
-- Table structure for t_wework_rule_file
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_rule_file`;
CREATE TABLE `t_wework_rule_file` (
  `id` varchar(32) NOT NULL,
  `rule_id` varchar(32) NOT NULL COMMENT '规则id',
  `file_type` tinyint(1) NOT NULL COMMENT '文件类型 1 欢迎语',
  `file_name` varchar(200) NOT NULL COMMENT '文件名称',
  `file_sort` tinyint(2) NOT NULL COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `create_id` varchar(32) NOT NULL COMMENT '创建人id',
  `update_id` varchar(32) NOT NULL COMMENT '修改人id',
  `expiration_time` datetime NOT NULL COMMENT '过期时间',
  `file_media` varchar(200) NOT NULL COMMENT '微信素材',
  `file_source` varchar(200) NOT NULL COMMENT '修改人id',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `file_desc` varchar(300) NOT NULL DEFAULT '' COMMENT '运动状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='企业微信规则附件';

-- ----------------------------
-- Table structure for t_wework_rule_used_info
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_rule_used_info`;
CREATE TABLE `t_wework_rule_used_info` (
  `id` varchar(32) NOT NULL,
  `user_id` varchar(32) NOT NULL COMMENT '客服人员',
  `external_user_id` varchar(32) NOT NULL COMMENT '客户id',
  `rule_id` varchar(32) NOT NULL COMMENT '规则id',
  `info_status` tinyint(1) NOT NULL COMMENT '状态 0 新增 1 删除',
  `execution_date` date NOT NULL COMMENT '创建时间',
  `create_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='企业微信规则附件';

-- ----------------------------
-- Table structure for t_wework_tag
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_tag`;
CREATE TABLE `t_wework_tag` (
  `id` varchar(32) NOT NULL,
  `identify` varchar(32) NOT NULL COMMENT '标识符',
  `tag_type` tinyint(3) DEFAULT NULL COMMENT '标签类型 0-机构 1-科室',
  `tag_identify` varchar(32) NOT NULL COMMENT '标签匹配字段 tagType为0-值为机构代码 tagType为1-值为科室代码',
  `group_id` varchar(32) NOT NULL COMMENT '分组id',
  `group_name` varchar(40) NOT NULL COMMENT '分组名称',
  `tag_id` varchar(32) NOT NULL COMMENT '标签id',
  `tag_name` varchar(32) NOT NULL COMMENT '标签名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_wework_user
-- ----------------------------
DROP TABLE IF EXISTS `t_wework_user`;
CREATE TABLE `t_wework_user` (
  `id` varchar(32) NOT NULL,
  `identify` varchar(32) NOT NULL COMMENT '标识符',
  `user_id` varchar(80) DEFAULT NULL COMMENT '企业用户id',
  `user_name` varchar(40) DEFAULT NULL COMMENT '企业用户姓名',
  `is_follow_user` tinyint(1) DEFAULT '0' COMMENT '是否配置客户联系',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_wewrok_empi_ref
-- ----------------------------
DROP TABLE IF EXISTS `t_wewrok_empi_ref`;
CREATE TABLE `t_wewrok_empi_ref` (
  `id` bigint(19) NOT NULL,
  `work_user_id` varchar(32) NOT NULL COMMENT '企业微信userId',
  `empi_id` varchar(32) NOT NULL COMMENT 'empi_id',
  `pat_id` bigint(19) NOT NULL COMMENT 'patId',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标识，0：未删除，1：已删除',
  `hosp_code` varchar(32) NOT NULL DEFAULT '' COMMENT '医院编码',
  `pay_id` varchar(32) NOT NULL DEFAULT '' COMMENT '开单id',
  `identify` varchar(16) NOT NULL DEFAULT 'sljk' COMMENT '企业微信主体',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='企业微信empi映射表';

-- ----------------------------
-- Table structure for t_xinyong_watch_hosp_rel
-- ----------------------------
DROP TABLE IF EXISTS `t_xinyong_watch_hosp_rel`;
CREATE TABLE `t_xinyong_watch_hosp_rel` (
  `id` varchar(32) NOT NULL,
  `watch_id` varchar(128) NOT NULL COMMENT '手表id',
  `hosp_code` varchar(32) NOT NULL COMMENT '机构代码',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除 0-否 1-是',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='心永手表机构关联表';

-- ----------------------------
-- Table structure for t_zxj_wechat_user
-- ----------------------------
DROP TABLE IF EXISTS `t_zxj_wechat_user`;
CREATE TABLE `t_zxj_wechat_user` (
  `id` varchar(50) NOT NULL,
  `open_id` varchar(200) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `in_hospital_num` varchar(80) DEFAULT NULL,
  `bed_num` varchar(80) DEFAULT NULL,
  `create_time` varchar(50) DEFAULT NULL,
  `update_time` varchar(50) DEFAULT NULL,
  `hg_id` varchar(50) DEFAULT NULL,
  `id_card` varchar(50) DEFAULT NULL,
  `source` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Function structure for cal_energy
-- ----------------------------
DROP FUNCTION IF EXISTS `cal_energy`;
delimiter ;;
CREATE FUNCTION `jianhaihug`.`cal_energy`(in_health_value varchar(4096))
 RETURNS double(8,2)
  SQL SECURITY INVOKER
BEGIN
	DECLARE energy DOUBLE(8,2) default 0.0;
	DECLARE health_value VARCHAR(4096);
	DECLARE start_pos INTEGER DEFAULT 0;
	DECLARE end_pos INTEGER DEFAULT 1;
	
	SET health_value = REPLACE(REPLACE(in_health_value,' ',''),'
','');
	-- 循环开始
	REPEAT
		SET start_pos = LOCATE('"energy":"', health_value, end_pos);
		SET end_pos = LOCATE('"', health_value, start_pos + 11);
		SET energy = energy + SUBSTRING(health_value, start_pos + 10, end_pos - start_pos -10);
	UNTIL start_pos = 0 END REPEAT;	
	RETURN energy;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for getPerIds
-- ----------------------------
DROP FUNCTION IF EXISTS `getPerIds`;
delimiter ;;
CREATE FUNCTION `jianhaihug`.`getPerIds`(rootId varchar(225))
 RETURNS varchar(2000) CHARSET utf8mb4
  SQL SECURITY INVOKER
BEGIN
            DECLARE sTemp VARCHAR(2000);
            DECLARE sTempChd VARCHAR(1000);

            SET sTemp = '$';
            SET sTempChd = rootId;

            WHILE sTempChd is not null DO
            SET sTemp = concat(sTemp,',',sTempChd);
            SELECT group_concat(per_id) INTO sTempChd FROM t_user_permission where FIND_IN_SET(parent_id,sTempChd)>0;
            END WHILE;
            RETURN sTemp;
            END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
