package org.example.api_routes.model;

import jakarta.persistence.*;

@Entity
@Table(name = "route_saves")
public class RouteSave {

    @Id
    @Column(name = "route_saves_id", length = 36)
    private String routeSavesId;

    @Column(name = "route_id", nullable = false, length = 36)
    private String routeId;

    @Column(name = "user_id", length = 28, nullable = false)
    private String userId;

    public RouteSave() {
        // Empty constructor needed for JPA
    }

    public RouteSave(String routeSavesId, String routeId, String userId) {
        this.routeSavesId = routeSavesId;
        this.routeId = routeId;
        this.userId = userId;
    }

    public String getRouteSavesId() { return routeSavesId; }
    public void setRouteSavesId(String routeSavesId) { this.routeSavesId = routeSavesId; }

    public String getRouteId() { return routeId; }
    public void setRouteId(String routeId) { this.routeId = routeId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
}
