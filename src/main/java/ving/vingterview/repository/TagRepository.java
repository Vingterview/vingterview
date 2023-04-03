package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.tag.Tag;

public interface TagRepository extends JpaRepository<Tag,Long> {
}
