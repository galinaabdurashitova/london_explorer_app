package org.example.api_users.controller;

import org.example.api_users.dto.*;
import org.example.api_users.model.*;
import org.example.api_users.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private FinishedRouteService finishedRouteService;

    @Autowired
    private UserAwardService userAwardService;

    @GetMapping
    public ResponseEntity<?> getUserInfo(@RequestParam String userId) {
        Optional<User> user = userService.getUserById(userId);
        if (!user.isPresent()) {
            return ResponseEntity.status(404).body("User not found");
        }

        Map<String, Object> response = new HashMap<>();
        response.put("userId", user.get().getUserId());
        response.put("email", user.get().getEmail());
        response.put("name", user.get().getName());
        response.put("userName", user.get().getUserName());
        response.put("description", user.get().getDescription());
        response.put("awards", userService.findUserAwards(userId));
        response.put("collectables", userService.findUserCollectables(userId));
        response.put("friends", userService.findUserFriends(userId));
        response.put("finishedRoutes", userService.findFinishedRoutes(userId));

        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody User user) {
        if (userService.userExists(user.getUserId())) {
            return ResponseEntity.status(409).body("User already exists");
        }

        if (user.getUserId() == null || user.getEmail() == null || user.getName() == null || user.getUserName() == null) {
            return ResponseEntity.status(400).body("Missing parameters");
        }

        userService.saveUser(user);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{userId}/finishedRoutes")
    public ResponseEntity<?> saveFinishedRoute(@PathVariable String userId, @RequestBody FinishedRouteRequest request) {
        if (!userService.userExists(userId)) {
            return ResponseEntity.status(404).body("User not found");
        }

        if (request.getFinishedRouteId() == null || request.getRouteId() == null || request.getFinishedDate() == null) {
            return ResponseEntity.status(400).body("Missing parameters");
        }

        // Save the FinishedRoute
        FinishedRoute finishedRoute = new FinishedRoute(
                request.getFinishedRouteId(),
                userId,
                request.getRouteId(),
                request.getSpentMinutes(),
                request.getFinishedDate(),
                request.getUserCollectables().size()
        );
        finishedRouteService.saveFinishedRoute(finishedRoute);

        // Save the UserCollectables
        if (request.getUserCollectables() != null) {
            for (UserCollectableRequest collectable : request.getUserCollectables()) {
                boolean exists = finishedRouteService.userCollectableExists(userId, collectable.getCollectable());

                if (!exists) {
                    UserCollectable userCollectable = new UserCollectable(
                            collectable.getUserCollectableId(),
                            userId,
                            collectable.getCollectable(),
                            request.getFinishedRouteId()
                    );
                    finishedRouteService.saveUserCollectable(userCollectable);
                }
            }
        }

        return ResponseEntity.ok().build();
    }

    @PostMapping("/{userId}/awards")
    public ResponseEntity<?> saveUserAward(@PathVariable String userId, @RequestBody List<UserAwardRequest> requests) {
        for (UserAwardRequest request : requests) {
            if (request.getUserAwardId() == null || request.getAward() == null || request.getAwardDate() == null) {
                return ResponseEntity.status(400).body("Missing parameters");
            }

            int savedLevel = userAwardService.getPreviousLevelsNumber(userId, request.getAward());

            if (request.getAwardLevel() <= savedLevel || request.getAwardLevel() > 3 || request.getAwardLevel() < 1) {
                return ResponseEntity.status(400).body("Wrong level");
            }
        }

        for (UserAwardRequest request : requests) {
            int levelsDifference = request.getAwardLevel() - userAwardService.getPreviousLevelsNumber(userId, request.getAward());

            for (int i = 1; i < levelsDifference; i++) {
                String uuid = UUID.randomUUID().toString();

                UserAward previousLevelAward = new UserAward(
                        uuid,
                        userId,
                        request.getAward(),
                        request.getAwardLevel() - levelsDifference + i,
                        request.getAwardDate()
                );

                userAwardService.saveUserAward(previousLevelAward);
            }

            UserAward userAward = new UserAward(
                    request.getUserAwardId(),
                    userId,
                    request.getAward(),
                    request.getAwardLevel(),
                    request.getAwardDate()
            );

            userAwardService.saveUserAward(userAward);
        }

        return ResponseEntity.ok().build();
    }
}
