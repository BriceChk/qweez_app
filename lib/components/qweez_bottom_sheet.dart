import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/choose_playername_modal.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/models/qweez.dart';

class QweezBottomSheet extends StatelessWidget {
  final Qweez qweez;

  const QweezBottomSheet({Key? key, required this.qweez}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: paddingVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: paddingVertical,
                left: paddingHorizontal,
                right: paddingHorizontal,
              ),
              child: Text(
                'Qweez: ${qweez.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizeSubtitle,
                ),
              ),
            ),
            QweezOption(
              text: 'Start',
              icon: const Icon(
                Icons.play_circle_fill_rounded,
                color: colorYellow,
              ),
              onTap: () {
                Navigator.pop(context);
                showPickUsername(context, qweez.id!);
              },
            ),
            QweezOption(
              text: 'Edit',
              icon: const Icon(
                Icons.edit,
                color: colorBlue,
              ),
              onTap: () {
                Beamer.of(context).beamToNamed('/editQuestionnaire/${qweez.id!}');
              },
            ),
            QweezOption(
              text: 'Delete',
              icon: const Icon(
                Icons.delete,
                color: colorRed,
              ),
              onTap: () {
                //TODO
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QweezOption extends StatelessWidget {
  const QweezOption({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final Icon icon;
  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: paddingHorizontal / 2,
      ),
      child: InkWell(
        highlightColor: colorYellow.withOpacity(0.1),
        splashColor: colorYellow.withOpacity(0.25),
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: paddingVertical / 2,
            horizontal: paddingHorizontal / 2,
          ),
          child: Row(
            children: [
              icon,
              Padding(
                padding: const EdgeInsets.only(left: paddingHorizontal / 2),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: fontSizeSubtitle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
