// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/pages/auth/forgotpassword_page.dart';
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

class SignInPage extends StatefulWidget {
  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  bool _passwordVisible = true;
  bool btnStatus = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isFilled = false;
  final Uri _terms = Uri.parse('https://doceo.jp/terms/');
  final Uri _privacy = Uri.parse('https://doceo.jp/privacy/');
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    email.addListener(_onTextChanged);
    password.addListener(_onTextChanged);
    _termsRecognizer = TapGestureRecognizer()..onTap = _openTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _openPrivacy;
  }

  void _onTextChanged() {
    setState(() {
      _isFilled = email.text.isNotEmpty && password.text.isNotEmpty;
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
                          'おかえりなさい！',
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
                                  padding: const EdgeInsets.only(top: 0),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordPage()));
                                      },
                                      child: const Text(
                                        'パスワードをお忘れですか？',
                                        style: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 13,
                                            color: Color(0xff1997F6)),
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                            onPressed: () {
                              if (email.text.isNotEmpty &&
                                  password.text.isNotEmpty &&
                                  !btnStatus) {
                                signInWithEmail();
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
                                            color: _isFilled
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
                        //         const Text('SNSを利用してのログインはこちら',
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
                        //           borderRadius: BorderRadius.circular(100),
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
                        //           borderRadius: BorderRadius.circular(100),
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
                                text: '|',
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

  void signInWithEmail() async {
    setState(() {
      btnStatus = true;
    });
    await Amplify.Auth.signOut();
    DateTime prev = DateTime.now();

    try {
      var res = await Amplify.Auth.signIn(
        username: email.text.toString(),
        password: password.text.toString(),
      );
      DateTime now = DateTime.now();
      print('***************SignIn***************');
      print('Amplify SignIn:${now.difference(prev).inMilliseconds}');

      if (res.nextStep.signInStep == AuthSignInStep.confirmSignUp) {
        await Amplify.Auth.resendSignUpCode(username: email.text);
        setState(() {
          btnStatus = false;
        });
        AuthenticateProviderPage.of(context).verificationTool = email.text;
        AuthenticateProviderPage.of(context).password = password.text;
        AuthenticateProviderPage.of(context, listen: false).verificationTitle =
            email.text + "に送信しました";
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VerificationPage()));
        return;
      }
    } on AuthException catch (e) {
      if (!e.message.contains('already signed in')) {
        safePrint(e);

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

    goHome();
  }

  void goHome() async {
    setState(() {
      btnStatus = false;
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const TransitionPage()));
    // try {
    //   DateTime prev = DateTime.now(), now;
    //   final userData = await Amplify.Auth.fetchUserAttributes();
    //   now = DateTime.now();
    //   print('***************Get Attributes***************');
    //   print('Amplify Get Attributes:${now.difference(prev).inMilliseconds}');
    //   Map userInfo = {};
    //   for (final element in userData) {
    //     userInfo
    //         .addAll({element.userAttributeKey.key.toString(): element.value});
    //   }

    //   AuthenticateProviderPage.of(context, listen: false).isAuthenticated =
    //       true;
    //   AuthenticateProviderPage.of(context, listen: false).user = userInfo;

    //   try {
    //     String userId = userInfo['sub'];
    //     String graphQLDocument = '''query createUserToken {
    //         CreateUserToken(id: "$userId"){
    //           token
    //           rooms{
    //             channel{
    //               id
    //               name
    //               description
    //               image
    //               feedsCount
    //               questions
    //               tags
    //               owner
    //             }
    //             members{
    //               role
    //               user_id
    //               user{
    //                 role
    //                 image
    //                 firstName
    //                 lastName
    //               }
    //             }
    //           }
    //         }
    //       }''';
    //     var operation = Amplify.API
    //         .query(request: GraphQLRequest<String>(document: graphQLDocument));
    //     prev = DateTime.now();
    //     var response = await operation.response;
    //     now = DateTime.now();
    //     print('***************Get Token***************');
    //     print('Getstream Token:${now.difference(prev).inMilliseconds}');
    //     var res = json.decode(response.data.toString());

    //     if (res['CreateUserToken']['token'].toString().isNotEmpty) {
    //       AuthenticateProviderPage.of(context, listen: false).getStreamToken =
    //           res['CreateUserToken']['token'].toString();
    //       AppProviderPage.of(context, listen: false).rooms =
    //           res['CreateUserToken']['rooms'];
    //       int userNum = 0;
    //       List roomSigned = [];

    //       for (var item in res['CreateUserToken']['rooms']) {
    //         userNum =
    //             item['members'].where((e) => e['user_id'] == userId).length;
    //         if (userNum > 0) {
    //           roomSigned.add({'status': true});
    //         } else {
    //           roomSigned.add({'status': false});
    //         }
    //         userNum = 0;
    //       }
    //       AppProviderPage.of(context, listen: false).roomSigned = roomSigned;

    //       try {
    //         final client = StreamChat.of(context).client;
    //         prev = DateTime.now();
    //         await client.disconnectUser();
    //         now = DateTime.now();
    //         print('***************Gestream Disconnect***************');
    //         print(
    //             'Getstream Disconnect:${now.difference(prev).inMilliseconds}');
    //         prev = DateTime.now();
    //         final currentUser = await client.connectUser(
    //           User(id: userId),
    //           AuthenticateProviderPage.of(context, listen: false)
    //               .getStreamToken,
    //         );
    //         now = DateTime.now();
    //         print('***************Gestream Connect***************');
    //         print('Getstream Connect:${now.difference(prev).inMilliseconds}');
    //         if (MainScreen.targetChannel.isNotEmpty) {
    //           final channel = await client.queryChannel(
    //               MainScreen.targetChannelType,
    //               channelId: MainScreen.targetChannel);

    //           AppProviderPage.of(context).selectedRoom =
    //               channel.channel!.extraData['room'].toString();
    //         }
    //         AuthenticateProviderPage.of(context).joined = currentUser.createdAt;

    //         if (currentUser.name.isEmpty) {
    //           Navigator.push(context,
    //               MaterialPageRoute(builder: (context) => ProfilePage()));
    //         } else {
    //           // Feed
    //           final feedClient = context.feedClient;
    //           final userData = {
    //             'name': currentUser.name,
    //             'avatar': currentUser.image,
    //             'gender': currentUser.extraData['sex'],
    //             'birthday': currentUser.extraData['birthday'],
    //             'role': 'user'
    //           };

    //           prev = DateTime.now();
    //           try {
    //             await feedClient.updateUser(userId, userData);
    //           } catch (e) {
    //             await feedClient.user(userId).getOrCreate(userData);
    //           }
    //           now = DateTime.now();
    //           print('***************Gestream Feed User***************');
    //           print(
    //               'Getstream Feed User:${now.difference(prev).inMilliseconds}');

    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => const TransitionPage()));
    //         }
    //       } catch (e) {
    //         print('Query failed: $e');
    //         AuthenticateProviderPage.of(context, listen: false)
    //             .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    //       }
    //     } else {
    //       AuthenticateProviderPage.of(context, listen: false)
    //           .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    //     }
    //   } catch (e) {
    //     print('Query failed: $e');
    //     AuthenticateProviderPage.of(context, listen: false)
    //         .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    //   }
    // } catch (e) {
    //   print('Error: $e');
    //   AuthenticateProviderPage.of(context, listen: false)
    //       .notifyToastDanger(message: "サインイン エラーです。もう一度お試しください。");
    // }
    // setState(() {
    //   btnStatus = false;
    // });
  }

  void signInWithApple() async {
    setState(() {
      btnStatus = true;
    });

    try {
      final result =
          await Amplify.Auth.signInWithWebUI(provider: AuthProvider.apple);
      safePrint("Sign in resultL $result");

      goHome();
    } catch (e) {
      safePrint('Error Signing in: $e');
      setState(() {
        btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "サインイン エラーです。もう一度お試しください。");
    }
  }

  void signInWithGoogle() async {
    setState(() {
      btnStatus = true;
    });

    try {
      final result =
          await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
      safePrint("Sign in resultL $result");

      goHome();
    } catch (e) {
      safePrint('Error Signing in: $e');
      setState(() {
        btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "サインイン エラーです。もう一度お試しください。");
    }
  }
}
