package ving.vingterview.controller;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.*;

import ving.vingterview.annotation.LoginMemberId;
import ving.vingterview.annotation.Trace;
import ving.vingterview.dto.ErrorResult;
import ving.vingterview.dto.board.*;
import ving.vingterview.service.board.BoardService;
import ving.vingterview.service.file.S3Upload;

import java.time.LocalDateTime;
import java.util.ArrayList;


@Slf4j
@RestController
@RequestMapping(value = "/boards", produces = "application/json;charset=utf8")
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;
    private final S3Upload fileStore;


    @Value("${video.dir}")
    private String tempDir;

    @ResponseStatus(HttpStatus.FORBIDDEN)
    @ExceptionHandler(AccessDeniedException.class)
    public ErrorResult accessDeniedExHandle(AccessDeniedException e) {
        log.error("[accessDeniedExHandle] ex", e);
        return new ErrorResult("403", e.getMessage());
    }

    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ExceptionHandler(EntityNotFoundException.class)
    public ErrorResult entityNotFoundExHandle(EntityNotFoundException e) {
        log.error("[entityNotFoundExHandle] ex", e);
        return new ErrorResult("404", e.getMessage());
    }


    @GetMapping(value = "")
    @Trace
    public ResponseEntity<BoardListDTO> boards(@RequestParam(name = "page", defaultValue = "0") int page,
                                               @RequestParam(name = "size", defaultValue = "20") int size) {
        log.info("BoardController boards");
        BoardListDTO boardListDTO = boardService.findAll(page, size, true);

        return ResponseEntity.ok(boardListDTO);
    }

    @GetMapping(value = "", params = "member_id")
    @Trace
    public ResponseEntity<BoardListDTO> filterByMember(@RequestParam(name = "member_id") Long member_id,
                                                       @RequestParam(name = "page", defaultValue = "0") int page,
                                                       @RequestParam(name = "size", defaultValue = "20") int size) {

        Long start = System.currentTimeMillis();
        BoardListDTO boardListDTO = boardService.findByMember(member_id, page, size);
        Long end = System.currentTimeMillis();
        log.info("findByMember {}", end - start);

        return ResponseEntity.ok(boardListDTO);
    }

    @GetMapping(value = "", params = "question_id")
    @Trace
    public ResponseEntity<BoardListDTO> filterByQuestion(@RequestParam(name = "question_id") Long question_id,
                                                         @RequestParam(name = "page", defaultValue = "0") int page,
                                                         @RequestParam(name = "size", defaultValue = "20") int size) {
        BoardListDTO boardListDTO = boardService.findByQuestion(question_id, page, size);

        return ResponseEntity.ok(boardListDTO);
    }

    @GetMapping(value = "", params = "order_by")
    @Trace
    public ResponseEntity<BoardListDTO> filterByOrder(@RequestParam(name = "order_by") String order_by,
                                                      @RequestParam(name = "page", defaultValue = "0") int page,
                                                      @RequestParam(name = "size", defaultValue = "20") int size) {

        if (order_by.equals("like")) {
            BoardListDTO boardListDTO = boardService.orderByLike(page, size);
            return ResponseEntity.ok(boardListDTO);

        } else if (order_by.equals("comment")) {
            BoardListDTO boardListDTO = boardService.orderByComment(page, size);
            return ResponseEntity.ok(boardListDTO);

        } else if (order_by.equals("old")) {
            BoardListDTO boardListDTO = boardService.findAll(page, size, false);
            return ResponseEntity.ok(boardListDTO);
        }

        BoardListDTO boardListDTO = new BoardListDTO();
        boardListDTO.setBoards(new ArrayList<>());
        boardListDTO.setHasNext(false);
        boardListDTO.setNextPage(0);

        return ResponseEntity.badRequest().body(boardListDTO);


    }

    @PostMapping("")
    @Trace
    public ResponseEntity<BoardResponseDTO> create(@RequestBody BoardCreateDTO boardCreateDTO,
                                                   @LoginMemberId Long memberId) {

        Long boardId = boardService.save(memberId, boardCreateDTO);
        BoardResponseDTO boardResponseDTO = new BoardResponseDTO();
        boardResponseDTO.setBoardId(boardId);

        return new ResponseEntity<>(boardResponseDTO, HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    @Trace
    public ResponseEntity<BoardDTOwithLike> board(@PathVariable(name = "id") Long id,
                                          @LoginMemberId Long memberId) {
        Boolean like = boardService.isLike(id, memberId);
        BoardDTO boardDTO = boardService.findById(id);

        BoardDTOwithLike boardDTOwithLike = BoardDTOwithLike.builder()
                .boardDTO(boardDTO)
                .like(like)
                .build();
        return ResponseEntity.ok(boardDTOwithLike);
    }


    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Trace
    public void delete(@PathVariable(name = "id") Long id,@LoginMemberId Long memberId)
    {
        boardService.delete(id,memberId);
    }


    @PutMapping("/{id}")
    @Trace
    public ResponseEntity<BoardResponseDTO> update(@PathVariable(name = "id") Long id,
                                                   @RequestBody BoardUpdateDTO boardUpdateDTO,
                                                   @LoginMemberId Long memberId) {

        Long boardId = boardService.update(id, boardUpdateDTO,memberId);
        BoardResponseDTO boardResponseDTO = new BoardResponseDTO();
        boardResponseDTO.setBoardId(boardId);
        return new ResponseEntity<>(boardResponseDTO, HttpStatus.CREATED);
    }


    @GetMapping("/{id}/like")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Trace
    public void like(@PathVariable(name = "id") Long id, @LoginMemberId Long memberId) {
        boardService.like(memberId, id);
    }

    @PostMapping("/video")
    @Trace
    public ResponseEntity<VideoResponseDTO> videoUpload(@ModelAttribute VideoDTO videoDTO) {
        if (videoDTO.getVideo() != null && !videoDTO.getVideo().isEmpty()) {
            String storeFileName = fileStore.createStoreFileName(videoDTO.getVideo().getOriginalFilename());

            log.info("----------uploadFile----------start {} {}", LocalDateTime.now(), Thread.currentThread().getName());

            fileStore.tempFileUpload(videoDTO.getVideo(), storeFileName);
//          videoDTO.getVideo().transferTo(new File(tempDir + storeFileName));

            fileStore.uploadFile(storeFileName);
            log.info("----------UploadFile----------returned {} {}", LocalDateTime.now(), Thread.currentThread().getName());

            VideoResponseDTO videoResponseDTO = new VideoResponseDTO();
            videoResponseDTO.setVideoUrl(fileStore.getFullPath(storeFileName, false));

            return new ResponseEntity<>(videoResponseDTO, HttpStatus.CREATED);

        }

        VideoResponseDTO videoResponseDTO = new VideoResponseDTO();
        videoResponseDTO.setVideoUrl("잘못된 접근입니다.");
        return new ResponseEntity<>(videoResponseDTO, HttpStatus.BAD_REQUEST);

    }
}
