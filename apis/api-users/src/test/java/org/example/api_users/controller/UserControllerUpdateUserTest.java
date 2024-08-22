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

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserControllerUpdateUserTest {
    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testUpdateUserSuccess() {
        // Test to verify that the user's information is updated successfully when the user is found.
        String userId = "testUserId";
        User existingUser = new User(userId, "original@test.com", "Original Name", "originalUserName", "Original description");

        when(userService.getUserById(userId)).thenReturn(Optional.of(existingUser));

        UserUpdateRequest updateRequest = new UserUpdateRequest();
        updateRequest.setName("Updated Name");
        updateRequest.setDescription("Updated description");

        ResponseEntity<?> responseEntity = userController.updateUser(userId, updateRequest);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(existingUser.getName()).isEqualTo("Updated Name");
        assertThat(existingUser.getDescription()).isEqualTo("Updated description");
        verify(userService).saveUser(existingUser);
    }

    @Test
    public void testUpdateUserNotFound() {
        // Test to ensure that a not found response is returned when trying to update a non-existent user.
        String userId = "testUserId";

        when(userService.getUserById(userId)).thenReturn(Optional.empty());

        UserUpdateRequest updateRequest = new UserUpdateRequest();
        updateRequest.setName("Updated Name");

        ResponseEntity<?> responseEntity = userController.updateUser(userId, updateRequest);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(userService, never()).saveUser(any());
    }
}
