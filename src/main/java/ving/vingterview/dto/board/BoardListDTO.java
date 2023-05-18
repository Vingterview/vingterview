package ving.vingterview.dto.board;

import lombok.Data;

import java.util.List;

@Data
public class BoardListDTO {

    private List<BoardDTO> boards;

    /**
     * 페이징 기능 구현 용도
     */
    private int nextPage;
    private boolean hasNext;


}
