package com.example.polihackv16.model.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserDTO {
    private String username;

    private Long score;
}
