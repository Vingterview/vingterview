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

        return null;
    }

    @PostMapping("")
    public Long create(@ModelAttribute MemberCreateDTO memberCreateDTO,
                       @ModelAttribute MemberProfileImageDTO memberProfileImageDTO){

        Long memberId = memberService.join(memberCreateDTO, memberProfileImageDTO);

        return memberId; // Member Id 반환
    }


    @GetMapping("/{id}")
    public ResponseEntity<MemberDTO> member(@PathVariable(name = "id") Long id) {
        return null;
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable(name = "id") Long id) {
        memberService.delete(id);
    }

    @PutMapping("/{id}")
    public Long update(@PathVariable(name = "id") Long id,
                       @ModelAttribute MemberUpdateDTO memberUpdateDTO,
                       @ModelAttribute MemberProfileImageDTO memberProfileImageDTO) {

        Long memberId = memberService.update(id, memberUpdateDTO, memberProfileImageDTO);
        return memberId;
    }


}
