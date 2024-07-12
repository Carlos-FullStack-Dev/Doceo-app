// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/auth/profile_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:toast/toast.dart';

import '../../services/auth_provider.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPage createState() => _VerificationPage();
}

class _VerificationPage extends State<VerificationPage> {
  TextEditingController verificationCode = TextEditingController();
  bool btnStatus = false;
  bool _isFilled = false;
  @override
  void initState() {
    super.initState();
    verificationCode.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isFilled = verificationCode.text.isNotEmpty;
    });
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
            actions: [
              TextButton(
                onPressed: () {
                  if (!btnStatus) {
                    resendCode();
                  }
                },
                child: const Text('再送する',
                    style: TextStyle(
                        color: Color(0xFF1997F6),
                        fontFamily: 'M_PLUS',
                        fontSize: 17,
                        fontWeight: FontWeight.w500)),
              )
            ],
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            // ignore: unnecessary_new
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "認証番号を入力してください",
                            style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            AuthenticateProviderPage.of(context, listen: false)
                                .verificationTitle,
                            style: const TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            filled: true,
                            fillColor: Color(0xffEBECEE),
                            // suffixIcon: Icon(Icons.phone, color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            hintText: '',
                          ),
                          controller: verificationCode,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if (verificationCode.text.isNotEmpty &&
                                !btnStatus) {
                              confirmVerification();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Ink(
                            decoration: _isFilled
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 1)
                                  : Text(
                                      '次へ',
                                      style: TextStyle(
                                          fontFamily: 'M_PLUS',
                                          fontSize: 15,
                                          fontStyle: FontStyle.normal,
                                          color: _isFilled
                                              ? Colors.white
                                              : const Color(0xffB4BABF)),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
        ),
        onWillPop: () => Future.value(false));
  }

  void resendCode() async {
    setState(() {
      btnStatus = true;
    });
    String verificationTool =
        AuthenticateProviderPage.of(context, listen: false).verificationTool;
    try {
      final result =
          await Amplify.Auth.resendSignUpCode(username: verificationTool);
      safePrint(result);
      setState(() {
        btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastSuccess('認証番号を再送しました', context);
    } on AuthException catch (e) {
      safePrint(e.message);
      setState(() {
        btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: 'エラーです。入力してください!');
    }
  }

  void confirmVerification() async {
    setState(() {
      btnStatus = true;
    });
    String verificationTool =
        AuthenticateProviderPage.of(context, listen: false).verificationTool;
    String password =
        AuthenticateProviderPage.of(context, listen: false).password;

    // Confirm Signup
    try {
      final res = await Amplify.Auth.confirmSignUp(
          username: verificationTool,
          confirmationCode: verificationCode.text.toString());

      if (!res.isSignUpComplete) {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: 'エラーです。もう一度お試しください。');
        setState(() {
          btnStatus = false;
        });
        return;
      }
    } on AuthException catch (e) {
      if (!e.message.contains("Current status is CONFIRMED")) {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: 'エラー、認証コードが正しくありません!');
        setState(() {
          btnStatus = false;
        });
        return;
      }
    }

    try {
      await Amplify.Auth.signIn(username: verificationTool, password: password);
    } on AuthException catch (e) {
      if (!e.message.contains('already signed in')) {
        setState(() {
          btnStatus = false;
        });
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "エラーです。もう一度お試しください。");
        return;
      }
    } catch (e) {
      safePrint(e);

      setState(() {
        btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
      return;
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));

    setState(() {
      btnStatus = false;
    });
  }
}
