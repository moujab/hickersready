package com.hikersway.backend.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import java.time.LocalDateTime;

/**
 * A broadcast reminder/notification written by an admin and shown to every
 * logged-in user (in-app). Inactive announcements are kept in the database
 * but hidden from the notification bell.
 */
@Entity
public class Announcement {

    @Id
    private String id;

    private String title;

    @Lob
    private String message;

    private LocalDateTime createdAt;

    private boolean active;

    protected Announcement() {
    }

    public Announcement(String id, String title, String message, LocalDateTime createdAt, boolean active) {
        this.id = id;
        this.title = title;
        this.message = message;
        this.createdAt = createdAt;
        this.active = active;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
