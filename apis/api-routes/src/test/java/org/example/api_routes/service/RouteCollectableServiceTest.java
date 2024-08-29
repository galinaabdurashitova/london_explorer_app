package org.example.api_routes.service;

import org.example.api_routes.model.RouteCollectable;
import org.example.api_routes.repository.RouteCollectableRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.mockito.Mockito.verify;

public class RouteCollectableServiceTest {

    @Mock
    private RouteCollectableRepository routeCollectableRepository;

    @InjectMocks
    private RouteCollectableService routeCollectableService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testSaveRouteCollectable() {
        // Ensures that RouteCollectableService.saveRouteCollectable correctly saves a RouteCollectable to the repository.
        RouteCollectable mockRouteCollectable = new RouteCollectable("collectable1", "route123", "Collectable Name", 12.3456789, 98.7654321);

        routeCollectableService.saveRouteCollectable(mockRouteCollectable);

        verify(routeCollectableRepository).save(mockRouteCollectable);
    }
}
