package ving.vingterview.service.tag;

import jakarta.persistence.EntityManager;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.tag.Tag;
import ving.vingterview.domain.tag.TagType;
import ving.vingterview.dto.tag.TagDTO;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.*;

@SpringBootTest
@Transactional
class TagServiceTest {

    @Autowired
    TagService tagService;
    @Autowired
    EntityManager em;

    List<Tag> tagList = new ArrayList<>();

    @BeforeEach
    void init() {
        Tag testTag1 = new Tag(null, "testTag1", TagType.CLASSIFICATION);
        Tag testTag2 = new Tag(null, "testTag2", TagType.INTERVIEW);
        Tag testTag3 = new Tag(testTag1, "testTag3", TagType.ENTERPRISE);
        em.persist(testTag1);
        em.persist(testTag2);
        em.persist(testTag3);
        tagList.addAll(Arrays.asList(testTag1, testTag2, testTag3));
    }

    @AfterEach
    void clear() {
        tagList.clear();
    }

    // tag type이 CLASSIFICATION이거나 INTERVIEW인 태그만 조회
    @Test
    void findAll() {
        Tag testTag1 = tagList.get(0);
        Tag testTag2 = tagList.get(1);
        Tag testTag3 = tagList.get(2);

        List<TagDTO> tags = tagService.findAll();

        assertThat(tags).extracting("tagId").contains(testTag1.getId(), testTag2.getId());
        assertThat(tags).extracting("tagName").contains(testTag1.getName(), testTag2.getName());

        assertThat(tags).extracting("tagId").doesNotContain(testTag3.getId());
        assertThat(tags).extracting("tagName").doesNotContain(testTag3.getName());
    }

    // 상위 태그로 검색한 경우
    @Test
    void findByParentTag() {
        Tag testTag1 = tagList.get(0);
        Tag testTag2 = tagList.get(1);
        Tag testTag3 = tagList.get(2);

        List<TagDTO> tags = tagService.findByParentTag(testTag1.getId());

        assertThat(tags).extracting("tagId").doesNotContain(testTag1.getId(), testTag2.getId());
        assertThat(tags).extracting("tagName").doesNotContain(testTag1.getName(), testTag2.getName());

        assertThat(tags).extracting("tagId").containsExactly(testTag3.getId());
        assertThat(tags).extracting("tagName").containsExactly(testTag3.getName());
    }

    // 조회하는 상위 태그의 id가 없는 경우
    @Test
    void findByWrongParentTag() {
        Tag testTag1 = tagList.get(0);

        List<TagDTO> tags = tagService.findByParentTag(testTag1.getId() + 100L);
        assertThat(tags.size()).isEqualTo(0);
    }


    // 하위 태그가 없는 경우
    @Test
    void findByParentTagWithNoChild() {
        Tag testTag3 = tagList.get(2);

        List<TagDTO> tags = tagService.findByParentTag(testTag3.getId());
        assertThat(tags.size()).isEqualTo(0);
    }
}