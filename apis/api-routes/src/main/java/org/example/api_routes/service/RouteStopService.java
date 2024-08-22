package org.example.api_routes.service;

import org.example.api_routes.model.RouteStop;
import org.example.api_routes.repository.RouteStopRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RouteStopService {
    @Autowired
    private RouteStopRepository routeStopRepository;

    public void saveRouteStop(RouteStop stop) {
        routeStopRepository.save(stop);
    }
}
