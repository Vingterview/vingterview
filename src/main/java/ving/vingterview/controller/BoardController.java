package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import ving.vingterview.annotation.LoginMemberId;
import ving.vingterview.dto.board.*;
import ving.vingterview.service.board.BoardService;
import ving.vingterview.service.file.FileStore;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;


@Slf4j
@RestController
@RequestMapping(value = "/boards", produces = "application/json;charset=utf8")
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

    @GetMapping(value = "", params = {"order_by","sort"})
    public ResponseEntity<BoardListDTO> filterByOrder(@RequestParam(name = "order_by") String order,@RequestParam(name="sort") String sort) {

        if (order == "좋아요") {
            boardService.orderByLike(sort);
        } else if (order =="댓글") {

        } else if (order == "최신") {

        }

        BoardListDTO boardListDTO = new BoardListDTO();
        boardListDTO.setBoards(new ArrayList<>());

        return ResponseEntity.badRequest().body(boardListDTO);


    }

    @PostMapping("")
    public ResponseEntity<BoardResponseDTO> create(@RequestBody BoardCreateDTO boardCreateDTO,
                                                   @LoginMemberId Long memberId) {

        Long boardId = boardService.save(memberId, boardCreateDTO);
        BoardResponseDTO boardResponseDTO = new BoardResponseDTO();
        boardResponseDTO.setBoardId(boardId);

        return new ResponseEntity<>(boardResponseDTO, HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<BoardDTO> board(@PathVariable(name = "id") Long id) {
        return ResponseEntity.ok(boardService.findById(id));
    }


    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
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
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void like(@PathVariable(name = "id") Long id, @LoginMemberId Long memberId) {
        boardService.like(memberId, id);
    }

    @PostMapping("/video")
    public ResponseEntity<VideoResponseDTO> videoUpload(@ModelAttribute VideoDTO videoDTO) {
        if (videoDTO.getVideo() != null && !videoDTO.getVideo().isEmpty()) {
            String storeFileName = videoStore.createStoreFileName(videoDTO.getVideo().getOriginalFilename());

            log.info("----------uploadFile----------start {} {}", LocalDateTime.now(), Thread.currentThread().getName());

            try {
                videoDTO.getVideo().transferTo(new File(videoStore.getFullPath(storeFileName)));
                log.info("파일 임시 업로드 성공");
            } catch (IOException e) {
                log.warn("파일 임시 업로드 실패 {}" , e.getMessage());
            }

            videoStore.uploadFile(storeFileName);
            log.info("----------UploadFile----------returned {} {}", LocalDateTime.now(), Thread.currentThread().getName());

            VideoResponseDTO videoResponseDTO = new VideoResponseDTO();
            videoResponseDTO.setVideoUrl(storeFileName);

            return new ResponseEntity<>(videoResponseDTO, HttpStatus.CREATED);

        }

        VideoResponseDTO videoResponseDTO = new VideoResponseDTO();
        videoResponseDTO.setVideoUrl("잘못된 접근입니다.");
        return new ResponseEntity<>(videoResponseDTO, HttpStatus.BAD_REQUEST);

    }
}
