package org.example.api_users.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.sql.Timestamp;

@Entity
@Table(name = "user_awards")
public class UserAward {
    @Id
    @Column(name = "user_award_id", length = 36)
    private String userAwardId;
    
    @JsonIgnore
    @Column(name = "user_id", length = 28, nullable = false)
    private String userId;

    @Column(name = "award", length = 64, nullable = false)
    private String award;

    @Column(name = "award_level", nullable = false)
    private int awardLevel;

    @Column(name = "award_date", nullable = false)
    private Timestamp awardDate;

    public UserAward() {
        // Empty constructor needed for JPA
    }

    public UserAward(String userAwardId, String userId, String award, int awardLevel, Timestamp awardDate) {
        this.userAwardId = userAwardId;
        this.userId = userId;
        this.award = award;
        this.awardLevel = awardLevel;
        this.awardDate = awardDate;
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

    public String getAward() {
        return award;
    }

    public void setAward(String award) {
        this.award = award;
    }

    public int getAwardLevel() {
        return awardLevel;
    }

    public void setAwardLevel(int awardLevel) {
        this.awardLevel = awardLevel;
    }

    public Timestamp getAwardDate() {
        return awardDate;
    }

    public void setAwardDateDate(Timestamp awardDate) {
        this.awardDate = awardDate;
    }
}
