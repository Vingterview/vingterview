package ving.vingterview.service.tag;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.tag.Tag;
import ving.vingterview.domain.tag.TagType;
import ving.vingterview.dto.tag.TagDTO;
import ving.vingterview.repository.TagRepository;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class TagService {

    private final TagRepository tagRepository;

    /**
     * 대분류 태그 전체 조회
     * @return
     */
    public List<TagDTO> findAll() {
        List<Tag> tags = tagRepository.findAllByCategoryIn(TagType.CLASSIFICATION, TagType.INTERVIEW);
        List<Tag> results = tags.stream().filter(tag -> tag.getParent() == null).toList();
        return convertToTagDTOList(results);
    }

    /**
     * 상위 태그로 조회
     * @param parentTagId
     * @return
     */
    public List<TagDTO> findByParentTag(Long parentTagId) {
        List<Tag> tags = tagRepository.findAllByParentId(parentTagId);
        return convertToTagDTOList(tags);
    }

    // 유틸리티 메소드

    /**
     * DTO로 변환
     * @param tags
     * @return
     */
    private static List<TagDTO> convertToTagDTOList(List<Tag> tags) {
        List<TagDTO> result = tags.stream()
                .map(tag -> new TagDTO(tag.getId(), tag.getName()))
                .toList();
        return result;
    }
}
