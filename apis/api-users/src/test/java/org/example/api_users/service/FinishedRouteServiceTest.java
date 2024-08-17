package org.example.api_users.service;

import org.example.api_users.model.FinishedRoute;
import org.example.api_users.model.UserCollectable;
import org.example.api_users.repository.FinishedRouteRepository;
import org.example.api_users.repository.UserCollectableRepository;
import org.example.api_users.service.FinishedRouteService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.mockito.Mockito.verify;

public class FinishedRouteServiceTest {

    @Mock
    private FinishedRouteRepository finishedRouteRepository;

    @Mock
    private UserCollectableRepository userCollectableRepository;

    @InjectMocks
    private FinishedRouteService finishedRouteService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testSaveFinishedRoute() {
        FinishedRoute mockFinishedRoute = new FinishedRoute("944F0FA9-256B-4568-92D7-855FA473FAE0", "SHrUmpceW6bDkRBLIlS0koDjyNH2", "29751B98-FDF0-485D-B03E-3BD12CA0884C", null, 0);

        finishedRouteService.saveFinishedRoute(mockFinishedRoute);

        verify(finishedRouteRepository).save(mockFinishedRoute);
    }

    @Test
    public void testSaveCollectable() {
        UserCollectable mockUserCollectable = new UserCollectable("944F0FA9-256B-4568-92D7-855FA473FAE0", "SHrUmpceW6bDkRBLIlS0koDjyNH2", "Bulldog", "29751B98-FDF0-485D-B03E-3BD12CA0884C");

        finishedRouteService.saveUserCollectable(mockUserCollectable);

        verify(userCollectableRepository).save(mockUserCollectable);
    }
}

