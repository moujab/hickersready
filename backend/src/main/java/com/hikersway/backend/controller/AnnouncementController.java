package com.hikersway.backend.controller;

import com.hikersway.backend.entity.Announcement;
import com.hikersway.backend.repository.AnnouncementRepository;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Broadcast announcements ("reminders and messages") that every user with the
 * app sees in-app. Reads are open to all clients; writes are made by admins
 * (gated client-side by the admin PIN, consistent with the other
 * content controllers such as {@link TownController}).
 */
@RestController
@RequestMapping("/api/announcements")
public class AnnouncementController {

    private final AnnouncementRepository repository;

    public AnnouncementController(AnnouncementRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Announcement> list() {
        return repository.findAll();
    }

    @PutMapping("/{id}")
    public Announcement upsert(@PathVariable String id, @RequestBody Announcement announcement) {
        announcement.setId(id);
        if (announcement.getCreatedAt() == null) {
            announcement.setCreatedAt(LocalDateTime.now());
        }
        return repository.save(announcement);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
