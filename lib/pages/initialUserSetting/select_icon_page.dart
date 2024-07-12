import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/pages/initialUserSetting/select_trouble.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SelectIconPage extends StatefulWidget {
  final String? fromPage;
  const SelectIconPage({Key? key, this.fromPage}) : super(key: key);

  @override
  State<SelectIconPage> createState() => _SelectIconPage();
}

class _SelectIconPage extends State<SelectIconPage> {
  // late final client = StreamChat.of(context).client;

  get child => null;
  String avatarUrl = "";
  bool btnStatus = false;
  String sex = '男性';

  @override
  void initState() {
    final currentUser = StreamChat.of(context).currentUser;
    if (currentUser != null) {
      avatarUrl = currentUser.image.toString();
      sex = currentUser.extraData['sex'].toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? fromPage = widget.fromPage;
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
              )),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text('プロフィール画像を選択',
                                style: TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.27,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              dashPattern: const [4, 6],
                              radius: const Radius.circular(200),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(avatarUrl),
                                      scale: 1,
                                    ),
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          ),
                          const Text('お好きなアイコンをお選びください',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xffB4BABF))),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.03),
                            child: GridView.count(
                              crossAxisCount: 4,
                              children: List.generate(sex == 'LGBT' ? 12 : 6,
                                  (index) {
                                final iconIndex =
                                    index * 2 + (sex == '男性' ? 0 : 1);

                                return InkWell(
                                  onTap: () {
                                    selAvatar(iconIndex);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://doceo-asset.s3.ap-northeast-1.amazonaws.com/user-icons/avatar_$iconIndex.png"),
                                            fit: BoxFit.contain),
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.77),
                        child: ElevatedButton(
                          onPressed: () {
                            if (!btnStatus) {
                              goSelectTroublePage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Ink(
                            decoration: avatarUrl.isNotEmpty
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
                                      fromPage == 'select_sex' ? '次へ' : '完了',
                                      style: TextStyle(
                                          fontFamily: 'M_PLUS',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontStyle: FontStyle.normal,
                                          color: avatarUrl.isNotEmpty
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

  void selAvatar(int num) {
    setState(() {
      avatarUrl =
          "https://doceo-asset.s3.ap-northeast-1.amazonaws.com/user-icons/avatar_$num.png";
      AuthenticateProviderPage.of(context, listen: false).avatarUrl =
          "https://doceo-asset.s3.ap-northeast-1.amazonaws.com/user-icons/avatar_$num.png";
    });
  }

  void goSelectTroublePage() async {
    final client = StreamChat.of(context).client;
    final feedClient = context.feedClient;
    final currentUser = StreamChat.of(context).currentUser;

    if (currentUser != null) {
      try {
        setState(() {
          btnStatus = true;
        });
        currentUser.extraData['image'] = avatarUrl;
        await client.updateUser(currentUser);
        if (widget.fromPage != 'select_sex') {
          await feedClient.updateUser(currentUser.id, {
            'name': currentUser.name,
            'avatar': currentUser.image,
            'gender': currentUser.extraData['sex'],
            'birthday': currentUser.extraData['birthday'],
            'role': 'user'
          });
        }

        if (widget.fromPage == 'select_sex') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectTroublePage()));
        } else {
          Navigator.pop(context);
        }
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
