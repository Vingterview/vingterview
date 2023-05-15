package ving.vingterview.config.websocket;

import lombok.Getter;

import java.util.HashMap;
import java.util.Map;

@Getter
public class GameRoomRepository {
    private Map<String, GameRoom> gameRoomMap = new HashMap<String, GameRoom>();

    public void addRoom(String roomId, GameRoom gameRoom) {
        gameRoomMap.put(roomId, gameRoom);
    }



}
