// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/pages/channels/users/user_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;

class FollowerPage extends StatefulWidget {
  String? type;
  String userId;

  FollowerPage({super.key, this.type, required this.userId});

  @override
  _FollowerPage createState() => _FollowerPage();
}

class _FollowerPage extends State<FollowerPage> {
  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: 0);
  final _pageSize = 5;
  Map<String, bool> isFollowing = {};

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final type = widget.type;

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
              title: Text(type == 'follower' ? 'フォロワー' : 'フォロー中',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                _pagingController.refresh();
              },
              child: PagedListView<int, User>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<User>(
                      noItemsFoundIndicatorBuilder: (_) => Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                SvgPicture.asset(
                                  'assets/images/empty-notification.svg',
                                  fit: BoxFit.contain,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 30),
                                    padding: const EdgeInsets.only(
                                        left: 55, right: 55),
                                    child: const Text('あなたがフォローされるとお知らせが届きます',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xffcbcbcb),
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal)))
                              ])),
                      itemBuilder: (context, item, index) {
                        final isFollowed = isFollowing[item.id] ?? false;
                        final currentUser =
                            AuthenticateProviderPage.of(context).user['sub'];

                        return Column(
                          children: [
                            ListTile(
                              trailing: item.id != currentUser
                                  ? InkWell(
                                      onTap: () {
                                        if (isFollowed) {
                                          _showRemoveFollowDialog(
                                              context, item.id!);
                                        } else {
                                          follow(item.id!);
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
                                    )
                                  : const SizedBox(),
                              leading: UtilHelper.userAvatar(item, 25, context),
                              title: Text(
                                UtilHelper.getDisplayName(item, 'follower'),
                                style: const TextStyle(
                                  color: Color(0xFF4F5660),
                                  fontSize: 15,
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                          ],
                        );
                      })),
            )));
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
      final activity = StreamFeed.Activity(
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

  Future<void> _fetchPage(int pageKey) async {
    try {
      final feedClient = context.feedClient;
      final currentUserId = AuthenticateProviderPage.of(context).user['sub'];
      final client = StreamChat.of(context).client;
      final feed = feedClient.flatFeed(
          widget.type == 'follower' ? 'user' : 'timeline', widget.userId);
      final originItems = widget.type == 'follower'
          ? await feed.followers(offset: pageKey, limit: _pageSize)
          : await feed.following(offset: pageKey, limit: _pageSize);
      final newItems = originItems.where((item) {
        final feedId = widget.type == 'following' ? item.targetId : item.feedId;
        return feedId.startsWith('timeline:') || feedId.startsWith('user:');
      }).toList();
      final userIds = newItems.map((item) {
        final feedId = widget.type == 'following' ? item.targetId : item.feedId;
        final id = feedId.substring(feedId.startsWith('timeline:') ? 9 : 5);
        return id;
      }).toList();
      List<User> res = [];
      if (userIds.isNotEmpty) {
        final response =
            await client.queryUsers(filter: Filter.in_('id', userIds));
        res = response.users;
      }
      Map<String, bool> temp = {};

      if (widget.type == 'follower' ||
          (widget.type == 'following' && currentUserId != widget.userId)) {
        final followingStatus = await feedClient
            .flatFeed('timeline', currentUserId)
            .following(
                filter: userIds
                    .map((userId) => StreamFeed.FeedId.id('user:$userId'))
                    .toList());
        for (final following in followingStatus) {
          final userId = following.targetId.substring(5);
          temp[userId] = true;
        }
      } else {
        for (final userId in userIds) {
          temp[userId] = true;
        }
      }

      setState(() {
        temp.forEach((key, value) {
          isFollowing[key] = value;
        });
      });

      if (originItems.length < _pageSize) {
        _pagingController.appendLastPage(res);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(res, nextPageKey);
      }
    } catch (error) {
      safePrint(error);
      _pagingController.error = error;
    }
  }
}
