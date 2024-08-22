package org.example.api_routes.dto;

public class RouteStopRequest {
    private String stopId;
    private int stepNumber;
    private String attractionId;

    public String getStopId() {  return stopId; }
    public void setStopId(String stopId) { this.stopId = stopId; }

    public int getStepNumber() { return stepNumber; }
    public void setStepNumber(int stepNumber) { this.stepNumber = stepNumber; }

    public String getAttractionId() {return attractionId; }
    public void setAttractionId(String attractionId) { this.attractionId = attractionId; }
}
