import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';

class FeedSelectRoomPage extends StatefulWidget {
  final String? roomId;
  const FeedSelectRoomPage({Key? key, this.roomId}) : super(key: key);
  @override
  _FeedSelectRoomPage createState() => _FeedSelectRoomPage();
}

class _FeedSelectRoomPage extends State<FeedSelectRoomPage>
    with WidgetsBindingObserver {
  String _index = '';
  List _rooms = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      final totalRooms = AppProviderPage.of(context, listen: false).rooms;
      final roomSigned = AppProviderPage.of(context).roomSigned;
      for (int index = 0; index < roomSigned.length; index++) {
        if (roomSigned[index]['status'] == true) {
          _rooms.add(totalRooms[index]);
        }
      }
      // _rooms = ;
      _index = widget.roomId ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text('ROOMを選択する',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _index = '';
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.pop(context, '');
                    });
                  });
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF4F5660),
                          width: 0.2,
                        ),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('選択しない',
                                  style: TextStyle(
                                      color: Color(0xff4F5660),
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          _index == ''
                              ? const Icon(Icons.check_circle,
                                  color: Color(0xff4F5660), size: 25)
                              : const SizedBox()
                        ])),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _rooms.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _item = _rooms[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _index = _item['channel']['id'];
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              Navigator.pop(context, _item['channel']['id']);
                            });
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFF4F5660),
                                  width: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _item['channel']['image'] != null
                                      ? Image.network(
                                          _item['channel']['image'].toString(),
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/room-icon1.png',
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              _item['channel']['name']
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Color(0xff4F5660),
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                              '投稿件数 ${_item['members'].length}件',
                                              style: const TextStyle(
                                                  color: Color(0xffB4BABF),
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ],
                                      ),
                                    ),
                                  ),
                                  _index == _item['channel']['id']
                                      ? const Icon(Icons.check_circle,
                                          color: Color(0xff4F5660), size: 25)
                                      : const SizedBox()
                                ])),
                      );
                    }),
              ),
            ])),
        onWillPop: () => Future.value(false));
  }
}
