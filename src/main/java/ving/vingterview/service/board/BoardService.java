package ving.vingterview.service.board;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.LikeType;
import ving.vingterview.domain.board.Board;
import ving.vingterview.domain.board.BoardMemberLike;
import ving.vingterview.domain.comment.Comment;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;
import ving.vingterview.dto.board.*;
import ving.vingterview.repository.BoardMemberLikeRepository;
import ving.vingterview.repository.BoardRepository;
import ving.vingterview.repository.MemberRepository;
import ving.vingterview.repository.QuestionRepository;


import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class BoardService {
    private final BoardRepository boardRepository;
    private final MemberRepository memberRepository;
    private final QuestionRepository questionRepository;

    private final BoardMemberLikeRepository boardMemberLikeRepository;


    @Transactional
    public Long save(Long memberId, BoardCreateDTO boardCreateDTO) {

        Member member = memberRepository.findById(memberId).orElseThrow(() -> new EntityNotFoundException("해당 사용자를 찾을 수 없습니다"));

        Long questionId = boardCreateDTO.getQuestionId();
        Question question = questionRepository.findById(questionId).orElseThrow(() -> new EntityNotFoundException("해당 질문을 찾을 수 없습니다."));

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

        Board board = boardRepository.findByIdWithMemberQuestion(id).orElseThrow(() -> new EntityNotFoundException("해당 게시글을 찾을 수 없습니다."));
        return transferBoardDTO(board);
    }


    public void delete(Long id, Long memberId) {

        Board board = boardRepository.findById(id).orElseThrow(() -> new EntityNotFoundException("해당 게시글을 찾을 수 없습니다"));
        if (board.getMember().getId() != memberId) {
            throw new AccessDeniedException("해당 게시글에 생성자만 글을 삭제할 수 있습니다.");
        }

        boardRepository.deleteById(id);
    }

    @Transactional
    public Long update(Long id, BoardUpdateDTO boardUpdateDTO,Long memberId) {

        Board board = boardRepository.findById(id).orElseThrow(() -> new EntityNotFoundException("해당 게시글을 찾을 수 없습니다"));
        if (board.getMember().getId() != memberId) {
            throw new AccessDeniedException("해당 게시글에 생성자만 글을 수정할 수 있습니다.");
        }



        Question question = questionRepository.findById(boardUpdateDTO.getQuestionId()).orElseThrow(() -> new EntityNotFoundException("해당 질문을 찾을 수 없습니다."));
        board.update(question, boardUpdateDTO.getContent(), boardUpdateDTO.getVideoUrl());
        return board.getId();

    }

    @Transactional
    public void like(Long memberId, Long boardId) {

        Optional<BoardMemberLike> boardMemberLike = boardMemberLikeRepository.findByMemberIdAndBoardId(memberId, boardId);

        if (boardMemberLike.isEmpty()) {
            log.info("create like , board_id:  {} , member_id: {}", boardId, memberId);
            Board board = boardRepository.findById(boardId).orElseThrow(() -> new EntityNotFoundException("해당 게시물을 찾을 수 없습니다."));
            Member member = memberRepository.findById(memberId).orElseThrow(() -> new EntityNotFoundException("해당 멤버를 찾을 수 없습니다."));
            boardMemberLikeRepository.save(new BoardMemberLike(board, member));

        }else{
            boardMemberLike.get().updateStatus();
        }


    }

    /**
     *
     * @param page 현재 페이지
     * @param size 페이지 크기
     * @return BoardListDTO
     * 최근 생성된 게시물 순
     */
    public BoardListDTO findAll(int page,int size,boolean desc) {
        PageRequest pageRequest;
        if (desc) {
            pageRequest = PageRequest.of(page, size, Sort.by("createTime").descending());
        }else{
            pageRequest = PageRequest.of(page, size, Sort.by("createTime").ascending());
        }

        Slice<Board> boardSlice = boardRepository.findSliceBy(pageRequest);
        List<BoardDTO> boardDTOList = boardSlice.stream().map(board -> transferBoardDTO(board)).collect(Collectors.toList());

        BoardListDTO boardListDTO = new BoardListDTO();
        boardListDTO.setBoards(boardDTOList);
        boardListDTO.setHasNext(boardSlice.hasNext());
        boardListDTO.setNextPage(page + 1); // 최대 페이지 넘게 요청하면 애초에 아무것도 반환이 안 됨.

        return boardListDTO;
    }

    public BoardListDTO findByMember(Long memberId, int page,int size) {

        /**
         * 92ms
         */
/*        List<Long> boardIds = boardRepository.findByMemberId(memberId)
                .stream().map(board -> board.getId()).collect(Collectors.toList());

        List<BoardDTO> boardDTOList = boardRepository.findByIdsWithMemberQuestion(boardIds)
                .stream().map(board -> transferBoardDTO(board)).collect(Collectors.toList());*/

        /**
         * 81ms
         */
        PageRequest pageRequest = PageRequest.of(page, size, Sort.by("createTime").descending());

        Slice<Board> boardSlice = boardRepository.findByMemberIdWithMemberQuestion(memberId,pageRequest);

        List<BoardDTO> boardDTOList = boardSlice.stream().map(board -> transferBoardDTO(board)).collect(Collectors.toList());


        BoardListDTO boardListDTO = new BoardListDTO();
        boardListDTO.setBoards(boardDTOList);
        boardListDTO.setHasNext(boardSlice.hasNext());
        boardListDTO.setNextPage(page+1);


        return boardListDTO;

    }

    public BoardListDTO findByQuestion(Long questionId,int page,int size) {

        PageRequest pageRequest = PageRequest.of(page, size, Sort.by("createTime").descending());

        Slice<Board> boardSlice = boardRepository.findByQuestionIdWithMemberQuestion(questionId,pageRequest);
        List<BoardDTO> boardDTOList = boardSlice.stream().map(board -> transferBoardDTO(board)).collect(Collectors.toList());


        BoardListDTO boardListDTO = new BoardListDTO();
        boardListDTO.setBoards(boardDTOList);
        boardListDTO.setHasNext(boardSlice.hasNext());
        boardListDTO.setNextPage(page+1);

        return boardListDTO;
    }


    public BoardListDTO orderByLike(int page,int size) {
        PageRequest pageRequest = PageRequest.of(page, size);

        Slice<Board> boardSlice = boardRepository.orderSliceByLike(pageRequest);
        List<BoardDTO> boardDTOList = boardSlice.stream().map(board -> transferBoardDTO(board)).collect(Collectors.toList());

        BoardListDTO boardListDTO = new BoardListDTO();
        boardListDTO.setBoards(boardDTOList);
        boardListDTO.setHasNext(boardSlice.hasNext());
        boardListDTO.setNextPage(page+1);

        return boardListDTO;

    }

    public BoardListDTO orderByComment(int page,int size) {
        PageRequest pageRequest = PageRequest.of(page, size);

        Slice<Board> boardSlice = boardRepository.orderSliceByComment(pageRequest);
        List<BoardDTO> boardDTOList = boardSlice.stream().map(board -> transferBoardDTO(board)).collect(Collectors.toList());

        BoardListDTO boardListDTO = new BoardListDTO();
        boardListDTO.setBoards(boardDTOList);
        boardListDTO.setHasNext(boardSlice.hasNext());
        boardListDTO.setNextPage(page+1);

        return boardListDTO;

    }

    private BoardDTO transferBoardDTO(Board board) {

        Question question = board.getQuestion();
        Member member = board.getMember();

        List<Comment> comments = board.getComments();

        int likeCount = boardMemberLikeRepository.countByBoardAndLikeStatus(board, LikeType.LIKE);
//        List<BoardMemberLike> boardMemberLikes = board.getBoardMemberLikes();
//        int likeCount = (int)boardMemberLikes.stream().filter(bml -> bml.getLikeStatus() == LikeType.LIKE).count();


        return BoardDTO.builder()
                .boardId(board.getId())
                .questionId(question.getId())
                .questionContent(question.getContent())
                .memberId(member.getId())
                .memberNickname(member.getNickname())
                .profileImageUrl(member.getProfileImageUrl())
                .content(board.getContent())
                .videoUrl(board.getVideoUrl())
                .likeCount(likeCount)
                .commentCount(comments.size())
                .createTime(LocalDateTime.now())
                .updateTime(board.getUpdateTime())
                .createTime(board.getCreateTime())
                .build();
    }



}
