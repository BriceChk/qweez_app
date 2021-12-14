import 'package:flutter/material.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/player.dart';

class MyRankingCard extends StatelessWidget {
  final Player member;
  final int numberOfQuestions;
  final String? username;
  final int rank;

  const MyRankingCard({
    Key? key,
    required this.member,
    required this.numberOfQuestions,
    required this.rank,
    this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: paddingVertical * 1.5),
      padding: const EdgeInsets.only(right: paddingVertical),
      height: 50,
      decoration: BoxDecoration(
        color: username == member.username ? colorYellow : colorWhite,
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
                member.username,
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
              member.score.toString() + ' / ' + numberOfQuestions.toString(),
              style: const TextStyle(
                color: colorBlue,
                fontSize: fontSizeText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
