package org.example.api_users.service;

import org.example.api_users.model.FinishedRoute;
import org.example.api_users.model.UserAward;
import org.example.api_users.repository.UserAwardRepository;
import org.example.api_users.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserAwardService {

    @Autowired
    private UserAwardRepository userAwardRepository;

    public void saveUserAward(UserAward userAward) { userAwardRepository.save(userAward); }

    public int getPreviousLevelsNumber(String userId, String award) {
        return userAwardRepository.getPreviousLevelsNumber(userId, award);
    }
}
