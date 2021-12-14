import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/question.dart';
import 'package:qweez_app/pages/gameplay/questions/my_answer_card.dart';
import 'package:qweez_app/pages/gameplay/questions/question_appbar.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final int index;
  final String qweezTitle;
  final Function(bool goodAnswer) onFinished;
  final Function() onNextQuestion;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.index,
    required this.onFinished,
    required this.onNextQuestion,
    required this.qweezTitle,
  }) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.question.time),
    );

    _colorTween = _animationController.drive(
      ColorTween(
        begin: colorGreen,
        end: colorRed,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        var goodAnswer = widget.question.answers.any((answer) => answer.isSelected && answer.isGoodAnswer);
        widget.onFinished(goodAnswer);
        // setState to rebuild buttons depending on animation controller status
        setState(() {});
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuestionAppBar(
        question: widget.question,
        index: widget.index,
        qweezTitle: widget.qweezTitle,
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Container(
      color: colorWhite,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return LinearProgressIndicator(
                backgroundColor: colorLightGray,
                minHeight: 5,
                valueColor: _colorTween,
                value: _animationController.value,
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.question.answers.length == 1) _buildOpenAnswer(widget.question.answers.first),
          if (widget.question.answers.length != 1)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.question.answers.map((answer) {
                return MyAnswerCard(
                  answer: answer,
                  index: widget.question.answers.indexOf(answer) + 1,
                  animationController: _animationController,
                  onSelect: () {
                    // Deselect all answers & select the tapped one if the time is not out
                    if (_animationController.isAnimating) {
                      setState(() {
                        for (var element in widget.question.answers) {
                          element.isSelected = element == answer;
                        }
                      });
                    }
                  },
                );
              }).toList(),
            ),
          if (_animationController.isAnimating)
            ElevatedButton(
              onPressed: () {
                _animationController.animateTo(1, duration: const Duration());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: paddingHorizontal / 3),
                      child: Text('Show result'),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                    ),
                  ],
                ),
              ),
            ),
          if (_animationController.isCompleted)
            ElevatedButton(
              onPressed: () {
                widget.onNextQuestion();
                _animationController.forward(from: 0);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: paddingHorizontal / 3),
                      child: Text('Next question'),
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
    );
  }

  Widget _buildOpenAnswer(Answer answer) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, Widget? child) {
        if (_animationController.isAnimating) {
          return MyTextFormField(
            hintText: 'Hurry to write your answer!',
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              answer.isSelected = value.toLowerCase() == answer.answer.toLowerCase();
            },
          );
        } else {
          var color = answer.isSelected ? colorGreen : colorRed;

          return Column(
            children: [
              Text(
                answer.isSelected ? 'Correct 🎉 The answer is:' : 'Sorry 😔 The answer is:',
                style: TextStyle(
                  fontSize: fontSizeText,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                answer.answer,
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
