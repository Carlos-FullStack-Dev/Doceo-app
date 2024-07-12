// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  _NotificationSettingPage createState() => _NotificationSettingPage();
}

class _NotificationSettingPage extends State<NotificationSettingPage> {
  late int myRooms;

  void _loadData() async {
    var roomSigned = AppProviderPage.of(context, listen: false).roomSigned;
    int count = 0;

    for (int i = 0; i < roomSigned.length; i++) {
      if (roomSigned[i]['status'] == true) {
        count++;
      }
    }

    myRooms = count;
  }
  // }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final client = StreamChat.of(context).client;

    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
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
            centerTitle: true,
            backgroundColor: Colors.white,
            title: const Text('通知設定',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: BetterStreamBuilder(
            stream: client.state.usersStream,
            builder: (context, data) {
              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.04, top: 30, bottom: 10),
                      child: const Text('全体管理',
                          style: TextStyle(
                              color: Color(0xffB4BABF),
                              fontFamily: 'M_PLUS',
                              fontSize: 13,
                              fontWeight: FontWeight.normal)),
                    ),
                    Container(
                      width: width,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: width * 0.04),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('新しいフォロワー',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                          ),
                          CupertinoSwitch(
                              activeColor: const Color(0xff7369E4),
                              value: StreamChat.of(context)
                                      .currentUser!
                                      .extraData[
                                          'disable_notifciation_follower']
                                      .toString() !=
                                  'yes',
                              onChanged: (newValue) async {
                                var currentUser =
                                    StreamChat.of(context).currentUser;
                                currentUser!.extraData[
                                        'disable_notifciation_follower'] =
                                    newValue ? 'no' : 'yes';
                                StreamChat.of(context).currentUser!.extraData[
                                        'disable_notifciation_follower'] =
                                    newValue ? 'no' : 'yes';
                                await client.updateUser(currentUser);
                              }),
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: width * 0.04),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('コメント',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                          ),
                          CupertinoSwitch(
                              activeColor: const Color(0xff7369E4),
                              value: StreamChat.of(context)
                                      .currentUser!
                                      .extraData['disable_notifciation_comment']
                                      .toString() !=
                                  'yes',
                              onChanged: (newValue) async {
                                var currentUser =
                                    StreamChat.of(context).currentUser;
                                currentUser!.extraData[
                                        'disable_notifciation_comment'] =
                                    newValue ? 'no' : 'yes';
                                StreamChat.of(context).currentUser!.extraData[
                                        'disable_notifciation_comment'] =
                                    newValue ? 'no' : 'yes';
                                await client.updateUser(currentUser);
                              }),
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: width * 0.04),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('投稿へのいいね',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                          ),
                          CupertinoSwitch(
                              activeColor: const Color(0xff7369E4),
                              value: StreamChat.of(context)
                                      .currentUser!
                                      .extraData['disable_notifciation_like']
                                      .toString() !=
                                  'yes',
                              onChanged: (newValue) async {
                                var currentUser =
                                    StreamChat.of(context).currentUser;
                                currentUser!.extraData[
                                        'disable_notifciation_like'] =
                                    newValue ? 'no' : 'yes';
                                StreamChat.of(context).currentUser!.extraData[
                                        'disable_notifciation_like'] =
                                    newValue ? 'no' : 'yes';
                                await client.updateUser(currentUser);
                              }),
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: width * 0.04),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('参加ROOM内の新しい投稿',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                          ),
                          CupertinoSwitch(
                              activeColor: const Color(0xff7369E4),
                              value: StreamChat.of(context)
                                      .currentUser!
                                      .extraData[
                                          'disable_notifciation_room_pos']
                                      .toString() !=
                                  'yes',
                              onChanged: (newValue) async {
                                var currentUser =
                                    StreamChat.of(context).currentUser;
                                currentUser!.extraData[
                                        'disable_notifciation_room_pos'] =
                                    newValue ? 'no' : 'yes';
                                StreamChat.of(context).currentUser!.extraData[
                                        'disable_notifciation_room_pos'] =
                                    newValue ? 'no' : 'yes';
                                await client.updateUser(currentUser);
                              }),
                        ],
                      ),
                    )
                  ]));
            }));
  }
}
