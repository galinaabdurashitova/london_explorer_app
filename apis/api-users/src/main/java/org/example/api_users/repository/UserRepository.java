package org.example.api_users.repository;

import org.example.api_users.model.*;
import org.example.api_users.dto.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserRepository extends JpaRepository<User, String> {

    @Query("SELECT f.user2Id FROM Friend f " +
            "WHERE f.user1Id = :userId AND EXISTS (" +
            "SELECT 1 FROM Friend f2 " +
            "WHERE f2.user1Id = f.user2Id AND f2.user2Id = :userId)")
    List<String> findUserFriends(@Param("userId") String userId);

    @Query("SELECT fr FROM FinishedRoute fr WHERE fr.userId = :userId")
    List<FinishedRoute> findFinishedRoutes(@Param("userId") String userId);

    @Query("SELECT ua FROM UserAward ua WHERE ua.userId = :userId")
    List<UserAward> findUserAwards(@Param("userId") String userId);

    @Query("SELECT uc FROM UserCollectable uc WHERE uc.userId = :userId")
    List<UserCollectable> findUserCollectables(@Param("userId") String userId);

    List<User> findByUserIdIn(List<String> userIds);

    @Query(value = "SELECT * FROM ( " +
            "    SELECT u.user_id, u.user_name, u.user_username, fr.finished_day AS update_date, 'FinishedRoute' AS update_type, fr.route_id AS description " +
            "    FROM friends f " +
            "    JOIN friends f1 ON f1.user_1_id = f.user_2_id AND f.user_1_id = f1.user_2_id " +
            "    JOIN users u ON u.user_id = f.user_2_id " +
            "    JOIN finished_routes fr ON fr.user_id = f.user_2_id " +
            "    WHERE f.user_1_id = :userId " +
            "    UNION " +
            "    SELECT u.user_id, u.user_name, u.user_username, ua.award_date AS update_date, 'Award' AS update_type, CONCAT(ua.award, ' Level ', ua.award_level) AS description " +
            "    FROM friends f " +
            "    JOIN friends f1 ON f1.user_1_id = f.user_2_id AND f.user_1_id = f1.user_2_id " +
            "    JOIN users u ON u.user_id = f.user_2_id " +
            "    JOIN User_awards ua ON ua.user_id = f.user_2_id " +
            "    WHERE f.user_1_id = :userId " +
            "    UNION " +
            "    SELECT u.user_id, u.user_name, u.user_username, fr.finished_day AS update_date, 'Collectable' AS update_type, uc.collectable AS description " +
            "    FROM friends f " +
            "    JOIN friends f1 ON f1.user_1_id = f.user_2_id AND f.user_1_id = f1.user_2_id " +
            "    JOIN users u ON u.user_id = f.user_2_id " +
            "    JOIN User_collectables uc ON uc.user_id = f.user_2_id " +
            "    JOIN finished_routes fr ON fr.finished_route_id = uc.finished_route_id " +
            "    WHERE f.user_1_id = :userId " +
            "    UNION " +
            "    SELECT u.user_id, u.user_name, u.user_username, GREATEST(f2.friendship_date, f3.friendship_date) AS update_date, 'Friend' AS update_type, " +
            "    CONCAT(u2.user_name, ' @', u2.user_username) AS description " +
            "    FROM friends f " +
            "    JOIN friends f1 ON f1.user_1_id = f.user_2_id AND f.user_1_id = f1.user_2_id " +
            "    JOIN users u ON u.user_id = f.user_2_id " +
            "    JOIN friends f2 ON f2.user_1_id = f.user_2_id " +
            "    JOIN friends f3 ON f3.user_1_id = f2.user_2_id AND f2.user_1_id = f3.user_2_id " +
            "    JOIN users u2 ON u2.user_id = f2.user_2_id " +
            "    WHERE f.user_1_id = :userId ) " +
            "ORDER BY update_date DESC " +
            "LIMIT :limit", nativeQuery = true)
    List<Object[]> findFriendsUpdates(@Param("userId") String userId, @Param("limit") int limit);
}
