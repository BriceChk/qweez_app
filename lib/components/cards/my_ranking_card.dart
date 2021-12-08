import 'package:flutter/material.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/models/member.dart';
import 'package:qweez_app/models/questionnaire.dart';

class MyRankingCard extends StatelessWidget {
  final Member member;
  final Questionnaire questionnaire;
  final int rank;

  const MyRankingCard({
    Key? key,
    required this.member,
    required this.questionnaire,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: paddingVertical * 1.5),
      padding: const EdgeInsets.only(right: paddingVertical),
      height: 50,
      decoration: BoxDecoration(
        color: colorWhite,
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
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: colorBlue,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  color: colorYellow,
                  fontSize: fontSizeSubtitle,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: paddingVertical),
              child: Text(
                member.userName,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: const TextStyle(
                  color: colorBlack,
                  fontSize: fontSizeText,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: paddingVertical),
            child: Text(
              member.score.toString() + ' / ' + questionnaire.questions.length.toString(),
              style: const TextStyle(
                color: colorYellow,
                fontSize: fontSizeText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
