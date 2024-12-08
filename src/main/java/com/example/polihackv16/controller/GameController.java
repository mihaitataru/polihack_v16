package com.example.polihackv16.controller;

import com.example.polihackv16.model.dto.SingleBodyResponse;
import com.example.polihackv16.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.util.Pair;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("api/v1/game")
@RequiredArgsConstructor
public class GameController {
    private final GameService gameService;

    @GetMapping ("/{username}")
    public ResponseEntity<String> create(@PathVariable String username) {
        var game = gameService.createGame(username);
        return ResponseEntity.ok(game.getId());
    }

}
