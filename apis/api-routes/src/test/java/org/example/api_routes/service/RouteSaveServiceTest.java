package org.example.api_routes.service;

import org.example.api_routes.model.RouteSave;
import org.example.api_routes.repository.RouteSaveRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.sql.Timestamp;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class RouteSaveServiceTest {

    @Mock
    private RouteSaveRepository routeSaveRepository;

    @InjectMocks
    private RouteSaveService routeSaveService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testSaveRoute() {
        // Ensures that RouteSaveService.saveRoute correctly saves a RouteSave to the repository.
        RouteSave mockRouteSave = new RouteSave("save1", "route123", "user123", new Timestamp(System.currentTimeMillis()));

        routeSaveService.saveRoute(mockRouteSave);

        verify(routeSaveRepository).save(mockRouteSave);
    }

    @Test
    public void testIsRouteSaveExists() {
        // Verifies that RouteSaveService.isRouteSaveExists correctly checks if a route save exists.
        String routeId = "route123";
        String userId = "user123";

        when(routeSaveRepository.existsByRouteIdAndUserId(routeId, userId)).thenReturn(true);

        boolean exists = routeSaveService.isRouteSaveExists(routeId, userId);

        assertThat(exists).isTrue();
    }

    @Test
    public void testDeleteRouteSave() {
        // Verifies that RouteSaveService.deleteRouteSave correctly deletes a RouteSave by routeId and userId.
        String routeId = "route123";
        String userId = "user123";
        RouteSave mockRouteSave = new RouteSave("save1", routeId, userId, new Timestamp(System.currentTimeMillis()));

        when(routeSaveRepository.findRouteSave(routeId, userId)).thenReturn(mockRouteSave);

        routeSaveService.deleteRouteSave(routeId, userId);

        verify(routeSaveRepository).deleteById(mockRouteSave.getRouteSaveId());
    }
}
