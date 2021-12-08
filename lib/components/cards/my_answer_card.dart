import 'package:flutter/material.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyAnswerCard extends StatelessWidget {
  final String text;
  final bool isTrue;
  final AnimationController animationController;

  const MyAnswerCard({
    Key? key,
    required this.text,
    required this.isTrue,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          //TODO Handle case mutliple choice or unique choice
          onTap: () {
            isSelected = !isSelected;
          },
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
                  ? !isTrue && isSelected
                      ? colorRed.withOpacity(0.45)
                      : isTrue
                          ? colorGreen.withOpacity(0.60)
                          : colorWhite
                  : isSelected
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
                      text,
                      maxLines: 4,
                      style: TextStyle(
                        color: animationController.isCompleted
                            ? isTrue
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
        isTrue ? Icons.check_rounded : Icons.clear_rounded,
        color: isTrue ? colorGreen : colorRed,
        size: 30,
      );
    } else {
      return const Text(
        'A',
        style: TextStyle(
          fontSize: fontSizeTitle / 1.5,
          color: colorBlue,
        ),
      );
    }
  }
}
