package org.example.api_attractions;

import org.example.api_attractions.controller.AttractionController;
import org.example.api_attractions.exception.GlobalExceptionHandler;
import org.example.api_attractions.repository.AttractionRepository;
import org.example.api_attractions.service.AttractionService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class ApiAttractionsApplicationTests {

	@Autowired
	private ApplicationContext applicationContext;

	@Test
	void testAttractionServiceBeanExists() {
		// Check using the class type
		assertThat(applicationContext.getBean(AttractionService.class)).isNotNull();
	}

	@Test
	void testAttractionRepositoryBeanExists() {
		// Check using the class type
		assertThat(applicationContext.getBean(AttractionRepository.class)).isNotNull();
	}

	@Test
	void testGlobalExceptionHandlerBeanExists() {
		// Check using the class type
		assertThat(applicationContext.getBean(GlobalExceptionHandler.class)).isNotNull();
	}

	@Test
	void testAttractionControllerBeanExists() {
		// Check using the class type
		assertThat(applicationContext.getBean(AttractionController.class)).isNotNull();
	}

}
