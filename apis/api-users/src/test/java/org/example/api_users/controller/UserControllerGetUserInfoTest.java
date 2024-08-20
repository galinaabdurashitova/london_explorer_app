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

import java.util.Collections;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserControllerGetUserInfoTest {
    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;
    @Test
    public void testGetUserInfo() {
        // Test to ensure that the user information is retrieved successfully.
        String userId = "testUserId";
        User mockUser = new User(userId, "test@example.com", "Test User", "testUser", null);

        when(userService.getUserById(userId)).thenReturn(Optional.of(mockUser));
        when(userService.findUserAwards(userId)).thenReturn(Collections.emptyList());
        when(userService.findUserCollectables(userId)).thenReturn(Collections.emptyList());
        when(userService.findUserFriends(userId)).thenReturn(Collections.emptyList());
        when(userService.findFinishedRoutes(userId)).thenReturn(Collections.emptyList());

        ResponseEntity<?> responseEntity = userController.getUserInfo(userId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(Map.class);
        assertThat(((Map<?, ?>) responseEntity.getBody()).get("userId")).isEqualTo(userId);
    }

    @Test
    public void testGetUserInfoUserNotFound() {
        // Test to ensure that the appropriate response is returned when a user is not found.
        String userId = "testUserId";

        when(userService.getUserById(userId)).thenReturn(Optional.empty());

        ResponseEntity<?> responseEntity = userController.getUserInfo(userId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isEqualTo("User not found");
    }
}
