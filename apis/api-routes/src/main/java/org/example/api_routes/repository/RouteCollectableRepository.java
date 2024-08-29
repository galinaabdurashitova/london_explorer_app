package org.example.api_routes.repository;

import org.example.api_routes.model.RouteCollectable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RouteCollectableRepository extends JpaRepository<RouteCollectable, String> {
}
