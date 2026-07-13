package com.hikersway.backend.repository;

import com.hikersway.backend.entity.Guide;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GuideRepository extends JpaRepository<Guide, String> {
}
