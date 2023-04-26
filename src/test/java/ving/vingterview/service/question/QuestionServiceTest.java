package ving.vingterview.service.question;

import jakarta.persistence.EntityManager;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;
import ving.vingterview.domain.question.QuestionMemberScrap;
import ving.vingterview.domain.tag.Tag;
import ving.vingterview.domain.tag.TagQuestion;
import ving.vingterview.dto.question.QuestionCreateDTO;
import ving.vingterview.dto.question.QuestionDTO;
import ving.vingterview.dto.tag.TagDTO;
import ving.vingterview.repository.QuestionMemberScrapRepository;

import java.util.ArrayList;
import java.util.Arrays;
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

    List<Member> members = new ArrayList<>();
    List<Question> questions = new ArrayList<>();
    List<Tag> tags = new ArrayList<>();

    List<QuestionMemberScrap> scraps = new ArrayList<>();

    @BeforeEach
    void init() {

        for (int i = 0; i < 3; i++) {
            Member member = Member.builder()
                    .name("testMember" + i)
                    .build();
            em.persist(member);
            members.add(member);
        }

        for (int i = 0; i < 10; i++) {
            Question question = Question.builder()
                    .content("testQuestion" + i)
                    .member(members.get(i % 3))
                    .build();
            em.persist(question);
            questions.add(question);
        }

        for (int i = 0; i < 5; i++) {
            Tag tag = Tag.builder()
                    .name("testTag" + i)
                    .build();
            em.persist(tag);
            tags.add(tag);
        }

        for (int i = 0; i < 10; i++) {
            Question question = questions.get(i);
            TagQuestion tagQuestion = TagQuestion.builder().question(question).tag(tags.get(i % 5)).build();
            tagQuestion.setQuestion(question);
            em.persist(tagQuestion);
        }

        for (int i = 0; i < 5; i++) {
            Question question = questions.get(i);
            QuestionMemberScrap scrap = QuestionMemberScrap.builder().question(question).member(members.get(i % 3)).build();
            scrap.setQuestion(question);
            scraps.add(scrap);
            em.persist(scrap);
        }
    }

    @AfterEach
    void clear() {
        members.clear();
        questions.clear();
        tags.clear();
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
        dto.setQuestionContent("testQuestion1");
        dto.setTags(tags);

        Long questionId = questionService.create(1L, dto);

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
        dto.setQuestionContent("testQuestion1");
        dto.setTags(tags);

        assertThatThrownBy(() -> questionService.create(100L, dto)).isInstanceOf(NoSuchElementException.class);
    }

    // 태그가 없는 경우
    @Test
    void createWithWrongTagId() {
        List<Long> tags = new ArrayList<>();
        tags.add(100L);

        QuestionCreateDTO dto = new QuestionCreateDTO();
        dto.setQuestionContent("testQuestion1");
        dto.setTags(tags);

        assertThatThrownBy(() -> questionService.create(1L, dto)).isInstanceOf(NoSuchElementException.class);
    }

    // 단건 조회 - 결과가 없는 경우
    @Test
    void findNothing() {
        assertThatThrownBy(() -> questionService.findOne(100L)).isInstanceOf(NoSuchElementException.class);
    }

    // 질문 전체 조회
    @Test
    void findAll() {
        List<QuestionDTO> questionDTOList = questionService.findAll();
        List<Long> ids = questionDTOList.stream().map(QuestionDTO::getQuestionId).toList();
        List<String> contents = questionDTOList.stream().map(QuestionDTO::getQuestionContent).toList();

        assertThat(ids).containsAll(questions.stream().map(Question::getId).toList());
        assertThat(contents).containsAll(questions.stream().map(Question::getContent).toList());
    }

    // 작성자로 필터링
    @Test
    void findByMember() {
        Member member = members.get(0);
        List<QuestionDTO> questionDTOList = questionService.findByMember(member.getId());

        List<Long> ids = questionDTOList.stream().map(QuestionDTO::getQuestionId).toList();

        assertThat(ids).containsExactlyInAnyOrderElementsOf(questions.stream()
                .filter(question -> question.getMember().equals(member))
                .map(Question::getId).toList());
    }

    // 없는 회원으로 필터링
    @Test
    void findByWrongMember() {
        List<QuestionDTO> questionDTOList = questionService.findByMember(100L);
        assertThat(questionDTOList.size()).isEqualTo(0);
    }

    // 태그로 필터링
    @Test
    void findByTags() {
        List<Tag> tagList = new ArrayList<>(Arrays.asList(tags.get(0), tags.get(tags.size()-1)));

        List<Long> tagIds = tagList.stream().map(Tag::getId).toList();

        List<QuestionDTO> questionDTOList = questionService.findByTags(tagIds);
        questionDTOList.stream().forEach(questionDTO -> {
            List<Long> ids = questionDTO.getTags().stream().map(TagDTO::getTagId).toList();
            assertThat(ids).containsAnyElementsOf(tagIds);
        });
    }

    // 없는 태그로 필터링
    @Test
    void findByWrongTag() {
        List<Long> tagIds = new ArrayList<>(Arrays.asList(100L));

        List<QuestionDTO> questionDTOList = questionService.findByTags(tagIds);

        assertThat(questionDTOList.size()).isEqualTo(0);
    }

    // 스크랩한 회원으로 필터링
    @Test
    void findByScrap() {
        Member scrapMember = members.get(0);
        List<QuestionDTO> questionDTOList = questionService.findByScrap(scrapMember.getId());
        List<Long> ids = questionDTOList.stream().map(QuestionDTO::getQuestionId).toList();
        assertThat(ids).containsExactlyInAnyOrderElementsOf(
                scraps.stream()
                        .filter(scrap -> scrap.getMember().equals(scrapMember))
                        .map(QuestionMemberScrap::getQuestion)
                        .map(Question::getId)
                        .toList()
        );
    }

    // 없는 회원으로 필터링
    @Test
    void findByWrongScrapMember() {
        List<QuestionDTO> questionDTOList = questionService.findByScrap(100L);
        assertThat(questionDTOList.size()).isEqualTo(0);
    }

    // 스크랩, 스크랩 취소
    @Test
    void scrap() {
        Member member = members.get(0);
        Question question = Question.builder()
                .content("testQuestion")
                .member(member)
                .build();
        em.persist(question);

        questionService.scrap(member.getId(), question.getId());

        QuestionDTO scrap = questionService.findOne(question.getId());
        assertThat(scrap.getScrapCount()).isEqualTo(1);

        em.flush();
        em.clear();

        questionService.scrap(member.getId(), question.getId());
        QuestionDTO unScrap = questionService.findOne(question.getId());
        assertThat(unScrap.getScrapCount()).isEqualTo(0);
    }
}