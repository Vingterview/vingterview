enum Stage {
  // 클라이언트가 받아서 위젯한테 알려줌.
  GAME_MATCHED, // 게임이 매칭됨 -> 게임 홈 화면 그리기
  ROUND_START, // 라운드 시작 -> 라운드 정보 띄우고 질문 보여주기 + 참가 신청 받기
  SHOW_PARTICIPANT, // 참가 신청 종료 -> 참가자 정보랑 순서 보여주기
  READY_STREAMING, // (답변자) 답변 준비 -> 카메라 띄우기
  WATCH_STREAMING, // (나머지) 답변 시청 -> 비디오 스트림 화면
  START_POLL, // 제일 잘 한사람 투표 -> 투표 화면 그리기
  SHOW_RESULT, // 투표 결과 -> 투표 결과 화면 그리기
  GAME_FINISH // 게임 종료 -> 홈 화면으로 나가기
}
