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
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RouteControllerGetTopSavedRoutesTest {

    @Mock
    private RouteService routeService;

    @InjectMocks
    private RouteController routeController;

    @Test
    public void testGetTopSavedRoutesSuccess() {
        // Test to verify that top saved routes are retrieved successfully with a limit.
        int limit = 5;
        List<Route> mockRoutes = Arrays.asList(
                new Route("route1", new Timestamp(System.currentTimeMillis()), "user1", "Route One", "Description 1", 120, new Timestamp(System.currentTimeMillis())),
                new Route("route2", new Timestamp(System.currentTimeMillis()), "user2", "Route Two", "Description 2", 90, new Timestamp(System.currentTimeMillis()))
        );

        when(routeService.getTopSavedRoutes(limit)).thenReturn(mockRoutes);
        when(routeService.findRouteStops(anyString())).thenReturn(Collections.emptyList());
        when(routeService.findRouteCollectables(anyString())).thenReturn(Collections.emptyList());
        when(routeService.findRouteSaves(anyString())).thenReturn(Collections.emptyList());

        ResponseEntity<?> responseEntity = routeController.getTopSavedRoutes(limit);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
        verify(routeService, times(1)).getTopSavedRoutes(limit);
    }

    @Test
    public void testGetTopSavedRoutesEmpty() {
        // Test to verify that an empty list is returned when there are no top saved routes.
        int limit = 5;
        when(routeService.getTopSavedRoutes(limit)).thenReturn(Collections.emptyList());

        ResponseEntity<?> responseEntity = routeController.getTopSavedRoutes(limit);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody())).isEmpty();
        verify(routeService, times(1)).getTopSavedRoutes(limit);
    }
}
