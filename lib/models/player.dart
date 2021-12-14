class Player {
  static const String dbUserName = 'username';
  static const String dbScore = 'score';

  String username = '';
  int score = 0;

  Player({
    required this.username,
    this.score = 0,
  });

  Player.fromJson(Map<String, dynamic> json) {
    username = json[dbUserName];
    score = json[dbScore];
  }

  Map<String, dynamic> toJson() => {
        dbUserName: username,
        dbScore: score,
      };
}
