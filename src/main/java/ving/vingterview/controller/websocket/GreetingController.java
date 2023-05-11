package ving.vingterview.controller.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

import java.io.ByteArrayInputStream;
import java.io.ObjectInputStream;

//@Controller
public class GreetingController {

//    @Autowired
//    private SimpMessagingTemplate messagingTemplate;
    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
    public Greeting greeting(HelloMessage message) throws Exception {
        System.out.println(message);
        System.out.println(message.getName());
//        messagingTemplate.convertAndSend("/topic/greetings", "Hello, subscribers!" + message.getName());
        return new Greeting("Hello, " + HtmlUtils.htmlEscape(message.getName()) + "!");
    }

    @MessageMapping("/stream")
    @SendTo("/topic/video")
    public Video videoStream(@Payload byte[] videoData) throws Exception {
        System.out.println("videoStream 실행");
        System.out.println(videoData);
//        ByteArrayInputStream in = new ByteArrayInputStream(videoData);
//        ObjectInputStream is = new ObjectInputStream(in);

//        messagingTemplate.convertAndSend("/topic/greetings", "Hello, subscribers!" + message.getName());
//        messagingTemplate.convertAndSend("/topic/video",is.);
//        messagingTemplate.convertAndSend("/topic/video",videoData);
        return new Video(videoData);
    }

}
