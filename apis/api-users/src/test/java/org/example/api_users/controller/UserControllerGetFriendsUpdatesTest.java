package org.example.api_users.controller;

import org.example.api_users.dto.FriendUpdateResponse;
import org.example.api_users.service.UserService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class UserControllerGetFriendsUpdatesTest {

    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testGetFriendsUpdates() {
        // Arrange
        String userId = "testUserId";
        int limit = 5;

        List<FriendUpdateResponse> mockUpdates = List.of(
                new FriendUpdateResponse("friendId1", "Friend One", "friend1", Timestamp.valueOf("2024-08-15 12:34:56"), "FinishedRoute", "Route ID 123"),
                new FriendUpdateResponse("friendId2", "Friend Two", "friend2", Timestamp.valueOf("2024-08-16 13:45:00"), "Award", "Top Scorer Level 2")
        );

        when(userService.getFriendsUpdates(userId, limit)).thenReturn(mockUpdates);

        // Act
        ResponseEntity<List<FriendUpdateResponse>> responseEntity = userController.getFriendsUpdates(userId, limit);

        // Assert
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isNotEmpty();
        assertThat(responseEntity.getBody().size()).isEqualTo(2);

        FriendUpdateResponse firstUpdate = responseEntity.getBody().get(0);
        assertThat(firstUpdate.getUserId()).isEqualTo("friendId1");
        assertThat(firstUpdate.getName()).isEqualTo("Friend One");
        assertThat(firstUpdate.getUserName()).isEqualTo("friend1");
        assertThat(firstUpdate.getUpdateDate()).isEqualTo(Timestamp.valueOf("2024-08-15 12:34:56"));
        assertThat(firstUpdate.getUpdateType()).isEqualTo("FinishedRoute");
        assertThat(firstUpdate.getDescription()).isEqualTo("Route ID 123");

        FriendUpdateResponse secondUpdate = responseEntity.getBody().get(1);
        assertThat(secondUpdate.getUserId()).isEqualTo("friendId2");
        assertThat(secondUpdate.getName()).isEqualTo("Friend Two");
        assertThat(secondUpdate.getUserName()).isEqualTo("friend2");
        assertThat(secondUpdate.getUpdateDate()).isEqualTo(Timestamp.valueOf("2024-08-16 13:45:00"));
        assertThat(secondUpdate.getUpdateType()).isEqualTo("Award");
        assertThat(secondUpdate.getDescription()).isEqualTo("Top Scorer Level 2");
    }

    @Test
    public void testGetFriendsUpdatesEmptyResult() {
        // Arrange
        String userId = "testUserId";
        int limit = 5;

        when(userService.getFriendsUpdates(userId, limit)).thenReturn(List.of());

        // Act
        ResponseEntity<List<FriendUpdateResponse>> responseEntity = userController.getFriendsUpdates(userId, limit);

        // Assert
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isEmpty();
    }
}
