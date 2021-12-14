import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/question.dart';
import 'package:qweez_app/pages/gameplay/questions/my_answer_card.dart';
import 'package:qweez_app/pages/gameplay/questions/question_appbar.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final int index;

  const QuestionWidget({Key? key, required this.question, required this.index}) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  String _openAnswerValue = '';

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
                //value: ,
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
            valueText: _openAnswerValue,
            hintText: 'Hurry to write your answer',
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              _openAnswerValue = value;
            },
          );
        } else {
          var color = _openAnswerValue.toLowerCase() == answer.answer.toLowerCase() ? colorGreen : colorRed;

          return Column(
            children: [
              Text(
                _openAnswerValue.toLowerCase() == answer.answer.toLowerCase()
                    ? 'Correct 🎉 The answer is:'
                    : 'Sorry 😔 The answer is:',
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
