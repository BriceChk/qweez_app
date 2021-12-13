import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/appbar/questions_appbar.dart';
import 'package:qweez_app/components/cards/my_answer_card.dart';
import 'package:qweez_app/components/cards/my_ranking_card.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/models/player.dart';
import 'package:qweez_app/models/question.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/responsive.dart';

class Questionpage extends StatefulWidget {
  const Questionpage({Key? key}) : super(key: key);

  @override
  _QuestionpageState createState() => _QuestionpageState();
}

class _QuestionpageState extends State<Questionpage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  final Qweez _questionnaire = Qweez(
    userId: 'userId',
    name: 'name',
    description: 'description',
    questions: [
      Question(
        question: 'question',
        type: listDropDownValue.last,
        answers: [
          Answer(answer: 'answer'),
          Answer(answer: 'answer'),
        ],
        time: 10,
      ),
      Question(
        question: 'test',
        type: listDropDownValue.last,
        answers: [
          Answer(answer: 'blabla'),
        ],
        time: 10,
      ),
    ],
  );

  final _isPresenter = true;

  int _questionIndex = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      // TODO changer ici
      duration: Duration(seconds: _questionnaire.questions.first.time),
    );
    _colorTween = _animationController.drive(
      ColorTween(
        begin: colorGreen,
        end: colorRed,
      ),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuestionsAppBar(
        qweez: _questionnaire,
        questionIndex: _questionIndex,
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
          if (_questionnaire.questions[_questionIndex].answers.length == 1)
            singleAnswer(_questionnaire.questions[_questionIndex].answers.first),
          if (_questionnaire.questions[_questionIndex].answers.length != 1)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _questionnaire.questions[_questionIndex].answers.map((answer) {
                //TODO check pour avoir seulement une card qu'on peut selectionner
                return MyAnswerCard(
                  text: answer.answer,
                  isTrue: answer.isGoodAnswer,
                  animationController: _animationController,
                );
              }).toList(),
            ),
          if (_isPresenter) _buildButtonPresenter(),
        ],
      ),
    );
  }

  Widget _buildButtonPresenter() {
    //TODO implemter la vrai liste de user
    var _listMembers = [
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé ze zefze ffe zzfe ', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
    ];

    _listMembers.sort((a, b) => b.score.compareTo(a.score));

    return Padding(
      padding: const EdgeInsets.only(top: paddingVertical * 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
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
                            padding:
                                const EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
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
                            children: _listMembers.map((member) {
                              int rank = _listMembers.indexOf(member);

                              return MyRankingCard(
                                member: member,
                                qweez: Qweez(questions: [], userId: '', name: '', description: ''),
                                rank: rank + 1,
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: paddingVertical),
            child: ElevatedButton(
              onPressed: () {
                if (_questionIndex == (_questionnaire.questions.length - 1)) {
                  Beamer.of(context).beamToNamed('/ranking');
                } else {
                  setState(() {
                    _questionIndex++;
                    _animationController.reset();
                    _animationController.forward();
                  });
                }
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
          ),
        ],
      ),
    );
  }

  Widget singleAnswer(Answer answer) {
    String valueAnswer = '';

    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, Widget? child) {
          if (_animationController.isAnimating) {
            return MyTextFormField(
              valueText: valueAnswer,
              hintText: 'Hurry to write your answer',
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                valueAnswer = value;
              },
            );
          } else {
            return Column(
              children: [
                Text(
                  valueAnswer.toLowerCase() == answer.answer.toLowerCase()
                      ? 'Correct, you were right, it was:'
                      : 'Sorry but the right answer was:',
                  style: TextStyle(
                    fontSize: fontSizeText,
                    fontWeight: FontWeight.w600,
                    color: valueAnswer.toLowerCase() == answer.answer.toLowerCase() ? colorGreen : colorRed,
                  ),
                ),
                Text(
                  answer.answer,
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.w600,
                    color: valueAnswer.toLowerCase() == answer.answer.toLowerCase() ? colorGreen : colorRed,
                  ),
                ),
              ],
            );
          }
        });
  }
}
