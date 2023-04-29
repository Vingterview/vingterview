package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.annotation.LoginMemberId;
import ving.vingterview.dto.question.QuestionCreateDTO;
import ving.vingterview.dto.question.QuestionListDTO;
import ving.vingterview.dto.question.QuestionResponseDTO;
import ving.vingterview.service.question.QuestionService;

import java.util.List;

@RestController
@RequestMapping(value = "/questions", produces = "application/json;charset=utf8")
@RequiredArgsConstructor
@Slf4j
public class QuestionController {

    private final QuestionService questionService;


    @GetMapping("")
    public ResponseEntity<QuestionListDTO> list() {
        return ResponseEntity.ok(new QuestionListDTO(questionService.findAll()));
    }

    @GetMapping(params = "tag_id")
    public ResponseEntity<QuestionListDTO> findByTag(@RequestParam(name = "tag_id") List<Long> tagId) {
        return ResponseEntity.ok(new QuestionListDTO(questionService.findByTags(tagId)));
    }


    @GetMapping(params = "member_id")
    public ResponseEntity<QuestionListDTO> findByMember(@RequestParam(name = "member_id") Long memberId) {
        return ResponseEntity.ok(new QuestionListDTO(questionService.findByMember(memberId)));
    }

    @GetMapping(params = "scrap_member_id")
    public ResponseEntity<QuestionListDTO> findScraps(@RequestParam(name = "scrap_member_id") Long scrapMemberId) {
        return ResponseEntity.ok(new QuestionListDTO(questionService.findByScrap(scrapMemberId)));
    }

    @PostMapping("")
    public ResponseEntity<QuestionResponseDTO> create(@RequestBody QuestionCreateDTO questionCreateDTO,
                                                      @LoginMemberId Long memberId) {
        return new ResponseEntity<>(new QuestionResponseDTO(questionService.create(memberId, questionCreateDTO)), HttpStatus.CREATED);
    }

    @GetMapping("/{id}/scrap")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void scrap(@PathVariable Long id, @LoginMemberId Long memberId) {
        questionService.scrap(memberId, id);
    }
}
