package com.example.polihackv16.service;

import com.example.polihackv16.model.User;
import com.example.polihackv16.model.dto.UserDTO;
import com.example.polihackv16.model.dto.UserMapper;
import com.example.polihackv16.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class UserService {
    private final UserRepository userRepository;

    public List<UserDTO> getAllUsers() {
        return userRepository.findAllOrderedByScoreDesc()
                .stream()
                .map(UserMapper::toDto)
                .toList();
    }

    public void updateScore(String username, Long score) {
        userRepository.findByUsername(username)
                .ifPresentOrElse(user -> applyUpdate(user, score),
                        () -> log.warn("User with username: " + username + "not found."));
    }

    private void applyUpdate(User user, Long score) {
        var previousScore = user.getScore();
        user.setScore(score + previousScore);
        userRepository.save(user);
    }
}
