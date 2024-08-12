package org.example.api_users.service;

import org.example.api_users.model.*;
import org.example.api_users.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FinishedRouteService {

    @Autowired
    private FinishedRouteRepository finishedRouteRepository;

    @Autowired
    private UserCollectableRepository userCollectableRepository;

    public void saveFinishedRoute(FinishedRoute finishedRoute) {
        finishedRouteRepository.save(finishedRoute);
    }

    public void saveUserCollectable(UserCollectable userCollectable) {
        userCollectableRepository.save(userCollectable);
    }
}

