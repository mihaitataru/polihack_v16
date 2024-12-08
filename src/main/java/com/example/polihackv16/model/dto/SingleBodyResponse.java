package com.example.polihackv16.model.dto;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class SingleBodyResponse<T> {
    T body;
}
