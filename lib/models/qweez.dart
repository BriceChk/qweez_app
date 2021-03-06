import 'package:qweez_app/models/player.dart';
import 'package:qweez_app/models/question.dart';

class Qweez {
  static const String dbCollectionName = 'qweez';

  static const String dbId = 'id';
  static const String dbUserId = 'userId';
  static const String dbName = 'name';
  static const String dbDescription = 'description';
  static const String dbQuestions = 'questions';
  static const String dbPlayers = 'players';

  String? id;
  String name = '';
  String description = '';
  String userId = '';
  List<Question> questions = [];
  List<Player> players = [];

  Qweez({
    this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.questions,
    List<Player>? players,
  }) {
    this.players = players ?? [];
  }

  Qweez.empty({required this.userId});

  Qweez.fromJson(Map<String, dynamic> json) {
    id = json[dbId];
    userId = json[dbUserId];
    name = json[dbName];
    description = json[dbDescription];
    questions = List<Question>.from(json[dbQuestions].map((question) => Question.fromJson(question)));
  }

  Map<String, dynamic> toJson() => {
        dbUserId: userId,
        dbName: name,
        dbDescription: description,
        dbQuestions: List<dynamic>.from(questions.map((question) => question.toJson())),
      };
}
