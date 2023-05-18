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

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping(value = "/questions", produces = "application/json;charset=utf8")
@RequiredArgsConstructor
@Slf4j
public class QuestionController {

    private final QuestionService questionService;


    @GetMapping("")
    public ResponseEntity<QuestionListDTO> list(@RequestParam(name="page",defaultValue ="0")int page,
                                                @RequestParam(name="size", defaultValue="20")int size) {
        return ResponseEntity.ok(questionService.findAll(page, size, true));
    }

    @GetMapping(params = "tag_id")
    public ResponseEntity<QuestionListDTO> findByTag(@RequestParam(name = "tag_id") List<Long> tagId,
                                                     @RequestParam(name="page",defaultValue ="0")int page,
                                                     @RequestParam(name="size", defaultValue="20")int size) {
        return ResponseEntity.ok(questionService.findByTags(tagId,page,size));
    }


    @GetMapping(params = "member_id")
    public ResponseEntity<QuestionListDTO> findByMember(@RequestParam(name = "member_id") Long memberId,
                                                        @RequestParam(name="page",defaultValue ="0")int page,
                                                        @RequestParam(name="size", defaultValue="20")int size) {
        return ResponseEntity.ok(questionService.findByMember(memberId,page,size));
    }

    @GetMapping(params = "scrap_member_id")
    public ResponseEntity<QuestionListDTO> findScraps(@RequestParam(name = "scrap_member_id") Long scrapMemberId,
                                                      @RequestParam(name="page",defaultValue ="0")int page,
                                                      @RequestParam(name="size", defaultValue="20")int size) {
        return ResponseEntity.ok(questionService.findByScrap(scrapMemberId,page,size));
    }

    @GetMapping(params = "order_by")
    public ResponseEntity<QuestionListDTO> orderBy(@RequestParam(name = "order_by") String order_by,
                                                   @RequestParam(name="page",defaultValue ="0")int page,
                                                   @RequestParam(name="size", defaultValue="20")int size) {

        if (order_by.equals("scrap")) {
            return ResponseEntity.ok().body(questionService.orderByScrap(page,size));
        } else if (order_by.equals("video")) {
            return ResponseEntity.ok().body(questionService.orderByVideo(page,size));
        } else if (order_by.equals("old")) {
            return ResponseEntity.ok(questionService.findAll(page, size, false));
        }


        QuestionListDTO questionListDTO = new QuestionListDTO(new ArrayList<>(),0,false);
        return ResponseEntity.badRequest()
                .body(questionListDTO);
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
