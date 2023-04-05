package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.member.Member;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member,Long> {

    Optional<Member> findByName(String name);

    Optional<Member> findByLoginId(String loginId);


}
