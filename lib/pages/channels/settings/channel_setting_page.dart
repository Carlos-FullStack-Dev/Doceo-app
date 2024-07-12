// ignore_for_file: avoid_print

import 'dart:math';

import 'package:doceo_new/helper/util_helper.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/channels/settings/member_list_page.dart';
import 'package:doceo_new/pages/search/search_screen.dart';
import 'package:doceo_new/pages/search/single_room_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelSettingPage extends StatefulWidget {
  // final Channel channel;
  const ChannelSettingPage({super.key});

  @override
  _ChannelSettingPage createState() => _ChannelSettingPage();
}

class _ChannelSettingPage extends State<ChannelSettingPage> {
  bool isMuted = false;
  bool isExiting = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      final channel = StreamChannel.of(context).channel;
      isMuted = channel.isMuted;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final channel = StreamChannel.of(context).channel;
    final totalRooms = AppProviderPage.of(context).rooms;
    final currentUser = StreamChat.of(context).currentUser;
    final roomIndex = totalRooms.indexWhere(
        (room) => room['channel']['id'] == channel.extraData['room']);
    final members = channel.state!.members
        .where((member) => member.userId != currentUser!.id)
        .toList();

    members.sort((a, b) {
      if (a.user!.role == 'doctor' && b.user!.role != 'doctor') {
        return -1;
      } else if (b.user!.role == 'doctor' && a.user!.role != 'doctor') {
        return -1;
      }

      return a.userId!.compareTo(b.userId!);
    });

    if (channel.extraData['owner'] != null) {
      members.sort((a, b) {
        if (a.userId == channel.extraData['owner']) {
          return -1;
        }
        if (b.userId == channel.extraData['owner']) {
          return 1;
        }
        return a.userId!.compareTo(b.userId!);
      });
    }

    final doctors = channel.type != 'channel-3'
        ? members.where((member) => member.user!.role == 'doctor').toList()
        : [];
    final users =
        members.where((member) => member.user!.role == 'user').toList();

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            backgroundColor: const Color(0xFFF2F2F2),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              title: Text('メンバー (${channel.state!.members.length})',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          Expanded(
                            child: doctors.isEmpty
                                ? GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                    ),
                                    itemCount: min(users.length, 10),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          UtilHelper.userAvatar(
                                              users[index].user!, 25, context),
                                          Text(
                                            UtilHelper.getDisplayName(
                                                users[index].user!,
                                                channel.type),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFF4F5660),
                                              fontSize: 15,
                                              fontFamily: 'M_PLUS',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                    ),
                                    itemCount: min(doctors.length, 5),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          UtilHelper.userAvatar(
                                              doctors[index].user!,
                                              25,
                                              context),
                                          Text(
                                            UtilHelper.getDisplayName(
                                                doctors[index].user!,
                                                channel.type),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFF4F5660),
                                              fontSize: 15,
                                              fontFamily: 'M_PLUS',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                          ),
                          if (doctors.isNotEmpty)
                            Expanded(
                                child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                              ),
                              itemCount: min(users.length, 5),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    UtilHelper.userAvatar(
                                        users[index].user!, 25, context),
                                    Text(
                                      UtilHelper.getDisplayName(
                                          users[index].user!, channel.type),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF4F5660),
                                        fontSize: 15,
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MemberListPage(members: members)));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'もっと見る',
                                  style: TextStyle(
                                    color: Color(0xFFB4BABF),
                                    fontSize: 15,
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    size: 17, color: Color(0xFFB4BABF))
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'グループチャット名',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  channel.name!,
                                  style: const TextStyle(
                                    color: Color(0xFFB4BABF),
                                    fontSize: 15,
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.10,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF4F5660),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'グループチャット紹介',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'M_PLUS',
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                    child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 15),
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          channel.extraData['description'] !=
                                                  null
                                              ? channel.extraData['description']
                                                  .toString()
                                              : 'No Description',
                                          style: const TextStyle(
                                            color: Color(0xFFB4BABF),
                                            fontSize: 15,
                                            fontFamily: 'M_PLUS',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.10,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF4F5660),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'ステータス',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: channel.type == 'channel-2'
                                    ? Wrap(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child: SvgPicture.asset(
                                                  'assets/images/coin-icon.svg',
                                                  height: 25,
                                                  width: 25,
                                                  fit: BoxFit.cover)),
                                          const Text(
                                            'D-COIN',
                                            style: TextStyle(
                                                color: Color(0xFFFCC14C),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      )
                                    : const Text(
                                        'Free',
                                        style: TextStyle(
                                          color: Color(0xFFB4BABF),
                                          fontSize: 15,
                                          fontFamily: 'M_PLUS',
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.10,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF4F5660),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  '連携しているROOM',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Text(
                                totalRooms[roomIndex]['channel']['name'],
                                style: const TextStyle(
                                  color: Color(0xFFB4BABF),
                                  fontSize: 15,
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    width: width,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'メッセージ通知',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        CupertinoSwitch(
                            activeColor: const Color(0xff7369E4),
                            value: isMuted != true,
                            onChanged: onToggleMutle)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    width: width,
                    alignment: Alignment.center,
                    child: InkWell(
                        onTap: () {
                          onExitChannel();
                        },
                        child: isExiting
                            ? const CircularProgressIndicator(
                                color: Color(0xFFFF4848),
                              )
                            : const Text(
                                'exit',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFFF4848),
                                  fontSize: 15,
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                ),
                              )),
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox.shrink()),
              ],
            )));
  }

  void onToggleMutle(newValue) async {
    try {
      final channel = StreamChannel.of(context).channel;
      if (newValue) {
        await channel.unmute();
      } else {
        await channel.mute();
      }
      setState(() {
        isMuted = !newValue;
      });
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void onExitChannel() async {
    setState(() {
      isExiting = true;
    });
    try {
      final currentUser = StreamChat.of(context).currentUser;
      final channel = StreamChannel.of(context).channel;
      await channel.watch();
      await channel.removeMembers([currentUser!.id]);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SingleRoomPage()));
    } catch (e) {
      setState(() {
        isExiting = false;
      });
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
