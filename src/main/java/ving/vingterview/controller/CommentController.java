package ving.vingterview.controller;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.annotation.LoginMemberId;
import ving.vingterview.annotation.Trace;
import ving.vingterview.dto.ErrorResult;
import ving.vingterview.dto.comment.*;
import ving.vingterview.service.comment.CommentService;


@Slf4j
@RestController
@RequestMapping(value = "/comments", produces = "application/json;charset=utf8")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;


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

    @GetMapping(params = "board_id")
    @Trace
    public ResponseEntity<CommentListDTO> findByBoard(@RequestParam(name = "board_id") Long boardId,
                                                      @RequestParam(name = "page", defaultValue = "0") int page,
                                                      @RequestParam(name = "size", defaultValue = "20") int size) {

        CommentListDTO result = commentService.findByBoard(boardId, page, size);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping(params = "member_id")
    @Trace
    public ResponseEntity<CommentListDTO> findByMember(@RequestParam(name = "member_id") Long memberId,
                                                       @RequestParam(name="page",defaultValue ="0")int page,
                                                       @RequestParam(name="size", defaultValue="20")int size) {
        CommentListDTO result = commentService.findByMember(memberId,page,size);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @PostMapping(value = "")
    @Trace
    public ResponseEntity<CommentResponseDTO> create(@RequestBody CommentCreateDTO commentCreateDTO,
                                                     @LoginMemberId Long memberId) {
        return new ResponseEntity<>(new CommentResponseDTO(commentService.create(memberId, commentCreateDTO)), HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    @Trace
    public ResponseEntity<CommentDTO> comment(@PathVariable Long id) {
        CommentDTO comment = commentService.findOne(id);
        return new ResponseEntity<>(comment, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Trace
    public void delete(@PathVariable Long id,
                       @LoginMemberId Long memberId) {
        commentService.delete(id,memberId);
    }

    @PutMapping("/{id}")
    @Trace
    public ResponseEntity<CommentResponseDTO> update(@PathVariable Long id,
                                                     @RequestBody CommentUpdateDTO commentUpdateDTO,
                                                     @LoginMemberId Long memberId) {
        return new ResponseEntity<>(new CommentResponseDTO(commentService.update(id, commentUpdateDTO,memberId)), HttpStatus.CREATED);
    }

    @GetMapping("/{id}/like")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Trace
    public void like(@PathVariable Long id,
                     @LoginMemberId Long memberId) {
        commentService.like(memberId, id);
    }
}
