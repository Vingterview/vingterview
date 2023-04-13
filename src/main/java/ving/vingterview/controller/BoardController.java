package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import ving.vingterview.dto.board.*;
import ving.vingterview.service.board.BoardService;
import ving.vingterview.service.file.FileStore;

import java.net.URI;
import java.time.LocalDateTime;


@Slf4j
@RestController
@RequestMapping("/boards")
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;
    @Qualifier("videoStore")
    private final FileStore videoStore;

    @GetMapping(value = "")
    public ResponseEntity<BoardListDTO> boards() {

        BoardListDTO boardListDTO = boardService.findAll();

        return ResponseEntity.ok(boardListDTO);
    }

    @GetMapping(value = "", params = "member_id")
    public ResponseEntity<BoardListDTO> filterByMember(@RequestParam(name = "member_id") Long member_id) {

        Long start = System.currentTimeMillis();
        BoardListDTO boardListDTO = boardService.findByMember(member_id);
        Long end = System.currentTimeMillis();
        log.info("findByMember {}", end-start);

        return ResponseEntity.ok(boardListDTO);
    }

    @GetMapping(value = "", params = "question_id")
    public ResponseEntity<BoardListDTO> filterByQuestion(@RequestParam(name = "question_id") Long question_id) {
        BoardListDTO boardListDTO = boardService.findByQuestion(question_id);

        return ResponseEntity.ok(boardListDTO);
    }

    @PostMapping("")
    public ResponseEntity<BoardResponseDTO> create(@RequestBody BoardCreateDTO boardCreateDTO) {

        Long boardId = boardService.save(boardCreateDTO);
        BoardResponseDTO boardResponseDTO = new BoardResponseDTO();
        boardResponseDTO.setBoardId(boardId);

        return new ResponseEntity<>(boardResponseDTO, HttpStatus.CREATED);
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
    public ResponseEntity<BoardResponseDTO> update(@PathVariable(name = "id") Long id,
                       @RequestBody BoardUpdateDTO boardUpdateDTO) {

        Long boardId = boardService.update(id, boardUpdateDTO);

        BoardResponseDTO boardResponseDTO = new BoardResponseDTO();
        boardResponseDTO.setBoardId(boardId);
        return new ResponseEntity<>(boardResponseDTO, HttpStatus.CREATED);


    }


    @GetMapping("/{id}/like")
    public void like(@PathVariable(name = "id") Long id) {

        boardService.like(id,1L);

    }

    @PostMapping("/video")
    public ResponseEntity<VideoResponseDTO> videoUpload(@ModelAttribute VideoDTO videoDTO) {
        if (!videoDTO.getVideo().isEmpty() && videoDTO.getVideo() != null) {
            String storeFileName = videoStore.createStoreFileName(videoDTO.getVideo().getOriginalFilename());

            log.info("----------uploadFile----------start {} {}", LocalDateTime.now(), Thread.currentThread().getName());
            videoStore.uploadFile(videoDTO.getVideo(), storeFileName);
            log.info("----------UploadFile----------returned {} {}", LocalDateTime.now(), Thread.currentThread().getName());

            VideoResponseDTO videoResponseDTO = new VideoResponseDTO();
            videoResponseDTO.setVideoUrl(storeFileName);

            return new ResponseEntity<>(videoResponseDTO, HttpStatus.CREATED);

        }

        VideoResponseDTO videoResponseDTO = new VideoResponseDTO();
        videoResponseDTO.setVideoUrl("잘못된 접근입니다.");
        return ResponseEntity.badRequest()
                .body(videoResponseDTO);
    }
}
