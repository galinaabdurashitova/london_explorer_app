package org.example.api_routes.service;

import org.example.api_routes.model.Route;
import org.example.api_routes.model.RouteCollectable;
import org.example.api_routes.model.RouteStop;
import org.example.api_routes.repository.RouteRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.sql.Timestamp;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class RouteServiceTest {

    @Mock
    private RouteRepository routeRepository;

    @InjectMocks
    private RouteService routeService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testGetRouteById() {
        String routeId = "route123";
        Route mockRoute = new Route(routeId, new Timestamp(System.currentTimeMillis()), "user123", "Route 123", "Description", 60, new Timestamp(System.currentTimeMillis()));

        when(routeRepository.findById(routeId)).thenReturn(Optional.of(mockRoute));

        Optional<Route> route = routeService.getRouteById(routeId);

        assertThat(route).isPresent();
        assertThat(route.get().getRouteId()).isEqualTo(routeId);
    }

    @Test
    public void testGetRoutesByIds() {
        List<String> routeIds = Collections.singletonList("route123");
        Route mockRoute = new Route("route123", new Timestamp(System.currentTimeMillis()), "user123", "Route 123", "Description", 60, new Timestamp(System.currentTimeMillis()));

        when(routeRepository.findByRouteIdIn(routeIds)).thenReturn(Collections.singletonList(mockRoute));

        List<Route> routes = routeService.getRoutesByIds(routeIds);

        assertThat(routes).isNotEmpty();
        assertThat(routes.get(0).getRouteId()).isEqualTo("route123");
    }

    @Test
    public void testGetAllRoutes() {
        Route mockRoute1 = new Route("route123", new Timestamp(System.currentTimeMillis()), "user123", "Route 123", "Description", 60, new Timestamp(System.currentTimeMillis()));
        Route mockRoute2 = new Route("route456", new Timestamp(System.currentTimeMillis()), "user456", "Route 456", "Another Description", 90, new Timestamp(System.currentTimeMillis()));

        when(routeRepository.findAll()).thenReturn(List.of(mockRoute1, mockRoute2));

        List<Route> routes = routeService.getAllRoutes();

        assertThat(routes).isNotEmpty();
        assertThat(routes.size()).isEqualTo(2);
        assertThat(routes.get(0).getRouteId()).isEqualTo("route123");
        assertThat(routes.get(1).getRouteId()).isEqualTo("route456");
    }

    @Test
    public void testGetRoutesByUserId() {
        String userId = "user123";
        Route mockRoute1 = new Route("route123", new Timestamp(System.currentTimeMillis()), userId, "Route 123", "Description", 60, new Timestamp(System.currentTimeMillis()));
        Route mockRoute2 = new Route("route456", new Timestamp(System.currentTimeMillis()), userId, "Route 456", "Another Description", 90, new Timestamp(System.currentTimeMillis()));

        when(routeRepository.findByUserCreatedIn(userId)).thenReturn(List.of(mockRoute1, mockRoute2));

        List<Route> routes = routeService.getRoutesByUserId(userId);

        assertThat(routes).isNotEmpty();
        assertThat(routes.size()).isEqualTo(2);
        assertThat(routes.get(0).getRouteId()).isEqualTo("route123");
        assertThat(routes.get(1).getRouteId()).isEqualTo("route456");
    }

    @Test
    public void testFindRouteStops() {
        String routeId = "route123";
        RouteStop mockRouteStop = new RouteStop("stop1", routeId, 1, "attraction123");

        when(routeRepository.findRouteStops(routeId)).thenReturn(Collections.singletonList(mockRouteStop));

        List<RouteStop> stops = routeService.findRouteStops(routeId);

        assertThat(stops).isNotEmpty();
        assertThat(stops.get(0).getStopId()).isEqualTo("stop1");
        assertThat(stops.get(0).getStepNumber()).isEqualTo(1);
        assertThat(stops.get(0).getAttractionId()).isEqualTo("attraction123");
    }

    @Test
    public void testFindRouteCollectables() {
        String routeId = "route123";
        RouteCollectable mockRouteCollectable = new RouteCollectable("collectable1", routeId, "Collectable Name", 12.3456789, 98.7654321);

        when(routeRepository.findRouteCollectables(routeId)).thenReturn(Collections.singletonList(mockRouteCollectable));

        List<RouteCollectable> collectables = routeService.findRouteCollectables(routeId);

        assertThat(collectables).isNotEmpty();
        assertThat(collectables.get(0).getRouteCollectableId()).isEqualTo("collectable1");
        assertThat(collectables.get(0).getCollectable()).isEqualTo("Collectable Name");
        assertThat(collectables.get(0).getLatitude()).isEqualTo(12.3456789);
        assertThat(collectables.get(0).getLongitude()).isEqualTo(98.7654321);
    }

    @Test
    public void testFindRouteSaves() {
        String routeId = "route123";
        List<String> mockRouteSaves = Collections.singletonList("user123");

        when(routeRepository.findRouteSaves(routeId)).thenReturn(mockRouteSaves);

        List<String> saves = routeService.findRouteSaves(routeId);

        assertThat(saves).isNotEmpty();
        assertThat(saves).contains("user123");
    }

    @Test
    public void testSaveRoute() {
        Route mockRoute = new Route("route123", new Timestamp(System.currentTimeMillis()), "user123", "Route 123", "Description", 60, new Timestamp(System.currentTimeMillis()));

        routeService.saveRoute(mockRoute);

        verify(routeRepository).save(mockRoute);
    }

    @Test
    public void testGetFavouriteRoutes() {
        String userId = "user123";
        Route mockRoute = new Route("route123", new Timestamp(System.currentTimeMillis()), userId, "Route 123", "Description", 60, new Timestamp(System.currentTimeMillis()));

        when(routeRepository.findUserSavedRoutes(userId)).thenReturn(Collections.singletonList(mockRoute));

        List<Route> routes = routeService.getFavouriteRoutes(userId);

        assertThat(routes).isNotEmpty();
        assertThat(routes.get(0).getRouteId()).isEqualTo("route123");
    }

    @Test
    public void testGetTopSavedRoutes() {
        int limit = 5;
        List<Object[]> mockTopRoutes = List.of(
                new Object[]{"route123", Timestamp.valueOf("2024-08-15 12:34:56"), "user123", "Route 123", "Description", 60, Timestamp.valueOf("2024-08-15 12:34:56")},
                new Object[]{"route456", Timestamp.valueOf("2024-08-16 13:45:00"), "user456", "Route 456", "Another Description", 90, Timestamp.valueOf("2024-08-16 13:45:00")}
        );

        when(routeRepository.findTopSavedRoutes(limit)).thenReturn(mockTopRoutes);

        List<Route> routes = routeService.getTopSavedRoutes(limit);

        assertThat(routes).isNotEmpty();
        assertThat(routes.size()).isEqualTo(2);

        Route firstRoute = routes.get(0);
        assertThat(firstRoute.getRouteId()).isEqualTo("route123");
        assertThat(firstRoute.getUserCreated()).isEqualTo("user123");
        assertThat(firstRoute.getRouteName()).isEqualTo("Route 123");

        Route secondRoute = routes.get(1);
        assertThat(secondRoute.getRouteId()).isEqualTo("route456");
        assertThat(secondRoute.getUserCreated()).isEqualTo("user456");
        assertThat(secondRoute.getRouteName()).isEqualTo("Route 456");
    }
}
