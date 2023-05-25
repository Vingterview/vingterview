package ving.vingterview.controller;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ving.vingterview.annotation.Trace;
import ving.vingterview.dto.member.*;
import ving.vingterview.service.file.S3Upload;
import ving.vingterview.service.member.MemberService;

import java.time.LocalDateTime;


@Slf4j
@RestController
@RequestMapping(value = "/members", produces = "application/json;charset=utf8")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final S3Upload fileStore;

    @GetMapping("")
    @Trace
    public ResponseEntity<MemberListDTO> list() {
        return ResponseEntity.ok(memberService.findAll());
    }

    @PostMapping("")
    @Trace
    public ResponseEntity<MemberResponseDTO> create(@RequestBody MemberCreateDTO memberCreateDTO){

        Long memberId = memberService.join(memberCreateDTO);

        MemberResponseDTO memberResponseDTO = new MemberResponseDTO();
        memberResponseDTO.setMemberId(memberId);

        return new ResponseEntity<>(memberResponseDTO, HttpStatus.CREATED);
    }

    @PostMapping("/image")
    @Trace
    public ResponseEntity<ProfileImageResponseDTO> profileUpload(@ModelAttribute ProfileImageDTO profileImageDTO) {
        if (profileImageDTO.getProfileImage() != null && !profileImageDTO.getProfileImage().isEmpty()) {
            String storeFileName = fileStore.createStoreFileName(profileImageDTO.getProfileImage().getOriginalFilename());

            log.info("----------uploadFile----------start {} {}", LocalDateTime.now(), Thread.currentThread().getName());
            fileStore.uploadFile(profileImageDTO.getProfileImage(),storeFileName);
            log.info("----------UploadFile----------returned {} {}", LocalDateTime.now(), Thread.currentThread().getName());

            ProfileImageResponseDTO profileImageResponseDTO = new ProfileImageResponseDTO();
            profileImageResponseDTO.setProfileImageUrl(fileStore.getFullPath(storeFileName,true));

            return new ResponseEntity<>(profileImageResponseDTO, HttpStatus.CREATED);

        }

        ProfileImageResponseDTO profileImageResponseDTO = new ProfileImageResponseDTO();
        profileImageResponseDTO.setProfileImageUrl("잘못된 접근입니다.");
        return ResponseEntity.badRequest()
                .body(profileImageResponseDTO);
    }


    @GetMapping("/{id}")
    @Trace
    public ResponseEntity<MemberDTO> member(@PathVariable(name = "id") Long id) {

        MemberDTO memberDTO = memberService.findById(id);
        return ResponseEntity.ok(memberDTO);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Trace
    public void delete(@PathVariable(name = "id") Long id) {
        memberService.delete(id);
    }

    @PutMapping("/{id}")
    @Trace
    public ResponseEntity<MemberResponseDTO> update(@PathVariable(name = "id") Long id,
                       @RequestBody MemberUpdateDTO memberUpdateDTO) {

        Long memberId = memberService.update(id, memberUpdateDTO);

        MemberResponseDTO memberResponseDTO = new MemberResponseDTO();
        memberResponseDTO.setMemberId(memberId);

        return new ResponseEntity<>(memberResponseDTO, HttpStatus.CREATED);
    }
}
