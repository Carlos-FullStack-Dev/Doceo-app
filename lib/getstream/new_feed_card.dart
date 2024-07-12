import 'package:doceo_new/getstream/custom_image_attachment.dart';
import 'package:doceo_new/getstream/custom_message_actions.dart';
import 'package:doceo_new/helper/fcm_helper.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/helper/video_player.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_reply.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_reply.dart';
import 'package:doceo_new/pages/home/single_feed.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:doceo_new/getstream/custom_reaction_icon.dart';
import 'package:doceo_new/getstream/reply_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

class NewFeedCardScreen extends StatefulWidget {
  BuildContext context;
  MessageDetails details;
  List<Message> messages;
  StreamMessageWidget defaultMessageWidget;
  String? type;

  NewFeedCardScreen(
      {super.key,
      required this.context,
      required this.details,
      required this.messages,
      required this.defaultMessageWidget,
      this.type});
  @override
  _NewFeedCardScreen createState() => _NewFeedCardScreen();
}

class _NewFeedCardScreen extends State<NewFeedCardScreen> {
  bool isEdit = false;
  String feedType = 'diary';
  bool isLiked = true;
  bool isPinned = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.details.message;
    final channel = StreamChannel.of(widget.context).channel;
    final themeData = StreamChatTheme.of(widget.context).otherMessageTheme;
    final currentUser = StreamChat.of(context).currentUser;

