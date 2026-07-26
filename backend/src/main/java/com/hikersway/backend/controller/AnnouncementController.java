package com.hikersway.backend.controller;

import com.hikersway.backend.entity.Announcement;
import com.hikersway.backend.repository.AnnouncementRepository;
import com.hikersway.backend.service.FcmPushService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/announcements")
public class AnnouncementController {

    private final AnnouncementRepository repository;
    private final FcmPushService pushService;

    public AnnouncementController(AnnouncementRepository repository, FcmPushService pushService) {
        this.repository = repository;
        this.pushService = pushService;
    }

    /** All announcements, newest first — used by the admin management screen. */
    @GetMapping
    public List<Announcement> list() {
        return repository.findAll(org.springframework.data.domain.Sort.by(
                org.springframework.data.domain.Sort.Direction.DESC, "createdAt"));
    }

    @PutMapping("/{id}")
    public Announcement upsert(@PathVariable String id, @RequestBody Announcement announcement) {
        announcement.setId(id);
        // Push only when a NEW active announcement is created — editing or
        // re-activating an existing one updates the bell without re-notifying
        // every device.
        boolean isNew = !repository.existsById(id);
        Announcement saved = repository.save(announcement);
        if (isNew && saved.isActive()) {
            pushService.sendToAll(saved.getTitle(), saved.getMessage());
        }
        return saved;
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
