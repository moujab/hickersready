package com.hikersway.backend.controller;

import com.hikersway.backend.entity.DeviceToken;
import com.hikersway.backend.repository.DeviceTokenRepository;
import java.time.LocalDateTime;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Registers Firebase Cloud Messaging tokens so the backend can push
 * announcement notifications to every app instance.
 */
@RestController
@RequestMapping("/api/device-tokens")
public class DeviceTokenController {

    private final DeviceTokenRepository repository;

    public DeviceTokenController(DeviceTokenRepository repository) {
        this.repository = repository;
    }

    /** Idempotent upsert — the client posts its current token on every launch. */
    @PostMapping
    public ResponseEntity<Void> register(@RequestBody Map<String, String> body) {
        final String token = body.get("token");
        if (token == null || token.isBlank()) {
            return ResponseEntity.badRequest().build();
        }
        repository.save(new DeviceToken(
                token,
                body.get("email"),
                body.get("platform"),
                LocalDateTime.now()));
        return ResponseEntity.noContent().build();
    }

    /** Called when a token becomes invalid or the user logs out on a device. */
    @DeleteMapping("/{token}")
    public ResponseEntity<Void> delete(@PathVariable String token) {
        repository.deleteById(token);
        return ResponseEntity.noContent().build();
    }
}
