package org.example.api_attractions.controller;

import org.example.api_attractions.dto.AttractionDTO;
import org.example.api_attractions.model.Attraction;
import org.example.api_attractions.service.AttractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/attractions")
public class AttractionController {
    private final AttractionService attractionService;

    @Autowired
    public AttractionController(AttractionService attractionService) {
        this.attractionService = attractionService;
    }

    @GetMapping("/{id}")
    public ResponseEntity<AttractionDTO> getAttractionById(@PathVariable String id) {
        AttractionDTO attractionDTO = attractionService.getAttractionByIdProjected(id);
        if (attractionDTO == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(attractionDTO, HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<AttractionDTO>> getAllAttractions() {
        List<AttractionDTO> attractions = attractionService.getAllAttractions();
        return new ResponseEntity<>(attractions, HttpStatus.OK);
    }
}
