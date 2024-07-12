import 'package:doceo_new/helper/util_helper.dart';
import 'package:flutter/material.dart';

class FeedSelectReasonPage extends StatefulWidget {
  final String? reason;
  const FeedSelectReasonPage({Key? key, this.reason}) : super(key: key);
  @override
  _FeedSelectReasonPage createState() => _FeedSelectReasonPage();
}

class _FeedSelectReasonPage extends State<FeedSelectReasonPage>
    with WidgetsBindingObserver {
  String index = '';
  @override
  void initState() {
    setState(() {
      index = widget.reason ?? '';
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
              title: const Text('訪問の目的を選択',
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
                          index = 'follow-up';
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context, index);
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
                                            UtilHelper.getReasonText(
                                                'follow-up'),
                                            style: const TextStyle(
                                                color: Color(0xff4F5660),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                        const Text('経過観察で担当の医師へ訪問します',
                                            style: TextStyle(
                                                color: Color(0xffB4BABF),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ),
                                ),
                                index == 'follow-up'
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xff4F5660), size: 21)
                                    : const SizedBox()
                              ])),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 'report-symptom';
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
                                            UtilHelper.getReasonText(
                                                'report-symptom'),
                                            style: const TextStyle(
                                                color: Color(0xff4F5660),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                        const Text('症状を医師に診てもらるために訪問します',
                                            style: TextStyle(
                                                color: Color(0xffB4BABF),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ),
                                ),
                                index == 'report-symptom'
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xff4F5660), size: 21)
                                    : const SizedBox()
                              ])),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 'regular-checkup';
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
                                            UtilHelper.getReasonText(
                                                'regular-checkup'),
                                            style: const TextStyle(
                                                color: Color(0xff4F5660),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                        const Text('年次で予定している健康診断のために訪問します',
                                            style: TextStyle(
                                                color: Color(0xffB4BABF),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ),
                                ),
                                index == 'regular-checkup'
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xff4F5660), size: 21)
                                    : const SizedBox()
                              ])),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 'other';
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context, index);
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
                                        Text(UtilHelper.getReasonText('other'),
                                            style: const TextStyle(
                                                color: Color(0xff4F5660),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                        const Text('治療法の見直し、セカンドオピニオンなど',
                                            style: TextStyle(
                                                color: Color(0xffB4BABF),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                  ),
                                ),
                                index == 'other'
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
