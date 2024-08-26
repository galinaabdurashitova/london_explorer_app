package org.example.api_users.controller;

import org.example.api_users.model.*;
import org.example.api_users.service.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserControllerCreateUserTest {
    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testCreateUser() {
        // Test to verify that a user is created successfully when all parameters are provided.
        User mockUser = new User("testUserId", "test@example.com", "Test User", "testUser", null, null);

        when(userService.userExists(mockUser.getUserId())).thenReturn(false);

        ResponseEntity<?> responseEntity = userController.createUser(mockUser);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(userService).saveUser(mockUser);
    }

    @Test
    public void testCreateUserUserExists() {
        // Test to ensure that a conflict response is returned when trying to create a user that already exists.
        User mockUser = new User("testUserId", "test@example.com", "Test User", "testUser", null, null);

        when(userService.userExists(mockUser.getUserId())).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.createUser(mockUser);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        assertThat(responseEntity.getBody()).isEqualTo("User already exists");
    }

    @Test
    public void testCreateUserMissingParameters() {
        // Test to ensure that a bad request response is returned when required parameters are missing.
        User mockUser = new User(null, null, null, null, null, null);

        ResponseEntity<?> responseEntity = userController.createUser(mockUser);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(responseEntity.getBody()).isEqualTo("Missing parameters");
    }
}
