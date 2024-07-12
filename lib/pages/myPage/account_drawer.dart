import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/pages/myPage/accout_page.dart';
import 'package:doceo_new/pages/myPage/coin_charge_page.dart';
import 'package:doceo_new/pages/myPage/font_size_setting_page.dart';
import 'package:doceo_new/pages/myPage/join_room_page.dart';
import 'package:doceo_new/pages/myPage/notification_setting_page.dart';
import 'package:doceo_new/pages/myPage/point_history_page.dart';
import 'package:doceo_new/pages/splash/sel_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:intl/intl.dart';

class AccountDrawer extends StatefulWidget {
  const AccountDrawer({super.key});

  @override
  State<AccountDrawer> createState() => _AccountDrawerState();
}

class _AccountDrawerState extends State<AccountDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onLogout() async {
    try {
      await Amplify.Auth.signOut();
      HomePage.index = TabItem.home;
      AuthenticateProviderPage.of(context, listen: false).isAuthenticated =
          false;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SelPage()));
    } on AuthException catch (e) {
      safePrint(e.message);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "サインアウト エラーです。もう一度お試しください。");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).client.state.currentUserStream;
    final formatter = NumberFormat.compact();

    return WillPopScope(
      child: BetterStreamBuilder(
          stream: StreamChat.of(context).client.state.currentUserStream,
          builder: (context, data) {
            var avatarUrl = data!.image ?? 'assets/images/avatars/default.png';
            var userName = data.name;

            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.only(right: 10, left: 0),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF9F0E0).withOpacity(0.65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 36,
                              width: 36,
                              child: SvgPicture.asset(
                                  'assets/images/coin-icon.svg',
                                  fit: BoxFit.cover)),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                data.extraData['point'] != null
                                    ? formatter.format(data.extraData['point'])
                                    : '0',
                                style: const TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF4F5660),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CoinChargePage()));
                            },
                            child: Container(
                                width: 24,
                                height: 24,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFFCC14C),
                                  shape: OvalBorder(),
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 20)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: avatarUrl.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                    image: avatarUrl.startsWith('assets')
                                        ? DecorationImage(
                                            image: AssetImage(avatarUrl),
                                            fit: BoxFit.contain)
                                        : DecorationImage(
                                            image: NetworkImage(avatarUrl),
                                            fit: BoxFit.contain),
                                    color: Colors.white,
                                    shape: BoxShape.circle))
                            : Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent,
                                ),
                                child: Text(
                                  userName.length >= 2
                                      ? userName.substring(0, 2).toUpperCase()
                                      : userName.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                      fontFamily: 'M_PLUS',
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: 'M_PLUS',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    myPageItem(
                        'アカウント', 'my-page-account.svg', const AccountPage()),
                    myPageItem('参加ROOM', 'room-icon-outlined.svg',
                        const JoinRoomPage()),
                    myPageItem('ポイント履歴', 'my-page-point-history.svg',
                        const PointHistoryPage()),
                    myPageItem('通知設定', 'my-page-notification.svg',
                        const NotificationSettingPage()),
                    myPageItem('文字サイズ', 'my-page-font-size.svg',
                        const FontSizeSettingPage()),
                    myPageItem('ログアウト', 'my-page-logout.svg', null, onLogout),
                  ],
                ),
              ),
            );
          }),
      onWillPop: () => Future.value(false),
    );
  }

  Widget myPageItem(String text, String fileName, Widget? page,
      [Function? handler]) {
    return TextButton(
        style: TextButton.styleFrom(
            foregroundColor: Colors.black12,
            backgroundColor: Colors.white,
            padding: EdgeInsets.zero),
        onPressed: () {
          if (page != null) {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          } else if (handler != null) {
            handler();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset('assets/images/$fileName',
                      color: page != null
                          ? const Color(0xFF4F5660)
                          : const Color(0xFFFF0000),
                      fit: BoxFit.contain,
                      height: 22,
                      width: 22),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  text,
                  style: TextStyle(
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: page != null
                          ? const Color(0xFF4F5660)
                          : const Color(0xFFFF0000)),
                ),
              ),
            ]),
          ),
        ));
  }
}
