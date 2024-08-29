package org.example.api_routes.controller;

import org.example.api_routes.model.*;
import org.example.api_routes.dto.*;
import org.example.api_routes.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/routes")
public class RouteController {

    @Autowired
    private RouteService routeService;

    @Autowired
    private RouteStopService routeStopService;

    @Autowired
    private RouteCollectableService routeCollectableService;

    @Autowired
    private RouteSaveService routeSaveService;

    @GetMapping
    public ResponseEntity<?> getRoutes(@RequestParam(value = "routeIds", required = false) List<String> routeIds) {
        List<Route> routes;

        if (routeIds == null || routeIds.isEmpty()) {
            routes = routeService.getAllRoutes();
        } else {
            routes = routeService.getRoutesByIds(routeIds);
        }

        List<Map<String, Object>> response = routes.stream().map(route -> {
            Map<String, Object> routeMap = new HashMap<>();
            routeMap.put("routeId", route.getRouteId());
            routeMap.put("dateCreated", route.getDateCreated());
            routeMap.put("userCreated", route.getUserCreated());
            routeMap.put("routeName", route.getRouteName());
            routeMap.put("routeDescription", route.getRouteDescription());
            routeMap.put("routeTime", route.getRouteTime());
            routeMap.put("datePublished", route.getDatePublished());

            List<RouteStop> stops = routeService.findRouteStops(route.getRouteId());
            List<RouteCollectable> collectables = routeService.findRouteCollectables(route.getRouteId());
            List<String> saves = routeService.findRouteSaves(route.getRouteId());

            routeMap.put("stops", stops);
            routeMap.put("collectables", collectables);
            routeMap.put("saves", saves);

            return routeMap;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @GetMapping("/userCreated")
    public ResponseEntity<?> getUserRoutes(@RequestParam(value = "userId", required = true) String userId) {
        List<Route> routes = routeService.getRoutesByUserId(userId);

        List<Map<String, Object>> response = routes.stream().map(route -> {
            Map<String, Object> routeMap = new HashMap<>();
            routeMap.put("routeId", route.getRouteId());
            routeMap.put("dateCreated", route.getDateCreated());
            routeMap.put("userCreated", route.getUserCreated());
            routeMap.put("routeName", route.getRouteName());
            routeMap.put("routeDescription", route.getRouteDescription());
            routeMap.put("routeTime", route.getRouteTime());
            routeMap.put("datePublished", route.getDatePublished());

            List<RouteStop> stops = routeService.findRouteStops(route.getRouteId());
            List<RouteCollectable> collectables = routeService.findRouteCollectables(route.getRouteId());
            List<String> saves = routeService.findRouteSaves(route.getRouteId());

            routeMap.put("stops", stops);
            routeMap.put("collectables", collectables);
            routeMap.put("saves", saves);

            return routeMap;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @GetMapping("/{routeId}")
    public ResponseEntity<?> getRouteInfo(@PathVariable String routeId) {
        Optional<Route> route = routeService.getRouteById(routeId);
        if (!route.isPresent()) {
            return ResponseEntity.status(404).body("Route not found");
        }

        Map<String, Object> response = new HashMap<>();

        response.put("routeId", route.get().getRouteId());
        response.put("dateCreated", route.get().getDateCreated());
        response.put("userCreated", route.get().getUserCreated());
        response.put("routeName", route.get().getRouteName());
        response.put("routeDescription", route.get().getRouteDescription());
        response.put("routeTime", route.get().getRouteTime());
        response.put("datePublished", route.get().getDatePublished());
        response.put("stops", routeService.findRouteStops(routeId));
        response.put("collectables", routeService.findRouteCollectables(routeId));
        response.put("saves", routeService.findRouteSaves(routeId));

        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<?> createRoute(@RequestBody RouteRequest request) {
        if (request.getRouteId() == null
                || request.getDateCreated() == null
                || request.getUserCreated() == null
                || request.getRouteName() == null
                || request.getRouteDescription() == null
                || request.getDatePublished() == null
                || request.getStops() == null
                || request.getCollectables() == null) {
            return ResponseEntity.status(400).body("Missing parameters");
        }

        for (RouteStopRequest stop : request.getStops()) {
            if (stop.getStopId() == null || stop.getAttractionId() == null || stop.getStepNumber() == 0) {
                return ResponseEntity.status(400).body("Missing parameters");
            }
        }

        for (RouteCollectableRequest collectable : request.getCollectables()) {
            if (collectable.getRouteCollectableId() == null || collectable.getCollectable() == null
                    || collectable.getLatitude() == 0 || collectable.getLongitude() == 0.0) {
                return ResponseEntity.status(400).body("Missing parameters");

            }
        }

        Route route = new Route(
                request.getRouteId(),
                request.getDateCreated(),
                request.getUserCreated(),
                request.getRouteName(),
                request.getRouteDescription(),
                request.getRouteTime(),
                request.getDatePublished()
        );
        routeService.saveRoute(route);

        for (RouteStopRequest stop : request.getStops()) {
            RouteStop newStop = new RouteStop(
                    stop.getStopId(),
                    request.getRouteId(),
                    stop.getStepNumber(),
                    stop.getAttractionId()
            );
            routeStopService.saveRouteStop(newStop);
        }

        for (RouteCollectableRequest collectable : request.getCollectables()) {
            RouteCollectable newCollectable = new RouteCollectable (
                    collectable.getRouteCollectableId(),
                    request.getRouteId(),
                    collectable.getCollectable(),
                    collectable.getLatitude(),
                    collectable.getLongitude()
            );
            routeCollectableService.saveRouteCollectable(newCollectable);
        }

        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{routeId}")
    public ResponseEntity<?> updateRoute(@PathVariable String routeId, @RequestBody RouteUpdateRequest updateRequest) {
        Optional<Route> optionalRoute = routeService.getRouteById(routeId);

        if (!optionalRoute.isPresent()) {
            return ResponseEntity.status(404).body("Route not found");
        }

        Route route = optionalRoute.get();

        if (updateRequest.getRouteName() != null) {
            route.setRouteName(updateRequest.getRouteName());
        }
        if (updateRequest.getRouteDescription() != null) {
            route.setRouteDescription(updateRequest.getRouteDescription());
        }

        routeService.saveRoute(route);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{routeId}/saves")
    public ResponseEntity<?> saveRoute(@PathVariable String routeId, @RequestBody SaveRouteRequest request) {
        if (request.getUserId() == null || request.getSaveDate() == null) {
            return ResponseEntity.status(400).body("Missing parameters");
        }

        Optional<Route> route = routeService.getRouteById(routeId);
        if (!route.isPresent()) {
            return ResponseEntity.status(404).body("Route not found");
        }

        String uuid = UUID.randomUUID().toString();
        RouteSave save = new RouteSave(uuid, routeId, request.getUserId(), request.getSaveDate());
        routeSaveService.saveRoute(save);

        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{routeId}/saves/{userId}")
    public ResponseEntity<?> deleteRouteSave(@PathVariable String routeId, @PathVariable String userId) {
        Optional<Route> route = routeService.getRouteById(routeId);
        if (!route.isPresent()) {
            return ResponseEntity.status(404).body("Route not found");
        }

        boolean isSaveExists = routeSaveService.isRouteSaveExists(routeId, userId);
        if (!isSaveExists) {
            return ResponseEntity.status(404).body("Route save does not exist");
        }

        routeSaveService.deleteRouteSave(routeId, userId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/favourites")
    public ResponseEntity<?> getUserSavedRoutes(@RequestParam(value = "userId", required = true) String userId) {
        List<Route> routes = routeService.getFavouriteRoutes(userId);

        List<Map<String, Object>> response = routes.stream().map(route -> {
            Map<String, Object> routeMap = new HashMap<>();
            routeMap.put("routeId", route.getRouteId());
            routeMap.put("dateCreated", route.getDateCreated());
            routeMap.put("userCreated", route.getUserCreated());
            routeMap.put("routeName", route.getRouteName());
            routeMap.put("routeDescription", route.getRouteDescription());
            routeMap.put("routeTime", route.getRouteTime());
            routeMap.put("datePublished", route.getDatePublished());

            List<RouteStop> stops = routeService.findRouteStops(route.getRouteId());
            List<RouteCollectable> collectables = routeService.findRouteCollectables(route.getRouteId());
            List<String> saves = routeService.findRouteSaves(route.getRouteId());

            routeMap.put("stops", stops);
            routeMap.put("collectables", collectables);
            routeMap.put("saves", saves);

            return routeMap;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @GetMapping("/favourites/top")
    public ResponseEntity<?> getTopSavedRoutes(@RequestParam(value = "limit", required = false) int limit) {
        List<Route> routes = routeService.getTopSavedRoutes(limit);

        List<Map<String, Object>> response = routes.stream().map(route -> {
            Map<String, Object> routeMap = new HashMap<>();
            routeMap.put("routeId", route.getRouteId());
            routeMap.put("dateCreated", route.getDateCreated());
            routeMap.put("userCreated", route.getUserCreated());
            routeMap.put("routeName", route.getRouteName());
            routeMap.put("routeDescription", route.getRouteDescription());
            routeMap.put("routeTime", route.getRouteTime());
            routeMap.put("datePublished", route.getDatePublished());

            List<RouteStop> stops = routeService.findRouteStops(route.getRouteId());
            List<RouteCollectable> collectables = routeService.findRouteCollectables(route.getRouteId());
            List<String> saves = routeService.findRouteSaves(route.getRouteId());

            routeMap.put("stops", stops);
            routeMap.put("collectables", collectables);
            routeMap.put("saves", saves);

            return routeMap;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }
}
