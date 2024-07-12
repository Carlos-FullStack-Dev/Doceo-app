import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Models;

class ReasonDialog extends StatefulWidget {
  final List<Models.Questionnaire?> questions;
  const ReasonDialog({super.key, required this.questions});

  @override
  _ReasonDialogState createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<ReasonDialog> {
  int reasonIndex = -1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          child: Container(
            width: constraints.maxWidth,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 60,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: const EdgeInsets.only(
                        bottom: 20, top: 30, right: 20, left: 20),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          '下記より自分に当てはまるものを1つ以上お選びの上お進みください',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF4F5660),
                            fontSize: 17,
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                              itemCount: widget.questions.length,
                              itemBuilder: (context, index) {
                                final question = widget.questions[index]!;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      reasonIndex = index;
                                    });
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: ShapeDecoration(
                                        color: index == reasonIndex
                                            ? const Color(0xFF4F5660)
                                            : const Color(0xFFF2F2F2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      alignment: Alignment.center,
                                      child: Text(question.question,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: index == reasonIndex
                                                ? Colors.white
                                                : const Color(0xFF4F5660),
                                            fontSize: 15,
                                            fontFamily: 'M_PLUS',
                                            fontWeight: FontWeight.normal,
                                          ))),
                                );
                              }),
                        ),
                        const Text(
                          '*当てはまるものがない方はROOMヘのご参加をご遠慮ください。',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFB4BABF),
                            fontSize: 13,
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  joinRoom(context);
                                },
                                child: Container(
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF69E4BF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'ROOMに参加する',
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      'assets/images/room-icon1.png',
                      fit: BoxFit.contain,
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> joinRoom(context) async {
    final client = StreamChat.of(context).client;
    final currentUser = StreamChat.of(context).currentUser!;
    final roomID = AppProviderPage.of(context).selectedRoom;
    String userId = currentUser.id;

    setState(() {
      isLoading = true;
    });

    if (reasonIndex >= 0) {
      try {
        final currentUser = AuthenticateProviderPage.of(context).user['sub'];
        final newQuestion = Models.UserQuestionnaire(
            questionId: widget.questions[reasonIndex]!.id, userId: currentUser);
        final request = ModelMutations.create(newQuestion);
        await Amplify.API.mutate(request: request).response;
      } catch (e) {
        safePrint(e);
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "エラーです。もう一度お試しください。");
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    try {
      final channel = client.channel('room', id: roomID);
      await channel.watch();
      await channel.addMembers([userId]);

      List totalRooms = AppProviderPage.of(context, listen: false).rooms;
      int roomIndex =
          totalRooms.indexWhere((e) => e['channel']['id'] == roomID);

      final roomSigned = AppProviderPage.of(context, listen: false).roomSigned;
      roomSigned[roomIndex]['status'] = true;
      AppProviderPage.of(context, listen: false).roomSigned = roomSigned;
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
      setState(() {
        isLoading = false;
      });
    }
  }
}
