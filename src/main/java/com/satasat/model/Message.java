package com.satasat.model;

import java.sql.Timestamp;

public class Message {
    private int id;
    private int requestId;
    private int senderId;
    private String senderName;
    private String senderImage;
    private String content;
    private Timestamp sentAt;

    public Message() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }
    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }
    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }
    public String getSenderImage() { return senderImage; }
    public void setSenderImage(String senderImage) { this.senderImage = senderImage; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Timestamp getSentAt() { return sentAt; }
    public void setSentAt(Timestamp sentAt) { this.sentAt = sentAt; }
}
