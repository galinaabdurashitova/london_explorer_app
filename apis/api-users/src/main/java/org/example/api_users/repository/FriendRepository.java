package org.example.api_users.repository;

import org.example.api_users.model.Friend;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface FriendRepository extends JpaRepository<Friend, String> {

    @Query("SELECT f FROM Friend f WHERE f.user1Id = :user1Id AND f.user2Id = :user2Id")
    Friend findFriendRequest(String user1Id, String user2Id);

    @Query("SELECT CASE WHEN COUNT(f) > 0 THEN TRUE ELSE FALSE END FROM Friend f WHERE f.user1Id = :user1Id AND f.user2Id = :user2Id")
    boolean existsByUser1IdAndUser2Id(String user1Id, String user2Id);

    @Query("SELECT f.user1Id FROM Friend f " +
            "WHERE f.user2Id = :userId AND NOT EXISTS (" +
            "SELECT f2 FROM Friend f2 " +
            "WHERE f2.user2Id = f.user1Id AND f2.user1Id = :userId)")
    List<String> findFriendRequests(@Param("userId") String userId);
}
