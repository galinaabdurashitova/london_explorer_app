package org.example.api_users;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class ApiUsersApplicationTests {

	@Autowired
	private ApplicationContext applicationContext;

	@Test
	void contextLoads() {
		// This test will pass if the application context loads successfully
		assertThat(applicationContext).isNotNull();
	}

	@Test
	void testUserServiceBeanExists() {
		// Verify that the UserService bean is loaded into the application context
		boolean userServiceExists = applicationContext.containsBean("userService");
		assertThat(userServiceExists).isTrue();
	}

	@Test
	void testFinishedRouteServiceBeanExists() {
		// Verify that the FinishedRouteService bean is loaded into the application context
		boolean finishedRouteServiceExists = applicationContext.containsBean("finishedRouteService");
		assertThat(finishedRouteServiceExists).isTrue();
	}

	@Test
	void testUserRepositoryBeanExists() {
		// Verify that the UserRepository bean is loaded into the application context
		boolean userRepositoryExists = applicationContext.containsBean("userRepository");
		assertThat(userRepositoryExists).isTrue();
	}

	@Test
	void testFinishedRouteRepositoryBeanExists() {
		// Verify that the FinishedRouteRepository bean is loaded into the application context
		boolean finishedRouteRepositoryExists = applicationContext.containsBean("finishedRouteRepository");
		assertThat(finishedRouteRepositoryExists).isTrue();
	}
}
