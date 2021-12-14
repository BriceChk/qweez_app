import 'package:flutter/material.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/gameplay/questions/question_widget.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';

class PlayAlonePage extends StatefulWidget {
  final String qweezId;

  const PlayAlonePage({Key? key, required this.qweezId}) : super(key: key);

  @override
  _PlayAlonePageState createState() => _PlayAlonePageState();
}

class _PlayAlonePageState extends State<PlayAlonePage> {
  final _qweezRepo = QweezRepository();

  Qweez? _qweez;

  int _currentQuestionIndex = 0;
  int _goodAnswers = 0;

  @override
  initState() {
    super.initState();

    _qweezRepo.get(widget.qweezId).then((value) {
      setState(() {
        if (value == null) {
          //TODO ID invalide
          return;
        }

        _qweez = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_qweez == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentQuestionIndex == _qweez!.questions.length) {
      //TODO Display result
      return Text(_goodAnswers.toString());
    }

    return QuestionWidget(
      question: _qweez!.questions[_currentQuestionIndex],
      index: _currentQuestionIndex,
      qweezTitle: _qweez!.name,
      onFinished: (bool goodAnswer) {
        if (goodAnswer) {
          _goodAnswers++;
        }
      },
      onNextQuestion: () {
        setState(() {
          _currentQuestionIndex++;
        });
      },
    );
  }
}
