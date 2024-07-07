package org.example.api_attractions.service;

import org.example.api_attractions.dto.AttractionDTO;
import org.example.api_attractions.model.Attraction;
import org.example.api_attractions.model.Category;
import org.example.api_attractions.repository.AttractionRepository;
import org.example.api_attractions.service.AttractionService;
import org.example.api_attractions.service.AttractionServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
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
    public void testGetAttractionById() {
        // Mock data
        String attractionId = "1";
        Attraction mockAttraction = new Attraction(
                "1", "Test Attraction", "Short desc", "Full desc",
                "Address", 0.0, 0.0);
        mockAttraction.setCategories(new HashSet<>()); // Ensure categories are initialized

        // Mock behavior
        when(attractionRepository.findById(attractionId)).thenReturn(Optional.of(mockAttraction));

        // Call the service method
        AttractionDTO attractionDTO = attractionService.getAttractionById(attractionId);

        // Assertions
        assertThat(attractionDTO).isNotNull();
        assertThat(attractionDTO.getId()).isEqualTo(mockAttraction.getId());
        assertThat(attractionDTO.getName()).isEqualTo(mockAttraction.getName());
        // Add more assertions for other fields as needed
    }

    @Test
    public void testGetAllAttractions() {
        // Mock data
        Attraction mockAttraction = new Attraction(
                "1", "Test Attraction", "Short desc", "Full desc",
                "Address", 0.0, 0.0);
        Category mockCategory = new Category("1", "Historical");
        Set<Category> mockCategorySet = new HashSet<Category>();
        mockCategorySet.add(mockCategory);
        mockAttraction.setCategories(mockCategorySet); // Ensure categories are initialized

        // Mock behavior
        when(attractionRepository.findAll()).thenReturn(Collections.singletonList(mockAttraction));

        // Call the service method
        List<AttractionDTO> attractionDTOs = attractionService.getAllAttractions();

        // Assertions
        assertThat(attractionDTOs).hasSize(1);
        AttractionDTO attractionDTO = attractionDTOs.get(0);
        assertThat(attractionDTO.getId()).isEqualTo(mockAttraction.getId());
        assertThat(attractionDTO.getName()).isEqualTo(mockAttraction.getName());
        // Add more assertions for other fields as needed
    }

    @Test
    public void testGetAttractionByIdProjected() {
        // Mock data
        String attractionId = "1";
        Category category = new Category("1", "Category");
        Attraction mockAttraction = new Attraction(
                "1", "Test Attraction", "Short desc", "Full desc",
                "Address", 0.0, 0.0);
        mockAttraction.setCategories(Collections.singleton(category));

        // Mock behavior
        when(attractionRepository.findById(attractionId)).thenReturn(Optional.of(mockAttraction));

        // Call the service method
        AttractionDTO attractionDTO = attractionService.getAttractionByIdProjected(attractionId);

        // Assertions
        assertThat(attractionDTO).isNotNull();
        assertThat(attractionDTO.getId()).isEqualTo(mockAttraction.getId());
        assertThat(attractionDTO.getName()).isEqualTo(mockAttraction.getName());
        assertThat(attractionDTO.getCategories()).containsExactly(category.getName());
        // Add more assertions for other fields as needed
    }
}

