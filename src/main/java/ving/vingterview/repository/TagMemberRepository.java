package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.tag.TagMember;

public interface TagMemberRepository extends JpaRepository<TagMember,Long> {
}
