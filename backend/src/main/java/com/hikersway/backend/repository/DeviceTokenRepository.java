package com.hikersway.backend.repository;

import com.hikersway.backend.entity.DeviceToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DeviceTokenRepository extends JpaRepository<DeviceToken, String> {
}
