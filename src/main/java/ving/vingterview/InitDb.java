package ving.vingterview;


import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ving.vingterview.domain.board.Board;
import ving.vingterview.domain.board.BoardMemberLike;
import ving.vingterview.domain.comment.Comment;
import ving.vingterview.domain.comment.CommentMemberLike;
import ving.vingterview.domain.member.Member;
import ving.vingterview.domain.question.Question;
import ving.vingterview.domain.question.QuestionMemberScrap;
import ving.vingterview.domain.tag.Tag;
import ving.vingterview.domain.tag.TagMember;
import ving.vingterview.domain.tag.TagQuestion;
import ving.vingterview.domain.tag.TagType;


@Component
@RequiredArgsConstructor
public class InitDb {

    private final InitService initService;

    @PostConstruct
    public void InitDb() {
        initService.dbInit();
    }



    @Component
    @RequiredArgsConstructor
    @Transactional
    static class InitService {

        private final EntityManager em;

        public void dbInit() {

            Member member1 = createMember("User1","PassWord1","임동현","Impala",25,"dla33834051@gmail.com","profileUrl1");
            Member member2 = createMember("User2","PassWord2","정찬영","Chan0",26,"email2","profileUrl2");
            Member member3 = createMember("User3","PassWord3","장혜정","Hae",23,"email3","profileUrl3");

            em.persist(member1);
            em.persist(member2);
            em.persist(member3);



            Tag tag1 = createTag(null,"대기업", TagType.CLASSIFICATION);
            Tag tag2 = createTag(null,"중소기업",TagType.CLASSIFICATION);
            Tag tag3 = createTag(null,"스타트업",TagType.CLASSIFICATION);

            Tag tag4 = createTag(tag1, "삼성", TagType.ENTERPRISE);
            Tag tag5 = createTag(tag1, "카카오", TagType.ENTERPRISE);
            Tag tag6 = createTag(tag1, "네이버", TagType.ENTERPRISE);
            Tag tag7 = createTag(tag2, "당근마켓", TagType.ENTERPRISE);


            Tag tag8 = createTag(tag5, "개발", TagType.JOB);
            Tag tag9 = createTag(tag4, "IT/개발", TagType.JOB);
            Tag tag10 = createTag(tag4, "마케팅", TagType.JOB);
            Tag tag11 = createTag(tag7, "회계", TagType.JOB);

            Tag tag12 = createTag(null, "인적성", TagType.INTERVIEW);
            Tag tag13 = createTag(null, "기술면접", TagType.INTERVIEW);

            em.persist(tag1);
            em.persist(tag2);
            em.persist(tag3);
            em.persist(tag4);
            em.persist(tag5);
            em.persist(tag6);
            em.persist(tag7);
            em.persist(tag8);
            em.persist(tag9);
            em.persist(tag10);
            em.persist(tag11);
            em.persist(tag12);
            em.persist(tag13);


            Question question1 = createQuestion(null, "질문1");
            Question question2 =createQuestion(member1,"질문2");
            Question question3 = createQuestion(member3,"질문3");
            Question question4 = createQuestion(member2,"질문4");
            Question question5 =  createQuestion(member2,"질문5");

            em.persist(question1);
            em.persist(question2);
            em.persist(question3);
            em.persist(question4);
            em.persist(question5);

            Board board1 = createBoard(question1,member1,"본문1","url1");
            Board board2 = createBoard(question4,member1,"본문2","url2");
            Board board3 = createBoard(question2,member2,"본문3","url3");
            Board board4 = createBoard(question2,member3,"본문4","url4");

            em.persist(board1);
            em.persist(board2);
            em.persist(board3);
            em.persist(board4);

            for (int i = 0; i < 1000; i++) {
                Board board = createBoard(question2,member3,"forPaging","forPaging");
                em.persist(board);
            }

            Comment comment1 = createComment(board1, member1, "댓글1");
            Comment comment2 = createComment(board1, member2, "댓글2");
            Comment comment3 = createComment(board2, member3, "댓글3");
            Comment comment4 = createComment(board3, member3, "댓글4");

            em.persist(comment1);
            em.persist(comment2);
            em.persist(comment3);
            em.persist(comment4);

            for (int i = 0; i < 10; i++) {
                Comment comment = createComment(board1, member1, "forPaging");
                em.persist(comment);
            }
            for (int i = 0; i < 20; i++) {
                Comment comment = createComment(board2, member1, "forPaging");
                em.persist(comment);
            }


            em.persist(createBoardMemberLike(board3, member1));
            em.persist(createBoardMemberLike(board4, member1));
            em.persist(createBoardMemberLike(board1, member2));
            em.persist(createBoardMemberLike(board2, member2));
            em.persist(createBoardMemberLike(board4, member2));
            em.persist(createBoardMemberLike(board1, member3));


            em.persist(createCommentMemberLike(comment1,member1));
            em.persist(createCommentMemberLike(comment2,member1));
            em.persist(createCommentMemberLike(comment3,member1));
            em.persist(createCommentMemberLike(comment4,member1));
            em.persist(createCommentMemberLike(comment1,member2));
            em.persist(createCommentMemberLike(comment4,member2));
            em.persist(createCommentMemberLike(comment1,member3));
            em.persist(createCommentMemberLike(comment2,member3));
            em.persist(createCommentMemberLike(comment3,member3));


            em.persist(createQuestionMemberScrap(question1,member1));
            em.persist(createQuestionMemberScrap(question4,member1));
            em.persist(createQuestionMemberScrap(question3,member2));
            em.persist(createQuestionMemberScrap(question4,member2));
            em.persist(createQuestionMemberScrap(question1,member3));
            em.persist(createQuestionMemberScrap(question2,member3));
            em.persist(createQuestionMemberScrap(question3,member3));
            em.persist(createQuestionMemberScrap(question4,member3));

            em.persist(createTagQuestion(tag1,question1));
            em.persist(createTagQuestion(tag4,question1));
            em.persist(createTagQuestion(tag9,question1));
            em.persist(createTagQuestion(tag2,question2));
            em.persist(createTagQuestion(tag7,question2));
            em.persist(createTagQuestion(tag11,question2));
            em.persist(createTagQuestion(tag1,question3));
            em.persist(createTagQuestion(tag5,question3));
            em.persist(createTagQuestion(tag8,question3));
            em.persist(createTagQuestion(tag1,question4));
            em.persist(createTagQuestion(tag5,question4));
            em.persist(createTagQuestion(tag8,question4));
            em.persist(createTagQuestion(tag1,question5));
            em.persist(createTagQuestion(tag4,question5));
            em.persist(createTagQuestion(tag9,question5));

            em.persist(createTagMember(tag1,member1));
            em.persist(createTagMember(tag4,member1));
            em.persist(createTagMember(tag9,member1));
            em.persist(createTagMember(tag2,member2));
            em.persist(createTagMember(tag7,member2));
            em.persist(createTagMember(tag11,member2));
            em.persist(createTagMember(tag1,member3));
            em.persist(createTagMember(tag5,member3));
            em.persist(createTagMember(tag8,member3));




        }

