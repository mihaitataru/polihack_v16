package com.example.polihackv16.service;

import com.example.polihackv16.model.Game;
import com.example.polihackv16.repository.GameRepository;
import com.example.polihackv16.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GameService {
    private final GameRepository gameRepository;

    private final UserRepository userRepository;

    public Game getById(String id) {
        return gameRepository.findById(id).orElse(null);
    }

    public Game createGame(String username) {
        var user = userRepository.findByUsername(username).get();
        var game = Game.builder()
                .ongoing(true)
                .userId(user.getId())
                .build();

        return gameRepository.save(game);
    }

    public Game updateGame(String id, Double lat, Double longt) {
        var game = gameRepository.findById(id).orElse(null);

        game.setLatitude(lat);
        game.setLongitude(longt);

        return gameRepository.save(game);
    }
}
