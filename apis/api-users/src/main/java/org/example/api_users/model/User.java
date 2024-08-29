package org.example.api_users.model;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @Column(name = "user_id", length = 28)
    private String userId;

    @Column(name = "user_email", nullable = false, length = 64)
    private String email;

    @Column(name = "user_name", nullable = false, length = 64)
    private String name;

    @Column(name = "user_username", nullable = false, length = 16)
    private String userName;

    @Column(name = "user_description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "image_name", nullable = true, length = 264)
    private String imageName;

    public User() {
        // Empty constructor needed for JPA
    }

    public User(String userId, String email, String name, String userName, String description, String imageName) {
        this.userId = userId;
        this.email = email;
        this.name = name;
        this.userName = userName;
        this.description = description;
        this.imageName = imageName;
    }

    // Getters and Setters

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageName() { return imageName; }

    public void setImageName(String imageName) { this.imageName = imageName; }
}
