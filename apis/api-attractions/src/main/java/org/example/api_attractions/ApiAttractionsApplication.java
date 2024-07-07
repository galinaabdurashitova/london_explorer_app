package org.example.api_attractions;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EntityScan("org.example.api_attractions.model")
@ComponentScan(basePackages = { "org.example.api_attractions.*" })
@EnableJpaRepositories("org.example.api_attractions.*")
public class ApiAttractionsApplication {

	public static void main(String[] args) {
		SpringApplication.run(ApiAttractionsApplication.class, args);
	}

}
