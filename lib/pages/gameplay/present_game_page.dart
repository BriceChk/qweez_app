import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qweez_app/components/appbar/classic_appbar.dart';
import 'package:qweez_app/components/ranking_page.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/player.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/error_page.dart';
import 'package:qweez_app/pages/gameplay/questions/player_list_widget.dart';
import 'package:qweez_app/pages/gameplay/questions/question_widget.dart';
import 'package:qweez_app/pages/responsive.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PresentGamePage extends StatefulWidget {
  final String qweezId;

  const PresentGamePage({Key? key, required this.qweezId}) : super(key: key);

  @override
  _PresentGamePageState createState() => _PresentGamePageState();
}

class _PresentGamePageState extends State<PresentGamePage> {
  final _qweezRepo = QweezRepository();

  Qweez? _qweez;

  late Socket _socket;

  String? _gameCode, _url;
  List<Player> _playerList = [];

  bool _hasError = false;
  bool _gamePlaying = false;

  int _currentQuestionIndex = 0;

  @override
  initState() {
    super.initState();

    _qweezRepo.get(widget.qweezId).then((value) {
      setState(() {
        if (value == null) {
          _hasError = true;
          return;
        }

        _qweez = value;
        _initSocket();
      });
    });
  }

  void _initSocket() {
    _socket = io(socketIoHost, OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());
    _socket.connect();
    _socket.emit('request-room', {'qweezId': _qweez!.id});

    _socket.on('room-created', (data) {
      setState(() {
        _gameCode = data['gameCode'];
        _url = data['url'];
      });
    });

    _socket.on('player-joined', (data) {
      setState(() {
        _playerList = List.from(data['players']).map((e) => Player.fromJson(e)).toList();
      });
    });
    _socket.on('player-left', (data) {
      setState(() {
        _playerList.removeWhere((element) => element.username == data['username']);
      });
    });

    _socket.on('status-update', (data) {
      setState(() {
        _gamePlaying = data['status'] == 'playing';
        _currentQuestionIndex = data['questionIndex'];
      });
    });

    _socket.on('player-list', (data) {
      setState(() {
        _playerList = List.from(data['players']).map((e) => Player.fromJson(e)).toList();
      });
    });
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const ErrorPage(message: '404: Qweez not found.');
    }

    if (_gameCode == null) {
      return Scaffold(
        appBar: ClassicAppbar(title: _qweez != null ? _qweez!.name : "Join the game"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_gamePlaying) {
      return Scaffold(
        appBar: ClassicAppbar(title: _qweez != null ? _qweez!.name : "Join the game"),
        body: _buildWaitingContent(),
      );
    }

    if (_currentQuestionIndex == _qweez!.questions.length) {
      return Scaffold(
        appBar: ClassicAppbar(title: _qweez != null ? _qweez!.name : "Join the game"),
        body: RankingWidget(playerList: _playerList, numberOfQuestions: _qweez!.questions.length),
      );
    }

    return QuestionWidget(
      key: ValueKey(_currentQuestionIndex),
      question: _qweez!.questions[_currentQuestionIndex],
      index: _currentQuestionIndex,
      qweez: _qweez!,
      playerList: _playerList,
      canSelect: false,
      onNextQuestion: () {
        setState(() {
          _socket.emit('next-question');
        });
      },
      onFinished: (goodAnswer) {
        _socket.emit('show-result');
      },
    );
  }

  Widget _buildWaitingContent() {
    return Flex(
      direction: Responsive.isDesktop(context) ? Axis.horizontal : Axis.vertical,
      children: [
        if (Responsive.isDesktop(context))
          Expanded(
            child: _buildQr(),
          ),
        if (!Responsive.isDesktop(context)) _buildQr(),
        Expanded(
          child: SingleChildScrollView(
            child: PlayerList(playerList: _playerList),
          ),
        ),
      ],
    );
  }

  Widget _buildQr() {
    var qrSize = MediaQuery.of(context).size.width / 2 - paddingHorizontal;
    var maxSize = MediaQuery.of(context).size.height - 350;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: paddingVertical),
          child: Text(
            'Qweez Code: ${_gameCode!}',
            style: const TextStyle(
              fontSize: fontSizeTitle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: paddingVertical),
          child: Container(
            width: qrSize,
            height: qrSize,
            constraints: BoxConstraints(maxWidth: maxSize, maxHeight: maxSize),
            child: QrImage(
              data: _url!,
              version: QrVersions.auto,
              size: qrSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: paddingVertical),
          child: Text(_url!),
        ),
        Container(
          padding: const EdgeInsets.only(top: paddingVertical),
          width: 200,
          child: ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorYellow)),
            onPressed: _playerList.isEmpty
                ? null
                : () {
                    _socket.emit('start-game');
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  AutoSizeText(
                    "Let's start",
                    style: TextStyle(
                      color: colorBlack,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: paddingVertical / 2),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: colorBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
