package org.example.api_users.service;

import org.example.api_users.model.User;
import org.example.api_users.model.FinishedRoute;
import org.example.api_users.model.UserAward;
import org.example.api_users.model.UserCollectable;
import org.example.api_users.repository.UserRepository;
import org.example.api_users.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

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
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        User mockUser = new User(userId, "Test@test.com", "Galina", "Galina", null);

        when(userRepository.findById(userId)).thenReturn(Optional.of(mockUser));

        Optional<User> user = userService.getUserById(userId);

        assertThat(user).isPresent();
        assertThat(user.get().getUserId()).isEqualTo(userId);
    }

    @Test
    public void testSaveUser() {
        User mockUser = new User("SHrUmpceW6bDkRBLIlS0koDjyNH2", "test@test.com", "Text", "Test", null);

        userService.saveUser(mockUser);

        verify(userRepository).save(mockUser);
    }

    @Test
    public void testFindUserFriends() {
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        List<String> mockFriends = Collections.singletonList("friendId");

        when(userRepository.findUserFriends(userId)).thenReturn(mockFriends);

        List<String> friends = userService.findUserFriends(userId);

        assertThat(friends).isNotEmpty();
        assertThat(friends).contains("friendId");
    }

    @Test
    public void testFindFinishedRoutes() {
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        FinishedRoute mockFinishedRoute = new FinishedRoute("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, "29751B98-FDF0-485D-B03E-3BD12CA0884C", 0.0, null, 0);

        when(userRepository.findFinishedRoutes(userId)).thenReturn(Collections.singletonList(mockFinishedRoute));

        List<FinishedRoute> finishedRoutes = userService.findFinishedRoutes(userId);

        assertThat(finishedRoutes).isNotEmpty();
        assertThat(finishedRoutes.get(0).getFinishedRouteId()).isEqualTo("944F0FA9-256B-4568-92D7-855FA473FAE0");
    }

    @Test
    public void testFindUserAwards() {
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        UserAward mockUserAward = new UserAward("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, "Finished routes", 1, null);

        when(userRepository.findUserAwards(userId)).thenReturn(Collections.singletonList(mockUserAward));

        List<UserAward> userAwards = userService.findUserAwards(userId);

        assertThat(userAwards).isNotEmpty();
        assertThat(userAwards.get(0).getUserAwardId()).isEqualTo("944F0FA9-256B-4568-92D7-855FA473FAE0");
    }

    @Test
    public void testFindUserCollectables() {
        String userId = "SHrUmpceW6bDkRBLIlS0koDjyNH2";
        UserCollectable mockUserCollectable = new UserCollectable("944F0FA9-256B-4568-92D7-855FA473FAE0", userId, "Bulldog", "29751B98-FDF0-485D-B03E-3BD12CA0884C");

        when(userRepository.findUserCollectables(userId)).thenReturn(Collections.singletonList(mockUserCollectable));

        List<UserCollectable> userCollectable = userService.findUserCollectables(userId);

        assertThat(userCollectable).isNotEmpty();
        assertThat(userCollectable.get(0).getUserCollectableId()).isEqualTo("944F0FA9-256B-4568-92D7-855FA473FAE0");
    }
}
