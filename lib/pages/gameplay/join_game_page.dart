import 'package:flutter/material.dart';
import 'package:qweez_app/components/appbar/classic_appbar.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/gameplay/questions/player_list_widget.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';
import 'package:socket_io_client/socket_io_client.dart';

class JoinGamePage extends StatefulWidget {
  final String gameCode;

  const JoinGamePage({Key? key, required this.gameCode}) : super(key: key);

  @override
  _JoinGamePageState createState() => _JoinGamePageState();
}

//TODO Connect to socket.io, get game info, react to events, send answers to socket

class _JoinGamePageState extends State<JoinGamePage> {
  final _qweezRepo = QweezRepository();
  final _formKey = GlobalKey<FormState>();

  String _usernameInput = '';
  String _username = '';
  String _errorText = '';
  late Socket _socket;

  bool _gamePlaying = false;

  List<String> _playerList = [];

  Qweez? _qweez;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _socket = io('http://localhost:3000', OptionBuilder().setTransports(['websocket']).build());

    _socket.on('qweez-id', (data) {
      _qweezRepo.get(data['qweezId']).then((value) {
        if (value == null) {
          //TODO Alert + go home
          return;
        }
        setState(() {
          _qweez = value;
        });
      });
    });

    _socket.on('player-joined', (data) {
      setState(() {
        _playerList = List<String>.from(data['usernames']);
      });
    });
    _socket.on('player-left', (data) {
      setState(() {
        _playerList.remove(data['username']);
      });
    });

    //TODO Game events

    _socket.on('username-already-taken', (data) {
      print('username taken');
      setState(() {
        _username = '';
        _errorText = 'This username is already taken';
      });
    });
    _socket.on('unknown-room', (data) {
      print('unknown room');
      //TODO Alert + go home
    });
    _socket.on('game-already-started', (data) {
      print('already started');
      //TODO Alert + go home
    });
    _socket.on('game-host-quit', (data) {
      print('host quit');
      //TODO Alert + go home
    });
  }

  @override
  void dispose() {
    _socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ClassicAppbar(title: _qweez != null ? _qweez!.name : "Join the game"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_username.isEmpty) {
      return Container(
        color: colorWhite,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: paddingVertical),
                    child: Text(
                      'Choose a username',
                      style: TextStyle(
                        fontSize: fontSizeSubtitle,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyTextFormField(
                          hintText: 'Username',
                          textInputAction: TextInputAction.done,
                          valueText: '',
                          validator: (username) {
                            if (username!.isEmpty) {
                              return 'Please enter your username';
                            }
                          },
                          onChanged: (input) => _usernameInput = input,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: paddingVertical),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _username = _usernameInput;
                                });
                                _socket.emit('join-room', {'gameCode': widget.gameCode, 'username': _username});
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                              child: Text('Join'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: paddingVertical),
                    height: 50,
                    child: Text(
                      _errorText,
                      style: const TextStyle(color: colorRed),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 60,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorYellow.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              top: 80,
              right: -20,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorYellow.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: -80,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorBlue.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              right: -70,
              bottom: -30,
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorBlue.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              left: 60,
              bottom: 50,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorYellow.withOpacity(0.2),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_qweez == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_gamePlaying) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: paddingVertical),
              child: Center(
                child: Text(
                  'The Qweez will start soon...',
                  style: TextStyle(fontSize: fontSizeSubtitle),
                ),
              ),
            ),
            PlayerList(playerList: _playerList),
          ],
        ),
      );
    }

    //TODO The game
    return const Text('PLAYING');
  }
}
