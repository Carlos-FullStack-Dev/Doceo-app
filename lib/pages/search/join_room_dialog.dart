import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/pages/search/reason_dialog.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Models;

class JoinRoomDialog extends StatefulWidget {
  @override
  _JoinRoomDialogState createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  bool isJoining = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.27,
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
              'ROOMの参加メンバーのみが\nROOMへの投稿やグループチャットを利用することができます。\nROOMに参加しますか？',
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
                    Navigator.of(context).pop();
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
                      'キャンセル',
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
                    if (!isJoining) {
                      _checkQuestionaires();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 45,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF69E4BF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.50),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isJoining
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            '参加',
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
  }

  _checkQuestionaires() async {
    setState(() {
      isJoining = true;
    });
    final selectedRoom = AppProviderPage.of(context).selectedRoom;
    final request = ModelQueries.list(Models.Questionnaire.classType,
        where: Models.Questionnaire.ROOMID.eq(selectedRoom));
    try {
      final response = await Amplify.API.query(request: request).response;
      final questions = response.data?.items;

      if (questions!.isEmpty) {
        joinRoom();
      } else {
        setState(() {
          isJoining = false;
        });
        Navigator.of(context).pop();
        _showSendReasonDialog(context, questions);
      }
    } catch (e) {
      safePrint(e);
      joinRoom();
    }
  }

  Future<void> joinRoom() async {
    final client = StreamChat.of(context).client;
    final feedClient = context.feedClient;
    final currentUser = StreamChat.of(context).currentUser!;
    final roomID = AppProviderPage.of(context).selectedRoom;
    String userId = currentUser.id;

    try {
      final channel = client.channel('room', id: roomID);
      await channel.watch();
      await channel.addMembers([userId]);

      final relatedFeed = feedClient.flatFeed('related', userId);
      final roomFeed = feedClient.flatFeed('room', roomID);
      await relatedFeed.follow(roomFeed);

      // Join to subchannels
      // final subChannels = await client
      //     .queryChannels(filter: Filter.equal('room', roomID))
      //     .first;
      // for (int i = 0; i < subChannels.length; i++) {
      //   await subChannels[i].addMembers([userId]);
      //   if (((subChannels[i].type == 'channel-2' ||
      //               subChannels[i].type == 'channel-3') &&
      //           currentUser.extraData['disable_other_notification']
      //                   .toString() ==
      //               'yes') ||
      //       (subChannels[i].type == 'channel-1' &&
      //           currentUser.extraData['disable_room_notification'].toString() ==
      //               'yes')) {
      //     await subChannels[i].mute();
      //   }
      // }

      List totalRooms = AppProviderPage.of(context, listen: false).rooms;
      int roomIndex =
          totalRooms.indexWhere((e) => e['channel']['id'] == roomID);

      final roomSigned = AppProviderPage.of(context, listen: false).roomSigned;
      roomSigned[roomIndex]['status'] = true;
      AppProviderPage.of(context, listen: false).roomSigned = roomSigned;
      Navigator.of(context).pop();
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
      setState(() {
        isJoining = false;
      });
    }
  }

  _showSendReasonDialog(BuildContext context, questions) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ReasonDialog(
        questions: questions,
      ),
    );
  }
}
