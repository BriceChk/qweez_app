import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qweez_app/components/appbar/classic_appbar.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/gameplay/questions/player_list_widget.dart';
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
  List<String> _playerList = [];

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
        _initSocket();
      });
    });
  }

  void _initSocket() {
    _socket = io('http://localhost:3000', OptionBuilder().setTransports(['websocket']).build());
    _socket.emit('request-room', {'qweezId': _qweez!.id});

    _socket.on('room-created', (data) {
      setState(() {
        _gameCode = data['gameCode'];
        _url = data['url'];
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
  }

  @override
  void dispose() {
    _socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameCode == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: ClassicAppbar(title: _qweez != null ? _qweez!.name : "Join the game"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var qrSize = MediaQuery.of(context).size.width / 2 - paddingHorizontal;
    var maxSize = MediaQuery.of(context).size.height - 350;
    return Row(
      children: [
        Expanded(
          child: Column(
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
                          //TODO Start game
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
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: PlayerList(playerList: _playerList),
          ),
        ),
      ],
    );
  }
}
