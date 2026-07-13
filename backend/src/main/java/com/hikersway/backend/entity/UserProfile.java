package com.hikersway.backend.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class UserProfile {

    /** Keyed by the owning account's email. */
    @Id
    private String email;

    private String name;

    private String father;

    private String family;

    private String phone;

    protected UserProfile() {
    }

    public UserProfile(String email, String name, String father, String family, String phone) {
        this.email = email;
        this.name = name;
        this.father = father;
        this.family = family;
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFather() {
        return father;
    }

    public void setFather(String father) {
        this.father = father;
    }

    public String getFamily() {
        return family;
    }

    public void setFamily(String family) {
        this.family = family;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
