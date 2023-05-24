package ving.vingterview.websocket;

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


    private String mostFrequentElement(List<String> poll) {

        Map<String, Integer> frequencyMap = new HashMap<>();
        for (String p : poll) {
            if (frequencyMap.containsKey(p)) {
                frequencyMap.put(p,frequencyMap.get(p)+1);
            }else{
                frequencyMap.put(p, 1);
            }
        }

        String mostFrequentElement = "";
        int maxFrequency = 0;

        // 맵을 순회하면서 가장 빈도가 높은 요소를 찾음
        for (Map.Entry<String, Integer> entry : frequencyMap.entrySet()) {
            if (entry.getValue() > maxFrequency) {
                maxFrequency = entry.getValue();
                mostFrequentElement = entry.getKey();
            }
        }

        return mostFrequentElement;

    }

    public String getResult() {
        List<String> poll = gameInfo.getPoll();
        return mostFrequentElement(poll);
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




    public void handleMessage(GameMessage gameMessage, ObjectMapper objectMapper) {

        if (gameMessage.getType() == MessageType.CREATE) {
            send(gameMessage, objectMapper);

            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }

           /* GameMessage startGameMessage = new GameMessage();
            startGameMessage.startGameMessage(roomId,gameInfo);
            send(startGameMessage, objectMapper);*/

            GameMessage questionGameMessage = new GameMessage();
            gameInfo.increaseRound();
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
                        messageObject.setType(MessageType.TURN);
                        messageObject.setSessionId(session.getId());
                        TextMessage message = new TextMessage(objectMapper.writeValueAsString(messageObject));
                        session.sendMessage(message);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }else{
                    try {
                        messageObject.setSessionId(session.getId());
                        messageObject.setType(MessageType.VIDEO);
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
