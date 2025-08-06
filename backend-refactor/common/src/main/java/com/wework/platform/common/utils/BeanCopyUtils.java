package com.wework.platform.common.utils;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Supplier;

/**
 * Bean拷贝工具类
 * 基于Spring BeanUtils，提供更便捷的对象拷贝功能
 *
 * @author WeWork Platform Team
 * @since 2.0.0
 */
@Slf4j
public class BeanCopyUtils {

    /**
     * 拷贝单个对象
     */
    public static <T> T copyBean(Object source, Class<T> targetClass) {
        if (source == null) {
            return null;
        }
        try {
            T target = targetClass.getDeclaredConstructor().newInstance();
            BeanUtils.copyProperties(source, target);
            return target;
        } catch (Exception e) {
            log.error("Bean拷贝失败: source={}, targetClass={}", source.getClass(), targetClass, e);
            throw new RuntimeException("Bean拷贝失败", e);
        }
    }

    /**
     * 拷贝单个对象（使用Supplier提供目标对象）
     */
    public static <T> T copyBean(Object source, Supplier<T> targetSupplier) {
        if (source == null) {
            return null;
        }
        try {
            T target = targetSupplier.get();
            BeanUtils.copyProperties(source, target);
            return target;
        } catch (Exception e) {
            log.error("Bean拷贝失败: source={}", source.getClass(), e);
            throw new RuntimeException("Bean拷贝失败", e);
        }
    }

    /**
     * 拷贝对象列表
     */
    public static <S, T> List<T> copyBeanList(List<S> sources, Class<T> targetClass) {
        if (sources == null || sources.isEmpty()) {
            return new ArrayList<>();
        }
        
        List<T> targets = new ArrayList<>(sources.size());
        for (S source : sources) {
            T target = copyBean(source, targetClass);
            if (target != null) {
                targets.add(target);
            }
        }
        return targets;
    }

    /**
     * 拷贝对象列表（使用Supplier提供目标对象）
     */
    public static <S, T> List<T> copyBeanList(List<S> sources, Supplier<T> targetSupplier) {
        if (sources == null || sources.isEmpty()) {
            return new ArrayList<>();
        }
        
        List<T> targets = new ArrayList<>(sources.size());
        for (S source : sources) {
            T target = copyBean(source, targetSupplier);
            if (target != null) {
                targets.add(target);
            }
        }
        return targets;
    }

    /**
     * 拷贝属性到已存在的对象
     */
    public static void copyProperties(Object source, Object target) {
        if (source == null || target == null) {
            return;
        }
        try {
            BeanUtils.copyProperties(source, target);
        } catch (Exception e) {
            log.error("属性拷贝失败: source={}, target={}", source.getClass(), target.getClass(), e);
            throw new RuntimeException("属性拷贝失败", e);
        }
    }

    /**
     * 拷贝属性到已存在的对象（忽略空值）
     */
    public static void copyPropertiesIgnoreNull(Object source, Object target) {
        if (source == null || target == null) {
            return;
        }
        try {
            BeanUtils.copyProperties(source, target, getNullPropertyNames(source));
        } catch (Exception e) {
            log.error("属性拷贝失败: source={}, target={}", source.getClass(), target.getClass(), e);
            throw new RuntimeException("属性拷贝失败", e);
        }
    }

    /**
     * 获取对象中值为null的属性名
     */
    private static String[] getNullPropertyNames(Object source) {
        java.beans.BeanInfo beanInfo;
        try {
            beanInfo = java.beans.Introspector.getBeanInfo(source.getClass());
        } catch (java.beans.IntrospectionException e) {
            log.error("获取Bean信息失败", e);
            return new String[0];
        }

        java.beans.PropertyDescriptor[] pds = beanInfo.getPropertyDescriptors();
        List<String> nullProperties = new ArrayList<>();

        for (java.beans.PropertyDescriptor pd : pds) {
            if (pd.getReadMethod() != null) {
                try {
                    Object value = pd.getReadMethod().invoke(source);
                    if (value == null) {
                        nullProperties.add(pd.getName());
                    }
                } catch (Exception e) {
                    log.debug("获取属性值失败: {}", pd.getName(), e);
                }
            }
        }

        return nullProperties.toArray(new String[0]);
    }
}