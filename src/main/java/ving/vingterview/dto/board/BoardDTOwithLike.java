package ving.vingterview.dto.board;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class BoardDTOwithLike {

    private BoardDTO boardDTO;

    private Boolean like;

    @Builder
    public BoardDTOwithLike(BoardDTO boardDTO, Boolean like) {
        this.boardDTO = boardDTO;
        this.like = like;
    }


}
