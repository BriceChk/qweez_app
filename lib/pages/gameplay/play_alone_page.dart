import 'package:flutter/material.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';

class PlayAlonePage extends StatefulWidget {
  final String qweezId;

  const PlayAlonePage({Key? key, required this.qweezId}) : super(key: key);

  @override
  _PlayAlonePageState createState() => _PlayAlonePageState();
}

class _PlayAlonePageState extends State<PlayAlonePage> {
  final _qweezRepo = QweezRepository();

  Qweez? _qweez;

  //TODO Display qweez and finish with number of correct answers

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
