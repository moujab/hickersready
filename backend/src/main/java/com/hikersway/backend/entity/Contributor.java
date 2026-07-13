package com.hikersway.backend.entity;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Contributor {

    @Id
    private String id;

    private String businessName;

    private String category;

    @Lob
    private String description;

    private String contactPhone;

    @ElementCollection
    @CollectionTable(name = "contributor_image_urls", joinColumns = @jakarta.persistence.JoinColumn(name = "contributor_id"))
    @Column(name = "url")
    private List<String> productImageUrls = new ArrayList<>();

    protected Contributor() {
    }

    public Contributor(String id, String businessName, String category, String description,
            String contactPhone, List<String> productImageUrls) {
        this.id = id;
        this.businessName = businessName;
        this.category = category;
        this.description = description;
        this.contactPhone = contactPhone;
        this.productImageUrls = productImageUrls != null ? productImageUrls : new ArrayList<>();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public List<String> getProductImageUrls() {
        return productImageUrls;
    }

    public void setProductImageUrls(List<String> productImageUrls) {
        this.productImageUrls = productImageUrls;
    }
}
