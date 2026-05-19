package com.satasat.model;
import java.sql.Timestamp;


public class Skill {
    private int id, userId, categoryId, viewCount;
    private String title, description, skillLevel, availability;
    private boolean active;
    private Timestamp createdAt, updatedAt;
    
    private String userName, userProfileImage, categoryName, categoryIcon;
    private double userAvgRating;

    public Skill() {}
    public int getId() { return id; }
    public void setId(int v) { this.id = v; }
    public int getUserId() { return userId; }
    public void setUserId(int v) { this.userId = v; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int v) { this.categoryId = v; }
    public int getViewCount() { return viewCount; }
    public void setViewCount(int v) { this.viewCount = v; }
    public String getTitle() { return title; }
    public void setTitle(String v) { this.title = v; }
    public String getDescription() { return description; }
    public void setDescription(String v) { this.description = v; }
    public String getSkillLevel() { return skillLevel; }
    public void setSkillLevel(String v) { this.skillLevel = v; }
    public String getAvailability() { return availability; }
    public void setAvailability(String v) { this.availability = v; }
    public boolean isActive() { return active; }
    public void setActive(boolean v) { this.active = v; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp v) { this.createdAt = v; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp v) { this.updatedAt = v; }
    public String getUserName() { return userName; }
    public void setUserName(String v) { this.userName = v; }
    public String getUserProfileImage() { return userProfileImage!=null?userProfileImage:"default.png"; }
    public void setUserProfileImage(String v) { this.userProfileImage = v; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String v) { this.categoryName = v; }
    public String getCategoryIcon() { return categoryIcon!=null?categoryIcon:"fas fa-star"; }
    public void setCategoryIcon(String v) { this.categoryIcon = v; }
    public double getUserAvgRating() { return userAvgRating; }
    public void setUserAvgRating(double v) { this.userAvgRating = v; }
    
    public String getShortDescription() {
        if (description == null) return "";
        return description.length() > 110 ? description.substring(0, 110) + "…" : description;
    }
}
