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

import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AttractionControllerTest {

    @Mock
    private AttractionService attractionService;

    @InjectMocks
    private AttractionController attractionController;

    @Test
    public void testGetAttractionById() {
        // Arrange
        String attractionId = "1";
        AttractionDTO mockAttraction = new AttractionDTO(attractionId, "Eiffel Tower", "Iconic tower", "The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France.", "Paris", 48.8584, 2.2945, List.of("Landmark"));

        when(attractionService.getAttractionById(attractionId)).thenReturn(mockAttraction);

        // Act
        ResponseEntity<AttractionDTO> responseEntity = attractionController.getAttractionById(attractionId);

        // Assert
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isNotNull();
        assertThat(responseEntity.getBody().getId()).isEqualTo(attractionId);
        assertThat(responseEntity.getBody().getName()).isEqualTo("Eiffel Tower");
    }

    @Test
    public void testGetAttractionById_NotFound() {
        // Arrange
        String attractionId = "1";

        when(attractionService.getAttractionById(attractionId)).thenReturn(null);

        // Act
        ResponseEntity<AttractionDTO> responseEntity = attractionController.getAttractionById(attractionId);

        // Assert
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(responseEntity.getBody()).isNull();
    }

    @Test
    public void testGetAllAttractions_NoIds() {
        // Arrange
        List<AttractionDTO> mockAttractions = Arrays.asList(
                new AttractionDTO("1", "Eiffel Tower", "Iconic tower", "The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France.", "Paris", 48.8584, 2.2945, List.of("Landmark")),
                new AttractionDTO("2", "Louvre Museum", "Famous museum", "The Louvre is the world's largest art museum and a historic monument in Paris, France.", "Paris", 48.8606, 2.3376, List.of("Museum"))
        );

        when(attractionService.getAllAttractions()).thenReturn(mockAttractions);

        // Act
        ResponseEntity<?> responseEntity = attractionController.getAllAttractions(null);

        // Assert
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }

    @Test
    public void testGetAllAttractions_WithIds() {
        // Arrange
        List<String> attractionIds = Arrays.asList("1", "2");
        List<AttractionDTO> mockAttractions = Arrays.asList(
                new AttractionDTO("1", "Eiffel Tower", "Iconic tower", "The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France.", "Paris", 48.8584, 2.2945, List.of("Landmark")),
                new AttractionDTO("2", "Louvre Museum", "Famous museum", "The Louvre is the world's largest art museum and a historic monument in Paris, France.", "Paris", 48.8606, 2.3376, List.of("Museum"))
        );

        when(attractionService.getAttractionsByIds(attractionIds)).thenReturn(mockAttractions);

        // Act
        ResponseEntity<?> responseEntity = attractionController.getAllAttractions(attractionIds);

        // Assert
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }

    @Test
    public void testGetAllAttractions_WithSomeIdsNotFound() {
        // Arrange
        List<String> attractionIds = Arrays.asList("1", "2", "3");
        List<AttractionDTO> mockAttractions = Arrays.asList(
                new AttractionDTO("1", "Eiffel Tower", "Iconic tower", "The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France.", "Paris", 48.8584, 2.2945, List.of("Landmark")),
                new AttractionDTO("2", "Louvre Museum", "Famous museum", "The Louvre is the world's largest art museum and a historic monument in Paris, France.", "Paris", 48.8606, 2.3376, List.of("Museum"))
        );

        when(attractionService.getAttractionsByIds(attractionIds)).thenReturn(mockAttractions);

        // Act
        ResponseEntity<?> responseEntity = attractionController.getAllAttractions(attractionIds);

        // Assert
        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(responseEntity.getBody()).isInstanceOf(List.class);
        assertThat(((List<?>) responseEntity.getBody()).size()).isEqualTo(2);
    }
}
