package ving.vingterview.service;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ving.vingterview.domain.member.Member;
import ving.vingterview.dto.member.MemberCreateDTO;
import ving.vingterview.dto.member.MemberProfileImageDTO;
import ving.vingterview.service.member.MemberService;

import java.io.IOException;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Transactional
@Rollback(value = false)
class MemberServiceTest {
    @Autowired
    MemberService memberService;


    @Test
    public void joinSuccess() throws Exception{

        //given
        MemberCreateDTO memberA = new MemberCreateDTO();
        memberA.setLoginId("idA");

        MemberProfileImageDTO memberProfileImageDTO = new MemberProfileImageDTO();
        memberProfileImageDTO.setProfileImage(new MockMultipartFile("file", "filename-1.jpeg", "image/jpeg", "some-image".getBytes()));
        Long memberId = memberService.join(memberA, memberProfileImageDTO);
        //when
        Member findMember = memberService.findById(memberId).get();

        //then
        assertThat(findMember.getName()).isEqualTo(memberA.getName());

    }
    @Test
    @Transactional(propagation = Propagation.NEVER)
    void joinException() throws IOException {

        //given
        MemberCreateDTO memberA = new MemberCreateDTO();
        memberA.setLoginId("idA");

        MemberCreateDTO memberB = new MemberCreateDTO();
        memberB.setLoginId("idA");

        MemberProfileImageDTO memberProfileImageDTO = new MemberProfileImageDTO();
        memberProfileImageDTO.setProfileImage(new MockMultipartFile("file", "filename-1.jpeg", "image/jpeg", "some-image".getBytes()));
        //when
        memberService.join(memberA, memberProfileImageDTO);

        //then
        Assertions.assertThrows(RuntimeException.class, () -> memberService.join(memberB, memberProfileImageDTO));
//        memberService.join(memberB, memberProfileImageDTO);
    }

    @Test
    public void delete() throws IOException {
        //given
        MemberCreateDTO memberA = new MemberCreateDTO();
        memberA.setName("nameA");
        MemberProfileImageDTO memberProfileImageDTO = new MemberProfileImageDTO();
        memberProfileImageDTO.setProfileImage(new MockMultipartFile("file", "filename-1.jpeg", "image/jpeg", "some-image".getBytes()));

        Long memberId = memberService.join(memberA, memberProfileImageDTO);

        System.out.println("memberId = " + memberId);
        //when
        memberService.delete(memberId);
        Optional<Member> findMember = memberService.findById(memberId);

        //then
        assertThat(findMember).isEmpty();



    }
}