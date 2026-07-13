package com.hikersway.backend.repository;

import com.hikersway.backend.entity.UpcomingHike;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UpcomingHikeRepository extends JpaRepository<UpcomingHike, String> {
}
