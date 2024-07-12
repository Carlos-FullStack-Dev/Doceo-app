// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Models;
import 'package:doceo_new/pages/channels/users/doctor_page.dart';
import 'package:doceo_new/pages/channels/users/user_page.dart';
import 'package:doceo_new/pages/home/single_feed.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_feed/stream_feed.dart';

class FavListPage extends StatefulWidget {
  const FavListPage({super.key});

  @override
  _FavListPage createState() => _FavListPage();
}

class _FavListPage extends State<FavListPage> {
  final PagingController<int, GenericEnrichedActivity> _pagingController =
      PagingController(firstPageKey: 0);
  final _pageSize = 5;

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
    //NOTE: This members is example.

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            backgroundColor: Colors.white,
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
              title: const Text('いいね',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            body: RefreshIndicator(
                child: PagedListView<int, GenericEnrichedActivity>(
                  pagingController: _pagingController,
                  padding: EdgeInsets.zero,
                  builderDelegate: PagedChildBuilderDelegate<
                          GenericEnrichedActivity>(
                      itemBuilder: (context, item, index) {
                        final activity = item;

                        return Column(
                          children: [
                            ListTile(
                              isThreeLine: true,
                              trailing: Container(
                                width: width * 0.2,
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                    onTap: () {
                                      goToTargetFeed(
                                          activity.object['id'].toString());
                                    },
                                    child: Text(
                                      activity.object['message'].toString(),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF4F5660),
                                        fontSize: 13,
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )),
                              ),
                              leading: InkWell(
                                  onTap: () {
                                    if (activity.actor['role'] == 'doctor') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DoctorPage(
                                                    doctorId:
                                                        activity.actor['id'],
                                                  )));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserPage(
                                                    userId:
                                                        activity.actor['id'],
                                                  )));
                                    }
                                  },
                                  child: UtilHelper.feedAvatar(
                                      activity.actor['data']['avatar'], 25)),
                              title: Text(
                                activity.actor['data']['name'],
                                style: const TextStyle(
                                  color: Color(0xFF4F5660),
                                  fontSize: 15,
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'さんがいいねしました',
                                      style: TextStyle(
                                        color: Color(0xFFB4BABF),
                                        fontSize: 13,
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      UtilHelper.formatDate(activity.time!),
                                      style: const TextStyle(
                                        color: Color(0xFFB4BABF),
                                        fontSize: 13,
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ]),
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
                      },
                      newPageErrorIndicatorBuilder: (_) => Container(),
                      firstPageErrorIndicatorBuilder: (_) => Container(),
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
                                    child: const Text('あなたの投稿にいいねがつくとお知らせが届きます',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xffcbcbcb),
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal)))
                              ]))),
                ),
                onRefresh: () async {
                  _pagingController.refresh();
                })));
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final feedClient = context.feedClient;
      final currentUser = AuthenticateProviderPage.of(context).user['sub'];
      final feed =
          feedClient.notificationFeed('notification_like', currentUser);
      final newItems = await feed.getPaginatedActivities(
          offset: pageKey,
          limit: _pageSize,
          marker: ActivityMarker().allSeen());
      List<GenericEnrichedActivity> activities = [];

      for (final group in newItems.results!) {
        activities.addAll(group.activities!);
      }

      if (activities.length < _pageSize) {
        _pagingController.appendLastPage(activities);
      } else {
        final nextPageKey = pageKey + activities.length;
        _pagingController.appendPage(activities, nextPageKey);
      }
    } catch (error) {
      safePrint(error);
      _pagingController.error = error;
    }
  }

  void goToTargetFeed(String activityId) async {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];
    final userFeed = feedClient.flatFeed('user', currentUser);

    try {
      final res = await userFeed.getEnrichedActivities(
          limit: 1,
          filter: Filter()
              .idLessThanOrEqual(activityId)
              .idGreaterThanOrEqual(activityId),
          flags: EnrichmentFlags().withReactionCounts().withOwnReactions());
      final activity = res.first;

      final userInfo = User.fromJson(activity.actor);
      final externalData = activity.extraData!;
      Models.Tag? usertag;
      var room;
      final currentUserId = AuthenticateProviderPage.of(context).user['sub'];
      bool userFlag = (currentUserId == userInfo.id);
      String verbType = activity.verb!;
      Map reactionNum = activity.reactionCounts!;
      String id = activity.id!;
      final likeReactions = activity.ownReactions != null &&
              activity.ownReactions!['like'] != null
          ? activity.ownReactions!['like']!
          : [];
      String liked = '';
      try {
        liked = likeReactions
            .firstWhere((reaction) => reaction.userId == currentUser)
            .id;
      } catch (_) {}

      try {
        room = AppProviderPage.of(context, listen: true).rooms.firstWhere(
            (room) => room['channel']['id'] == externalData['room']);
      } catch (_) {}

      if (activity.extraData!['usertag'] != null) {
        try {
          usertag = AppProviderPage.of(context)
              .tags
              .firstWhere((tag) => tag.id == activity.extraData!['usertag']);
        } catch (_) {}
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SingleFeedScreen(
                  activity: activity,
                  userInfo: userInfo,
                  externalData: externalData,
                  usertag: usertag,
                  verbType: verbType,
                  userFlag: userFlag,
                  reactionNum: reactionNum,
                  likeReaction: liked,
                  foreignId: activity.foreignId,
                  time: activity.time,
                  room: room,
                  id: id)));
    } catch (e) {
      safePrint(e);
    }
  }
}
