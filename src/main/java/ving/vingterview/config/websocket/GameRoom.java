package ving.vingterview.config.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.*;

@Slf4j
@Getter
public class GameRoom {

    private String  roomId;
    private Set<WebSocketSession> sessions = new HashSet<>();
    private GameInfo gameInfo;

    public GameRoom(String roomId) {
        this.roomId = roomId;
        this.gameInfo = new GameInfo();
    }

    public String getResult() {
        List<String> poll = gameInfo.getPoll();
        return "1";
    }

    public void setRandomOrder() {
        List<String> participant = gameInfo.getParticipant();

        if (participant.size() < 3) {
            int rest = 3 - participant.size();
            for (WebSocketSession session : sessions) {
                if ((!participant.contains(session.getId())) && rest > 0) {
                    participant.add(session.getId());
                    rest -= 1;
                }
            }
        }

        ArrayList<String> temp = new ArrayList<>(participant);
        Collections.shuffle(temp);
        gameInfo.setOrder(temp);
    }
    public void addParticipant(String sessionId) {
        if(!gameInfo.getParticipant().contains(sessionId)){
            gameInfo.getParticipant().add(sessionId);
        }
    }

    public void initGameInfo() {
        gameInfo.setParticipant(new ArrayList<>());
        gameInfo.setOrder(new ArrayList<>());
    }


    public void handleMessage(GameMessage gameMessage, ObjectMapper objectMapper) {

        if (gameMessage.getType() == MessageType.CREATE) {
            send(gameMessage, objectMapper);

            GameMessage startGameMessage = new GameMessage();
            startGameMessage.startGameMessage(roomId,gameInfo);
            send(startGameMessage, objectMapper);

            GameMessage questionGameMessage = new GameMessage();
            questionGameMessage.questionGameMessage(roomId,gameInfo);
            send(questionGameMessage, objectMapper);


        } else if (gameMessage.getType() == MessageType.INFO) {
            send(gameMessage, objectMapper);
            log.info("Server send INFO Message {}", gameMessage);
            GameMessage turnGameMessage = new GameMessage();
            turnGameMessage.turnGameMessage(roomId, gameInfo);
            send(turnGameMessage, objectMapper);
            log.info("Server send Turn Message {}", gameMessage);


        } else if (gameMessage.getType() == MessageType.RESULT) {

            send(gameMessage, objectMapper);


        } else {
            send(gameMessage, objectMapper);
        }
    }


    private void send(GameMessage messageObject, ObjectMapper objectMapper){

        // UNICAST
        if (messageObject.getType() == MessageType.TURN) {
            String target = gameInfo.getOrder().remove(0);
            for (WebSocketSession session : sessions) {
                if (session.getId().equals(target)) {
                    try {
                        messageObject.setSessionId(session.getId());
                        TextMessage message = new TextMessage(objectMapper.writeValueAsString(messageObject));
                        session.sendMessage(message);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }

        }
        // MULTICAST
        else{
            sessions.parallelStream().forEach(session -> {
                try {
                    messageObject.setSessionId(session.getId());
                    TextMessage message = new TextMessage(objectMapper.writeValueAsString(messageObject));
                    session.sendMessage(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
        }

    }


}
