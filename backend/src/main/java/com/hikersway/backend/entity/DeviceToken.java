package com.hikersway.backend.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import java.time.LocalDateTime;

/**
 * A Firebase Cloud Messaging registration token for one app instance (a
 * browser or a phone). Used to push announcement notifications to every
 * logged-in user, even when the app is closed. Keyed by the token itself so
 * re-registering the same device is an idempotent upsert.
 */
@Entity
public class DeviceToken {

    @Id
    private String token;

    /** The account email this token was last seen for (may be null for guests). */
    private String email;

    /** "web" or "android" — informational, useful for debugging delivery. */
    private String platform;

    private LocalDateTime updatedAt;

    protected DeviceToken() {
    }

    public DeviceToken(String token, String email, String platform, LocalDateTime updatedAt) {
        this.token = token;
        this.email = email;
        this.platform = platform;
        this.updatedAt = updatedAt;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
