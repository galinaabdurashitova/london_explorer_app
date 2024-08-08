package org.example.api_users.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.example.api_users.model.FinishedRoute;
import org.example.api_users.repository.FinishedRouteRepository;

@Service
public class FinishedRouteService {

    @Autowired
    private FinishedRouteRepository finishedRouteRepository;

    public void saveFinishedRoute(FinishedRoute finishedRoute) {
        finishedRouteRepository.save(finishedRoute);
    }
}
