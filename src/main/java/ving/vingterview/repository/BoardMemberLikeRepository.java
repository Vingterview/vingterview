package ving.vingterview.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ving.vingterview.domain.LikeType;
import ving.vingterview.domain.board.Board;
import ving.vingterview.domain.board.BoardMemberLike;
import ving.vingterview.domain.comment.Comment;

import java.util.Optional;

public interface BoardMemberLikeRepository extends JpaRepository<BoardMemberLike,Long> {


    @Query("select bml from BoardMemberLike bml where bml.board.id = :board_id and bml.member.id = :member_id")
    Optional<BoardMemberLike> findByMemberIdAndBoardId( @Param(value = "member_id") Long member_id,@Param(value = "board_id") Long board_id);

    int countByBoardAndLikeStatus(Board board, LikeType status);

}
