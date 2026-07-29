package com.hikersway.backend.controller;

import com.hikersway.backend.entity.UpcomingHike;
import com.hikersway.backend.repository.UpcomingHikeRepository;
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
@RequestMapping("/api/upcoming-hikes")
public class UpcomingHikeController {

    private final UpcomingHikeRepository repository;

    public UpcomingHikeController(UpcomingHikeRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<UpcomingHike> list() {
        return repository.findAll();
    }

    @PutMapping("/{id}")
    public UpcomingHike upsert(@PathVariable String id, @RequestBody UpcomingHike hike) {
        hike.setId(id);
        return repository.save(hike);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
