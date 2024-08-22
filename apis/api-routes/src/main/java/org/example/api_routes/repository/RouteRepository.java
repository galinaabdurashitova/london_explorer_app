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

    @Query("SELECT rs FROM RouteStop rs WHERE rs.routeId = :routeId")
    List<RouteStop> findRouteStops(@Param("routeId") String routeId);

    @Query("SELECT rc FROM RouteCollectable rc WHERE rc.routeId = :routeId")
    List<RouteCollectable> findRouteCollectables(@Param("routeId") String routeId);

    @Query("SELECT rs.userId FROM RouteSave rs WHERE rs.routeId = :routeId")
    List<String> findRouteSaves(@Param("routeId") String routeId);
}
