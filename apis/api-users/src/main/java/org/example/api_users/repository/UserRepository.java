package org.example.api_users.repository;

import org.example.api_users.model.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserRepository extends JpaRepository<User, String> {

    @Query("SELECT COUNT(ua) FROM UserAward ua WHERE ua.userId = :userId")
    int countUserAwards(@Param("userId") String userId);

    @Query("SELECT COUNT(uc) FROM UserCollectable uc WHERE uc.userId = :userId")
    int countUserCollectables(@Param("userId") String userId);

    @Query("SELECT f.user2Id FROM Friend f WHERE f.user1Id = :userId OR f.user2Id = :userId")
    List<String> findUserFriends(@Param("userId") String userId);

    @Query("SELECT fr.routeId FROM FavouriteRoute fr WHERE fr.userId = :userId")
    List<String> findFavouriteRoutes(@Param("userId") String userId);

    @Query("SELECT fr FROM FinishedRoute fr WHERE fr.userId = :userId")
    List<FinishedRoute> findFinishedRoutes(@Param("userId") String userId);
}
