package org.example.api_users.controller;

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
public class UserControllerDeleteFriendTest {

    @Mock
    private UserService userService;

    @Mock
    private FriendService friendService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testDeleteFriendSuccess() {
        // Test to verify that a friend is successfully deleted when all conditions are met.
        String userId = "user1";
        String friendUserId = "user2";

        // Mock the necessary services
        when(userService.userExists(userId)).thenReturn(true);
        when(userService.userExists(friendUserId)).thenReturn(true);
        when(friendService.isFriendRequestExists(friendUserId, userId)).thenReturn(true);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.deleteFriend(userId, friendUserId);

        // Assert that the response status code is OK (200)
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);

        // Verify that the friendService's declineFriendRequest method was called once with the correct parameters
        verify(friendService, times(1)).declineFriendRequest(friendUserId, userId);
    }

    @Test
    public void testDeleteFriendUserNotFound() {
        // Test to ensure that a not found response is returned when the user does not exist.
        String userId = "user1";
        String friendUserId = "user2";

        // Mock that the user does not exist
        when(userService.userExists(userId)).thenReturn(false);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.deleteFriend(userId, friendUserId);

        // Assert that the response status code is NOT FOUND (404)
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isEqualTo("User not found");

        // Verify that the friendService's declineFriendRequest method was not called
        verify(friendService, never()).declineFriendRequest(anyString(), anyString());
    }

    @Test
    public void testDeleteFriendFriendUserNotFound() {
        // Test to ensure that a not found response is returned when the friend does not exist.
        String userId = "user1";
        String friendUserId = "user2";

        // Mock that the user exists but the friend does not
        when(userService.userExists(userId)).thenReturn(true);
        when(userService.userExists(friendUserId)).thenReturn(false);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.deleteFriend(userId, friendUserId);

        // Assert that the response status code is NOT FOUND (404)
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isEqualTo("Friend user not found");

        // Verify that the friendService's declineFriendRequest method was not called
        verify(friendService, never()).declineFriendRequest(anyString(), anyString());
    }

    @Test
    public void testDeleteFriendFriendshipDoesNotExist() {
        // Test to ensure that a not found response is returned when the friendship does not exist.
        String userId = "user1";
        String friendUserId = "user2";

        // Mock that both users exist, but the friendship does not exist
        when(userService.userExists(userId)).thenReturn(true);
        when(userService.userExists(friendUserId)).thenReturn(true);
        when(friendService.isFriendRequestExists(friendUserId, userId)).thenReturn(false);

        // Call the controller method
        ResponseEntity<?> responseEntity = userController.deleteFriend(userId, friendUserId);

        // Assert that the response status code is NOT FOUND (404)
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isEqualTo("Friendship does not exist");

        // Verify that the friendService's declineFriendRequest method was not called
        verify(friendService, never()).declineFriendRequest(anyString(), anyString());
    }
}
