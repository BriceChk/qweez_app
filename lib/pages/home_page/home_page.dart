import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qweez_app/pages/home_page/qweez_card.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/main.dart';
import 'package:qweez_app/models/qweez.dart';
import 'package:qweez_app/pages/home_page/home_page_appbar.dart';
import 'package:qweez_app/pages/responsive.dart';
import 'package:qweez_app/repository/questionnaire_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _questionnaireRepository = QweezRepository();

  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? _result;
  QRViewController? _qrController;
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  List<Qweez> _qweezList = [];

  bool get _loggedIn => MyApp.user != null;
  var _isLoaded = false;

  @override
  void initState() {
    super.initState();

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
      _questionnaireRepository.getUserQweezes(MyApp.user!.uid).then((value) {
        setState(() {
          _qweezList = value;
          _isLoaded = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getData();

    return Container(
      color: colorBlue,
      child: SafeArea(
        child: Scaffold(
          appBar: HomePageAppBar(
            onQrCodeTap: () {
              _showQrCodeDialog(context);
            },
            context: context,
          ),
          body: _getBody(),
          floatingActionButton: _loggedIn
              ? FloatingActionButton(
                  backgroundColor: colorYellow,
                  onPressed: () {
                    Beamer.of(context).beamToNamed('/create-qweez');
                  },
                  tooltip: 'Create a Qweez',
                  child: const Icon(
                    Icons.add,
                    color: colorBlack,
                    size: 30,
                  ),
                )
              : null,
        ),
      ),
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
                alignment: _loggedIn && _qweezList.isEmpty ? Alignment.center : Alignment.topCenter,
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
        return _qweezList.isEmpty ? _noQweezContent() : _loggedInContent(_qweezList);
      } else {
        return CircularProgressIndicator(
          valueColor: _colorTween,
        );
      }
    } else {
      return _notLoggedInContent();
    }
  }

  Widget _noQweezContent() {
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

  Widget _loggedInContent(List<Qweez> listQuestionnaire) {
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

              return QweezCard(qweez: questionnaire, index: index);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _notLoggedInContent() {
    final List<Qweez> _listFakeQuestionnaire = [
      for (var i = 0; i < 3; i++)
        Qweez(
          userId: 'userId',
          name: 'name',
          description: 'description',
          questions: [],
        ),
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

                  return QweezCard(qweez: questionnaire, index: index);
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
                      color: colorLightGray.withOpacity(0.75),
                      borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
                      border: Border.all(
                        color: colorWhite.withOpacity(0.40),
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
                onQRViewCreated: (controller) {
                  setState(() {
                    _qrController = controller;
                  });
                  controller.scannedDataStream.listen((scanData) {
                    setState(() {
                      _result = scanData;
                      if (_result != null) {
                        if (_result!.code!.contains('qweez-app.web.app/play/')) {
                          Navigator.pop(context);
                          controller.pauseCamera();
                          var id = _result!.code!.split("qweez-app.web.app/play/")[1];
                          context.beamToNamed('/play/$id');
                        }
                      }
                      controller.resumeCamera();
                    });
                  });
                },
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

  @override
  void dispose() {
    if (_qrController != null) {
      _qrController!.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }
}
