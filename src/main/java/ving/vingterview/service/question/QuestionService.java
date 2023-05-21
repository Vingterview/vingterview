package ving.vingterview.service.question;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;
import ving.vingterview.domain.question.QuestionMemberScrap;
import ving.vingterview.domain.tag.Tag;
import ving.vingterview.domain.tag.TagQuestion;
import ving.vingterview.dto.question.QuestionCreateDTO;
import ving.vingterview.dto.question.QuestionDTO;
import ving.vingterview.dto.question.QuestionListDTO;
import ving.vingterview.dto.tag.TagDTO;
import ving.vingterview.repository.*;

import java.util.List;
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
     * @param memberId
     * @param questionCreateDTO
     * @return
     */
    public Long create(Long memberId, QuestionCreateDTO questionCreateDTO) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new EntityNotFoundException("회원 정보 없음"));

        Question question = questionRepository.save(
                Question.builder()
                        .member(member)
                        .content(questionCreateDTO.getQuestionContent())
                        .build());

        questionCreateDTO.getTags().stream()
                .forEach(tagId -> {
                    Tag tag = tagRepository.findById(tagId)
                            .orElseThrow(() -> new EntityNotFoundException("태그 없음"));
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
    @Transactional(readOnly = true)
    public QuestionDTO findOne(Long id) {
        Question question = questionRepository.findById(id).orElseThrow(() -> new EntityNotFoundException("해당 질문을 찾을 수 없습니다."));
        return convertToQuestionDTO(question);
    }

    /**
     * 전체 질문 목록 조회
     * @return
     */
    @Transactional(readOnly = true)
    public QuestionListDTO findAll(int page,int size,boolean desc) {
        PageRequest pageRequest;
        if(desc){
            pageRequest = PageRequest.of(page, size, Sort.by("createTime").descending());
        }else{
            pageRequest = PageRequest.of(page, size, Sort.by("createTime").ascending());

        }
        Slice<Question> questions = questionRepository.findSliceBy(pageRequest);

        List<QuestionDTO> result = questions.stream()
                .map(this::convertToQuestionDTO)
                .toList();

        return new QuestionListDTO(result, page + 1, questions.hasNext());
    }

    /**
     * 작성자로 질문 조회
     * @param memberId
     * @return
     */
    @Transactional(readOnly = true)
    public QuestionListDTO findByMember(Long memberId,int page,int size) {
        PageRequest pageRequest = PageRequest.of(page, size, Sort.by("createTime").descending());
        Slice<Question> questions = questionRepository.findAllByMemberId(memberId,pageRequest);

        List<QuestionDTO> result = questions.stream()
                .map(this::convertToQuestionDTO)
                .toList();

        return new QuestionListDTO(result, page + 1, questions.hasNext());
    }


    /**
     * 태그로 질문 조회
     * @param tagId
     * @return
     */
    @Transactional(readOnly = true)
    public QuestionListDTO findByTags(List<Long> tagId,int page,int size) {
        PageRequest pageRequest = PageRequest.of(page, size);
        Slice<TagQuestion> questions = tagQuestionRepository.findAllQuestionByTagId(tagId,pageRequest);

        List<QuestionDTO> result = questions.stream()
                .map(TagQuestion::getQuestion)
                .map(this::convertToQuestionDTO)
                .toList();

        return new QuestionListDTO(result, page + 1, questions.hasNext());
    }

    /**
     * 스크랩한 질문 조회
     * @param scrapMemberId
     * @return
     */
    @Transactional(readOnly = true)
    public QuestionListDTO findByScrap(Long scrapMemberId,int page, int size) {
        PageRequest pageRequest = PageRequest.of(page, size);
        Slice<QuestionMemberScrap> questions = scrapRepository.findAllQuestionByMemberId(scrapMemberId,pageRequest);
        List<QuestionDTO> result = questions.stream()
                .map(QuestionMemberScrap::getQuestion)
                .map(this::convertToQuestionDTO)
                .toList();

        return new QuestionListDTO(result, page + 1, questions.hasNext());
    }

    /**
     * 스크랩 개수 많은 순으로 조회
     * @param page
     * @param size
     * @return
     */
    public QuestionListDTO orderByScrap(int page,int size) {
        PageRequest pageRequest = PageRequest.of(page, size);
        Slice<Question> questions = questionRepository.orderByScrap(pageRequest);
        List<QuestionDTO> result = questions.stream()
                .map(this::convertToQuestionDTO)
                .toList();

        return new QuestionListDTO(result, page + 1, questions.hasNext());
    }

    public QuestionListDTO orderByVideo(int page,int size) {
        PageRequest pageRequest = PageRequest.of(page, size);
        Slice<Question> questions = questionRepository.orderByVideo(pageRequest);
        List<QuestionDTO> result = questions.stream()
                .map(this::convertToQuestionDTO)
                .toList();

        return new QuestionListDTO(result, page + 1, questions.hasNext());
    }


    /**
     * 질문 스크랩
     * @param memberId
     * @param questionId
     */
    public void scrap(Long memberId, Long questionId) {
        Optional<QuestionMemberScrap> scrap = scrapRepository.findByQuestionIdAndMemberId(questionId, memberId);

        if (scrap.isEmpty()) {
            Question question = questionRepository.findById(questionId).orElseThrow(() -> new EntityNotFoundException("질문 없음"));
            Member member = memberRepository.findById(memberId).orElseThrow(() -> new EntityNotFoundException("회원 정보 없음"));
            QuestionMemberScrap questionMemberScrap = new QuestionMemberScrap(question, member);
            questionMemberScrap.setQuestion(question);
            scrapRepository.save(questionMemberScrap);
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
                .createTime(question.getCreateTime())
                .build();
    }



}
