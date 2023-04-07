package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.board.*;
import ving.vingterview.service.board.BoardService;

@RestController
@RequestMapping("/boards")
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;

    @GetMapping("")
    public ResponseEntity<BoardListDTO> list(@RequestParam(name = "member_id", required = false) Long member_id,
                                             @RequestParam(name = "question_id", required = false) Long question_id) {
        return null;
    }

    @PostMapping("")
    public Long create(@ModelAttribute BoardCreateDTO boardCreateDTO) {

        return boardService.save(boardCreateDTO); // board_id
    }

    @GetMapping("/{id}")
    public ResponseEntity<BoardDTO> board(@PathVariable(name = "id") Long id) {

        return ResponseEntity.ok(boardService.findById(id));


    }


    @DeleteMapping("/{id}")
    public void delete(@PathVariable(name = "id") Long id) {

        boardService.delete(id);
    }


    @PutMapping("/{id}")
    public Long update(@PathVariable(name = "id") Long id,
                       @ModelAttribute BoardUpdateDTO boardUpdateDTO) {

        return boardService.update(id, boardUpdateDTO);

    }


    @GetMapping("/{id}/like")
    public void like(@PathVariable(name = "id") Long id) {
        boardService.like(id);
    }

    @GetMapping("/video")
    public String videoUpload(BoardVideoDTO boardVideoDTO) {
        return boardService.videoUpload(boardVideoDTO);
    }
}
