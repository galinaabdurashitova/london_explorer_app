package org.example.api_users.repository;

import org.example.api_users.model.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserRepository extends JpaRepository<User, String> {

    @Query("SELECT f.user2Id FROM Friend f WHERE f.user1Id = :userId OR f.user2Id = :userId")
    List<String> findUserFriends(@Param("userId") String userId);

    @Query("SELECT fr FROM FinishedRoute fr WHERE fr.userId = :userId")
    List<FinishedRoute> findFinishedRoutes(@Param("userId") String userId);

    @Query("SELECT ua FROM UserAward ua WHERE ua.userId = :userId")
    List<UserAward> findUserAwards(@Param("userId") String userId);

    @Query("SELECT uc FROM UserCollectable uc WHERE uc.userId = :userId")
    List<UserCollectable> findUserCollectables(@Param("userId") String userId);
}
