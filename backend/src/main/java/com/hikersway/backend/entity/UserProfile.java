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

    private String weatherCity;

    private Double weatherLat;

    private Double weatherLon;

    protected UserProfile() {
    }

    public UserProfile(String email, String name, String father, String family, String phone) {
        this(email, name, father, family, phone, null, null, null);
    }

    public UserProfile(String email, String name, String father, String family, String phone,
            String weatherCity, Double weatherLat, Double weatherLon) {
        this.email = email;
        this.name = name;
        this.father = father;
        this.family = family;
        this.phone = phone;
        this.weatherCity = weatherCity;
        this.weatherLat = weatherLat;
        this.weatherLon = weatherLon;
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

    public String getWeatherCity() {
        return weatherCity;
    }

    public void setWeatherCity(String weatherCity) {
        this.weatherCity = weatherCity;
    }

    public Double getWeatherLat() {
        return weatherLat;
    }

    public void setWeatherLat(Double weatherLat) {
        this.weatherLat = weatherLat;
    }

    public Double getWeatherLon() {
        return weatherLon;
    }

    public void setWeatherLon(Double weatherLon) {
        this.weatherLon = weatherLon;
    }
}
