package ving.vingterview.websocket;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class GameInfo {

    private List<String> question;
    private List<String> order = new ArrayList<>();
    private List<String> participant = new ArrayList<>();
    private List<String> poll = new ArrayList<>();
    private int round = 0;

    public void increaseRound() {
        round += 1;
    }


    public void addPoll(String p) {
        poll.add(p);
    }
}
