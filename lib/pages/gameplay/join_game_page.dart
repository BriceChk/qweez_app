import 'package:flutter/material.dart';

class JoinGamePage extends StatefulWidget {
  final String gameCode;

  const JoinGamePage({Key? key, required this.gameCode}) : super(key: key);

  @override
  _JoinGamePageState createState() => _JoinGamePageState();
}

//TODO Connect to socket.io, get game info, react to events, send answers to socket

class _JoinGamePageState extends State<JoinGamePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
