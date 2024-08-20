package org.example.api_users.controller;

import org.example.api_users.dto.*;
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
public class UserControllerSendOrConfirmFriendRequestTest {
    @Mock
    private UserService userService;

    @Mock
    private FriendService friendService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testSendOrConfirmFriendRequestSuccess() {
        // Test to verify that a friend request is sent successfully or a friendship is confirmed.
        String userId = "user1";
        String friendUserId = "user2";

        FriendshipRequest request = new FriendshipRequest();
        request.setFriendUserId(friendUserId);

        when(userService.userExists(userId)).thenReturn(true);
        when(userService.userExists(friendUserId)).thenReturn(true);
        when(friendService.isFriendRequestExists(userId, friendUserId)).thenReturn(false);
        when(friendService.isFriendshipConfirmed(userId, friendUserId)).thenReturn(false);

        ResponseEntity<?> responseEntity = userController.sendOrConfirmFriendRequest(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isEqualTo("Friend request sent");

        verify(friendService, times(1)).addOrUpdateFriend(userId, friendUserId);
    }

    @Test
    public void testSendOrConfirmFriendRequestAlreadyConfirmed() {
        // Test to ensure that the response indicates a friendship is already confirmed if both directions exist.
        String userId = "user1";
        String friendUserId = "user2";

        FriendshipRequest request = new FriendshipRequest();
        request.setFriendUserId(friendUserId);

        when(userService.userExists(userId)).thenReturn(true);
        when(userService.userExists(friendUserId)).thenReturn(true);
        when(friendService.isFriendRequestExists(userId, friendUserId)).thenReturn(false);
        when(friendService.isFriendshipConfirmed(userId, friendUserId)).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.sendOrConfirmFriendRequest(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isEqualTo("Friendship confirmed");

        verify(friendService, times(1)).addOrUpdateFriend(userId, friendUserId);
    }

    @Test
    public void testSendOrConfirmFriendRequestMissingParameters() {
        // Test to ensure that a bad request response is returned when required parameters are missing.
        String userId = "user1";
        FriendshipRequest request = new FriendshipRequest();

        ResponseEntity<?> responseEntity = userController.sendOrConfirmFriendRequest(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(responseEntity.getBody()).isEqualTo("Missing parameters");

        verify(friendService, never()).addOrUpdateFriend(anyString(), anyString());
    }

    @Test
    public void testSendOrConfirmFriendRequestUserNotFound() {
        // Test to ensure that a not found response is returned when one of the users does not exist.
        String userId = "user1";
        String friendUserId = "user2";

        FriendshipRequest request = new FriendshipRequest();
        request.setFriendUserId(friendUserId);

        when(userService.userExists(userId)).thenReturn(true);
        when(userService.userExists(friendUserId)).thenReturn(false);

        ResponseEntity<?> responseEntity = userController.sendOrConfirmFriendRequest(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isEqualTo("User not found");

        verify(friendService, never()).addOrUpdateFriend(anyString(), anyString());
    }

    @Test
    public void testSendOrConfirmFriendRequestRequestAlreadyExists() {
        // Test to ensure that a bad request response is returned when a friend request already exists.
        String userId = "user1";
        String friendUserId = "user2";

        FriendshipRequest request = new FriendshipRequest();
        request.setFriendUserId(friendUserId);

        when(userService.userExists(userId)).thenReturn(true);
        when(userService.userExists(friendUserId)).thenReturn(true);
        when(friendService.isFriendRequestExists(userId, friendUserId)).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.sendOrConfirmFriendRequest(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(responseEntity.getBody()).isEqualTo("Request already exists");

        verify(friendService, never()).addOrUpdateFriend(anyString(), anyString());
    }

    @Test
    public void testSendOrConfirmFriendRequestSameUserIds() {
        // Test to ensure that a bad request response is returned when a user tries to send a friend request to themselves.
        String userId = "user1";
        String friendUserId = "user1";

        FriendshipRequest request = new FriendshipRequest();
        request.setFriendUserId(friendUserId);

        when(userService.userExists(userId)).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.sendOrConfirmFriendRequest(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(responseEntity.getBody()).isEqualTo("Wrong userIds");

        verify(friendService, never()).addOrUpdateFriend(anyString(), anyString());
    }
}
