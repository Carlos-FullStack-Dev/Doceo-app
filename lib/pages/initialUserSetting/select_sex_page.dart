import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SelectSexPage extends StatefulWidget {
  const SelectSexPage({Key? key}) : super(key: key);

  @override
  State<SelectSexPage> createState() => _SelectSexPage();
}

class _SelectSexPage extends State<SelectSexPage> {
  bool btnStatus = false;
  String sex = '男性';
  int selected = -1;

  @override
  void initState() {
    super.initState();
    final currentUser = StreamChat.of(context).currentUser;

    if (currentUser != null) {
      sex = currentUser.extraData['sex'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text('性別を選択',
                                  style: TextStyle(
                                      fontFamily: 'M_PLUS',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 15, bottom: 30),
                              child: const Text('後から変更することができません。',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xffB4BABF))),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF7CDE3),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected == 0
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.female),
                                      color: Colors.white,
                                      iconSize: 55.0,
                                      onPressed: () {
                                        setState(() {
                                          selected = 0;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffC4E6F7),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected == 1
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.male),
                                      color: Colors.white,
                                      iconSize: 55.0,
                                      onPressed: () {
                                        setState(() {
                                          selected = 1;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(22.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF2F2F2),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected == 2
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.circle_outlined),
                                      color: Colors.white,
                                      iconSize: 30.0,
                                      onPressed: () {
                                        setState(() {
                                          selected = 2;
                                        });
                                      },
                                    ),
                                  ),
                                ])
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.77),
                        child: ElevatedButton(
                          onPressed: () {
                            if (selected != -1 && !btnStatus) {
                              goToSelectIconPage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Ink(
                            decoration: selected != -1
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontStyle: FontStyle.normal,
                                          color: selected != -1
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
          ),
        ),
        onWillPop: () => Future.value(false));
  }

  void goToSelectIconPage() async {
    final client = StreamChat.of(context).client;
    final currentUser = StreamChat.of(context).currentUser;

    if (currentUser != null) {
      setState(() {
        btnStatus = true;
      });
      if (selected == 1) {
        AuthenticateProviderPage.of(context, listen: false).gender = "Male";
        currentUser.extraData['sex'] = '男性';
      } else if (selected == 0) {
        AuthenticateProviderPage.of(context, listen: false).gender = "Female";
        currentUser.extraData['sex'] = '女性';
      } else {
        AuthenticateProviderPage.of(context, listen: false).gender = "Neutral";
        currentUser.extraData['sex'] = 'LGBT';
      }

      try {
        await client.updateUser(currentUser);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectIconPage(fromPage: 'select_sex'),
          ),
        );
      } catch (e) {
        safePrint(e);
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "エラーです。もう一度お試しください。");
      }

      setState(() {
        btnStatus = false;
      });
    } else {}
  }
}
