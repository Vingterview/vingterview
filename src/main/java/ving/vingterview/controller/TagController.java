package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ving.vingterview.dto.tag.TagDTO;

@RestController
@RequestMapping("/tags")
@RequiredArgsConstructor
public class TagController {

    @GetMapping("")
    public ResponseEntity<TagDTO> list(@RequestParam(name = "parent_tag_id", required = false) Long parentTagId) {
        // 태그 조회
        return null;
    }
}
