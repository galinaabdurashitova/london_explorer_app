package org.example.api_routes.controller;

import org.example.api_routes.model.Route;
import org.example.api_routes.service.RouteSaveService;
import org.example.api_routes.service.RouteService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RouteControllerDeleteRouteSaveTest {

    @Mock
    private RouteService routeService;

    @Mock
    private RouteSaveService routeSaveService;

    @InjectMocks
    private RouteController routeController;

    @Test
    public void testDeleteRouteSaveSuccess() {
        // Test to verify that a route save is deleted successfully when all conditions are met.
        String routeId = "route1";
        String userId = "user123";
        Route mockRoute = new Route(routeId, null, "user1", "Test Route", "Test Description", 60, null);

        when(routeService.getRouteById(routeId)).thenReturn(Optional.of(mockRoute));
        when(routeSaveService.isRouteSaveExists(routeId, userId)).thenReturn(true);

        ResponseEntity<?> responseEntity = routeController.deleteRouteSave(routeId, userId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(routeSaveService).deleteRouteSave(routeId, userId);
    }

    @Test
    public void testDeleteRouteSaveNotFound() {
        // Test to ensure that a not found response is returned when trying to delete a save for a non-existent route.
        String routeId = "route1";
        String userId = "user123";

        when(routeService.getRouteById(routeId)).thenReturn(Optional.empty());

        ResponseEntity<?> responseEntity = routeController.deleteRouteSave(routeId, userId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(routeSaveService, never()).deleteRouteSave(anyString(), anyString());
    }

    @Test
    public void testDeleteRouteSaveDoesNotExist() {
        // Test to ensure that a not found response is returned when the route save does not exist.
        String routeId = "route1";
        String userId = "user123";
        Route mockRoute = new Route(routeId, null, "user1", "Test Route", "Test Description", 60, null);

        when(routeService.getRouteById(routeId)).thenReturn(Optional.of(mockRoute));
        when(routeSaveService.isRouteSaveExists(routeId, userId)).thenReturn(false);

        ResponseEntity<?> responseEntity = routeController.deleteRouteSave(routeId, userId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(routeSaveService, never()).deleteRouteSave(anyString(), anyString());
    }
}
