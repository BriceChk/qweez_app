import 'package:flutter/material.dart';
import 'package:qweez_app/components/cards/my_ranking_card.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/player.dart';
import 'package:qweez_app/pages/responsive.dart';

class RankingWidget extends StatelessWidget {
  final List<Player> playerList;
  final int numberOfQuestions;
  final String? username;

  const RankingWidget({
    Key? key,
    required this.playerList,
    required this.numberOfQuestions,
    this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    playerList.sort((a, b) => b.score.compareTo(a.score));

    return Container(
      color: colorWhite,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    vertical: paddingVertical,
                    horizontal: paddingHorizontal,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isMobile(context)
                          ? 1
                          : Responsive.isTablet(context)
                              ? 2
                              : 3,
                      mainAxisExtent: 75, // Card height (100) + Padding vertical
                      crossAxisSpacing: paddingHorizontal,
                      mainAxisSpacing: paddingVertical),
                  children: playerList.map((member) {
                    int index = playerList.indexOf(member);

                    return MyRankingCard(
                      member: member,
                      numberOfQuestions: numberOfQuestions,
                      rank: index + 1,
                      username: username,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
