class Member {
  static const String dbUserName = 'username';
  static const String dbScore = 'score';

  String userName = '';
  int score = 0;

  Member({
    required this.userName,
    this.score = 0,
  });

  Member.fromJson(Map<String, dynamic> json) {
    userName = json[dbUserName];
    score = json[dbScore];
  }

  Map<String, dynamic> toJson() => {
        dbUserName: userName,
        dbScore: score,
      };
}
