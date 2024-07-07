package org.example.api_attractions.service;

import org.example.api_attractions.dto.AttractionDTO;
import org.example.api_attractions.model.Attraction;

import java.util.List;

public interface AttractionService {
    AttractionDTO getAttractionById(String id);
    void saveAttraction(Attraction attraction);
    void updateAttraction(Attraction attraction);
    void deleteAttraction(String id);
    List<AttractionDTO> getAllAttractions();
    AttractionDTO getAttractionByIdProjected(String id);
}
