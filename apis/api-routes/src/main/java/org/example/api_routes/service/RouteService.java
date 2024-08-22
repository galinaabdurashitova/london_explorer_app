package org.example.api_routes.service;

import org.example.api_routes.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.example.api_routes.repository.*;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RouteService {
    @Autowired
    private RouteRepository routeRepository;

    public Optional<Route> getRouteById(String routeId) {
        return routeRepository.findById(routeId);
    }

    public List<Route> getRoutesByIds(List<String> routeIds) { return routeRepository.findByRouteIdIn(routeIds); }

    public List<Route> getAllRoutes() { return routeRepository.findAll(); }

    public List<RouteStop> findRouteStops(String routeId) {  return routeRepository.findRouteStops(routeId); }

    public List<RouteCollectable> findRouteCollectables(String routeId) { return routeRepository.findRouteCollectables(routeId); }

    public List<String> findRouteSaves(String routeId) { return routeRepository.findRouteSaves(routeId); }

    public void saveRoute(Route route) {
        routeRepository.save(route);
    }
}
