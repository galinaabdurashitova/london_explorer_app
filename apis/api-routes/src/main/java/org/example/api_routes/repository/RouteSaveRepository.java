package org.example.api_routes.repository;

import org.example.api_routes.model.RouteSave;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RouteSaveRepository extends JpaRepository<RouteSave, String> {
}
