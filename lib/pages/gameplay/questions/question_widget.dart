import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qweez_app/components/cards/my_ranking_card.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/player.dart';
import 'package:qweez_app/models/question.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/gameplay/questions/my_answer_card.dart';
import 'package:qweez_app/pages/gameplay/questions/question_appbar.dart';
import 'package:qweez_app/pages/responsive.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final int index;
  final Qweez qweez;
  final List<Player>? playerList;
  final Function(bool goodAnswer)? onFinished;
  final Function()? onNextQuestion;
  final bool showControlButtons;
  final AnimationController? animationController;
  final bool canSelect;
  final String? username;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.index,
    this.onFinished,
    this.onNextQuestion,
    this.showControlButtons = true,
    this.animationController,
    required this.qweez,
    this.playerList,
    this.canSelect = true,
    this.username,
  }) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    if (widget.animationController != null) {
      _animationController = widget.animationController!;
      _animationController.duration = Duration(seconds: widget.question.time);
    } else {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.question.time),
      );
    }

    _colorTween = _animationController.drive(
      ColorTween(
        begin: colorGreen,
        end: colorRed,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        var goodAnswer = widget.question.answers.any((answer) => answer.isSelected && answer.isGoodAnswer);
        if (widget.onFinished != null) {
          widget.onFinished!(goodAnswer);
        }
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
    return Container(
      color: colorBlue,
      child: SafeArea(
        child: Scaffold(
          appBar: QuestionAppBar(
            question: widget.question,
            index: widget.index,
            qweezTitle: widget.qweez.name,
          ),
          body: _getBody(),
        ),
      ),
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
                    if (_animationController.isAnimating && widget.canSelect) {
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
          if (_animationController.isAnimating && widget.showControlButtons)
            Padding(
              padding: const EdgeInsets.only(top: paddingVertical),
              child: ElevatedButton(
                onPressed: () {
                  _animationController.animateTo(1, duration: const Duration());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: paddingHorizontal / 3),
                        child: Text('Show answer'),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_animationController.isCompleted && widget.showControlButtons)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: paddingVertical),
              child: ElevatedButton(
                onPressed: widget.onNextQuestion,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: paddingHorizontal / 3),
                        child: Text(widget.index == widget.qweez.questions.length - 1 ? 'End quiz' : 'Next question'),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_animationController.isCompleted && widget.playerList != null) _buildRankingButton(),
        ],
      ),
    );
  }

  Widget _buildRankingButton() {
    widget.playerList!.sort((a, b) => a.score.compareTo(b.score));

    return ElevatedButton(
      onPressed: () {
        showMaterialModalBottomSheet(
          backgroundColor: colorWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
          ),
          context: context,
          builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: paddingVertical,
                horizontal: paddingHorizontal,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      splashRadius: 20.0,
                      highlightColor: Colors.transparent,
                      splashColor: colorBlue.withOpacity(0.25),
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: GridView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isMobile(context)
                            ? 1
                            : Responsive.isTablet(context)
                                ? 2
                                : 3,
                        mainAxisExtent: 70, // Card height (100) + Padding vertical
                        crossAxisSpacing: paddingHorizontal,
                        mainAxisSpacing: paddingVertical / 2,
                      ),
                      children: widget.playerList!.map((member) {
                        int index = widget.playerList!.indexOf(member);

                        return MyRankingCard(
                          member: member,
                          numberOfQuestions: widget.qweez.questions.length,
                          rank: index + 1,
                          username: widget.username,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
        child: Row(
          children: const [
            Icon(
              Icons.align_vertical_bottom_rounded,
            ),
            Padding(
              padding: EdgeInsets.only(left: paddingHorizontal / 3),
              child: Text('Ranking'),
            ),
          ],
        ),
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
          var color = answer.isSelected || widget.username == null ? colorGreen : colorRed;

          return Column(
            children: [
              Text(
                widget.username == null
                    ? 'The answer is:'
                    : answer.isSelected
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
