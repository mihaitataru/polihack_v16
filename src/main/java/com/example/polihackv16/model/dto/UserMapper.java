package com.example.polihackv16.model.dto;

import com.example.polihackv16.model.User;

public class UserMapper {
    public static UserDTO toDto(User user) {
        return UserDTO.builder()
                .username(user.getUsername())
                .score(user.getScore())
                .build();
    }
}
