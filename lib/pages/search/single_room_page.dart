// ignore_for_file: avoid_print

import 'package:doceo_new/components/show_channel_icon.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/getstream/custom_flat_feed.dart';
import 'package:doceo_new/pages/channels/type_1/channel_1_1_page.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_page.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_page.dart';
import 'package:doceo_new/pages/home/add_feed_dialog.dart';
import 'package:doceo_new/pages/search/charge_alert_dialog.dart';
import 'package:doceo_new/pages/search/exit_room_dialog.dart';
import 'package:doceo_new/pages/search/join_room_dialog.dart';
import 'package:doceo_new/pages/search/room_entrance_page.dart';
import 'package:doceo_new/pages/search/room_info_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;
import 'package:doceo_new/models/ModelProvider.dart' as Models;
import 'package:url_launcher/url_launcher.dart';

class SingleRoomPage extends StatefulWidget {
  const SingleRoomPage({super.key});

  @override
  _SingleRoomPage createState() => _SingleRoomPage();
}

class _SingleRoomPage extends State<SingleRoomPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  int reasonIndex = 0;
  bool isJoining = false;
  final Uri _email = Uri.parse(
      'https://www.noway-form.com/ja/f/44fd04ca-e059-46d9-9e76-bad47b7ae6e6');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final selectedRoom = AppProviderPage.of(context).selectedRoom;
    List totalRooms = AppProviderPage.of(context, listen: false).rooms;
    int roomIndex =
        totalRooms.indexWhere((e) => e['channel']['id'] == selectedRoom);
    final roomInfo = totalRooms[roomIndex];
    final doctors = roomInfo['members']
        .where((e) => e['user']['role'] == 'doctor')
        .toList();
    final tags = roomInfo['channel']['tags'] ?? [];
    final feedCount = roomInfo['channel']['feedsCount'] ?? 0;
    final doctorFeedCount = roomInfo['channel']['doctorFeedsCount'] ?? 0;
    print(roomInfo['channel']);

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          backgroundColor: const Color(0xffF2F2F2),
          body: SingleChildScrollView(
            child: SizedBox(
              height: height,
              width: width,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/single_room_background.png'),
                            fit: BoxFit.cover)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RoomInfoPage(roomId: selectedRoom)));
                      },
                      child: Column(
                        children: [
                          AppBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            leading: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                            actions: [
                              // InkWell(
                              //   onTap: () {},
                              //   child: const Padding(
                              //     padding: EdgeInsets.symmetric(horizontal: 10),
                              //     child: Icon(
                              //       Icons.search_outlined,
                              //       color: Colors.black,
                              //     ),
                              //   ),
                              // ),
                              InkWell(
                                onTap: () async {
                                  if (!await launchUrl(_email,
                                      mode: LaunchMode.inAppWebView)) {
                                    throw Exception('Could not launch $_email');
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  AppProviderPage.of(context)
                                          .roomSigned[roomIndex]['status']
                                      ? _showExitRoomDialog(context)
                                      : _showJoinRoomDialog(context);
                                },
                                child: Container(
                                    height: 30,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      color: AppProviderPage.of(context,
                                                  listen: true)
                                              .roomSigned[roomIndex]['status']
                                          ? Colors.white
                                          : const Color(0xFF69E4BF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.5),
                                      ),
                                    ),
                                    child: AppProviderPage.of(context,
                                                listen: true)
                                            .roomSigned[roomIndex]['status']
                                        ? const Icon(Icons.cloud_done_rounded,
                                            color: Color(0xffB4BABF))
                                        : const Text(
                                            '参加',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'M_PLUS',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )),
                              )
                            ],
                          ),
                          Container(
                              color: Colors.transparent,
                              alignment: Alignment.bottomCenter,
                              child: Row(children: [
                                SizedBox(
                                  width: width * 0.5,
                                  child: roomInfo['channel']['image'] != null
                                      ? Image.network(
                                          roomInfo['channel']['image'],
                                          fit: BoxFit.contain,
                                          height: width * 0.3,
                                          width: width * 0.3,
                                        )
                                      : Image.asset(
                                          'assets/images/room-icon1.png',
                                          fit: BoxFit.contain,
                                          height: width * 0.3,
                                          width: width * 0.3,
                                        ),
                                ),
                                SizedBox(
                                  width: width * 0.5,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          roomInfo['channel']['name'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontFamily: 'M_PLUS',
                                            fontWeight: FontWeight.bold,
                                            height: 1.33,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 7, bottom: 7),
                                          child: Text(
                                            roomInfo['members'].isNotEmpty
                                                ? '${roomInfo['members'].length}人が参加中'
                                                : 'まだ誰も参加していません。',
                                            style: const TextStyle(
                                              color: Color(0xFF4F5660),
                                              fontSize: 15,
                                              fontFamily: 'M_PLUS',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          runSpacing: 4,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Text(
                                                  doctors.isNotEmpty
                                                      ? 'ROOM担当医師'
                                                      : 'ROOM担当医師はまだ参加していません',
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      color: Color(0xFF4F5660),
                                                      fontFamily: 'M_PLUS',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                            if (doctors.isNotEmpty)
                                              for (int index = 0;
                                                  index < doctors.length;
                                                  index++)
                                                doctorIcon(doctors[index])
                                          ],
                                        ),
                                      ]),
                                ),
                              ])),
                          const SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    color: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var i = 0; i < 3; i++)
                          Material(
                            child: InkWell(
                              onTap: () {
                                _tabController.animateTo(i);
                              },
                              child: Container(
                                color: Colors.white,
                                // padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                        i == 0
                                            ? '投稿'
                                            : i == 1
                                                ? '医師掲示板'
                                                : 'グループチャット',
                                        style: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 17,
                                            fontWeight: _selectedIndex == i
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: _selectedIndex == i
                                                ? Colors.black
                                                : const Color(0xffB4BABF))),
                                    const SizedBox(height: 7),
                                    if (_selectedIndex == i)
                                      Container(
                                        height: 3,
                                        width: width * 0.1,
                                        decoration: ShapeDecoration(
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.50),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text('ROOM対象疾患',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: "M_PLUS",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.mainText2)),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                            tags.length,
                                            (index) =>
                                                _hashTagCard(tags[index])),
                                      )),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text('計$feedCount個',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: "M_PLUS",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.mainText2)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomFlatFeed(
                                    scrollable: false,
                                    context: context,
                                    id: selectedRoom,
                                    type: 'room',
                                    noItem: _emptyPage(context, 0),
                                  )
                                ]))),
                        Container(
                            padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text('ROOM対象疾患',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: "M_PLUS",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.mainText2)),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                            tags.length,
                                            (index) =>
                                                _hashTagCard(tags[index])),
                                      )),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text('計$doctorFeedCount個',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: "M_PLUS",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.mainText2)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomFlatFeed(
                                    scrollable: false,
                                    context: context,
                                    id: selectedRoom,
                                    type: 'room_doctor',
                                    noItem: _emptyPage(context, 0),
                                  ),
                                ]))),
                        StreamChannelListView(
                            padding: const EdgeInsets.only(top: 12, bottom: 35),
                            shrinkWrap: true,
                            emptyBuilder: (BuildContext context) {
                              return _emptyPage(context, 2);
                            },
                            controller: StreamChannelListController(
                                client: StreamChat.of(context).client,
                                presence: false,
                                // messageLimit: 300,
                                filter: Filter.and([
                                  Filter.equal(
                                    'room',
                                    selectedRoom,
                                  ),
                                  Filter.or([
                                    Filter.equal('private', false),
                                    Filter.notExists('private')
                                  ]),
                                  Filter.in_('type', const [
                                    'channel-1',
                                    'channel-2',
                                    'channel-3'
                                  ]),
                                ]),
                                channelStateSort: const [
                                  SortOption('created_at',
                                      direction: SortOption.ASC)
                                ]),
                            separatorBuilder: (context, values, index) =>
                                const SizedBox.shrink(),
                            itemBuilder: _channelCard)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: _selectedIndex == 0 &&
                  AppProviderPage.of(context, listen: true)
                      .roomSigned[roomIndex]['status']
              ? FloatingActionButton(
                  elevation: 25,
                  backgroundColor: const Color(0xff4F5660),
                  onPressed: () {
                    _showAddFeedDialog(context);
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        ));
  }

  Widget _channelCard(
    context,
    channels,
    index,
    defaultWidget,
  ) {
    final client = StreamChat.of(context).client;
    final currentUser = StreamChat.of(context).currentUser;
    String title = channels[index].name ?? '';
    String? cid = channels[index].cid;
    bool hasCoin = channels[index].type == 'channel-2';
    String desc = channels[index].extraData['description'] ?? 'No Description';
    final selectedRoom = AppProviderPage.of(context).selectedRoom;
    List totalRooms = AppProviderPage.of(context, listen: false).rooms;
    int roomIndex =
        totalRooms.indexWhere((e) => e['channel']['id'] == selectedRoom);
    bool isSigned = AppProviderPage.of(context).roomSigned[roomIndex]['status'];
    final hasJoined = channels[index]
        .state
        .members
        .where((member) => member.userId == currentUser!.id)
        .isNotEmpty;

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
                                  hasCoin
                                      ? Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 0, 9, 0),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFF9F0E0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Row(children: [
                                            SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: SvgPicture.asset(
                                                    'assets/images/coin-icon.svg',
                                                    fit: BoxFit.cover)),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            const Text(
                                              'D-COIN',
                                              style: TextStyle(
                                                  color: Color(0xFFFCC14C),
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ]),
                                        )
                                      : Container(
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
                                            'Free',
                                            style: TextStyle(
                                                color: Color(0xff4F5660),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                desc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
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
                      if (isSigned)
                        InkWell(
                          onTap: () {
                            if (!hasJoined) {
                              final currentUser =
                                  StreamChat.of(context).currentUser;
                              if (hasCoin &&
                                  (currentUser!.extraData['point'] == null ||
                                      currentUser.extraData['point'] == 0)) {
                                _showChargeAlertDialog(context);
                                return;
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RoomEntrancePage(
                                          channel: channels[index])));
                            } else {
                              goChannelDetail(channels[index]);
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 3),
                              decoration: ShapeDecoration(
                                color: !hasJoined
                                    ? const Color(0xFFE7FFF8)
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 0.50,
                                      color: !hasJoined
                                          ? const Color(0xFF69E4BF)
                                          : const Color(0xFFB4BABF)),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: !hasJoined
                                  ? const Text(
                                      '入る',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF69E4BF),
                                        fontSize: 15,
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.cloud_done_rounded,
                                      color: Color(0xFFB4BABF),
                                    )),
                        )
                    ],
                  ),
                )),
          );
        });
  }

  Widget _hashTagCard(tagId) {
    final tags = AppProviderPage.of(context).tags;
    final tagIndex = tags.indexWhere((tag) => tag.id == tagId);

    return FutureBuilder(
        future: getTagActivity(tagId),
        builder: ((context, snapshot) {
          final data = snapshot.data;

          return Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 12),
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '＃${tagIndex >= 0 ? tags[tagIndex].name : 'Unknown'}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color(0xFF4F5660),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.normal)),
                        Text(
                          snapshot.hasData
                              ? data!.extraData!['text'].toString()
                              : 'No post',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFB4BABF),
                            fontSize: 15,
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 58,
                    height: 58,
                    decoration: data != null &&
                            data.extraData!['filePath'] != null &&
                            data.extraData!['fileType'] == 'image'
                        ? ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  data.extraData!['filePath'].toString()),
                              fit: BoxFit.fill,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          )
                        : null,
                  )
                ],
              ));
        }));
  }

  Widget _emptyPage(BuildContext context, int index) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SvgPicture.asset(
            'assets/images/empty-feed-icon.svg',
            fit: BoxFit.contain,
          ),
          Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 55, right: 55),
              child: Text(
                  index == 0
                      ? 'まだあなたと同じ悩みを持つユーザの投稿がありません'
                      : index == 1
                          ? 'まだグループチャットが開設されていません'
                          : 'まだ医師参加型のチャットが開設されていません',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xffcbcbcb),
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.normal)))
        ]));
  }

  _showJoinRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => JoinRoomDialog(),
    );
  }

  _showExitRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ExitRoomDialog(),
    );
  }

  Widget doctorIcon(Map<String, dynamic> doctor) {
    late String imageUrl = doctor['user']['image'] ??
        'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%EF%BC%88%E3%82%B5%E3%82%A4%E3%82%B9%E3%82%99%E8%AA%BF%E6%95%B4%E6%B8%88%E3%81%BF%EF%BC%89/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88/Defalt_Doctor_Icon_Gray.png';
    return Container(
      width: 22,
      height: 22,
      padding: EdgeInsets.zero,
      alignment: Alignment.bottomLeft,
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () {
          // showModalBottomSheet(
          //     context: context,
          //     isScrollControlled: true,
          //     useRootNavigator: true,
          //     shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(20),
          //         topRight: Radius.circular(20),
          //       ),
          //     ),
          //     builder: ((context) {
          //       return DoctorInfoModal(doctor: doctor);
          //     }));
        },
        child: CircleAvatar(
            backgroundColor: Colors.black12,
            backgroundImage: NetworkImage(imageUrl)),
      ),
    );
  }

  _showChargeAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChargeAlertDialog(),
    );
  }

  Future<StreamFeed.Activity?> getTagActivity(tagId) async {
    final feedClient = context.feedClient;
    final tagFeed = feedClient.flatFeed('tag', tagId);

    try {
      final activities = await tagFeed.getActivities(limit: 1);
      return activities.isEmpty ? null : activities[0];
    } catch (e) {
      rethrow;
    }
  }

  void _showAddFeedDialog(BuildContext context) {
    final selectedRoom = AppProviderPage.of(context).selectedRoom;
    showDialog(
      context: context,
      builder: (context) => AddFeedDialog(selectedRoom: selectedRoom),
    );
  }

  void goChannelDetail(Channel channel) {
    if (channel.type == 'channel-1') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StreamChannel(
            channel: channel,
            child: const Type1Channel1Page(),
          ),
        ),
      );
    } else if (channel.type == 'channel-2') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StreamChannel(
            channel: channel,
            child: Type2Channel1Page(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StreamChannel(
            channel: channel,
            child: const Type3Channel1Page(),
          ),
        ),
      );
    }
  }
}
