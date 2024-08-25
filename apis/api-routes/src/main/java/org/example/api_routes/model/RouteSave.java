package org.example.api_routes.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.sql.Timestamp;

@Entity
@Table(name = "route_saves")
public class RouteSave {

    @Id
    @Column(name = "route_save_id", length = 36)
    private String routeSaveId;

    @Column(name = "route_id", nullable = false, length = 36)
    private String routeId;

    @Column(name = "user_id", length = 28, nullable = false)
    private String userId;

    @Column(name = "save_date", nullable = false)
    private Timestamp saveDate;

    public RouteSave() {
        // Empty constructor needed for JPA
    }

    public RouteSave(String routeSaveId, String routeId, String userId, Timestamp saveDate) {
        this.routeSaveId = routeSaveId;
        this.routeId = routeId;
        this.userId = userId;
        this.saveDate = saveDate;
    }

    public String getRouteSaveId() { return routeSaveId; }
    public void setRouteSaveId(String routeSavesId) { this.routeSaveId = routeSavesId; }

    public String getRouteId() { return routeId; }
    public void setRouteId(String routeId) { this.routeId = routeId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public Timestamp getSaveDate() { return saveDate; }
    public void setSaveDate(Timestamp saveDate) { this.saveDate = saveDate;}
}
