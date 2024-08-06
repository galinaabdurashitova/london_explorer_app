package org.example.api_users.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.example.api_users.model.FinishedRoute;

public interface FinishedRouteRepository extends JpaRepository<FinishedRoute, String> {
}
