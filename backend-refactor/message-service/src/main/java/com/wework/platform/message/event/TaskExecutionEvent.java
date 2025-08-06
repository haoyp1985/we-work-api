package com.wework.platform.message.event;

import org.springframework.context.ApplicationEvent;

/**
 * 任务执行事件
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public class TaskExecutionEvent extends ApplicationEvent {

    private final String taskId;
    private final String eventType;
    private final String message;
    private final Long timestamp;

    /**
     * 创建任务执行事件
     *
     * @param taskId 任务ID
     * @param eventType 事件类型 (STARTED, COMPLETED, PAUSED, CANCELLED, FAILED)
     */
    public TaskExecutionEvent(String taskId, String eventType) {
        super(taskId);
        this.taskId = taskId;
        this.eventType = eventType;
        this.message = null;
        this.timestamp = System.currentTimeMillis();
    }

    /**
     * 创建任务执行事件
     *
     * @param taskId 任务ID
     * @param eventType 事件类型
     * @param message 事件消息
     */
    public TaskExecutionEvent(String taskId, String eventType, String message) {
        super(taskId);
        this.taskId = taskId;
        this.eventType = eventType;
        this.message = message;
        this.timestamp = System.currentTimeMillis();
    }

    public String getTaskId() {
        return taskId;
    }

    public String getEventType() {
        return eventType;
    }

    public String getMessage() {
        return message;
    }

    public Long getEventTimestamp() {
        return timestamp;
    }
}