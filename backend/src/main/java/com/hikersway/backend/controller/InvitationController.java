package com.hikersway.backend.controller;

import com.hikersway.backend.entity.Invitation;
import com.hikersway.backend.repository.InvitationRepository;
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
@RequestMapping("/api/invitations")
public class InvitationController {

    private final InvitationRepository repository;

    public InvitationController(InvitationRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Invitation> list() {
        return repository.findAll();
    }

    @PutMapping("/{id}")
    public Invitation upsert(@PathVariable String id, @RequestBody Invitation invitation) {
        invitation.setId(id);
        return repository.save(invitation);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
