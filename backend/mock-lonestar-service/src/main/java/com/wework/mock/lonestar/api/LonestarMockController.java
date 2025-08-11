package com.wework.mock.lonestar.api;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;

@RestController
public class LonestarMockController {

    private static final String DEMO_GUID = "5b1eb388-a4df-3da5-a49a-507eea46632c";
    private static final List<String> GUIDS = new CopyOnWriteArrayList<>();

    static {
        GUIDS.add(DEMO_GUID);
    }

    @GetMapping(value = "/client/all_clients", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> allClients() {
        return Map.of("data", new ArrayList<>(GUIDS));
    }

    @PostMapping(value = "/client/get_client_status", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> getClientStatus(@RequestBody Map<String, String> body) {
        // 始终返回在线: status=2
        return Map.of("error_code", 0, "data", Map.of("status", 2));
    }

    @PostMapping(value = "/client/create_client", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> createClient(@RequestBody Map<String, Object> body) {
        String guid = UUID.randomUUID().toString();
        GUIDS.add(guid);
        return Map.of("error_code", 0, "error_message", "ok", "data", Map.of("guid", guid));
    }

    @PostMapping(value = "/client/set_notify_url", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> setNotifyUrl(@RequestBody Map<String, Object> body) {
        return Map.of("error_code", 0, "error_message", "ok", "data", Map.of());
    }

    @PostMapping(value = "/global/set_notify_url", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> setNotifyUrlGlobal(@RequestBody Map<String, Object> body) {
        return Map.of("error_code", 0, "error_message", "ok", "data", Map.of());
    }

    @PostMapping(value = "/client/set_bridge", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> setBridge(@RequestBody Map<String, Object> body) {
        return Map.of("error_code", 0, "error_message", "ok", "data", Map.of());
    }

    @PostMapping(value = "/client/get_login_qrcode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> getLoginQrcode(@RequestBody Map<String, Object> body) {
        Map<String, Object> data = new HashMap<>();
        data.put("qrcode", "MOCK_QR_CONTENT");
        data.put("expire_seconds", 120);
        return Map.of("error_code", 0, "error_message", "ok", "data", data);
    }

    @PostMapping(value = "/login/get_login_qrcode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> getLoginQrcodeLogin(@RequestBody Map<String, Object> body) {
        Map<String, Object> data = new HashMap<>();
        data.put("qrcode", "MOCK_QR_CONTENT");
        data.put("expire_seconds", 120);
        return Map.of("error_code", 0, "error_message", "ok", "data", data);
    }

    @PostMapping(value = "/login/query_login_status", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> queryLoginStatus(@RequestBody Map<String, Object> body) {
        // 直接返回已登录状态
        return Map.of("error_code", 0, "error_message", "ok", "data", Map.of("status", 2));
    }

    @PostMapping(value = "/session/get_session_list", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> getSessionList(@RequestBody Map<String, Object> body) {
        Map<String, Object> data = new HashMap<>();
        data.put("session_list", List.of("S:1688852792312821", "S:1688857160788209", "R:1970325468984112", "R:13102691282047519", "R:13102691536807585"));
        data.put("begin_seq", "1000123");
        return Map.of("error_code", 0, "error_message", "ok", "data", data);
    }

    @GetMapping(value = "/session/get_session_list", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> getSessionListGet() {
        Map<String, Object> data = new HashMap<>();
        data.put("session_list", List.of("S:1688852792312821", "S:1688857160788209", "R:1970325468984112", "R:13102691282047519", "R:13102691536807585"));
        data.put("begin_seq", "1000123");
        return Map.of("error_code", 0, "error_message", "ok", "data", data);
    }

    public static class SendTextRequest {
        public String guid;
        public String conversation_id;
        public String content;
        public String getGuid() { return guid; }
        public String getConversation_id() { return conversation_id; }
        public String getContent() { return content; }
        public void setGuid(String guid) { this.guid = guid; }
        public void setConversation_id(String conversation_id) { this.conversation_id = conversation_id; }
        public void setContent(String content) { this.content = content; }
    }

    @PostMapping(value = "/msg/send_text", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> sendText(@RequestBody SendTextRequest req) {
        if (req.getConversation_id() == null || req.getConversation_id().isBlank()) {
            return Map.of("error_code", -2003, "error_message", "head rsp code error, error_msg: ", "data", Map.of());
        }
        // 模拟权限不足错误
        if (!req.getConversation_id().startsWith("S:")) {
            return Map.of("error_code", -4017, "error_message", "head rsp code error, error_msg: 对方无外部联系人权限，发送消息失败", "data", Map.of());
        }
        Map<String, Object> msgData = new LinkedHashMap<>();
        msgData.put("id", "1000127");
        msgData.put("seq", "14303419");
        msgData.put("messagetype", 0);
        msgData.put("sender", "1688856214724417");
        msgData.put("receiver", req.getConversation_id());
        msgData.put("roomid", "0");
        msgData.put("contenttype", 2);
        msgData.put("content", "ChgIABIUChLmtYvor5XkuIDmnaHmtojmga8=");
        msgData.put("sendtime", System.currentTimeMillis() / 1000);
        msgData.put("flag", 0);
        msgData.put("devinfo", "131075");
        msgData.put("appinfo", "Q0FVUTZjbWl4QVlZNk9qeC9JdldyS3NZSVBUcWdQQUw=");
        msgData.put("sendername", "6YOd5rC45bmz");
        msgData.put("extra_content", "oj8IuAGS3ZCuhTOqvgFfCiBuArKOQkqHqRjIxABCtsSRByJbhxlBNIfNjBtxQryA8hACGjkI6cmixAYQARogQ0FVUTZjbWl4QVlZNk9qeC9JdldyS3NZSVBUcWdQQUwiAhAAMMG+hdaXgIADOAE=");
        msgData.put("asid", "0");
        Map<String, Object> data = Map.of("msg_data", msgData, "is_svr_fail", false);
        return Map.of("error_code", 0, "error_message", "ok", "data", data);
    }
}


