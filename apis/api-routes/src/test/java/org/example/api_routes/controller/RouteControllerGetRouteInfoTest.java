package org.example.api_routes.controller;

import org.example.api_routes.model.Route;
import org.example.api_routes.service.RouteService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.Collections;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RouteControllerGetRouteInfoTest {

    @Mock
    private RouteService routeService;

    @InjectMocks
    private RouteController routeController;

    @Test
    public void testGetRouteInfo() {
        // Test to ensure that the route information is retrieved successfully.
        String routeId = "route123";
        Route mockRoute = new Route(routeId, new Timestamp(System.currentTimeMillis()), "user123", "Route 123", "Description", 60, new Timestamp(System.currentTimeMillis()));

        when(routeService.getRouteById(routeId)).thenReturn(Optional.of(mockRoute));
        when(routeService.findRouteStops(routeId)).thenReturn(Collections.emptyList());
        when(routeService.findRouteCollectables(routeId)).thenReturn(Collections.emptyList());
        when(routeService.findRouteSaves(routeId)).thenReturn(Collections.emptyList());

        ResponseEntity<?> responseEntity = routeController.getRouteInfo(routeId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(Map.class);
        assertThat(((Map<?, ?>) responseEntity.getBody()).get("routeId")).isEqualTo(routeId);
    }

    @Test
    public void testGetRouteInfoRouteNotFound() {
        // Test to ensure that the appropriate response is returned when a route is not found.
        String routeId = "route123";

        when(routeService.getRouteById(routeId)).thenReturn(Optional.empty());

        ResponseEntity<?> responseEntity = routeController.getRouteInfo(routeId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isEqualTo("Route not found");
    }
}
