// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/pages/channels/type_1/channel_1_1_page.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_page.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class RoomEntrancePage extends StatefulWidget {
  final Channel channel;
  const RoomEntrancePage({super.key, required this.channel});

  @override
  _RoomEntrancePage createState() => _RoomEntrancePage();
}

class _RoomEntrancePage extends State<RoomEntrancePage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final channel = widget.channel;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  _showChannelTypeImage(channel),
                  Text(
                    '${channel.name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'メンバー ${channel.memberCount}人',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF4F5660),
                      fontSize: 15,
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 15),
                  channel.type != 'channel-2'
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 3),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF2F2F2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Free',
                            style: TextStyle(
                                color: Color(0xff4F5660),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.only(
                              left: 5, right: 15, top: 3, bottom: 3),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF8F0DF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Wrap(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 5),
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
                          ),
                        ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'グループチャット紹介',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'M_PLUS',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      channel.extraData['description'] != null
                          ? channel.extraData['description'].toString()
                          : 'No description',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Color(0xFF4F5660),
                        fontSize: 15,
                        fontFamily: 'M_PLUS',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  if (channel.extraData['owner'] != null)
                    FutureBuilder(
                      future: getOwnerData(channel.extraData['owner']),
                      builder: (((context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Container();
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            const Expanded(
                              child: Text(
                                'オーナー',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            UtilHelper.userAvatar(snapshot.data!, 10, context),
                            const SizedBox(width: 5),
                            Text(
                              UtilHelper.getDisplayName(
                                  snapshot.data!, channel.type),
                              style: const TextStyle(
                                color: Color(0xFF4F5660),
                                fontSize: 15,
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]),
                        );
                      })),
                    )
                ])),
            Positioned(
              bottom: 45,
              child: Container(
                width: width,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    goChannelDetail(channel);
                  },
                  child: Container(
                    width: width * 0.9,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE7FFF8),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.50, color: Color(0xFF69E4BF)),
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xFF69E4BF))
                        : const Text(
                            'チャットルームに入る',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF69E4BF),
                              fontSize: 17,
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void goChannelDetail(Channel channel) async {
    setState(() {
      isLoading = true;
    });
    try {
      final currentUser = StreamChat.of(context).currentUser;
      // print('User:${currentUser!.id}');
      // return;
      await channel.watch();
      await channel.addMembers([currentUser!.id]);
      if (((channel.type == 'channel-2' || channel.type == 'channel-3') &&
              currentUser.extraData['disable_other_notification'].toString() ==
                  'yes') ||
          (channel.type == 'channel-1' &&
              currentUser.extraData['disable_room_notification'].toString() ==
                  'yes')) {
        await channel.mute();
      }

      if (channel.type == 'channel-1') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: const Type1Channel1Page(),
            ),
          ),
        );
      } else if (channel.type == 'channel-2') {
        // AppProviderPage.of(context, listen: false).doctors = doctors;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: Type2Channel1Page(),
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: const Type3Channel1Page(),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<User?> getOwnerData(userId) async {
    final client = StreamChat.of(context).client;
    try {
      final res = await client.queryUsers(filter: Filter.equal('id', userId));
      return res.users.isNotEmpty ? res.users[0] : null;
    } catch (e) {
      safePrint(e);
      rethrow;
    }
  }

  Widget _showChannelTypeImage(channel) {
    print(channel.type);
    if (channel.type == 'channel-3') {
      return SizedBox(
        height: 140,
        width: 140,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 5,
              child: Image.asset('assets/images/avatars/avatar_0.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
            Positioned(
              top: 0,
              left: 5,
              child: Image.asset('assets/images/avatars/avatar_1.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
            Positioned(
              top: 60,
              right: 5,
              child: Image.asset('assets/images/avatars/avatar_5.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
            Positioned(
              top: 60,
              left: 5,
              child: Image.asset('assets/images/avatars/avatar_4.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
          ],
        ),
      );
    } else if (channel.type == 'channel-1') {
      return SizedBox(
        height: 190,
        width: 140,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 35,
              child: Image.asset('assets/images/avatars/dr_avatar_1.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
            Positioned(
                top: 80,
                right: 52.5,
                child: SvgPicture.asset('assets/images/down-arrow.svg',
                    height: 35, width: 35)),
            Positioned(
              bottom: 0,
              right: 5,
              child: Image.asset('assets/images/avatars/avatar_5.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
            Positioned(
              bottom: 0,
              left: 5,
              child: Image.asset('assets/images/avatars/avatar_4.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 190,
        width: 140,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 5,
              child: Image.asset('assets/images/avatars/dr_avatar_1.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
            Positioned(
              top: 0,
              left: 5,
              child: Image.asset('assets/images/avatars/dr_avatar_0.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
            Positioned(
                top: 85,
                right: 57,
                child: SvgPicture.asset('assets/images/close-icon.svg',
                    height: 26, width: 26)),
            Positioned(
              bottom: 0,
              right: 5,
              child: Image.asset('assets/images/avatars/avatar_5.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
            Positioned(
              bottom: 0,
              left: 5,
              child: Image.asset('assets/images/avatars/avatar_4.png',
                  fit: BoxFit.cover, height: 70, width: 70),
            ),
          ],
        ),
      );
    }
  }
}
