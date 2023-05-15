package ving.vingterview.config.websocket;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GameMessage {

    private String roomId;
    private String sessionId;
    private MessageType type;
    private GameInfo gameInfo;
    private String message = ""; // for mapping

    public void createGameMessage(String roomId,GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.CREATE;
        this.gameInfo = gameInfo;
    }

    public void startGameMessage(String roomId,GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.START;
        this.gameInfo = gameInfo;

    }

    public void questionGameMessage(String roomId,GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.QUESTION;
        this.gameInfo = gameInfo;

    }

    public void infoGameMessage(String roomId,GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.INFO;
        this.gameInfo = gameInfo;
    }

    public void turnGameMessage(String roomId, GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.TURN;
        this.gameInfo = gameInfo;
    }

    public void pollGameMessage(String roomId, GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.POLL;
        this.gameInfo = gameInfo;
    }


    public void resultGameMessage(String roomId, GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.RESULT;
        this.gameInfo = gameInfo;
    }

    public void finishGameMessage(String roomId, GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.FINISH_GAME;
        this.gameInfo = gameInfo;
    }
}
