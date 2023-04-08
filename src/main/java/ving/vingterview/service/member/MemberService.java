package ving.vingterview.service.member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.file.UploadFile;
import ving.vingterview.domain.member.Member;
import ving.vingterview.dto.member.*;
import ving.vingterview.repository.MemberRepository;
import ving.vingterview.service.file.FileStore;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberService {
    private final MemberRepository memberRepository;

    @Qualifier("imgStore")
    private final FileStore imgStore;


    /**
     * 회원 가입
     */
    @Transactional
    public Long join(MemberCreateDTO memberCreateDTO) {

        validateDuplicateMember(memberCreateDTO.getLoginId());
        Member member = Member.builder()
                .name(memberCreateDTO.getName())
                .loginId(memberCreateDTO.getLoginId())
                .password(memberCreateDTO.getPassword())
                .age(memberCreateDTO.getAge())
                .email(memberCreateDTO.getEmail())
                .nickname(memberCreateDTO.getNickname())
                .profileImageUrl(memberCreateDTO.getProfileImageUrl())
                .build();

        memberRepository.save(member);
        return member.getId();
    }

    /**
     * 회원 가입 아이디 중복 검사
     */
    private void validateDuplicateMember(String loginId) {
        memberRepository.findByLoginId(loginId)
                .ifPresent(m -> {
                    throw new RuntimeException("이미 존재하는 회원입니다.");
                });
    }


    /**
     * 멤버 id로 조회
     */
    public MemberDTO findById(Long id) {
        Member member = memberRepository.findById(id).orElseThrow(() -> new RuntimeException("해당 멤버를 찾을 수 없습니다."));

        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setId(member.getId());
        memberDTO.setPassword(member.getPassword());
        memberDTO.setLoginId(member.getLoginId());
        memberDTO.setName(member.getName());
        memberDTO.setAge(member.getAge());
        memberDTO.setEmail(member.getEmail());
        memberDTO.setNickname(member.getNickname());
        memberDTO.setProfileImageUrl(member.getProfileImageUrl());


        return memberDTO;
    }

    /**
     * 멤버 전체 조회
     */
    public MemberListDTO findAll() {
        List<Member> members = memberRepository.findAll();
        MemberListDTO memberListDTO = new MemberListDTO();
        memberListDTO.setMembers(members.stream().map(m -> new MemberDTO()).toList());
        return memberListDTO;
    }


    /**
     * 멤버 삭제
     */
    public void delete(Long id) {
        memberRepository.deleteById(id);
    }

    @Transactional
    public Long update(Long id, MemberUpdateDTO memberUpdateDTO) {

        Optional<Member> findMember = memberRepository.findById(id);
        Member member = findMember.orElseThrow(() -> new RuntimeException("찾을 수 없는 회원입니다."));

        imgStore.deleteFile(member.getProfileImageUrl());

        member.update(memberUpdateDTO.getName(), memberUpdateDTO.getAge(), memberUpdateDTO.getEmail(),
                memberUpdateDTO.getNickname(),
                memberUpdateDTO.getProfileImageUrl());

        return member.getId();


    }

    public String profileUpload(MemberProfileImageDTO memberProfileImageDTO) {

//        Optional<UploadFile> uploadFile = Optional.ofNullable(imgStore.storeFile(memberProfileImageDTO.getProfileImage()));
//        return uploadFile.orElse(new UploadFile(null, null)).getStoreFileName();
        return null;
    }
}
