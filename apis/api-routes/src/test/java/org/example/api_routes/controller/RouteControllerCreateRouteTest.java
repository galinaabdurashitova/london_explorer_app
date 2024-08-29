package org.example.api_routes.controller;

import org.example.api_routes.model.Route;
import org.example.api_routes.model.RouteCollectable;
import org.example.api_routes.model.RouteStop;
import org.example.api_routes.service.RouteCollectableService;
import org.example.api_routes.service.RouteService;
import org.example.api_routes.service.RouteStopService;
import org.example.api_routes.dto.RouteRequest;
import org.example.api_routes.dto.RouteStopRequest;
import org.example.api_routes.dto.RouteCollectableRequest;
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

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RouteControllerCreateRouteTest {

    @Mock
    private RouteService routeService;

    @Mock
    private RouteStopService routeStopService;

    @Mock
    private RouteCollectableService routeCollectableService;

    @InjectMocks
    private RouteController routeController;

    @Test
    public void testCreateRouteSuccess() {
        // Test to verify that a route is created successfully when all parameters are provided.
        RouteRequest request = new RouteRequest();
        request.setRouteId("route1");
        request.setDateCreated(new Timestamp(System.currentTimeMillis()));
        request.setUserCreated("user1");
        request.setRouteName("Test Route");
        request.setRouteDescription("Test Description");
        request.setRouteTime(60);
        request.setDatePublished(new Timestamp(System.currentTimeMillis()));

        RouteStopRequest stopRequest = new RouteStopRequest();
        stopRequest.setStopId("stop1");
        stopRequest.setStepNumber(1);
        stopRequest.setAttractionId("attraction1");

        RouteCollectableRequest collectableRequest = new RouteCollectableRequest();
        collectableRequest.setRouteCollectableId("collectable1");
        collectableRequest.setCollectable("collectableItem");
        collectableRequest.setLatitude(12.3456789);
        collectableRequest.setLongitude(98.7654321);

        request.setStops(Arrays.asList(stopRequest));
        request.setCollectables(Arrays.asList(collectableRequest));

        ResponseEntity<?> responseEntity = routeController.createRoute(request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(routeService).saveRoute(any(Route.class));
        verify(routeStopService).saveRouteStop(any(RouteStop.class));
        verify(routeCollectableService).saveRouteCollectable(any(RouteCollectable.class));
    }

    @Test
    public void testCreateRouteMissingParameters() {
        // Test to ensure that a bad request response is returned when required parameters are missing.
        RouteRequest request = new RouteRequest();

        ResponseEntity<?> responseEntity = routeController.createRoute(request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(routeService, never()).saveRoute(any(Route.class));
        verify(routeStopService, never()).saveRouteStop(any(RouteStop.class));
        verify(routeCollectableService, never()).saveRouteCollectable(any(RouteCollectable.class));
    }

    @Test
    public void testCreateRouteMissingStopParameters() {
        // Test to ensure that a bad request response is returned when required stop parameters are missing.
        RouteRequest request = new RouteRequest();
        request.setRouteId("route1");
        request.setDateCreated(new Timestamp(System.currentTimeMillis()));
        request.setUserCreated("user1");
        request.setRouteName("Test Route");
        request.setRouteDescription("Test Description");
        request.setRouteTime(60);
        request.setDatePublished(new Timestamp(System.currentTimeMillis()));

        RouteStopRequest stopRequest = new RouteStopRequest();
        // Missing stop parameters
        request.setStops(Collections.singletonList(stopRequest));

        ResponseEntity<?> responseEntity = routeController.createRoute(request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(routeService, never()).saveRoute(any(Route.class));
        verify(routeStopService, never()).saveRouteStop(any(RouteStop.class));
        verify(routeCollectableService, never()).saveRouteCollectable(any(RouteCollectable.class));
    }

    @Test
    public void testCreateRouteMissingCollectableParameters() {
        // Test to ensure that a bad request response is returned when required collectable parameters are missing.
        RouteRequest request = new RouteRequest();
        request.setRouteId("route1");
        request.setDateCreated(new Timestamp(System.currentTimeMillis()));
        request.setUserCreated("user1");
        request.setRouteName("Test Route");
        request.setRouteDescription("Test Description");
        request.setRouteTime(60);
        request.setDatePublished(new Timestamp(System.currentTimeMillis()));

        RouteCollectableRequest collectableRequest = new RouteCollectableRequest();
        // Missing collectable parameters
        request.setCollectables(Collections.singletonList(collectableRequest));

        ResponseEntity<?> responseEntity = routeController.createRoute(request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(routeService, never()).saveRoute(any(Route.class));
        verify(routeStopService, never()).saveRouteStop(any(RouteStop.class));
        verify(routeCollectableService, never()).saveRouteCollectable(any(RouteCollectable.class));
    }
}
