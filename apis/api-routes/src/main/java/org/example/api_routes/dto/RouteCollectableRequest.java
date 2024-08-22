package org.example.api_routes.dto;

public class RouteCollectableRequest {
    private String routeCollectableId;
    private String collectable;
    private double latitude;
    private double longitude;

    public String getRouteCollectableId() { return routeCollectableId;  }
    public void setRouteCollectableId(String routeCollectableId) { this.routeCollectableId = routeCollectableId; }

    public String getCollectable() { return collectable; }
    public void setCollectable(String collectable) { this.collectable = collectable; }

    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }

    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
}
