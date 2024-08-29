package org.example.api_routes.dto;

import java.sql.Timestamp;
import java.util.List;

public class RouteRequest {
    private String routeId;
    private Timestamp dateCreated;
    private String userCreated;
    private String routeName;
    private String routeDescription;
    private int routeTime;
    private Timestamp datePublished;
    private List<RouteStopRequest> stops;
    private List<RouteCollectableRequest> collectables;

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

    public List<RouteStopRequest> getStops() {
        return stops;
    }

    public void setStops(List<RouteStopRequest> stops) {
        this.stops = stops;
    }

    public List<RouteCollectableRequest> getCollectables() {
        return collectables;
    }

    public void setCollectables(List<RouteCollectableRequest> collectables) {
        this.collectables = collectables;
    }
}
