package ving.vingterview.service.member;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.member.Member;
import ving.vingterview.dto.member.MemberCreateDTO;
import ving.vingterview.dto.member.MemberDTO;

import java.util.NoSuchElementException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;


@SpringBootTest
@Transactional
class MemberServiceTest {

    @Autowired
    MemberService memberService;

    @Autowired
    EntityManager em;


    @Test
    void join() {

        MemberCreateDTO memberCreateDTO = new MemberCreateDTO();
        memberCreateDTO.setName("memberA");
        memberCreateDTO.setId("loginId");

        Long memberId = memberService.join(memberCreateDTO);

        Member member = em.find(Member.class, memberId);
        assertThat(memberId).isEqualTo(member.getId());
    }

    @Test
    void joinError() {
        MemberCreateDTO memberCreateDTO = new MemberCreateDTO();
        memberCreateDTO.setName("memberA");
        memberCreateDTO.setId("loginId");
        Long memberId = memberService.join(memberCreateDTO);

        MemberCreateDTO memberCreateDTO2 = new MemberCreateDTO();
        memberCreateDTO2.setName("memberB");
        memberCreateDTO2.setId("loginId");


        Assertions.assertThrows(RuntimeException.class, () -> memberService.join(memberCreateDTO2));


    }



    @Test
    void findById() {
        Member member = Member.builder()
                .name("memberA")
                .loginId("loginId")
                .build();

        em.persist(member);
        em.flush();

        MemberDTO findMember = memberService.findById(member.getId());


        assertThat(findMember.getMemberId()).isEqualTo(member.getId());
        assertThat(findMember.getName()).isEqualTo(member.getName());

    }

    @Test
    void findAll() {

    }

    @Test
    void delete() {
        Member member = Member.builder()
                .name("memberA")
                .loginId("loginId")
                .build();

        em.persist(member);
        em.flush();

        memberService.delete(member.getId());

        Member findMember = em.find(Member.class, member.getId());

        assertThat(findMember).isNull();

    }

}