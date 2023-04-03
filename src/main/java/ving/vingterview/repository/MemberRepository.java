package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.member.Member;

public interface MemberRepository extends JpaRepository<Member,Long> {
}
