package ving.vingterview.websocket;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.socket.WebSocketSession;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class GameMessage {

    private String roomId;
    private String sessionId;
    private MessageType type;
    private GameInfo gameInfo;
    private String poll = ""; // for mapping

    private String currentBroadcaster;
    private String agoraToken;

    private List<MemberInfo> memberInfos = new ArrayList<>();

    public void createGameMessage(String roomId,GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.CREATE;
        this.gameInfo = gameInfo;
    }

    public void setMemberInfo(WebSocketSession session) {
        MemberInfo memberInfo = new MemberInfo();
        memberInfo.setName((String) session.getAttributes().get("name"));
        memberInfo.setSessionId(session.getId());
        memberInfo.convertImageToBase64((String) session.getAttributes().get("imageUrl"));

        memberInfos.add(memberInfo);

    }

    public void videoGameMessage(String roomId,GameInfo gameInfo,String sessionId) {
        this.roomId = roomId;
        this.type = MessageType.VIDEO;
        this.currentBroadcaster =sessionId;
        this.gameInfo = gameInfo;
    }

    public void questionGameMessage(String roomId,GameInfo gameInfo) {
        this.roomId = roomId;
        this.type = MessageType.START;
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

    public void finishVideoMessage(String roomId, GameInfo gameInfo, String sessionId) {
        this.roomId = roomId;
        this.type = MessageType.FINISH_VIDEO;
        this.currentBroadcaster = sessionId;
        this.gameInfo = gameInfo;

    }
}
