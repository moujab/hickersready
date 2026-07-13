package com.hikersway.backend.controller;

import com.hikersway.backend.entity.Contributor;
import com.hikersway.backend.repository.ContributorRepository;
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
@RequestMapping("/api/contributors")
public class ContributorController {

    private final ContributorRepository repository;

    public ContributorController(ContributorRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Contributor> list() {
        return repository.findAll();
    }

    @PutMapping("/{id}")
    public Contributor upsert(@PathVariable String id, @RequestBody Contributor contributor) {
        contributor.setId(id);
        return repository.save(contributor);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
