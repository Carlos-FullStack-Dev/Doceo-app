// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/pages/auth/profile_page.dart';
import 'package:doceo_new/pages/auth/verification_page.dart';
import 'package:doceo_new/pages/home/main_screen.dart';
import 'package:doceo_new/pages/transitionToHome/transition.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  int segmentedControlGroupValue = 1;
  TextEditingController email = TextEditingController();
  bool _passwordVisible = true;
  bool btnStatus = false;
  TextEditingController password = TextEditingController();
  bool _isFilled = false;
  bool _isPasswordValid = true;
  final Uri _terms = Uri.parse('https://doceo.jp/terms/');
  final Uri _privacy = Uri.parse('https://doceo.jp/privacy/');
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    email.addListener(_onEmailChanged);
    password.addListener(_onPasswordChanged);
    _termsRecognizer = TapGestureRecognizer()..onTap = _openTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _openPrivacy;
  }

  void _onEmailChanged() {
    setState(() {
      _isFilled = email.text.isNotEmpty && password.text.isNotEmpty;
    });
  }

  void _onPasswordChanged() {
    const passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';
    final regExp = RegExp(passwordPattern);
    setState(() {
      _isFilled = email.text.isNotEmpty && password.text.isNotEmpty;
      _isPasswordValid = regExp.hasMatch(password.text);
    });
  }

  void _openTerms() async {
    if (!await launchUrl(_terms, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $_terms');
    }
  }

  void _openPrivacy() async {
    if (!await launchUrl(
      _privacy,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $_privacy');
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            titleSpacing: 0,
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "戻る",
                style: TextStyle(
                  fontFamily: 'M_PLUS',
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              // ignore: unnecessary_new
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'DOCEOへようこそ',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: const Text(
                                    'アカウント情報',
                                    style: TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        filled: true,
                                        fillColor: Color(0xffEBECEE),
                                        suffixIcon: Icon(Icons.email,
                                            color: Colors.grey),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        hintText: 'メールアドレス',
                                        hintStyle: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            color: Colors.grey)),
                                    controller: email,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    obscureText: _passwordVisible,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                        filled: true,
                                        fillColor: const Color(0xffEBECEE),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        hintText: 'パスワード',
                                        hintStyle: const TextStyle(
                                            fontFamily: 'M_PLUS',
                                            color: Colors.grey,
                                            fontSize: 15)),
                                    controller: password,
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text('パスワードは、英数字小文字大文字含む8字以上で!',
                                        style: TextStyle(
                                          fontFamily: 'M_PLUS',
                                          color: _isPasswordValid
                                              ? const Color(0xffB4BABF)
                                              : Colors.red,
                                          fontSize: 13,
                                        ))),
                              ],
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_isFilled && _isPasswordValid && !btnStatus) {
                                getVeificationCode();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Ink(
                              decoration: _isFilled && _isPasswordValid
                                  ? BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Color(0xffB44DD9),
                                        Color(0xff70A4F2)
                                      ]),
                                      borderRadius: BorderRadius.circular(10))
                                  : BoxDecoration(
                                      color: const Color(0xffF2F2F2),
                                      borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 40,
                                alignment: Alignment.center,
                                child: btnStatus
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        strokeWidth: 1)
                                    : Text(
                                        '次へ',
                                        style: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            color: email.text.isNotEmpty &&
                                                    password.text.isNotEmpty
                                                ? Colors.white
                                                : const Color(0xffB4BABF)),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.only(top: 30),
                        //   child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         Container(
                        //           height: 0.2,
                        //           width: 60.0,
                        //           color: const Color(0xff4F5660),
                        //         ),
                        //         const Text('SNSを利用しての登録はこちら',
                        //             style: TextStyle(
                        //                 fontFamily: 'M_PLUS',
                        //                 fontSize: 13,
                        //                 fontStyle: FontStyle.normal,
                        //                 color: Color(0xffB4BABF))),
                        //         Container(
                        //           height: 0.2,
                        //           width: 60.0,
                        //           color: const Color(0xff4F5660),
                        //         ),
                        //       ]),
                        // ),
                        // Container(
                        //   margin: const EdgeInsets.only(top: 30),
                        //   child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         InkWell(
                        //           onTap: () {
                        //             if (!btnStatus) {
                        //               signInWithApple();
                        //             }
                        //           },
                        //           child: Container(
                        //             width: 50,
                        //             height: 50,
                        //             decoration: BoxDecoration(
                        //               shape: BoxShape.circle,
                        //               color: Colors.white,
                        //               boxShadow: [
                        //                 BoxShadow(
                        //                   color: Colors.black.withOpacity(0.25),
                        //                   spreadRadius: 1,
                        //                   blurRadius: 5,
                        //                   offset: const Offset(0, 4),
                        //                 ),
                        //               ],
                        //             ),
                        //             child: Center(
                        //               child: SvgPicture.asset(
                        //                 'assets/images/apple.svg',
                        //                 height: 30.0,
                        //                 width: 30.0,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         InkWell(
                        //           onTap: () {
                        //             if (!btnStatus) {
                        //               signInWithGoogle();
                        //             }
                        //           },
                        //           child: Container(
                        //             width: 50,
                        //             height: 50,
                        //             decoration: BoxDecoration(
                        //               shape: BoxShape.circle,
                        //               color: Colors.white,
                        //               boxShadow: [
                        //                 BoxShadow(
                        //                   color: Colors.black.withOpacity(0.25),
                        //                   spreadRadius: 1,
                        //                   blurRadius: 5,
                        //                   offset: const Offset(0, 4),
                        //                 ),
                        //               ],
                        //             ),
                        //             child: Center(
                        //               child: SvgPicture.asset(
                        //                 'assets/images/google.svg',
                        //                 height: 30.0,
                        //                 width: 30.0,
                        //               ),
                        //             ),
                        //           ),
                        //         )
                        //       ]),
                        // ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.7,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height * 0.11,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 80),
                        child: RichText(
                          text: TextSpan(
                            text: '利用規約',
                            recognizer: _termsRecognizer,
                            style: const TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff1997F6)),
                            children: <TextSpan>[
                              const TextSpan(
                                text: ' | ',
                                style: TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xffB4BABF)),
                              ),
                              TextSpan(
                                text: 'プライバシーポリシー',
                                recognizer: _privacyRecognizer,
                                style: const TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff1997F6)),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }

  void getVeificationCode() async {
    final userAttributes = <AuthUserAttributeKey, String>{
      AuthUserAttributeKey.email: email.text,
      const CognitoUserAttributeKey.custom('groupname'): 'Users'
    };
    setState(() {
      btnStatus = true;
    });

    try {
      SignUpResult signUpResult = await Amplify.Auth.signUp(
        username: email.text,
        password: password.text,
        options: SignUpOptions(userAttributes: userAttributes),
      );

      setState(() {
        btnStatus = false;
      });

      // if (signUpResult.isSignUpComplete) {
      //   safePrint('Sign up successful');
      // } else {
      setState(() {
        AuthenticateProviderPage.of(context, listen: false).verificationTitle =
            email.text + "に送信しました";
        AuthenticateProviderPage.of(context, listen: false).verificationTool =
            email.text;
        AuthenticateProviderPage.of(context, listen: false).password =
            password.text;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VerificationPage()));
      // }
    } catch (e) {
      setState(() {
        btnStatus = false;
      });
      if (e is UsernameExistsException) {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastAlert("Email address is already registered。", context);
      } else {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToast(message: "エラーです。値を入力してください。");
      }
    }
  }

  void goHome() async {
    setState(() {
      btnStatus = false;
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const TransitionPage()));
  }

  void signInWithApple() async {
    // setState(() {
    //   btnStatus = true;
    // });

    try {
      final result =
          await Amplify.Auth.signInWithWebUI(provider: AuthProvider.apple);
      safePrint("Sign in resultL $result");

      goHome();
    } catch (e) {
      safePrint('Error Signing in: $e');
      // setState(() {
      //   btnStatus = false;
      // });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "サインイン エラーです。もう一度お試しください。");
    }
  }

  void signInWithGoogle() async {
    // setState(() {
    //   btnStatus = true;
    // });

    try {
      final result =
          await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
      safePrint("Sign in resultL $result");

      goHome();
    } catch (e) {
      safePrint('Error Signing in: $e');
      // setState(() {
      //   btnStatus = false;
      // });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "サインイン エラーです。もう一度お試しください。");
    }
  }
}
