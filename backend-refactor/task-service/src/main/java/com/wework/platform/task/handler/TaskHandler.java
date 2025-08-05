package com.wework.platform.task.handler;

/**
 * 任务处理器接口
 * 所有具体的任务处理器都需要实现此接口
 * 
 * @author WeWork Platform Team
 * @since 1.0.0
 */
public interface TaskHandler {

    /**
     * 执行任务
     * 
     * @param context 任务上下文
     * @return 执行结果
     */
    TaskResult execute(TaskContext context);

    /**
     * 获取处理器名称
     * 
     * @return 处理器名称
     */
    String getHandlerName();

    /**
     * 获取处理器描述
     * 
     * @return 处理器描述
     */
    default String getDescription() {
        return getHandlerName();
    }

    /**
     * 获取处理器版本
     * 
     * @return 版本号
     */
    default String getVersion() {
        return "1.0.0";
    }

    /**
     * 检查是否支持指定的任务类型
     * 
     * @param taskType 任务类型
     * @return 是否支持
     */
    default boolean supports(String taskType) {
        return true;
    }

    /**
     * 任务执行前的预处理
     * 
     * @param context 任务上下文
     * @return 是否继续执行
     */
    default boolean preExecute(TaskContext context) {
        return true;
    }

    /**
     * 任务执行后的后处理
     * 
     * @param context 任务上下文
     * @param result 执行结果
     */
    default void postExecute(TaskContext context, TaskResult result) {
        // 默认不做任何处理
    }

    /**
     * 处理任务执行异常
     * 
     * @param context 任务上下文
     * @param exception 异常
     * @return 处理结果
     */
    default TaskResult handleException(TaskContext context, Exception exception) {
        context.logError("任务执行异常", exception);
        return TaskResult.failure("任务执行异常: " + exception.getMessage(), exception);
    }

    /**
     * 验证任务参数
     * 
     * @param context 任务上下文
     * @return 验证结果，null表示验证通过
     */
    default String validateParameters(TaskContext context) {
        return null; // 默认不验证
    }

    /**
     * 估算任务执行时间（秒）
     * 
     * @param context 任务上下文
     * @return 预估执行时间，-1表示无法估算
     */
    default long estimateExecutionTime(TaskContext context) {
        return -1; // 默认无法估算
    }

    /**
     * 检查任务是否可以取消
     * 
     * @param context 任务上下文
     * @return 是否可以取消
     */
    default boolean isCancellable(TaskContext context) {
        return false; // 默认不可取消
    }

    /**
     * 取消任务执行
     * 
     * @param context 任务上下文
     * @return 取消结果
     */
    default TaskResult cancel(TaskContext context) {
        return TaskResult.failure("任务不支持取消操作");
    }

    /**
     * 获取任务进度
     * 
     * @param context 任务上下文
     * @return 进度百分比（0-100），-1表示无法获取进度
     */
    default int getProgress(TaskContext context) {
        return -1; // 默认无法获取进度
    }

    /**
     * 暂停任务执行
     * 
     * @param context 任务上下文
     * @return 暂停结果
     */
    default TaskResult pause(TaskContext context) {
        return TaskResult.failure("任务不支持暂停操作");
    }

    /**
     * 恢复任务执行
     * 
     * @param context 任务上下文
     * @return 恢复结果
     */
    default TaskResult resume(TaskContext context) {
        return TaskResult.failure("任务不支持恢复操作");
    }

    /**
     * 获取任务资源需求
     * 
     * @param context 任务上下文
     * @return 资源需求描述
     */
    default TaskResourceRequirement getResourceRequirement(TaskContext context) {
        return TaskResourceRequirement.DEFAULT;
    }

    /**
     * 任务资源需求类
     */
    class TaskResourceRequirement {
        
        public static final TaskResourceRequirement DEFAULT = new TaskResourceRequirement();

        /**
         * CPU需求（核心数）
         */
        private double cpuCores = 1.0;

        /**
         * 内存需求（MB）
         */
        private long memoryMB = 512;

        /**
         * 磁盘需求（MB）
         */
        private long diskMB = 100;

        /**
         * 网络需求（是否需要网络）
         */
        private boolean networkRequired = false;

        public double getCpuCores() {
            return cpuCores;
        }

        public void setCpuCores(double cpuCores) {
            this.cpuCores = cpuCores;
        }

        public long getMemoryMB() {
            return memoryMB;
        }

        public void setMemoryMB(long memoryMB) {
            this.memoryMB = memoryMB;
        }

        public long getDiskMB() {
            return diskMB;
        }

        public void setDiskMB(long diskMB) {
            this.diskMB = diskMB;
        }

        public boolean isNetworkRequired() {
            return networkRequired;
        }

        public void setNetworkRequired(boolean networkRequired) {
            this.networkRequired = networkRequired;
        }

        public static TaskResourceRequirement of(double cpuCores, long memoryMB, long diskMB, boolean networkRequired) {
            TaskResourceRequirement requirement = new TaskResourceRequirement();
            requirement.setCpuCores(cpuCores);
            requirement.setMemoryMB(memoryMB);
            requirement.setDiskMB(diskMB);
            requirement.setNetworkRequired(networkRequired);
            return requirement;
        }

        @Override
        public String toString() {
            return "TaskResourceRequirement{" +
                    "cpuCores=" + cpuCores +
                    ", memoryMB=" + memoryMB +
                    ", diskMB=" + diskMB +
                    ", networkRequired=" + networkRequired +
                    '}';
        }
    }
}