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

    public List<Route> getRoutesByUserId(String userId) { return routeRepository.findByUserCreatedIn(userId); }

    public List<RouteStop> findRouteStops(String routeId) {  return routeRepository.findRouteStops(routeId); }

    public List<RouteCollectable> findRouteCollectables(String routeId) { return routeRepository.findRouteCollectables(routeId); }

    public List<String> findRouteSaves(String routeId) { return routeRepository.findRouteSaves(routeId); }

    public void saveRoute(Route route) {
        routeRepository.save(route);
    }

    public List<Route> getFavouriteRoutes(String userId) { return routeRepository.findUserSavedRoutes(userId); }

    public List<Route> getTopSavedRoutes(int limit) {
        List<Object[]> topRoutes = routeRepository.findTopSavedRoutes(limit);

        return topRoutes.stream().map(update -> new Route(
                (String) update[0], // routeId
                (Timestamp) update[1], // dateCreated
                (String) update[2], // userCreated
                (String) update[3], // routeName
                (String) update[4], // routeDescription
                (int) update[5],  // routeTime
                (Timestamp) update[6]  // datePublished
        )).collect(Collectors.toList());
    }
}
