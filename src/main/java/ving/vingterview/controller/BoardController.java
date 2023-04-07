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

    @GetMapping(value = "",params = "member_id")
    public ResponseEntity<BoardListDTO> filterByMember(@RequestParam(name = "member_id") Long member_id){

        BoardListDTO boardListDTO = boardService.findByMember(member_id);

        return ResponseEntity.ok(boardListDTO);
    }

    @GetMapping(value = "",params = "question_id")
    public ResponseEntity<BoardListDTO> filterByQuestion(@RequestParam(name = "question_id") Long question_id) {
        BoardListDTO boardListDTO = boardService.findByQuestion(question_id);

        return ResponseEntity.ok(boardListDTO);
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
