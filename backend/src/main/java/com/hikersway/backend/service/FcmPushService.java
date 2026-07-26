package com.hikersway.backend.service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.BatchResponse;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.MessagingErrorCode;
import com.google.firebase.messaging.MulticastMessage;
import com.google.firebase.messaging.Notification;
import com.google.firebase.messaging.SendResponse;
import com.hikersway.backend.entity.DeviceToken;
import com.hikersway.backend.repository.DeviceTokenRepository;
import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * Sends announcement push notifications to every registered device via
 * Firebase Cloud Messaging. Credentials come from the
 * {@code FIREBASE_SERVICE_ACCOUNT_JSON} environment variable (the full
 * service-account JSON, pasted into Railway's variables). When the variable
 * is absent — e.g. local dev — pushes are skipped and only logged, so the
 * rest of the backend keeps working.
 */
@Service
public class FcmPushService {

    private static final Logger log = LoggerFactory.getLogger(FcmPushService.class);
    private static final int FCM_BATCH_LIMIT = 500;

    private final DeviceTokenRepository tokenRepository;
    private final boolean enabled;

    public FcmPushService(
            DeviceTokenRepository tokenRepository,
            @Value("${FIREBASE_SERVICE_ACCOUNT_JSON:}") String serviceAccountJson) {
        this.tokenRepository = tokenRepository;
        boolean ok = false;
        if (serviceAccountJson == null || serviceAccountJson.isBlank()) {
            log.warn("FIREBASE_SERVICE_ACCOUNT_JSON not set — push notifications disabled");
        } else {
            try {
                if (FirebaseApp.getApps().isEmpty()) {
                    FirebaseApp.initializeApp(FirebaseOptions.builder()
                            .setCredentials(GoogleCredentials.fromStream(new ByteArrayInputStream(
                                    serviceAccountJson.getBytes(StandardCharsets.UTF_8))))
                            .build());
                }
                ok = true;
            } catch (Exception e) {
                log.error("Firebase initialization failed — push notifications disabled", e);
            }
        }
        this.enabled = ok;
    }

    /**
     * Pushes the given title/body to every registered device. Tokens FCM
     * reports as no-longer-valid are deleted so the table doesn't accumulate
     * dead browsers and uninstalled apps.
     */
    public void sendToAll(String title, String body) {
        if (!enabled) {
            log.info("Push skipped (disabled): {}", title);
            return;
        }
        List<String> tokens = tokenRepository.findAll().stream().map(DeviceToken::getToken).toList();
        if (tokens.isEmpty()) {
            return;
        }
        for (int from = 0; from < tokens.size(); from += FCM_BATCH_LIMIT) {
            List<String> batch = tokens.subList(from, Math.min(from + FCM_BATCH_LIMIT, tokens.size()));
            try {
                MulticastMessage message = MulticastMessage.builder()
                        .addAllTokens(batch)
                        .setNotification(Notification.builder().setTitle(title).setBody(body).build())
                        .build();
                BatchResponse response = FirebaseMessaging.getInstance().sendEachForMulticast(message);
                List<String> dead = new ArrayList<>();
                for (int i = 0; i < response.getResponses().size(); i++) {
                    SendResponse sr = response.getResponses().get(i);
                    // Only prune tokens FCM says are permanently gone;
                    // transient failures keep their registration.
                    if (!sr.isSuccessful() && sr.getException() != null
                            && sr.getException().getMessagingErrorCode() == MessagingErrorCode.UNREGISTERED) {
                        dead.add(batch.get(i));
                    }
                }
                if (!dead.isEmpty()) {
                    tokenRepository.deleteAllById(dead);
                    log.info("Removed {} invalid device tokens", dead.size());
                }
                log.info("Push '{}' sent: {} ok, {} failed", title,
                        response.getSuccessCount(), response.getFailureCount());
            } catch (Exception e) {
                log.error("Push send failed for '{}'", title, e);
            }
        }
    }
}
