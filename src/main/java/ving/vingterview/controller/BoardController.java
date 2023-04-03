package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.board.*;

@RestController
@RequestMapping("/boards")
@RequiredArgsConstructor
public class BoardController {


    @GetMapping("")
    public ResponseEntity<BoardListDTO> list(@RequestParam(name = "member_id", required = false) Long member_id,
                                             @RequestParam(name = "question_id", required = false) Long question_id) {
        return null;
    }

    @PostMapping("")
    public Long create(@ModelAttribute BoardCreateDTO boardCreateDTO,
                       @ModelAttribute BoardVideoDTO boardVideoDTO) {
        return null; // board_id
    }

    @GetMapping("/{id}")
    public ResponseEntity<BoardDTO> board(@PathVariable(name = "id") Long id) {
        return null;
    }


    @DeleteMapping("/{id}")
    public Long delete(@PathVariable(name = "id") Long id) {
        return null;
    }


    @PutMapping("/{id}")
    public Long update(@PathVariable(name = "id") Long id,
                       @ModelAttribute BoardUpdateDTO boardUpdateDTO,
                       @ModelAttribute BoardVideoDTO boardVideoDTO) {
        return null;
    }


    @GetMapping("/{id}/like")
    public void like(@PathVariable(name = "id") Long id) {
        return;
    }
}
