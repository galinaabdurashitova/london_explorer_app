package org.example.api_users.controller;

import org.example.api_users.dto.*;
import org.example.api_users.model.*;
import org.example.api_users.service.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.Timestamp;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserControllerSaveUserAwardTest {

    @Mock
    private UserAwardService userAwardService;

    @InjectMocks
    private UserController userController;

    @Test
    public void testSaveUserAward() {
        // Test to verify that a user award is saved successfully when all parameters are provided.
        String userId = "testUserId";
        UserAwardRequest request = new UserAwardRequest();
        request.setUserAwardId("awardId1");
        request.setAward("award1");
        request.setAwardLevel(2);
        request.setAwardDate(Timestamp.valueOf("2024-08-12 12:34:56"));

        when(userAwardService.getPreviousLevelsNumber(userId, "award1")).thenReturn(1);

        ResponseEntity<?> responseEntity = userController.saveUserAward(userId, List.of(request));

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.OK);
        verify(userAwardService, times(1)).saveUserAward(any(UserAward.class));
    }

    @Test
    public void testSaveUserAwardMissingParameters() {
        // Test to ensure that a bad request response is returned when required parameters are missing for saving a user award.
        String userId = "testUserId";
        UserAwardRequest request = new UserAwardRequest();

        ResponseEntity<?> responseEntity = userController.saveUserAward(userId, List.of(request));

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(userAwardService, never()).saveUserAward(any(UserAward.class));
    }

    @Test
    public void testSaveUserAwardWrongLevel() {
        // Test to ensure that a bad request response is returned when the award level is incorrect.
        String userId = "testUserId";
        UserAwardRequest request = new UserAwardRequest();
        request.setUserAwardId("awardId1");
        request.setAward("award1");
        request.setAwardLevel(1);
        request.setAwardDate(Timestamp.valueOf("2024-08-12 12:34:56"));

        when(userAwardService.getPreviousLevelsNumber(userId, "award1")).thenReturn(2);

        ResponseEntity<?> responseEntity = userController.saveUserAward(userId, List.of(request));

        assertThat(responseEntity.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        verify(userAwardService, never()).saveUserAward(any(UserAward.class));
    }
}
