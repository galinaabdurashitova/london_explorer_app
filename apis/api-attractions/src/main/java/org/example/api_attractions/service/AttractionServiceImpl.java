package org.example.api_attractions.service;

import org.example.api_attractions.dto.AttractionDTO;
import org.example.api_attractions.model.Attraction;
import org.example.api_attractions.repository.AttractionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class AttractionServiceImpl implements AttractionService {
    private final AttractionRepository attractionRepository;

    @Autowired
    public AttractionServiceImpl(AttractionRepository attractionRepository) {
        this.attractionRepository = attractionRepository;
    }

    @Override
    public AttractionDTO getAttractionById(String id) {
        Optional<Attraction> optionalAttraction = attractionRepository.findById(id);
        if (optionalAttraction.isPresent()) {
            return convertToDTO(optionalAttraction.get());
        }
        return null;
    }

    @Override
    public void saveAttraction(Attraction attraction) {
        attractionRepository.save(attraction);
    }

    @Override
    public void updateAttraction(Attraction attraction) {
        attractionRepository.save(attraction);
    }

    @Override
    public void deleteAttraction(String id) {
        attractionRepository.deleteById(id);
    }

    @Override
    public List<AttractionDTO> getAllAttractions() {
        return attractionRepository.findAll().stream()
                .filter(attraction -> !attraction.getCategories().isEmpty())
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public AttractionDTO getAttractionByIdProjected(String id) {
        Optional<Attraction> optionalAttraction = attractionRepository.findById(id);
        if (optionalAttraction.isPresent() && !optionalAttraction.get().getCategories().isEmpty()) {
            return convertToDTO(optionalAttraction.get());
        }
        return null;
    }

    private AttractionDTO convertToDTO(Attraction attraction) {
        List<String> categoryNames = attraction.getCategories().stream()
                .map(category -> category.getName())
                .collect(Collectors.toList());

        return new AttractionDTO(
                attraction.getId(),
                attraction.getName(),
                attraction.getShortDescription(),
                attraction.getFullDescription(),
                attraction.getAddress(),
                attraction.getLatitude(),
                attraction.getLongitude(),
                categoryNames
        );
    }
}
