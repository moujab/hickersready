package com.hikersway.backend.repository;

import com.hikersway.backend.entity.Town;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TownRepository extends JpaRepository<Town, String> {
}
