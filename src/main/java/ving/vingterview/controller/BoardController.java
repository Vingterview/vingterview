package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.domain.file.UploadFile;
import ving.vingterview.dto.board.*;
import ving.vingterview.service.board.BoardService;

import java.util.concurrent.CompletableFuture;

@Slf4j
@RestController
@RequestMapping("/boards")
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;


    @GetMapping(value = "")
    public ResponseEntity<BoardListDTO> boards() {

        BoardListDTO boardListDTO = boardService.findAll();

        return ResponseEntity.ok(boardListDTO);
    }

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
    public Long create(@RequestBody BoardCreateDTO boardCreateDTO) {

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
                       @RequestBody BoardUpdateDTO boardUpdateDTO) {

        return boardService.update(id, boardUpdateDTO);

    }


    @GetMapping("/{id}/like")
    public void like(@PathVariable(name = "id") Long id) {
        boardService.like(id);
    }

    @PostMapping("/video")
    public String videoUpload(@ModelAttribute BoardVideoDTO boardVideoDTO) {
        String videoUrl = boardService.videoUpload(boardVideoDTO);
        log.info("BoardController.videoUpload Returned {}", videoUrl);

        return videoUrl;
    }




/*    @PostMapping("/{id}/video")
    public String videoUploadByBoard(@PathVariable(name = "id") Long id,@ModelAttribute BoardVideoDTO boardVideoDTO) {
        return boardService.videoUpload(boardVideoDTO);
    }*/
}
