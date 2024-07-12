// ignore_for_file: avoid_print

import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/search/room_info_page.dart';
import 'package:doceo_new/pages/search/single_room_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  List rooms = [];
  int _currentIndex = 0;
  CarouselController _carouselController = CarouselController();
  final Uri _roomHelp = Uri.parse(
      'https://wivil.notion.site/wivil/D-ROOM-1a6032dbc6d949a0a5c3e0ab43198f28');

  @override
  void initState() {
    setState(() {
      rooms = AppProviderPage.of(context, listen: false).rooms;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openHelp() async {
    if (!await launchUrl(
      _roomHelp,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $_roomHelp');
    }
  }

  void _selectRoom(room) {
    AppProviderPage.of(context, listen: false).selectedRoom = room;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var room = rooms[_currentIndex];
    final doctors =
        room['members'].where((e) => e['user']['role'] == 'doctor').toList();
    bool joined = AppProviderPage.of(context, listen: true)
        .roomSigned[_currentIndex]['status'];
    final tagIds = room['channel']['tags'] ?? [];
    List tags = AppProviderPage.of(context).tags;
    final roomTags = tags.where((tag) {
      return tagIds.indexWhere((id) => id == tag!.id) >= 0;
    }).toList();

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: Image.asset(
              'assets/images/search-room-background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('D-ROOM',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'M_PLUS',
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          _openHelp();
                        },
                        icon: const Icon(Icons.help_outline_rounded),
                        color: Colors.black,
                        iconSize: 30,
                      ),
                    )
                  ],
                ),
              ),
              body: rooms.isNotEmpty
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          _carouselController.previousPage();
                        } else if (details.velocity.pixelsPerSecond.dx < 0) {
                          _carouselController.nextPage();
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CarouselSlider.builder(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                                viewportFraction: 0.45,
                                height: height * 0.3,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                                enlargeFactor: 0.45),
                            itemCount: rooms.length,
                            itemBuilder: (BuildContext context, int itemIndex,
                                int realIndex) {
                              final room = rooms[itemIndex];

                              return Container(
                                alignment: Alignment.bottomCenter,
                                height: height * 0.35,
                                width: width * 0.5,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: room['channel']['image'] == null
                                    ? Image.asset(
                                        'assets/images/room-icon1.png',
                                        fit: BoxFit.contain,
                                        height: width * 0.5,
                                        width: width * 0.5,
                                      )
                                    : Image.network(
                                        room['channel']['image'],
                                        fit: BoxFit.contain,
                                        height: width * 0.5,
                                        width: width * 0.5,
                                      ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(room['channel']['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    room['members'].isNotEmpty
                                        ? '${room['members'].length}人が参加中'
                                        : 'まだ誰も参加していません。',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Color(0xff1D5162),
                                        fontFamily: 'M_PLUS',
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal)),
                                if (AppProviderPage.of(context, listen: true)
                                    .roomSigned[_currentIndex]['status'])
                                  IntrinsicWidth(
                                    child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.only(
                                            top: 6,
                                            bottom: 6,
                                            right: 15,
                                            left: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.5)),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/cloud-icon.svg',
                                              color: const Color(0xFFB4BABF),
                                              width: 22,
                                              height: 16,
                                            ),
                                            const SizedBox(width: 10),
                                            const Text('参加済み',
                                                style: TextStyle(
                                                    color: Color(0xFFB4BABF),
                                                    fontFamily: 'M_PLUS',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        )),
                                  )
                              ]),
                          InkWell(
                            onTap: () {
                              if (doctors.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RoomInfoPage(
                                              roomId: room['channel']['id'],
                                            )));
                              }
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 25),
                                          child: Text(
                                              doctors.isNotEmpty
                                                  ? 'ROOM担当医師'
                                                  : 'ROOM担当医師はまだ参加していません',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color(0xff1D5162),
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                        if (doctors.isNotEmpty)
                                          ...doctors.map(
                                              (doctor) => doctorIcon(doctor))
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                          if (roomTags.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: List.generate(roomTags.length,
                                            (index) {
                                      final roomTag = roomTags[index];
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Text('#${roomTag.name}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal)));
                                    })))),
                          SizedBox(
                            height: height * 0.2,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                                child: Text(room['channel']['description'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'M_PLUS',
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal)),
                              ),
                            ),
                          ),
                        ],
                      ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.12,
                          width: width,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/room-search-header.png',
                                    ),
                                    fit: BoxFit.cover)),
                            child: SafeArea(
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                    'assets/images/room-search-doceo-logo.png',
                                    width: width * 0.3),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                              SvgPicture.asset(
                                'assets/images/empty-search.svg',
                                fit: BoxFit.contain,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.only(
                                      left: 65, right: 65),
                                  child: const Text('現在公開しているROOMがありません',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xffcbcbcb),
                                          fontFamily: 'M_PLUS',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)))
                            ])))
                      ],
                    ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  _selectRoom(rooms[_currentIndex]['channel']['id']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SingleRoomPage()));
                },
                child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF69E4BF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: const Text(
                      'ROOMをのぞいてみる',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'M_PLUS',
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget doctorIcon(Map<String, dynamic> doctor) {
    late String imageUrl = doctor['user']['image'] ??
        'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%EF%BC%88%E3%82%B5%E3%82%A4%E3%82%B9%E3%82%99%E8%AA%BF%E6%95%B4%E6%B8%88%E3%81%BF%EF%BC%89/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88/Defalt_Doctor_Icon_Gray.png';
    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.only(right: 3),
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
      child: CircleAvatar(
          backgroundColor: Colors.black12,
          backgroundImage: NetworkImage(imageUrl)),
    );
  }
}
