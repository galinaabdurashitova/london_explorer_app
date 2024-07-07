package org.example.api_attractions.controller;

import org.example.api_attractions.dto.AttractionDTO;
import org.example.api_attractions.service.AttractionService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class AttractionControllerTest {

    @Mock
    private AttractionService attractionService;

    @InjectMocks
    private AttractionController attractionController;

    @Test
    public void testGetAttractionById() {
        // Mock data
        String attractionId = "1";
        AttractionDTO mockAttractionDTO = new AttractionDTO(
                "1", "Test Attraction", "Short desc", "Full desc",
                "Address", 0.0, 0.0, Collections.singletonList("Category"));

        // Mock behavior
        when(attractionService.getAttractionByIdProjected(attractionId)).thenReturn(mockAttractionDTO);

        // Call the controller method
        ResponseEntity<AttractionDTO> responseEntity = attractionController.getAttractionById(attractionId);

        // Assertions
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isEqualTo(mockAttractionDTO);
    }

    @Test
    public void testGetAllAttractions() {
        // Mock data
        AttractionDTO mockAttractionDTO = new AttractionDTO(
                "1", "Test Attraction", "Short desc", "Full desc",
                "Address", 0.0, 0.0, Collections.singletonList("Category"));

        // Mock behavior
        when(attractionService.getAllAttractions()).thenReturn(Collections.singletonList(mockAttractionDTO));

        // Call the controller method
        ResponseEntity<List<AttractionDTO>> responseEntity = attractionController.getAllAttractions();

        // Assertions
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).hasSize(1);
        assertThat(responseEntity.getBody().get(0)).isEqualTo(mockAttractionDTO);
    }
}
