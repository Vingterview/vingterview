package ving.vingterview.service.question;

import jakarta.persistence.EntityManager;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;
import ving.vingterview.dto.question.QuestionCreateDTO;
import ving.vingterview.dto.question.QuestionDTO;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
class QuestionServiceTest {

    @Autowired
    QuestionService questionService;
    @Autowired
    EntityManager em;

    @BeforeEach
    void init() {

    }

    // 질문 생성
    @Test
    void create() {
        List<Long> tags = new ArrayList<>();
        tags.add(1L);
        tags.add(5L);
        tags.add(8L);
        tags.add(12L);

        QuestionCreateDTO dto = new QuestionCreateDTO();
        dto.setMemberId(1L);
        dto.setQuestionContent("testQuestion1");
        dto.setTags(tags);

        Long questionId = questionService.create(dto);

        QuestionDTO foundDTO = questionService.findOne(questionId);

        assertThat(foundDTO.getQuestionId()).isEqualTo(questionId);
        assertThat(foundDTO.getQuestionContent()).isEqualTo(dto.getQuestionContent());
        assertThat(foundDTO.getTags()).extracting("tagId").isEqualTo(dto.getTags());
    }

    // 회원이 없는 경우
    @Test
    void createWithWrongMemberId() {
        List<Long> tags = new ArrayList<>();
        tags.add(1L);
        tags.add(5L);
        tags.add(8L);

        QuestionCreateDTO dto = new QuestionCreateDTO();
        dto.setMemberId(100L);
        dto.setQuestionContent("testQuestion1");
        dto.setTags(tags);

        assertThatThrownBy(() -> questionService.create(dto)).isInstanceOf(NoSuchElementException.class);
    }

    // 태그가 없는 경우
    @Test
    void createWithWrongTagId() {
        List<Long> tags = new ArrayList<>();
        tags.add(100L);

        QuestionCreateDTO dto = new QuestionCreateDTO();
        dto.setMemberId(1L);
        dto.setQuestionContent("testQuestion1");
        dto.setTags(tags);

        assertThatThrownBy(() -> questionService.create(dto)).isInstanceOf(NoSuchElementException.class);
    }

    @Test
    void findNothing() {
        assertThatThrownBy(() -> questionService.findOne(100L)).isInstanceOf(NoSuchElementException.class);
    }

    @Test
    void findAll() {


    }

    @Test
    void findByMember() {
    }

    @Test
    void findByTags() {
    }

    @Test
    void findByScrap() {
    }

    @Test
    void scrap() {
    }
}