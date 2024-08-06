package org.example.api_users.model;

import jakarta.persistence.*;

@Entity
@Table(name = "favourite_routes")
public class FavouriteRoute {
    @Id
    @Column(name = "fav_route_id", length = 16)
    private String favRouteId;

    @Column(name = "user_id", length = 28, nullable = false)
    private String userId;

    @Column(name = "route_id", length = 16, nullable = false)
    private String routeId;

    public FavouriteRoute() {
        // Empty constructor needed for JPA
    }

    public FavouriteRoute(String favRouteId, String userId, String routeId) {
        this.favRouteId = favRouteId;
        this.userId = userId;
        this.routeId = routeId;
    }

    // Getters and Setters

    public String getFavRouteId() {
        return favRouteId;
    }

    public void setFavRouteId(String favRouteId) {
        this.favRouteId = favRouteId;
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
}
