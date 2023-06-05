// import 'package:capston/models/comments.dart';
// import 'package:flutter/material.dart';
// import '../providers/comments_api.dart';
// import '../providers/uploadmp4.dart';
// import 'dart:io';
// import 'package:capston/models/globals.dart';
// import 'package:capston/models/questions.dart';
// import 'pick_question.dart';
// import 'package:image_picker/image_picker.dart';

// class EditcommentPage extends StatefulWidget {
//   final Comments comment; // 수정할 게시글의 객체
//   EditcommentPage({@required this.comment});

//   @override
//   _EditcommentPageState createState() => _EditcommentPageState();
// }

// class _EditcommentPageState extends State<EditcommentPage> {
//   String _content;
//   String _comment_url;

//   XFile _comment;
//   String uri = myUri;
//   Questions selectedQuestion;

//   CommentApi _commentApi = CommentApi();

//   final _formKey = GlobalKey<FormState>();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.comment != null) {
//       // 게시글 수정 페이지로 넘어온 경우, 기존 게시글의 값으로 초기화
//       setState(() {
//         buttonText = widget.comment.questionContent;
//         _questionId = widget.comment.questionId;
//         _content = widget.comment.content;
//         _comment_url = widget.comment.commentUrl;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF6fa8dc), Color(0xFF8A61D4)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.check),
//               onPressed: () async {
//                 print(_comment);
//                 if (_formKey.currentState.validate() &&
//                     (_comment != null || _comment_url != null)) {
//                   _formKey.currentState.save();
//                   try {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('글을 수정하는데에 1분~10분 이내에 시간이 소요될 수 있습니다.')));
//                     Navigator.pop(context);
//                     if (_comment != null) {
//                       _comment_url =
//                           await uploadcommentApi.pickcomment(_comment);
//                       print(_comment_url);
//                     }
//                     print(_comment_url);
//                     int boardId = await _commentApi.putRequest(
//                         widget.comment.boardId,
//                         _questionId,
//                         _content,
//                         _comment_url);
//                     print(boardId);
//                   } catch (e) {
//                     print("dd$e");
//                   }
//                 }
//               },
//             ),
//           ],
//           title: Text(
//             '영상 수정하기',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//         ),
//         body: Padding(
//             padding: EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         pickQuestion(context);
//                       },
//                       child: Container(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                         margin:
//                             EdgeInsets.symmetric(vertical: 5, horizontal: 0),
//                         decoration: BoxDecoration(
//                           color: Color(0xFFEEEEEE),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           "Q. $buttonText",
//                           style: TextStyle(
//                               fontSize: 16, // 줄글 글씨 크기
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       initialValue: _content ?? '', // 수정할 게시글의 내용을 초기값으로 설정
//                       decoration: InputDecoration(
//                         labelText: '본문 내용',
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 20, horizontal: 0),
//                       ),
//                       maxLines: 3,
//                       keyboardType: TextInputType.multiline,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return '내용을 작성해주세요';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _content = value;
//                       },
//                     ),
//                     SizedBox(
//                       height: 3,
//                     ),
//                   ],
//                 ),
//               ),
//             )));
//   }
// }
