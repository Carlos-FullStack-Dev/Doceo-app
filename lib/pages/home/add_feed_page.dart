import 'dart:io';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/home/feed_publication_scope_page.dart';
import 'package:doceo_new/pages/home/feed_select_doctor.dart';
import 'package:doceo_new/pages/home/feed_select_emotion_page.dart';
import 'package:doceo_new/pages/home/feed_select_hashtag_page.dart';
import 'package:doceo_new/pages/home/feed_select_hospital.dart';
import 'package:doceo_new/pages/home/feed_select_reason_page.dart';
import 'package:doceo_new/pages/home/feed_select_room_page.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;
import 'package:path/path.dart' as p;
import 'package:logger/logger.dart' as Logger;

class AddFeedPage extends StatefulWidget {
  final String? postType;
  final String? selectedRoom;
  const AddFeedPage({Key? key, this.postType, this.selectedRoom})
      : super(key: key);
  @override
  _AddFeedPage createState() => _AddFeedPage();
}

class _AddFeedPage extends State<AddFeedPage> with WidgetsBindingObserver {
  final textController = TextEditingController(text: '');
  bool _isFilled = false;
  bool _btnStatus = false;
  String _filePath = '';
  String _fileType = 'file';
  String roomId = '';
  String usertag = '';
  String publishScope = 'public';
  String hospital = '';
  String doctorName = '';
  String doctorIcon = '';
  String doctorId = '';
  String reason = '';
  String emotion = '';
  int joinedRooms = 0;

