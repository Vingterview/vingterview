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
import ving.vingterview.repository.QuestionRepository;

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
        private final QuestionRepository questionRepository;

        @Value("classpath:기업.txt")
        private Resource fileResource;
        @Value("classpath:소분류.txt")
        private Resource fileResource2;
        @Value("classpath:질문Parsing.txt")
        private Resource fileResource3;

        public void dbInit() {

            Member member1 = createMember("User1","PassWord1","임동현","임팔라",25,"dla33834051@gmail.com","https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png");
            Member member2 = createMember("User2","PassWord2","정찬영","정찬영",26,"jungchanyoung31@gmail.com","https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png");
            Member member3 = createMember("User3","PassWord3","임동현","장혜쩡",25,"editimpala@gmail.com","https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png");
            Member member4 = createMember("User4","PassWord4","장혜정","면접왕",23,"hjnet01@gmail.com","https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png");
            Member member5 = createMember("User5","PassWord4","장혜정","내일은 취업왕",23,"capstonvivi@gmail.com","https://vingterview.s3.ap-northeast-2.amazonaws.com/image/1b9ec992-d85f-4758-bbfc-69b0c68ccc47.png");

            List<Member> members = new ArrayList<>();
            members.add(member1);
            members.add(member2);
            members.add(member3);
            members.add(member4);
            members.add(member5);

            em.persist(member1);
            em.persist(member2);
            em.persist(member3);
            em.persist(member4);
            em.persist(member5);


            List<String> contents = new ArrayList<>();
            contents.add("시선처리가 아직 많이 어렵네요. 더 열심히 하겠습니다.");
            contents.add("아직 부족한 점이 많네요. 피드백 부탁드립니다");
            contents.add("안녕하세요. 취업 1년차입니다. 면접 준비가 항상 어려웠는데, 뷰인터 너무 좋은 것 같네요.");
            contents.add("답변 내용 위주로 피드백 부탁드립니다!");
            contents.add("냉정하게 평가 부탁드리겠습니다.");

            List<String> urls = new ArrayList<>();
            urls.add("https://vingterview.s3.ap-northeast-2.amazonaws.com/video/dade5483-fbf8-492b-bb8d-b9766e8d1231.mp4");
            urls.add("https://vingterview.s3.ap-northeast-2.amazonaws.com/video/cf0a7c6c-4297-4425-9c07-9c31d1f4cf12.mp4");
            urls.add("https://vingterview.s3.ap-northeast-2.amazonaws.com/video/d3f9f160-bcf2-4bb9-856e-a336fef2420d.mp4");
            urls.add("https://vingterview.s3.ap-northeast-2.amazonaws.com/video/51f2f0c8-aa6b-48c4-bb15-e1cf4018c5c7.mp4");
            urls.add("https://vingterview.s3.ap-northeast-2.amazonaws.com/video/bf74f782-66ce-4c1a-a777-46d3b28b9c85.mp4");



            for (int i = 0; i < 10; i++) {
                Question question = questionRepository.findRandom();
                Board board = createBoard(question, members.get(i % 5), contents.get(i % 5), urls.get(i % 5));
                em.persist(board);
            }






           /* Tag tag1 = createTag(null,"이벤트", TagType.TOPLEVEL);
            Tag tag2 = createTag(tag1,"이벤트", TagType.MIDLEVEL);
            Tag tag3 = createTag(tag2,"이벤트", TagType.SUB);

            em.persist(tag1);
            em.persist(tag2);
            em.persist(tag3);

            Question question =createQuestion(member1,"임시");
            em.persist(question);
            em.persist(createTagQuestion(tag1,question));
            em.persist(createTagQuestion(tag2,question));
            em.persist(createTagQuestion(tag3,question));

            for (int i = 0; i < 1000; i++) {
                Board board = createBoard(question,member3,"임시글","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");
                em.persist(board);
            }*/

            Tag tag1 = createTag(null, "공무원", TagType.TOPLEVEL);
            Tag tag2 = createTag(tag1, "7,9급", TagType.MIDLEVEL);
            Tag tag3 = createTag(tag2, "검찰사무직", TagType.SUB);
            Tag tag4 = createTag(tag2, "고용노동부", TagType.SUB);

            em.persist(tag1);
            em.persist(tag2);
            em.persist(tag3);
            em.persist(tag4);


/*

            Tag tag1 = createTag(null,"대기업", TagType.TOPLEVEL);
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
            em.persist(tag11);



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



            Board board1 = createBoard(question1,member1,"본문1","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");
            Board board2 = createBoard(question2,member1,"본문2","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");
            Board board3 = createBoard(question3,member2,"본문3","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");
            Board board4 = createBoard(question4,member3,"본문4","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");

            em.persist(board1);
            em.persist(board2);
            em.persist(board3);
            em.persist(board4);

            for (int i = 0; i < 1000; i++) {
                Board board = createBoard(question1,member3,"forPaging","https://vingterview.s3.ap-northeast-2.amazonaws.com/video/e474aa97-b4f1-434b-a89e-203bb9b9f6d3.mp4");
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
            em.persist(createQuestionMemberScrap(question1,member1));
            em.persist(createQuestionMemberScrap(question1,member2));
            em.persist(createQuestionMemberScrap(question1,member2));
            em.persist(createQuestionMemberScrap(question1,member3));
            em.persist(createQuestionMemberScrap(question1,member3));
            em.persist(createQuestionMemberScrap(question1,member3));
            em.persist(createQuestionMemberScrap(question1,member3));

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
