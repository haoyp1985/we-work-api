package com.wework.platform.message.client;

import com.wework.platform.message.entity.Message;

/**
 * 企微客户端接口
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
public interface WeWorkClient {

    /**
     * 发送消息
     *
     * @param message 消息实体
     * @return 企微消息ID
     * @throws WeWorkException 发送异常
     */
    String sendMessage(Message message) throws WeWorkException;

    /**
     * 撤回消息
     *
     * @param accountId 账号ID
     * @param weworkMsgId 企微消息ID
     * @return 是否成功
     * @throws WeWorkException 撤回异常
     */
    boolean recallMessage(String accountId, String weworkMsgId) throws WeWorkException;

    /**
     * 获取消息发送状态
     *
     * @param accountId 账号ID
     * @param weworkMsgId 企微消息ID
     * @return 发送状态
     * @throws WeWorkException 查询异常
     */
    MessageStatus getMessageStatus(String accountId, String weworkMsgId) throws WeWorkException;

    /**
     * 发送文本消息
     *
     * @param accountId 账号ID
     * @param receiverId 接收者ID
     * @param content 文本内容
     * @return 企微消息ID
     * @throws WeWorkException 发送异常
     */
    String sendTextMessage(String accountId, String receiverId, String content) throws WeWorkException;

    /**
     * 发送图片消息
     *
     * @param accountId 账号ID
     * @param receiverId 接收者ID
     * @param mediaId 媒体ID
     * @return 企微消息ID
     * @throws WeWorkException 发送异常
     */
    String sendImageMessage(String accountId, String receiverId, String mediaId) throws WeWorkException;

    /**
     * 发送文件消息
     *
     * @param accountId 账号ID
     * @param receiverId 接收者ID
     * @param mediaId 媒体ID
     * @param fileName 文件名
     * @return 企微消息ID
     * @throws WeWorkException 发送异常
     */
    String sendFileMessage(String accountId, String receiverId, String mediaId, String fileName) throws WeWorkException;

    /**
     * 批量发送消息
     *
     * @param accountId 账号ID
     * @param receiverIds 接收者ID列表
     * @param content 消息内容
     * @return 批次ID
     * @throws WeWorkException 发送异常
     */
    String batchSendMessage(String accountId, String[] receiverIds, Object content) throws WeWorkException;

    /**
     * 上传媒体文件
     *
     * @param accountId 账号ID
     * @param fileType 文件类型
     * @param filePath 文件路径
     * @return 媒体ID
     * @throws WeWorkException 上传异常
     */
    String uploadMedia(String accountId, String fileType, String filePath) throws WeWorkException;

    /**
     * 验证账号连接状态
     *
     * @param accountId 账号ID
     * @return 是否在线
     */
    boolean checkAccountStatus(String accountId);

    /**
     * 消息状态枚举
     */
    enum MessageStatus {
        PENDING("待发送"),
        SENDING("发送中"),
        SUCCESS("发送成功"),
        FAILED("发送失败"),
        RECALLED("已撤回");

        private final String description;

        MessageStatus(String description) {
            this.description = description;
        }

        public String getDescription() {
            return description;
        }
    }

    /**
     * 企微异常
     */
    class WeWorkException extends Exception {
        private String errorCode;
        
        public WeWorkException(String message) {
            super(message);
        }
        
        public WeWorkException(String errorCode, String message) {
            super(message);
            this.errorCode = errorCode;
        }
        
        public WeWorkException(String message, Throwable cause) {
            super(message, cause);
        }
        
        public String getErrorCode() {
            return errorCode;
        }
    }
}