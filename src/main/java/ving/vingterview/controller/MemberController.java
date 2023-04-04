package ving.vingterview.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.member.*;
import ving.vingterview.service.file.FileStore;
import ving.vingterview.service.member.MemberService;

import java.io.IOException;

@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @GetMapping("")
    public ResponseEntity<MemberListDTO> list() {

        return null;
    }

    @PostMapping("")
    public Long create(@ModelAttribute MemberCreateDTO memberCreateDTO,
                       @ModelAttribute MemberProfileImageDTO memberProfileImageDTO){

        memberService.join(memberCreateDTO,memberProfileImageDTO);

        return null; // Member Id 반환
    }


    @GetMapping("/{id}")
    public ResponseEntity<MemberDTO> member(@PathVariable(name = "id") Long id) {
        return null;
    }

    @DeleteMapping("/{id}")
    public Long delete(@PathVariable(name = "id") Long id) {
        return null;
    }

    @PutMapping("/{id}")
    public Long update(@PathVariable(name = "id") Long id,
                       @ModelAttribute MemberUpdateDTO memberUpdateDTO,
                       @ModelAttribute MemberProfileImageDTO memberProfileImageDTO) {
        return null;
    }


}
