package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.question.QuestionCreateDTO;
import ving.vingterview.dto.question.QuestionDTO;
import ving.vingterview.dto.question.QuestionListDTO;
import ving.vingterview.service.question.QuestionService;

import java.util.List;

@RestController
@RequestMapping("/questions")
@RequiredArgsConstructor
@Slf4j
public class QuestionController {

    private final QuestionService questionService;


    @GetMapping("")
    public ResponseEntity<List<QuestionDTO>> list() {
        return ResponseEntity.ok(questionService.findAll());
    }

    @GetMapping(params = "tag_id")
    public ResponseEntity<List<QuestionDTO>> findByTag(@RequestParam(name = "tag_id") List<Long> tagId) {
        return ResponseEntity.ok(questionService.findByTags(tagId));
    }


    @GetMapping(params = "member_id")
    public ResponseEntity<List<QuestionDTO>> findByMember(@RequestParam(name = "member_id") Long memberId) {
        return ResponseEntity.ok(questionService.findByMember(memberId));
    }

    @GetMapping(params = "scrap_member_id")
    public ResponseEntity<List<QuestionDTO>> findScraps(@RequestParam(name = "scrap_member_id") Long scrapMemberId) {
        return ResponseEntity.ok(questionService.findByScrap(scrapMemberId));
    }

    @PostMapping("")
    public Long create(@RequestBody QuestionCreateDTO questionCreateDTO) {
        Long id = questionService.create(questionCreateDTO);
        return id;
    }

    @GetMapping("/{id}/scrap")
    public void scrap(@PathVariable Long id) {
        questionService.scrap(id);
    }
}
