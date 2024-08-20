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

import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserControllerGetUsersTest {
    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testGetUsersByIds() {
        // Test to verify that users are retrieved successfully by their IDs.
        List<String> userIds = Arrays.asList("1", "2");
        List<User> mockUsers = Arrays.asList(
                new User("1", "user1@example.com", "User One", "user1", null),
                new User("2", "user2@example.com", "User Two", "user2", null)
        );

        when(userService.getUsersByIds(userIds)).thenReturn(mockUsers);

        ResponseEntity<?> responseEntity = userController.getUsers(userIds);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }

    @Test
    public void testGetUsersWithNoIds() {
        // Test to verify that all users are retrieved when no IDs are provided.
        List<User> mockUsers = Arrays.asList(
                new User("1", "user1@example.com", "User One", "user1", null),
                new User("2", "user2@example.com", "User Two", "user2", null)
        );

        // Mock the getAllUsers method instead of getUsersByIds(null)
        when(userService.getAllUsers()).thenReturn(mockUsers);

        ResponseEntity<?> responseEntity = userController.getUsers(null);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }

    @Test
    public void testGetUsersByIdsSomeNotFound() {
        // Test to verify that only the users found by their IDs are returned, excluding the ones not found.
        List<String> userIds = Arrays.asList("1", "2", "3");
        List<User> mockUsers = Arrays.asList(
                new User("1", "user1@example.com", "User One", "user1", null),
                new User("2", "user2@example.com", "User Two", "user2", null)
        );

        when(userService.getUsersByIds(userIds)).thenReturn(mockUsers);

        ResponseEntity<?> responseEntity = userController.getUsers(userIds);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }
}
