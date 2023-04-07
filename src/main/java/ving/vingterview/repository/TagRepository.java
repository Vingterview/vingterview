package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.tag.Tag;
import ving.vingterview.domain.tag.TagType;

import java.util.List;
import java.util.Optional;

public interface TagRepository extends JpaRepository<Tag,Long> {

    public Optional<List<Tag>> findAllByCategoryIn(TagType... categories);

    public Optional<List<Tag>> findAllByParentId(Long parentId);
}
