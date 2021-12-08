import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/pages/creation_questionnaire/creation_questionnaire.dart';
import 'package:qweez_app/pages/home_page.dart';
import 'package:qweez_app/pages/launch_page.dart';
import 'package:qweez_app/pages/login_page.dart';
import 'package:qweez_app/pages/questions/questions_page.dart';
import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qweez_app/pages/questions/questions_presenter_waiting_page.dart';
import 'package:qweez_app/pages/ranking_page.dart';

void main() async {
  // Set the orientation to portrait only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  static UserCredential? userCredential;
  static double sizeNotificationBar = 0.0;

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  // Define the location of our routes
  final _routerDelegate = BeamerDelegate(
    initialPath: '/',
    locationBuilder: SimpleLocationBuilder(
      routes: {
        '/': (context, state) => BeamPage(
              key: const ValueKey('home'),
              child: const HomePage(),
            ),
        '/launch': (context, state) => BeamPage(
              key: const ValueKey('launch'),
              child: const LaunchPage(),
            ),
        '/editQuestionnaire/:questionnaireId': (context, state) {
          final questionnaireId = state.pathParameters['questionnaireId']!;
          return BeamPage(
            key: ValueKey('editQuestionnaire-$questionnaireId'),
            type: BeamPageType.cupertino,
            child: const CreationQuestionnairePage(),
          );
        },
        '/creationQuestionnaire': (context, state) => BeamPage(
              key: const ValueKey('creationQuestionnaire'),
              child: const CreationQuestionnairePage(),
              type: BeamPageType.cupertino,
            ),
        '/question/:questionnaireId': (context, state) {
          final questionnaireId = state.pathParameters['questionnaireId']!;
          return BeamPage(
            key: ValueKey('question-$questionnaireId'),
            child: const Questionpage(),
            type: BeamPageType.cupertino,
          );
        },
        '/questionPresenterWaiting/:questionnaireId/:username': (context, state) {
          final questionnaireId = state.pathParameters['questionnaireId']!;
          final username = state.pathParameters['username']!;
          return BeamPage(
            key: ValueKey('questionPresenterWaiting-$questionnaireId-$username'),
            child: QuestionsPresenterWaitingPage(
              questionnaireId: questionnaireId,
              username: username,
            ),
            type: BeamPageType.cupertino,
          );
        },
        '/login': (context, state) => BeamPage(
              key: const ValueKey('login'),
              child: const LoginPage(),
              type: BeamPageType.cupertino,
            ),
        '/ranking': (context, state) => BeamPage(
              key: const ValueKey('ranking'),
              child: const RankingPage(),
              type: BeamPageType.cupertino,
            ),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text('Error'),
          ),
        ),
      );
    }

    if (!_initialized) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: _routerDelegate,
        routeInformationParser: BeamerParser(),
        backButtonDispatcher: BeamerBackButtonDispatcher(delegate: _routerDelegate),
      );
    }

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
