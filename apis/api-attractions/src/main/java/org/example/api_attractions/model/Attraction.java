package org.example.api_attractions.model;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "attraction")
public class Attraction {
    @Id
    @Column(name = "attraction_id")
    private String id;

    @Column(name = "attraction_name", nullable = false)
    private String name;

    @Column(name = "short_description", nullable = false, length = 256)
    private String shortDescription;

    @Column(name = "full_description", nullable = false, columnDefinition = "TEXT")
    private String fullDescription;

    @Column(name = "address", nullable = false, length = 255)
    private String address;

    @Column(name = "latitude", columnDefinition = "NUMERIC(10, 7)")
    private double latitude;

    @Column(name = "longitude", columnDefinition = "NUMERIC(10, 7)")
    private double longitude;

    @ManyToMany
    @JoinTable(
            name = "attraction_categories",
            joinColumns = @JoinColumn(name = "attraction_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    private Set<Category> categories;

    // Constructors
    public Attraction() {
        // Empty constructor needed for JPA
    }

    public Attraction(String id, String name, String shortDescription, String fullDescription,
                      String address, double latitude, double longitude) {
        this.id = id;
        this.name = name;
        this.shortDescription = shortDescription;
        this.fullDescription = fullDescription;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getFullDescription() {
        return fullDescription;
    }

    public void setFullDescription(String fullDescription) {
        this.fullDescription = fullDescription;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public Set<Category> getCategories() {
        return categories;
    }

    public void setCategories(Set<Category> categories) {
        this.categories = categories;
    }
}
