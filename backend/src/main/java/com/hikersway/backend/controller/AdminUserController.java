package com.hikersway.backend.controller;

import com.hikersway.backend.entity.Account;
import com.hikersway.backend.entity.UserProfile;
import com.hikersway.backend.repository.AccountRepository;
import com.hikersway.backend.repository.UserProfileRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Admin-only management of registered users (accounts + their profiles).
 * NOTE: like the rest of the app's admin CRUD, these routes are not
 * server-side authenticated — access is gated only by the client-side admin
 * PIN. This is a known stopgap until real backend admin auth exists.
 */
@RestController
@RequestMapping("/api/admin/users")
public class AdminUserController {

    private final AccountRepository accounts;
    private final UserProfileRepository profiles;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public AdminUserController(AccountRepository accounts, UserProfileRepository profiles) {
        this.accounts = accounts;
        this.profiles = profiles;
    }

    /** What the admin list/detail shows — never includes the password hash. */
    public record AdminUserView(String email, String name, String father, String family, String phone) {
    }

    /** Create/modify payload. On modify a blank/null password leaves it unchanged. */
    public record AdminUserUpsert(String email, String password, String name, String father, String family,
            String phone) {
    }

    @GetMapping
    public List<AdminUserView> list() {
        return accounts.findAll().stream().map(account -> {
            UserProfile profile = profiles.findById(account.getEmail()).orElse(null);
            if (profile == null) {
                return new AdminUserView(account.getEmail(), "", "", "", "");
            }
            return new AdminUserView(account.getEmail(), profile.getName(), profile.getFather(),
                    profile.getFamily(), profile.getPhone());
        }).toList();
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody AdminUserUpsert body) {
        String email = body.email().trim().toLowerCase();
        if (email.isEmpty() || body.password() == null || body.password().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        if (accounts.existsById(email)) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        accounts.save(new Account(email, encoder.encode(body.password())));
        profiles.save(new UserProfile(email, nz(body.name()), nz(body.father()), nz(body.family()), nz(body.phone())));
        return ResponseEntity.ok(view(email));
    }

    @PutMapping("/{email}")
    public ResponseEntity<?> update(@PathVariable String email, @RequestBody AdminUserUpsert body) {
        String key = email.trim().toLowerCase();
        Account account = accounts.findById(key).orElse(null);
        if (account == null) {
            return ResponseEntity.notFound().build();
        }
        if (body.password() != null && !body.password().isEmpty()) {
            account.setPasswordHash(encoder.encode(body.password()));
            accounts.save(account);
        }
        UserProfile profile = profiles.findById(key)
                .orElseGet(() -> new UserProfile(key, "", "", "", ""));
        profile.setName(nz(body.name()));
        profile.setFather(nz(body.father()));
        profile.setFamily(nz(body.family()));
        profile.setPhone(nz(body.phone()));
        profiles.save(profile);
        return ResponseEntity.ok(view(key));
    }

    @DeleteMapping("/{email}")
    public ResponseEntity<Void> delete(@PathVariable String email) {
        String key = email.trim().toLowerCase();
        accounts.deleteById(key);
        profiles.deleteById(key);
        return ResponseEntity.noContent().build();
    }

    private AdminUserView view(String email) {
        UserProfile p = profiles.findById(email).orElse(null);
        if (p == null) {
            return new AdminUserView(email, "", "", "", "");
        }
        return new AdminUserView(email, p.getName(), p.getFather(), p.getFamily(), p.getPhone());
    }

    private static String nz(String value) {
        return value == null ? "" : value.trim();
    }
}
