package ving.vingterview.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.member.*;
import ving.vingterview.service.member.MemberService;


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
    public ResponseEntity<MemberResponseDTO> create(@RequestBody MemberCreateDTO memberCreateDTO){

        Long memberId = memberService.join(memberCreateDTO);

        MemberResponseDTO memberResponseDTO = new MemberResponseDTO();
        memberResponseDTO.setMemberId(memberId);

        return ResponseEntity.ok(memberResponseDTO);
    }

    @PostMapping("/image")
    public ResponseEntity<ProfileImageResponseDTO> profileUpload(@ModelAttribute ProfileImageDTO profileImageDTO) {
        String profileImageUrl = memberService.profileUpload(profileImageDTO);

        ProfileImageResponseDTO profileImageResponseDTO = new ProfileImageResponseDTO();
        profileImageResponseDTO.setProfileImageUrl(profileImageUrl);
        return ResponseEntity.ok(profileImageResponseDTO);
    }


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
    public ResponseEntity<MemberResponseDTO> update(@PathVariable(name = "id") Long id,
                       @RequestBody MemberUpdateDTO memberUpdateDTO) {

        Long memberId = memberService.update(id, memberUpdateDTO);

        MemberResponseDTO memberResponseDTO = new MemberResponseDTO();
        memberResponseDTO.setMemberId(memberId);

        return ResponseEntity.ok(memberResponseDTO);

    }


}
