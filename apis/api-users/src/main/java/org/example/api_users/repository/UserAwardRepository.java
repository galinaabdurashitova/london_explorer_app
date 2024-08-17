package org.example.api_users.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.example.api_users.model.UserAward;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserAwardRepository extends JpaRepository<UserAward, String> {

    @Query("SELECT COUNT(ua) FROM UserAward ua WHERE ua.userId = :userId AND ua.award = :award")
    int getPreviousLevelsNumber(@Param("userId") String userId, @Param("award") String award);
}
