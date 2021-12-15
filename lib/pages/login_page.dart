import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants.dart';
import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qweez_app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  var _email = '';
  var _password = '';
  var _passwordConfirmation = '';
  var _errorText = '';

  late final double _height;
  late final double _width;

  var _isRegister = false;
  var _firstBuild = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_firstBuild) {
      _firstBuild = false;
      _height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
      _width = MediaQuery.of(context).size.width;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colorBlue.withOpacity(0.9),
          child: Stack(
            children: [
              Positioned(
                top: 80,
                left: -50,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorBlue,
                  ),
                ),
              ),
              Positioned(
                right: -40,
                bottom: 50,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorBlue,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: _height,
                  width: _width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: colorWhite,
                          ),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: paddingVertical * 2),
                          child: Text(
                            "Let's sign you in.",
                            style: TextStyle(
                              fontSize: fontSizeTitle,
                              color: colorWhite,
                              fontWeight: FontWeight.w900,
                              fontFamily: fontHKGrotesk,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: paddingVertical / 2),
                          child: Text(
                            "You've been missed!",
                            style: TextStyle(
                              fontSize: fontSizeTitle,
                              color: colorWhite,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontHKGrotesk,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 500,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyTextFormField(
                                    valueText: _email,
                                    hintText: 'E-mail',
                                    textInputAction: TextInputAction.next,
                                    validator: (String? email) {
                                      return _email.isEmpty ? 'Please enter an e-mail' : null;
                                    },
                                    onChanged: (String email) {
                                      _email = email;
                                    },
                                  ),
                                  const SizedBox(
                                    height: paddingVertical,
                                  ),
                                  MyTextFormField(
                                    valueText: _password,
                                    hintText: 'Password',
                                    textInputAction: _isRegister ? TextInputAction.next : TextInputAction.done,
                                    isPassword: true,
                                    validator: (String? password) {
                                      return password!.isEmpty ? 'Please enter a password' : null;
                                    },
                                    onChanged: (String password) {
                                      _password = password;
                                    },
                                  ),
                                  if (_isRegister)
                                    MyTextFormField(
                                      valueText: _passwordConfirmation,
                                      hintText: 'Password confirmation',
                                      textInputAction: TextInputAction.done,
                                      isPassword: true,
                                      validator: (String? passwordConfirmation) {
                                        return passwordConfirmation!.isEmpty
                                            ? 'Please enter re-enter your password'
                                            : _passwordConfirmation != _password
                                                ? 'The passwords do not match'
                                                : null;
                                      },
                                      onChanged: (String password) {
                                        _passwordConfirmation = password;
                                      },
                                    ),
                                  if (_errorText.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: paddingVertical),
                                      child: Text(
                                        _errorText,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: colorRed,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isRegister ? "You already have an account?" : "You don't have an account?",
                              style: const TextStyle(
                                color: colorWhite,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.only(left: paddingHorizontal / 2),
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                              ),
                              child: Text(
                                _isRegister ? 'Log in' : "Register",
                                style: const TextStyle(
                                  color: colorYellow,
                                  fontWeight: FontWeight.w600,
                                  fontSize: fontSizeText,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isRegister = !_isRegister;
                                });
                              },
                            ),
                          ],
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: paddingVertical * 2, top: paddingVertical),
                            height: 50,
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            width: double.maxFinite,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(colorYellow),
                              ),
                              child: Text(
                                _isRegister ? 'Register' : 'Log in',
                                style: const TextStyle(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_isRegister) {
                                    signUp();
                                  } else {
                                    login();
                                  }
                                }
                              },
                            ),
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
      ),
    );
  }

  //firebase function to create user with email and password
  Future signUp() async {
    setState(() {
      _errorText = '';
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

      userCredential.user!.sendEmailVerification();

      _showEmailSend(
        'A verification e-mail was sent to your email address.',
        'Please confirm it before logging in!',
        'I will check',
      );

      FirebaseAuth.instance.signOut();
      MyApp.user = null;
      setState(() {
        _isRegister = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _errorText = "Your password is too weak, it must contain at least six characters!";
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _errorText = "An account already exists with this e-mail address.";
        });
      }
    } catch (e) {
      setState(() {
        _errorText = "An error occured, please try again.";
      });
    }
  }

  //firebase function to login with email and password
  Future login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);

      if (userCredential.user!.emailVerified) {
        Beamer.of(context).popToNamed('/');
      } else {
        _showEmailSend(
          'Your account is not verified.',
          'A verification e-mail was sent to you, if you have not received it, please check your spam.',
          'Understood',
        );
        FirebaseAuth.instance.signOut();
        MyApp.user = null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        setState(() {
          _errorText = "Invalid e-mail or password, please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorText = "An error occured, please try again.";
      });
    }
  }

  Future<void> _showEmailSend(String title, String content, String action) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(
            left: paddingHorizontal / 1.75,
            right: paddingHorizontal / 1.75,
            bottom: paddingVertical / 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: colorBlack,
              fontWeight: FontWeight.w600,
              fontSize: fontSizeSubtitle,
            ),
          ),
          content: Text(content),
          actions: <Widget>[
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colorYellow),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  action,
                  style: const TextStyle(
                    color: colorBlack,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
