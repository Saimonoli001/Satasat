package com.satasat.model;
import java.sql.Timestamp;


public class Session {
    private int id, requestId, requesterId, receiverId;
    private Timestamp scheduledDate, completedAt, createdAt;
    private String notes, status;
    private String requesterName, receiverName, offeredSkillTitle, requestedSkillTitle;
    private boolean reviewedByRequester, reviewedByReceiver;

    public Session() {}
    public int getId() { return id; }
    public void setId(int v) { this.id = v; }
    public int getRequestId() { return requestId; }
    public void setRequestId(int v) { this.requestId = v; }
    public int getRequesterId() { return requesterId; }
    public void setRequesterId(int v) { this.requesterId = v; }
    public int getReceiverId() { return receiverId; }
    public void setReceiverId(int v) { this.receiverId = v; }
    public Timestamp getScheduledDate() { return scheduledDate; }
    public void setScheduledDate(Timestamp v) { this.scheduledDate = v; }
    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp v) { this.completedAt = v; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp v) { this.createdAt = v; }
    public String getNotes() { return notes; }
    public void setNotes(String v) { this.notes = v; }
    public String getStatus() { return status; }
    public void setStatus(String v) { this.status = v; }
    public String getRequesterName() { return requesterName; }
    public void setRequesterName(String v) { this.requesterName = v; }
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String v) { this.receiverName = v; }
    public String getOfferedSkillTitle() { return offeredSkillTitle; }
    public void setOfferedSkillTitle(String v) { this.offeredSkillTitle = v; }
    public String getRequestedSkillTitle() { return requestedSkillTitle; }
    public void setRequestedSkillTitle(String v) { this.requestedSkillTitle = v; }
    public boolean isReviewedByRequester() { return reviewedByRequester; }
    public void setReviewedByRequester(boolean v) { this.reviewedByRequester = v; }
    public boolean isReviewedByReceiver() { return reviewedByReceiver; }
    public void setReviewedByReceiver(boolean v) { this.reviewedByReceiver = v; }
}
