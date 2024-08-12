package org.example.api_users.controller;

import org.example.api_users.model.User;
import org.example.api_users.model.FinishedRoute;
import org.example.api_users.service.UserService;
import org.example.api_users.service.FinishedRouteService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.Collections;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class UserControllerTest {

    @Mock
    private UserService userService;

    @Mock
    private FinishedRouteService finishedRouteService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testGetUserInfo() {
        // Mock data
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        User mockUser = new User(userId, "Test@test.com", "Galina", "Galina", null);

        when(userService.getUserById(userId)).thenReturn(Optional.of(mockUser));
        when(userService.countUserAwards(userId)).thenReturn(0);
        when(userService.countUserCollectables(userId)).thenReturn(0);
        when(userService.findUserFriends(userId)).thenReturn(Collections.emptyList());
        when(userService.findFavouriteRoutes(userId)).thenReturn(Collections.emptyList());
        when(userService.findFinishedRoutes(userId)).thenReturn(Collections.emptyList());

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.getUserInfo(userId);

        // Assertions
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(Map.class);
        assertThat(((Map<?, ?>) responseEntity.getBody()).get("userId")).isEqualTo(userId);
    }

    @Test
    public void testGetUserInfoUserNotFound() {
        // Mock data
        String userId = "NonExistentUserId";

        when(userService.getUserById(userId)).thenReturn(Optional.empty());

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.getUserInfo(userId);

        // Assertions
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isEqualTo("User not found");
    }

    @Test
    public void testCreateUser() {
        // Mock data
        User mockUser = new User("SHrUmpceW6bDkRBLIlS0koDjyNH2", "Test@test.com", "Galina", "Galina", null);

        when(userService.userExists(mockUser.getUserId())).thenReturn(false);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.createUser(mockUser);

        // Assertions
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    public void testCreateUserUserExists() {
        // Mock data
        User mockUser = new User("ExistingUserId", "existing@test.com", "Existing User", "existingUser", null);

        when(userService.userExists(mockUser.getUserId())).thenReturn(true);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.createUser(mockUser);

        // Assertions
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        assertThat(responseEntity.getBody()).isEqualTo("User already exists");
    }

    @Test
    public void testCreateUserMissingParameters() {
        // Mock data with missing parameters
        User mockUser = new User("NewUserId", null, "Galina", "Galina", null);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.createUser(mockUser);

        // Assertions
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(responseEntity.getBody()).isEqualTo("Missing parameters");
    }

    @Test
    public void testSaveFinishedRouteWithEmptyDate() {
        // Mock data
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        FinishedRoute mockFinishedRoute = new FinishedRoute("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, "29751B98-FDF0-485D-B03E-3BD12CA0884C", null, 5);

        when(userService.userExists(userId)).thenReturn(true);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, mockFinishedRoute);

        // Assertions for 400 error due to missing finishedDate
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(responseEntity.getBody()).isEqualTo("Missing parameters");
    }

    @Test
    public void testSaveFinishedRouteWithValidDate() {
        // Mock data
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        Timestamp validFinishedDate = Timestamp.valueOf("2023-08-05 12:34:56");
        FinishedRoute mockFinishedRoute = new FinishedRoute("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, "29751B98-FDF0-485D-B03E-3BD12CA0884C", validFinishedDate, 5);

        when(userService.userExists(userId)).thenReturn(true);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, mockFinishedRoute);

        // Assertions for 200 success with valid finishedDate
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    public void testSaveFinishedRouteUserNotFound() {
        // Mock data
        String userId = "NonExistentUserId";
        FinishedRoute mockFinishedRoute = new FinishedRoute("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, "29751B98-FDF0-485D-B03E-3BD12CA0884C", null, 5);

        when(userService.userExists(userId)).thenReturn(false);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, mockFinishedRoute);

        // Assertions
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isEqualTo("User not found");
    }

    @Test
    public void testSaveFinishedRouteMissingParameters() {
        // Mock data with missing parameters
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        FinishedRoute mockFinishedRoute = new FinishedRoute("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, null, null, 0);

        when(userService.userExists(userId)).thenReturn(true);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, mockFinishedRoute);

        // Assertions
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(responseEntity.getBody()).isEqualTo("Missing parameters");
    }
}
