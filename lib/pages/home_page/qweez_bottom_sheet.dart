import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';

class QweezBottomSheet extends StatelessWidget {
  final Qweez qweez;
  final QweezRepository _qweezRepo = QweezRepository();

  QweezBottomSheet({Key? key, required this.qweez}) : super(key: key);

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
                qweez.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizeSubtitle,
                ),
              ),
            ),
            if (qweez.questions.isNotEmpty)
              QweezOption(
                text: 'Play alone',
                icon: const Icon(
                  Icons.play_circle_fill_rounded,
                  color: colorYellow,
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.beamToNamed('/qweez/${qweez.id}/play');
                },
              ),
            if (qweez.questions.isNotEmpty)
              QweezOption(
                text: 'Present online',
                icon: const Icon(
                  Icons.qr_code,
                  color: colorYellow,
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.beamToNamed('/qweez/${qweez.id}/present');
                },
              ),
            QweezOption(
              text: 'Edit',
              icon: const Icon(
                Icons.edit,
                color: colorBlue,
              ),
              onTap: () {
                Navigator.pop(context);
                Beamer.of(context).beamToNamed('/qweez/${qweez.id!}/edit');
              },
            ),
            QweezOption(
              text: 'Delete',
              icon: const Icon(
                Icons.delete,
                color: colorRed,
              ),
              onTap: () {
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    Navigator.pop(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius / 1.5),
          ),
          title: Text("Do you want to delete the Qweez '${qweez.name}' ?"),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                  colorBlue.withOpacity(0.15),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: fontSizeText,
                  color: colorBlue,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                  colorRed.withOpacity(0.15),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: fontSizeText,
                  color: colorRed,
                ),
              ),
              onPressed: () {
                _qweezRepo.remove(qweez);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
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
