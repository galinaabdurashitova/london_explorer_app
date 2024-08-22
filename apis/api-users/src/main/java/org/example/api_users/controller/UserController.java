package org.example.api_users.controller;

import org.example.api_users.dto.*;
import org.example.api_users.model.*;
import org.example.api_users.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.Timestamp;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private FinishedRouteService finishedRouteService;

    @Autowired
    private UserAwardService userAwardService;

    @Autowired
    private FriendService friendService;

    @GetMapping
    public ResponseEntity<?> getUsers(@RequestParam(value = "userIds", required = false) List<String> userIds) {
        List<User> users;

        if (userIds == null || userIds.isEmpty()) {
            users = userService.getAllUsers();
        } else {
            users = userService.getUsersByIds(userIds);
        }

        List<Map<String, Object>> response = users.stream().map(user -> {
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("userId", user.getUserId());
            userMap.put("email", user.getEmail());
            userMap.put("name", user.getName());
            userMap.put("userName", user.getUserName());
            userMap.put("description", user.getDescription());

            List<String> friends = userService.findUserFriends(user.getUserId());
            List<UserAward> awards = userService.findUserAwards(user.getUserId());
            List<UserCollectable> collectables = userService.findUserCollectables(user.getUserId());
            List<FinishedRoute> finishedRoutes = userService.findFinishedRoutes(user.getUserId());

            userMap.put("friends", friends);
            userMap.put("awards", awards);
            userMap.put("collectables", collectables);
            userMap.put("finishedRoutes", finishedRoutes);

            return userMap;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<?> getUserInfo(@PathVariable String userId) {
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

    @PatchMapping("/{userId}")
    public ResponseEntity<?> updateUser(@PathVariable String userId, @RequestBody UserUpdateRequest updateRequest) {
        Optional<User> optionalUser = userService.getUserById(userId);

        if (!optionalUser.isPresent()) {
            return ResponseEntity.status(404).body("User not found");
        }

        User user = optionalUser.get();

        if (updateRequest.getName() != null) {
            user.setName(updateRequest.getName());
        }
        if (updateRequest.getUserName() != null) {
            user.setUserName(updateRequest.getUserName());
        }
        if (updateRequest.getDescription() != null) {
            user.setDescription(updateRequest.getDescription());
        }

        userService.saveUser(user);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{userId}/friends")
    public ResponseEntity<?> sendOrConfirmFriendRequest(@PathVariable String userId, @RequestBody FriendshipRequest request) {
        if (request.getFriendUserId() == null) {
            return ResponseEntity.status(400).body("Missing parameters");
        }

        if (!userService.userExists(userId) || !userService.userExists(request.getFriendUserId())) {
            return ResponseEntity.status(404).body("User not found");
        }

        if (friendService.isFriendRequestExists(userId, request.getFriendUserId())) {
            return ResponseEntity.status(400).body("Request already exists");
        }

        if (userId == request.getFriendUserId()) {
            return ResponseEntity.status(400).body("Wrong userIds");
        }

        friendService.addOrUpdateFriend(userId, request.getFriendUserId());

        if (friendService.isFriendshipConfirmed(userId, request.getFriendUserId())) {
            return ResponseEntity.ok("Friendship confirmed");
        } else {
            return ResponseEntity.ok("Friend request sent");
        }
    }

    @DeleteMapping("/{userId}/friends/{friendUserId}")
    public ResponseEntity<?> deleteFriend(@PathVariable String userId, @PathVariable String friendUserId) {
        if (!userService.userExists(userId)) {
            return ResponseEntity.status(404).body("User not found");
        }

        if (!userService.userExists(friendUserId)) {
            return ResponseEntity.status(404).body("Friend user not found");
        }

        boolean friendRequestExists = friendService.isFriendRequestExists(friendUserId, userId);
        if (!friendRequestExists) {
            return ResponseEntity.status(404).body("Friendship does not exist");
        }

        friendService.declineFriendRequest(friendUserId, userId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{userId}/friends/requests")
    public ResponseEntity<?> getFriendRequests(@PathVariable String userId) {
        if (!userService.userExists(userId)) {
            return ResponseEntity.status(404).body("User not found");
        }

        List<String> friendsRequestedFriendship = friendService.findUsersFriendRequests(userId);

        List<User> users = userService.getUsersByIds(friendsRequestedFriendship);

        return ResponseEntity.ok(users);
    }

    @GetMapping("/{userId}/friends/updates")
    public ResponseEntity<List<FriendUpdateResponse>> getFriendsUpdates(@PathVariable String userId, @RequestParam(value = "limit", required = false) int limit) {
        List<FriendUpdateResponse> updates = userService.getFriendsUpdates(userId, limit);
        return ResponseEntity.ok(updates);
    }
}
