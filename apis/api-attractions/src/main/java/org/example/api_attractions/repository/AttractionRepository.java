package org.example.api_attractions.repository;

import org.example.api_attractions.model.Attraction;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AttractionRepository extends JpaRepository<Attraction, String> {

}
