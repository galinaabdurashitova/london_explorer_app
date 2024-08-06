package org.example.api_users.model;

import jakarta.persistence.*;

@Entity
@Table(name = "user_awards")
public class UserAward {
    @Id
    @Column(name = "user_award_id", length = 16)
    private String userAwardId;

    @Column(name = "user_id", length = 28, nullable = false)
    private String userId;

    @Column(name = "award_id", length = 16, nullable = false)
    private String awardId;

    public UserAward() {
        // Empty constructor needed for JPA
    }

    public UserAward(String userAwardId, String userId, String awardId) {
        this.userAwardId = userAwardId;
        this.userId = userId;
        this.awardId = awardId;
    }

    // Getters and Setters

    public String getUserAwardId() {
        return userAwardId;
    }

    public void setUserAwardId(String userAwardId) {
        this.userAwardId = userAwardId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getAwardId() {
        return awardId;
    }

    public void setAwardId(String awardId) {
        this.awardId = awardId;
    }
}
