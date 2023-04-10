package ving.vingterview.service.question;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;
import ving.vingterview.domain.question.QuestionMemberScrap;
import ving.vingterview.domain.tag.Tag;
import ving.vingterview.domain.tag.TagQuestion;
import ving.vingterview.dto.question.QuestionCreateDTO;
import ving.vingterview.dto.question.QuestionDTO;
import ving.vingterview.dto.tag.TagDTO;
import ving.vingterview.repository.*;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class QuestionService {

    private final QuestionRepository questionRepository;
    private final BoardRepository boardRepository;
    private final MemberRepository memberRepository;
    private final QuestionMemberScrapRepository scrapRepository;

    private final TagRepository tagRepository;
    private final TagQuestionRepository tagQuestionRepository;

    /**
     * 질문 생성
     * @param questionCreateDTO
     * @return
     */
    public Long create(QuestionCreateDTO questionCreateDTO) {
        Member member = memberRepository.findById(questionCreateDTO.getMemberId())
                .orElseThrow(() -> new NoSuchElementException("회원 정보 없음"));

        Question question = questionRepository.save(
                Question.builder()
                        .member(member)
                        .content(questionCreateDTO.getQuestionContent())
                        .build());

        questionCreateDTO.getTags().stream()
                .forEach(tagId -> {
                    Tag tag = tagRepository.findById(tagId)
                            .orElseThrow(() -> new NoSuchElementException("태그 없음"));
                    TagQuestion tagQuestion = TagQuestion.builder()
                            .question(question)
                            .tag(tag)
                            .build();
                    tagQuestion.setQuestion(question);
                    tagQuestionRepository.save(tagQuestion);
                });

        return question.getId();
    }

    /**
     * 질문 id로 조회
     * @param id
     * @return
     */
    public QuestionDTO findOne(Long id) {
        Question question = questionRepository.findById(id).orElseThrow(() -> new NoSuchElementException());
        return convertToQuestionDTO(question);
    }

    /**
     * 전체 질문 목록 조회
     * @return
     */
    public List<QuestionDTO> findAll() {
        List<Question> questions = questionRepository.findAll();

        return questions.stream()
                .map(this::convertToQuestionDTO)
                .toList();
    }

    /**
     * 작성자로 질문 조회
     * @param memberId
     * @return
     */
    public List<QuestionDTO> findByMember(Long memberId) {
        List<Question> questions = questionRepository.findAllByMemberId(memberId);
        return questions.stream()
                .map(this::convertToQuestionDTO)
                .toList();
    }


    /**
     * 태그로 질문 조회
     * @param tagId
     * @return
     */
    public List<QuestionDTO> findByTags(List<Long> tagId) {
        List<TagQuestion> result = tagQuestionRepository.findAllQuestionByTagId(tagId);
        return result.stream()
                .map(TagQuestion::getQuestion)
                .map(this::convertToQuestionDTO)
                .toList();
    }

    /**
     * 스크랩한 질문 조회
     * @param scrapMemberId
     * @return
     */
    public List<QuestionDTO> findByScrap(Long scrapMemberId) {
        List<QuestionMemberScrap> result = scrapRepository.findAllQuestionByMemberId(scrapMemberId);
        return result.stream()
                .map(QuestionMemberScrap::getQuestion)
                .map(this::convertToQuestionDTO)
                .toList();
    }

    /**
     * 질문 스크랩
     * @param id
     */
    public void scrap(Long id) {
        Long member_id = 1L;
        Optional<QuestionMemberScrap> scrap = scrapRepository.findByQuestionIdAndMemberId(id, member_id);

        if (scrap.isEmpty()) {
            Question question = questionRepository.findById(id).orElseThrow(() -> new NoSuchElementException("질문 없음"));
            Member member = memberRepository.findById(member_id).orElseThrow(() -> new NoSuchElementException("회원 정보 없음"));
            scrapRepository.save(new QuestionMemberScrap(question, member));
        } else {
            scrapRepository.delete(scrap.get());
        }
    }

    // 유틸리티 메소드
    /**
     * DTO로 변환
     * @param question
     * @return
     */
    private QuestionDTO convertToQuestionDTO(Question question) {

        List<TagDTO> tagDTOList = question.getTags().stream()
                .map(tagQuestion -> {
                    Tag tag = tagQuestion.getTag();
                    return new TagDTO(tag.getId(), tag.getName());
                })
                .toList();

        // 건당 count 쿼리가 나감 <- 개선 필요
        return QuestionDTO.builder()
                .questionId(question.getId())
                .questionContent(question.getContent())
                .tags(tagDTOList)
                .boardCount(boardRepository.countByQuestion(question))
                .scrapCount(scrapRepository.countByQuestion(question))
                .build();
    }

}
