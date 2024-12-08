package com.example.polihackv16.config;

import jakarta.annotation.PostConstruct;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@Component
@NoArgsConstructor
public class ApiKeyLoader {
    @Value("${api.key.location}")
    private String apiKeyFilePath;

    public String getApiKey() {
        try {
//            Path path = Path.of(apiKeyFilePath);
            Path path = Path.of("C:/mihai/Projects/polihack_v16/apikey.txt");
            return Files.readString(path).trim();
        } catch (IOException e) {
            throw new RuntimeException("Failed to load API key from file", e);
        }
    }
}