    return ListTile(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => StreamChannel(
        //             channel: channel,
        //             child: SingleFeedScreen(
        //               parent: message,
        //             ))));
      },
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(13))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              widget.type == 'myPage'
                  ? Row(children: [
                      if (isPinned)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SvgPicture.asset(
                              'assets/images/pinned-icon.svg',
                              fit: BoxFit.cover,
                              height: 20,
                              width: 20),
                        ),
                      Expanded(
                          child: Text(UtilHelper.formatDate(message.createdAt),
                              style: AppStyles.feedDate)),
                      feedOption(currentUser!.id, message.user!.id)
                    ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        (message.user!.image != null)
                            ? CircleAvatar(
                                radius: 21,
                                backgroundImage:
                                    AssetImage(message.user!.image.toString()),
                                backgroundColor: Colors.transparent,
                              )
                            : const CircleAvatar(
                                radius: 21,
                                backgroundImage:
                                    AssetImage('assets/images/splash_1.png'),
                                backgroundColor: Colors.transparent,
                              ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                UtilHelper.getDisplayName(
                                    message.user!, channel.type),
                                textAlign: TextAlign.left,
                                style: AppStyles.feedUserName),
                            Text(
                                feedType != 'diary'
                                    ? UtilHelper.formatDate(message.createdAt)
                                    : feedType != 'diagnoseMemo'
                                        ? '${UtilHelper.formatDate(message.createdAt)} . 診察メモ'
                                        : '${UtilHelper.formatDate(message.createdAt)} . 治験日記',
                                style: AppStyles.feedDate),
                          ],
                        ),
                        feedOption(currentUser!.id, message.user!.id)
                      ],
                    ),
              Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: !message.isDeleted
                          ? [
                              (message.text != null && message.text!.isNotEmpty)
                                  ? Text(message.text!,
                                      textAlign: TextAlign.left,
                                      style: AppStyles.replyMessage)
                                  : const SizedBox(),
                              const SizedBox(height: 10),
                              (message.attachments.isNotEmpty
                                  ? (message.attachments[0].type == "image")
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: CustomImageAttachment(
                                            message: message,
                                            attachment: message.attachments[0],
                                            messageTheme: themeData,
                                            constraints: const BoxConstraints(
                                                maxHeight: 400),
                                          ))
                                      : (message.attachments[0].type == "video")
                                          ? StreamVideoAttachment(
                                              message: message,
                                              attachment:
                                                  message.attachments[0],
                                              messageTheme: themeData,
                                              constraints: const BoxConstraints(
                                                  maxHeight: 400),
                                            )
                                          : (message.attachments[0].type ==
                                                  "file")
                                              ? StreamFileAttachment(
                                                  message: message,
                                                  attachment:
                                                      message.attachments[0],
                                                  constraints:
                                                      const BoxConstraints
                                                          .expand(height: 50),
                                                )
                                              : Text(message
                                                  .attachments[0].title
                                                  .toString())
                                  : Container()),
                              IntrinsicWidth(
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 3, bottom: 3, right: 20, left: 10),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF2F2F2),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/room-icon1.png',
                                            fit: BoxFit.cover,
                                            width: 25,
                                            height: 25),
                                        const SizedBox(width: 10),
                                        Text('ROOM NAME',
                                            style: AppStyles.feedUserName),
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Text('#EXAMPLE HASH TAG',
                                        style: AppStyles.feedHashTag),
                                  ],
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(child: Container()),
                                    InkWell(
                                      child: SvgPicture.asset(
                                          'assets/images/comment.svg',
                                          fit: BoxFit.cover,
                                          height: 28,
                                          width: 28),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                        UtilHelper.convertNumberWithPrefix(
                                            message.replyCount),
                                        style: AppStyles.feedUserName),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isLiked = !isLiked;
                                        });
                                      },
                                      child: isLiked
                                          ? SvgPicture.asset(
                                              'assets/images/like_red.svg',
                                              fit: BoxFit.cover)
                                          : SvgPicture.asset(
                                              'assets/images/like.svg',
                                              fit: BoxFit.cover),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                        UtilHelper.convertNumberWithPrefix(
                                            29128),
                                        style: AppStyles.feedUserName)
                                  ])
                            ]
                          : [
                              const Text('The message was deleted',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal)),
                            ]))
            ])),
        // if (!message.isDeleted)
        //   Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         if (StreamChannel.of(context).channel.type == 'channel-2')
        //           Container(
        //               margin: const EdgeInsets.only(top: 10, bottom: 10),
        //               decoration: const BoxDecoration(
        //                   color: Color(0xffF8F8F8),
        //                   borderRadius: BorderRadius.all(Radius.circular(5))),
        //               padding: const EdgeInsets.symmetric(
        //                   vertical: 2, horizontal: 21),
        //               child: InkWell(
        //                   onTap: () {
        //                     final channel = StreamChannel.of(context).channel;
        //                     final currentUser =
        //                         StreamChat.of(context).currentUser;
        //                     RenderBox renderBox = (widget.key as GlobalKey)
        //                         .currentContext!
        //                         .findRenderObject() as RenderBox;
        //                     final offset = renderBox.localToGlobal(Offset.zero);
        //                     UtilHelper.showMessageReactionsModalBottomSheet(
        //                         context,
        //                         message,
        //                         [offset.dy, offset.dy + renderBox.size.height]);
        //                   },
        //                   child: SvgPicture.asset(
        //                     'assets/images/reaction-icon.svg',
        //                     fit: BoxFit.contain,
        //                     width: 24,
        //                     height: 24,
        //                   ))),
        //         UtilHelper.buildReactionsList(context, message)
        //       ]),
        // UtilHelper.buildReactionsList(context, message)
      ]),
      // subtitle: !message.isDeleted
      //     ? Container(
      //         child: (message.replyCount! > 0)
      //             ? Container(
      //                 margin: const EdgeInsets.only(top: 10),
      //                 padding: const EdgeInsets.only(
      //                     left: 5, right: 5, bottom: 10, top: 10),
      //                 decoration: const BoxDecoration(
      //                     color: Color(0xffF8F8F8),
      //                     borderRadius: BorderRadius.all(Radius.circular(5))),
      //                 child: CustomReplyMessage(
      //                     message: message, channel: channel),
      //               )
      //             : const SizedBox.shrink(),
      //       )
      //     : Container(),
      // onLongPress: () async {
      //   final channel = StreamChannel.of(widget.context).channel;
      //   if (channel.type == 'channel-2') {
      //     return;
      //   }
      //   final currentUser = StreamChat.of(context).currentUser;
      //   RenderBox renderBox = (widget.key as GlobalKey)
      //       .currentContext!
      //       .findRenderObject() as RenderBox;
      //   final offset = renderBox.localToGlobal(Offset.zero);

      //   showDialog(
      //     useRootNavigator: false,
      //     context: widget.context,
      //     barrierColor: const Color.fromRGBO(0, 0, 0, 0.33),
      //     builder: (context) => StreamChannel(
      //       channel: channel,
      //       child: CustomMessageActionsModal(
      //           onCopyTap: (message) =>
      //               Clipboard.setData(ClipboardData(text: message.text)),
      //           message: message,
      //           onEditTap: (message) {
      //             setState(() {
      //               isEdit = true;
      //             });
      //           },
      //           onEdited: (message) {
      //             setState(() {
      //               isEdit = false;
      //             });
      //           },
      //           onThreadReplyTap: (message) {
      //             // replyMsg(message);
      //           },
      //           showCopyMessage: message.text?.trim().isNotEmpty == true,
      //           showReplyMessage: false,
      //           showThreadReplyMessage: channel.type == 'channel-3' &&
      //               currentUser!.id != message.user!.id,
      //           showDeleteMessage:
      //               currentUser!.id == message.user!.id && !message.isDeleted,
      //           showEditMessage: currentUser.id == message.user!.id &&
      //               !message.attachments
      //                   .any((element) => element.type == 'giphy'),
      //           showWatchButton: true,
      //           pos: [offset.dy, offset.dy + renderBox.size.height]),
      //     ),
      //   );
      // },
    );
  }

  Widget feedOption(currentUserId, messageId) {
    return currentUserId == messageId
        ? Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  UtilHelper.showMyCupertinoModalBottomSheet(
                      context, '投稿を削除する', '📌プロフィールに固定する', () {}, () {});
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
        : Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  UtilHelper.showMyCupertinoModalBottomSheet(
                      context, '不適切な投稿として通報', '📝投稿を保存する', () {}, () {});
                },
                child: const Text('…',
                    style: TextStyle(
                        color: Color(0xffD9D9D9),
                        fontFamily: 'M_PLUS',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          );
  }
}
