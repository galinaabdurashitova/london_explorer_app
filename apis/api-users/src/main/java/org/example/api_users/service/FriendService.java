package org.example.api_users.service;

import org.example.api_users.model.Friend;
import org.example.api_users.repository.FriendRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
public class FriendService {

    @Autowired
    private FriendRepository friendRepository;

    public void addOrUpdateFriend(String userId, String friendUserId) {
        String friendshipId = UUID.randomUUID().toString();
        Friend confirmedFriendship = new Friend(friendshipId, userId, friendUserId);
        friendRepository.save(confirmedFriendship);
    }

    public boolean isFriendRequestExists(String userId, String friendUserId) {
        return friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId);
    }

    public boolean isFriendshipConfirmed(String userId, String friendUserId) {
        return friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)
                && friendRepository.existsByUser1IdAndUser2Id(friendUserId, userId);
    }
}
