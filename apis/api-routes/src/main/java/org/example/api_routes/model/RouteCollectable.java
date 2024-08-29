package org.example.api_routes.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "route_collectables")
public class RouteCollectable {
    @Id
    @Column(name = "route_collectable_id", length = 36)
    private String routeCollectableId;

    @JsonIgnore
    @Column(name = "route_id", nullable = false, length = 36)
    private String routeId;

    @Column(name = "collectable", length = 64, nullable = false)
    private String collectable;

    @Column(name = "latitude", columnDefinition = "NUMERIC(10, 7)", nullable = false)
    private double latitude;

    @Column(name = "longitude", columnDefinition = "NUMERIC(10, 7)", nullable = false)
    private double longitude;

    public RouteCollectable() {
        // Empty constructor needed for JPA
    }

    public RouteCollectable(String routeCollectableId, String routeId, String collectable, double latitude, double longitude) {
        this.routeCollectableId = routeCollectableId;
        this.routeId = routeId;
        this.collectable = collectable;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public String getRouteCollectableId() { return routeCollectableId;  }
    public void setRouteCollectableId(String routeCollectableId) { this.routeCollectableId = routeCollectableId; }

    public String getRouteId() { return routeId; }
    public void setRouteId(String routeId) { this.routeId = routeId; }

    public String getCollectable() { return collectable; }
    public void setCollectable(String collectable) { this.collectable = collectable; }

    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }

    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
}
