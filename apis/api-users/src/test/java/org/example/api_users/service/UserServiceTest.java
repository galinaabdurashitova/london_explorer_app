package org.example.api_users.service;

import org.example.api_users.dto.*;
import org.example.api_users.model.*;
import org.example.api_users.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.sql.Timestamp;
import java.util.Optional;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testGetUserById() {
        // Verifies that UserService.getUserById correctly retrieves a user by their ID.
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        User mockUser = new User(userId, "Test@test.com", "Galina", "Galina", null);

        when(userRepository.findById(userId)).thenReturn(Optional.of(mockUser));

        Optional<User> user = userService.getUserById(userId);

        assertThat(user).isPresent();
        assertThat(user.get().getUserId()).isEqualTo(userId);
    }

    @Test
    public void testSaveUser() {
        // Ensures that UserService.saveUser correctly saves a user to the repository.
        User mockUser = new User("SHrUmpceW6bDkRBLIlS0koDjyNH2", "test@test.com", "Text", "Test", null);

        userService.saveUser(mockUser);

        verify(userRepository).save(mockUser);
    }

    @Test
    public void testFindUserFriends() {
        // Confirms that UserService.findUserFriends returns the correct list of friends for a user.
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        List<String> mockFriends = Collections.singletonList("friendId");

        when(userRepository.findUserFriends(userId)).thenReturn(mockFriends);

        List<String> friends = userService.findUserFriends(userId);

        assertThat(friends).isNotEmpty();
        assertThat(friends).contains("friendId");
    }

    @Test
    public void testFindFinishedRoutes() {
        // Validates that UserService.findFinishedRoutes retrieves all finished routes for a user.
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        FinishedRoute mockFinishedRoute = new FinishedRoute("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, "29751B98-FDF0-485D-B03E-3BD12CA0884C", 0.0, null, 0);

        when(userRepository.findFinishedRoutes(userId)).thenReturn(Collections.singletonList(mockFinishedRoute));

        List<FinishedRoute> finishedRoutes = userService.findFinishedRoutes(userId);

        assertThat(finishedRoutes).isNotEmpty();
        assertThat(finishedRoutes.get(0).getFinishedRouteId()).isEqualTo("944F0FA9-256B-4568-92D7-855FA473FAE0");
    }

    @Test
    public void testFindUserAwards() {
        // Ensures that UserService.findUserAwards returns the list of awards for a user.
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        UserAward mockUserAward = new UserAward("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, "Finished routes", 1, null);

        when(userRepository.findUserAwards(userId)).thenReturn(Collections.singletonList(mockUserAward));

        List<UserAward> userAwards = userService.findUserAwards(userId);

        assertThat(userAwards).isNotEmpty();
        assertThat(userAwards.get(0).getUserAwardId()).isEqualTo("944F0FA9-256B-4568-92D7-855FA473FAE0");
    }

    @Test
    public void testFindUserCollectables() {
        // Confirms that UserService.findUserCollectables correctly retrieves the user's collectables.
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        UserCollectable mockUserCollectable = new UserCollectable("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, "Bulldog", "29751B98-FDF0-485D-B03E-3BD12CA0884C");

        when(userRepository.findUserCollectables(userId)).thenReturn(Collections.singletonList(mockUserCollectable));

        List<UserCollectable> userCollectable = userService.findUserCollectables(userId);

        assertThat(userCollectable).isNotEmpty();
        assertThat(userCollectable.get(0).getUserCollectableId()).isEqualTo("944F0FA9-256B-4568-92D7-855FA473FAE0");
    }

    @Test
    public void testGetUsersByIds() {
        // Verifies that UserService.getUsersByIds returns users by a list of IDs.
        List<String> userIds = Collections.singletonList("SHrUmpceW6bDkRBLIlS0koDjyNH2");
        User mockUser = new User("SHrUmpceW6bDkRBLIlS0koDjyNH2", "test@test.com", "Galina", "Galina", null);

        when(userRepository.findByUserIdIn(userIds)).thenReturn(Collections.singletonList(mockUser));

        List<User> users = userService.getUsersByIds(userIds);

        assertThat(users).isNotEmpty();
        assertThat(users.get(0).getUserId()).isEqualTo("SHrUmpceW6bDkRBLIlS0koDjyNH2");
    }

    @Test
    public void testGetAllUsers() {
        // Confirms that UserService.getAllUsers retrieves all users in the repository.
        User mockUser1 = new User("SHrUmpceW6bDkRBLIlS0koDjyNH2", "test1@test.com", "Galina", "Galina", null);
        User mockUser2 = new User("ABC123", "test2@test.com", "Ivan", "Ivan123", null);

        when(userRepository.findAll()).thenReturn(List.of(mockUser1, mockUser2));

        List<User> users = userService.getAllUsers();

        assertThat(users).isNotEmpty();
        assertThat(users.size()).isEqualTo(2);
        assertThat(users.get(0).getUserId()).isEqualTo("SHrUmpceW6bDkRBLIlS0koDjyNH2");
        assertThat(users.get(1).getUserId()).isEqualTo("ABC123");
    }

    @Test
    public void testGetFriendsUpdates() {
        // Arrange
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        int limit = 5;
        List<Object[]> mockUpdates = List.of(
                new Object[]{"friendId1", "Friend One", "friend1", Timestamp.valueOf("2024-08-15 12:34:56"), "FinishedRoute", "Route ID 123"},
                new Object[]{"friendId2", "Friend Two", "friend2", Timestamp.valueOf("2024-08-16 13:45:00"), "Award", "Top Scorer Level 2"}
        );

        when(userRepository.findFriendsUpdates(userId, limit)).thenReturn(mockUpdates);

        // Act
        List<FriendUpdateResponse> updates = userService.getFriendsUpdates(userId, limit);

        // Assert
        assertThat(updates).isNotEmpty();
        assertThat(updates.size()).isEqualTo(2);

        FriendUpdateResponse firstUpdate = updates.get(0);
        assertThat(firstUpdate.getUserId()).isEqualTo("friendId1");
        assertThat(firstUpdate.getName()).isEqualTo("Friend One");
        assertThat(firstUpdate.getUserName()).isEqualTo("friend1");
        assertThat(firstUpdate.getUpdateDate()).isEqualTo(Timestamp.valueOf("2024-08-15 12:34:56"));
        assertThat(firstUpdate.getUpdateType()).isEqualTo("FinishedRoute");
        assertThat(firstUpdate.getDescription()).isEqualTo("Route ID 123");

        FriendUpdateResponse secondUpdate = updates.get(1);
        assertThat(secondUpdate.getUserId()).isEqualTo("friendId2");
        assertThat(secondUpdate.getName()).isEqualTo("Friend Two");
        assertThat(secondUpdate.getUserName()).isEqualTo("friend2");
        assertThat(secondUpdate.getUpdateDate()).isEqualTo(Timestamp.valueOf("2024-08-16 13:45:00"));
        assertThat(secondUpdate.getUpdateType()).isEqualTo("Award");
        assertThat(secondUpdate.getDescription()).isEqualTo("Top Scorer Level 2");
    }
}
