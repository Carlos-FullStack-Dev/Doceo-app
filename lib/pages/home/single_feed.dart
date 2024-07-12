import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/getstream/fullscreen_image_viewer.dart';
import 'package:doceo_new/helper/feedVideo.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/channels/users/doctor_page.dart';
import 'package:doceo_new/pages/channels/users/user_page.dart';
import 'package:doceo_new/pages/home/single_comment.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleFeedScreen extends StatefulWidget {
  StreamFeed.GenericEnrichedActivity activity;
  StreamFeed.User userInfo;
  Map externalData;
  Map? room;
  bool userFlag;
  String verbType;
  String? likeReaction;
  String? foreignId;
  DateTime? time;
  Map reactionNum;
  Tag? usertag;

  String id;
  SingleFeedScreen(
      {super.key,
      required this.activity,
      required this.userInfo,
      required this.externalData,
      required this.userFlag,
      required this.verbType,
      required this.reactionNum,
      required this.id,
      this.usertag,
      this.foreignId,
      this.time,
      this.likeReaction,
      this.room});
  @override
  State<SingleFeedScreen> createState() => _SingleFeedScreen();
}

class _SingleFeedScreen extends State<SingleFeedScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  String likeReaction = '';
  int likeCount = 0;
  TextEditingController commentPart = TextEditingController();
  final PagingController<int, StreamFeed.Reaction> _pagingController =
      PagingController(firstPageKey: 0);
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchComments(pageKey);
    });
    setState(() {
      likeReaction = widget.likeReaction ?? '';
      likeCount = widget.reactionNum['like'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final userInfo = widget.userInfo;
    final externalData = widget.externalData;
    final usertag = widget.usertag;
    final id = widget.id;
    final room = widget.room;
    bool userFlag = widget.userFlag;
    String verbType = widget.verbType;
    Map reactionNum = widget.reactionNum;

    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text('投稿',
                  style: TextStyle(
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              leading: IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              actions: [
                Container(
                    margin: const EdgeInsets.only(right: 15),
                    alignment: Alignment.center,
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
                    ))
              ],
            ),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                    child: Stack(
                  children: [
                    SingleChildScrollView(
                        child: Column(
                      children: [
                        ListTile(
                          onTap: () {},
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (!userFlag) {
                                                    if (userInfo
                                                            .data!['role'] !=
                                                        'doctor') {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UserPage(
                                                                      userId: userInfo
                                                                          .id!)));
                                                    } else {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DoctorPage(
                                                                      doctorId:
                                                                          userInfo
                                                                              .id!)));
                                                    }
                                                  }
                                                },
                                                child: UtilHelper.feedAvatar(
                                                    userInfo.data!['avatar']
                                                        as String?,
                                                    21),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      userInfo.data!['role'] ==
                                                              'doctor'
                                                          ? '${userInfo.data!['lastName']}医師'
                                                          : userInfo
                                                              .data!['name']
                                                              .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: AppStyles
                                                          .feedUserName),
                                                  if (widget.time != null)
                                                    Text(
                                                        UtilHelper.formatDate(
                                                            widget.time!),
                                                        style:
                                                            AppStyles.feedDate),
                                                ],
                                              )),
                                              if (!userFlag)
                                                FutureBuilder(
                                                    future: _isFollowing(
                                                        userInfo.id),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Container();
                                                      }

                                                      return Container(
                                                        width: 99,
                                                        height: 39,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: snapshot.data!
                                                              ? const Color(
                                                                  0xFFF2F2F2)
                                                              : const Color(
                                                                  0xFF69E4BF),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              width: 0.50,
                                                              color: snapshot
                                                                      .data!
                                                                  ? const Color(
                                                                      0xFFF2F2F2)
                                                                  : const Color(
                                                                      0xFF69E4BF),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        19.50),
                                                          ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: InkWell(
                                                            onTap: () {
                                                              followUser(
                                                                  userInfo.id);
                                                            },
                                                            child: isLoading ==
                                                                    true
                                                                ? const CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                    strokeWidth:
                                                                        1)
                                                                : Text(
                                                                    snapshot.data!
                                                                        ? 'フォロー中'
                                                                        : 'フォロー',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: snapshot
                                                                              .data!
                                                                          ? const Color(
                                                                              0xFFB4BABF)
                                                                          : Colors
                                                                              .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'M_PLUS',
                                                                      fontWeight: snapshot.data!
                                                                          ? FontWeight
                                                                              .normal
                                                                          : FontWeight
                                                                              .bold,
                                                                    ),
                                                                  )),
                                                      );
                                                    }),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (verbType == 'diary')
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 9),
                                                          child: Row(children: [
                                                            SvgPicture.asset(
                                                                'assets/images/check-icon.svg'),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                                '${UtilHelper.getReasonText(externalData['reason'].toString())}${usertag != null ? ' / ${usertag.name}' : ''}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: AppStyles
                                                                    .replyMessage)
                                                          ])),
                                                    (externalData[
                                                                    'message'] !=
                                                                null &&
                                                            externalData[
                                                                    'message']
                                                                .isNotEmpty)
                                                        ? Linkify(
                                                            onOpen:
                                                                (link) async {
                                                              if (!await launchUrl(
                                                                  Uri.parse(
                                                                      link.url),
                                                                  mode: LaunchMode
                                                                      .inAppWebView)) {
                                                                throw Exception(
                                                                    'Could not launch ${link.url}');
                                                              }
                                                            },
                                                            text: externalData[
                                                                    'message']
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyles
                                                                .replyMessage,
                                                            linkStyle: AppStyles
                                                                .replyMessage
                                                                .copyWith(
                                                                    color: const Color(
                                                                        0xff1997F6)))
                                                        : const SizedBox(),
                                                    if (room != null ||
                                                        externalData[
                                                                'hospital'] !=
                                                            null ||
                                                        externalData[
                                                                'doctorName'] !=
                                                            null)
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15),
                                                          child: Wrap(
                                                              runSpacing: 10,
                                                              spacing: 10,
                                                              children: [
                                                                if (externalData[
                                                                        'hospital'] !=
                                                                    null)
                                                                  IntrinsicWidth(
                                                                    child: Container(
                                                                        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                                                                        decoration: BoxDecoration(color: const Color(0xffF2F2F2), borderRadius: BorderRadius.circular(16)),
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset('assets/images/hospital-gray.svg',
                                                                                fit: BoxFit.cover),
                                                                            const SizedBox(width: 10),
                                                                            Text(externalData['hospital'].toString(),
                                                                                style: AppStyles.feedUserName),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                if (externalData[
                                                                        'doctorName'] !=
                                                                    null)
                                                                  IntrinsicWidth(
                                                                    child: Container(
                                                                        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                                                                        decoration: BoxDecoration(color: const Color(0xffF2F2F2), borderRadius: BorderRadius.circular(16)),
                                                                        child: Row(
                                                                          children: [
                                                                            externalData['doctorIcon'] != null
                                                                                ? CircleAvatar(
                                                                                    radius: 9.5,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    backgroundImage: NetworkImage(externalData['doctorIcon'].toString()),
                                                                                  )
                                                                                : SvgPicture.asset('assets/images/select-doctor.svg', fit: BoxFit.cover),
                                                                            const SizedBox(width: 10),
                                                                            Text(externalData['doctorName'].toString(),
                                                                                style: AppStyles.feedUserName),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                if (room !=
                                                                    null)
                                                                  IntrinsicWidth(
                                                                    child: Container(
                                                                        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                                                                        decoration: BoxDecoration(color: const Color(0xffF2F2F2), borderRadius: BorderRadius.circular(16)),
                                                                        child: Row(
                                                                          children: [
                                                                            (room['channel']['image'] != null)
                                                                                ? Image.network(room['channel']['image'], fit: BoxFit.cover, width: 23, height: 23)
                                                                                : Image.asset('assets/images/room-icon1.png', fit: BoxFit.cover, width: 25, height: 25),
                                                                            const SizedBox(width: 10),
                                                                            Text(room['channel']['name'],
                                                                                style: AppStyles.feedUserName),
                                                                          ],
                                                                        )),
                                                                  )
                                                              ])),
                                                    (externalData['filePath']
                                                            .isNotEmpty
                                                        ? const SizedBox(
                                                            height: 20)
                                                        : Container()),
                                                    (externalData['filePath']
                                                            .isNotEmpty
                                                        ? (externalData[
                                                                    'fileType'] ==
                                                                "image")
                                                            ? InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              FullScreenImageViewer(externalData['filePath'].toString())));
                                                                },
                                                                child: Image
                                                                    .network(
                                                                  externalData[
                                                                      'filePath'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ))
                                                            : (externalData[
                                                                        'fileType'] ==
                                                                    "video")
                                                                ? FeedVideoPlayer(
                                                                    videoPlayerController: VideoPlayerController.network(
                                                                        externalData[
                                                                            'filePath'],
                                                                        videoPlayerOptions:
                                                                            VideoPlayerOptions()),
                                                                    looping:
                                                                        false,
                                                                    autoplay:
                                                                        false,
                                                                  )
                                                                : (externalData[
                                                                            'fileType'] ==
                                                                        "file")
                                                                    ? const Text(
                                                                        'File',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 18),
                                                                      )
                                                                    : const Text(
                                                                        '')
                                                        : Container()),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          if (reactionNum[
                                                                      'alert'] !=
                                                                  null &&
                                                              reactionNum[
                                                                      'alert'] >
                                                                  0)
                                                            SvgPicture.asset(
                                                                'assets/images/warning.svg',
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 25,
                                                                height: 29),
                                                          if (reactionNum[
                                                                      'warn'] !=
                                                                  null &&
                                                              reactionNum[
                                                                      'warn'] >
                                                                  0)
                                                            SvgPicture.asset(
                                                                'assets/images/warning.svg',
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 30,
                                                                height: 28),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          SvgPicture.asset(
                                                              'assets/images/comment.svg',
                                                              fit: BoxFit.cover,
                                                              height: 28,
                                                              width: 28),
                                                          const SizedBox(
                                                              width: 15),
                                                          (reactionNum[
                                                                      'comment'] !=
                                                                  null)
                                                              ? Text(
                                                                  UtilHelper.convertNumberWithPrefix(
                                                                      reactionNum[
                                                                          'comment']),
                                                                  style: AppStyles
                                                                      .feedUserName)
                                                              : Text('0',
                                                                  style: AppStyles
                                                                      .feedUserName),
                                                          const SizedBox(
                                                              width: 25),
                                                          InkWell(
                                                            onTap: () {
                                                              toggleLikePost();
                                                            },
                                                            child: likeReaction
                                                                    .isNotEmpty
                                                                ? SvgPicture.asset(
                                                                    'assets/images/like_red.svg',
                                                                    fit: BoxFit
                                                                        .cover)
                                                                : SvgPicture.asset(
                                                                    'assets/images/like.svg',
                                                                    fit: BoxFit
                                                                        .cover),
                                                          ),
                                                          const SizedBox(
                                                              width: 15),
                                                          Text(
                                                              UtilHelper
                                                                  .convertNumberWithPrefix(
                                                                      likeCount),
                                                              style: AppStyles
                                                                  .feedUserName)
                                                        ])
                                                  ]))
                                        ])),
                              ]),
                        ),
                        Container(
                          height: 10,
                          decoration:
                              const BoxDecoration(color: Color(0xFFF2F2F2)),
                        ),
                        Container(
                          width: width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xFF4F5660), width: 0.2))),
                          child: const Text(
                            'コメント',
                            style: TextStyle(
                                color: Color(0xff4f5660),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        // Expanded(
                        //     child:
                        PagedListView<int, StreamFeed.Reaction>(
                          pagingController: _pagingController,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          builderDelegate:
                              PagedChildBuilderDelegate<StreamFeed.Reaction>(
                                  itemBuilder: (context, item, index) {
                                    final userId = AuthenticateProviderPage.of(
                                            context,
                                            listen: false)
                                        .user['sub'];
                                    final userFlag = item.userId == userId;
                                    final userInfo = item.user!;
                                    final reactionNum =
                                        item.childrenCounts ?? {};
                                    final likeReactions = item.ownChildren !=
                                                null &&
                                            item.ownChildren!['like'] != null
                                        ? item.ownChildren!['like']!
                                        : [];
                                    final comments = item.ownChildren != null &&
                                            item.ownChildren!['comment'] != null
                                        ? item.ownChildren!['comment']!
                                        : [];
                                    String likeReaction = '';

                                    try {
                                      likeReaction = likeReactions
                                          .firstWhere((reaction) =>
                                              reaction.userId == userId)
                                          .id;
                                    } catch (_) {}

                                    return Container(
                                        margin: const EdgeInsets.only(
                                            left: 35, top: 20, right: 25),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0xff4f5660),
                                                    width: 0.1))),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SingleCommentScreen(
                                                          reaction: item,
                                                          likeReaction:
                                                              likeReaction,
                                                        )));
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  if (!userFlag) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                UserPage(userId: userInfo.id!)));
                                                                  }
                                                                },
                                                                child: UtilHelper.feedAvatar(
                                                                    userInfo.data![
                                                                            'avatar']
                                                                        as String?,
                                                                    21),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                  child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      userInfo
                                                                          .data![
                                                                              'name']
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyles
                                                                          .feedUserName),
                                                                  Text(
                                                                      UtilHelper
                                                                          .formatDate(item
                                                                              .createdAt!),
                                                                      style: AppStyles
                                                                          .feedDate),
                                                                ],
                                                              )),
                                                              if (userFlag)
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        ownCommentActions(
                                                                            item.id);
                                                                      },
                                                                      child: const Text(
                                                                          '…',
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
                                                          const SizedBox(
                                                              height: 12),
                                                          Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 52),
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    (item.data!['text'] !=
                                                                            null)
                                                                        ? Text(
                                                                            item.data!['text']
                                                                                .toString(),
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: AppStyles.replyMessage)
                                                                        : const SizedBox(),
                                                                    if (comments
                                                                        .isNotEmpty)
                                                                      Container(
                                                                          margin: const EdgeInsets.only(
                                                                              top:
                                                                                  12),
                                                                          padding: const EdgeInsets.symmetric(
                                                                              vertical:
                                                                                  8,
                                                                              horizontal:
                                                                                  15),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: const Color(0xFFF2F2F2)),
                                                                          child: RichText(
                                                                            text:
                                                                                TextSpan(children: [
                                                                              TextSpan(text: comments[0].user.data['name'], style: const TextStyle(color: Color(0xFF1997F6), fontFamily: 'M_PLUS', fontSize: 15, fontWeight: FontWeight.w500)),
                                                                              TextSpan(text: ' : ${comments[0].data!['text']}', style: const TextStyle(color: Color(0xFFB4BABF), fontFamily: 'M_PLUS', fontSize: 15, fontWeight: FontWeight.w500))
                                                                            ]),
                                                                          )),
                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Expanded(
                                                                              child: Container()),
                                                                          SvgPicture.asset(
                                                                              'assets/images/comment.svg',
                                                                              fit: BoxFit.cover,
                                                                              height: 28,
                                                                              width: 28),
                                                                          const SizedBox(
                                                                              width: 15),
                                                                          (reactionNum['comment'] != null)
                                                                              ? Text(UtilHelper.convertNumberWithPrefix(reactionNum['comment']), style: AppStyles.feedUserName)
                                                                              : Text('0', style: AppStyles.feedUserName),
                                                                          const SizedBox(
                                                                              width: 25),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              if (likeReaction.isNotEmpty) {
                                                                                removeLikeComment(likeReaction);
                                                                              } else {
                                                                                likeComment(item.id, item.userId);
                                                                              }
                                                                            },
                                                                            child: likeReaction.isNotEmpty
                                                                                ? SvgPicture.asset('assets/images/like_red.svg', fit: BoxFit.cover)
                                                                                : SvgPicture.asset('assets/images/like.svg', fit: BoxFit.cover),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 15),
                                                                          (reactionNum['like'] != null)
                                                                              ? Text(UtilHelper.convertNumberWithPrefix(reactionNum['like']), style: AppStyles.feedUserName)
                                                                              : Text('0', style: AppStyles.feedUserName)
                                                                        ])
                                                                  ]))
                                                        ])),
                                              ]),
                                        ));
                                  },
                                  newPageErrorIndicatorBuilder: (_) =>
                                      Container(),
                                  firstPageErrorIndicatorBuilder: (_) =>
                                      Container(),
                                  noItemsFoundIndicatorBuilder: (_) =>
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 60),
                                          padding: const EdgeInsets.only(
                                              left: 65, right: 65),
                                          child: const Text('まだコメントがありません',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xffb4babf),
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.w500)))),
                        ),
                        // ),
                        const SizedBox(
                          height: 80,
                        )
                      ],
                    )),
                    SizedBox(
                      height: height,
                      child: Container(),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: width,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(
                                      color: Color(0xFF4F5660), width: 0.1))),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Expanded(flex: 1, child: Text('')
                                  // Set the shape of the button to a circle
                                  ),
                              Expanded(
                                flex: 9,
                                child: TextFormField(
                                  onChanged: (text) {
                                    setState(() {
                                      isEditing = text.isNotEmpty;
                                    });
                                  },
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      filled: true,
                                      fillColor: Colors.white,
                                      // suffixIcon: Icon(Icons.email, color: Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: '',
                                      hintStyle: TextStyle(
                                          fontFamily: 'M_PLUS',
                                          fontSize: 15,
                                          color: Colors.grey)),
                                  controller: commentPart,
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: !isEditing
                                          ? Colors.grey
                                          : Colors
                                              .blue, // Set the background color of the button
                                    ),
                                    child: IconButton(
                                      icon: Icon(!isEditing
                                          ? Icons.arrow_forward_ios_rounded
                                          : Icons.arrow_upward_outlined),
                                      onPressed: () {
                                        // Handle button press
                                        postComment(id);
                                      },
                                      iconSize: 15, // Set the size of the icon
                                      color: Colors
                                          .white, // Set the color of the icon
                                    ),
                                  ))
                            ],
                          ),
                        )),
                  ],
                )))
            // )
            ),
        onWillPop: () => Future.value(false));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<bool> _isFollowing(userId) async {
    try {
      final feedClient = context.feedClient;
      final currentUser = AuthenticateProviderPage.of(context).user['sub'];
      final timeline = feedClient.flatFeed('timeline', currentUser);

      final res = await timeline
          .following(filter: [StreamFeed.FeedId.id('user:$userId')]);
      return res.isNotEmpty;
    } catch (e) {
      safePrint(e);
      return false;
    }
  }

  Future<void> _fetchComments(int pageKey) async {
    try {
      final feedClient = context.feedClient;
      final lastId = _pagingController.itemList?.last.id;
      final newItems = await feedClient.reactions.filter(
          StreamFeed.LookupAttribute.activityId, widget.id,
          kind: 'comment',
          limit: 5,
          flags: StreamFeed.EnrichmentFlags().withOwnChildren(),
          filter:
              lastId != null ? StreamFeed.Filter().idLessThan(lastId) : null);

      if (newItems.length < 5) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      safePrint(error);
      _pagingController.error = error;
    }
  }

  void followUser(userId) async {
    setState(() {
      isLoading = true;
    });
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];
    final timeline = feedClient.flatFeed('timeline', currentUser);
    final notificationFeed =
        feedClient.notificationFeed('notification_follow', userId);

    try {
      await timeline.follow(feedClient.flatFeed('user', userId));
      final activity = StreamFeed.Activity(
          actor: feedClient.user(currentUser).ref,
          object: '${currentUser}follows$userId',
          verb: 'follow');
      await notificationFeed.addActivity(activity);
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
    setState(() {
      isLoading = false;
    });
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
                await feed.removeActivityById(widget.id);
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

  void ownCommentActions(reactionId) {
    final feedClient = context.feedClient;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('コメントを削除する',
                style: TextStyle(
                    color: Color(0xffFF4848),
                    fontFamily: 'M_PLUS',
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
            onPressed: () async {
              try {
                await feedClient.reactions.delete(reactionId);
                AuthenticateProviderPage.of(context)
                    .notifyToastSuccess('Deleted the comment', context);
                Navigator.pop(context);
                _pagingController.refresh();
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
                    .add('report', widget.id, userId: currentUser);
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
            'like', widget.id, userId: currentUser, targetFeeds: [
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

  void likeComment(commentId, userId) async {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];

    try {
      await feedClient.reactions.addChild('like', commentId,
          userId: currentUser,
          targetFeeds: [StreamFeed.FeedId('notification_like', userId)]);
      _pagingController.refresh();
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void removeLikeComment(reactionId) async {
    final feedClient = context.feedClient;

    try {
      await feedClient.reactions.delete(reactionId);
      _pagingController.refresh();
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void postComment(String id) async {
    final feedClient = context.feedClient;
    final currentUser =
        AuthenticateProviderPage.of(context, listen: false).user['sub'];
    try {
      await feedClient.reactions.add('comment', id,
          data: {'text': commentPart.text},
          userId: currentUser,
          targetFeeds: [
            StreamFeed.FeedId(
                'notification_comment', widget.activity.actor['id'])
          ]);
      commentPart.clear();
      _pagingController.refresh();
      FocusScope.of(context).unfocus();
      setState(() {
        isEditing = false;
      });
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
