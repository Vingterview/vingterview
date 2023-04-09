package ving.vingterview.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ving.vingterview.dto.tag.TagDTO;
import ving.vingterview.dto.tag.TagListDTO;
import ving.vingterview.service.tag.TagService;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/tags")
@RequiredArgsConstructor
public class TagController {

    private final TagService tagService;

    @GetMapping("")
    public ResponseEntity<TagListDTO> list(@RequestParam(name = "parent_tag_id", required = false) Long parentTagId) {

        TagListDTO tags = new TagListDTO();

        if (parentTagId == null) {
            tags.setTags(tagService.findAll());
        } else {
            tags.setTags(tagService.findByParentTag(parentTagId));
        }

        return new ResponseEntity<>(tags, HttpStatus.OK);
    }
}
