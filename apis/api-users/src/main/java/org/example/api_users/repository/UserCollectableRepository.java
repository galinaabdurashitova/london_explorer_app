package org.example.api_users.repository;

import org.example.api_users.model.UserCollectable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserCollectableRepository extends JpaRepository<UserCollectable, String> {
}