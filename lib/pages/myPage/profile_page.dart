// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final TextEditingController _introductionController =
      TextEditingController(text: '');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      final currentUser = StreamChat.of(context).currentUser!;

      _introductionController.text = currentUser.extraData['intro'] != null
          ? currentUser.extraData['intro'].toString()
          : '';
      _usernameController.text = currentUser.name;
      _birthdayController.text = currentUser.extraData['birthday'] != null
          ? currentUser.extraData['birthday'].toString()
          : '';
      selectedDate = currentUser.extraData['birthday'] != null
          ? DateFormat('MM/dd/yyyy')
              .parse(currentUser.extraData['birthday'].toString())
          : DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 4, top: 2, bottom: 2),
                child: TextButton(
                  onPressed: () {
                    updateProfile();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 23, vertical: 3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xffB44DD9), Color(0xff70A4F2)]),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text('完了',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              )
            ],
            backgroundColor: Colors.white,
            title: const Text('プロフィール',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Stack(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: BetterStreamBuilder(
                                    stream: StreamChat.of(context)
                                        .client
                                        .state
                                        .currentUserStream,
                                    builder: (context, data) {
                                      var avatarUrl = data.image ??
                                          'assets/images/avatars/default.png';

                                      return Container(
                                          decoration: BoxDecoration(
                                              image: avatarUrl
                                                      .startsWith('assets')
                                                  ? DecorationImage(
                                                      image:
                                                          AssetImage(avatarUrl),
                                                      fit: BoxFit.contain)
                                                  : DecorationImage(
                                                      image: NetworkImage(
                                                          avatarUrl),
                                                      fit: BoxFit.contain),
                                              color: Colors.white,
                                              shape: BoxShape.circle));
                                    })),
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SelectIconPage(
                                                  fromPage: 'myProfilePage'),
                                        ),
                                      );
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const ShapeDecoration(
                                          color: Color(0xFFF2F2F2),
                                          shape: OvalBorder(
                                              side: BorderSide(width: 0.50)),
                                        ),
                                        child: const Icon(
                                            Icons.mode_edit_outline_outlined,
                                            size: 25))))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        'ユーザー名',
                        style: TextStyle(
                          fontFamily: 'M_PLUS',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      style: const TextStyle(
                          fontFamily: 'M_PLUS',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        filled: true,
                        fillColor: Color(0xffEBECEE),
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
                      controller: _usernameController,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 25, bottom: 5),
                      child: const Text(
                        '生年月日',
                        style: TextStyle(
                          fontFamily: 'M_PLUS',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1900, 1, 1),
                              maxTime: DateTime(2023, 12, 31),
                              onConfirm: (date) {
                            String formattedDate =
                                DateFormat('MM/dd/yyyy').format(date);
                            setState(() {
                              selectedDate = date;
                              _birthdayController.text = formattedDate;
                            });
                          }, currentTime: selectedDate, locale: LocaleType.jp);
                        },
                        child: TextFormField(
                          enabled: false,
                          style: const TextStyle(
                              fontFamily: 'M_PLUS',
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            filled: true,
                            fillColor: Color(0xffEBECEE),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            hintText: '',
                          ),
                          controller: _birthdayController,
                        )),
                    Container(
                      padding: const EdgeInsets.only(top: 25, bottom: 5),
                      child: const Text(
                        '自己紹介',
                        style: TextStyle(
                          fontFamily: 'M_PLUS',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _introductionController,
                      maxLines: null,
                      minLines: 7,
                      style: const TextStyle(
                          fontFamily: 'M_PLUS',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Color(0xFFB4BABF)),
                          hintText: 'あなたのことを書きましょう',
                          filled: true,
                          fillColor: const Color(0xffEBECEE),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: width * 0.02),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ],
                ))));
  }

  void updateProfile() async {
    final client = StreamChat.of(context).client;
    final feedClient = context.feedClient;
    final currentUser = StreamChat.of(context).currentUser!;

    try {
      currentUser.extraData['name'] = _usernameController.text;
      currentUser.extraData['birthday'] = _birthdayController.text;
      currentUser.extraData['intro'] = _introductionController.text;

      await client.updateUser(currentUser);
      await feedClient.updateUser(currentUser.id, {
        'name': currentUser.name,
        'avatar': currentUser.image,
        'gender': currentUser.extraData['sex'],
        'birthday': currentUser.extraData['birthday'],
        'role': 'user'
      });
      Navigator.pop(context);
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
