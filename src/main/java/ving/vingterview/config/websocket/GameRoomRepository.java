package ving.vingterview.config.websocket;

import lombok.Getter;
import org.springframework.web.socket.WebSocketSession;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@Getter
public class GameRoomRepository {
    private Map<String, GameRoom> gameRoomMap = new HashMap<String, GameRoom>();
    private Map<String, String> sessionMap = new HashMap<String,String>(); // (sessionId, roomId)

    public void addRoom(String roomId, GameRoom gameRoom) {
        gameRoomMap.put(roomId, gameRoom);
    }

    public void addSession(String sessionId, String roomId) {
        sessionMap.put(sessionId, roomId);
    }

    public String getRoomId(String sessionId) {
        return sessionMap.get(sessionId);
    }

    public GameRoom getGameRoom(String roomId) {
        return gameRoomMap.get(roomId);
    }

    public void removeGameRoom(String roomId) {
        if (gameRoomMap.containsKey(roomId)) {
            GameRoom gameRoom = gameRoomMap.get(roomId);
            for (WebSocketSession session : gameRoom.getSessions()) {
                if (sessionMap.containsKey(session.getId())) {
                    sessionMap.remove(session.getId());
                }
            }

            gameRoomMap.remove(roomId);
        }

    }


}
