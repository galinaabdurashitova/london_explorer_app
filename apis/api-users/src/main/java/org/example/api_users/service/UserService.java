package org.example.api_users.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.example.api_users.model.User;
import org.example.api_users.model.FinishedRoute;
import org.example.api_users.repository.UserRepository;

import java.util.List;
import java.util.Optional;

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

    public int countUserAwards(String userId) {
        return userRepository.countUserAwards(userId);
    }

    public int countUserCollectables(String userId) {
        return userRepository.countUserCollectables(userId);
    }

    public List<String> findUserFriends(String userId) {
        return userRepository.findUserFriends(userId);
    }

    public List<String> findFavouriteRoutes(String userId) {
        return userRepository.findFavouriteRoutes(userId);
    }

    public List<FinishedRoute> findFinishedRoutes(String userId) {
        return userRepository.findFinishedRoutes(userId);
    }
}
