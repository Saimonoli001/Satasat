package com.satasat.model;
import java.sql.Timestamp;


public class User {
    private int id;
    private String fullName, email, passwordHash, bio, profileImage, location, role, status;
    private double avgRating;
    private int totalReviews;
    private Timestamp createdAt, updatedAt;

    public User() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFullName() { return fullName; }
    public void setFullName(String v) { this.fullName = v; }
    public String getEmail() { return email; }
    public void setEmail(String v) { this.email = v; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String v) { this.passwordHash = v; }
    public String getBio() { return bio; }
    public void setBio(String v) { this.bio = v; }
    public String getProfileImage() { return (profileImage!=null&&!profileImage.isEmpty()) ? profileImage : "default.png"; }
    public void setProfileImage(String v) { this.profileImage = v; }
    public String getLocation() { return location; }
    public void setLocation(String v) { this.location = v; }
    public String getRole() { return role; }
    public void setRole(String v) { this.role = v; }
    public String getStatus() { return status; }
    public void setStatus(String v) { this.status = v; }
    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double v) { this.avgRating = v; }
    public int getTotalReviews() { return totalReviews; }
    public void setTotalReviews(int v) { this.totalReviews = v; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp v) { this.createdAt = v; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp v) { this.updatedAt = v; }

    public boolean isAdmin()  { return "ADMIN".equals(role); }
    public boolean isActive() { return "ACTIVE".equals(status); }
    public String getFirstName() {
        if (fullName == null) return "";
        int sp = fullName.indexOf(' ');
        return sp > 0 ? fullName.substring(0, sp) : fullName;
    }
}
