package com.hikersway.backend.controller;

import com.hikersway.backend.entity.Account;
import com.hikersway.backend.repository.AccountRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AccountRepository repository;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public AuthController(AccountRepository repository) {
        this.repository = repository;
    }

    public record Credentials(String email, String password) {
    }

    public record AuthResult(String result) {
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResult> register(@RequestBody Credentials credentials) {
        String email = credentials.email().trim().toLowerCase();
        if (repository.existsById(email)) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(new AuthResult("emailTaken"));
        }
        Account account = new Account(email, encoder.encode(credentials.password()));
        repository.save(account);
        return ResponseEntity.ok(new AuthResult("success"));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResult> login(@RequestBody Credentials credentials) {
        String email = credentials.email().trim().toLowerCase();
        Account account = repository.findById(email).orElse(null);
        if (account == null || !encoder.matches(credentials.password(), account.getPasswordHash())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new AuthResult("invalidCredentials"));
        }
        return ResponseEntity.ok(new AuthResult("success"));
    }
}
