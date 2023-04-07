package ving.vingterview.service.board;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.board.Board;
import ving.vingterview.domain.board.BoardMemberLike;
import ving.vingterview.domain.comment.Comment;
import ving.vingterview.domain.file.UploadFile;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;
import ving.vingterview.dto.board.BoardCreateDTO;
import ving.vingterview.dto.board.BoardDTO;
import ving.vingterview.dto.board.BoardUpdateDTO;
import ving.vingterview.dto.board.BoardVideoDTO;
import ving.vingterview.repository.BoardMemberLikeRepository;
import ving.vingterview.repository.BoardRepository;
import ving.vingterview.repository.MemberRepository;
import ving.vingterview.repository.QuestionRepository;
import ving.vingterview.service.file.FileStore;


import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class BoardService {
    private final BoardRepository boardRepository;
    private final MemberRepository memberRepository;
    private final QuestionRepository questionRepository;

    private final BoardMemberLikeRepository boardMemberLikeRepository;


    @Qualifier("videoStore")
    private final FileStore videoStore;


    @Transactional
    public Long save(BoardCreateDTO boardCreateDTO) {

        Long memberId = boardCreateDTO.getMemberId();
        Member member = memberRepository.findById(memberId).orElseThrow(() -> new RuntimeException("해당 사용자를 찾을 수 없습니다"));

        Long questionId = boardCreateDTO.getQuestionId();
        Question question = questionRepository.findById(questionId).orElseThrow(() -> new RuntimeException("해당 질문을 찾을 수 없습니다."));

        Board board = Board.builder()
                .member(member)
                .content(boardCreateDTO.getContent())
                .question(question)
                .videoUrl(boardCreateDTO.getVideoUrl())
                .build();

        boardRepository.save(board);

        return board.getId();

    }



    public BoardDTO findById(Long id) {

        Board board = boardRepository.findByIdWithMemberQuestion(id).orElseThrow(() -> new RuntimeException("해당 게시글을 찾을 수 없습니다."));
        Question question = board.getQuestion();
        Member member = board.getMember();

        List<Comment> comments = board.getComments();
        List<BoardMemberLike> boardMemberLikes = board.getBoardMemberLikes();


        BoardDTO boardDTO = BoardDTO.builder()
                .id(board.getId())
                .questionId(question.getId())
                .questionContent(question.getContent())
                .memberId(member.getId())
                .memberNickname(member.getNickname())
                .profileImageUrl(member.getProfileImageUrl())
                .content(board.getContent())
                .videoUrl(board.getVideoUrl())
                .likeCount(boardMemberLikes.size())
                .commentCount(comments.size())
                .createTime(LocalDateTime.now())
                .updateTime(board.getUpdateTime())
                .createTime(board.getCreateTime())
                .build();


        return boardDTO;
    }

    public String videoUpload(BoardVideoDTO boardVideoDTO) {
        Optional<UploadFile> uploadFile = Optional.ofNullable(videoStore.storeFile(boardVideoDTO.getVideo()));
        return uploadFile.orElse(new UploadFile(null, null)).getStoreFileName();
    }


    public void delete(Long id) {
        boardRepository.deleteById(id);
    }

    @Transactional
    public Long update(Long id, BoardUpdateDTO boardUpdateDTO) {

        Board board = boardRepository.findById(id).orElseThrow(() -> new RuntimeException("해당 게시글을 찾을 수 없습니다"));

        Question question = questionRepository.findById(boardUpdateDTO.getQuestionId()).orElseThrow(() -> new RuntimeException("해당 질문을 찾을 수 없습니다."));

        board.update(question, boardUpdateDTO.getContent(), boardUpdateDTO.getVideoUrl());

        return board.getId();

    }

    @Transactional
    public void like(Long board_id) {

        Long member_id = 1L;
        Optional<BoardMemberLike> boardMemberLike = boardMemberLikeRepository.findByMemberIdAndBoardId(board_id, member_id);

        if (boardMemberLike.isEmpty()) {
            log.info("create like , board_id:  {} , member_id: {}", board_id, member_id);
            Board board = boardRepository.findById(board_id).orElseThrow(() -> new RuntimeException("해당 게시물을 찾을 수 없습니다."));
            Member member = memberRepository.findById(member_id).orElseThrow(() -> new RuntimeException("해당 멤버를 찾을 수 없습니다."));
            boardMemberLikeRepository.save(new BoardMemberLike(board, member));

        }else{
            boardMemberLike.get().updateStatus();
        }


    }
}