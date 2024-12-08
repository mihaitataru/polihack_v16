package com.example.polihackv16.repository;

import com.example.polihackv16.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    @Query("SELECT u FROM User u ORDER BY u.score DESC")
    List<User> findAllOrderedByScoreDesc();

    Optional<User> findByUsername(String username);
}
