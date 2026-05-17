package com.satasat.model;
import java.sql.Timestamp;

/** Maps to barter_requests table. */
public class BarterRequest {
    private int id, requesterId, receiverId, offeredSkillId, requestedSkillId;
    private String message, counterMessage, status;
    private Timestamp createdAt, updatedAt;
    // Joined
    private String requesterName, requesterImage, receiverName, receiverImage;
    private String offeredSkillTitle, requestedSkillTitle;

    public BarterRequest() {}
    public int getId() { return id; }
    public void setId(int v) { this.id = v; }
    public int getRequesterId() { return requesterId; }
    public void setRequesterId(int v) { this.requesterId = v; }
    public int getReceiverId() { return receiverId; }
    public void setReceiverId(int v) { this.receiverId = v; }
    public int getOfferedSkillId() { return offeredSkillId; }
    public void setOfferedSkillId(int v) { this.offeredSkillId = v; }
    public int getRequestedSkillId() { return requestedSkillId; }
    public void setRequestedSkillId(int v) { this.requestedSkillId = v; }
    public String getMessage() { return message; }
    public void setMessage(String v) { this.message = v; }
    public String getCounterMessage() { return counterMessage; }
    public void setCounterMessage(String v) { this.counterMessage = v; }
    public String getStatus() { return status; }
    public void setStatus(String v) { this.status = v; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp v) { this.createdAt = v; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp v) { this.updatedAt = v; }
    public String getRequesterName() { return requesterName; }
    public void setRequesterName(String v) { this.requesterName = v; }
    public String getRequesterImage() { return requesterImage!=null?requesterImage:"default.png"; }
    public void setRequesterImage(String v) { this.requesterImage = v; }
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String v) { this.receiverName = v; }
    public String getReceiverImage() { return receiverImage!=null?receiverImage:"default.png"; }
    public void setReceiverImage(String v) { this.receiverImage = v; }
    public String getOfferedSkillTitle() { return offeredSkillTitle; }
    public void setOfferedSkillTitle(String v) { this.offeredSkillTitle = v; }
    public String getRequestedSkillTitle() { return requestedSkillTitle; }
    public void setRequestedSkillTitle(String v) { this.requestedSkillTitle = v; }
}
