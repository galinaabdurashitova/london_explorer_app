package org.example.api_routes.repository;

import org.example.api_routes.model.RouteStop;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RouteStopRepository extends JpaRepository<RouteStop, String> {

}
