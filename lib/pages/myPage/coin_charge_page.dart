// ignore_for_file: avoid_print

import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/pages/myPage/point_history_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CoinChargePage extends StatefulWidget {
  const CoinChargePage({super.key});

  @override
  _CoinChargePage createState() => _CoinChargePage();
}

class _CoinChargePage extends State<CoinChargePage> {
  final Uri _terms = Uri.parse('https://doceo.jp/terms/');
  final Uri _privacy = Uri.parse('https://doceo.jp/privacy/');
  final Uri _coinHelp = Uri.parse(
      'https://wivil.notion.site/D-COIN-408066773e434ee8be054c03ee5c1b98?pvs=4');
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;
  final formatter = NumberFormat.compact();
  List<ProductDetails> _products = [];
  bool isLoading = false;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    initStoreInfo();
    // isLoading = false;
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = _openTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _openPrivacy;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _openTerms() async {
    if (!await launchUrl(_terms, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $_terms');
    }
  }

  void _openPrivacy() async {
    if (!await launchUrl(
      _privacy,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $_privacy');
    }
  }

  void _openHelp() async {
    if (!await launchUrl(
      _coinHelp,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $_coinHelp');
    }
  }

  // Initialize Store Info and get products
  Future<void> initStoreInfo() async {
    final isAvailable = await InAppPurchase.instance.isAvailable();
    if (!isAvailable) {
      setState(() {});
      return;
    }
    final productIds = <String>[
      'doceo.point.charge.small',
      'doceo.point.charge.midium',
      'doceo.point.charge.big',
    ];

    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(productIds.toSet());

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Product not found: ${response.notFoundIDs}');
    }

    if (response.error != null) {
      debugPrint('Error: ${response.error}');
      return;
    }

    setState(() {
      _products = response.productDetails.reversed.toList();
    });

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print('DONE');
      _subscription.cancel();
    }, onError: (Object error) {
      print(error);
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      final _product =
          _products.where((e) => e.id == purchaseDetails.productID);
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          isLoading = true;
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print('Error? ${purchaseDetails}');
          setState(() {
            isLoading = false;
          });
          AuthenticateProviderPage.of(context, listen: false)
              .notifyToastDanger(message: "購入に失敗しました。少し時間をおいた後もう一度お試しください。");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          await _addPurchaseData(_product.first);
          setState(() {
            isLoading = false;
          });
          // Navigator.pop(context);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _addPurchaseData(product) async {
    try {
      final client = StreamChat.of(context).client;
      final currentUser = StreamChat.of(context).currentUser;
      final purchasedPoint = int.parse(product.title.split(' ')[1]);
      int point = (currentUser!.extraData['point'] != null
              ? currentUser.extraData['point'] as int
              : 0) +
          purchasedPoint;
      currentUser.extraData['point'] = point;
      await client.updateUser(currentUser);
      final pointHistory = PointHistory(
          type: 'purchase',
          text: 'ポイントを購入しました',
          userId: currentUser.id,
          point: purchasedPoint);
      final request = ModelMutations.create(pointHistory);
      await Amplify.API.mutate(request: request).response;
    } catch (err) {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。少し時間をおいた後もう一度お試しください。");
    }
  }

  Future<void> _buyProduct(ProductDetails product) async {
    setState(() {
      isLoading = true;
    });
    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      bool isSuccess = await InAppPurchase.instance
          .buyConsumable(purchaseParam: purchaseParam);
      setState(() {
        isLoading = false;
      });
      if (!isSuccess) {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "エラーです。少し時間をおいた後もう一度お試しください。");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。少し時間をおいた後もう一度お試しください。");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Stack(children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/coin-charge-header.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const Expanded(
                              child: Center(
                            child: Text('D-COIN',
                                style: TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )),
                          IconButton(
                            onPressed: () {
                              _openHelp();
                            },
                            icon: const Icon(
                              Icons.help_outline_rounded,
                              color: Colors.white,
                            ),
                            color: Colors.black,
                            iconSize: 30,
                          ),
                        ]),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            '保有D-COIN数：',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(children: [
                            SvgPicture.asset('assets/images/coin-icon.svg',
                                fit: BoxFit.cover, height: 40, width: 40),
                            const SizedBox(width: 5),
                            Text(
                              StreamChat.of(context)
                                          .currentUser!
                                          .extraData['point'] !=
                                      null
                                  ? formatter.format(StreamChat.of(context)
                                      .currentUser!
                                      .extraData['point'])
                                  : '0',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PointHistoryPage()));
                                },
                                child: Row(
                                  children: const [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'チャージ・使用履歴',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: 'M_PLUS',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        )
                      ]),
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        right: 15, left: 15, top: 15, bottom: 10),
                    child: const Text(
                      'チャージする',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'M_PLUS',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _products.isEmpty
                        ? const LoadingAnimation()
                        : Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: _products.length,
                                itemBuilder: (context, index) {
                                  return _pointCard(_products[index]);
                                }),
                          ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: RichText(
                text: TextSpan(
                  text: '利用規約',
                  recognizer: _termsRecognizer,
                  style: const TextStyle(
                      fontFamily: 'M_PLUS',
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff1997F6)),
                  children: <TextSpan>[
                    const TextSpan(
                      text: ' | ',
                      style: TextStyle(
                          fontFamily: 'M_PLUS',
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1997F6)),
                    ),
                    TextSpan(
                      text: 'プライバシーポリシー',
                      recognizer: _privacyRecognizer,
                      style: const TextStyle(
                          fontFamily: 'M_PLUS',
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff1997F6)),
                    ),
                  ],
                ),
              ),
            ),
          ]),
          if (isLoading)
            Container(
              // This container will take all available space
              color: const Color.fromRGBO(0, 0, 0,
                  0.5), // This line adds a semi-transparent black overlay
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _pointCard(ProductDetails item) {
    final _title = item.title.split(' ')[1];

    return InkWell(
        onTap: () {
          _buyProduct(item);
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
            ),
            child: Row(children: [
              SvgPicture.asset('assets/images/coin-icon.svg',
                  fit: BoxFit.cover, height: 40, width: 40),
              Text(
                '× $_title',
                style: TextStyle(
                  color: const Color(0xFF4F5660).withOpacity(0.7),
                  fontSize: 17,
                  fontFamily: 'M_PLUS',
                  fontWeight: FontWeight.w800,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item.price,
                    style: const TextStyle(
                      color: Color(0xFFFCC14C),
                      fontSize: 20,
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ])));
  }
}
