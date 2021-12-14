import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/question.dart';

class QuestionAppBar extends StatelessWidget implements PreferredSize {
  final Question question;
  final String qweezTitle;
  final int index;

  const QuestionAppBar({
    Key? key,
    required this.question,
    required this.index,
    required this.qweezTitle,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size(double.infinity, 230);

  @override
  Widget get child => Container(
        color: colorBlue.withOpacity(0.9),
        padding: const EdgeInsets.only(top: paddingVertical * 2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: paddingVertical, left: paddingHorizontal, right: paddingHorizontal),
              child: Text(
                qweezTitle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: const TextStyle(
                  color: colorWhite,
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Stack(
              children: [
                // Scanning and enter code + title container
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(top: paddingVertical * 2),
                  padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical * 2),
                  decoration: const BoxDecoration(
                    color: colorBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 130,
                      minHeight: 50,
                    ),
                    child: AutoSizeText(
                      question.question,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: fontSizeTitle,
                        color: colorWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: paddingVertical,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: paddingHorizontal * 1.5, vertical: paddingVertical / 2),
                    decoration: BoxDecoration(
                      color: colorYellow,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Text(
                      'Question ' + (index + 1).toString(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
