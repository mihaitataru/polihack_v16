package com.example.polihackv16.controller;

import com.example.polihackv16.config.ApiKeyLoader;
import com.example.polihackv16.service.GameService;
import com.example.polihackv16.utils.RandomCoordinateGenerator;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RequiredArgsConstructor
@Controller
@RequestMapping("api/v1/")
@Log4j2
public class StreetViewController {

    private final RandomCoordinateGenerator randomCoordinateGenerator;

    private final GameService gameService;

    @GetMapping("/streetview")
    public String serveStreetView(
        @RequestParam double latitude,
        @RequestParam double longitude,
        @RequestParam String radius,
        @RequestParam String gameId,
        Model model) {

        log.info("Received coordinates: {}", new double[]{latitude, longitude});

        ApiKeyLoader apiKeyLoader = new ApiKeyLoader();
        String apiKey = apiKeyLoader.getApiKey();
//        String url = "https://maps.googleapis.com/maps/api/js?key=" + apiKey;

        var game = gameService.getById(gameId);
        double[] coordinates = {0.0, 0.0};
        if(game.getLatitude() != null) {
            coordinates[0] = game.getLatitude();
            coordinates[1] = game.getLongitude();
        } else {
            coordinates = randomCoordinateGenerator.generateRandomCoordinate(latitude, longitude, Integer.parseInt(radius));
            gameService.updateGame(gameId, coordinates[0], coordinates[1]);
        }

        model.addAttribute("latitude", coordinates[0]);
        model.addAttribute("longitude", coordinates[1]);
        model.addAttribute("apiKey", apiKey);

        return "dynamicStreetView";
    }
}
