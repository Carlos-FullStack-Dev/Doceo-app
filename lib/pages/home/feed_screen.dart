import 'package:doceo_new/getstream/custom_flat_feed.dart';
import 'package:doceo_new/helper/fcm_helper.dart';
import 'package:doceo_new/pages/home/add_feed_dialog.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreen();
}

class _FeedScreen extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  List publicFeeds = [];
  List roomtagFeeds = [];
  List privateFeeds = [];
  bool publicFeedFlag = false;
  bool tagroomFeedFlag = false;
  bool privateFeedFlag = false;
  @override
  void initState() {
    // getPublicFeed();
    super.initState();
    FcmHelper.initFcm(updateToken);
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
    final userId = AuthenticateProviderPage.of(context).user['sub'];

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: Stack(children: [
          Column(children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    InkWell(
                      onTap: () {
                        _tabController.animateTo(i);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 2),
                        decoration: BoxDecoration(
                          color: _selectedIndex == i
                              ? const Color(0xff4F5660)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                            i == 0
                                ? 'つながる'
                                : i == 1
                                    ? 'フォロー中'
                                    : '新着',
                            style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 17,
                                fontWeight: _selectedIndex == i
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _selectedIndex == i
                                    ? Colors.white
                                    : const Color(0xffB4BABF))),
                      ),
                    ),
                  // InkWell(
                  //   onTap: () {},
                  //   child: SvgPicture.asset('assets/images/search-icon.svg',
                  //       fit: BoxFit.contain, height: 25, width: 25),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    CustomFlatFeed(
                        context: context,
                        id: userId,
                        type: 'related',
                        noItem:
                            noItemWidget('こちらはあなたと同じ悩みを登録したユーザーの投稿が表示されます')),
                    CustomFlatFeed(
                        context: context,
                        id: userId,
                        type: 'timeline',
                        noItem: noItemWidget('ここにはあなたがフォローしているユーザーの投稿が表示されます')),
                    CustomFlatFeed(
                        context: context,
                        id: 'all',
                        type: 'user',
                        noItem: noItemWidget('ここにはあなたと同じ悩みを持つユーザーの投稿が表示されます ')),
                  ],
                ),
              ),
            )
          ]),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                _showAddFeedDialog(context);
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
          )
        ]),
      ),
    );
  }

  Widget noItemWidget(String text) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SvgPicture.asset(
            'assets/images/empty-channel.svg',
            fit: BoxFit.contain,
          ),
          Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 65, right: 65),
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xffcbcbcb),
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.w500)))
        ]));
  }

  void _showAddFeedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const AddFeedDialog(),
    );
  }

  Future<void> updateToken(String? token) {
    print('Token: $token');
    StreamChat.of(context).client.addDevice(token!, PushProvider.firebase,
        pushProviderName: 'doceo_pushnotification');
    throw '';
  }
}
