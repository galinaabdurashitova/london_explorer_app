package org.example.api_users.service;

import org.example.api_users.model.Friend;
import org.example.api_users.repository.FriendRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.sql.Timestamp;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class FriendServiceTest {

    @Mock
    private FriendRepository friendRepository;

    @InjectMocks
    private FriendService friendService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testAddOrUpdateFriend() {
        // Verifies that addOrUpdateFriend correctly adds or updates a friendship in the repository.
        String userId = "user1";
        String friendUserId = "user2";
        Friend mockFriend = new Friend(UUID.randomUUID().toString(), userId, friendUserId,  new Timestamp(System.currentTimeMillis()));

        when(friendRepository.save(any(Friend.class))).thenReturn(mockFriend);

        friendService.addOrUpdateFriend(userId, friendUserId);

        verify(friendRepository, times(1)).save(any(Friend.class));
    }

    @Test
    public void testIsFriendRequestExistsTrue() {
        // Ensures that isFriendRequestExists returns true when a friend request exists in the repository.
        String userId = "user1";
        String friendUserId = "user2";

        when(friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)).thenReturn(true);

        boolean exists = friendService.isFriendRequestExists(userId, friendUserId);

        assertThat(exists).isTrue();
    }

    @Test
    public void testIsFriendRequestExistsFalse() {
        // Ensures that isFriendRequestExists returns false when a friend request does not exist in the repository.
        String userId = "user1";
        String friendUserId = "user2";

        when(friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)).thenReturn(false);

        boolean exists = friendService.isFriendRequestExists(userId, friendUserId);

        assertThat(exists).isFalse();
    }

    @Test
    public void testIsFriendshipConfirmedTrue() {
        // Verifies that isFriendshipConfirmed returns true when a mutual friendship exists in the repository.
        String userId = "user1";
        String friendUserId = "user2";

        when(friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)).thenReturn(true);
        when(friendRepository.existsByUser1IdAndUser2Id(friendUserId, userId)).thenReturn(true);

        boolean confirmed = friendService.isFriendshipConfirmed(userId, friendUserId);

        assertThat(confirmed).isTrue();
    }

    @Test
    public void testIsFriendshipConfirmedFalse() {
        // Verifies that isFriendshipConfirmed returns false when a mutual friendship does not exist in the repository.
        String userId = "user1";
        String friendUserId = "user2";

        when(friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)).thenReturn(true);
        when(friendRepository.existsByUser1IdAndUser2Id(friendUserId, userId)).thenReturn(false);

        boolean confirmed = friendService.isFriendshipConfirmed(userId, friendUserId);

        assertThat(confirmed).isFalse();
    }

    @Test
    public void testDeclineFriendRequest() {
        // Ensures that declineFriendRequest correctly removes a friend request from the repository.
        String userId = "user1";
        String friendUserId = "user2";
        Friend mockFriendRequest = new Friend(UUID.randomUUID().toString(), friendUserId, userId,  new Timestamp(System.currentTimeMillis()));

        // Mocking the behavior of finding a friend request
        when(friendRepository.findFriendRequest(friendUserId, userId)).thenReturn(mockFriendRequest);

        // Call the service method to decline the friend request
        friendService.declineFriendRequest(friendUserId, userId);

        // Verify that the friendRepository's deleteById method was called with the correct friendship ID
        verify(friendRepository, times(1)).deleteById(mockFriendRequest.getFriendshipId());
    }
}
