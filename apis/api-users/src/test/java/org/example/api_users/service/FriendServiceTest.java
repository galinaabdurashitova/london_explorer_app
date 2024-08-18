package org.example.api_users.service;

import org.example.api_users.model.Friend;
import org.example.api_users.repository.FriendRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Optional;
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
        String userId = "user1";
        String friendUserId = "user2";
        Friend mockFriend = new Friend(UUID.randomUUID().toString(), userId, friendUserId);

        when(friendRepository.save(any(Friend.class))).thenReturn(mockFriend);

        friendService.addOrUpdateFriend(userId, friendUserId);

        verify(friendRepository, times(1)).save(any(Friend.class));
    }

    @Test
    public void testIsFriendRequestExistsTrue() {
        String userId = "user1";
        String friendUserId = "user2";

        when(friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)).thenReturn(true);

        boolean exists = friendService.isFriendRequestExists(userId, friendUserId);

        assertThat(exists).isTrue();
    }

    @Test
    public void testIsFriendRequestExistsFalse() {
        String userId = "user1";
        String friendUserId = "user2";

        when(friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)).thenReturn(false);

        boolean exists = friendService.isFriendRequestExists(userId, friendUserId);

        assertThat(exists).isFalse();
    }

    @Test
    public void testIsFriendshipConfirmedTrue() {
        String userId = "user1";
        String friendUserId = "user2";

        when(friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)).thenReturn(true);
        when(friendRepository.existsByUser1IdAndUser2Id(friendUserId, userId)).thenReturn(true);

        boolean confirmed = friendService.isFriendshipConfirmed(userId, friendUserId);

        assertThat(confirmed).isTrue();
    }

    @Test
    public void testIsFriendshipConfirmedFalse() {
        String userId = "user1";
        String friendUserId = "user2";

        when(friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)).thenReturn(true);
        when(friendRepository.existsByUser1IdAndUser2Id(friendUserId, userId)).thenReturn(false);

        boolean confirmed = friendService.isFriendshipConfirmed(userId, friendUserId);

        assertThat(confirmed).isFalse();
    }
}