        private TagMember createTagMember(Tag tag, Member member) {
            return TagMember.builder()
                    .tag(tag)
                    .member(member)
                    .build();
        }

        private TagQuestion createTagQuestion(Tag tag, Question question) {
            return TagQuestion.builder()
                    .tag(tag)
                    .question(question)
                    .build();
        }

        private QuestionMemberScrap createQuestionMemberScrap(Question question, Member member) {

            return QuestionMemberScrap.builder()
                    .member(member)
                    .question(question)
                    .build();
        }

        private CommentMemberLike createCommentMemberLike(Comment comment, Member member) {

            return CommentMemberLike.builder()
                    .member(member)
                    .comment(comment)
                    .build();
        }

        private BoardMemberLike createBoardMemberLike(Board board, Member member) {

            return BoardMemberLike.builder()
                    .member(member)
                    .board(board)
                    .build();
        }

        private Comment createComment(Board board, Member member, String content) {
            return Comment.builder()
                    .board(board)
                    .member(member)
                    .content(content)
                    .build();
        }

        private Board createBoard(Question question, Member member, String content, String videoUrl) {
            return Board.builder()
                    .question(question)
                    .member(member)
                    .content(content)
                    .videoUrl(videoUrl)
                    .build();
        }

        private Question createQuestion(Member member, String content) {
            return  Question.builder()
                    .member(member)
                    .content(content)
                    .build();
        }

        private Member createMember(String loginId, String password, String name, String nickname, int age,String email,String profileImageUrl) {
            return Member.builder()
                    .loginId(loginId)
                    .password(password)
                    .name(name)
                    .nickname(nickname)
                    .age(age)
                    .email(email)
                    .profileImageUrl(profileImageUrl)
                    .build();
        }

        private Tag createTag(Tag parent, String name, TagType category) {
            return Tag.builder()
                    .parent(parent)
                    .name(name)
                    .category(category)
                    .build();
        }
    }
}
