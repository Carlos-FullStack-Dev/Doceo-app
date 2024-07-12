import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/getstream/custom_date_divider.dart';
import 'package:doceo_new/getstream/custom_message.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Model;
import 'package:doceo_new/pages/channels/settings/channel_setting_page.dart';
import 'package:doceo_new/pages/myPage/point_charge_modal.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Type2Channel1Page extends StatefulWidget {
  Type2Channel1Page({super.key});
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _Type2Channel1Page createState() => _Type2Channel1Page();
}

class _Type2Channel1Page extends State<Type2Channel1Page> {
  String searchKey = '';
  late String searchId = '';
  late List doctorList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formatter = NumberFormat.compact();

  @override
  void initState() {
    searchKey = '';
    doctorList = AppProviderPage.of(context, listen: false).doctors;
    searchId = doctorList.isNotEmpty ? doctorList[0]['user_id'] : '';

    searchDoctors();
    super.initState();
  }

  void searchDoctors() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                final channel = StreamChannel.of(context).channel;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StreamChannel(
                            channel: channel,
                            child: const ChannelSettingPage())));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Center(
                  child: Text(
                    '…',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/main-channel-title.svg',
                ),
                const SizedBox(width: 12),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.3),
                    child: Text('${StreamChannel.of(context).channel.name}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'M_PLUS',
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 6),
                const Text(
                  '( ',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SvgPicture.asset(
                  'assets/images/user-icon.svg',
                  fit: BoxFit.contain,
                ),
                const Text(' ⇄ ',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'M_PLUS',
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                SvgPicture.asset('assets/images/doctor-icon.svg'),
                const Text(' )',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'M_PLUS',
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 5)
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                // child: Text('**************'),
                child: StreamMessageListView(
                    showFloatingDateDivider: false,
                    dateDividerBuilder: (date) {
                      return CustomDateDivider(dateTime: date);
                    },
                    scrollPhysics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    emptyBuilder: _emptyBuilder,
                    messageBuilder: _messageBuilder),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        color: const Color(0xffF8F8F8),
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.04,
                            left: 5,
                            top: 5,
                            bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: TextButton(
                                  style: OutlinedButton.styleFrom(
                                      surfaceTintColor: Colors.transparent),
                                  onPressed: () {
                                    showCoinCharge(context);
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      StreamChat.of(context)
                                              .currentUser!
                                              .image!
                                              .startsWith('assets')
                                          ? CircleAvatar(
                                              radius: 20,
                                              backgroundImage: AssetImage(
                                                  StreamChat.of(context)
                                                      .currentUser!
                                                      .image
                                                      .toString()),
                                              backgroundColor:
                                                  Colors.transparent,
                                            )
                                          : CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                  StreamChat.of(context)
                                                      .currentUser!
                                                      .image
                                                      .toString()),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 30),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                              alignment: Alignment.center,
                                              color: const Color.fromRGBO(
                                                  87, 86, 86, 0.5),
                                              height: 11,
                                              width: 55,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/coin-icon.svg',
                                                    width: 10,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Expanded(
                                                      child:
                                                          BetterStreamBuilder(
                                                              stream: StreamChat
                                                                      .of(
                                                                          context)
                                                                  .currentUserStream,
                                                              builder: (context,
                                                                  data) {
                                                                return Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    data.extraData['point'] !=
                                                                            null
                                                                        ? formatter
                                                                            .format(data.extraData['point'])
                                                                        : '0',
                                                                    maxLines: 1,
                                                                    style: const TextStyle(
                                                                        height:
                                                                            1.1,
                                                                        fontFamily:
                                                                            'M_PLUS',
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                );
                                                              })),
                                                  InkWell(
                                                    child: Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                            Icons.arrow_forward,
                                                            size: 9,
                                                            color: Color(
                                                                0xff777777)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                              flex: 8,
                              child: Container(
                                padding: const EdgeInsets.only(right: 12),
                                alignment: Alignment.centerRight,
                                child: const Text('医師への質問',
                                    style: TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 15,
                                        color: Color(0xff777777),
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 40,
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/coin-icon.svg',
                                          height: 24,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text('500',
                                            style: TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                color: Color(0xff777777),
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )),
                            )
                          ],
                        )),
                  )
                ],
              ),
              StreamMessageInput(
                showCommandsButton: false,
                attachmentLimit: 1,
                // attachmentsPickerBuilder:
                //     (context, messageInputController, defaultPicker) {
                //   return defaultPicker.copyWith(allowedAttachmentTypes: [
                //     DefaultAttachmentTypes.image,
                //     DefaultAttachmentTypes.video
                //   ]);
                // },
                preMessageSending: (message) async {
                  final result = await requestCoinModal(context);
                  if (result != true) {
                    return Future.error(Exception('issue'));
                  }

                  return Future.value(message);
                },
                // sendButtonBuilder: (context, messageInputController) {
                //   return Container(
                //     child: InkWell(
                //       onTap: () async {
                //         requestCoinModal(context, messageInputController);
                //       },
                //       child: const Padding(
                //         padding: EdgeInsets.all(8),
                //         child: Center(
                //           child: Icon(
                //             Icons.send,
                //             color: Colors.black,
                //           ),
                //         ),
                //       ),
                //     ),
                //   );
                // },
              ),
            ],
          ),
        ));
  }
  // Widget doctorListFun() {
  //   return(
  //     ,
  //   );
  // }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (now.difference(date).inDays > 0) {
      return '${now.difference(date).inDays}日前';
    } else if (now.difference(date).inHours > 0) {
      return '${now.difference(date).inHours}時間前';
    } else if (now.difference(date).inMinutes > 0) {
      return '${now.difference(date).inMinutes}分前';
    } else {
      return '${now.difference(date).inSeconds}秒前';
    }
  }

  Widget _emptyBuilder(BuildContext context) {
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
              child: const Text('ここでは医師への聞きたいことを投稿することが可能です',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffcbcbcb),
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.w500)))
        ]));
  }

  Future<bool?> requestCoinModal(BuildContext context) async {
    final client = StreamChat.of(context).client;
    final currentUser = StreamChat.of(context).currentUser;
    int point = currentUser!.extraData['point'] != null
        ? currentUser.extraData['point'] as int
        : 0;
    if (point < 500) {
      return Future.value(false);
    }
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
            insetPadding: EdgeInsets.only(
                right: width * 0.06,
                left: width * 0.06,
                top: height * 0.16,
                bottom: height * 0.18),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(''),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset(
                            'assets/images/requestCoin.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Text(''),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: SvgPicture.asset(
                          'assets/images/coin-icon.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        '500',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: AppColors.subText3),
                      ),
                    ],
                  ),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025, vertical: 5),
                        child: Text(
                          '※1週間以内に返答がなければ、ポイントは変換されます。',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontSize: 12,
                              color: AppColors.subText3),
                        ),
                      ),
                    ),
                  ]),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025, vertical: 5),
                        child: Text(
                          '※投稿内容は公開されるので、個人が特定されるようなことがないよう入力内容には十分ご注意ください。',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontSize: 12,
                              color: AppColors.subText3),
                        ),
                      ),
                    ),
                  ]),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025, vertical: 5),
                        child: Text(
                          '※医師の回答は医学的助言の範囲であり、投稿者の個別的な状態を踏まえた診断は行っていません。急を要するお悩みや診断を求める場合は必ずお近くのクリニックを受診するようお願い致します。',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontSize: 12,
                              color: AppColors.subText3),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.5),
                          color: AppColors.cancelButtonBackground,
                          child: Text(
                            'キャンセル',
                            style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 20,
                                color: AppColors.subText3),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            // Point Reduction
                            point -= 500;
                            currentUser.extraData['point'] = point;
                            await client.updateUser(currentUser);

                            Navigator.pop(context, true);

                            final pointHistory = Model.PointHistory(
                              type: 'post',
                              text: '医師に質問を投稿しました',
                              userId: currentUser.id,
                              point: -500,
                            );
                            final request = ModelMutations.create(pointHistory);
                            try {
                              final response = await Amplify.API
                                  .mutate(request: request)
                                  .response;
                              if (response.errors.isNotEmpty) {
                                print(response.errors);
                              }
                            } catch (e) {
                              safePrint(e);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.5),
                            color: AppColors.sendButtonBackground,
                            child: Text(
                              '送信',
                              style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 20,
                                color: AppColors.mainText3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void showCoinCharge(BuildContext context) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isDismissible: false,
        isScrollControlled: true,
        builder: ((context) {
          return const PointChargeModal();
        }));
  }

  Widget _messageBuilder(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
    StreamMessageWidget defaultMessageWidget,
  ) {
    return CustomMessage(
        key: GlobalKey(),
        context: context,
        details: details,
        messages: messages,
        defaultMessageWidget: defaultMessageWidget);
  }
}
