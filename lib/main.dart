import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/pages/qweez_edit/edit_qweez_page.dart';
import 'package:qweez_app/pages/home_page/home_page.dart';
import 'package:qweez_app/pages/launch_page.dart';
import 'package:qweez_app/pages/login_page.dart';
import 'package:qweez_app/pages/questions/questions_page.dart';
import 'package:qweez_app/pages/questions/questions_presenter_waiting_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set the orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static User? user;

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() => MyApp.user = user);
    });
  }

  // Define the location of our routes
  final _routerDelegate = BeamerDelegate(
    initialPath: '/',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => const BeamPage(
              key: ValueKey('home'),
              child: HomePage(),
            ),
        '/launch': (context, state, data) => const BeamPage(
              key: ValueKey('launch'),
              child: LaunchPage(),
            ),
        '/create-qweez': (context, state, data) => const BeamPage(
              key: ValueKey('create-qweez'),
              child: EditQweezPage(),
              type: BeamPageType.cupertino,
            ),
        '/qweez/:qweezId/edit': (context, state, data) {
          final qweezId = state.pathParameters['qweezId']!;
          return BeamPage(
            key: ValueKey('qweez-edit-$qweezId'),
            type: BeamPageType.cupertino,
            child: EditQweezPage(qweezId: qweezId),
          );
        },
        '/qweez/:qweezId/present': (context, state, data) {
          final qweezId = state.pathParameters['qweezId']!;
          return BeamPage(
            key: ValueKey('qweez-present-$qweezId'),
            child: PresentQweezPage(
              qweezId: qweezId,
            ),
            type: BeamPageType.cupertino,
          );
        },
        '/qweez/:qweezId/play': (context, state, data) {
          final qweezId = state.pathParameters['qweezId']!;
          return BeamPage(
            key: ValueKey('qweez-play-$qweezId'),
            child: const Questionpage(),
            type: BeamPageType.cupertino,
          );
        },
        '/play/:code': (context, state, data) {
          final code = state.pathParameters['code']!;
          return BeamPage(
            key: ValueKey('qweez-join-$code'),
            child: const Questionpage(),
            type: BeamPageType.cupertino,
          );
        },
        '/login': (context, state, data) => const BeamPage(
              key: ValueKey('login'),
              child: LoginPage(),
              type: BeamPageType.cupertino,
            ),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BeamerProvider(
      routerDelegate: _routerDelegate,
      child: MaterialApp.router(
        title: 'Qweez',
        debugShowCheckedModeBanner: false,
        routerDelegate: _routerDelegate,
        routeInformationParser: BeamerParser(),
        backButtonDispatcher: BeamerBackButtonDispatcher(delegate: _routerDelegate),
        scrollBehavior: const ScrollBehavior().copyWith(physics: const BouncingScrollPhysics()),
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: colorBlue,
              titleTextStyle: TextStyle(
                fontSize: fontSizeTitle / 1.75,
                fontWeight: FontWeight.w800,
              )),
          primaryColor: colorBlue,
          fontFamily: fontHKGrotesk,
          textTheme: const TextTheme(
            bodyText2: TextStyle(
              fontSize: fontSizeText,
              fontWeight: FontWeight.w600,
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: colorBlue,
            selectionHandleColor: colorYellow,
            selectionColor: colorBlue.withOpacity(0.25),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                const TextStyle(
                  fontSize: fontSizeSubtitle,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(colorBlue),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
