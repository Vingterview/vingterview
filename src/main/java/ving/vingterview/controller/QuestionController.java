package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.question.QuestionCreateDTO;
import ving.vingterview.dto.question.QuestionDTO;
import ving.vingterview.dto.question.QuestionListDTO;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/questions")
@RequiredArgsConstructor
@Slf4j
public class QuestionController {

    @GetMapping("")
    public ResponseEntity<QuestionListDTO> list(@RequestParam(name = "tag_id", required = false) List<Long> tagId,
                                                @RequestParam(name = "member_id", required = false) Long memberId,
                                                @RequestParam(name = "scrap_member_id", required = false) Long scrapMemberId) {
        log.info("tagId={}", tagId);
        // 질문 목록 조회
        return null;
    }

    @PostMapping("")
    public Long create(@ModelAttribute QuestionCreateDTO questionCreateDTO) {
        // 질문 생성
        return null; // 질문 id 반환
    }

    @GetMapping("/{id}/scrap")
    public void scrap(@PathVariable Long id) {
        // 질문 스크랩
        return;
    }
}
