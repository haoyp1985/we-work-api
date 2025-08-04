-- =====================================================
-- 健康管理模块数据库设计
-- 包含：患者管理、健康记录、设备管理、健康告警、体检报告
-- =====================================================

-- 创建健康管理模块数据库
CREATE DATABASE IF NOT EXISTS `health_management` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `health_management`;

-- =====================================================
-- 1. 患者管理层
-- =====================================================

-- 患者基本信息表
CREATE TABLE health_patients (
    id VARCHAR(36) PRIMARY KEY COMMENT '患者ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 基本信息
    patient_code VARCHAR(50) NOT NULL COMMENT '患者编号',
    id_card VARCHAR(18) COMMENT '身份证号',
    name VARCHAR(100) NOT NULL COMMENT '姓名',
    gender ENUM('male', 'female', 'other') NOT NULL COMMENT '性别',
    birth_date DATE NOT NULL COMMENT '出生日期',
    age INT GENERATED ALWAYS AS (TIMESTAMPDIFF(YEAR, birth_date, CURDATE())) STORED COMMENT '年龄',
    
    -- 联系信息
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    emergency_contact VARCHAR(100) COMMENT '紧急联系人',
    emergency_phone VARCHAR(20) COMMENT '紧急联系电话',
    
    -- 地址信息
    address JSON COMMENT '地址信息 {province, city, district, detail}',
    
    -- 职业信息
    occupation VARCHAR(100) COMMENT '职业',
    workplace VARCHAR(200) COMMENT '工作单位',
    
    -- 医疗信息
    blood_type ENUM('A', 'B', 'AB', 'O', 'unknown') DEFAULT 'unknown' COMMENT '血型',
    rh_factor ENUM('positive', 'negative', 'unknown') DEFAULT 'unknown' COMMENT 'RH因子',
    allergies JSON COMMENT '过敏史',
    chronic_diseases JSON COMMENT '慢性病史',
    family_medical_history JSON COMMENT '家族病史',
    current_medications JSON COMMENT '当前用药',
    
    -- 身体基本指标
    height DECIMAL(5,2) COMMENT '身高(cm)',
    weight DECIMAL(5,2) COMMENT '体重(kg)',
    bmi DECIMAL(4,1) GENERATED ALWAYS AS (
        CASE 
            WHEN height > 0 THEN ROUND(weight / POW(height/100, 2), 1)
            ELSE NULL 
        END
    ) STORED COMMENT 'BMI指数',
    
    -- 生活习惯
    smoking_status ENUM('never', 'former', 'current') DEFAULT 'never' COMMENT '吸烟状态',
    drinking_status ENUM('never', 'occasional', 'regular', 'heavy') DEFAULT 'never' COMMENT '饮酒状态',
    exercise_frequency ENUM('never', 'rare', 'regular', 'frequent') DEFAULT 'never' COMMENT '运动频率',
    
    -- 状态管理
    status ENUM('active', 'inactive', 'archived', 'deceased') DEFAULT 'active' COMMENT '患者状态',
    registration_source VARCHAR(50) COMMENT '注册来源',
    assigned_doctor_id VARCHAR(36) COMMENT '主治医生ID',
    
    -- 隐私设置
    privacy_level ENUM('public', 'restricted', 'private') DEFAULT 'private' COMMENT '隐私级别',
    data_sharing_consent BOOLEAN DEFAULT FALSE COMMENT '数据共享同意',
    
    -- 统计信息
    total_visits INT DEFAULT 0 COMMENT '总就诊次数',
    total_records INT DEFAULT 0 COMMENT '总健康记录数',
    last_visit_at TIMESTAMP NULL COMMENT '最后就诊时间',
    last_record_at TIMESTAMP NULL COMMENT '最后记录时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    updated_by VARCHAR(36) COMMENT '更新人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_patient_code (tenant_id, patient_code),
    UNIQUE KEY uk_tenant_id_card (tenant_id, id_card),
    
    -- 索引设计
    INDEX idx_name (name),
    INDEX idx_phone (phone),
    INDEX idx_birth_date (birth_date),
    INDEX idx_age (age),
    INDEX idx_status (status),
    INDEX idx_assigned_doctor (assigned_doctor_id),
    INDEX idx_last_visit (last_visit_at),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='患者基本信息表';

-- =====================================================
-- 2. 健康记录层
-- =====================================================

-- 健康记录主表
CREATE TABLE health_records (
    id VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    patient_id VARCHAR(36) NOT NULL COMMENT '患者ID',
    
    -- 记录基本信息
    record_type ENUM(
        'vital_signs', 'blood_test', 'urine_test', 'imaging', 'ecg', 'blood_pressure',
        'blood_sugar', 'temperature', 'weight', 'symptom', 'diagnosis', 'treatment',
        'medication', 'vaccination', 'allergy', 'surgery', 'checkup', 'emergency',
        'chronic_disease', 'mental_health', 'rehabilitation', 'custom'
    ) NOT NULL COMMENT '记录类型',
    record_source ENUM('manual', 'device', 'import', 'api', 'third_party') DEFAULT 'manual' COMMENT '记录来源',
    
    -- 记录内容
    title VARCHAR(200) NOT NULL COMMENT '记录标题',
    description TEXT COMMENT '记录描述',
    
    -- 测量数据 (JSON格式存储各种指标)
    measurements JSON COMMENT '测量数据',
    reference_ranges JSON COMMENT '参考范围',
    
    -- 异常标记
    abnormal_indicators JSON COMMENT '异常指标',
    risk_level ENUM('normal', 'low', 'medium', 'high', 'critical') DEFAULT 'normal' COMMENT '风险级别',
    
    -- 关联信息
    device_id VARCHAR(36) COMMENT '设备ID',
    doctor_id VARCHAR(36) COMMENT '医生ID',
    hospital VARCHAR(200) COMMENT '医院名称',
    department VARCHAR(100) COMMENT '科室',
    
    -- 文件附件
    attachments JSON COMMENT '附件信息 [{file_id, file_name, file_type, file_url}]',
    images JSON COMMENT '图片信息',
    reports JSON COMMENT '报告信息',
    
    -- 时间信息
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
    measured_at TIMESTAMP NULL COMMENT '测量时间',
    
    -- 数据质量
    data_quality ENUM('excellent', 'good', 'fair', 'poor') DEFAULT 'good' COMMENT '数据质量',
    validation_status ENUM('pending', 'validated', 'rejected') DEFAULT 'pending' COMMENT '验证状态',
    validated_by VARCHAR(36) COMMENT '验证人ID',
    validated_at TIMESTAMP NULL COMMENT '验证时间',
    
    -- 隐私标记
    is_sensitive BOOLEAN DEFAULT FALSE COMMENT '是否敏感数据',
    access_level ENUM('public', 'doctor_only', 'restricted', 'private') DEFAULT 'doctor_only' COMMENT '访问级别',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    INDEX idx_tenant_patient (tenant_id, patient_id),
    INDEX idx_record_type (record_type, recorded_at),
    INDEX idx_risk_level (risk_level),
    INDEX idx_recorded_at (recorded_at),
    INDEX idx_measured_at (measured_at),
    INDEX idx_device_id (device_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_validation_status (validation_status),
    
    FOREIGN KEY (patient_id) REFERENCES health_patients(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='健康记录主表';

-- 生命体征记录表 (专门存储生命体征数据)
CREATE TABLE health_vital_signs (
    id VARCHAR(36) PRIMARY KEY COMMENT '记录ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    patient_id VARCHAR(36) NOT NULL COMMENT '患者ID',
    health_record_id VARCHAR(36) COMMENT '健康记录ID',
    
    -- 基本生命体征
    systolic_pressure INT COMMENT '收缩压(mmHg)',
    diastolic_pressure INT COMMENT '舒张压(mmHg)',
    heart_rate INT COMMENT '心率(bpm)',
    respiratory_rate INT COMMENT '呼吸频率(次/分)',
    body_temperature DECIMAL(4,1) COMMENT '体温(°C)',
    oxygen_saturation DECIMAL(5,2) COMMENT '血氧饱和度(%)',
    
    -- 身体测量
    weight DECIMAL(5,2) COMMENT '体重(kg)',
    height DECIMAL(5,2) COMMENT '身高(cm)',
    bmi DECIMAL(4,1) COMMENT 'BMI指数',
    waist_circumference DECIMAL(5,2) COMMENT '腰围(cm)',
    hip_circumference DECIMAL(5,2) COMMENT '臀围(cm)',
    
    -- 血糖相关
    blood_glucose DECIMAL(5,2) COMMENT '血糖(mmol/L)',
    glucose_measurement_time ENUM('fasting', 'before_meal', 'after_meal', 'random', 'bedtime') COMMENT '血糖测量时间',
    
    -- 疼痛评估
    pain_level INT COMMENT '疼痛级别(0-10)',
    pain_location VARCHAR(200) COMMENT '疼痛部位',
    
    -- 测量环境
    measurement_conditions JSON COMMENT '测量条件 {position, activity_level, medication_taken}',
    device_info JSON COMMENT '设备信息',
    
    -- 异常标记
    abnormal_values JSON COMMENT '异常值标记',
    risk_assessment ENUM('normal', 'caution', 'warning', 'critical') DEFAULT 'normal' COMMENT '风险评估',
    
    -- 时间信息
    measured_at TIMESTAMP NOT NULL COMMENT '测量时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    INDEX idx_tenant_patient (tenant_id, patient_id),
    INDEX idx_measured_at (measured_at),
    INDEX idx_blood_pressure (systolic_pressure, diastolic_pressure),
    INDEX idx_heart_rate (heart_rate),
    INDEX idx_temperature (body_temperature),
    INDEX idx_blood_glucose (blood_glucose),
    INDEX idx_risk_assessment (risk_assessment),
    INDEX idx_health_record (health_record_id),
    
    FOREIGN KEY (patient_id) REFERENCES health_patients(id) ON DELETE CASCADE,
    FOREIGN KEY (health_record_id) REFERENCES health_records(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='生命体征记录表';

-- =====================================================
-- 3. 设备管理层
-- =====================================================

-- 健康设备表
CREATE TABLE health_devices (
    id VARCHAR(36) PRIMARY KEY COMMENT '设备ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 设备基本信息
    device_name VARCHAR(100) NOT NULL COMMENT '设备名称',
    device_code VARCHAR(50) NOT NULL COMMENT '设备编号',
    device_type ENUM(
        'blood_pressure', 'blood_glucose', 'thermometer', 'scale', 'heart_rate',
        'oximeter', 'ecg', 'sleep_monitor', 'activity_tracker', 'smart_watch',
        'spirometer', 'glucometer', 'stethoscope', 'ultrasound', 'x_ray', 'custom'
    ) NOT NULL COMMENT '设备类型',
    
    -- 设备详情
    manufacturer VARCHAR(100) COMMENT '制造商',
    model VARCHAR(100) COMMENT '型号',
    serial_number VARCHAR(100) COMMENT '序列号',
    firmware_version VARCHAR(50) COMMENT '固件版本',
    
    -- 设备规格
    specifications JSON COMMENT '设备规格',
    measurement_range JSON COMMENT '测量范围',
    accuracy JSON COMMENT '精度信息',
    supported_metrics JSON COMMENT '支持的测量指标',
    
    -- 连接配置
    connection_type ENUM('bluetooth', 'wifi', 'usb', 'serial', 'manual', 'api') DEFAULT 'manual' COMMENT '连接方式',
    connection_config JSON COMMENT '连接配置',
    api_endpoint VARCHAR(500) COMMENT 'API端点',
    
    -- 设备状态
    status ENUM('active', 'inactive', 'maintenance', 'error', 'offline') DEFAULT 'active' COMMENT '设备状态',
    battery_level INT COMMENT '电池电量(%)',
    signal_strength INT COMMENT '信号强度',
    last_online_at TIMESTAMP NULL COMMENT '最后在线时间',
    
    -- 校准信息
    last_calibration_at TIMESTAMP NULL COMMENT '最后校准时间',
    calibration_interval_days INT DEFAULT 365 COMMENT '校准间隔(天)',
    needs_calibration BOOLEAN GENERATED ALWAYS AS (
        last_calibration_at IS NULL OR 
        last_calibration_at < DATE_SUB(NOW(), INTERVAL calibration_interval_days DAY)
    ) STORED COMMENT '是否需要校准',
    
    -- 维护信息
    maintenance_schedule JSON COMMENT '维护计划',
    warranty_expires_at DATE COMMENT '保修到期日期',
    
    -- 使用统计
    total_measurements BIGINT DEFAULT 0 COMMENT '总测量次数',
    successful_measurements BIGINT DEFAULT 0 COMMENT '成功测量次数',
    error_count INT DEFAULT 0 COMMENT '错误次数',
    last_measurement_at TIMESTAMP NULL COMMENT '最后测量时间',
    
    -- 位置信息
    location JSON COMMENT '设备位置信息',
    assigned_patient_id VARCHAR(36) COMMENT '分配的患者ID',
    assigned_doctor_id VARCHAR(36) COMMENT '负责医生ID',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_device_code (tenant_id, device_code),
    UNIQUE KEY uk_serial_number (serial_number),
    
    -- 索引设计
    INDEX idx_device_type (device_type),
    INDEX idx_status (status),
    INDEX idx_manufacturer (manufacturer),
    INDEX idx_assigned_patient (assigned_patient_id),
    INDEX idx_last_online (last_online_at),
    INDEX idx_needs_calibration (needs_calibration),
    
    FOREIGN KEY (assigned_patient_id) REFERENCES health_patients(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='健康设备表';

-- 设备数据日志表 (分区表)
CREATE TABLE health_device_logs (
    id VARCHAR(36) NOT NULL COMMENT '日志ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    device_id VARCHAR(36) NOT NULL COMMENT '设备ID',
    patient_id VARCHAR(36) COMMENT '患者ID',
    
    -- 数据内容
    log_type ENUM('measurement', 'status', 'error', 'calibration', 'maintenance') NOT NULL COMMENT '日志类型',
    raw_data JSON NOT NULL COMMENT '原始数据',
    processed_data JSON COMMENT '处理后数据',
    
    -- 数据质量
    data_quality ENUM('excellent', 'good', 'fair', 'poor', 'invalid') DEFAULT 'good' COMMENT '数据质量',
    validation_result JSON COMMENT '验证结果',
    
    -- 错误信息
    error_code VARCHAR(50) COMMENT '错误代码',
    error_message TEXT COMMENT '错误信息',
    
    -- 环境信息
    environment_data JSON COMMENT '环境数据(温度、湿度等)',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 复合主键，包含分区键
    PRIMARY KEY (id, created_at),
    
    INDEX idx_tenant_device (tenant_id, device_id),
    INDEX idx_patient_id (patient_id),
    INDEX idx_log_type (log_type),
    INDEX idx_data_quality (data_quality),
    INDEX idx_created_at (created_at),
    
    FOREIGN KEY (device_id) REFERENCES health_devices(id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES health_patients(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备数据日志表'
PARTITION BY RANGE (UNIX_TIMESTAMP(created_at)) (
    PARTITION p202501 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01 00:00:00')),
    PARTITION p202502 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01 00:00:00')),
    PARTITION p202503 VALUES LESS THAN (UNIX_TIMESTAMP('2025-04-01 00:00:00')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- =====================================================
-- 4. 健康告警层
-- =====================================================

-- 健康告警表
CREATE TABLE health_alerts (
    id VARCHAR(36) PRIMARY KEY COMMENT '告警ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    patient_id VARCHAR(36) NOT NULL COMMENT '患者ID',
    
    -- 告警基本信息
    alert_type ENUM(
        'vital_signs_abnormal', 'blood_pressure_high', 'blood_pressure_low',
        'heart_rate_high', 'heart_rate_low', 'temperature_high', 'temperature_low',
        'blood_sugar_high', 'blood_sugar_low', 'oxygen_low', 'weight_change',
        'medication_reminder', 'appointment_reminder', 'device_offline',
        'data_anomaly', 'emergency', 'chronic_disease_alert', 'custom'
    ) NOT NULL COMMENT '告警类型',
    alert_level ENUM('info', 'warning', 'error', 'critical', 'emergency') NOT NULL COMMENT '告警级别',
    
    -- 告警内容
    alert_title VARCHAR(200) NOT NULL COMMENT '告警标题',
    alert_message TEXT NOT NULL COMMENT '告警消息',
    alert_data JSON COMMENT '告警相关数据',
    
    -- 触发信息
    trigger_source ENUM('device', 'manual', 'rule', 'ai_analysis', 'scheduled') NOT NULL COMMENT '触发源',
    trigger_rule_id VARCHAR(36) COMMENT '触发规则ID',
    health_record_id VARCHAR(36) COMMENT '关联健康记录ID',
    device_id VARCHAR(36) COMMENT '关联设备ID',
    
    -- 临床信息
    clinical_significance TEXT COMMENT '临床意义',
    recommended_actions JSON COMMENT '建议措施',
    urgency_level ENUM('immediate', 'urgent', 'routine', 'scheduled') DEFAULT 'routine' COMMENT '紧急程度',
    
    -- 状态管理
    status ENUM('open', 'acknowledged', 'in_progress', 'resolved', 'false_positive', 'suppressed') DEFAULT 'open' COMMENT '告警状态',
    
    -- 时间管理
    triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '触发时间',
    acknowledged_at TIMESTAMP NULL COMMENT '确认时间',
    resolved_at TIMESTAMP NULL COMMENT '解决时间',
    
    -- 处理信息
    acknowledged_by VARCHAR(36) COMMENT '确认人ID',
    resolved_by VARCHAR(36) COMMENT '解决人ID',
    resolution_notes TEXT COMMENT '解决备注',
    follow_up_required BOOLEAN DEFAULT FALSE COMMENT '是否需要随访',
    follow_up_date DATE COMMENT '随访日期',
    
    -- 通知状态
    notification_sent BOOLEAN DEFAULT FALSE COMMENT '是否已发送通知',
    notification_channels JSON COMMENT '通知渠道',
    escalation_level INT DEFAULT 0 COMMENT '升级级别',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_tenant_patient (tenant_id, patient_id),
    INDEX idx_alert_type (alert_type, triggered_at),
    INDEX idx_alert_level (alert_level, status),
    INDEX idx_status (status, triggered_at),
    INDEX idx_urgency_level (urgency_level),
    INDEX idx_trigger_source (trigger_source),
    INDEX idx_health_record (health_record_id),
    INDEX idx_device_id (device_id),
    
    FOREIGN KEY (patient_id) REFERENCES health_patients(id) ON DELETE CASCADE,
    FOREIGN KEY (health_record_id) REFERENCES health_records(id) ON DELETE SET NULL,
    FOREIGN KEY (device_id) REFERENCES health_devices(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='健康告警表';

-- 告警规则表
CREATE TABLE health_alert_rules (
    id VARCHAR(36) PRIMARY KEY COMMENT '规则ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    
    -- 规则基本信息
    rule_name VARCHAR(100) NOT NULL COMMENT '规则名称',
    rule_type ENUM(
        'threshold', 'trend', 'pattern', 'combination', 'ai_model', 'schedule'
    ) NOT NULL COMMENT '规则类型',
    description TEXT COMMENT '规则描述',
    
    -- 适用范围
    target_type ENUM('all_patients', 'patient_group', 'specific_patient', 'device_type') NOT NULL COMMENT '目标类型',
    target_criteria JSON COMMENT '目标条件',
    
    -- 规则配置
    rule_conditions JSON NOT NULL COMMENT '规则条件',
    threshold_config JSON COMMENT '阈值配置',
    evaluation_window JSON COMMENT '评估窗口',
    
    -- 告警配置
    alert_level ENUM('info', 'warning', 'error', 'critical', 'emergency') NOT NULL COMMENT '告警级别',
    alert_template VARCHAR(200) COMMENT '告警模板',
    notification_config JSON COMMENT '通知配置',
    
    -- 规则属性
    is_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    priority INT DEFAULT 100 COMMENT '优先级',
    cooldown_period INT DEFAULT 300 COMMENT '冷却期(秒)',
    
    -- 执行统计
    execution_count BIGINT DEFAULT 0 COMMENT '执行次数',
    trigger_count BIGINT DEFAULT 0 COMMENT '触发次数',
    last_executed_at TIMESTAMP NULL COMMENT '最后执行时间',
    last_triggered_at TIMESTAMP NULL COMMENT '最后触发时间',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    INDEX idx_tenant_type (tenant_id, rule_type),
    INDEX idx_target_type (target_type),
    INDEX idx_is_enabled (is_enabled),
    INDEX idx_priority (priority),
    INDEX idx_last_executed (last_executed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='健康告警规则表';

-- =====================================================
-- 5. 体检报告层
-- =====================================================

-- 体检报告表
CREATE TABLE health_checkup_reports (
    id VARCHAR(36) PRIMARY KEY COMMENT '报告ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    patient_id VARCHAR(36) NOT NULL COMMENT '患者ID',
    
    -- 体检基本信息
    checkup_type ENUM('annual', 'employment', 'insurance', 'specialized', 'follow_up', 'emergency') NOT NULL COMMENT '体检类型',
    report_number VARCHAR(50) NOT NULL COMMENT '报告编号',
    checkup_date DATE NOT NULL COMMENT '体检日期',
    report_date DATE COMMENT '报告日期',
    
    -- 医疗机构信息
    hospital_name VARCHAR(200) NOT NULL COMMENT '医院名称',
    department VARCHAR(100) COMMENT '科室',
    doctor_name VARCHAR(100) COMMENT '主检医生',
    doctor_signature VARCHAR(500) COMMENT '医生签名图片URL',
    
    -- 体检项目
    checkup_items JSON NOT NULL COMMENT '体检项目列表',
    
    -- 检查结果汇总
    overall_conclusion TEXT COMMENT '总体结论',
    health_status ENUM('healthy', 'sub_healthy', 'abnormal', 'disease_detected', 'critical') NOT NULL COMMENT '健康状态',
    risk_factors JSON COMMENT '危险因素',
    recommendations JSON COMMENT '建议事项',
    
    -- 主要发现
    major_findings JSON COMMENT '主要发现',
    abnormal_results JSON COMMENT '异常结果',
    follow_up_required BOOLEAN DEFAULT FALSE COMMENT '是否需要复查',
    follow_up_items JSON COMMENT '复查项目',
    follow_up_date DATE COMMENT '建议复查日期',
    
    -- 详细结果
    vital_signs JSON COMMENT '生命体征',
    laboratory_results JSON COMMENT '化验结果',
    imaging_results JSON COMMENT '影像检查结果',
    functional_tests JSON COMMENT '功能检查结果',
    specialist_consultations JSON COMMENT '专科会诊结果',
    
    -- 报告状态
    report_status ENUM('draft', 'pending_review', 'reviewed', 'finalized', 'amended') DEFAULT 'draft' COMMENT '报告状态',
    reviewed_by VARCHAR(36) COMMENT '审核医生ID',
    reviewed_at TIMESTAMP NULL COMMENT '审核时间',
    
    -- 文件附件
    report_files JSON COMMENT '报告文件',
    image_files JSON COMMENT '图像文件',
    raw_data_files JSON COMMENT '原始数据文件',
    
    -- 费用信息
    total_cost DECIMAL(10,2) COMMENT '总费用',
    payment_status ENUM('unpaid', 'partial', 'paid', 'refunded') DEFAULT 'unpaid' COMMENT '支付状态',
    
    -- 审计字段
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(36) COMMENT '创建人ID',
    
    -- 唯一约束
    UNIQUE KEY uk_tenant_report_number (tenant_id, report_number),
    
    -- 索引设计
    INDEX idx_tenant_patient (tenant_id, patient_id),
    INDEX idx_checkup_date (checkup_date),
    INDEX idx_checkup_type (checkup_type),
    INDEX idx_health_status (health_status),
    INDEX idx_report_status (report_status),
    INDEX idx_hospital_name (hospital_name),
    INDEX idx_follow_up_required (follow_up_required, follow_up_date),
    
    FOREIGN KEY (patient_id) REFERENCES health_patients(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='体检报告表';

-- =====================================================
-- 6. 统计分析层
-- =====================================================

-- 健康统计表
CREATE TABLE health_statistics (
    id VARCHAR(36) PRIMARY KEY COMMENT '统计ID',
    tenant_id VARCHAR(36) NOT NULL COMMENT '租户ID',
    stat_date DATE NOT NULL COMMENT '统计日期',
    stat_type ENUM('daily', 'weekly', 'monthly', 'yearly') NOT NULL COMMENT '统计类型',
    
    -- 患者统计
    total_patients INT DEFAULT 0 COMMENT '总患者数',
    new_patients INT DEFAULT 0 COMMENT '新增患者数',
    active_patients INT DEFAULT 0 COMMENT '活跃患者数',
    
    -- 记录统计
    total_records INT DEFAULT 0 COMMENT '总记录数',
    new_records INT DEFAULT 0 COMMENT '新增记录数',
    abnormal_records INT DEFAULT 0 COMMENT '异常记录数',
    
    -- 设备统计
    total_devices INT DEFAULT 0 COMMENT '总设备数',
    online_devices INT DEFAULT 0 COMMENT '在线设备数',
    offline_devices INT DEFAULT 0 COMMENT '离线设备数',
    error_devices INT DEFAULT 0 COMMENT '故障设备数',
    
    -- 告警统计
    total_alerts INT DEFAULT 0 COMMENT '总告警数',
    critical_alerts INT DEFAULT 0 COMMENT '严重告警数',
    resolved_alerts INT DEFAULT 0 COMMENT '已解决告警数',
    avg_resolution_time DECIMAL(8,2) COMMENT '平均解决时间(小时)',
    
    -- 体检统计
    total_checkups INT DEFAULT 0 COMMENT '总体检数',
    healthy_checkups INT DEFAULT 0 COMMENT '健康体检数',
    abnormal_checkups INT DEFAULT 0 COMMENT '异常体检数',
    
    -- 质量指标
    data_quality_score DECIMAL(5,2) COMMENT '数据质量评分',
    device_reliability DECIMAL(5,2) COMMENT '设备可靠性',
    alert_accuracy DECIMAL(5,2) COMMENT '告警准确率',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    UNIQUE KEY uk_tenant_date_type (tenant_id, stat_date, stat_type),
    INDEX idx_stat_date (stat_date),
    INDEX idx_stat_type (stat_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='健康统计表';

-- =====================================================
-- 7. 创建视图
-- =====================================================

-- 患者健康概览视图
CREATE VIEW v_patient_health_overview AS
SELECT 
    p.id,
    p.tenant_id,
    p.patient_code,
    p.name,
    p.gender,
    p.age,
    p.phone,
    p.status,
    p.total_visits,
    p.total_records,
    p.last_visit_at,
    p.last_record_at,
    COUNT(DISTINCT hr.id) as recent_records,
    COUNT(DISTINCT ha.id) as open_alerts,
    COUNT(DISTINCT hd.id) as assigned_devices,
    MAX(vs.measured_at) as last_vital_signs_at,
    vs.systolic_pressure as last_systolic_pressure,
    vs.diastolic_pressure as last_diastolic_pressure,
    vs.heart_rate as last_heart_rate,
    vs.body_temperature as last_temperature,
    cr.health_status as last_checkup_status,
    cr.checkup_date as last_checkup_date
FROM health_patients p
LEFT JOIN health_records hr ON p.id = hr.patient_id 
    AND hr.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
LEFT JOIN health_alerts ha ON p.id = ha.patient_id 
    AND ha.status = 'open'
LEFT JOIN health_devices hd ON p.id = hd.assigned_patient_id 
    AND hd.status = 'active'
LEFT JOIN health_vital_signs vs ON p.id = vs.patient_id 
    AND vs.measured_at = (
        SELECT MAX(measured_at) FROM health_vital_signs 
        WHERE patient_id = p.id
    )
LEFT JOIN health_checkup_reports cr ON p.id = cr.patient_id 
    AND cr.checkup_date = (
        SELECT MAX(checkup_date) FROM health_checkup_reports 
        WHERE patient_id = p.id
    )
GROUP BY p.id, p.tenant_id, p.patient_code, p.name, p.gender, p.age, 
         p.phone, p.status, p.total_visits, p.total_records, 
         p.last_visit_at, p.last_record_at, vs.measured_at,
         vs.systolic_pressure, vs.diastolic_pressure, vs.heart_rate, 
         vs.body_temperature, cr.health_status, cr.checkup_date;

-- 设备状态概览视图
CREATE VIEW v_device_status_overview AS
SELECT 
    d.id,
    d.tenant_id,
    d.device_name,
    d.device_type,
    d.status,
    d.assigned_patient_id,
    p.name as patient_name,
    d.battery_level,
    d.last_online_at,
    d.total_measurements,
    d.successful_measurements,
    d.error_count,
    CASE 
        WHEN d.successful_measurements > 0 THEN 
            (d.successful_measurements * 100.0 / d.total_measurements)
        ELSE 0 
    END as success_rate,
    d.needs_calibration,
    d.last_calibration_at,
    COUNT(DISTINCT dl.id) as recent_logs
FROM health_devices d
LEFT JOIN health_patients p ON d.assigned_patient_id = p.id
LEFT JOIN health_device_logs dl ON d.id = dl.device_id 
    AND dl.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY d.id, d.tenant_id, d.device_name, d.device_type, d.status,
         d.assigned_patient_id, p.name, d.battery_level, d.last_online_at,
         d.total_measurements, d.successful_measurements, d.error_count,
         d.needs_calibration, d.last_calibration_at;

-- =====================================================
-- 8. 创建存储过程
-- =====================================================

DELIMITER //

-- 生成健康报告
CREATE PROCEDURE sp_generate_health_report(
    IN p_patient_id VARCHAR(36),
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        'patient_info' as section,
        JSON_OBJECT(
            'patient_id', p.id,
            'name', p.name,
            'age', p.age,
            'gender', p.gender,
            'blood_type', p.blood_type
        ) as data
    FROM health_patients p WHERE p.id = p_patient_id
    
    UNION ALL
    
    SELECT 
        'vital_signs_summary' as section,
        JSON_OBJECT(
            'avg_systolic_pressure', AVG(vs.systolic_pressure),
            'avg_diastolic_pressure', AVG(vs.diastolic_pressure),
            'avg_heart_rate', AVG(vs.heart_rate),
            'avg_temperature', AVG(vs.body_temperature),
            'min_blood_pressure', MIN(vs.systolic_pressure),
            'max_blood_pressure', MAX(vs.systolic_pressure),
            'measurement_count', COUNT(*)
        ) as data
    FROM health_vital_signs vs 
    WHERE vs.patient_id = p_patient_id 
    AND vs.measured_at BETWEEN p_start_date AND p_end_date
    
    UNION ALL
    
    SELECT 
        'alerts_summary' as section,
        JSON_OBJECT(
            'total_alerts', COUNT(*),
            'critical_alerts', COUNT(CASE WHEN alert_level = 'critical' THEN 1 END),
            'resolved_alerts', COUNT(CASE WHEN status = 'resolved' THEN 1 END),
            'open_alerts', COUNT(CASE WHEN status = 'open' THEN 1 END)
        ) as data
    FROM health_alerts ha 
    WHERE ha.patient_id = p_patient_id 
    AND ha.triggered_at BETWEEN p_start_date AND p_end_date;
    
END //

-- 评估患者健康风险
CREATE PROCEDURE sp_assess_health_risk(IN p_patient_id VARCHAR(36))
BEGIN
    DECLARE v_age INT;
    DECLARE v_bmi DECIMAL(4,1);
    DECLARE v_systolic_avg DECIMAL(8,2);
    DECLARE v_diastolic_avg DECIMAL(8,2);
    DECLARE v_heart_rate_avg DECIMAL(8,2);
    DECLARE v_risk_score INT DEFAULT 0;
    DECLARE v_risk_level VARCHAR(20);
    
    -- 获取患者基本信息
    SELECT age, bmi INTO v_age, v_bmi
    FROM health_patients WHERE id = p_patient_id;
    
    -- 获取最近30天的平均生命体征
    SELECT 
        AVG(systolic_pressure),
        AVG(diastolic_pressure),
        AVG(heart_rate)
    INTO v_systolic_avg, v_diastolic_avg, v_heart_rate_avg
    FROM health_vital_signs 
    WHERE patient_id = p_patient_id 
    AND measured_at >= DATE_SUB(NOW(), INTERVAL 30 DAY);
    
    -- 年龄风险评估
    IF v_age >= 65 THEN
        SET v_risk_score = v_risk_score + 20;
    ELSEIF v_age >= 50 THEN
        SET v_risk_score = v_risk_score + 10;
    ELSEIF v_age >= 35 THEN
        SET v_risk_score = v_risk_score + 5;
    END IF;
    
    -- BMI风险评估
    IF v_bmi >= 30 THEN
        SET v_risk_score = v_risk_score + 15;
    ELSEIF v_bmi >= 25 THEN
        SET v_risk_score = v_risk_score + 10;
    ELSEIF v_bmi < 18.5 THEN
        SET v_risk_score = v_risk_score + 8;
    END IF;
    
    -- 血压风险评估
    IF v_systolic_avg >= 140 OR v_diastolic_avg >= 90 THEN
        SET v_risk_score = v_risk_score + 20;
    ELSEIF v_systolic_avg >= 130 OR v_diastolic_avg >= 80 THEN
        SET v_risk_score = v_risk_score + 15;
    ELSEIF v_systolic_avg >= 120 THEN
        SET v_risk_score = v_risk_score + 5;
    END IF;
    
    -- 心率风险评估
    IF v_heart_rate_avg > 100 OR v_heart_rate_avg < 60 THEN
        SET v_risk_score = v_risk_score + 10;
    END IF;
    
    -- 确定风险等级
    IF v_risk_score >= 50 THEN
        SET v_risk_level = 'high';
    ELSEIF v_risk_score >= 30 THEN
        SET v_risk_level = 'medium';
    ELSEIF v_risk_score >= 15 THEN
        SET v_risk_level = 'low';
    ELSE
        SET v_risk_level = 'very_low';
    END IF;
    
    SELECT 
        p_patient_id as patient_id,
        v_risk_score as risk_score,
        v_risk_level as risk_level,
        JSON_OBJECT(
            'age_factor', v_age,
            'bmi_factor', v_bmi,
            'avg_systolic_pressure', v_systolic_avg,
            'avg_diastolic_pressure', v_diastolic_avg,
            'avg_heart_rate', v_heart_rate_avg
        ) as risk_factors;
        
END //

-- 设备性能分析
CREATE PROCEDURE sp_analyze_device_performance(IN p_device_id VARCHAR(36))
BEGIN
    DECLARE v_device_name VARCHAR(100);
    DECLARE v_total_measurements BIGINT;
    DECLARE v_successful_measurements BIGINT;
    DECLARE v_error_count INT;
    DECLARE v_success_rate DECIMAL(5,2);
    DECLARE v_avg_data_quality DECIMAL(5,2);
    
    -- 获取设备基本信息
    SELECT device_name, total_measurements, successful_measurements, error_count
    INTO v_device_name, v_total_measurements, v_successful_measurements, v_error_count
    FROM health_devices WHERE id = p_device_id;
    
    -- 计算成功率
    IF v_total_measurements > 0 THEN
        SET v_success_rate = (v_successful_measurements * 100.0 / v_total_measurements);
    ELSE
        SET v_success_rate = 0;
    END IF;
    
    -- 计算平均数据质量
    SELECT 
        AVG(CASE 
            WHEN data_quality = 'excellent' THEN 100
            WHEN data_quality = 'good' THEN 80
            WHEN data_quality = 'fair' THEN 60
            WHEN data_quality = 'poor' THEN 40
            ELSE 20
        END)
    INTO v_avg_data_quality
    FROM health_device_logs 
    WHERE device_id = p_device_id 
    AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY);
    
    SELECT 
        p_device_id as device_id,
        v_device_name as device_name,
        v_total_measurements as total_measurements,
        v_successful_measurements as successful_measurements,
        v_error_count as error_count,
        v_success_rate as success_rate,
        v_avg_data_quality as avg_data_quality,
        CASE 
            WHEN v_success_rate >= 95 AND v_avg_data_quality >= 80 THEN 'excellent'
            WHEN v_success_rate >= 90 AND v_avg_data_quality >= 70 THEN 'good'
            WHEN v_success_rate >= 80 AND v_avg_data_quality >= 60 THEN 'fair'
            ELSE 'poor'
        END as performance_rating;
END //

DELIMITER ;

-- =====================================================
-- 9. 创建定时任务
-- =====================================================

-- 启用事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建健康统计任务
CREATE EVENT IF NOT EXISTS generate_daily_health_stats
ON SCHEDULE EVERY 1 DAY
STARTS DATE_ADD(DATE_ADD(CURDATE(), INTERVAL 1 DAY), INTERVAL 2 HOUR)
DO
BEGIN
    INSERT INTO health_statistics (
        id, tenant_id, stat_date, stat_type,
        total_patients, new_patients, active_patients,
        total_records, new_records, abnormal_records,
        total_devices, online_devices, offline_devices, error_devices,
        total_alerts, critical_alerts, resolved_alerts,
        total_checkups, healthy_checkups, abnormal_checkups
    )
    SELECT 
        UUID() as id,
        p.tenant_id,
        CURDATE() - INTERVAL 1 DAY as stat_date,
        'daily' as stat_type,
        COUNT(DISTINCT p.id) as total_patients,
        COUNT(DISTINCT CASE WHEN DATE(p.created_at) = CURDATE() - INTERVAL 1 DAY THEN p.id END) as new_patients,
        COUNT(DISTINCT CASE WHEN p.last_record_at >= CURDATE() - INTERVAL 7 DAY THEN p.id END) as active_patients,
        COUNT(DISTINCT hr.id) as total_records,
        COUNT(DISTINCT CASE WHEN DATE(hr.created_at) = CURDATE() - INTERVAL 1 DAY THEN hr.id END) as new_records,
        COUNT(DISTINCT CASE WHEN hr.risk_level IN ('high', 'critical') THEN hr.id END) as abnormal_records,
        COUNT(DISTINCT hd.id) as total_devices,
        COUNT(DISTINCT CASE WHEN hd.status = 'active' AND hd.last_online_at >= NOW() - INTERVAL 1 HOUR THEN hd.id END) as online_devices,
        COUNT(DISTINCT CASE WHEN hd.status = 'offline' OR hd.last_online_at < NOW() - INTERVAL 1 HOUR THEN hd.id END) as offline_devices,
        COUNT(DISTINCT CASE WHEN hd.status = 'error' THEN hd.id END) as error_devices,
        COUNT(DISTINCT ha.id) as total_alerts,
        COUNT(DISTINCT CASE WHEN ha.alert_level IN ('critical', 'emergency') THEN ha.id END) as critical_alerts,
        COUNT(DISTINCT CASE WHEN ha.status = 'resolved' AND DATE(ha.resolved_at) = CURDATE() - INTERVAL 1 DAY THEN ha.id END) as resolved_alerts,
        COUNT(DISTINCT cr.id) as total_checkups,
        COUNT(DISTINCT CASE WHEN cr.health_status = 'healthy' THEN cr.id END) as healthy_checkups,
        COUNT(DISTINCT CASE WHEN cr.health_status IN ('abnormal', 'disease_detected', 'critical') THEN cr.id END) as abnormal_checkups
    FROM health_patients p
    LEFT JOIN health_records hr ON p.id = hr.patient_id
    LEFT JOIN health_devices hd ON p.tenant_id = hd.tenant_id
    LEFT JOIN health_alerts ha ON p.id = ha.patient_id AND DATE(ha.triggered_at) = CURDATE() - INTERVAL 1 DAY
    LEFT JOIN health_checkup_reports cr ON p.id = cr.patient_id AND DATE(cr.checkup_date) = CURDATE() - INTERVAL 1 DAY
    GROUP BY p.tenant_id
    ON DUPLICATE KEY UPDATE
        total_patients = VALUES(total_patients),
        new_patients = VALUES(new_patients),
        active_patients = VALUES(active_patients),
        total_records = VALUES(total_records),
        new_records = VALUES(new_records),
        abnormal_records = VALUES(abnormal_records),
        total_devices = VALUES(total_devices),
        online_devices = VALUES(online_devices),
        offline_devices = VALUES(offline_devices),
        error_devices = VALUES(error_devices),
        total_alerts = VALUES(total_alerts),
        critical_alerts = VALUES(critical_alerts),
        resolved_alerts = VALUES(resolved_alerts),
        total_checkups = VALUES(total_checkups),
        healthy_checkups = VALUES(healthy_checkups),
        abnormal_checkups = VALUES(abnormal_checkups),
        updated_at = NOW();
END;

-- 创建设备状态检查任务
CREATE EVENT IF NOT EXISTS check_device_status
ON SCHEDULE EVERY 10 MINUTE
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- 标记离线设备
    UPDATE health_devices 
    SET status = 'offline'
    WHERE status = 'active' 
    AND last_online_at < NOW() - INTERVAL 1 HOUR;
    
    -- 检查需要校准的设备
    INSERT INTO health_alerts (
        id, tenant_id, patient_id, alert_type, alert_level,
        alert_title, alert_message, trigger_source, device_id
    )
    SELECT 
        UUID() as id,
        hd.tenant_id,
        hd.assigned_patient_id,
        'device_offline' as alert_type,
        'warning' as alert_level,
        CONCAT('设备离线: ', hd.device_name) as alert_title,
        CONCAT('设备 ', hd.device_name, ' 已离线超过1小时，请检查设备状态') as alert_message,
        'rule' as trigger_source,
        hd.id as device_id
    FROM health_devices hd
    WHERE hd.needs_calibration = TRUE
    AND hd.assigned_patient_id IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM health_alerts ha 
        WHERE ha.device_id = hd.id 
        AND ha.alert_type = 'device_offline'
        AND ha.status = 'open'
    );
END;

-- =====================================================
-- 10. 插入初始数据
-- =====================================================

-- 插入默认告警规则
INSERT INTO health_alert_rules (id, tenant_id, rule_name, rule_type, target_type, rule_conditions, alert_level, description) VALUES
(UUID(), 'default-tenant', '高血压告警', 'threshold', 'all_patients', '{"systolic_pressure": {"min": 140}, "diastolic_pressure": {"min": 90}}', 'warning', '收缩压≥140或舒张压≥90时触发'),
(UUID(), 'default-tenant', '低血压告警', 'threshold', 'all_patients', '{"systolic_pressure": {"max": 90}, "diastolic_pressure": {"max": 60}}', 'warning', '收缩压≤90或舒张压≤60时触发'),
(UUID(), 'default-tenant', '心率异常告警', 'threshold', 'all_patients', '{"heart_rate": {"min": 100, "max": 60}}', 'warning', '心率>100或<60时触发'),
(UUID(), 'default-tenant', '高血糖告警', 'threshold', 'all_patients', '{"blood_glucose": {"min": 11.1}}', 'error', '血糖≥11.1mmol/L时触发'),
(UUID(), 'default-tenant', '低血糖告警', 'threshold', 'all_patients', '{"blood_glucose": {"max": 3.9}}', 'critical', '血糖≤3.9mmol/L时触发'),
(UUID(), 'default-tenant', '发热告警', 'threshold', 'all_patients', '{"body_temperature": {"min": 37.3}}', 'warning', '体温≥37.3°C时触发'),
(UUID(), 'default-tenant', '体重急剧变化', 'trend', 'all_patients', '{"weight_change": {"percentage": 5, "duration_days": 7}}', 'warning', '7天内体重变化超过5%时触发');

-- =====================================================
-- 完成提示
-- =====================================================

SELECT '🏥 健康管理模块数据库初始化完成！' as message;
SELECT '📊 包含患者管理、健康记录、设备管理、告警系统等功能' as features;
SELECT '🔧 已创建视图、存储过程和定时任务用于数据分析和监控' as additional_features;
SELECT '📈 分区表设计支持大量设备日志数据存储' as performance_features;
SELECT '⚕️ 支持多种健康设备和完整的健康生命周期管理' as health_features;