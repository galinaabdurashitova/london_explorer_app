package org.example.api_users.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "finished_routes")
public class FinishedRoute {
    @Id
    @Column(name = "finished_route_id", length = 16)
    private String finishedRouteId;

    @JsonIgnore
    @Column(name = "user_id", length = 28, nullable = false)
    private String userId;

    @Column(name = "route_id", length = 16, nullable = false)
    private String routeId;

    @Column(name = "finished_day")
    private Timestamp finishedDate;

    @Column(name = "collectables")
    private int collectables;

    public FinishedRoute() {
        // Empty constructor needed for JPA
    }

    public FinishedRoute(String finishedRouteId, String userId, String routeId, Timestamp finishedDate, int collectables) {
        this.finishedRouteId = finishedRouteId;
        this.userId = userId;
        this.routeId = routeId;
        this.finishedDate = finishedDate;
        this.collectables = collectables;
    }

    // Getters and Setters

    public String getFinishedRouteId() {
        return finishedRouteId;
    }

    public void setFinishedRouteId(String finishedRouteId) {
        this.finishedRouteId = finishedRouteId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getRouteId() {
        return routeId;
    }

    public void setRouteId(String routeId) {
        this.routeId = routeId;
    }

    public Timestamp getFinishedDate() {
        return finishedDate;
    }

    public void setFinishedDate(Timestamp finishedDate) {
        this.finishedDate = finishedDate;
    }

    public int getCollectables() {
        return collectables;
    }

    public void setCollectables(int collectables) {
        this.collectables = collectables;
    }
}
