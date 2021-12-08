import 'package:flutter/material.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:qweez_app/main.dart';
import 'package:qweez_app/models/qweez.dart';

class QuestionsAppBar extends StatelessWidget implements PreferredSize {
  final Qweez qweez;

  const QuestionsAppBar({
    Key? key,
    required this.qweez,
  }) : super(key: key);

  @override
  Size get preferredSize => Size(double.infinity, 150 + MyApp.sizeNotificationBar);

  @override
  Widget get child => Container(
        color: colorBlue.withOpacity(0.9),
        padding: const EdgeInsets.only(top: paddingVertical * 2),
        child: Stack(
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
                  qweez.questions[0].question,
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
                padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal * 1.5, vertical: paddingVertical / 2),
                decoration: BoxDecoration(
                  color: colorYellow,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Text(
                  'Question ' + qweez.questions.indexOf(qweez.questions[0]).toString(),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
