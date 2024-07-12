// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:doceo_new/getstream/custom_feed_card.dart';
import 'package:doceo_new/pages/home/feed_screen.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class HashTagScreen extends StatefulWidget {
  @override
  _HashTagScreen createState() => _HashTagScreen();
}

class _HashTagScreen extends State<HashTagScreen> {
  List selectedTagList = [];
  bool loadingData = true;
  @override
  void initState() {
    setState(() {
      selectedTagList = AppProviderPage.of(context, listen: false).hashTag;
      loadingData = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FeedScreen()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        titleSpacing: 0,
        // title: Align(
        //   alignment: Alignment.centerLeft,
        //   child: const Text(
        //     "戻る",
        //     style: TextStyle(
        //       fontFamily: 'M_PLUS',
        //       color: Colors.black,
        //       fontSize: 17,
        //     ),
        //   ),
        // ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // ignore: unnecessary_new
          child: new SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        AppProviderPage.of(context, listen: false).tagKey,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )
                  ],
                ),
                // Expanded(
                //   child: (loadingData)
                //       ? Container(
                //           alignment: Alignment.center,
                //           child: const CircularProgressIndicator(
                //               valueColor:
                //                   AlwaysStoppedAnimation<Color>(Colors.grey),
                //               strokeWidth: 2),
                //         )
                //       : ListView.builder(
                //           padding: const EdgeInsets.all(8),
                //           itemCount: selectedTagList.length,
                //           itemBuilder: (BuildContext context, int index) {
                //             return CustomFeedCard(
                //               key: GlobalKey(),
                //               context: context,
                //               id: selectedTagList[index].id!,
                //               userInfo:
                //                   (selectedTagList[index].actor.runtimeType ==
                //                           String)
                //                       ? {}
                //                       : selectedTagList[index].actor,
                //               externalData: selectedTagList[index].extraData,
                //               tags: jsonDecode(jsonEncode(
                //                   selectedTagList[index].extraData['tags'])),
                //               verbType: selectedTagList[index].verb,
                //               reactionNum:
                //                   selectedTagList[index].reactionCounts,
                //             );
                //           }),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
