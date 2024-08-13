package org.example.api_users.repository;

import org.example.api_users.model.UserCollectable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserCollectableRepository extends JpaRepository<UserCollectable, String> {

    @Query("SELECT CASE WHEN COUNT(uc) > 0 THEN TRUE ELSE FALSE END FROM UserCollectable uc WHERE uc.userId = :userId AND uc.collectable = :collectable")
    boolean existsByUserIdAndCollectable(@Param("userId") String userId, @Param("collectable") String collectable);
}
