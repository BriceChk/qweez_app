import 'package:flutter/material.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';

class PresentGamePage extends StatefulWidget {
  final String qweezId;

  const PresentGamePage({Key? key, required this.qweezId}) : super(key: key);

  @override
  _PresentGamePageState createState() => _PresentGamePageState();
}

class _PresentGamePageState extends State<PresentGamePage> {
  final _qweezRepo = QweezRepository();

  Qweez? _qweez;

  //TODO Connect to socket.io, request room for qweezId, get back code, display QR, display playerlist + start btn
  //TODO Show answer / skip question button
  //TODO Leaderboard button on answer screen

  @override
  initState() {
    super.initState();

    _qweezRepo.get(widget.qweezId).then((value) {
      setState(() {
        if (value == null) {
          //TODO ID invalide
          return;
        }

        _qweez = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
