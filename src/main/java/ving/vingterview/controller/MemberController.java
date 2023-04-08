package ving.vingterview.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.domain.member.Member;
import ving.vingterview.dto.board.BoardVideoDTO;
import ving.vingterview.dto.member.*;
import ving.vingterview.service.member.MemberService;

import java.util.Optional;


@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @GetMapping("")
    public ResponseEntity<MemberListDTO> list() {
        return ResponseEntity.ok(memberService.findAll());
    }

    @PostMapping("")
    public Long create(@RequestBody MemberCreateDTO memberCreateDTO){

        Long memberId = memberService.join(memberCreateDTO);

        return memberId; // Member Id 반환
    }

    @PostMapping("/image")
    public String profileUpload(@ModelAttribute MemberProfileImageDTO memberProfileImageDTO) {
        return memberService.profileUpload(memberProfileImageDTO);
    }

/*    @PostMapping("/{id}/image")
    public String profileUploadByMember(@PathVariable(name = "id") Long id,@ModelAttribute MemberProfileImageDTO memberProfileImageDTO) {
        return memberService.profileUpload(memberProfileImageDTO);
    }*/


    @GetMapping("/{id}")
    public ResponseEntity<MemberDTO> member(@PathVariable(name = "id") Long id) {

        MemberDTO memberDTO = memberService.findById(id);
        return ResponseEntity.ok(memberDTO);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable(name = "id") Long id) {
        memberService.delete(id);
    }

    @PutMapping("/{id}")
    public Long update(@PathVariable(name = "id") Long id,
                       @RequestBody MemberUpdateDTO memberUpdateDTO) {

        Long memberId = memberService.update(id, memberUpdateDTO);
        return memberId;
    }


}
