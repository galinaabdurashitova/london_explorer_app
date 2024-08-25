package org.example.api_routes.controller;

import org.example.api_routes.model.Route;
import org.example.api_routes.model.RouteCollectable;
import org.example.api_routes.model.RouteStop;
import org.example.api_routes.service.RouteService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RouteControllerGetRoutesTest {

    @Mock
    private RouteService routeService;

    @InjectMocks
    private RouteController routeController;

    @Test
    public void testGetRoutesByIds() {
        // Test to verify that routes are retrieved successfully by their IDs.
        List<String> routeIds = Arrays.asList("route1", "route2");
        List<Route> mockRoutes = Arrays.asList(
                new Route("route1", new Timestamp(System.currentTimeMillis()), "user1", "Route One", "Description 1", 120, new Timestamp(System.currentTimeMillis())),
                new Route("route2", new Timestamp(System.currentTimeMillis()), "user2", "Route Two", "Description 2", 90, new Timestamp(System.currentTimeMillis()))
        );

        when(routeService.getRoutesByIds(routeIds)).thenReturn(mockRoutes);
        when(routeService.findRouteStops("route1")).thenReturn(Collections.emptyList());
        when(routeService.findRouteStops("route2")).thenReturn(Collections.emptyList());
        when(routeService.findRouteCollectables("route1")).thenReturn(Collections.emptyList());
        when(routeService.findRouteCollectables("route2")).thenReturn(Collections.emptyList());
        when(routeService.findRouteSaves("route1")).thenReturn(Collections.emptyList());
        when(routeService.findRouteSaves("route2")).thenReturn(Collections.emptyList());

        ResponseEntity<?> responseEntity = routeController.getRoutes(routeIds);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }

    @Test
    public void testGetRoutesWithNoIds() {
        // Test to verify that all routes are retrieved when no IDs are provided.
        List<Route> mockRoutes = Arrays.asList(
                new Route("route1", new Timestamp(System.currentTimeMillis()), "user1", "Route One", "Description 1", 120, new Timestamp(System.currentTimeMillis())),
                new Route("route2", new Timestamp(System.currentTimeMillis()), "user2", "Route Two", "Description 2", 90, new Timestamp(System.currentTimeMillis()))
        );

        when(routeService.getAllRoutes()).thenReturn(mockRoutes);
        when(routeService.findRouteStops("route1")).thenReturn(Collections.emptyList());
        when(routeService.findRouteStops("route2")).thenReturn(Collections.emptyList());
        when(routeService.findRouteCollectables("route1")).thenReturn(Collections.emptyList());
        when(routeService.findRouteCollectables("route2")).thenReturn(Collections.emptyList());
        when(routeService.findRouteSaves("route1")).thenReturn(Collections.emptyList());
        when(routeService.findRouteSaves("route2")).thenReturn(Collections.emptyList());

        ResponseEntity<?> responseEntity = routeController.getRoutes(null);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }

    @Test
    public void testGetRoutesByIdsSomeNotFound() {
        // Test to verify that only the routes found by their IDs are returned, excluding the ones not found.
        List<String> routeIds = Arrays.asList("route1", "route2", "route3");
        List<Route> mockRoutes = Arrays.asList(
                new Route("route1", new Timestamp(System.currentTimeMillis()), "user1", "Route One", "Description 1", 120, new Timestamp(System.currentTimeMillis())),
                new Route("route2", new Timestamp(System.currentTimeMillis()), "user2", "Route Two", "Description 2", 90, new Timestamp(System.currentTimeMillis()))
        );

        when(routeService.getRoutesByIds(routeIds)).thenReturn(mockRoutes);
        when(routeService.findRouteStops("route1")).thenReturn(Collections.emptyList());
        when(routeService.findRouteStops("route2")).thenReturn(Collections.emptyList());
        when(routeService.findRouteCollectables("route1")).thenReturn(Collections.emptyList());
        when(routeService.findRouteCollectables("route2")).thenReturn(Collections.emptyList());
        when(routeService.findRouteSaves("route1")).thenReturn(Collections.emptyList());
        when(routeService.findRouteSaves("route2")).thenReturn(Collections.emptyList());

        ResponseEntity<?> responseEntity = routeController.getRoutes(routeIds);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }
}
