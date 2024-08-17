package org.example.api_users.service;

import org.example.api_users.model.User;
import org.example.api_users.model.FinishedRoute;
import org.example.api_users.model.UserAward;
import org.example.api_users.repository.UserAwardRepository;
import org.example.api_users.service.UserAwardService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Optional;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class UserAwardServiceTest {

    @Mock
    private UserAwardRepository userAwardRepository;

    @InjectMocks
    private UserAwardService userAwardService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testSaveFinishedRoute() {
        UserAward mockUserAward = new UserAward("944F0FA9-256B-4568-92D7-855FA473FAE0", "SHrUmpceW6bDkRBLIlS0koDjyNH2", "Finished routes", 2, null);

        userAwardService.saveUserAward(mockUserAward);

        verify(userAwardRepository).save(mockUserAward);
    }
}
