package org.example.api_users.dto;

import java.sql.Timestamp;
import java.util.List;

public class FinishedRouteRequest {
    private String finishedRouteId;
    private String routeId;
    private double spentMinutes;
    private Timestamp finishedDate;
    private List<UserCollectableRequest> userCollectables;

    // Getters and Setters

    public String getFinishedRouteId() {
        return finishedRouteId;
    }

    public void setFinishedRouteId(String finishedRouteId) {
        this.finishedRouteId = finishedRouteId;
    }

    public String getRouteId() {
        return routeId;
    }

    public void setRouteId(String routeId) {
        this.routeId = routeId;
    }

    public double getSpentMinutes() {
        return spentMinutes;
    }

    public void setSpentMinutes(double spentMinutes) {
        this.spentMinutes = spentMinutes;
    }

    public Timestamp getFinishedDate() {
        return finishedDate;
    }

    public void setFinishedDate(Timestamp finishedDate) {
        this.finishedDate = finishedDate;
    }

    public List<UserCollectableRequest> getUserCollectables() {
        return userCollectables;
    }

    public void setUserCollectables(List<UserCollectableRequest> userCollectables) {
        this.userCollectables = userCollectables;
    }
}