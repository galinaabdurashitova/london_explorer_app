package org.example.api_routes;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EntityScan("org.example.api_routes.model")
@ComponentScan(basePackages = { "org.example.api_routes.*" })
@EnableJpaRepositories("org.example.api_routes.repository")
public class ApiRoutesApplication {

	public static void main(String[] args) {
		SpringApplication.run(ApiRoutesApplication.class, args);
	}
}
