package com.hikersway.backend.repository;

import com.hikersway.backend.entity.Contributor;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ContributorRepository extends JpaRepository<Contributor, String> {
}
