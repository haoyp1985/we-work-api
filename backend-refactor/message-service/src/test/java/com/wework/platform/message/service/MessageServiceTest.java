package com.wework.platform.message.service;

import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.common.enums.MessageStatus;
import com.wework.platform.common.enums.MessageType;
import com.wework.platform.message.dto.MessageDTO;
import com.wework.platform.message.dto.MessageStatisticsDTO;
import com.wework.platform.message.dto.SendMessageRequest;
import com.wework.platform.message.entity.Message;
import com.wework.platform.message.repository.MessageRepository;
import com.wework.platform.message.service.impl.MessageServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * 消息服务测试类
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@ExtendWith(MockitoExtension.class)
class MessageServiceTest {

    @Mock
    private MessageRepository messageRepository;

    @Mock
    private ApplicationEventPublisher eventPublisher;

    @InjectMocks
    private MessageServiceImpl messageService;

    private Message testMessage;
    private SendMessageRequest sendRequest;

    @BeforeEach
    void setUp() {
        testMessage = new Message();
        testMessage.setId("msg-001");
        testMessage.setTenantId("tenant-001");
        testMessage.setAccountId("account-001");
        testMessage.setType(MessageType.TEXT);
        testMessage.setContent("测试消息");
        testMessage.setRecipient("user@example.com");
        testMessage.setStatus(MessageStatus.PENDING);
        testMessage.setCreatedAt(LocalDateTime.now());

        sendRequest = new SendMessageRequest();
        sendRequest.setAccountId("account-001");
        sendRequest.setType(MessageType.TEXT);
        sendRequest.setContent("测试消息");
        sendRequest.setRecipient("user@example.com");
    }

    @Test
    void testSendMessage_Success() {
        // Given
        when(messageRepository.save(any(Message.class))).thenReturn(testMessage);

        // When
        Result<MessageDTO> result = messageService.sendMessage("tenant-001", sendRequest);

        // Then
        assertTrue(result.isSuccess());
        assertNotNull(result.getData());
        assertEquals("msg-001", result.getData().getId());
        assertEquals("测试消息", result.getData().getContent());

        verify(messageRepository).save(any(Message.class));
        verify(eventPublisher).publishEvent(any());
    }

    @Test
    void testGetMessageById_Success() {
        // Given
        when(messageRepository.findByIdAndTenantId("msg-001", "tenant-001"))
                .thenReturn(Optional.of(testMessage));

        // When
        Result<MessageDTO> result = messageService.getMessageById("tenant-001", "msg-001");

        // Then
        assertTrue(result.isSuccess());
        assertNotNull(result.getData());
        assertEquals("msg-001", result.getData().getId());
    }

    @Test
    void testGetMessageById_NotFound() {
        // Given
        when(messageRepository.findByIdAndTenantId("msg-001", "tenant-001"))
                .thenReturn(Optional.empty());

        // When
        Result<MessageDTO> result = messageService.getMessageById("tenant-001", "msg-001");

        // Then
        assertFalse(result.isSuccess());
        assertEquals("消息不存在", result.getMessage());
    }

    @Test
    void testGetMessages_Success() {
        // Given
        List<Message> messages = Arrays.asList(testMessage);
        Page<Message> page = new PageImpl<>(messages);
        when(messageRepository.findByTenantId(eq("tenant-001"), any(Pageable.class)))
                .thenReturn(page);

        // When
        Result<PageResult<MessageDTO>> result = messageService.getMessages("tenant-001", 1, 10);

        // Then
        assertTrue(result.isSuccess());
        assertNotNull(result.getData());
        assertEquals(1, result.getData().getRecords().size());
        assertEquals("msg-001", result.getData().getRecords().get(0).getId());
    }

    @Test
    void testRecallMessage_Success() {
        // Given
        when(messageRepository.findByIdAndTenantId("msg-001", "tenant-001"))
                .thenReturn(Optional.of(testMessage));
        when(messageRepository.save(any(Message.class))).thenReturn(testMessage);

        // When
        Result<Void> result = messageService.recallMessage("tenant-001", "msg-001");

        // Then
        assertTrue(result.isSuccess());
        verify(messageRepository).save(testMessage);
        assertEquals(MessageStatus.RECALLED, testMessage.getStatus());
    }

    @Test
    void testUpdateMessageStatus_Success() {
        // Given
        when(messageRepository.findByIdAndTenantId("msg-001", "tenant-001"))
                .thenReturn(Optional.of(testMessage));
        when(messageRepository.save(any(Message.class))).thenReturn(testMessage);

        // When
        Result<Void> result = messageService.updateMessageStatus("tenant-001", "msg-001", MessageStatus.SENT);

        // Then
        assertTrue(result.isSuccess());
        assertEquals(MessageStatus.SENT, testMessage.getStatus());
        verify(messageRepository).save(testMessage);
    }

    @Test
    void testGetMessageStatistics_Success() {
        // Given
        when(messageRepository.countByTenantIdAndStatus("tenant-001", MessageStatus.SENT)).thenReturn(10L);
        when(messageRepository.countByTenantIdAndStatus("tenant-001", MessageStatus.FAILED)).thenReturn(2L);
        when(messageRepository.countByTenantId("tenant-001")).thenReturn(12L);

        // When
        Result<MessageStatisticsDTO> result = messageService.getMessageStatistics("tenant-001");

        // Then
        assertTrue(result.isSuccess());
        assertNotNull(result.getData());
        assertEquals(10L, result.getData().getSentCount());
        assertEquals(2L, result.getData().getFailedCount());
        assertEquals(12L, result.getData().getTotalCount());
    }

    @Test
    void testDeleteMessage_Success() {
        // Given
        when(messageRepository.findByIdAndTenantId("msg-001", "tenant-001"))
                .thenReturn(Optional.of(testMessage));

        // When
        Result<Void> result = messageService.deleteMessage("tenant-001", "msg-001");

        // Then
        assertTrue(result.isSuccess());
        verify(messageRepository).delete(testMessage);
    }
}