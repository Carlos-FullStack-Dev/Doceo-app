// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/components/show_channel_icon.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/getstream/custom_flat_feed.dart';
import 'package:doceo_new/pages/channels/type_1/channel_1_1_page.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_page.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_page.dart';
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/pages/search/charge_alert_dialog.dart';
import 'package:doceo_new/pages/search/room_entrance_page.dart';
import 'package:doceo_new/pages/search/single_room_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorPage extends StatefulWidget {
  String doctorId;
  DoctorPage({super.key, required this.doctorId});

  @override
  _DoctorPage createState() => _DoctorPage();
}

class _DoctorPage extends State<DoctorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  var hospitalName = '登録していません。';
  var address = '登録していません。';
  bool isLoading = true;
  late User doctorInfo = User(id: widget.doctorId);

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    super.initState();
    getData(widget.doctorId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final avatar = doctorInfo.image ??
        'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%EF%BC%88%E3%82%B5%E3%82%A4%E3%82%B9%E3%82%99%E8%AA%BF%E6%95%B4%E6%B8%88%E3%81%BF%EF%BC%89/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88/Defalt_Doctor_Icon_Gray.png';
    final dateFormatter = DateFormat.yMd('ja');
    final totalRooms = AppProviderPage.of(context).rooms;
    final roomIndex = totalRooms.indexWhere((room) {
      final memberIndex = (room['members'] as List)
          .indexWhere((member) => member['user_id'] == widget.doctorId);
      return memberIndex >= 0;
    });
    final isJoined = roomIndex >= 0
        ? AppProviderPage.of(context).roomSigned[roomIndex]['status']
        : false;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          backgroundColor: const Color(0xffF8F8F8),
          body: isLoading
              ? const LoadingAnimation()
              : Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/my-page-header.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 0, bottom: 15),
                          alignment: Alignment.centerLeft,
                          child: SafeArea(
                            bottom: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                    const Expanded(child: SizedBox.shrink()),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: avatar.isNotEmpty
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    image: avatar.startsWith(
                                                            'assets')
                                                        ? DecorationImage(
                                                            image: AssetImage(
                                                                avatar),
                                                            fit: BoxFit.contain)
                                                        : DecorationImage(
                                                            image: NetworkImage(
                                                                avatar),
                                                            fit:
                                                                BoxFit.contain),
                                                    color: Colors.white,
                                                    shape: BoxShape.circle))
                                            : Container(
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.blueAccent,
                                                ),
                                                child: Text(
                                                  doctorInfo.name.length >= 2
                                                      ? doctorInfo.name
                                                          .substring(0, 2)
                                                          .toUpperCase()
                                                      : doctorInfo.name
                                                          .substring(0, 1)
                                                          .toUpperCase(),
                                                  style: const TextStyle(
                                                      fontFamily: 'M_PLUS',
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${doctorInfo.extraData['occupation'] ?? ''}/${doctorInfo.extraData['specialtyName'] ?? ''} ${doctorInfo.extraData['lastName'] ?? ''}${doctorInfo.extraData['firstName'] ?? ''}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${dateFormatter.format(doctorInfo.createdAt)} から利用中',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontFamily: 'M_PLUS',
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  '${doctorInfo.extraData['trouble'] ?? '${doctorInfo.extraData['specialtyName'] ?? ''} 全般'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (roomIndex >= 0)
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            totalRooms[roomIndex]['channel']
                                                        ['image'] !=
                                                    null
                                                ? Image.network(
                                                    totalRooms[roomIndex]
                                                        ['channel']['image'],
                                                    height: 21,
                                                    width: 21,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/images/room-icon1.png',
                                                    fit: BoxFit.cover,
                                                    width: 21,
                                                    height: 21),
                                            const SizedBox(width: 14),
                                            Text(
                                              totalRooms[roomIndex]['channel']
                                                  ['name'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontFamily: 'M_PLUSå',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ])),
                                if (hospitalName.isNotEmpty)
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(children: [
                                        SvgPicture.asset(
                                          'assets/images/hospital-icon.svg',
                                          fit: BoxFit.cover,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 14),
                                        Text(
                                          hospitalName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: 'M_PLUS',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ])),
                                if (address.isNotEmpty)
                                  Row(children: [
                                    SvgPicture.asset(
                                      'assets/images/map-icon.svg',
                                      fit: BoxFit.cover,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 14),
                                    Text(
                                      address,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ])
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
                                                  ? '基本情報'
                                                  : i == 1
                                                      ? '診察レポート'
                                                      : '担当チャット',
                                              style: TextStyle(
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight:
                                                      _selectedIndex == i
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                  color: _selectedIndex == i
                                                      ? Colors.black
                                                      : const Color(
                                                          0xffB4BABF))),
                                          const SizedBox(height: 7),
                                          if (_selectedIndex == i)
                                            Container(
                                              height: 3,
                                              width: width * 0.1,
                                              decoration: ShapeDecoration(
                                                color: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.50),
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
                              doctorInfoList(),
                              Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: CustomFlatFeed(
                                      context: context,
                                      id: widget.doctorId,
                                      type: 'doctor',
                                      showUser: false,
                                      noItem: _emptyPage(context))),
                              Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: CustomFlatFeed(
                                      context: context,
                                      id: widget.doctorId,
                                      type: 'user',
                                      showUser: false,
                                      noItem: _emptyPage(context))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (roomIndex >= 0)
                      Positioned(
                        bottom: 0,
                        child: Container(
                          color: Colors.white,
                          width: width,
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, top: 10, bottom: 10),
                          child: SafeArea(
                            top: false,
                            child: InkWell(
                              onTap: () {
                                if (isJoined) {
                                  leftRoom(roomIndex);
                                } else {
                                  joinRoom(roomIndex);
                                }
                              },
                              child: Container(
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    color: isJoined
                                        ? const Color(0xFFF2F2F2)
                                        : const Color(0xFF69E4BF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                  ),
                                  child: Text(
                                    isJoined ? 'フォロー中' : 'フォロー',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isJoined
                                          ? const Color(0xFFB4BABF)
                                          : Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'M_PLUS',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      )
                  ],
                )),
    );
  }

  Widget doctorInfoList() {
    final _itemCount =
        ((doctorInfo.extraData['links'] ?? []) as List<dynamic>).length;
    return SingleChildScrollView(
      child: Column(children: [
        // if ((doctorInfo.extraData['medicalSpecialties'] != null &&
        //         doctorInfo.extraData['medicalSpecialties'] != '') ||
        //     (doctorInfo.extraData['biography'] != null &&
        //         doctorInfo.extraData['biography'] != '') ||
        //     (doctorInfo.extraData['links'] != null &&
        //         doctorInfo.extraData['links'] != '') ||
        //     (doctorInfo.extraData['papers'] != null &&
        //         doctorInfo.extraData['papers'] != ''))
        Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (doctorInfo.extraData['medicalSpecialties'] != null &&
                  //     doctorInfo.extraData['medicalSpecialties'] != '')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('専門医資格',
                            style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        Text(
                            // '${doctorInfo.extraData['medicalSpecialties'] ?? '未登録です。'}',
                            '${doctorInfo.extraData['medicalSpecialties'] ?? '未登録です。'}',
                            style: const TextStyle(
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                  // if (doctorInfo.extraData['biography'] != null &&
                  //     doctorInfo.extraData['biography'] != '')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('略歴',
                            style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        Text('${doctorInfo.extraData['biography'] ?? '未登録です。'}',
                            style: const TextStyle(
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                  // if (doctorInfo.extraData['papers'] != null &&
                  //     doctorInfo.extraData['papers'] != '')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('研究テーマ / 論文',
                            style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        Text('${doctorInfo.extraData['papers'] ?? '未登録です。'}',
                            style: const TextStyle(
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                ])),
        if (doctorInfo.extraData['links'] != null &&
            (doctorInfo.extraData['links'] as List<dynamic>).isNotEmpty)
          Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('所属先HPのリンク',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    Container(
                      height: _itemCount * 50,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 0.15, color: Color(0xFF4F5660)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            (doctorInfo.extraData['links'] as List<dynamic>)
                                .length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: const EdgeInsets.only(bottom: 0),
                              padding: const EdgeInsets.only(left: 15),
                              child: TextButton(
                                onPressed: () {
                                  _openURL((doctorInfo.extraData['links']
                                      as List<dynamic>)[index]['url']);
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          (doctorInfo.extraData['links']
                                              as List<dynamic>)[index]['title'],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'M_PLUS',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                      )
                                    ]),
                              ));
                        },
                      ),
                    ),
                  ])),
        const SizedBox(height: 60)
      ]),
    );
  }

  void _openURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getData(doctorId) async {
    final client = StreamChat.of(context).client;
    try {
      final result =
          await client.queryUsers(filter: Filter.equal('id', doctorId));
      final hosptials = AppProviderPage.of(context).hospitals;
      int hospitalIndex = hosptials.indexWhere(
          (e) => e.id == result.users[0].extraData['hospitalId'].toString());
      final hospital = hospitalIndex >= 0 ? hosptials[hospitalIndex] : null;
      setState(() {
        doctorInfo = result.users[0];
        if (hospital?.name != null) hospitalName = hospital!.name.toString();
        if (hospital?.address != null) address = hospital!.address.toString();
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _emptyPage(BuildContext context) {
    return const Center(
        child: Text('まだ投稿がありません。',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xffb4babf),
                fontFamily: 'M_PLUS',
                fontSize: 15,
                fontWeight: FontWeight.normal)));
  }

  void joinRoom(roomIndex) async {
    final client = StreamChat.of(context).client;
    final feedClient = context.feedClient;
    final rooms = AppProviderPage.of(context).rooms;
    final roomID = rooms[roomIndex]['channel']['id'];
    final userId = AuthenticateProviderPage.of(context).user['sub'];

    try {
      final channel = client.channel('room', id: roomID);
      await channel.watch();
      await channel.addMembers([userId]);

      final relatedFeed = feedClient.flatFeed('related', userId);
      final roomFeed = feedClient.flatFeed('room', roomID);
      await relatedFeed.follow(roomFeed);

      final roomSigned = AppProviderPage.of(context, listen: false).roomSigned;
      roomSigned[roomIndex]['status'] = true;
      AppProviderPage.of(context, listen: false).roomSigned = roomSigned;
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void leftRoom(roomIndex) async {
    final client = StreamChat.of(context).client;
    final feedClient = context.feedClient;
    final rooms = AppProviderPage.of(context).rooms;
    final roomId = rooms[roomIndex]['channel']['id'];
    final userId = AuthenticateProviderPage.of(context).user['sub'];
    final channel = client.channel('room', id: roomId);
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

      final roomSigned = AppProviderPage.of(context, listen: false).roomSigned;
      roomSigned[roomIndex]['status'] = false;
      AppProviderPage.of(context, listen: false).roomSigned = roomSigned;
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
