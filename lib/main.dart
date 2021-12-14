import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/pages/error_page.dart';
import 'package:qweez_app/pages/gameplay/join_game_page.dart';
import 'package:qweez_app/pages/gameplay/play_alone_page.dart';
import 'package:qweez_app/pages/gameplay/present_game_page.dart';
import 'package:qweez_app/pages/home_page/home_page.dart';
import 'package:qweez_app/pages/launch_page.dart';
import 'package:qweez_app/pages/login_page.dart';
import 'package:qweez_app/pages/qweez_edit/edit_qweez_page.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  bool _userIsLoaded = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _userIsLoaded = true;
      setState(() => MyApp.user = user);
    });
  }

  // Define the location of our routes
  final _routerDelegate = BeamerDelegate(
    initialPath: '/',
    notFoundPage: const BeamPage(key: ValueKey('error'), child: ErrorPage(message: '404: Not found.')),
    guards: [
      BeamGuard(
        // on which path patterns (from incoming routes) to perform the check
        pathPatterns: ['/login', '/', '/play/*'],
        // perform the check on all patterns that **don't** have a match in pathPatterns
        guardNonMatching: true,
        // return false to redirect
        check: (context, location) => MyApp.user != null,
        // where to redirect on a false check
        beamToNamed: (origin, target) => '/login',
      ),
      BeamGuard(
        pathPatterns: ['/login'],
        check: (context, location) => MyApp.user == null,
        beamToNamed: (origin, target) => '/',
      ),
    ],
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => const BeamPage(key: ValueKey('home'), child: HomePage(), title: 'Qweez - Home'),
        '/create-qweez': (context, state, data) => const BeamPage(
              key: ValueKey('create-qweez'),
              child: EditQweezPage(),
              type: BeamPageType.cupertino,
              title: 'Qweez - Create',
            ),
        '/qweez/:qweezId/edit': (context, state, data) {
          final qweezId = state.pathParameters['qweezId']!;
          return BeamPage(
            key: ValueKey('qweez-edit-$qweezId'),
            type: BeamPageType.cupertino,
            child: EditQweezPage(qweezId: qweezId),
            title: 'Qweez - Edit',
            popToNamed: '/',
          );
        },
        '/qweez/:qweezId/present': (context, state, data) {
          final qweezId = state.pathParameters['qweezId']!;
          return BeamPage(
            key: ValueKey('qweez-present-$qweezId'),
            child: PresentGamePage(qweezId: qweezId),
            type: BeamPageType.cupertino,
            title: 'Qweez - Presenting',
            popToNamed: '/',
          );
        },
        '/qweez/:qweezId/play': (context, state, data) {
          final qweezId = state.pathParameters['qweezId']!;
          return BeamPage(
            key: ValueKey('qweez-play-$qweezId'),
            child: PlayAlonePage(qweezId: qweezId),
            type: BeamPageType.cupertino,
            title: 'Qweez - Play',
            popToNamed: '/',
          );
        },
        '/play/:code': (context, state, data) {
          final code = state.pathParameters['code']!;
          return BeamPage(
            key: ValueKey('qweez-join-$code'),
            child: JoinGamePage(gameCode: code),
            type: BeamPageType.cupertino,
            title: 'Qweez - Play',
            popToNamed: '/',
          );
        },
        '/login': (context, state, data) => const BeamPage(
              key: ValueKey('login'),
              child: LoginPage(),
              type: BeamPageType.cupertino,
              title: 'Qweez - Login',
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
        builder: (context, child) {
          if (!_userIsLoaded) {
            return const LaunchPage();
          }
          return child!;
        },
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
