class Question {
  static const String dbQuestion = "question";
  static const String dbType = "type";
  static const String dbAnswers = "answers";
  static const String dbTime = "time";

  String question = '';
  String type = '';
  int time = 10;
  List<Answer> answers = [];

  Question({
    required this.question,
    required this.type,
    required this.answers,
    required this.time,
  });

  Question.empty() {
    answers = [Answer(), Answer(), Answer(), Answer()];
  }

  Question.fromJson(Map<String, dynamic> json) {
    question = json[dbQuestion];
    type = json[dbType];
    time = json[dbTime] ?? 10;
    answers = List<Answer>.from(json[dbAnswers].map((answer) => Answer.fromJson(answer)));
  }

  Map<String, dynamic> toJson() => {
        dbQuestion: question,
        dbType: type,
        dbTime: time,
        dbAnswers: List<dynamic>.from(answers.map((answer) => answer.toJson())),
      };
}

class Answer {
  static const String dbAnswer = "answer";
  static const String dbValue = "isGoodAnswer";

  String answer = '';
  bool isGoodAnswer = false;

  Answer({
    this.answer = '',
    this.isGoodAnswer = false,
  });

  Answer.fromJson(Map<String, dynamic> json) {
    answer = json[dbAnswer];
    isGoodAnswer = json[dbValue];
  }

  Map<String, dynamic> toJson() => {
        dbAnswer: answer,
        dbValue: isGoodAnswer,
      };
}
