package ving.vingterview.config.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import ving.vingterview.domain.question.Question;
import ving.vingterview.repository.QuestionRepository;

import java.util.Queue;
import java.util.UUID;
import java.util.concurrent.LinkedBlockingQueue;

@Slf4j
@Component
@RequiredArgsConstructor
public class SocketHandler extends TextWebSocketHandler {

    private final Queue<WebSocketSession> waitingQueue = new LinkedBlockingQueue<>();
    private final GameRoomRepository gameRoomRepository = new GameRoomRepository();
    private final QuestionRepository questionRepository;

    ObjectMapper objectMapper = new ObjectMapper();

    public static final int NUMBEROFPLAYERS = 3;




    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        waitingQueue.offer(session);
        log.info("Server : waitingQueue add {}", session);

        if ( NUMBEROFPLAYERS <= waitingQueue.size()) {
            GameRoom room = createRoom();
            log.info("Server : Make Game Room , {}", room.getRoomId());
        }

    }

    private GameRoom createRoom() {
        String roomId = UUID.randomUUID().toString();
        GameRoom gameRoom = new GameRoom(roomId);
        GameInfo gameInfo = gameRoom.getGameInfo();
        gameInfo.setQuestion(questionRepository.findRandom().stream().map(Question::getContent).toList());



        /**
         * 소캣 NUMBEROFPLAYERS 만큼 제거해서 GameRoom에 추가
         */
        for (int i = 0; i < NUMBEROFPLAYERS; i++) {
            gameRoom.getSessions().add(waitingQueue.poll());
        }

        /**
         * Create Room Message 생성
         */
        GameMessage gameMessage = new GameMessage();
        gameMessage.createGameMessage(roomId,gameInfo);

        gameRoomRepository.addRoom(gameRoom.getRoomId(), gameRoom);
        gameRoom.handleMessage(gameMessage,objectMapper);

        return gameRoom;
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception{
        String payload = message.getPayload();

        GameMessage gameMessage = objectMapper.readValue(payload, GameMessage.class);
        String roomId = gameMessage.getRoomId();
        MessageType type = gameMessage.getType();
        String sessionId = gameMessage.getSessionId();

        GameRoom gameRoom = gameRoomRepository.getGameRoomMap().get(roomId);
        GameInfo gameInfo = gameRoom.getGameInfo();


        switch (type) {
            case PARTICIPATE ->
            {
                log.info("CLIENT SEND PARTICIPANT");
                gameRoom.addParticipant(sessionId);
            }
            case FINISH_PARTICIPATE -> {
                log.info("CLIENT SEND PARTICIPANT FINISH");
                gameRoom.setRandomOrder();
                gameInfo.increaseRound();
                GameMessage infoGameMessage = new GameMessage();
                infoGameMessage.infoGameMessage(roomId, gameInfo);
                gameRoom.handleMessage(infoGameMessage,objectMapper);
            }
            case FINISH_VIDEO ->{

                if (gameRoom.getGameInfo().getOrder().size() == 0) {
                    log.info("CLIENT SEND FINISH VIDEO, NO MORE PARTICIPANT");
                    GameMessage pollGameMessage = new GameMessage();
                    pollGameMessage.pollGameMessage(roomId, gameInfo);
                    gameRoom.handleMessage(pollGameMessage,objectMapper);
                }else{
                    log.info("CLIENT SEND FINISH VIDEO, NEXT PARTICIPANT");
                    GameMessage turnGameMessage = new GameMessage();
                    turnGameMessage.turnGameMessage(roomId, gameInfo);
                    gameRoom.handleMessage(turnGameMessage, objectMapper);
                }

            }
            case POLL ->{
                log.info("CLIENT SEND POLL");
                gameInfo.addPoll(gameMessage.getMessage());
            }
            case FINISH_POLL ->{
                log.info("CLIENT SEND POLL FINISH");
                GameMessage resultGameMessage = new GameMessage();
                String winner = gameRoom.getResult();
                resultGameMessage.setMessage(winner);
                resultGameMessage.resultGameMessage(roomId, gameInfo);
                gameRoom.handleMessage(resultGameMessage, objectMapper);
            }
            case NEXT->{
                log.info("CLIENT SEND NEXT");
                if (gameInfo.getRound() == 3) {
                    log.info("NO MORE ROUND, finish game");
                    // finish
                    GameMessage finishGameMessage = new GameMessage();
                    finishGameMessage.finishGameMessage(roomId,gameInfo);
                    gameRoom.handleMessage(finishGameMessage, objectMapper);

                }else{
                    log.info("GO NEXT ROUND");
                    //next round
                    GameMessage questionGameMessage = new GameMessage();
                    questionGameMessage.questionGameMessage(roomId,gameInfo);
                    gameRoom.handleMessage(questionGameMessage, objectMapper);
                }
            }

        }




    }

    @Override
    protected void handleBinaryMessage(WebSocketSession session, BinaryMessage message) {

/*        for (WebSocketSession sess : sessions) {
            try {
                sess.sendMessage(new BinaryMessage(message.getPayload()));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }*/
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        waitingQueue.remove(session);
    }
}
