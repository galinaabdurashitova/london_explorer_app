package org.example.api_routes;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class ApiRoutesApplicationTests {

    @Autowired
    private ApplicationContext applicationContext;

    @Test
    void contextLoads() {
        // This test will pass if the application context loads successfully
        assertThat(applicationContext).isNotNull();
    }

    @Test
    void testRouteServiceBeanExists() {
        // Verify that the RouteService bean is loaded into the application context
        boolean routeServiceExists = applicationContext.containsBean("routeService");
        assertThat(routeServiceExists).isTrue();
    }

    @Test
    void testRouteStopServiceBeanExists() {
        // Verify that the RouteStopService bean is loaded into the application context
        boolean routeStopServiceExists = applicationContext.containsBean("routeStopService");
        assertThat(routeStopServiceExists).isTrue();
    }

    @Test
    void testRouteCollectableServiceBeanExists() {
        // Verify that the RouteCollectableService bean is loaded into the application context
        boolean routeCollectableServiceExists = applicationContext.containsBean("routeCollectableService");
        assertThat(routeCollectableServiceExists).isTrue();
    }

    @Test
    void testRouteSaveServiceBeanExists() {
        // Verify that the RouteSaveService bean is loaded into the application context
        boolean routeSaveServiceExists = applicationContext.containsBean("routeSaveService");
        assertThat(routeSaveServiceExists).isTrue();
    }

    @Test
    void testRouteRepositoryBeanExists() {
        // Verify that the RouteRepository bean is loaded into the application context
        boolean routeRepositoryExists = applicationContext.containsBean("routeRepository");
        assertThat(routeRepositoryExists).isTrue();
    }

    @Test
    void testRouteStopRepositoryBeanExists() {
        // Verify that the RouteStopRepository bean is loaded into the application context
        boolean routeStopRepositoryExists = applicationContext.containsBean("routeStopRepository");
        assertThat(routeStopRepositoryExists).isTrue();
    }

    @Test
    void testRouteCollectableRepositoryBeanExists() {
        // Verify that the RouteCollectableRepository bean is loaded into the application context
        boolean routeCollectableRepositoryExists = applicationContext.containsBean("routeCollectableRepository");
        assertThat(routeCollectableRepositoryExists).isTrue();
    }

    @Test
    void testRouteSaveRepositoryBeanExists() {
        // Verify that the RouteSaveRepository bean is loaded into the application context
        boolean routeSaveRepositoryExists = applicationContext.containsBean("routeSaveRepository");
        assertThat(routeSaveRepositoryExists).isTrue();
    }
}
