package org.example.api_routes.repository;

import org.example.api_routes.model.Route;
import org.example.api_routes.model.RouteCollectable;
import org.example.api_routes.model.RouteSave;
import org.example.api_routes.model.RouteStop;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RouteRepository extends JpaRepository<Route, String> {
    List<Route> findByRouteIdIn(List<String> routeIds);

    @Query("SELECT r FROM Route r WHERE r.userCreated = :userId")
    List<Route> findByUserCreatedIn(String userId);

    @Query("SELECT rs FROM RouteStop rs WHERE rs.routeId = :routeId")
    List<RouteStop> findRouteStops(@Param("routeId") String routeId);

    @Query("SELECT rc FROM RouteCollectable rc WHERE rc.routeId = :routeId")
    List<RouteCollectable> findRouteCollectables(@Param("routeId") String routeId);

    @Query("SELECT rs.userId FROM RouteSave rs WHERE rs.routeId = :routeId")
    List<String> findRouteSaves(@Param("routeId") String routeId);

    @Query("SELECT r FROM Route r " +
            "WHERE EXISTS ( " +
            "SELECT 1 FROM RouteSave rs " +
            "WHERE rs.userId = :userId AND rs.routeId = r.routeId)")
    List<Route> findUserSavedRoutes(@Param("userId") String userId);

    @Query(value = "SELECT r.*, COUNT(rs.user_id) AS saves_count " +
            "FROM route r " +
            "JOIN route_saves rs ON rs.route_id = r.route_id " +
            "GROUP BY r.route_id, r.date_created, r.user_created, r.route_name, r.route_description, r.route_time, r.date_published " +
            "ORDER BY saves_count DESC " +
            "LIMIT :limit ", nativeQuery = true)
    List<Object[]> findTopSavedRoutes(@Param("limit") int limit);
}
