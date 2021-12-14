import 'package:flutter/material.dart';
import 'package:qweez_app/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:qweez_app/models/question.dart';

class MyAnswerCard extends StatelessWidget {
  final Answer answer;
  final int index;
  final AnimationController animationController;
  final Function() onSelect;

  const MyAnswerCard({
    Key? key,
    required this.answer,
    required this.index,
    required this.animationController,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: onSelect,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 100,
              minHeight: 50,
            ),
            margin: const EdgeInsets.symmetric(vertical: paddingVertical),
            padding: const EdgeInsets.fromLTRB(
              paddingHorizontal / 3,
              paddingVertical / 2,
              paddingHorizontal,
              paddingVertical / 2,
            ),
            decoration: BoxDecoration(
              //color: Colors.amber,
              color: animationController.isCompleted
                  ? !answer.isGoodAnswer && answer.isSelected
                      ? colorRed.withOpacity(0.45)
                      : answer.isGoodAnswer
                          ? colorGreen.withOpacity(0.60)
                          : colorWhite
                  : answer.isSelected
                      ? colorYellow.withOpacity(0.35)
                      : colorWhite,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: colorBlue.withOpacity(0.1), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 5, // blur radius
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: animationController.isCompleted ? colorWhite : colorBlue.withOpacity(0.2),
                  ),
                  child: Center(
                    child: _buildLeading(),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: paddingHorizontal / 2),
                    child: AutoSizeText(
                      answer.answer,
                      maxLines: 4,
                      style: TextStyle(
                        color: animationController.isCompleted
                            ? answer.isGoodAnswer
                                ? colorWhite
                                : colorRed.withOpacity(0.8)
                            : colorDarkGray,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeading() {
    if (animationController.isCompleted) {
      return Icon(
        answer.isGoodAnswer ? Icons.check_rounded : Icons.clear_rounded,
        color: answer.isGoodAnswer ? colorGreen : colorRed,
        size: 30,
      );
    } else {
      return Text(
        index.toString(),
        style: const TextStyle(
          fontSize: fontSizeTitle / 1.5,
          color: colorBlue,
        ),
      );
    }
  }
}
