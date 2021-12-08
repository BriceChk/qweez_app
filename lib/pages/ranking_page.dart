import 'package:flutter/material.dart';
import 'package:qweez_app/components/appbar/classic_appbar.dart';
import 'package:qweez_app/components/cards/my_ranking_card.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/models/player.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/responsive.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ClassicAppbar(title: 'Ranking'),
      body: _getBody(context),
    );
  }

  Widget _getBody(BuildContext context) {
    var _listMembers = [
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
      Player(userName: 'XxJackiexX', score: 5),
      Player(userName: 'Timothé', score: 2),
      Player(userName: 'Jack'),
      Player(userName: 'test', score: 3),
    ];

    _listMembers.sort((a, b) => b.score.compareTo(a.score));

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
                  children: _listMembers.map((member) {
                    int rank = _listMembers.indexOf(member);

                    return MyRankingCard(
                      member: member,
                      qweez: Qweez(questions: [], userId: '', name: '', description: ''),
                      rank: rank + 1,
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
