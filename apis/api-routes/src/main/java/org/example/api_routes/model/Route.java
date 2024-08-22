package org.example.api_routes.model;

import jakarta.persistence.*;

import java.sql.Timestamp;

@Entity
@Table(name = "route")
public class Route {
    @Id
    @Column(name = "route_id", length = 36)
    private String routeId;

    @Column(name = "date_created", nullable = false)
    private Timestamp dateCreated;

    @Column(name = "user_created", nullable = false, length = 28)
    private String userCreated;

    @Column(name = "route_name", nullable = false, length = 64)
    private String routeName;

    @Column(name = "route_description", columnDefinition = "TEXT")
    private String routeDescription;

    @Column(name = "route_time", nullable = false)
    private int routeTime;

    @Column(name = "date_published", nullable = false)
    private Timestamp datePublished;

    public Route() {
        // Empty constructor needed for JPA
    }

    public Route(String routeId, Timestamp dateCreated, String userCreated, String routeName,
                 String routeDescription, int routeTime, Timestamp datePublished) {
        this.routeId = routeId;
        this.dateCreated = dateCreated;
        this.userCreated = userCreated;
        this.routeName = routeName;
        this.routeDescription = routeDescription;
        this.routeTime = routeTime;
        this.datePublished = datePublished;
    }

    public String getRouteId() { return routeId; }
    public void setRouteId(String routeId) { this.routeId = routeId; }

    public Timestamp getDateCreated() { return dateCreated; }
    public void setDateCreated(Timestamp dateCreated) { this.dateCreated = dateCreated; }

    public String getUserCreated() { return userCreated; }
    public void setUserCreated(String userCreated) { this.userCreated = userCreated; }

    public String getRouteName() { return routeName; }
    public void setRouteName(String routeName) { this.routeName = routeName; }

    public String getRouteDescription() { return routeDescription; }
    public void setRouteDescription(String routeDescription) { this.routeDescription = routeDescription; }

    public int getRouteTime() {  return routeTime; }
    public void setRouteTime(int routeTime) { this.routeTime = routeTime; }

    public Timestamp getDatePublished() { return datePublished; }
    public void setDatePublished(Timestamp datePublished) { this.datePublished = datePublished; }
}
