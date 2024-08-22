package org.example.api_routes.model;

import jakarta.persistence.*;

@Entity
@Table(name = "route_stops")
public class RouteStop {
    @Id
    @Column(name = "stop_id", length = 36)
    private String stopId;

    @Column(name = "route_id", nullable = false, length = 36)
    private String routeId;

    @Column(name = "step_number", nullable = false)
    private int stepNumber;

    @Column(name = "attraction_id", nullable = false, length = 16)
    private String attractionId;

    public RouteStop() {
        // Empty constructor needed for JPA
    }

    public RouteStop(String stopId, String routeId, int stepNumber, String attractionId) {
        this.stopId = stopId;
        this.routeId = routeId;
        this.stepNumber = stepNumber;
        this.attractionId = attractionId;
    }

    public String getStopId() {  return stopId; }
    public void setStopId(String stopId) { this.stopId = stopId; }

    public String getRouteId() { return routeId; }
    public void setRouteId(String routeId) { this.routeId = routeId; }

    public int getStepNumber() { return stepNumber; }
    public void setStepNumber(int stepNumber) { this.stepNumber = stepNumber; }

    public String getAttractionId() {return attractionId; }
    public void setAttractionId(String attractionId) { this.attractionId = attractionId; }
}
