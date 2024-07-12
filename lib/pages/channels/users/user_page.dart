// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/getstream/custom_flat_feed.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Models;
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/pages/myPage/my_trouble_page.dart';
import 'package:doceo_new/pages/notification/follower_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;

class UserPage extends StatefulWidget {
  String userId;
  UserPage({super.key, required this.userId});

  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool isFollowing = false;
  bool isLoading = true;
  List<Channel> rooms = [];
  int followers = 0;
  int followings = 0;
  late User userInfo;

  @override
  void initState() {
    super.initState();
    getUserData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final formatter = NumberFormat.compact();
    final dateFormatter = DateFormat.yMd('ja');
    final avatarUrl = isLoading
        ? 'assets/images/avatars/default.png'
        : userInfo.image ?? 'assets/images/avatars/default.png';
    final userName = isLoading ? '' : userInfo.name;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          backgroundColor: const Color(0xffF8F8F8),
          body: isLoading
              ? const LoadingAnimation()
              : Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          // height: height * 0.41,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/my-page-header.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 0, bottom: 15),
                          alignment: Alignment.centerLeft,
                          child: SafeArea(
                            bottom: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                    const Expanded(child: SizedBox.shrink()),
                                    InkWell(
                                      onTap: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoActionSheet(
                                            actions: <Widget>[
                                              CupertinoActionSheetAction(
                                                child: const Text(
                                                    '不適切なアカウントとして通報',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFF4848),
                                                        fontFamily: 'M_PLUS',
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                onPressed: () {
                                                  reportUser();
                                                },
                                              ),
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              child: const Text('キャンセル',
                                                  style: TextStyle(
                                                      color: Color(0xff1997F6),
                                                      fontFamily: 'M_PLUS',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        '…',
                                        style: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: avatarUrl.isNotEmpty
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    image: avatarUrl.startsWith(
                                                            'assets')
                                                        ? DecorationImage(
                                                            image: AssetImage(
                                                                avatarUrl),
                                                            fit: BoxFit.contain)
                                                        : DecorationImage(
                                                            image: NetworkImage(
                                                                avatarUrl),
                                                            fit:
                                                                BoxFit.contain),
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
                                                      ? userName
                                                          .substring(0, 2)
                                                          .toUpperCase()
                                                      : userName
                                                          .substring(0, 1)
                                                          .toUpperCase(),
                                                  style: const TextStyle(
                                                      fontFamily: 'M_PLUS',
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${dateFormatter.format(userInfo.createdAt)} から利用中',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontFamily: 'M_PLUS',
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  userInfo.extraData['intro'] != null
                                      ? userInfo.extraData['intro'].toString()
                                      : 'No introduction',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 15,
                                  runSpacing: 12,
                                  direction: Axis.horizontal,
                                  children: [
                                    if (rooms.isEmpty)
                                      Row(children: [
                                        SvgPicture.asset(
                                          'assets/images/room-icon-outlined.svg',
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 5),
                                        const Text(
                                          'no joined ROOMs',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontFamily: 'M_PLUSå',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ]),
                                    for (var room in rooms) ...[
                                      Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            room.image != null
                                                ? Image.network(
                                                    room.image!,
                                                    height: 27,
                                                    width: 27,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/images/room-icon1.png',
                                                    fit: BoxFit.cover,
                                                    width: 27,
                                                    height: 27),
                                            const SizedBox(width: 5),
                                            Text(
                                              room.name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontFamily: 'M_PLUSå',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ])
                                    ]
                                  ],
                                ),
                                const SizedBox(height: 12),
                                FutureBuilder<List<Models.Tag>>(
                                    future: getUserTags(widget.userId),
                                    builder: ((context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Row(children: [
                                          Container(
                                              alignment: Alignment.center,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 15),
                                              decoration: ShapeDecoration(
                                                color: const Color(0xADF2F2F2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                              ),
                                              child: const Text(
                                                'Not set',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF4F5660),
                                                  fontSize: 13,
                                                  fontFamily: 'M_PLUS',
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ))
                                        ]);
                                      }

                                      return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyTroublePage(
                                                            userId:
                                                                widget.userId,
                                                            isEditable:
                                                                false)));
                                          },
                                          child: Wrap(
                                              spacing: 12,
                                              runSpacing: 12,
                                              runAlignment: WrapAlignment.start,
                                              children: [
                                                ...snapshot.data!
                                                    .map((tag) => Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      3),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 5),
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: const Color(
                                                                0xADF2F2F2),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            tag.name,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF4F5660),
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'M_PLUS',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 3),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        const Color(0xADF2F2F2),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  child: const Icon(Icons
                                                      .keyboard_control_outlined),
                                                )
                                              ]));
                                    })),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowerPage(
                                                        type: 'following',
                                                        userId: widget.userId,
                                                      )));
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              formatter.format(followings),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontFamily: 'M_PLUS',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const Text(
                                              'フォロー中',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontFamily: 'M_PLUS',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(width: 20),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowerPage(
                                                      type: 'follower',
                                                      userId: widget.userId,
                                                    )));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            formatter.format(followers),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: 'M_PLUS',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          const Text(
                                            'フォロワー',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontFamily: 'M_PLUS',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: width,
                          color: Colors.white,
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                for (var i = 0; i < 2; i++)
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 10),
                                    child: InkWell(
                                      onTap: () {
                                        _tabController.animateTo(i);
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        // padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(i == 0 ? 'つぶやき' : '診察レポート',
                                                style: TextStyle(
                                                    fontFamily: 'M_PLUS',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        _selectedIndex == i
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                    color: _selectedIndex == i
                                                        ? Colors.black
                                                        : const Color(
                                                            0xffB4BABF))),
                                            const SizedBox(height: 7),
                                            if (_selectedIndex == i)
                                              Container(
                                                height: 3,
                                                width: width * 0.1,
                                                decoration: ShapeDecoration(
                                                  color: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.50),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ]),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  CustomFlatFeed(
                                      context: context,
                                      id: widget.userId,
                                      type: 'user',
                                      showUser: false,
                                      verbFilter: 'tweet',
                                      noItem: _emptyPage(context, 'tweet')),
                                  CustomFlatFeed(
                                      context: context,
                                      id: widget.userId,
                                      type: 'user',
                                      showUser: false,
                                      verbFilter: 'diary',
                                      noItem: _emptyPage(context, 'diary')),
                                ],
                              )),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        color: Colors.white,
                        width: width,
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, top: 10, bottom: 10),
                        child: FutureBuilder(
                            future: following(),
                            builder: (context, snapshot) {
                              final isFollowing =
                                  snapshot.hasData && snapshot.data!;

                              return SafeArea(
                                top: false,
                                child: InkWell(
                                  onTap: () {
                                    if (snapshot.hasData) {
                                      if (isFollowing) {
                                        unfollow();
                                      } else {
                                        follow();
                                      }
                                    }
                                  },
                                  child: Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      decoration: ShapeDecoration(
                                        color: isFollowing
                                            ? const Color(0xFFF2F2F2)
                                            : const Color(0xFF69E4BF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                      ),
                                      child: Text(
                                        isFollowing ? 'フォロー中' : 'フォロー',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isFollowing
                                              ? const Color(0xFFB4BABF)
                                              : Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'M_PLUS',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                )),
    );
  }

  void reportUser() async {
    final client = StreamChat.of(context).client;
    try {
      await client.partialUpdateUser(widget.userId, set: {'reported': true});
      Navigator.pop(context);
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void unfollow() async {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];
    final timelineFeed = feedClient.flatFeed('timeline', currentUser);
    try {
      await timelineFeed.unfollow(feedClient.flatFeed('user', widget.userId));
      setState(() {
        isFollowing = false;
      });
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void follow() async {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];
    final timelineFeed = feedClient.flatFeed('timeline', currentUser);
    final notificationFeed =
        feedClient.notificationFeed('notification_follow', widget.userId);
    try {
      await timelineFeed.follow(feedClient.flatFeed('user', widget.userId));
      final activity = StreamFeed.Activity(
          actor: feedClient.user(currentUser).ref,
          object: '${currentUser}follows${widget.userId}',
          verb: 'follow');
      await notificationFeed.addActivity(activity);
      setState(() {
        isFollowing = true;
      });
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void getUserData() async {
    try {
      final client = StreamChat.of(context).client;
      final res =
          await client.queryUsers(filter: Filter.equal('id', widget.userId));
      final roomsRes = await client
          .queryChannels(
              filter: Filter.and([
            Filter.equal('type', 'room'),
            Filter.in_('members', [widget.userId])
          ]))
          .first;
      final feedClient = context.feedClient;
      final followingRes = await feedClient
          .flatFeed('timeline', widget.userId)
          .followStats(followingSlugs: ['user']);
      final followerRes = await feedClient
          .flatFeed('user', widget.userId)
          .followStats(followerSlugs: ['timeline']);

      setState(() {
        rooms = roomsRes;
        userInfo = res.users.first;
        isLoading = false;
        followings = followingRes.following.count ?? 0;
        followers = followerRes.followers.count ?? 0;
      });
    } catch (e) {
      safePrint(e);
      rethrow;
    }
  }

  Future<bool> following() async {
    try {
      final feedClient = context.feedClient;
      final currentUser = AuthenticateProviderPage.of(context).user['sub'];
      final timelineFeed = feedClient.flatFeed('timeline', currentUser);
      final following = await timelineFeed
          .following(filter: [StreamFeed.FeedId('user', widget.userId)]);
      return following.isNotEmpty;
    } catch (e) {
      safePrint(e);
      rethrow;
    }
  }

  Future<List<Models.Tag>> getUserTags(userId) async {
    try {
      final query = Models.UserTag.USERID.eq(userId);
      final request =
          ModelQueries.list(Models.UserTag.classType, where: query, limit: 2);
      final response = await Amplify.API.query(request: request).response;
      if (response.data != null) {
        final userTags = response.data!.items;

        return userTags
            .where((userTag) => userTag!.tag != null)
            .map((userTag) => userTag!.tag!)
            .toList();
      }
      return [];
    } catch (e) {
      safePrint(e);
      return [];
    }
  }

  Future<List<Channel>> getJoinedRooms() async {
    final client = StreamChat.of(context).client;
    try {
      final res = await client
          .queryChannels(
              filter: Filter.and([
            Filter.equal('type', 'room'),
            Filter.in_('members', [widget.userId])
          ]))
          .first;
      return res;
    } catch (e) {
      safePrint(e);
      rethrow;
    }
  }

  Widget _emptyPage(BuildContext context, String verb) {
    return const Center(
        child: Text('まだ投稿がありません',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xffb4babf),
                fontFamily: 'M_PLUS',
                fontSize: 15,
                fontWeight: FontWeight.normal)));
  }
}
