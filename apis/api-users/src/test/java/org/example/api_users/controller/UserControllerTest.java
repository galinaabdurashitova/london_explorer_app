package org.example.api_users.controller;

import org.example.api_users.dto.FinishedRouteRequest;
import org.example.api_users.dto.UserCollectableRequest;
import org.example.api_users.model.*;
import org.example.api_users.service.FinishedRouteService;
import org.example.api_users.service.UserService;
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
public class UserControllerTest {

    @Mock
    private UserService userService;

    @Mock
    private FinishedRouteService finishedRouteService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testSaveFinishedRouteWithUserCollectables() {
        String userId = "testUserId";
        String finishedRouteId = "testFinishedRouteId";
        String routeId = "testRouteId";
        Timestamp finishedDate = Timestamp.valueOf("2024-08-12 12:34:56");

        UserCollectableRequest collectableRequest = new UserCollectableRequest();
        collectableRequest.setUserCollectableId("collectableId1");
        collectableRequest.setCollectable("collectable1");

        FinishedRouteRequest request = new FinishedRouteRequest();
        request.setFinishedRouteId(finishedRouteId);
        request.setRouteId(routeId);
        request.setFinishedDate(finishedDate);
        request.setUserCollectables(Collections.singletonList(collectableRequest));

        when(userService.userExists(userId)).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    public void testSaveFinishedRouteMissingParameters() {
        String userId = "testUserId";
        FinishedRouteRequest request = new FinishedRouteRequest();

        when(userService.userExists(userId)).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
    }

    @Test
    public void testSaveFinishedRouteUserNotFound() {
        String userId = "testUserId";
        FinishedRouteRequest request = new FinishedRouteRequest();

        when(userService.userExists(userId)).thenReturn(false);

        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
    }

    @Test
    public void testSaveFinishedRouteWithDuplicateUserCollectable() {
        String userId = "testUserId";
        String finishedRouteId = "testFinishedRouteId";
        String routeId = "testRouteId";
        Timestamp finishedDate = Timestamp.valueOf("2024-08-12 12:34:56");
        String collectable = "collectable1";

        UserCollectableRequest collectableRequest = new UserCollectableRequest();
        collectableRequest.setUserCollectableId("collectableId1");
        collectableRequest.setCollectable(collectable);

        FinishedRouteRequest request = new FinishedRouteRequest();
        request.setFinishedRouteId(finishedRouteId);
        request.setRouteId(routeId);
        request.setFinishedDate(finishedDate);
        request.setUserCollectables(Collections.singletonList(collectableRequest));

        when(userService.userExists(userId)).thenReturn(true);
        when(finishedRouteService.userCollectableExists(userId, collectable)).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, request);

        // Verify that no new UserCollectable was saved
        verify(finishedRouteService, never()).saveUserCollectable(any(UserCollectable.class));

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

}
