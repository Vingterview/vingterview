class MemberInfo {
  String sessionId;
  String name;
  String encodedImage;

  MemberInfo({
    this.sessionId,
    this.name,
    this.encodedImage
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json){
    return MemberInfo(
      sessionId: json['sessionId'] as String,
      name: json['name'] as String,
      encodedImage: json['encodedImage'] as String
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'sessionId': sessionId,
      'name': name,
      'encodedImage': encodedImage
    };
  }
}