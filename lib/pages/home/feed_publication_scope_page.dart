import 'package:doceo_new/helper/util_helper.dart';
import 'package:flutter/material.dart';

class FeedPublicationScopePage extends StatefulWidget {
  final String? scope;
  const FeedPublicationScopePage({Key? key, this.scope}) : super(key: key);
  @override
  _FeedPublicationScopePage createState() => _FeedPublicationScopePage();
}

class _FeedPublicationScopePage extends State<FeedPublicationScopePage>
    with WidgetsBindingObserver {
  String index = 'public';
  @override
  void initState() {
    setState(() {
      index = widget.scope ?? 'public';
    });

    super.initState();
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
              title: const Text('公開設定',
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
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 'public';
                          Future.delayed(const Duration(milliseconds: 300), () {
                            Navigator.pop(context, index);
                          });
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            UtilHelper.getPublishText('public'),
                                            style: const TextStyle(
                                                color: Color(0xff4F5660),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                        const Text('誰でもこの投稿を閲覧できます',
                                            style: TextStyle(
                                                color: Color(0xffB4BABF),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ),
                                ),
                                index == 'public'
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xff4F5660), size: 21)
                                    : const SizedBox()
                              ])),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 'followers';
                          Future.delayed(const Duration(milliseconds: 300), () {
                            Navigator.pop(context, index);
                          });
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            UtilHelper.getPublishText(
                                                'followers'),
                                            style: const TextStyle(
                                                color: Color(0xff4F5660),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                        const Text('あなたのフォロワーのみこの投稿を閲覧できます',
                                            style: TextStyle(
                                                color: Color(0xffB4BABF),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ),
                                ),
                                index == 'followers'
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xff4F5660), size: 21)
                                    : const SizedBox()
                              ])),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 'private';
                          Future.delayed(const Duration(milliseconds: 300), () {
                            Navigator.pop(context, index);
                          });
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            UtilHelper.getPublishText(
                                                'private'),
                                            style: const TextStyle(
                                                color: Color(0xff4F5660),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                        const Text('この投稿は記録用で自分のみ閲覧できます',
                                            style: TextStyle(
                                                color: Color(0xffB4BABF),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ),
                                ),
                                index == 'private'
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xff4F5660), size: 21)
                                    : const SizedBox()
                              ])),
                    ),
                  ]),
            ))),
        onWillPop: () => Future.value(false));
  }
}
