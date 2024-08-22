package org.example.api_users.dto;

import java.sql.Timestamp;

public class UserAwardRequest {
    private String userAwardId;
    private String award;
    private int awardLevel;
    private Timestamp awardDate;

    public String getUserAwardId() {
        return userAwardId;
    }

    public void setUserAwardId(String userAwardId) {
        this.userAwardId = userAwardId;
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

    public void setAwardDate(Timestamp awardDate) {
        this.awardDate = awardDate;
    }
}
