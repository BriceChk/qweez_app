import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qweez_app/components/appbar/classic_appbar.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants.dart';

class JoinGamePage extends StatefulWidget {
  final String gameCode;

  const JoinGamePage({Key? key, required this.gameCode}) : super(key: key);

  @override
  _JoinGamePageState createState() => _JoinGamePageState();
}

//TODO Connect to socket.io, get game info, react to events, send answers to socket

class _JoinGamePageState extends State<JoinGamePage> {
  final _formKey = GlobalKey<FormState>();

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
                          onChanged: (username) {
                            _username = username;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: paddingVertical),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // TODO push à la waiting page
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

    return Container();
  }
}
