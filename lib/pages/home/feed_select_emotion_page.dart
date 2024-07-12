import 'package:doceo_new/helper/util_helper.dart';
import 'package:flutter/material.dart';

class FeedSelectEmotionPage extends StatefulWidget {
  final String? emotion;
  const FeedSelectEmotionPage({Key? key, this.emotion}) : super(key: key);
  @override
  _FeedSelectEmotionPage createState() => _FeedSelectEmotionPage();
}

class _FeedSelectEmotionPage extends State<FeedSelectEmotionPage>
    with WidgetsBindingObserver {
  String index = '';
  @override
  void initState() {
    setState(() {
      index = widget.emotion ?? '';
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
              title: const Text('あなたの気分',
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
                          index = 'good';
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context, index);
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 25),
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
                                      child: Text('気分が良いです',
                                          style: TextStyle(
                                              color: Color(0xff4F5660),
                                              fontFamily: 'M_PLUS',
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal))),
                                ),
                                index == 'good'
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xff4F5660), size: 21)
                                    : const SizedBox()
                              ])),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 'neutral';
                          Future.delayed(const Duration(milliseconds: 300), () {
                            Navigator.pop(context, index);
                          });
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 25,
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
                                const Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text('普通です',
                                          style: TextStyle(
                                              color: Color(0xff4F5660),
                                              fontFamily: 'M_PLUS',
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal))),
                                ),
                                index == 'neutral'
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xff4F5660), size: 21)
                                    : const SizedBox()
                              ])),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 'bad';
                          Future.delayed(const Duration(milliseconds: 300), () {
                            Navigator.pop(context, index);
                          });
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 25,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text('気分が悪いです',
                                          style: TextStyle(
                                              color: Color(0xff4F5660),
                                              fontFamily: 'M_PLUS',
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal))),
                                ),
                                index == 'bad'
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xff4F5660), size: 21)
                                    : const SizedBox()
                              ])),
                    )
                  ]),
            ))),
        onWillPop: () => Future.value(false));
  }
}
