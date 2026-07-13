package com.hikersway.backend.controller;

import com.hikersway.backend.entity.UpcomingHike;
import com.hikersway.backend.repository.UpcomingHikeRepository;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
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
}
