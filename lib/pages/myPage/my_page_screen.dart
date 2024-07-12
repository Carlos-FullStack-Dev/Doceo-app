// ignore_for_file: avoid_print

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/getstream/custom_flat_feed.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/home/add_feed_page.dart';
import 'package:doceo_new/pages/initialUserSetting/select_trouble.dart';
import 'package:doceo_new/pages/myPage/coin_charge_page.dart';
import 'package:doceo_new/pages/myPage/my_trouble_page.dart';
import 'package:doceo_new/pages/myPage/profile_page.dart';
import 'package:doceo_new/pages/notification/follower_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreen createState() => _MyPageScreen();
}

class _MyPageScreen extends State<MyPageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  List rooms = [];
  int followers = 0;
  int followings = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    final roomSigned = AppProviderPage.of(context).roomSigned;
    final List totalRooms = AppProviderPage.of(context).rooms;

    setState(() {
      List temp = [];
      for (int i = 0; i < totalRooms.length; i++) {
        if (roomSigned[i]['status']) {
          temp.add(totalRooms[i]);
        }
      }

      rooms = temp;
    });
    super.initState();
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
    final formatter = NumberFormat.compact();
    final dateFormatter = DateFormat.yMd('ja');
    final userId =
        AuthenticateProviderPage.of(context, listen: false).user['sub'];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Container(
        color: const Color(0xffF8F8F8),
        height: height,
        width: width,
        child: BetterStreamBuilder(
            stream: StreamChat.of(context).client.state.currentUserStream,
            builder: (context, data) {
              var avatarUrl = data.image ?? 'assets/images/avatars/default.png';
              var userName = data.name;
              var intro = data.extraData['intro'];
              final joined = AuthenticateProviderPage.of(context).joined;

              return Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/my-page-header.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 0, bottom: 15),
                    alignment: Alignment.centerLeft,
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CoinChargePage()));
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(right: 10, left: 0),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xffF2F2F2)
                                        .withOpacity(0.68),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: SvgPicture.asset(
                                              'assets/images/coin-icon.svg',
                                              fit: BoxFit.cover)),
                                      const SizedBox(width: 5),
                                      Text(
                                        data.extraData['point'] != null
                                            ? formatter
                                                .format(data.extraData['point'])
                                            : '0',
                                        overflow: TextOverflow.visible,
                                        style: const TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff777777)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox.shrink()),
                              InkWell(
                                onTap: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                child: const Icon(
                                  Icons.menu_rounded,
                                  size: 27,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: avatarUrl.isNotEmpty
                                      ? Container(
                                          decoration: BoxDecoration(
                                              image: avatarUrl
                                                      .startsWith('assets')
                                                  ? DecorationImage(
                                                      image:
                                                          AssetImage(avatarUrl),
                                                      fit: BoxFit.contain)
                                                  : DecorationImage(
                                                      image: NetworkImage(
                                                          avatarUrl),
                                                      fit: BoxFit.contain),
                                              color: Colors.white,
                                              shape: BoxShape.circle))
                                      : Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blueAccent,
                                          ),
                                          child: Text(
                                            userName.length >= 2
                                                ? userName
                                                    .substring(0, 2)
                                                    .toUpperCase()
                                                : userName
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                            style: const TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 4,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage()));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName,
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
                                            '${dateFormatter.format(joined)} から利用中',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(width: 15),
                                          const Icon(
                                              Icons.mode_edit_outline_outlined,
                                              color: Colors.white,
                                              size: 25)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            intro != null ? intro.toString() : '自己紹介が未編集です',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 15,
                            runSpacing: 12,
                            direction: Axis.horizontal,
                            children: [
                              if (rooms.isEmpty)
                                Row(children: [
                                  SvgPicture.asset(
                                    'assets/images/room-icon-outlined.svg',
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'no joined ROOMs',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: 'M_PLUSå',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ]),
                              for (var room in rooms) ...[
                                Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      room['channel']['image'] != null
                                          ? Image.network(
                                              room['channel']['image']
                                                  .toString(),
                                              height: 27,
                                              width: 27,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/room-icon1.png',
                                              fit: BoxFit.cover,
                                              width: 27,
                                              height: 27),
                                      const SizedBox(width: 5),
                                      Text(
                                        room['channel']['name'].toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: 'M_PLUSå',
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ])
                              ]
                            ],
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<List<Tag>>(
                              future: getUserTags(userId),
                              builder: ((context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectTroublePage(
                                                        fromPage: 'my_page')));
                                      },
                                      child: Row(children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              top: 5,
                                              bottom: 5,
                                              right: 10),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xADF2F2F2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                          child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: const [
                                                Text(
                                                  '自分の悩みを設定しよう',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFF4F5660),
                                                    fontSize: 13,
                                                    fontFamily: 'M_PLUS',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.chevron_right,
                                                  // size: 13,
                                                )
                                              ]),
                                        )
                                      ]));
                                }

                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyTroublePage(
                                                      userId: userId,
                                                      isEditable: true)));
                                    },
                                    child: Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        runAlignment: WrapAlignment.start,
                                        children: [
                                          ...snapshot.data!
                                              .map((tag) => Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 3),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                    decoration: ShapeDecoration(
                                                      color: const Color(
                                                          0xADF2F2F2),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      tag.name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF4F5660),
                                                        fontSize: 13,
                                                        fontFamily: 'M_PLUS',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 3),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                            decoration: ShapeDecoration(
                                              color: const Color(0xADF2F2F2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Icon(Icons
                                                .keyboard_control_outlined),
                                          )
                                        ]));
                              })),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FollowerPage(
                                                  type: 'following',
                                                  userId: userId,
                                                )));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        formatter.format(followings),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'M_PLUS',
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      const Text(
                                        'フォロー中',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: 'M_PLUS',
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FollowerPage(
                                                type: 'follower',
                                                userId: userId,
                                              )));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      formatter.format(followers),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const Text(
                                      'フォロワー',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
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
                                            ? 'つぶやき'
                                            : i == 1
                                                ? '診察レポート'
                                                : '保存したポスト',
                                        style: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
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
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child:
                              TabBarView(controller: _tabController, children: [
                            CustomFlatFeed(
                                context: context,
                                id: userId,
                                type: 'user',
                                showUser: false,
                                verbFilter: 'tweet',
                                noItem: _emptyPage(context, 'tweet')),
                            CustomFlatFeed(
                                context: context,
                                id: userId,
                                type: 'user',
                                showUser: false,
                                verbFilter: 'diary',
                                noItem: _emptyPage(context, 'diary')),
                            CustomFlatFeed(
                                context: context,
                                id: userId,
                                type: 'collection',
                                noItem: const Center(
                                    child: Text(
                                        '他の人の投稿で気になるものを保存できます\n*保存した投稿一覧は自分にしか表せません',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xffcbcbcb),
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal))))
                          ])))
                ],
              );
            }),
      ),
    );
  }

  Widget _emptyPage(BuildContext context, String verb) {
    return Align(
        child: Container(
      alignment: Alignment.topCenter,
      child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          height: 130,
          alignment: Alignment.center,
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 25),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            verb == 'tweet'
                ? SvgPicture.asset(
                    'assets/images/tweet-icon.svg',
                    fit: BoxFit.contain,
                  )
                : SvgPicture.asset(
                    'assets/images/diary-icon.svg',
                    fit: BoxFit.contain,
                  ),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      verb == 'tweet' ? '今の気持ちを投稿しよう' : '診察を記録しよう',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Rounded Mplus 1c',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      verb == 'tweet'
                          ? 'あなたの今の悩みや気持ちを気軽に投稿してみて'
                          : '診察の内容を記録して皆んなにシェアしよう',
                      style: const TextStyle(
                        color: Color(0xFF4F5660),
                        fontSize: 15,
                        fontFamily: 'Rounded Mplus 1c',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddFeedPage(postType: verb)),
                );
              },
              style: ButtonStyle(
                iconSize: MaterialStateProperty.all(35),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff4F5660)),
                shape: MaterialStateProperty.all<CircleBorder>(
                    const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
              ),
              child: const Icon(Icons.add),
            ),
          ])),
    ));
  }

  Future<List<Tag>> getUserTags(userId) async {
    try {
      final query = UserTag.USERID.eq(userId);
      final request = ModelQueries.list(UserTag.classType, where: query);
      final response = await Amplify.API.query(request: request).response;
      if (response.data != null) {
        final userTags = response.data!.items;

        return userTags
            .where((userTag) => userTag!.tag != null)
            .map((userTag) => userTag!.tag!)
            .toList()
            .sublist(0, 2);
      }
      return [];
    } catch (e) {
      safePrint(e);
      return [];
    }
  }

  @override
  void didChangeDependencies() async {
    final feedClient = context.feedClient;
    final userId = AuthenticateProviderPage.of(context).user['sub'];
    final followingRes = await feedClient
        .flatFeed('timeline', userId)
        .followStats(followingSlugs: ['user']);
    final followerRes = await feedClient
        .flatFeed('user', userId)
        .followStats(followerSlugs: ['timeline']);

    setState(() {
      followings = followingRes.following.count ?? 0;
      followers = followerRes.followers.count ?? 0;
    });
  }
}