  @override
  void initState() {
    super.initState();
    _isFilled = false;
    _btnStatus = false;
    textController.addListener(() {
      setState(() {
        _isFilled = textController.text.isNotEmpty;
      });
    });
    setState(() {
      final draft = widget.postType == 'tweet'
          ? AppProviderPage.of(context).tweetDraft
          : AppProviderPage.of(context).diaryDraft;

      _filePath = draft != null && draft['filePath'] != null
          ? draft['filePath'].toString()
          : '';
      _fileType = draft != null && draft['fileType'] != null
          ? draft['fileType'].toString()
          : '';
      textController.text = draft != null && draft['text'] != null
          ? draft['text'].toString()
          : '';
      usertag =
          draft != null && draft['usertag'] != null ? draft['usertag'] : '';
      roomId = widget.selectedRoom != null
          ? widget.selectedRoom!
          : draft != null && draft['roomId'] != null
              ? draft['roomId'].toString()
              : '';
      publishScope = draft != null && draft['publishScope'] != null
          ? draft['publishScope'].toString()
          : 'public';
      hospital = draft != null && draft['hospital'] != null
          ? draft['hospital'].toString()
          : '';
      doctorName = draft != null && draft['doctorName'] != null
          ? draft['doctorName'].toString()
          : '';
      doctorIcon = draft != null && draft['doctorIcon'] != null
          ? draft['doctorIcon'].toString()
          : '';
      doctorId = draft != null && draft['doctorId'] != null
          ? draft['doctorId'].toString()
          : '';
      reason = draft != null && draft['reason'] != null
          ? draft['reason'].toString()
          : '';
      emotion = draft != null && draft['emotion'] != null
          ? draft['emotion'].toString()
          : '';

      // How many joined rooms
      final roomsSigned = AppProviderPage.of(context).roomSigned;
      joinedRooms = roomsSigned
          .where((roomSigned) => roomSigned['status'] == true)
          .toList()
          .length;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final postType = widget.postType;
    Map? room;
    Tag? selectedTag;

    try {
      room = AppProviderPage.of(context)
          .rooms
          .firstWhere((myRoom) => myRoom['channel']['id'] == roomId);
    } catch (e) {
      room = null;
    }

    try {
      selectedTag = AppProviderPage.of(context)
          .tags
          .firstWhere((tag) => tag.id == usertag);
    } catch (e) {
      selectedTag = null;
    }

    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(postType == 'tweet' ? 'つぶやく' : '診察レポート',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
              leading: IconButton(
                onPressed: () {
                  if (_filePath.isNotEmpty ||
                      roomId.isNotEmpty ||
                      usertag.isNotEmpty ||
                      publishScope != 'public' ||
                      roomId.isNotEmpty) {
                    _showCancelTweetDialog(context);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                    child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                getFile();
                              },
                              child: Container(
                                height: width * 0.3,
                                width: width * 0.3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                child: _filePath.isNotEmpty
                                    ? (_fileType == 'image'
                                        ? Image.file(File(
                                            _filePath.getResizedImageUrl(
                                                width: width * 0.3,
                                                height: height * 0.3)))
                                        : const Text(
                                            "ファイルがロードされました!",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8,
                                            ),
                                          ))
                                    : SvgPicture.asset(
                                        'assets/images/add-icon.svg',
                                        fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                                height: height * 0.22,
                                child: TextField(
                                  autofocus: false,
                                  style: const TextStyle(
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                  maxLines: null,
                                  controller: textController,
                                  decoration: InputDecoration(
                                      hintText: postType == 'tweet'
                                          ? '自分の今の気持ちを投稿してみよう'
                                          : '診察を記録して、皆んなに共有しよう',
                                      hintStyle: const TextStyle(
                                          fontFamily: 'M_PLUS',
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xffB4BABF)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      )),
                                )),
                            if (postType == 'tweet')
                              InkWell(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  final newEmotion = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FeedSelectEmotionPage(
                                                  emotion: emotion)));
                                  if (newEmotion != null) {
                                    setState(() {
                                      emotion = newEmotion;
                                    });
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0xFF4F5660),
                                          width: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 6),
                                          SvgPicture.asset(
                                              'assets/images/sel_emo.svg',
                                              fit: BoxFit.cover),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                  emotion.isNotEmpty
                                                      ? UtilHelper
                                                          .getEmotionText(
                                                              emotion)
                                                      : '今の気分を選択してください',
                                                  style: const TextStyle(
                                                      color: Color(0xff4F5660),
                                                      fontFamily: 'M_PLUS',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                          ),
                                          const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 15)
                                        ])),
                              ),
                            if (postType == 'diary')
                              InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  selectHospital();
                                },
                                child: Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 147),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 7),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF2F2F2),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Wrap(children: [
                                    SvgPicture.asset(
                                        'assets/images/hospital-gray.svg',
                                        fit: BoxFit.cover),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(hospital.isEmpty ? '訪問先' : hospital,
                                        style: const TextStyle(
                                            color: Color(0xffb4babf),
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal))
                                  ]),
                                ),
                              ),
                            if (postType == 'diary')
                              InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  selectDoctor();
                                },
                                child: Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 147),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 7),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF2F2F2),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        doctorIcon.isNotEmpty
                                            ? CircleAvatar(
                                                radius: 9.5,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage:
                                                    NetworkImage(doctorIcon),
                                              )
                                            : SvgPicture.asset(
                                                'assets/images/select-doctor.svg',
                                                fit: BoxFit.cover),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            doctorName.isNotEmpty
                                                ? doctorName
                                                : '担当医師',
                                            style: const TextStyle(
                                                color: Color(0xffb4babf),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal))
                                      ]),
                                ),
                              ),
                            if (postType == 'diary')
                              InkWell(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  final newReason = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FeedSelectReasonPage(
                                                  reason: reason)));
                                  if (newReason != null) {
                                    setState(() {
                                      reason = newReason;
                                    });
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0xFF4F5660),
                                          width: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 6),
                                          SvgPicture.asset(
                                              'assets/images/write-doc.svg',
                                              fit: BoxFit.cover),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                  reason.isNotEmpty
                                                      ? UtilHelper
                                                          .getReasonText(reason)
                                                      : '訪問の目的を選択してください',
                                                  style: const TextStyle(
                                                      color: Color(0xff4F5660),
                                                      fontFamily: 'M_PLUS',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                          ),
                                          const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 15)
                                        ])),
                              ),
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                final newTag = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FeedSelectHashtagPage(
                                                tag: usertag)));
                                if (newTag != null) {
                                  setState(() {
                                    usertag = newTag;
                                  });
                                }
                              },
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Color(0xFF4F5660),
                                        width: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 6),
                                        SvgPicture.asset(
                                            'assets/images/tag.svg',
                                            fit: BoxFit.cover),
                                        const SizedBox(width: 3),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                                selectedTag != null
                                                    ? selectedTag.name
                                                    : usertag == 'unknown'
                                                        ? 'その他病名不明'
                                                        : '関連するタグを選択してください',
                                                style: const TextStyle(
                                                    color: Color(0xff4F5660),
                                                    fontFamily: 'M_PLUS',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                        ),
                                        const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15)
                                      ])),
                            ),
                            if (joinedRooms > 0)
                              InkWell(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  final newRoom = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FeedSelectRoomPage(
                                                  roomId: roomId)));
                                  if (newRoom != Null) {
                                    setState(() {
                                      roomId = newRoom;
                                    });
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0xFF4F5660),
                                          width: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          room == null ||
                                                  room['channel']['image'] ==
                                                      null
                                              ? SvgPicture.asset(
                                                  'assets/images/room-icon.svg',
                                                  fit: BoxFit.cover)
                                              : Image.network(
                                                  room['channel']['image']
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                  width: 29,
                                                  height: 29),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                  room == null ||
                                                          room['channel']
                                                                  ['name'] ==
                                                              null
                                                      ? '投稿するROOMを選択してください'
                                                      : room['channel']['name']
                                                          .toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff4F5660),
                                                      fontFamily: 'M_PLUS',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                          ),
                                          const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 15)
                                        ])),
                              ),
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                final newScope = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FeedPublicationScopePage(
                                                scope: publishScope)));
                                if (newScope != Null) {
                                  setState(() {
                                    publishScope = newScope;
                                  });
                                }
                              },
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Color(0xFF4F5660),
                                        width: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/publication-scope-icon.svg',
                                            fit: BoxFit.cover),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                                UtilHelper.getPublishText(
                                                    publishScope),
                                                style: const TextStyle(
                                                    color: Color(0xffD79833),
                                                    fontFamily: 'M_PLUS',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                        ),
                                        const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15)
                                      ])),
                            ),
                          ]),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.77),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isFilled) {
                            postFeed();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Ink(
                          decoration: _isFilled
                              ? BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xffB44DD9),
                                    Color(0xff70A4F2)
                                  ]),
                                  borderRadius: BorderRadius.circular(10))
                              : BoxDecoration(
                                  color: const Color(0xffF2F2F2),
                                  borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 40,
                            alignment: Alignment.center,
                            child: _btnStatus
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 1)
                                : Text(
                                    '投稿',
                                    style: TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal,
                                        color: _isFilled
                                            ? Colors.white
                                            : const Color(0xffB4BABF)),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )))),
        onWillPop: () => Future.value(false));
  }

  void selectHospital() async {
    final newHospital = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext bc) {
        return FeedSelectHospitalModal(
          hospital: hospital,
        );
      },
    );

    if (newHospital != null && newHospital.isNotEmpty) {
      setState(() {
        hospital = newHospital;
      });
    }
  }

  void selectDoctor() async {
    final newDoctor = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext bc) {
        return FeedSelectDoctorModal(
          doctorName: doctorName,
        );
      },
    );

    if (newDoctor != null) {
      setState(() {
        doctorName = newDoctor['name'];
        doctorIcon = newDoctor['icon'];
        doctorId = newDoctor['id'];
      });
    }
  }

  void postFeed() async {
    final feedClient = context.feedClient;
    final userId =
        AuthenticateProviderPage.of(context, listen: false).user['sub'];
    final currentUser = feedClient.user(userId).ref;
    setState(() {
      _btnStatus = true;
    });

    String? fileUrl = '';
    if (_filePath.isNotEmpty) {
      try {
        if (_fileType == 'image' && _filePath.isNotEmpty) {
          fileUrl = await feedClient.images
              .upload(StreamFeed.AttachmentFile(path: _filePath));
        } else {
          fileUrl = await feedClient.files
              .upload(StreamFeed.AttachmentFile(path: _filePath));
        }
      } catch (e) {
        setState(() {
          _btnStatus = false;
        });
        Logger.Logger().e(e);
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "添付ファイルのアップロードに失敗しました。");
        return;
      }
    }

    List<StreamFeed.FeedId> targets = [];
    if (publishScope == 'public') {
      targets = [StreamFeed.FeedId.id('user:all')];
      // Tags
      if (usertag.isNotEmpty && usertag != 'unknown') {
        targets.add(StreamFeed.FeedId.id('tag:$usertag'));
      }
      // Room
      if (roomId.isNotEmpty) {
        targets.add(StreamFeed.FeedId.id('room:$roomId'));
      }
      // Doctor
      if (doctorId.isNotEmpty) {
        targets.add(StreamFeed.FeedId.id('doctor:$doctorId'));
      }
    }

    StreamFeed.FlatFeed feed = feedClient.flatFeed(
        publishScope == 'private' ? 'private' : 'user', userId);
    Map<String, Object> extraData;
    if (widget.postType == 'tweet') {
      extraData = {
        'message': textController.text,
        'filePath': fileUrl.toString(),
        'fileType': _fileType,
        'emotion': emotion,
        'usertag': usertag,
        'room': roomId,
        'publish': publishScope
      };
    } else {
      extraData = {
        'message': textController.text,
        'filePath': fileUrl.toString(),
        'fileType': _fileType,
        'hospital': hospital,
        'doctorIcon': doctorIcon,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'reason': reason,
        'usertag': usertag,
        'room': roomId,
        'publish': publishScope
      };
    }
    final activity = StreamFeed.Activity(
        actor: currentUser,
        extraData: extraData,
        foreignId:
            '$userId:${widget.postType}:${DateTime.now().millisecondsSinceEpoch}',
        time: DateTime.now(),
        verb: widget.postType,
        object: '${widget.postType}:id',
        to: targets);

    try {
      await feed.addActivity(activity);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastSuccess("成功しました。新しいフィードが投稿されました。", context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      Logger.Logger().e(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラー。フィードの種類を選択してください。");
    }
    setState(() {
      _btnStatus = false;
    });
  }

  void getFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;

      String extensionVal = file.extension.toString();
      switch (extensionVal) {
        case 'png':
        case 'jpg':
        case 'jpeg':
        case 'PNG':
        case 'JPG':
        case 'JPEG':
          _fileType = 'image';
          break;
        case 'avi':
        case 'AVI':
        case 'mp4':
        case 'MP4':
        case 'WMV':
        case 'wmv':
        case 'MOV':
        case 'mov':
          _fileType = 'video';
          break;
        default:
          _fileType = 'file';
      }
      setState(() {
        _filePath = file.path!;
      });
    } else {
      // User canceled the picker
    }
  }

  void _showCancelTweetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Adjust as needed
            height:
                MediaQuery.of(context).size.height * 0.2, // Adjust as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const SizedBox(height: 5),
                const Text(
                  "編集内容を保存しますか？",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4F5660)),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: const Color(0xffF2F2F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.5),
                          ),
                        ),
                        onPressed: () {
                          discardDraft();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text("破棄",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4F5660))),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: const Color(0xFF69E4BF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.5),
                          ),
                        ),
                        onPressed: () {
                          saveDraft();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text("保存する",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void discardDraft() {
    if (widget.postType == 'tweet') {
      AppProviderPage.of(context).tweetDraft = {};
    } else {
      AppProviderPage.of(context).diaryDraft = {};
    }
  }

  void saveDraft() {
    if (widget.postType == 'tweet') {
      AppProviderPage.of(context).tweetDraft = {
        'filePath': _filePath,
        'fileType': _fileType,
        'text': textController.text,
        'usertag': usertag,
        'emotion': emotion,
        'roomId': roomId,
        'publishScope': publishScope
      };
    } else {
      AppProviderPage.of(context).diaryDraft = {
        'filePath': _filePath,
        'fileType': _fileType,
        'text': textController.text,
        'usertag': usertag,
        'roomId': roomId,
        'publishScope': publishScope,
        'hospital': hospital,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'doctorIcon': doctorIcon,
        'reason': reason
      };
    }
  }
}
