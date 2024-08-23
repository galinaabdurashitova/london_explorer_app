package org.example.api_routes.service;

import org.example.api_routes.model.RouteSave;
import org.example.api_routes.repository.RouteSaveRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RouteSaveService {
    @Autowired
    private RouteSaveRepository routeSaveRepository;

    public void saveRoute(RouteSave save) {
        routeSaveRepository.save(save);
    }
}
