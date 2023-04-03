package ving.vingterview.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.dto.member.*;

@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
public class MemberController {

    @GetMapping("")
    public ResponseEntity<MemberListDTO> list() {

        return null;
    }

    @PostMapping("")
    public Long create(@ModelAttribute MemberCreateDTO memberCreateDTO,
                       @ModelAttribute MemberProfileImageDTO memberProfileImageDTO) {

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
