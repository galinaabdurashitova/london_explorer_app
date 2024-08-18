package org.example.api_users.repository;

import org.example.api_users.model.Friend;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface FriendRepository extends JpaRepository<Friend, String> {

    @Query("SELECT f FROM Friend f WHERE f.user1Id = :user1Id AND f.user2Id = :user2Id")
    Optional<Friend> findFriendRequest(String user1Id, String user2Id);

    @Query("SELECT CASE WHEN COUNT(f) > 0 THEN TRUE ELSE FALSE END FROM Friend f WHERE f.user1Id = :user1Id AND f.user2Id = :user2Id")
    boolean existsByUser1IdAndUser2Id(String user1Id, String user2Id);
}
