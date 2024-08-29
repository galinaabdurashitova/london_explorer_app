package org.example.api_routes.controller;

import org.example.api_routes.model.Route;
import org.example.api_routes.service.RouteService;
import org.example.api_routes.dto.RouteUpdateRequest;
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
public class RouteControllerUpdateRouteTest {

    @Mock
    private RouteService routeService;

    @InjectMocks
    private RouteController routeController;

    @Test
    public void testUpdateRouteSuccess() {
        // Test to verify that the route is updated successfully when the route is found.
        String routeId = "route1";
        Route existingRoute = new Route(routeId, null, "user1", "Original Route", "Original Description", 60, null);

        when(routeService.getRouteById(routeId)).thenReturn(Optional.of(existingRoute));

        RouteUpdateRequest updateRequest = new RouteUpdateRequest();
        updateRequest.setRouteName("Updated Route");
        updateRequest.setRouteDescription("Updated Description");

        ResponseEntity<?> responseEntity = routeController.updateRoute(routeId, updateRequest);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(existingRoute.getRouteName()).isEqualTo("Updated Route");
        assertThat(existingRoute.getRouteDescription()).isEqualTo("Updated Description");
        verify(routeService).saveRoute(existingRoute);
    }

    @Test
    public void testUpdateRouteNotFound() {
        // Test to ensure that a not found response is returned when trying to update a non-existent route.
        String routeId = "route1";

        when(routeService.getRouteById(routeId)).thenReturn(Optional.empty());

        RouteUpdateRequest updateRequest = new RouteUpdateRequest();
        updateRequest.setRouteName("Updated Route");

        ResponseEntity<?> responseEntity = routeController.updateRoute(routeId, updateRequest);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(routeService, never()).saveRoute(any(Route.class));
    }
}
