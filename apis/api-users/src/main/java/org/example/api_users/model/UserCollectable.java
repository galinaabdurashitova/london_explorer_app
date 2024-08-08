package org.example.api_users.model;

import jakarta.persistence.*;

@Entity
@Table(name = "user_collectables")
public class UserCollectable {
    @Id
    @Column(name = "user_collectable_id", length = 16)
    private String userCollectableId;

    @Column(name = "user_id", length = 28, nullable = false)
    private String userId;

    @Column(name = "collectable_id", length = 16, nullable = false)
    private String collectableId;

    public UserCollectable() {
        // Empty constructor needed for JPA
    }

    public UserCollectable(String userCollectableId, String userId, String collectableId) {
        this.userCollectableId = userCollectableId;
        this.userId = userId;
        this.collectableId = collectableId;
    }

    // Getters and Setters

    public String getUserCollectableId() {
        return userCollectableId;
    }

    public void setUserCollectableId(String userCollectableId) {
        this.userCollectableId = userCollectableId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getCollectableId() {
        return collectableId;
    }

    public void setCollectableId(String collectableId) {
        this.collectableId = collectableId;
    }
}
