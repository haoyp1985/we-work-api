package com.wework.platform.message.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wework.platform.common.dto.PageResult;
import com.wework.platform.common.dto.Result;
import com.wework.platform.common.enums.MessageStatus;
import com.wework.platform.common.enums.MessageType;
import com.wework.platform.message.dto.MessageDTO;
import com.wework.platform.message.dto.MessageStatisticsDTO;
import com.wework.platform.message.dto.SendMessageRequest;
import com.wework.platform.message.service.MessageService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.Arrays;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * 消息控制器测试类
 *
 * @author WeWork Platform
 * @since 2.0.0
 */
@WebMvcTest(MessageController.class)
class MessageControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private MessageService messageService;

    @Autowired
    private ObjectMapper objectMapper;

    private MessageDTO testMessageDTO;
    private SendMessageRequest sendRequest;

    @BeforeEach
    void setUp() {
        testMessageDTO = new MessageDTO();
        testMessageDTO.setId("msg-001");
        testMessageDTO.setTenantId("tenant-001");
        testMessageDTO.setAccountId("account-001");
        testMessageDTO.setType(MessageType.TEXT);
        testMessageDTO.setContent("测试消息");
        testMessageDTO.setRecipient("user@example.com");
        testMessageDTO.setStatus(MessageStatus.PENDING);
        testMessageDTO.setCreatedAt(LocalDateTime.now());

        sendRequest = new SendMessageRequest();
        sendRequest.setAccountId("account-001");
        sendRequest.setType(MessageType.TEXT);
        sendRequest.setContent("测试消息");
        sendRequest.setRecipient("user@example.com");
    }

    @Test
    void testSendMessage() throws Exception {
        // Given
        when(messageService.sendMessage(eq("tenant-001"), any(SendMessageRequest.class)))
                .thenReturn(Result.success(testMessageDTO));

        // When & Then
        mockMvc.perform(post("/api/v1/messages")
                        .header("X-Tenant-Id", "tenant-001")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(sendRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data.id").value("msg-001"))
                .andExpect(jsonPath("$.data.content").value("测试消息"));
    }

    @Test
    void testGetMessages() throws Exception {
        // Given
        PageResult<MessageDTO> pageResult = new PageResult<>();
        pageResult.setRecords(Arrays.asList(testMessageDTO));
        pageResult.setTotal(1L);
        pageResult.setPageNum(1);
        pageResult.setPageSize(10);

        when(messageService.getMessages(eq("tenant-001"), eq(1), eq(10)))
                .thenReturn(Result.success(pageResult));

        // When & Then
        mockMvc.perform(get("/api/v1/messages")
                        .header("X-Tenant-Id", "tenant-001")
                        .param("pageNum", "1")
                        .param("pageSize", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data.records[0].id").value("msg-001"));
    }

    @Test
    void testGetMessage() throws Exception {
        // Given
        when(messageService.getMessageById("tenant-001", "msg-001"))
                .thenReturn(Result.success(testMessageDTO));

        // When & Then
        mockMvc.perform(get("/api/v1/messages/msg-001")
                        .header("X-Tenant-Id", "tenant-001"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data.id").value("msg-001"));
    }

    @Test
    void testRecallMessage() throws Exception {
        // Given
        when(messageService.recallMessage("tenant-001", "msg-001"))
                .thenReturn(Result.success());

        // When & Then
        mockMvc.perform(post("/api/v1/messages/msg-001/recall")
                        .header("X-Tenant-Id", "tenant-001"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200));
    }

    @Test
    void testUpdateMessageStatus() throws Exception {
        // Given
        when(messageService.updateMessageStatus("tenant-001", "msg-001", MessageStatus.SENT))
                .thenReturn(Result.success());

        // When & Then
        mockMvc.perform(patch("/api/v1/messages/msg-001/status")
                        .header("X-Tenant-Id", "tenant-001")
                        .param("status", "SENT"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200));
    }

    @Test
    void testGetMessageStatistics() throws Exception {
        // Given
        MessageStatisticsDTO statistics = new MessageStatisticsDTO();
        statistics.setTotalCount(100L);
        statistics.setSentCount(80L);
        statistics.setFailedCount(5L);
        statistics.setPendingCount(15L);

        when(messageService.getMessageStatistics("tenant-001"))
                .thenReturn(Result.success(statistics));

        // When & Then
        mockMvc.perform(get("/api/v1/messages/statistics")
                        .header("X-Tenant-Id", "tenant-001"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data.totalCount").value(100))
                .andExpect(jsonPath("$.data.sentCount").value(80));
    }

    @Test
    void testDeleteMessage() throws Exception {
        // Given
        when(messageService.deleteMessage("tenant-001", "msg-001"))
                .thenReturn(Result.success());

        // When & Then
        mockMvc.perform(delete("/api/v1/messages/msg-001")
                        .header("X-Tenant-Id", "tenant-001"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200));
    }
}