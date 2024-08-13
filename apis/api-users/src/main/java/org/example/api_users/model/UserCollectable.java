package org.example.api_users.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "user_collectables")
public class UserCollectable {
    @Id
    @Column(name = "user_collectable_id", length = 36)
    private String userCollectableId;

    @JsonIgnore
    @Column(name = "user_id", length = 28, nullable = false)
    private String userId;

    @Column(name = "collectable", length = 64, nullable = false)
    private String collectable;

    @Column(name = "finished_route_id", length = 36, nullable = false)
    private String finishedRouteId;

    public UserCollectable() {
        // Empty constructor needed for JPA
    }

    public UserCollectable(String userCollectableId, String userId, String collectable, String finishedRouteId) {
        this.userCollectableId = userCollectableId;
        this.userId = userId;
        this.collectable = collectable;
        this.finishedRouteId = finishedRouteId;
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

    public String getCollectable() {
        return collectable;
    }

    public void setCollectable(String collectable) {
        this.collectable = collectable;
    }

    public String getFinishedRouteId() {
        return finishedRouteId;
    }

    public void setFinishedRouteId(String finishedRouteId) {
        this.finishedRouteId = finishedRouteId;
    }
}
