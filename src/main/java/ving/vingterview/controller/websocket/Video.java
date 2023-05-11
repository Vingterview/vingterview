package ving.vingterview.controller.websocket;

public class Video {

    private byte[] stream;

    public Video() {
    }

    public Video(byte[] stream) {
        this.stream = stream;
    }

    public byte[] getStream() {
        return stream;
    }
}
