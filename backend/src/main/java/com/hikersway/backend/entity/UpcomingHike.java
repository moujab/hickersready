package com.hikersway.backend.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import java.time.LocalDateTime;

@Entity
public class UpcomingHike {

    @Id
    private String id;

    private String trailName;

    private LocalDateTime date;

    @Lob
    private String description;

    protected UpcomingHike() {
    }

    public UpcomingHike(String id, String trailName, LocalDateTime date, String description) {
        this.id = id;
        this.trailName = trailName;
        this.date = date;
        this.description = description;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTrailName() {
        return trailName;
    }

    public void setTrailName(String trailName) {
        this.trailName = trailName;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
