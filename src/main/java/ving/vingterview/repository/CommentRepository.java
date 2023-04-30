package ving.vingterview.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import ving.vingterview.domain.board.Board;
import ving.vingterview.domain.comment.Comment;
import ving.vingterview.domain.member.Member;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment,Long> {

    List<Comment> findAllByBoard(Board board);
    Slice<Comment> findSliceByBoard(Board board, Pageable pageable);
    List<Comment> findAllByMember(Member member);

    Slice<Comment> findSliceByMember(Member board, Pageable pageable);


}
