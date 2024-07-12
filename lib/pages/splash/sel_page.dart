import 'dart:async';
import 'package:doceo_new/pages/auth/signin_page.dart';
import 'package:doceo_new/pages/auth/signup_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelPage extends StatefulWidget {
  @override
  _SelPage createState() => _SelPage();
}

class _SelPage extends State<SelPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.topCenter,
                      child: SvgPicture.asset(
                        'assets/images/sel_header.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/sel_body.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SvgPicture.asset(
                        'assets/images/sel_footer.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.62),
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/sel_logo.png',
                              fit: BoxFit.contain,
                            )),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02),
                          child: const Text(
                            '悩みでつながる\nメディカルコミュニティ',
                            style: TextStyle(
                                color: Color(0xff1D5162),
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.bottomCenter,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.03),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpPage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [
                                          Color(0xffB44DD9),
                                          Color(0xff70A4F2)
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'はじめる',
                                        style: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 3, bottom: 47),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignInPage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        color: const Color(0xff63CEF0),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'ログイン',
                                        style: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]))
                  ],
                )
              ],
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }
}
