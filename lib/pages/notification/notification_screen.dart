// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/components/show_channel_icon.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Model;
import 'package:doceo_new/pages/channels/type_1/channel_1_1_page.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_page.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_page.dart';
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/pages/notification/alert_page.dart';
import 'package:doceo_new/pages/notification/comment_list_page.dart';
import 'package:doceo_new/pages/notification/fav_list_page.dart';
import 'package:doceo_new/pages/notification/follower_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;

class NotificationScreen extends StatefulWidget {
  static int defaultIndex = 0;

  const NotificationScreen({super.key});

  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final currentUser = StreamChat.of(context).currentUser;
    print(currentUser!.id);
    // final announcementChannel =
    //     StreamChat.of(context).client.channel('announcement', id: 'all');
    // announcementChannel.watch();

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            backgroundColor: const Color(0xFFF2F2F2),
            body: SingleChildScrollView(
                child: SafeArea(
                    child: Container(
                        width: width,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'メッセージ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          const FavListPage())));
                                            },
                                            child: Container(
                                                height: height * 0.12,
                                                margin: const EdgeInsets.only(
                                                    right: 5, top: 5),
                                                alignment: Alignment.center,
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xFFB44DD9)),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(19),
                                                      bottomLeft:
                                                          Radius.circular(19),
                                                      bottomRight:
                                                          Radius.circular(19),
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/images/notification-like.svg',
                                                          fit: BoxFit.cover),
                                                      const SizedBox(
                                                          height: 10),
                                                      const Text(
                                                        'いいね',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFB44DD9),
                                                          fontSize: 13,
                                                          fontFamily: 'M_PLUS',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ])),
                                          ),
                                          FutureBuilder(
                                            future: getUnseenCount(
                                                'notification_like'),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData ||
                                                  snapshot.data! == 0) {
                                                return Container();
                                              }

                                              return Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Container(
                                                    width: 21,
                                                    height: 21,
                                                    decoration:
                                                        const ShapeDecoration(
                                                      color: Color(0xFFFF1717),
                                                      shape: OvalBorder(),
                                                    ),
                                                    child: Text(
                                                      snapshot.data.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontFamily: 'M_PLUS',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    )),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          const CommentListPage())));
                                            },
                                            child: Container(
                                                height: height * 0.12,
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 5, top: 5),
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xFF70A4F2)),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(19),
                                                      bottomLeft:
                                                          Radius.circular(19),
                                                      bottomRight:
                                                          Radius.circular(19),
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/images/notification-comment.svg',
                                                          fit: BoxFit.cover),
                                                      const SizedBox(
                                                          height: 10),
                                                      const Text(
                                                        'コメント',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF70A4F2),
                                                          fontSize: 13,
                                                          fontFamily: 'M_PLUS',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ])),
                                          ),
                                          FutureBuilder(
                                            future: getUnseenCount(
                                                'notification_comment'),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData ||
                                                  snapshot.data! == 0) {
                                                return Container();
                                              }

                                              return Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Container(
                                                    width: 21,
                                                    height: 21,
                                                    decoration:
                                                        const ShapeDecoration(
                                                      color: Color(0xFFFF1717),
                                                      shape: OvalBorder(),
                                                    ),
                                                    child: Text(
                                                      snapshot.data.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontFamily: 'M_PLUS',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    )),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              goToFollowerPage();
                                            },
                                            child: Container(
                                                height: height * 0.12,
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 5, top: 5),
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 0.75,
                                                        color:
                                                            Color(0xFF63CEF0)),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(19),
                                                      bottomLeft:
                                                          Radius.circular(19),
                                                      bottomRight:
                                                          Radius.circular(19),
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/images/notification-follower.svg',
                                                          fit: BoxFit.cover),
                                                      const SizedBox(
                                                          height: 10),
                                                      const Text(
                                                        'フォロワー',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF63CEF0),
                                                          fontSize: 13,
                                                          fontFamily: 'M_PLUS',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ])),
                                          ),
                                          FutureBuilder(
                                            future: getUnseenCount(
                                                'notification_follow'),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData ||
                                                  snapshot.data! == 0) {
                                                return Container();
                                              }

                                              return Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Container(
                                                    width: 21,
                                                    height: 21,
                                                    decoration:
                                                        const ShapeDecoration(
                                                      color: Color(0xFFFF1717),
                                                      shape: OvalBorder(),
                                                    ),
                                                    child: Text(
                                                      snapshot.data.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontFamily: 'M_PLUS',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    )),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          const AlertPage())));
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 5, top: 5),
                                                height: height * 0.12,
                                                alignment: Alignment.center,
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 0.75,
                                                        color:
                                                            Color(0xFF69E4BF)),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(19),
                                                      bottomLeft:
                                                          Radius.circular(19),
                                                      bottomRight:
                                                          Radius.circular(19),
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/images/notification-alert.svg',
                                                          fit: BoxFit.cover),
                                                      const Text(
                                                        'アラート',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF69E4BF),
                                                          fontSize: 13,
                                                          fontFamily: 'M_PLUS',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ])),
                                          ),
                                          FutureBuilder(
                                            future: getUnseenCount(
                                                'notification_alert'),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData ||
                                                  snapshot.data! == 0) {
                                                return Container();
                                              }

                                              return Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Container(
                                                    width: 21,
                                                    height: 21,
                                                    decoration:
                                                        const ShapeDecoration(
                                                      color: Color(0xFFFF1717),
                                                      shape: OvalBorder(),
                                                    ),
                                                    child: Text(
                                                      snapshot.data.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontFamily: 'M_PLUS',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    )),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                              const SizedBox(height: 15),
                              // StreamChannel(
                              //     channel: announcementChannel,
                              //     child: AnnouncementCard()),
                              StreamChannelListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  emptyBuilder: (BuildContext context) {
                                    return Container();
                                  },
                                  controller: StreamChannelListController(
                                      client: StreamChat.of(context).client,
                                      presence: false,
                                      // messageLimit: 300,
                                      filter: Filter.or([
                                        Filter.equal('cid', 'announcement:all'),
                                        Filter.and([
                                          Filter.in_(
                                            'members',
                                            [currentUser!.id],
                                          ),
                                          Filter.notEqual('type', 'room')
                                        ])
                                      ]),
                                      channelStateSort: const [
                                        SortOption('type',
                                            direction: SortOption.ASC),
                                        SortOption('unread_count',
                                            direction: SortOption.DESC)
                                      ]),
                                  separatorBuilder: (context, values, index) =>
                                      const SizedBox.shrink(),
                                  itemBuilder: _NotificationCard)
                              // _NotificationCard(),
                              // const SizedBox(height: 15),
                              // _NotificationCard(),
                              // const SizedBox(height: 15),
                              // _NotificationCard()
                            ]))))));
  }

  Future<int> getUnseenCount(String slug) async {
    try {
      final currentUser = AuthenticateProviderPage.of(context).user['sub'];
      final feedClient = context.feedClient;
      final notificationFeed = feedClient.notificationFeed(slug, currentUser);
      final res = await notificationFeed.getUnreadUnseenCounts();
      return res.unseenCount;
    } catch (e) {
      safePrint(e);
      rethrow;
    }
  }

  void goToFollowerPage() async {
    try {
      final currentUser = AuthenticateProviderPage.of(context).user['sub'];
      final feedClient = context.feedClient;
      final notificationFeed =
          feedClient.notificationFeed('notification_follow', currentUser);
      await notificationFeed.getUnreadUnseenCounts(
          marker: StreamFeed.ActivityMarker().allSeen());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) =>
                  FollowerPage(type: 'follower', userId: currentUser))));
    } catch (e) {
      safePrint(e);
    }
  }

  Widget _NotificationCard(context, channels, index, defaultWidget) {
    //NOTE: isUnread means whether there are messages which users haven't read yet.
    Channel channel = channels[index];
    final channelType = channel.type;
    final title = channel.name!;
    final date = channel.lastMessageAt;
    bool isUnread = channel.state!.unreadCount > 0;

    final widget = InkWell(
        onTap: () {
          if (channelType == 'channel-1' || channelType == 'announcement') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StreamChannel(
                  channel: channel,
                  child: const Type1Channel1Page(),
                ),
              ),
            );
          } else if (channelType == 'channel-2') {
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
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: isUnread
                ? [
                    const BoxShadow(
                      color: Color(0x268600FF),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ]
                : [],
          ),
          padding:
              const EdgeInsets.only(bottom: 10, top: 10, right: 20, left: 10),
          child: Row(
            children: [
              channelType == 'channel-1' ||
                      channelType == 'channel-2' ||
                      channelType == 'channel-3'
                  ? ShowChannelIcon(channelType: channelType)
                  : Image.asset('assets/images/robot-icon.png',
                      fit: BoxFit.cover, height: 40, width: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(
                          channelType == 'announcement' ? 'DOCEOガイド' : title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF4F5660),
                            fontSize: 15,
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.normal,
                          ),
                        )),
                        if (date != null)
                          Text(
                            UtilHelper.formatDate(date),
                            style: const TextStyle(
                              color: Color(0xFFB4BABF),
                              fontSize: 13,
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            channel.state!.lastMessage != null
                                ? channel.state!.lastMessage!.text.toString()
                                : 'No message',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFB4BABF),
                              fontSize: 15,
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (isUnread)
                          Container(
                            width: 40,
                            height: 23,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFF1717),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11.50),
                              ),
                            ),
                            child: Text(
                              channel.state!.unreadCount.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                      ],
                    ),
                  )
                ]),
              ),
            ],
          ),
        ));

    return channelType == 'announcement'
        ? widget
        : Dismissible(
            key: Key(channel.id!),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height * 0.1,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text('exit',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
            onDismissed: (DismissDirection direction) async {
              final currentUser = StreamChat.of(context).currentUser;
              await channel.watch();
              await channel.removeMembers([currentUser!.id]);
            },
            child: widget);
  }
}
