package org.example.api_attractions.service;

import org.example.api_attractions.dto.AttractionDTO;
import org.example.api_attractions.model.Attraction;
import org.example.api_attractions.model.Category;
import org.example.api_attractions.repository.AttractionRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

public class AttractionServiceTest {

    @Mock
    private AttractionRepository attractionRepository;

    @InjectMocks
    private AttractionServiceImpl attractionService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testGetAllAttractions() {
        // Arrange
        Category category = new Category("1", "Museum");
        Attraction mockAttraction = new Attraction("1", "Louvre", "Famous museum", "World's largest art museum", "Paris", 48.8606, 2.3376);
        mockAttraction.setCategories(Set.of(category));

        when(attractionRepository.findAll()).thenReturn(List.of(mockAttraction));

        // Act
        List<AttractionDTO> attractions = attractionService.getAllAttractions();

        // Assert
        assertThat(attractions).isNotEmpty();
        assertThat(attractions.size()).isEqualTo(1);
        assertThat(attractions.get(0).getName()).isEqualTo("Louvre");
        assertThat(attractions.get(0).getCategories()).contains("Museum");
    }

    @Test
    public void testGetAllAttractions_NoCategories() {
        // Arrange
        Attraction mockAttraction = new Attraction("1", "Louvre", "Famous museum", "World's largest art museum", "Paris", 48.8606, 2.3376);
        mockAttraction.setCategories(Collections.emptySet());

        when(attractionRepository.findAll()).thenReturn(List.of(mockAttraction));

        // Act
        List<AttractionDTO> attractions = attractionService.getAllAttractions();

        // Assert
        assertThat(attractions).isEmpty();
    }

    @Test
    public void testGetAttractionsByIds() {
        // Arrange
        Category category = new Category("1", "Museum");
        Attraction mockAttraction = new Attraction("1", "Louvre", "Famous museum", "World's largest art museum", "Paris", 48.8606, 2.3376);
        mockAttraction.setCategories(Set.of(category));
        List<String> attractionIds = List.of("1");

        when(attractionRepository.findByIdIn(attractionIds)).thenReturn(List.of(mockAttraction));

        // Act
        List<AttractionDTO> attractions = attractionService.getAttractionsByIds(attractionIds);

        // Assert
        assertThat(attractions).isNotEmpty();
        assertThat(attractions.size()).isEqualTo(1);
        assertThat(attractions.get(0).getName()).isEqualTo("Louvre");
        assertThat(attractions.get(0).getCategories()).contains("Museum");
    }

    @Test
    public void testGetAttractionsByIds_NoCategories() {
        // Arrange
        Attraction mockAttraction = new Attraction("1", "Louvre", "Famous museum", "World's largest art museum", "Paris", 48.8606, 2.3376);
        mockAttraction.setCategories(Collections.emptySet());
        List<String> attractionIds = List.of("1");

        when(attractionRepository.findByIdIn(attractionIds)).thenReturn(List.of(mockAttraction));

        // Act
        List<AttractionDTO> attractions = attractionService.getAttractionsByIds(attractionIds);

        // Assert
        assertThat(attractions).isEmpty();
    }

    @Test
    public void testGetAttractionById() {
        // Arrange
        Category category = new Category("1", "Museum");
        Attraction mockAttraction = new Attraction("1", "Louvre", "Famous museum", "World's largest art museum", "Paris", 48.8606, 2.3376);
        mockAttraction.setCategories(Set.of(category));
        String attractionId = "1";

        when(attractionRepository.findById(attractionId)).thenReturn(Optional.of(mockAttraction));

        // Act
        AttractionDTO attraction = attractionService.getAttractionById(attractionId);

        // Assert
        assertThat(attraction).isNotNull();
        assertThat(attraction.getName()).isEqualTo("Louvre");
        assertThat(attraction.getCategories()).contains("Museum");
    }

    @Test
    public void testGetAttractionById_NoCategories() {
        // Arrange
        Attraction mockAttraction = new Attraction("1", "Louvre", "Famous museum", "World's largest art museum", "Paris", 48.8606, 2.3376);
        mockAttraction.setCategories(Collections.emptySet());
        String attractionId = "1";

        when(attractionRepository.findById(attractionId)).thenReturn(Optional.of(mockAttraction));

        // Act
        AttractionDTO attraction = attractionService.getAttractionById(attractionId);

        // Assert
        assertThat(attraction).isNull();
    }
}
