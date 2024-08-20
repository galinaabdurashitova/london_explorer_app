package org.example.api_users.service;

import org.example.api_users.model.Friend;
import org.example.api_users.repository.FriendRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class FriendService {

    @Autowired
    private FriendRepository friendRepository;

    public void addOrUpdateFriend(String userId, String friendUserId) {
        String friendshipId = UUID.randomUUID().toString();
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        Friend confirmedFriendship = new Friend(friendshipId, userId, friendUserId, timestamp);
        friendRepository.save(confirmedFriendship);
    }

    public boolean isFriendRequestExists(String userId, String friendUserId) {
        return friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId);
    }

    public boolean isFriendshipConfirmed(String userId, String friendUserId) {
        return friendRepository.existsByUser1IdAndUser2Id(userId, friendUserId)
                && friendRepository.existsByUser1IdAndUser2Id(friendUserId, userId);
    }

    public void declineFriendRequest(String userId, String friendUserId) {
        Friend friendRequest = friendRepository.findFriendRequest(userId, friendUserId);
        friendRepository.deleteById(friendRequest.getFriendshipId());
    }

    public List<String> findUsersFriendRequests(String userId) {
        return friendRepository.findFriendRequests(userId);
    }
}
