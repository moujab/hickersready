package com.hikersway.backend.controller;

import com.hikersway.backend.entity.UserProfile;
import com.hikersway.backend.repository.UserProfileRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/profile")
public class UserProfileController {

    private final UserProfileRepository repository;

    public UserProfileController(UserProfileRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/{email}")
    public UserProfile get(@PathVariable String email) {
        return repository.findById(email)
                .orElse(new UserProfile(email, "", "", "", ""));
    }

    @PutMapping("/{email}")
    public UserProfile upsert(@PathVariable String email, @RequestBody UserProfile profile) {
        profile.setEmail(email);
        return repository.save(profile);
    }
}
