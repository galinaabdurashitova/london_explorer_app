package org.example.api_attractions;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ApiAttractionsApplicationTests {

	@Autowired
	private TestRestTemplate restTemplate;

	@Autowired
	private Environment environment;

	@Test
	void testGetAllAttractionsEndpoint() {
		// Retrieve the server port from the environment
		String port = environment.getProperty("local.server.port");

		// Prepare URL for the endpoint to test
		String url = "http://localhost:" + port + "/api/attractions";

		// Send HTTP GET request to the endpoint
		ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

		// Assert the response status code
		assertThat(response.getStatusCode().is2xxSuccessful()).isTrue();

		// Add more assertions as needed to validate the response body or headers
	}
}

