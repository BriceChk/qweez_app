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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: paddingHorizontal / 2),
              child: InkWell(
                highlightColor: colorBlue.withOpacity(0.1),
                splashColor: colorBlue.withOpacity(0.25),
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: () {
                  Beamer.of(context).beamToNamed('/editQuestionnaire/${qweez.id!}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2, horizontal: paddingHorizontal / 2),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit,
                        color: colorBlue,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingHorizontal / 2),
                        child: Text(
                          'Edit the Qweez',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: fontSizeSubtitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: paddingHorizontal / 2,
              ),
              child: InkWell(
                highlightColor: colorYellow.withOpacity(0.1),
                splashColor: colorYellow.withOpacity(0.25),
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: () {
                  Navigator.pop(context);
                  showPickUsername(context, qweez.id!);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: paddingVertical / 2,
                    horizontal: paddingHorizontal / 2,
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.play_circle_fill_rounded,
                        color: colorYellow,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingHorizontal / 2),
                        child: Text(
                          'Start the Qweez',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: fontSizeSubtitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
