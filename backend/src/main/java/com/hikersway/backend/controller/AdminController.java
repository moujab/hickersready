package com.hikersway.backend.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Value("${hikersway.admin-pin:1234}")
    private String adminPin;

    public record PinRequest(String pin) {
    }

    @PostMapping("/login")
    public ResponseEntity<Void> login(@RequestBody PinRequest request) {
        if (adminPin.equals(request.pin())) {
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
}
