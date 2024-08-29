package org.example.api_routes.service;

import org.example.api_routes.model.RouteCollectable;
import org.example.api_routes.repository.RouteCollectableRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RouteCollectableService {
    @Autowired
    private RouteCollectableRepository routeCollectableRepository;

    public void saveRouteCollectable(RouteCollectable collectable) {
        routeCollectableRepository.save(collectable);
    }
}
