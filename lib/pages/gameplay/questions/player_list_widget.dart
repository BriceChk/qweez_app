import 'package:flutter/material.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/pages/responsive.dart';

class PlayerList extends StatelessWidget {
  final List<String> playerList;
  const PlayerList({Key? key, required this.playerList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(
        vertical: paddingVertical,
        horizontal: paddingHorizontal,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
          mainAxisExtent: 40, // Card height (100) + Padding vertical
          crossAxisSpacing: paddingHorizontal,
          mainAxisSpacing: paddingVertical),
      children: playerList.map((player) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal / 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: colorBlue.withOpacity(0.1),
          ),
          child: Text(
            player,
            overflow: TextOverflow.fade,
            softWrap: false,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(
              fontSize: fontSizeSubtitle,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
