class GameInfo {
  List<String> question;
  List<String> participant;
  List<String> order;
  int round;

  GameInfo({
    this.question,
    this.participant,
    this.order,
    this.round
  });

  factory GameInfo.fromJson(Map<String, dynamic> json){
    return GameInfo(
        question: (json['question'] as List<dynamic>).cast<String>(),
        participant: (json['participant'] as List<dynamic>).cast<String>(),
        order: (json['order'] as List<dynamic>).cast<String>(),
        round: json['round'] as int
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'question': question,
      'participant': participant,
      'order': order,
      'round': round
    };
  }
}