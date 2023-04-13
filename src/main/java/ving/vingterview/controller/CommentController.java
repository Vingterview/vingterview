package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.comment.*;
import ving.vingterview.service.comment.CommentService;

@Slf4j
@RestController
@RequestMapping(value = "/comments", produces = "application/json;charset=utf8")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    @GetMapping(params = "board_id")
    public ResponseEntity<CommentListDTO> findByBoard(@RequestParam(name = "board_id") Long boardId) {
        CommentListDTO result = commentService.findByBoard(boardId);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping(params = "member_id")
    public ResponseEntity<CommentListDTO> findByMember(@RequestParam(name = "member_id") Long memberId) {
        CommentListDTO result = commentService.findByMember(memberId);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @PostMapping(value = "")
    public ResponseEntity<CommentResponseDTO> create(@RequestBody CommentCreateDTO commentCreateDTO) {
        return new ResponseEntity<>(new CommentResponseDTO(commentService.create(commentCreateDTO)), HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<CommentDTO> comment(@PathVariable Long id) {
        CommentDTO comment = commentService.findOne(id);
        return new ResponseEntity<>(comment, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        commentService.delete(id);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CommentResponseDTO> update(@PathVariable Long id, @RequestBody CommentUpdateDTO commentUpdateDTO) {
        return new ResponseEntity<>(new CommentResponseDTO(commentService.update(id, commentUpdateDTO)), HttpStatus.CREATED);
    }

    @GetMapping("/{id}/like")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void like(@PathVariable Long id) {
        commentService.like(id);
    }
}
