package com.hikersway.backend.controller;

import com.hikersway.backend.entity.Town;
import com.hikersway.backend.repository.TownRepository;
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
@RequestMapping("/api/towns")
public class TownController {

    private final TownRepository repository;

    public TownController(TownRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Town> list() {
        return repository.findAll();
    }

    @PutMapping("/{id}")
    public Town upsert(@PathVariable String id, @RequestBody Town town) {
        town.setId(id);
        return repository.save(town);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
