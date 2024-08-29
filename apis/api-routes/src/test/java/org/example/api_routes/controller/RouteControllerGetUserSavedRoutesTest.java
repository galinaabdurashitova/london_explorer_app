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
public class RouteControllerGetUserSavedRoutesTest {

    @Mock
    private RouteService routeService;

    @InjectMocks
    private RouteController routeController;

    @Test
    public void testGetUserSavedRoutesSuccess() {
        // Test to verify that user saved routes are retrieved successfully.
        String userId = "user1";
        List<Route> mockRoutes = Arrays.asList(
                new Route("route1", new Timestamp(System.currentTimeMillis()), userId, "Route One", "Description 1", 120, new Timestamp(System.currentTimeMillis())),
                new Route("route2", new Timestamp(System.currentTimeMillis()), userId, "Route Two", "Description 2", 90, new Timestamp(System.currentTimeMillis()))
        );

        when(routeService.getFavouriteRoutes(userId)).thenReturn(mockRoutes);
        when(routeService.findRouteStops(anyString())).thenReturn(Collections.emptyList());
        when(routeService.findRouteCollectables(anyString())).thenReturn(Collections.emptyList());
        when(routeService.findRouteSaves(anyString())).thenReturn(Collections.emptyList());

        ResponseEntity<?> responseEntity = routeController.getUserSavedRoutes(userId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
        verify(routeService, times(1)).getFavouriteRoutes(userId);
    }

    @Test
    public void testGetUserSavedRoutesEmpty() {
        // Test to verify that an empty list is returned when the user has no saved routes.
        String userId = "user1";
        when(routeService.getFavouriteRoutes(userId)).thenReturn(Collections.emptyList());

        ResponseEntity<?> responseEntity = routeController.getUserSavedRoutes(userId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody())).isEmpty();
        verify(routeService, times(1)).getFavouriteRoutes(userId);
    }
}
