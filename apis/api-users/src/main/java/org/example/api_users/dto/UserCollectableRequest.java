package org.example.api_users.dto;

public class UserCollectableRequest {
    private String userCollectableId;
    private String collectable;

    // Getters and Setters

    public String getUserCollectableId() {
        return userCollectableId;
    }

    public void setUserCollectableId(String userCollectableId) {
        this.userCollectableId = userCollectableId;
    }

    public String getCollectable() {
        return collectable;
    }

    public void setCollectable(String collectable) {
        this.collectable = collectable;
    }
}
