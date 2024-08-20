package org.example.api_users.controller;

import org.example.api_users.dto.*;
import org.example.api_users.model.*;
import org.example.api_users.service.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.Collections;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserControllerSaveFinishedRouteTest {
    @Mock
    private UserService userService;

    @Mock
    private FinishedRouteService finishedRouteService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testSaveFinishedRoute() {
        // Test to verify that a finished route is saved successfully when all parameters are provided.
        String userId = "testUserId";
        FinishedRouteRequest request = new FinishedRouteRequest();
        request.setFinishedRouteId("testFinishedRouteId");
        request.setRouteId("testRouteId");
        request.setSpentMinutes(2.0);
        request.setFinishedDate(Timestamp.valueOf("2024-08-12 12:34:56"));
        request.setUserCollectables(Collections.emptyList());

        when(userService.userExists(userId)).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(finishedRouteService).saveFinishedRoute(any(FinishedRoute.class));
    }

    @Test
    public void testSaveFinishedRouteMissingParameters() {
        // Test to ensure that a bad request response is returned when required parameters are missing for saving a finished route.
        String userId = "testUserId";
        FinishedRouteRequest request = new FinishedRouteRequest();

        when(userService.userExists(userId)).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(finishedRouteService, never()).saveFinishedRoute(any(FinishedRoute.class));
    }

    @Test
    public void testSaveFinishedRouteUserNotFound() {
        // Test to ensure that a not found response is returned when trying to save a finished route for a non-existent user.
        String userId = "testUserId";
        FinishedRouteRequest request = new FinishedRouteRequest();

        when(userService.userExists(userId)).thenReturn(false);

        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(finishedRouteService, never()).saveFinishedRoute(any(FinishedRoute.class));
    }
}
