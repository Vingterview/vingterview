package ving.vingterview.websocket;

import io.agora.media.RtcTokenBuilder2;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class AgoraTokenBuilder {

    @Value("${agora.appId}")
    private String appId;

    @Value("${agora.appCertificate}")
    private String appCertificate;

    private int expirationTimeSeconds = 3600;

    public String generateToken(String roomId, int userId) {
        RtcTokenBuilder2 tokenBuilder = new RtcTokenBuilder2();
        int timeStamp = (int) (System.currentTimeMillis()) / 1000 + expirationTimeSeconds;
        return tokenBuilder.buildTokenWithUid(
                appId,
                appCertificate,
                roomId,
                userId,
                RtcTokenBuilder2.Role.ROLE_PUBLISHER,
                timeStamp,
                timeStamp);
    }
}
