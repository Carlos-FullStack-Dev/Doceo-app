// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/initialUserSetting/select_sex_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:toast/toast.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  bool btnStatus = false;
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  bool _isFilled = false;
  TextEditingController birthday = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String _dobValue = '';

  @override
  void initState() {
    super.initState();
    birthday.text =
        AuthenticateProviderPage.of(context, listen: false).birthday;
    username.addListener(_onTextChanged);
    birthday.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final birthdayPattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    setState(() {
      _isFilled = username.text.isNotEmpty &&
          birthday.text.isNotEmpty &&
          birthdayPattern.hasMatch(birthday.text);
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
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            // ignore: unnecessary_new
            child: new SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'プロフィールを登録',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: const Text(
                              'ユーザー名を入力',
                              style:
                                  TextStyle(fontFamily: 'M_PLUS', fontSize: 13),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 5),
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
                              controller: username,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: const Text(
                              '後からいつでも変更できます！',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontSize: 13,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: const Text(
                          '誕生日を入力',
                          style: TextStyle(fontFamily: 'M_PLUS', fontSize: 13),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1900, 1, 1),
                                maxTime: DateTime(2023, 12, 31),
                                onConfirm: (date) {
                              String formattedDate =
                                  DateFormat('MM/dd/yyyy').format(date);
                              _dobValue = DateFormat('yyyy-MM-dd').format(date);
                              if (selectedDate != null) {
                                setState(() {
                                  selectedDate = date;
                                  birthday.text = formattedDate;
                                });
                              }
                            },
                                currentTime: selectedDate,
                                locale: LocaleType.jp);
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            filled: true,
                            fillColor: Color(0xffEBECEE),
                            // suffixIcon: InkWell(
                            //   child: Icon(Icons.calendar_month,
                            //       color: Colors.grey),
                            // ),
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
                          controller: birthday,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.only(top: 2),
                        child: const Text(
                          '他のユーザーには表示されません',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontSize: 13,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if (birthday.text.isNotEmpty &&
                                username.text.isNotEmpty &&
                                !btnStatus) {
                              goGenderPage();
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
                                      'アカウントを作成',
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
                  ),
                ],
              ),
            ),
          )),
        ),
        onWillPop: () => Future.value(false));
  }

  void goGenderPage() async {
    final client = StreamChat.of(context).client;
    final currentUser = StreamChat.of(context).currentUser;

    if (currentUser != null) {
      currentUser.extraData['birthday'] = birthday.text;
      currentUser.extraData['name'] = username.text;

      setState(() {
        btnStatus = true;
      });

      try {
        await client.updateUser(currentUser);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectSexPage()));
      } catch (e) {
        safePrint(e);
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "エラーです。もう一度お試しください。");
      }

      setState(() {
        btnStatus = false;
      });
    }
  }
}
