// ignore_for_file: avoid_print

import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';

class ChannelDetailPage extends StatefulWidget {
  const ChannelDetailPage({super.key});

  @override
  _ChannelDetailPage createState() => _ChannelDetailPage();
}

class _ChannelDetailPage extends State<ChannelDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List doctorExample = AppProviderPage.of(context, listen: false).doctors;

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              title: const Text('グループチャットの詳細',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Text(
                      'グループチャット名',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'M_PLUS',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Text(
                    'Channel title',
                    style: TextStyle(
                      color: Color(0xFF4F5660),
                      fontSize: 15,
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.10,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF4F5660),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Text(
                      'グループチャット紹介',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'M_PLUS',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Text(
                    'Group chat introduction textGroup chat introduction textGroup chat introduction textGroup chat introduction textGroup chat introduction text',
                    style: TextStyle(
                      color: Color(0xFF4F5660),
                      fontSize: 15,
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.10,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF4F5660),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Text(
                      'サブタイトル',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'M_PLUS',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Text(
                    '＃Subtitle ＃Subtitle ＃Subtitle',
                    style: TextStyle(
                      color: Color(0xFF4F5660),
                      fontSize: 15,
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )));
  }
}
