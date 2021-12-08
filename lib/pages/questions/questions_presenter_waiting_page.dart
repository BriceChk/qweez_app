import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/appbar/classic_appbar.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/main.dart';
import 'package:qweez_app/models/member.dart';
import 'package:qweez_app/models/questionnaire.dart';
import 'package:qweez_app/pages/launch_page.dart';
import 'package:qweez_app/pages/responsive.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:beamer/beamer.dart';
import 'package:qweez_app/services/repository/questionnaire_repository.dart';
import 'package:auto_size_text/auto_size_text.dart';

class QuestionsPresenterWaitingPage extends StatefulWidget {
  final String username;
  final String questionnaireId;

  const QuestionsPresenterWaitingPage({
    Key? key,
    required this.username,
    required this.questionnaireId,
  }) : super(key: key);

  @override
  State<QuestionsPresenterWaitingPage> createState() => _QuestionsPresenterWaitingPageState();
}

class _QuestionsPresenterWaitingPageState extends State<QuestionsPresenterWaitingPage> {
  final _questionnaireRepository = QuestionnaireRepository();

  Questionnaire? _questionnaire;

  String _presenterId = '';

  @override
  initState() {
    super.initState();
    if (MyApp.userCredential != null) {
      _presenterId = MyApp.userCredential!.user!.uid;
    }

    _getData();
  }

  Future<void> _getData() async {
    _questionnaire = await _questionnaireRepository.getQuestionnairesById(widget.questionnaireId);

    setState(() {
      // TODO check pour mettre la bdd en accord
      for (int i = 0; i < 40; i++) {
        _questionnaire!.members.add(
          Member(userName: widget.username),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questionnaire == null) {
      return const LaunchPage();
    }

    return Scaffold(
      appBar: const ClassicAppbar(title: 'Waiting for all the players'),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Container(
      color: colorWhite,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_presenterId == _questionnaire!.userId) _buildButtonsPresenter(),
                  GridView(
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
                    children: _questionnaire!.members.map((member) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal / 2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: colorBlue.withOpacity(0.1),
                        ),
                        child: Text(
                          member.userName,
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsPresenter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal / 2, vertical: paddingVertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: paddingVertical / 2),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorBlue)),
              onPressed: () {
                _showQrCode();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
                child: Row(
                  children: const [
                    AutoSizeText(
                      "QR Code",
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: paddingVertical / 2),
                      child: Icon(
                        Icons.qr_code,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: paddingVertical / 2),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorYellow)),
              onPressed: () {
                Beamer.of(context).beamToNamed('/question/${widget.questionnaireId}');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
                child: Row(
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
    );
  }

  Future<void> _showQrCode() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        var size = Responsive.isDesktop(context) ? 500.0 : 250.0;
        return AlertDialog(
          content: SizedBox(
            width: size,
            height: size,
            child: QrImage(
              data: "QweezApp-${widget.questionnaireId}",
              version: QrVersions.auto,
              size: size,
            ),
          ),
        );
      },
    );
  }
}
