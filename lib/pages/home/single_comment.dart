import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/pages/channels/users/user_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;

class SingleCommentScreen extends StatefulWidget {
  StreamFeed.Reaction reaction;
  String likeReaction;
  SingleCommentScreen(
      {super.key, required this.reaction, required this.likeReaction});
  @override
  State<SingleCommentScreen> createState() => _SingleCommentScreen();
}

class _SingleCommentScreen extends State<SingleCommentScreen>
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
      likeReaction = widget.likeReaction;
      likeCount = widget.reaction.childrenCounts!['like'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = AuthenticateProviderPage.of(context).user['sub'];
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userInfo = widget.reaction.user!;
    bool userFlag = widget.reaction.userId == userId;
    Map reactionNum = widget.reaction.childrenCounts!;

    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text('コメント',
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
                if (userFlag)
                  Container(
                      margin: const EdgeInsets.only(right: 15),
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          ownCommentActions(widget.reaction.id!);
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
                  child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          SizedBox(
                            width: width,
                            height: height,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {},
                                  title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (!userFlag) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        UserPage(
                                                                            userId:
                                                                                userInfo.id!)));
                                                          }
                                                        },
                                                        child: UtilHelper
                                                            .feedAvatar(
                                                                userInfo.data![
                                                                        'avatar']
                                                                    as String?,
                                                                21),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                          child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              userInfo
                                                                  .data!['name']
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyles
                                                                  .feedUserName),
                                                          Text(
                                                              UtilHelper.formatDate(
                                                                  widget
                                                                      .reaction
                                                                      .createdAt!),
                                                              style: AppStyles
                                                                  .feedDate),
                                                        ],
                                                      )),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                widget
                                                                    .reaction
                                                                    .data![
                                                                        'text']
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: AppStyles
                                                                    .replyMessage),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        '元の投稿を見る〉',
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xFF1997F6),
                                                                            fontFamily:
                                                                                'M_PLUS',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500)),
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          Container()),
                                                                  SvgPicture.asset(
                                                                      'assets/images/comment.svg',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          28,
                                                                      width:
                                                                          28),
                                                                  const SizedBox(
                                                                      width:
                                                                          15),
                                                                  (reactionNum[
                                                                              'comment'] !=
                                                                          null)
                                                                      ? Text(
                                                                          UtilHelper.convertNumberWithPrefix(reactionNum[
                                                                              'comment']),
                                                                          style: AppStyles
                                                                              .feedUserName)
                                                                      : Text(
                                                                          '0',
                                                                          style:
                                                                              AppStyles.feedUserName),
                                                                  const SizedBox(
                                                                      width:
                                                                          25),
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
                                                                            fit:
                                                                                BoxFit.cover),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          15),
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
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFF2F2F2)),
                                ),
                                Container(
                                  width: width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xFF4F5660),
                                              width: 0.2))),
                                  child: const Text(
                                    'コメント',
                                    style: TextStyle(
                                        color: Color(0xff4f5660),
                                        fontFamily: 'M_PLUS',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                    child:
                                        PagedListView<int, StreamFeed.Reaction>(
                                  pagingController: _pagingController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  builderDelegate:
                                      PagedChildBuilderDelegate<
                                              StreamFeed.Reaction>(
                                          itemBuilder: (context, item, index) {
                                            final userFlag =
                                                item.userId == userId;
                                            final userInfo = item.user!;
                                            final reactionNum =
                                                item.childrenCounts ?? {};
                                            final likeReactions = item
                                                            .ownChildren !=
                                                        null &&
                                                    item.ownChildren!['like'] !=
                                                        null
                                                ? item.ownChildren!['like']!
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
                                                    left: 35,
                                                    top: 20,
                                                    right: 25),
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xff4f5660),
                                                            width: 0.1))),
                                                child: ListTile(
                                                  onTap: () {},
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
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
                                                                        onTap:
                                                                            () {
                                                                          if (!userFlag) {
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (context) => UserPage(userId: userInfo.id!)));
                                                                          }
                                                                        },
                                                                        child: UtilHelper.feedAvatar(
                                                                            userInfo.data!['avatar']
                                                                                as String?,
                                                                            21),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              10),
                                                                      Expanded(
                                                                          child:
                                                                              Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              userInfo.data!['name'].toString(),
                                                                              textAlign: TextAlign.left,
                                                                              style: AppStyles.feedUserName),
                                                                          Text(
                                                                              UtilHelper.formatDate(item.createdAt!),
                                                                              style: AppStyles.feedDate),
                                                                        ],
                                                                      )),
                                                                      if (userFlag)
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                ownCommentActions(item.id);
                                                                              },
                                                                              child: const Text('…', style: TextStyle(color: Color(0xffD9D9D9), fontFamily: 'M_PLUS', fontSize: 20, fontWeight: FontWeight.bold)),
                                                                            ),
                                                                          ),
                                                                        )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          12),
                                                                  Container(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              52),
                                                                      child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            (item.data!['text'] != null)
                                                                                ? Text(item.data!['text'].toString(), textAlign: TextAlign.left, style: AppStyles.replyMessage)
                                                                                : const SizedBox(),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                                              Expanded(child: Container()),
                                                                              SvgPicture.asset('assets/images/comment.svg', fit: BoxFit.cover, height: 28, width: 28),
                                                                              const SizedBox(width: 15),
                                                                              (reactionNum['comment'] != null) ? Text(UtilHelper.convertNumberWithPrefix(reactionNum['comment']), style: AppStyles.feedUserName) : Text('0', style: AppStyles.feedUserName),
                                                                              const SizedBox(width: 25),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  if (likeReaction.isNotEmpty) {
                                                                                    removeLikeComment(likeReaction);
                                                                                  } else {
                                                                                    likeComment(item.id, item.userId);
                                                                                  }
                                                                                },
                                                                                child: likeReaction.isNotEmpty ? SvgPicture.asset('assets/images/like_red.svg', fit: BoxFit.cover) : SvgPicture.asset('assets/images/like.svg', fit: BoxFit.cover),
                                                                              ),
                                                                              const SizedBox(width: 15),
                                                                              (reactionNum['like'] != null) ? Text(UtilHelper.convertNumberWithPrefix(reactionNum['like']), style: AppStyles.feedUserName) : Text('0', style: AppStyles.feedUserName)
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
                                                  margin: const EdgeInsets.only(
                                                      top: 60),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 65, right: 65),
                                                  child: const Text(
                                                      'まだコメントがありません',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffb4babf),
                                                          fontFamily: 'M_PLUS',
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .w500)))),
                                )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
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
                                  postComment(widget.reaction.id!);
                                },
                                iconSize: 15, // Set the size of the icon
                                color:
                                    Colors.white, // Set the color of the icon
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              )),
            )),
        onWillPop: () => Future.value(false));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchComments(int pageKey) async {
    try {
      final feedClient = context.feedClient;
      final lastId = _pagingController.itemList?.last.id;
      final newItems = await feedClient.reactions.filter(
          StreamFeed.LookupAttribute.reactionId, widget.reaction.id!,
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

  void toggleLikePost() async {
    final feedClient = context.feedClient;
    final currentUser = AuthenticateProviderPage.of(context).user['sub'];

    try {
      if (likeReaction.isEmpty) {
        final reaction = await feedClient.reactions.add(
            'like', widget.reaction.id!, userId: currentUser, targetFeeds: [
          StreamFeed.FeedId('notification_like', widget.reaction.userId!)
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
    setState(() {
      isLoading = true;
    });
    final feedClient = context.feedClient;
    final currentUser =
        AuthenticateProviderPage.of(context, listen: false).user['sub'];
    try {
      await feedClient.reactions.addChild('comment', id,
          data: {'text': commentPart.text},
          userId: currentUser,
          targetFeeds: [
            StreamFeed.FeedId('notification_comment', widget.reaction.userId!)
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
    setState(() {
      isLoading = true;
    });
  }
}
