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

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  static double sizeNotificationBar = 0.0;

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
        '/editQuestionnaire/:questionnaireId': (context, state, data) {
          final questionnaireId = state.pathParameters['questionnaireId']!;
          return BeamPage(
            key: ValueKey('editQuestionnaire-$questionnaireId'),
            type: BeamPageType.cupertino,
            child: EditQweezPage(questionnaireId: questionnaireId),
          );
        },
        '/creationQuestionnaire': (context, state, data) => const BeamPage(
              key: ValueKey('creationQuestionnaire'),
              child: EditQweezPage(),
              type: BeamPageType.cupertino,
            ),
        '/question/:questionnaireId': (context, state, data) {
          final questionnaireId = state.pathParameters['questionnaireId']!;
          return BeamPage(
            key: ValueKey('question-$questionnaireId'),
            child: const Questionpage(),
            type: BeamPageType.cupertino,
          );
        },
        '/questionPresenterWaiting/:questionnaireId/:username': (context, state, data) {
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
        '/login': (context, state, data) => const BeamPage(
              key: ValueKey('login'),
              child: LoginPage(),
              type: BeamPageType.cupertino,
            ),
        '/ranking': (context, state, data) => const BeamPage(
              key: ValueKey('ranking'),
              child: RankingPage(),
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
