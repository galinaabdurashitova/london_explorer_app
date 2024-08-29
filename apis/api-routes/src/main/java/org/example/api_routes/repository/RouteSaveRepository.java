package org.example.api_routes.repository;

import org.example.api_routes.model.RouteSave;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface RouteSaveRepository extends JpaRepository<RouteSave, String> {
    @Query("SELECT CASE WHEN COUNT(rs) > 0 THEN TRUE ELSE FALSE END FROM RouteSave rs WHERE rs.routeId = :routeId AND rs.userId = :userId")
    boolean existsByRouteIdAndUserId(String routeId, String userId);

    @Query("SELECT rs FROM RouteSave rs WHERE rs.routeId = :routeId AND rs.userId = :userId")
    RouteSave findRouteSave(String routeId, String userId);
}
