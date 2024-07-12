import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ExitRoomDialog extends StatefulWidget {
  const ExitRoomDialog({super.key});

  @override
  _ExitRoomDialogState createState() => _ExitRoomDialogState();
}

class _ExitRoomDialogState extends State<ExitRoomDialog> {
  bool isExiting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.24,
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
              'ROOMを退出すると、ROOMへの投稿やグループチャットができません。ROOMを退出しますか？',
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
                    if (!isExiting) {
                      leftRoom(AppProviderPage.of(context).selectedRoom);
                    }
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
                    child: isExiting
                        ? const CircularProgressIndicator(
                            color: Color(0xFF4F5660),
                          )
                        : const Text(
                            '退出する',
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
  }

  void leftRoom(String roomId) async {
    setState(() {
      isExiting = true;
    });
    final client = StreamChat.of(context).client;
    final userId = StreamChat.of(context).currentUser!.id;
    final channel = client.channel('room', id: roomId);
    final feedClient = context.feedClient;
    final relatedFeed = feedClient.flatFeed('related', userId);
    final roomFeed = feedClient.flatFeed('room', roomId);

    try {
      await channel.watch();
      await channel.removeMembers([userId]);
      await relatedFeed.unfollow(roomFeed);

      // Left from subchannels
      final subChannels = await client
          .queryChannels(filter: Filter.equal('room', roomId))
          .first;
      for (int i = 0; i < subChannels.length; i++) {
        await subChannels[i].removeMembers([userId]);
      }

      List totalRooms = AppProviderPage.of(context, listen: false).rooms;
      int roomIndex =
          totalRooms.indexWhere((e) => e['channel']['id'] == roomId);
      final roomSigned = AppProviderPage.of(context, listen: false).roomSigned;
      roomSigned[roomIndex]['status'] = false;
      AppProviderPage.of(context, listen: false).roomSigned = roomSigned;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        isExiting = false;
      });
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
