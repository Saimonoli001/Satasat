package com.satasat.model;
import java.sql.Timestamp;

/** Maps to reviews table. */
public class Review {
    private int id, sessionId, reviewerId, revieweeId, rating;
    private String comment;
    private Timestamp createdAt;
    private String reviewerName, reviewerImage;

    public Review() {}
    public int getId() { return id; }
    public void setId(int v) { this.id = v; }
    public int getSessionId() { return sessionId; }
    public void setSessionId(int v) { this.sessionId = v; }
    public int getReviewerId() { return reviewerId; }
    public void setReviewerId(int v) { this.reviewerId = v; }
    public int getRevieweeId() { return revieweeId; }
    public void setRevieweeId(int v) { this.revieweeId = v; }
    public int getRating() { return rating; }
    public void setRating(int v) { this.rating = v; }
    public String getComment() { return comment; }
    public void setComment(String v) { this.comment = v; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp v) { this.createdAt = v; }
    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String v) { this.reviewerName = v; }
    public String getReviewerImage() { return reviewerImage!=null?reviewerImage:"default.png"; }
    public void setReviewerImage(String v) { this.reviewerImage = v; }
}
