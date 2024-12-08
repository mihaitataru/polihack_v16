package com.example.polihackv16.controller;

import com.example.polihackv16.model.Game;
import com.example.polihackv16.model.ScoreRequest;
import com.example.polihackv16.model.dto.UserDTO;
import com.example.polihackv16.service.GameService;
import com.example.polihackv16.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.antlr.v4.runtime.misc.Pair;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("api/v1/score")
@Log4j2
public class ScoreController {
    private final UserService userService;

    private final GameService gameService;

    @GetMapping("/users")
    public ResponseEntity<List<UserDTO>> getUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/{username}")
    public ResponseEntity<String> submitAnswer(
            @PathVariable String username,
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam String radius,
            @RequestParam String gameId) {

        var game = gameService.getById(gameId);
        var score = calculateScore(latitude, longitude, Integer.parseInt(radius), game);
        userService.updateScore(username, score);

        log.info("User {} scored: {}.", username, score);

        return ResponseEntity.ok(score.toString());
    }

    @GetMapping("/coordinates")
    public ResponseEntity<Pair<Double, Double>> getLocation( @RequestParam String gameId ) {
        var game = gameService.getById(gameId);
        var coord = new Pair<>(game.getLatitude(), game.getLongitude());

        log.info("Coordinates requested: {}", coord);
        return ResponseEntity.ok(coord);
    }

    private Long calculateScore(double latitude, double longitude, int d, Game game) {
        final int EARTH_RADIUS = 6371; // Earth radius in kilometers
        final int MAX_SCORE = 1000;

        double correctLatRad = Math.toRadians(game.getLatitude());
        double correctLonRad = Math.toRadians(game.getLongitude());
        double latRad = Math.toRadians(latitude);
        double lonRad = Math.toRadians(longitude);

        double dlat = latRad - correctLatRad;
        double dlon = lonRad - correctLonRad;
        double a = Math.sin(dlat / 2) * Math.sin(dlat / 2)
                + Math.cos(correctLatRad) * Math.cos(latRad)
                * Math.sin(dlon / 2) * Math.sin(dlon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distance = EARTH_RADIUS * c * 1000; // Convert to meters

        return (long) Math.max(0, MAX_SCORE * (1 - distance / d));
    }
}
