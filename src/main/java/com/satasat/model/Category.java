package com.satasat.model;
import java.sql.Timestamp;

/** Maps to categories table. */
public class Category {
    private int id;
    private String name, description, icon;
    private boolean active;
    private Timestamp createdAt;

    public Category() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String v) { this.name = v; }
    public String getDescription() { return description; }
    public void setDescription(String v) { this.description = v; }
    public String getIcon() { return icon != null ? icon : "fas fa-star"; }
    public void setIcon(String v) { this.icon = v; }
    public boolean isActive() { return active; }
    public void setActive(boolean v) { this.active = v; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp v) { this.createdAt = v; }
}
