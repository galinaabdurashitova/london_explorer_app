package org.example.api_routes.service;

import org.example.api_routes.model.RouteStop;
import org.example.api_routes.repository.RouteStopRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.mockito.Mockito.verify;

public class RouteStopServiceTest {

    @Mock
    private RouteStopRepository routeStopRepository;

    @InjectMocks
    private RouteStopService routeStopService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testSaveRouteStop() {
        // Ensures that RouteStopService.saveRouteStop correctly saves a RouteStop to the repository.
        RouteStop mockRouteStop = new RouteStop("stop1", "route123", 1, "attraction123");

        routeStopService.saveRouteStop(mockRouteStop);

        verify(routeStopRepository).save(mockRouteStop);
    }
}
