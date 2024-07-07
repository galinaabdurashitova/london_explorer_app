package org.example.api_attractions.model;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "category")
public class Category {
    @Id
    @Column(name = "category_id")
    private String id;

    @Column(name = "category_name", nullable = false, length = 64)
    private String name;

    // Constructors
    public Category() {
        // Empty constructor needed for JPA
    }

    public Category(String id, String name) {
        this.id = id;
        this.name = name;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) { this.id = id; }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
