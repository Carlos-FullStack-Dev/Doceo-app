// ignore_for_file: avoid_print

import 'package:doceo_new/pages/search/single_room_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  _JoinRoomPage createState() => _JoinRoomPage();
}

class _JoinRoomPage extends State<JoinRoomPage> {
  List rooms = [];

  @override
  void initState() {
    final roomSigned = AppProviderPage.of(context).roomSigned;
    final List totalRooms = AppProviderPage.of(context).rooms;

    setState(() {
      List temp = [];
      for (int i = 0; i < totalRooms.length; i++) {
        if (roomSigned[i]['status']) {
          temp.add(totalRooms[i]);
        }
      }

      rooms = temp;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            title: const Text('参加ROOM',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: rooms.isNotEmpty
            ? Container(
                decoration: const BoxDecoration(color: Colors.white),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: ((BuildContext context, int index) {
                      return _roomItem(rooms, index);
                    })))
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    SvgPicture.asset(
                      'assets/images/empty-room.svg',
                      fit: BoxFit.contain,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.only(left: 65, right: 65),
                        child: const Text(
                            '現在参加中のROOMがありません。ROOM検索画面より参加するROOMをお選びください',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xffcbcbcb),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.w500)))
                  ])));
  }

  Widget _roomItem(List rooms, int index) {
    final formatter = NumberFormat.compact();
    final roomName = rooms[index]['channel']['name'] ?? '';
    final int feedsCount = rooms[index]['channel']['feedsCount'] ?? 0;

    // final feed = feedClient.flatFeed('room', rooms[index]['channel']['id']);
    // feed.

    return InkWell(
        onTap: () {
          AppProviderPage.of(context).selectedRoom =
              rooms[index]['channel']['id'];
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SingleRoomPage()));
        },
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Color(0xFF4F5660), width: 0.2))),
            child: Row(
              children: [
                rooms[index]['channel']['image'] != null
                    ? Image.network(
                        rooms[index]['channel']['image'].toString(),
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/images/room-icon1.png',
                        fit: BoxFit.cover, width: 40, height: 40),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'M_PLUS',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '投稿件数 ${formatter.format(feedsCount)}件',
                        style: const TextStyle(
                            color: Color(0xffB4BABF),
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            fontStyle: FontStyle.normal),
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
