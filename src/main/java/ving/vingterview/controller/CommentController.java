package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.comment.CommentCreateDTO;
import ving.vingterview.dto.comment.CommentDTO;
import ving.vingterview.dto.comment.CommentListDTO;
import ving.vingterview.dto.comment.CommentUpdateDTO;
import ving.vingterview.service.comment.CommentService;

@Slf4j
@RestController
@RequestMapping("/comments")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    @GetMapping(params = "board_id")
    public ResponseEntity<CommentListDTO> filterByBoard(@RequestParam(name = "board_id") Long boardId) {
        CommentListDTO result = commentService.filterByBoard(boardId);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping(params = "member_id")
    public ResponseEntity<CommentListDTO> filterByMember(@RequestParam(name = "member_id") Long memberId) {
        CommentListDTO result = commentService.filterByMember(memberId);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @PostMapping(value = "")
    public Long create(@RequestBody CommentCreateDTO commentCreateDTO) {
        return commentService.save(commentCreateDTO);
    }

    @GetMapping("/{id}")
    public ResponseEntity<CommentDTO> comment(@PathVariable Long id) {
        CommentDTO comment = commentService.findOne(id);
        return new ResponseEntity<>(comment, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        commentService.delete(id);
    }

    @PutMapping("/{id}")
    public Long update(@PathVariable Long id, @ModelAttribute CommentUpdateDTO commentUpdateDTO) {
        return commentService.update(id, commentUpdateDTO);
    }

    @GetMapping("/{id}/like")
    public void like(@PathVariable Long id) {
        // 댓글 좋아요
        return;
    }
}
