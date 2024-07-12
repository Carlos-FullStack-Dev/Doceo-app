import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/getstream/fullscreen_image_viewer.dart';
import 'package:doceo_new/helper/feedVideo.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/channels/users/doctor_page.dart';
import 'package:doceo_new/pages/channels/users/user_page.dart';
import 'package:doceo_new/pages/home/single_feed.dart';
import 'package:doceo_new/pages/search/single_room_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;
import 'package:video_player/video_player.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFeedCard extends StatefulWidget {
  BuildContext context;
  StreamFeed.GenericEnrichedActivity activity;
  bool showUser;
  CustomFeedCard({
    super.key,
    required this.activity,
    required this.context,
    this.showUser = true,
  });
  @override
  _CustomFeedCard createState() => _CustomFeedCard();
}

class _CustomFeedCard extends State<CustomFeedCard> {
  bool isDeleted = false;
  String likeReaction = '';
  int likeCount = 0;
  late bool expanded = widget.activity.extraData!['message'] != null &&
      widget.activity.extraData!['message'].toString().length <= 140;

  @override
  void initState() {
    super.initState();
    setState(() {
      final currentUser = AuthenticateProviderPage.of(context).user['sub'];
      final likeReactions = widget.activity.ownReactions != null &&
              widget.activity.ownReactions!['like'] != null
          ? widget.activity.ownReactions!['like']!
          : [];
      String liked = '';
      try {
        liked = likeReactions
            .firstWhere((reaction) => reaction.userId == currentUser)
            .id;
      } catch (_) {}
      likeReaction = liked;
      likeCount = widget.activity.reactionCounts!['like'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isDeleted) {
      return const Text('The post was deleted',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'M_PLUS',
              fontSize: 15,
              fontWeight: FontWeight.normal));
    }

    final userInfo = StreamFeed.User.fromJson(widget.activity.actor);
    final externalData = widget.activity.extraData!;
    Tag? usertag;
    var room;
    final currentUserId = AuthenticateProviderPage.of(context).user['sub'];
    bool userFlag = (currentUserId == userInfo.id);
    String verbType = widget.activity.verb!;
    Map reactionNum = widget.activity.reactionCounts!;
    String id = widget.activity.id!;

    try {
      room = AppProviderPage.of(context, listen: true)
          .rooms
          .firstWhere((room) => room['channel']['id'] == externalData['room']);
    } catch (_) {}

    if (widget.activity.extraData!['usertag'] != null) {
      try {
        usertag = AppProviderPage.of(context).tags.firstWhere(
            (tag) => tag.id == widget.activity.extraData!['usertag']);
      } catch (_) {}
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleFeedScreen(
                    activity: widget.activity,
                    userInfo: userInfo,
                    externalData: externalData,
                    usertag: usertag,
                    verbType: verbType,
                    userFlag: userFlag,
                    reactionNum: reactionNum,
                    likeReaction: likeReaction,
                    foreignId: widget.activity.foreignId,
                    time: widget.activity.time,
                    room: room,
                    id: id)));
      },
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(13))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.showUser)
                    InkWell(
                      onTap: () {
                        if (!userFlag) {
                          if (userInfo.data!['role'] != 'doctor') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserPage(userId: userInfo.id!)));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DoctorPage(doctorId: userInfo.id!)));
                          }
                        }
                      },
                      child: UtilHelper.feedAvatar(
                          userInfo.data!['avatar'] as String?, 21),
                    ),
                  if (widget.showUser) const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.showUser)
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            children: [
                              Text(
                                  userInfo.data!['role'] == 'doctor'
                                      ? '${userInfo.data!['lastName']}医師'
                                      : userInfo.data!['name'].toString(),
                                  textAlign: TextAlign.left,
                                  style: AppStyles.feedUserName),
                              if (verbType == 'tweet' &&
                                  widget.activity.extraData!['emotion'] !=
                                      null &&
                                  widget.activity.extraData!['emotion'] != '')
                                SvgPicture.asset(
                                  'assets/images/emo_${widget.activity.extraData!['emotion'].toString()}.svg',
                                  fit: BoxFit.cover,
                                  width: 19,
                                  height: 19,
                                )
                            ]),
                      if (widget.activity.time != null)
                        Text(
                            '${UtilHelper.formatDate(widget.activity.time!)}${usertag != null ? ' ・ ${usertag.name}' : ''}',
                            style: AppStyles.feedDate),
                    ],
                  )),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          if (userFlag) {
                            ownActions();
                          } else {
                            otherActions();
                          }
                        },
                        child: const Text('…',
                            style: TextStyle(
                                color: Color(0xffD9D9D9),
                                fontFamily: 'M_PLUS',
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (verbType == 'diary')
                          Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              child: Row(children: [
                                SvgPicture.asset(
                                    'assets/images/check-icon.svg'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    UtilHelper.getReasonText(
                                        externalData['reason'].toString()),
                                    textAlign: TextAlign.left,
                                    style: AppStyles.feedUserName)
                              ])),
                        (externalData['message'] != null)
                            ? expanded ||
                                    externalData['message'].toString().length <=
                                        140
                                ? Linkify(
                                    onOpen: (link) async {
                                      if (!await launchUrl(Uri.parse(link.url),
                                          mode: LaunchMode.inAppWebView)) {
                                        throw Exception(
                                            'Could not launch ${link.url}');
                                      }
                                    },
                                    text: externalData['message'].toString(),
                                    textAlign: TextAlign.left,
                                    style: AppStyles.replyMessage,
                                    linkStyle: AppStyles.replyMessage.copyWith(
                                        color: const Color(0xff1997F6)))
                                : RichText(
                                    text: TextSpan(children: [
                                    WidgetSpan(
                                        baseline: TextBaseline.ideographic,
                                        alignment: PlaceholderAlignment.middle,
                                        child: Linkify(
                                            onOpen: (link) async {
                                              if (!await launchUrl(
                                                  Uri.parse(link.url),
                                                  mode: LaunchMode
                                                      .inAppWebView)) {
                                                throw Exception(
                                                    'Could not launch ${link.url}');
                                              }
                                            },
                                            text:
                                                '${externalData['message'].toString().substring(0, 140)}...',
                                            textAlign: TextAlign.left,
                                            style: AppStyles.replyMessage,
                                            linkStyle: AppStyles.replyMessage
                                                .copyWith(
                                                    color: const Color(
                                                        0xff1997F6)))),
                                    WidgetSpan(
                                        baseline: TextBaseline.ideographic,
                                        alignment: PlaceholderAlignment.middle,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(0)),
                                          child: Text(
                                            'more',
                                            style: AppStyles.replyMessage
                                                .copyWith(
                                                    color: const Color(
                                                        0xff1997F6)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              expanded = true;
                                            });
                                          },
                                        ))
                                  ]))
                            : const SizedBox(),
                        if (room != null ||
                            (externalData['hospital'] != null &&
                                externalData['hospital'] != '') ||
                            externalData['doctorName'] != null &&
                                externalData['doctorName'] != '')
                          Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child:
                                  Wrap(runSpacing: 10, spacing: 10, children: [
                                if (externalData['hospital'] != null &&
                                    externalData['hospital'] != '')
                                  IntrinsicWidth(
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            right: 10,
                                            left: 10),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/images/hospital-gray.svg',
                                                fit: BoxFit.cover),
                                            const SizedBox(width: 10),
                                            Text(
                                                externalData['hospital']
                                                    .toString(),
                                                style: AppStyles.feedUserName),
                                          ],
                                        )),
                                  ),
                                if (externalData['doctorName'] != null &&
                                    externalData['doctorName'] != '')
                                  InkWell(
                                      onTap: () {
                                        if (externalData['doctorId'] != null &&
                                            externalData['doctorId'] != '') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DoctorPage(
                                                          doctorId: externalData[
                                                                  'doctorId']
                                                              .toString())));
                                        }
                                      },
                                      child: IntrinsicWidth(
                                        child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                right: 10,
                                                left: 10),
                                            decoration: BoxDecoration(
                                                color: const Color(0xffF2F2F2),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Row(
                                              children: [
                                                externalData['doctorIcon'] !=
                                                        null
                                                    ? CircleAvatar(
                                                        radius: 9.5,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                externalData[
                                                                        'doctorIcon']
                                                                    .toString()),
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/images/select-doctor.svg',
                                                        fit: BoxFit.cover),
                                                const SizedBox(width: 10),
                                                Text(
                                                    externalData['doctorName']
                                                        .toString(),
                                                    style:
                                                        AppStyles.feedUserName),
                                              ],
                                            )),
                                      )),
                                if (room != null)
                                  IntrinsicWidth(
                                      child: InkWell(
                                    onTap: () {
                                      AppProviderPage.of(context).selectedRoom =
                                          room['channel']['id'];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SingleRoomPage()));
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            right: 10,
                                            left: 10),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Row(
                                          children: [
                                            (room['channel']['image'] != null)
                                                ? Image.network(
                                                    room['channel']['image'],
                                                    fit: BoxFit.cover,
                                                    width: 23,
                                                    height: 23)
                                                : Image.asset(
                                                    'assets/images/room-icon1.png',
                                                    fit: BoxFit.cover,
                                                    width: 25,
                                                    height: 25),
                                            const SizedBox(width: 10),
                                            Text(room['channel']['name'],
                                                style: AppStyles.feedUserName),
                                          ],
                                        )),
                                  ))
                              ])),
                        (externalData['filePath'] != null
                            ? const SizedBox(height: 20)
                            : Container()),
                        (externalData['filePath'] != null
                            ? (externalData['fileType'] == "image")
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenImageViewer(
                                                      externalData['filePath']
                                                          .toString())));
                                    },
                                    child: Image.network(
                                      externalData['filePath'].toString(),
                                      fit: BoxFit.cover,
                                    ))
                                : (externalData['fileType'] == "video")
                                    ? FeedVideoPlayer(
                                        videoPlayerController:
                                            VideoPlayerController.network(
                                                externalData['filePath']
                                                    .toString(),
                                                videoPlayerOptions:
                                                    VideoPlayerOptions()),
                                        looping: false,
                                        autoplay: false,
                                      )
                                    : (externalData['fileType'] == "file")
                                        ? const Text(
                                            'File',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          )
                                        : const Text('')
                            : Container()),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (reactionNum['alert'] != null &&
                                  reactionNum['alert'] > 0)
                                SvgPicture.asset('assets/images/warning.svg',
                                    fit: BoxFit.cover, width: 25, height: 29),
                              Expanded(child: Container()),
                              SvgPicture.asset('assets/images/comment.svg',
                                  fit: BoxFit.cover, height: 28, width: 28),
                              const SizedBox(width: 15),
                              (reactionNum['comment'] != null)
                                  ? Text(
                                      UtilHelper.convertNumberWithPrefix(
                                          reactionNum['comment']),
                                      style: AppStyles.feedUserName)
                                  : Text('0', style: AppStyles.feedUserName),
                              const SizedBox(width: 25),
                              InkWell(
                                onTap: () {
                                  if (!userFlag) {
                                    toggleLikePost();
                                  }
                                },
                                child: likeReaction.isNotEmpty
                                    ? SvgPicture.asset(
                                        'assets/images/like_red.svg',
                                        fit: BoxFit.cover)
                                    : SvgPicture.asset('assets/images/like.svg',
                                        fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                  UtilHelper.convertNumberWithPrefix(likeCount),
                                  style: AppStyles.feedUserName)
                            ])
                      ]))
            ])),
      ]),
    );
  }

  void ownActions() {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];
    final feed = feedClient.flatFeed('user', currentUser);

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('投稿を削除する',
                style: TextStyle(
                    color: Color(0xffFF4848),
                    fontFamily: 'M_PLUS',
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
            onPressed: () async {
              try {
                await feed.removeActivityById(widget.activity.id!);
                setState(() {
                  isDeleted = true;
                });
                AuthenticateProviderPage.of(context)
                    .notifyToastSuccess('Deleted the post', context);
                Navigator.pop(context);
              } catch (e) {
                safePrint(e);
                AuthenticateProviderPage.of(context, listen: false)
                    .notifyToastDanger(message: "エラーです。もう一度お試しください。");
              }
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('キャンセル',
              style: TextStyle(
                  color: Color(0xff1997F6),
                  fontFamily: 'M_PLUS',
                  fontSize: 18,
                  fontWeight: FontWeight.normal)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void otherActions() {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];
    final userInfo = StreamFeed.User.fromJson(widget.activity.actor);
    Map<String, Object> externalData = {};

    for (var key in widget.activity.extraData!.keys) {
      if (widget.activity.extraData![key] != null) {
        externalData[key] = widget.activity.extraData![key]!;
      }
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('不適切な投稿として通報',
                style: TextStyle(
                    color: Color(0xffFF4848),
                    fontFamily: 'M_PLUS',
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
            onPressed: () async {
              try {
                await feedClient.reactions
                    .add('report', widget.activity.id!, userId: currentUser);
                AuthenticateProviderPage.of(context).notifyToastSuccess(
                    'Reported as inappropriate post', context);
                Navigator.pop(context);
              } catch (e) {
                safePrint(e);
                AuthenticateProviderPage.of(context, listen: false)
                    .notifyToastDanger(message: "エラーです。もう一度お試しください。");
              }
            },
          ),
          // if (widget.foreignId!.isNotEmpty)
          CupertinoActionSheetAction(
            child: const Text('📝投稿を保存する',
                style: TextStyle(
                    color: Color(0xff1997F6),
                    fontFamily: 'M_PLUS',
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
            onPressed: () async {
              try {
                String graphQLDocument =
                    '''mutation addToCollection(\$foreignId: String!, \$time: String!, \$userId: String!, \$targetId: String!) {
                    addToCollection(foreignId: \$foreignId, time: \$time, userId: \$userId, targetId: \$targetId)
                  }
                  ''';
                var operation = Amplify.API.mutate(
                    request: GraphQLRequest<String>(
                        document: graphQLDocument,
                        variables: {
                      'foreignId': widget.activity.foreignId,
                      'time': widget.activity.time.toString(),
                      'userId': widget.activity.id,
                      'targetId': currentUser
                    }));
                var response = await operation.response;
                var res = json.decode(response.data.toString());
                if (response.errors.isNotEmpty ||
                    res['addToCollection'] != 'success') {
                  throw Exception('Add to collection failed');
                } else {
                  AuthenticateProviderPage.of(context)
                      .notifyToastSuccess('Post collected', context);
                  Navigator.pop(context);
                }
              } catch (e) {
                safePrint(e);
                AuthenticateProviderPage.of(context, listen: false)
                    .notifyToastDanger(message: "エラーです。もう一度お試しください。");
              }
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('キャンセル',
              style: TextStyle(
                  color: Color(0xff1997F6),
                  fontFamily: 'M_PLUS',
                  fontSize: 18,
                  fontWeight: FontWeight.normal)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void toggleLikePost() async {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];

    try {
      if (likeReaction.isEmpty) {
        final reaction = await feedClient.reactions.add(
            'like', widget.activity.id!, userId: currentUser, targetFeeds: [
          StreamFeed.FeedId('notification_like', widget.activity.actor['id'])
        ]);

        setState(() {
          likeReaction = reaction.id!;
          likeCount++;
        });
      } else {
        await feedClient.reactions.delete(likeReaction);

        setState(() {
          likeReaction = '';
          likeCount--;
        });
      }
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
