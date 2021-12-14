import 'package:flutter/material.dart';
import 'package:qweez_app/components/appbar/classic_appbar.dart';

class JoinGamePage extends StatefulWidget {
  final String gameCode;

  const JoinGamePage({Key? key, required this.gameCode}) : super(key: key);

  @override
  _JoinGamePageState createState() => _JoinGamePageState();
}

//TODO Connect to socket.io, get game info, react to events, send answers to socket

class _JoinGamePageState extends State<JoinGamePage> {
  String _username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ClassicAppbar(title: "Join the game"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_username.isEmpty) {
      //TODO Choose username page
      return Container();
    }

    return Container();
  }
}
