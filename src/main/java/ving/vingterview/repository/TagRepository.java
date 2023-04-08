package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.tag.Tag;
import ving.vingterview.domain.tag.TagType;

import java.util.List;
import java.util.Optional;

public interface TagRepository extends JpaRepository<Tag,Long> {

    public List<Tag> findAllByCategoryIn(TagType... categories);

    public List<Tag> findAllByParentId(Long parentId);

    public List<Tag> findAllByIdIn(List<Long> tags);
}
