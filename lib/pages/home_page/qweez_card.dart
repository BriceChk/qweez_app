import 'package:flutter/material.dart';
import 'package:qweez_app/pages/home_page/qweez_bottom_sheet.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/qweez.dart';

class QweezCard extends StatelessWidget {
  final Qweez qweez;
  final int index;

  const QweezCard({Key? key, required this.qweez, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color buttonColor = index.isEven ? const Color(0xffF8E7C9) : const Color(0xff8D9CE2);
    Color iconColor = index.isEven ? colorBlack : colorWhite;
    Color containerColor = index.isEven ? colorYellow : colorBlue;
    Color? textColor = index.isOdd ? colorWhite : null;
    Color shadowColor = index.isEven ? colorYellow.withOpacity(0.2) : colorBlue.withOpacity(0.2);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(borderRadius), topLeft: Radius.circular(borderRadius)),
          ),
          context: context,
          builder: (context) => QweezBottomSheet(qweez: qweez),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: paddingVertical),
        padding: const EdgeInsets.fromLTRB(paddingHorizontal, paddingVertical, paddingHorizontal, 0),
        height: 120,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              qweez.name,
              style: TextStyle(
                fontSize: fontSizeSubtitle,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            Text(
              qweez.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSizeText,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: paddingVertical / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    qweez.questions.length.toString() + ' questions',
                    style: TextStyle(
                      fontSize: fontSizeText,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: buttonColor),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: iconColor,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
