import 'package:flutter/material.dart';
import 'package:qweez_app/components/appbar/classic_appbar.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/error_page.dart';
import 'package:qweez_app/pages/gameplay/questions/question_widget.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';
import 'package:beamer/beamer.dart';

class PlayAlonePage extends StatefulWidget {
  final String qweezId;

  const PlayAlonePage({Key? key, required this.qweezId}) : super(key: key);

  @override
  _PlayAlonePageState createState() => _PlayAlonePageState();
}

class _PlayAlonePageState extends State<PlayAlonePage> with SingleTickerProviderStateMixin {
  final _qweezRepo = QweezRepository();

  Qweez? _qweez;

  double get _result => _goodAnswers / _qweez!.questions.length;
  int _currentQuestionIndex = 0;
  int _goodAnswers = 0;

  late AnimationController _animationController;
  bool _hasError = false;

  @override
  initState() {
    super.initState();

    _qweezRepo.get(widget.qweezId).then((value) {
      setState(() {
        if (value == null) {
          _hasError = true;
          return;
        }

        _qweez = value;
      });

      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const ErrorPage(message: '404: Qweez not found');
    }

    if (_qweez == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentQuestionIndex == _qweez!.questions.length) {
      return _buildResult();
    }

    return QuestionWidget(
      key: UniqueKey(),
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

  Widget _buildResult() {
    _animationController.forward();

    var _valueTween = _animationController.drive(
      Tween(
        begin: 0,
        end: _result == 0 ? 0.1 : _result,
      ),
    );

    var _colorTween = _animationController.drive(
      ColorTween(
        begin: colorRed,
        end: _result >= 0.75
            ? colorGreen
            : _result >= 0.5
                ? colorYellow
                : colorRed,
      ),
    );

    return Scaffold(
      appBar: const ClassicAppbar(
        title: 'Your result',
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _result == 1
                        ? 'Perfect!'
                        : _result >= 0.75
                            ? "Congrats! You answered correctly to most of the questions."
                            : _result >= 0.5
                                ? "Keep going, you are on the right track!"
                                : "You will need to study a little more.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: fontSizeTitle - 5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: paddingVertical * 3, top: paddingVertical * 2),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 125,
                          width: 125,
                          child: CircularProgressIndicator(
                            value: _valueTween.value.toDouble(),
                            valueColor: _colorTween,
                            strokeWidth: 5,
                          ),
                        ),
                        Text(
                          _goodAnswers.toString() + "/" + _qweez!.questions.length.toString(),
                          style: const TextStyle(
                            fontSize: fontSizeTitle,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.beamToNamed('/');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: paddingHorizontal / 3),
                            child: Text('Home'),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
