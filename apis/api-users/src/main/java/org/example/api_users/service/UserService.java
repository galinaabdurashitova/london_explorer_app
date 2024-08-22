package org.example.api_users.service;

import org.example.api_users.model.*;
import org.example.api_users.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.example.api_users.model.User;
import org.example.api_users.model.FinishedRoute;
import org.example.api_users.repository.UserRepository;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public Optional<User> getUserById(String userId) {
        return userRepository.findById(userId);
    }

    public void saveUser(User user) {
        userRepository.save(user);
    }

    public boolean userExists(String userId) {
        return userRepository.existsById(userId);
    }

    public List<String> findUserFriends(String userId) {
        return userRepository.findUserFriends(userId);
    }

    public List<FinishedRoute> findFinishedRoutes(String userId) {
        return userRepository.findFinishedRoutes(userId);
    }

    public List<UserAward> findUserAwards(String userId) {
        return userRepository.findUserAwards(userId);
    }

    public List<UserCollectable> findUserCollectables(String userId) { return userRepository.findUserCollectables(userId); }

    public List<User> getUsersByIds(List<String> userIds) {
        return userRepository.findByUserIdIn(userIds);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public List<FriendUpdateResponse> getFriendsUpdates(String userId, int limit) {
        List<Object[]> updates = userRepository.findFriendsUpdates(userId, limit);

        return updates.stream().map(update -> new FriendUpdateResponse(
                (String) update[0], // userId
                (String) update[1], // name
                (String) update[2], // userName
                (Timestamp) update[3], // updateDate
                (String) update[4], // updateType
                (String) update[5]  // description
        )).collect(Collectors.toList());
    }
}
