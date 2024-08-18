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
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserControllerTest {

    @Mock
    private UserService userService;

    @Mock
    private FinishedRouteService finishedRouteService;

    @Mock
    private UserAwardService userAwardService;

    @Mock
    private FriendService friendService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testGetUserInfo() {
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
        String userId = "testUserId";

        when(userService.getUserById(userId)).thenReturn(Optional.empty());

        ResponseEntity<?> responseEntity = userController.getUserInfo(userId);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isEqualTo("User not found");
    }

    @Test
    public void testCreateUser() {
        User mockUser = new User("testUserId", "test@example.com", "Test User", "testUser", null);

        when(userService.userExists(mockUser.getUserId())).thenReturn(false);

        ResponseEntity<?> responseEntity = userController.createUser(mockUser);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(userService).saveUser(mockUser);
    }

    @Test
    public void testCreateUserUserExists() {
        User mockUser = new User("testUserId", "test@example.com", "Test User", "testUser", null);

        when(userService.userExists(mockUser.getUserId())).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.createUser(mockUser);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        assertThat(responseEntity.getBody()).isEqualTo("User already exists");
    }

    @Test
    public void testCreateUserMissingParameters() {
        User mockUser = new User(null, null, null, null, null);

        ResponseEntity<?> responseEntity = userController.createUser(mockUser);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(responseEntity.getBody()).isEqualTo("Missing parameters");
    }

    @Test
    public void testSaveFinishedRoute() {
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
        String userId = "testUserId";
        FinishedRouteRequest request = new FinishedRouteRequest();

        when(userService.userExists(userId)).thenReturn(true);

        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(finishedRouteService, never()).saveFinishedRoute(any(FinishedRoute.class));
    }

    @Test
    public void testSaveFinishedRouteUserNotFound() {
        String userId = "testUserId";
        FinishedRouteRequest request = new FinishedRouteRequest();

        when(userService.userExists(userId)).thenReturn(false);

        ResponseEntity<?> responseEntity = userController.saveFinishedRoute(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(finishedRouteService, never()).saveFinishedRoute(any(FinishedRoute.class));
    }

    @Test
    public void testSaveUserAward() {
        String userId = "testUserId";
        UserAwardRequest request = new UserAwardRequest();
        request.setUserAwardId("awardId1");
        request.setAward("award1");
        request.setAwardLevel(2);
        request.setAwardDate(Timestamp.valueOf("2024-08-12 12:34:56"));

        when(userAwardService.getPreviousLevelsNumber(userId, "award1")).thenReturn(1);

        ResponseEntity<?> responseEntity = userController.saveUserAward(userId, List.of(request));

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(userAwardService, times(1)).saveUserAward(any(UserAward.class));
    }

    @Test
    public void testSaveUserAwardMissingParameters() {
        String userId = "testUserId";
        UserAwardRequest request = new UserAwardRequest();

        ResponseEntity<?> responseEntity = userController.saveUserAward(userId, List.of(request));

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(userAwardService, never()).saveUserAward(any(UserAward.class));
    }

    @Test
    public void testSaveUserAwardWrongLevel() {
        String userId = "testUserId";
        UserAwardRequest request = new UserAwardRequest();
        request.setUserAwardId("awardId1");
        request.setAward("award1");
        request.setAwardLevel(1);
        request.setAwardDate(Timestamp.valueOf("2024-08-12 12:34:56"));

        when(userAwardService.getPreviousLevelsNumber(userId, "award1")).thenReturn(2);

        ResponseEntity<?> responseEntity = userController.saveUserAward(userId, List.of(request));

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(userAwardService, never()).saveUserAward(any(UserAward.class));
    }

    @Test
    public void testGetUsersByIds() {
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
        List<User> mockUsers = Arrays.asList(
                new User("1", "user1@example.com", "User One", "user1", null),
                new User("2", "user2@example.com", "User Two", "user2", null)
        );

        when(userService.getUsersByIds(null)).thenReturn(mockUsers);

        ResponseEntity<?> responseEntity = userController.getUsers(null);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }

    @Test
    public void testGetUsersByIdsSomeNotFound() {
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

    @Test
    public void testUpdateUserSuccess() {
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
        String userId = "testUserId";

        when(userService.getUserById(userId)).thenReturn(Optional.empty());

        UserUpdateRequest updateRequest = new UserUpdateRequest();
        updateRequest.setName("Updated Name");

        ResponseEntity<?> responseEntity = userController.updateUser(userId, updateRequest);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        verify(userService, never()).saveUser(any());
    }

    @Test
    public void testSendOrConfirmFriendRequestSuccess() {
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
        String userId = "user1";
        FriendshipRequest request = new FriendshipRequest();

        ResponseEntity<?> responseEntity = userController.sendOrConfirmFriendRequest(userId, request);

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(responseEntity.getBody()).isEqualTo("Missing parameters");

        verify(friendService, never()).addOrUpdateFriend(anyString(), anyString());
    }

    @Test
    public void testSendOrConfirmFriendRequestUserNotFound() {
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
