package ving.vingterview.websocket;

import com.fasterxml.jackson.annotation.JsonIgnore;
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

    @JsonIgnore
    private boolean finishParticipate = false;
    @JsonIgnore
    private boolean finishPoll = false;
    @JsonIgnore
    private int next = 0;

    public void addNext() {
        next += 1;
    }
    public void setFinishParticipate(boolean finishParticipate) {
        this.finishParticipate = finishParticipate;
    }

    public void setFinishPoll(boolean finishPoll) {
        this.finishPoll = finishPoll;
    }

    public void increaseRound() {
        round += 1;
    }


    public void addPoll(String p) {
        poll.add(p);
    }

    public void initGameInfo() {
        setParticipant(new ArrayList<>());
        setOrder(new ArrayList<>());
        setPoll(new ArrayList<>());
        finishParticipate = false;
        finishPoll = false;
        next = 0;
    }
}
