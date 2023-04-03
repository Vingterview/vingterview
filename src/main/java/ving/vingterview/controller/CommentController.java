package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.comment.CommentCreateDTO;
import ving.vingterview.dto.comment.CommentDTO;
import ving.vingterview.dto.comment.CommentListDTO;
import ving.vingterview.dto.comment.CommentUpdateDTO;

@RestController
@RequestMapping("/comments")
@RequiredArgsConstructor
public class CommentController {

    @GetMapping("")
    public ResponseEntity<CommentListDTO> list(@RequestParam(name = "board_id", required = false) Long boardId,
                                               @RequestParam(name = "member_id", required = false) Long memberId) {
        //board_id와 member_id 둘중 하나만 받아서 처리
        return null;
    }

    @PostMapping("")
    public Long create(@ModelAttribute CommentCreateDTO commentCreateDTO) {
        // 댓글 등록
        return null; // 댓글 id 반환
    }

    @GetMapping("/{id}")
    public ResponseEntity<CommentDTO> comment(@PathVariable Long id) {
        // id로 댓글 조회
        return null;
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        // id로 조회한 댓글 삭제
        return;
    }

    @PatchMapping("/{id}")
    public Long update(@PathVariable Long id, @ModelAttribute CommentUpdateDTO commentUpdateDTO) {
        // id로 댓글 조회 후 업데이트
        return null;
    }

    @GetMapping("/{id}/like")
    public void like(@PathVariable Long id) {
        // 댓글 좋아요
        return;
    }
}
