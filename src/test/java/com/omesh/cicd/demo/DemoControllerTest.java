package com.omesh.cicd.demo;

import com.omesh.cicd.demo.DemoController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// This annotation sets up the test environment specifically for MVC controllers
@WebMvcTest(DemoController.class)
public class DemoControllerTest {

    @Autowired
    private MockMvc mockMvc; // Used to simulate HTTP requests

    @Test
    void shouldReturnDefaultMessage() throws Exception {
        // Simulates a GET request to /hello and verifies the response status and content
        mockMvc.perform(get("/hello"))
                .andExpect(status().isOk())
                .andExpect(content().string("Spring Boot CI/CD Pipeline Success! Version 1.0"));
    }
}
