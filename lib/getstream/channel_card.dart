import 'dart:math';
import 'dart:ui';
import 'dart:core';
import 'package:doceo_new/components/show_channel_icon.dart';
import 'package:doceo_new/getstream/custom_reaction_picker.dart';
import 'package:doceo_new/pages/search/room_entrance_page.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelCard extends StatefulWidget {
  final BuildContext context;
  final List<Channel> channels;
  int index;
  StreamChannelListTile defaultWidget;

  ChannelCard({
    super.key,
    required this.context,
    required this.channels,
    required this.index,
    required this.defaultWidget,
  });

  @override
  _ChannelCardState createState() => _ChannelCardState();
}

class _ChannelCardState extends State<ChannelCard> {
  @override
  Widget build(BuildContext context) {
    final context = widget.context;
    final channels = widget.channels;
    final index = widget.index;
    final defaultWidget = widget.defaultWidget;
    final client = StreamChat.of(context).client;
    String title = channels[index].name!;
    String? cid = channels[index].cid;
    bool hasCoin = true;

    return BetterStreamBuilder<int>(
        stream: client.state.channels[cid]?.state?.unreadCountStream,
        initialData: client.state.channels[cid]?.state?.unreadCount,
        builder: (context, data) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InkWell(
                onTap: () {
                  // goChannelDetail(channels[index]);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      ShowChannelIcon(channelType: channels[index].type),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 1),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      '# SubTitle',
                                      style: TextStyle(
                                          color: Color(0xff4F5660),
                                          fontFamily: 'M_PLUS',
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  if (hasCoin)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 1),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFF2F2F2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'D-COIN',
                                        style: TextStyle(
                                            color: Color(0xFFFCC14C),
                                            fontFamily: 'M_PLUS',
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'ChattextChattextChat...',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFFB4BABF),
                                  fontSize: 15,
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RoomEntrancePage(
                                      channel: channels[index])));
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE7FFF8),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.50, color: Color(0xFF69E4BF)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              '入る',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF69E4BF),
                                fontSize: 15,
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
