import 'package:qweez_app/models/player.dart';
import 'package:qweez_app/models/question.dart';

class Qweez {
  static const String dbId = 'id';
  static const String dbUserId = 'userId';
  static const String dbName = 'name';
  static const String dbDescription = 'description';
  static const String dbQuestions = 'questions';
  static const String dbMembers = 'members';

  String? id = '';
  String name = '';
  String description = '';
  String userId = '';
  List<Question> questions = [];
  List<Player> members = [];

  Qweez({
    this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.questions,
    List<Player>? members,
  }) {
    this.members = members ?? [];
  }

  Qweez.fromJson(Map<String, dynamic> json) {
    id = json[dbId];
    userId = json[dbUserId];
    name = json[dbName];
    description = json[dbDescription];
    questions = List<Question>.from(json[dbQuestions].map((question) => Question.fromJson(question)));
    members = []; // Empty list because we'll not go through friebase for the user
  }

  Map<String, dynamic> toJson() => {
        dbId: id,
        dbUserId: userId,
        dbName: name,
        dbDescription: description,
        dbQuestions: List<dynamic>.from(questions.map((question) => question.toJson())),
        dbMembers: [], // Empty list because we'll not go through friebase for the user
      };
}
