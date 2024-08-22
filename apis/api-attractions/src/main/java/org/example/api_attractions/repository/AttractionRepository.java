package org.example.api_attractions.repository;

import org.example.api_attractions.model.Attraction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AttractionRepository extends JpaRepository<Attraction, String> {

    List<Attraction> findByIdIn(List<String> attractionIds);
}
