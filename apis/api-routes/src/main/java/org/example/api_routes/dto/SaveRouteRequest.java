package org.example.api_routes.dto;

import java.sql.Timestamp;

public class SaveRouteRequest {
    private String userId;
    private Timestamp saveDate;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Timestamp getSaveDate() {
        return saveDate;
    }

    public void setSaveDate(Timestamp saveDate) {
        this.saveDate = saveDate;
    }
}
