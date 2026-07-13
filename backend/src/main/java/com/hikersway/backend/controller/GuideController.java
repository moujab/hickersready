package com.hikersway.backend.controller;

import com.hikersway.backend.entity.Guide;
import com.hikersway.backend.repository.GuideRepository;
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
@RequestMapping("/api/guides")
public class GuideController {

    private final GuideRepository repository;

    public GuideController(GuideRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Guide> list() {
        return repository.findAll();
    }

    @PutMapping("/{id}")
    public Guide upsert(@PathVariable String id, @RequestBody Guide guide) {
        guide.setId(id);
        return repository.save(guide);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
