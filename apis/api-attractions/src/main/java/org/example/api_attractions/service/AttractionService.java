package org.example.api_attractions.service;

import org.example.api_attractions.dto.AttractionDTO;
import org.example.api_attractions.model.Attraction;

import java.util.List;

public interface AttractionService {
    AttractionDTO getAttractionById(String id);
    List<AttractionDTO> getAllAttractions();
    List<AttractionDTO> getAttractionsByIds(List<String> attractionIds);
}
