import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/appbar/home_page_appbar.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:beamer/beamer.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qweez_app/main.dart';
import 'package:qweez_app/models/questionnaire.dart';
import 'package:qweez_app/pages/responsive.dart';
import 'package:qweez_app/services/repository/questionnaire_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _questionnaireRepository = QuestionnaireRepository();

  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? _result;
  QRViewController? _qrController;
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  List<Questionnaire> _listQuestionnaire = [];

  bool get _loggedIn => MyApp.user != null;
  var _isLoaded = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _colorTween = _animationController.drive(
      ColorTween(
        begin: colorBlue,
        end: colorYellow,
      ),
    );
    _animationController.repeat(reverse: true);

    super.initState();
  }

/*  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      _qrController!.resumeCamera();
    }
  }*/

  void _getData() {
    if (_loggedIn) {
      _getQuestionnaires(MyApp.user!.uid);
    }
  }

  void _getQuestionnaires(String userId) async {
    _listQuestionnaire = await _questionnaireRepository.getQuestionnairesByUserId(userId);
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    MyApp.sizeNotificationBar = MediaQuery.of(context).padding.top;

    // TODO trouver une solution pour ca
    _getData();

    return Scaffold(
      appBar: HomePageAppBar(
        onTap: () {
          _showQrCodeDialog(context);
        },
        setState: () {
          setState(() {});
        },
      ),
      body: _getBody(),
      floatingActionButton: _loggedIn
          ? FloatingActionButton(
              backgroundColor: colorYellow,
              onPressed: () {
                Beamer.of(context).beamToNamed('/creationQuestionnaire');
              },
              tooltip: 'Create a Qweez',
              child: const Icon(
                Icons.add,
                color: colorBlack,
                size: 30,
              ),
            )
          : null,
    );
  }

  Widget _getBody() {
    return Container(
      color: colorWhite,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Align(
                alignment: _loggedIn && _listQuestionnaire.isEmpty ? Alignment.center : Alignment.topCenter,
                child: _buildContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loggedIn) {
      if (_isLoaded) {
        return _listQuestionnaire.isEmpty ? noQuestionnaireContent() : loggedContent(_listQuestionnaire);
      } else {
        return CircularProgressIndicator(
          valueColor: _colorTween,
        );
      }
    } else {
      return loginContent();
    }
  }

  Widget noQuestionnaireContent() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: paddingVertical,
        horizontal: paddingHorizontal,
      ),
      child: Text(
        "You don't have any Qweez.\n\nStart now by clicking on the '+' button.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSizeSubtitle,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget loggedContent(List<Questionnaire> listQuestionnaire) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: paddingVertical),
            child: Text(
              'My Qweezes',
              style: TextStyle(
                fontSize: fontSizeSubtitle,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          GridView(
            physics: const NeverScrollableScrollPhysics(),
            primary: true,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: paddingVertical),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isMobile(context)
                  ? 1
                  : Responsive.isTablet(context)
                      ? 2
                      : 3,
              mainAxisExtent: 130, // Card height (100) + Padding vertical
              crossAxisSpacing: paddingHorizontal,
            ),
            children: listQuestionnaire.map((questionnaire) {
              int index = listQuestionnaire.indexOf(questionnaire);

              return cardQuestionnaire(questionnaire, index);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget cardQuestionnaire(Questionnaire questionnaire, int index) {
    Color buttonColor = index.isEven ? const Color(0xffF8E7C9) : const Color(0xff8D9CE2);
    Color iconColor = index.isEven ? colorBlack : colorWhite;
    Color containerColor = index.isEven ? colorYellow : colorBlue;
    Color? textColor = index.isOdd ? colorWhite : null;
    Color shadowColor = index.isEven ? colorYellow.withOpacity(0.2) : colorBlue.withOpacity(0.2);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(borderRadius), topLeft: Radius.circular(borderRadius)),
          ),
          context: context,
          builder: (context) => _showEditOrLaunch(questionnaire),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: paddingVertical),
        padding: const EdgeInsets.fromLTRB(paddingHorizontal, paddingVertical, paddingHorizontal, 0),
        height: 120,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionnaire.name,
              style: TextStyle(
                fontSize: fontSizeSubtitle,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            Text(
              questionnaire.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSizeText,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: paddingVertical / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    questionnaire.questions.length.toString() + ' questions',
                    style: TextStyle(
                      fontSize: fontSizeText,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: buttonColor),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: iconColor,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginContent() {
    final List<Questionnaire> _listFakeQuestionnaire = [
      Questionnaire(
        userId: 'userId',
        name: 'name',
        description: 'description',
        questions: [],
      ),
      Questionnaire(
        userId: 'userId',
        name: 'name',
        description: 'description',
        questions: [],
      ),
      Questionnaire(
        userId: 'userId',
        name: 'name',
        description: 'description',
        questions: [],
      )
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height - 256 - MediaQuery.of(context).padding.top,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isMobile(context)
                      ? 1
                      : Responsive.isTablet(context)
                          ? 2
                          : 3,
                  mainAxisExtent: 130, // Card height (100) + Padding vertical
                  crossAxisSpacing: paddingHorizontal,
                ),
                children: _listFakeQuestionnaire.map((questionnaire) {
                  int index = _listFakeQuestionnaire.indexOf(questionnaire);

                  return cardQuestionnaire(questionnaire, index);
                }).toList(),
              ),
            ),
          ),
          Column(
            children: [
              GlassmorphicFlexContainer(
                borderRadius: 0,
                blur: 5,
                alignment: Alignment.bottomCenter,
                border: 0,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorWhite.withOpacity(0.05),
                    colorWhite.withOpacity(0.05),
                  ],
                ),
                borderGradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical * 2),
                    decoration: BoxDecoration(
                      color: colorLightGray.withOpacity(0.25),
                      borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
                      border: Border.all(
                        color: colorWhite.withOpacity(0.25),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'You are not logged in.\nLog in if you want to create your own Qweez!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSizeSubtitle,
                          ),
                        ),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.only(top: paddingVertical),
                          width: double.maxFinite,
                          child: ElevatedButton(
                            key: GlobalKey(),
                            child: const Text('Log in'),
                            onPressed: () {
                              Beamer.of(context).beamToNamed('/login');
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showEditOrLaunch(Questionnaire questionnaire) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: paddingVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: paddingVertical,
                left: paddingHorizontal,
                right: paddingHorizontal,
              ),
              child: Text(
                'Qweez: ${questionnaire.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizeSubtitle,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: paddingHorizontal / 2),
              child: InkWell(
                highlightColor: colorBlue.withOpacity(0.1),
                splashColor: colorBlue.withOpacity(0.25),
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: () {
                  Beamer.of(context).beamToNamed('/editQuestionnaire/${questionnaire.id!}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2, horizontal: paddingHorizontal / 2),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit,
                        color: colorBlue,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingHorizontal / 2),
                        child: Text(
                          'Edit the Qweez',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: fontSizeSubtitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: paddingHorizontal / 2,
              ),
              child: InkWell(
                highlightColor: colorYellow.withOpacity(0.1),
                splashColor: colorYellow.withOpacity(0.25),
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: () {
                  Navigator.pop(context);
                  _showPickUsername(questionnaire.id!);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: paddingVertical / 2,
                    horizontal: paddingHorizontal / 2,
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.play_circle_fill_rounded,
                        color: colorYellow,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: paddingHorizontal / 2),
                        child: Text(
                          'Start the Qweez',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: fontSizeSubtitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showPickUsername(String id) {
    var _formKey = GlobalKey<FormState>();
    var _username = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius / 1.5),
          ),
          insetPadding: EdgeInsets.zero,
          title: const Text(
            'Choose a username',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontSizeSubtitle,
            ),
          ),
          content: Form(
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
                        Beamer.of(context).beamToNamed('/questionPresenterWaiting/$id/$_username');
                      }
                    },
                    child: const Text('Validate'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showQrCodeDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius / 1.5),
          ),
          insetPadding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius / 1.5),
            child: SizedBox(
              height: 250,
              width: 250,
              child: QRView(
                key: _qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: colorYellow,
                  borderRadius: borderRadius / 2,
                  borderLength: 30,
                  borderWidth: 10,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _result = scanData;
        if (_result != null) {
          if (_result!.code!.contains('QweezApp')) {
            controller.pauseCamera();
            var id = _result!.code!.split("QweezApp-");
            _showPickUsername(id.last);
          }
        }
        controller.resumeCamera();
      });
    });
  }

  @override
  void dispose() {
    _qrController!.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
