package org.example.api_routes.controller;

import org.example.api_routes.model.Route;
import org.example.api_routes.model.RouteSave;
import org.example.api_routes.service.RouteSaveService;
import org.example.api_routes.service.RouteService;
import org.example.api_routes.dto.SaveRouteRequest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RouteControllerSaveRouteTest {

    @Mock
    private RouteService routeService;

    @Mock
    private RouteSaveService routeSaveService;

    @InjectMocks
    private RouteController routeController;

    @Test
    public void testSaveRouteSuccess() {
        // Test to verify that a route save is created successfully when all parameters are provided.
        String routeId = "route1";
        Route mockRoute = new Route(routeId, null, "user1", "Test Route", "Test Description", 60, null);

        when(routeService.getRouteById(routeId)).thenReturn(Optional.of(mockRoute));

        SaveRouteRequest request = new SaveRouteRequest();
        request.setUserId("user123");
        request.setSaveDate(new Timestamp(System.currentTimeMillis()));

        ResponseEntity<?> responseEntity = routeController.saveRoute(routeId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(routeSaveService).saveRoute(any(RouteSave.class));
    }

    @Test
    public void testSaveRouteMissingParameters() {
        // Test to ensure that a bad request response is returned when required parameters are missing.
        String routeId = "route1";

        SaveRouteRequest request = new SaveRouteRequest();

        ResponseEntity<?> responseEntity = routeController.saveRoute(routeId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(routeSaveService, never()).saveRoute(any(RouteSave.class));
    }

    @Test
    public void testSaveRouteNotFound() {
        // Test to ensure that a not found response is returned when trying to save a route for a non-existent route.
        String routeId = "route1";

        when(routeService.getRouteById(routeId)).thenReturn(Optional.empty());

        SaveRouteRequest request = new SaveRouteRequest();
        request.setUserId("user123");
        request.setSaveDate(new Timestamp(System.currentTimeMillis()));

        ResponseEntity<?> responseEntity = routeController.saveRoute(routeId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(routeSaveService, never()).saveRoute(any(RouteSave.class));
    }
}
