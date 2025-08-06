package com.wework.platform.task.handler;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 任务处理器注册中心
 * 负责管理所有的任务处理器
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
@Slf4j
@Component
public class TaskHandlerRegistry implements ApplicationContextAware, InitializingBean {

    private ApplicationContext applicationContext;

    /**
     * 处理器映射表：handlerName -> TaskHandler
     */
    private final Map<String, TaskHandler> handlerMap = new ConcurrentHashMap<>();

    /**
     * 类名映射表：className -> TaskHandler
     */
    private final Map<String, TaskHandler> classNameMap = new ConcurrentHashMap<>();

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        registerHandlers();
    }

    /**
     * 注册所有任务处理器
     */
    private void registerHandlers() {
        log.info("开始注册任务处理器...");
        
        // 从Spring上下文中获取所有TaskHandler实现
        Map<String, TaskHandler> handlers = applicationContext.getBeansOfType(TaskHandler.class);
        
        for (Map.Entry<String, TaskHandler> entry : handlers.entrySet()) {
            String beanName = entry.getKey();
            TaskHandler handler = entry.getValue();
            
            try {
                registerHandler(handler);
                log.info("成功注册任务处理器: {} -> {}", handler.getHandlerName(), handler.getClass().getName());
            } catch (Exception e) {
                log.error("注册任务处理器失败: beanName={}, handler={}", beanName, handler.getClass().getName(), e);
            }
        }
        
        log.info("任务处理器注册完成，共注册 {} 个处理器", handlerMap.size());
    }

    /**
     * 注册单个处理器
     * 
     * @param handler 任务处理器
     */
    public void registerHandler(TaskHandler handler) {
        if (handler == null) {
            throw new IllegalArgumentException("任务处理器不能为空");
        }

        String handlerName = handler.getHandlerName();
        if (handlerName == null || handlerName.trim().isEmpty()) {
            throw new IllegalArgumentException("任务处理器名称不能为空: " + handler.getClass().getName());
        }

        // 检查名称冲突
        if (handlerMap.containsKey(handlerName)) {
            TaskHandler existingHandler = handlerMap.get(handlerName);
            log.warn("任务处理器名称冲突: {} -> 现有:{}, 新增:{}", 
                    handlerName, existingHandler.getClass().getName(), handler.getClass().getName());
        }

        // 注册处理器
        handlerMap.put(handlerName, handler);
        classNameMap.put(handler.getClass().getName(), handler);
        classNameMap.put(handler.getClass().getSimpleName(), handler);

        log.debug("注册任务处理器: {} -> {} (版本: {})", 
                handlerName, handler.getClass().getName(), handler.getVersion());
    }

    /**
     * 注销处理器
     * 
     * @param handlerName 处理器名称
     * @return 是否注销成功
     */
    public boolean unregisterHandler(String handlerName) {
        TaskHandler handler = handlerMap.remove(handlerName);
        if (handler != null) {
            classNameMap.remove(handler.getClass().getName());
            classNameMap.remove(handler.getClass().getSimpleName());
            log.info("注销任务处理器: {} -> {}", handlerName, handler.getClass().getName());
            return true;
        }
        return false;
    }

    /**
     * 根据处理器名称获取处理器
     * 
     * @param handlerName 处理器名称
     * @return 任务处理器，不存在返回null
     */
    public TaskHandler getHandler(String handlerName) {
        if (handlerName == null || handlerName.trim().isEmpty()) {
            return null;
        }
        
        return handlerMap.get(handlerName);
    }

    /**
     * 根据类名获取处理器
     * 
     * @param className 类名（全限定名或简单名）
     * @return 任务处理器，不存在返回null
     */
    public TaskHandler getHandlerByClassName(String className) {
        if (className == null || className.trim().isEmpty()) {
            return null;
        }
        
        return classNameMap.get(className);
    }

    /**
     * 根据类获取处理器
     * 
     * @param handlerClass 处理器类
     * @return 任务处理器，不存在返回null
     */
    public TaskHandler getHandlerByClass(Class<? extends TaskHandler> handlerClass) {
        if (handlerClass == null) {
            return null;
        }
        
        return classNameMap.get(handlerClass.getName());
    }

    /**
     * 检查处理器是否存在
     * 
     * @param handlerName 处理器名称
     * @return 是否存在
     */
    public boolean hasHandler(String handlerName) {
        return handlerMap.containsKey(handlerName);
    }

    /**
     * 检查类名对应的处理器是否存在
     * 
     * @param className 类名
     * @return 是否存在
     */
    public boolean hasHandlerByClassName(String className) {
        return classNameMap.containsKey(className);
    }

    /**
     * 获取所有处理器名称
     * 
     * @return 处理器名称集合
     */
    public java.util.Set<String> getAllHandlerNames() {
        return handlerMap.keySet();
    }

    /**
     * 获取所有处理器
     * 
     * @return 处理器映射表的副本
     */
    public Map<String, TaskHandler> getAllHandlers() {
        return new ConcurrentHashMap<>(handlerMap);
    }

    /**
     * 获取支持指定任务类型的处理器
     * 
     * @param taskType 任务类型
     * @return 支持的处理器列表
     */
    public java.util.List<TaskHandler> getHandlersByTaskType(String taskType) {
        java.util.List<TaskHandler> supportedHandlers = new java.util.ArrayList<>();
        
        for (TaskHandler handler : handlerMap.values()) {
            if (handler.supports(taskType)) {
                supportedHandlers.add(handler);
            }
        }
        
        return supportedHandlers;
    }

    /**
     * 获取处理器数量
     * 
     * @return 处理器数量
     */
    public int getHandlerCount() {
        return handlerMap.size();
    }

    /**
     * 清空所有处理器
     */
    public void clear() {
        handlerMap.clear();
        classNameMap.clear();
        log.info("清空所有任务处理器");
    }

    /**
     * 获取处理器信息
     * 
     * @param handlerName 处理器名称
     * @return 处理器信息
     */
    public HandlerInfo getHandlerInfo(String handlerName) {
        TaskHandler handler = getHandler(handlerName);
        if (handler == null) {
            return null;
        }
        
        return HandlerInfo.builder()
                .handlerName(handler.getHandlerName())
                .className(handler.getClass().getName())
                .description(handler.getDescription())
                .version(handler.getVersion())
                .build();
    }

    /**
     * 获取所有处理器信息
     * 
     * @return 处理器信息列表
     */
    public java.util.List<HandlerInfo> getAllHandlerInfos() {
        java.util.List<HandlerInfo> infos = new java.util.ArrayList<>();
        
        for (TaskHandler handler : handlerMap.values()) {
            HandlerInfo info = HandlerInfo.builder()
                    .handlerName(handler.getHandlerName())
                    .className(handler.getClass().getName())
                    .description(handler.getDescription())
                    .version(handler.getVersion())
                    .build();
            infos.add(info);
        }
        
        return infos;
    }

    /**
     * 处理器信息类
     */
    @lombok.Data
    @lombok.Builder
    @lombok.NoArgsConstructor
    @lombok.AllArgsConstructor
    public static class HandlerInfo {
        /**
         * 处理器名称
         */
        private String handlerName;

        /**
         * 类名
         */
        private String className;

        /**
         * 描述
         */
        private String description;

        /**
         * 版本
         */
        private String version;

        /**
         * 注册时间
         */
        private java.time.LocalDateTime registeredAt;
    }

    /**
     * 重新加载处理器
     */
    public void reload() {
        log.info("重新加载任务处理器...");
        clear();
        registerHandlers();
    }

    /**
     * 验证处理器配置
     * 
     * @return 验证结果
     */
    public String validateHandlers() {
        java.util.List<String> errors = new java.util.ArrayList<>();
        
        for (Map.Entry<String, TaskHandler> entry : handlerMap.entrySet()) {
            String handlerName = entry.getKey();
            TaskHandler handler = entry.getValue();
            
            try {
                // 验证处理器名称
                if (handlerName == null || handlerName.trim().isEmpty()) {
                    errors.add("处理器名称为空: " + handler.getClass().getName());
                }
                
                // 验证处理器版本
                String version = handler.getVersion();
                if (version == null || version.trim().isEmpty()) {
                    errors.add("处理器版本为空: " + handlerName);
                }
                
            } catch (Exception e) {
                errors.add("验证处理器失败: " + handlerName + " - " + e.getMessage());
            }
        }
        
        return errors.isEmpty() ? null : String.join("; ", errors);
    }

    @Override
    public String toString() {
        return "TaskHandlerRegistry{" +
                "handlerCount=" + handlerMap.size() +
                ", handlers=" + handlerMap.keySet() +
                '}';
    }

}