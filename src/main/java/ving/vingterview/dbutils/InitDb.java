package ving.vingterview.dbutils;


import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
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

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


@Component
@RequiredArgsConstructor
public class InitDb {

    private final InitService initService;

    @PostConstruct
    public void InitDb() {

        initService.tagInit();
        initService.dbInit();


    }



    @Component
    @RequiredArgsConstructor
    @Transactional
    static class InitService {

        private final EntityManager em;

        @Value("classpath:기업.txt")
        private Resource fileResource;
        @Value("classpath:소분류.txt")
        private Resource fileResource2;
        @Value("classpath:질문Parsing.txt")
        private Resource fileResource3;

        public void dbInit() {

            Member member1 = createMember("User1","PassWord1","임동현","Impala",25,"dla33834051@gmail.com","https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png");
            Member member2 = createMember("User2","PassWord2","정찬영","Chan0",26,"jungchanyoung32@gmail.com","https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png");
            Member member3 = createMember("User3","PassWord3","장혜정","Hae",23,"","https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png");
            Member member4 = createMember("User4","PassWord4","장혜정2","Hae",23,"capstonvivi@gmail.com","https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png");

            em.persist(member1);
            em.persist(member2);
            em.persist(member3);
            em.persist(member4);



           /* Tag tag1 = createTag(null,"대기업", TagType.TOPLEVEL);
            Tag tag2 = createTag(null,"중소기업",TagType.TOPLEVEL);
            Tag tag3 = createTag(null,"스타트업",TagType.TOPLEVEL);

            Tag tag4 = createTag(tag1, "삼성", TagType.MIDLEVEL);
            Tag tag5 = createTag(tag1, "카카오", TagType.MIDLEVEL);
            Tag tag6 = createTag(tag1, "네이버", TagType.MIDLEVEL);
            Tag tag7 = createTag(tag2, "당근마켓", TagType.MIDLEVEL);


            Tag tag8 = createTag(tag5, "개발", TagType.SUB);
            Tag tag9 = createTag(tag4, "IT/개발", TagType.SUB);
            Tag tag10 = createTag(tag4, "마케팅", TagType.SUB);
            Tag tag11 = createTag(tag7, "회계", TagType.SUB);


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
            em.persist(tag11);*/

/*            Question question =createQuestion(member1,"forpaging");
            em.persist(question);*/


            /*Question question1 = createQuestion(null, "질문1");
            Question question2 =createQuestion(member1,"질문2");
            Question question3 = createQuestion(member3,"질문3");
            Question question4 = createQuestion(member2,"질문4");
            Question question5 =  createQuestion(member2,"질문5");

            em.persist(question1);
            em.persist(question2);
            em.persist(question3);
            em.persist(question4);
            em.persist(question5);

            for (int i = 0; i < 100; i++) {
                Question question = createQuestion(null, "forPaging" + i);
                em.persist(question);
                em.persist(createTagQuestion(tag1,question));
                em.persist(createTagQuestion(tag4,question));
                em.persist(createTagQuestion(tag9,question));

            }*/


         /*   Board board1 = createBoard(question,member1,"본문1","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");
            Board board2 = createBoard(question,member1,"본문2","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");
            Board board3 = createBoard(question,member2,"본문3","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");
            Board board4 = createBoard(question,member3,"본문4","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");

            em.persist(board1);
            em.persist(board2);
            em.persist(board3);
            em.persist(board4);

            for (int i = 0; i < 1000; i++) {
                Board board = createBoard(question,member3,"forPaging","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");
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


            em.persist(createQuestionMemberScrap(question,member1));
            em.persist(createQuestionMemberScrap(question,member1));
            em.persist(createQuestionMemberScrap(question,member2));
            em.persist(createQuestionMemberScrap(question,member2));
            em.persist(createQuestionMemberScrap(question,member3));
            em.persist(createQuestionMemberScrap(question,member3));
            em.persist(createQuestionMemberScrap(question,member3));
            em.persist(createQuestionMemberScrap(question,member3));*/

/*            em.persist(createTagQuestion(tag1,question1));
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
            em.persist(createTagQuestion(tag9,question5));*/

/*
            em.persist(createTagMember(tag1,member1));
            em.persist(createTagMember(tag4,member1));
            em.persist(createTagMember(tag9,member1));
            em.persist(createTagMember(tag2,member2));
            em.persist(createTagMember(tag7,member2));
            em.persist(createTagMember(tag11,member2));
            em.persist(createTagMember(tag1,member3));
            em.persist(createTagMember(tag5,member3));
            em.persist(createTagMember(tag8,member3));
*/




        }

        public void tagInit() {

            try {

                BufferedReader br = new BufferedReader(new InputStreamReader(fileResource.getInputStream()));
                BufferedReader br2 = new BufferedReader(new InputStreamReader(fileResource2.getInputStream()));
                BufferedReader questionBufferReader = new BufferedReader(new InputStreamReader(fileResource3.getInputStream()));

                String line;
                String line2;
                Tag toplevel  = createTag(null, "기업", TagType.TOPLEVEL);
                em.persist(toplevel);

                while (((line = br.readLine()) != null) && ((line2 = br2.readLine()) != null)) {
                    Tag midlevel = createTag(toplevel, line, TagType.MIDLEVEL);
                    em.persist(midlevel);
                    String[] subs = line2.split(",");
                    for (String sub : subs) {
                        Tag sublevel = createTag(midlevel, sub, TagType.SUB);
                        em.persist(sublevel);
                        questionInit(questionBufferReader,new ArrayList<>(Arrays.asList(new Tag[]{toplevel, midlevel, sublevel})));


                    }

                }


            } catch (FileNotFoundException e) {
                throw new RuntimeException(e);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

        }

        public void questionInit(BufferedReader fis, List<Tag> tags) {
            try {
                String[] questions = fis.readLine().split("-");
                String 기업 = questions[0];
                String 직무 = questions[1];
                for (int i = 2; i < questions.length ; i++) {
                    String content = questions[i];
                    Question question = createQuestion(null, content);
                    em.persist(question);
                    for (Tag tag : tags) {
                        TagQuestion tagQuestion = createTagQuestion(tag,question);
                        tagQuestion.setQuestion(question);
                        em.persist(tagQuestion);
                    }
                }


            } catch (FileNotFoundException e) {
                throw new RuntimeException(e);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

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
