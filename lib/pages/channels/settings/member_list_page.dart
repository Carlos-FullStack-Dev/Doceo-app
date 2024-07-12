// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart';

class MemberListPage extends StatefulWidget {
  final List<Member> members;
  const MemberListPage({super.key, required this.members});

  @override
  _MemberListPage createState() => _MemberListPage();
}

class _MemberListPage extends State<MemberListPage> {
  Map<String, bool> isFollowing = {};

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
    final currentUser = StreamChat.of(context).currentUser;
    final members = widget.members;

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              title: Text('メンバーリスト (${members.length})',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: FutureBuilder(
                    future: _fetchPage(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: LoadingAnimation());
                      }

                      return ListView.builder(
                        // shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          final isFollowed =
                              isFollowing[member.userId] ?? false;

                          return Column(
                            children: [
                              ListTile(
                                trailing: member.user!.role == 'doctor' ||
                                        member.userId == currentUser!.id
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          if (isFollowed) {
                                            _showRemoveFollowDialog(
                                                context, member.userId!);
                                          } else {
                                            follow(member.userId);
                                          }
                                        },
                                        child: Container(
                                          width: 99,
                                          height: 39,
                                          decoration: ShapeDecoration(
                                            color: isFollowed
                                                ? const Color(0xFFF2F2F2)
                                                : const Color(0xFF69E4BF),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.50,
                                                color: isFollowed
                                                    ? const Color(0xFFF2F2F2)
                                                    : const Color(0xFF69E4BF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(19.50),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            isFollowed ? 'フォロー中' : 'フォロー',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: isFollowed
                                                  ? const Color(0xFFB4BABF)
                                                  : Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'M_PLUS',
                                              fontWeight: isFollowed
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                leading: UtilHelper.userAvatar(
                                    member.user!, 25, context),
                                title: Text(
                                  UtilHelper.getDisplayName(
                                      member.user!, 'channel-setting'),
                                  style: const TextStyle(
                                    color: Color(0xFF4F5660),
                                    fontSize: 15,
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (index != members.length - 1)
                                Container(
                                  width: width * 0.9,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 0.10,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        color: Color(0xFF4F5660),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    }))));
  }

  _showRemoveFollowDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.18,
            padding:
                const EdgeInsets.only(bottom: 20, top: 30, right: 20, left: 20),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'フォローを外しますか？',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4F5660),
                    fontSize: 17,
                    fontFamily: 'M_PLUS',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        unfollow(userId);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 45,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2F2F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.50),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '確認',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF4F5660),
                            fontSize: 17,
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 45,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF4F5660),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.50),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'キャンセル',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void unfollow(userId) async {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];
    final timelineFeed = feedClient.flatFeed('timeline', currentUser);
    try {
      await timelineFeed.unfollow(feedClient.flatFeed('user', userId));
      setState(() {
        isFollowing[userId] = false;
      });
      Navigator.of(context).pop();
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void follow(userId) async {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];
    final timelineFeed = feedClient.flatFeed('timeline', currentUser);
    final notificationFeed =
        feedClient.notificationFeed('notification_follow', userId);
    try {
      await timelineFeed.follow(feedClient.flatFeed('user', userId));
      final activity = Activity(
          actor: feedClient.user(currentUser).ref,
          object: '${currentUser}follows$userId',
          verb: 'follow');
      await notificationFeed.addActivity(activity);
      setState(() {
        isFollowing[userId] = true;
      });
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  Future<bool> _fetchPage() async {
    try {
      final feedClient = context.feedClient;
      final currentUserId = AuthenticateProviderPage.of(context).user['sub'];
      final feed = feedClient.flatFeed('timeline', currentUserId);
      final userIds = widget.members
          .where((member) => member.user!.role == 'user')
          .map((member) => member.userId)
          .toList();
      final followingStatus = await feed.following(
          filter: userIds.map((userId) => FeedId.id('user:$userId')).toList());
      Map<String, bool> res = {};
      for (final following in followingStatus) {
        final userId = following.targetId.substring(5);
        res[userId] = true;
      }
      setState(() {
        isFollowing = res;
      });
      return true;
    } catch (error) {
      safePrint(error);
      rethrow;
    }
  }
}
