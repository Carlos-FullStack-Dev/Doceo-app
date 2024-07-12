import 'package:doceo_new/getstream/custom_message_actions.dart';
import 'package:doceo_new/getstream/custom_reaction_icon.dart';
import 'package:doceo_new/pages/channels/users/doctor_page.dart';
import 'package:doceo_new/pages/channels/users/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UtilHelper {
  UtilHelper._();

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final format = DateFormat('yyyy/MM/dd');

    if (now.difference(date).inDays > 6) {
      return format.format(date);
    } else if (now.difference(date).inDays > 0) {
      return '${now.difference(date).inDays}日前';
    } else if (now.difference(date).inHours > 0) {
      return '${now.difference(date).inHours}時間前';
    } else if (now.difference(date).inMinutes > 0) {
      return '${now.difference(date).inMinutes}分前';
    } else {
      return '${now.difference(date).inSeconds}秒前';
    }
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static Widget userAvatar(User user, double radius, BuildContext context) {
    if (user.role == 'admin') {
      return CircleAvatar(
          backgroundImage: const AssetImage('assets/images/splash_1.png'),
          backgroundColor: Colors.transparent,
          radius: radius);
    }

    Widget avatar;

    if (user.image != null) {
      if (user.image!.startsWith('assets')) {
        avatar = CircleAvatar(
            backgroundImage: AssetImage(user.image!),
            backgroundColor: Colors.transparent,
            radius: radius);
      } else {
        avatar = CircleAvatar(
            backgroundImage: NetworkImage(user.image!),
            backgroundColor: Colors.transparent,
            radius: radius);
      }
    } else {
      avatar = CircleAvatar(
          backgroundImage:
              const AssetImage('assets/images/avatars/default.png'),
          backgroundColor: Colors.transparent,
          radius: radius);
    }
    return InkWell(
        onTap: () {
          if (user.role == 'user') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserPage(userId: user.id)));
          } else if (user.role == 'doctor') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DoctorPage(doctorId: user.id)));
          }
        },
        child: avatar);
  }

  static Widget feedAvatar(String? avatar, double radius) {
    if (avatar != null) {
      if (avatar.startsWith('assets')) {
        return CircleAvatar(
            backgroundImage: AssetImage(avatar),
            backgroundColor: Colors.transparent,
            radius: radius);
      }
      return CircleAvatar(
          backgroundImage: NetworkImage(avatar),
          backgroundColor: Colors.transparent,
          radius: radius);
    }

    return CircleAvatar(
        backgroundImage: const AssetImage('assets/images/avatars/default.png'),
        backgroundColor: Colors.transparent,
        radius: radius);
  }

  static String getDisplayName(User user, String channelType) {
    if (user.role == 'admin') {
      return '運営';
    } else if (user.role == 'doctor') {
      return '${user.extraData['lastName'].toString()}医師';
    }
    // else if (channelType == 'channel-2') {
    //   final dateFormatter = DateFormat.yMd('en');
    //   // user.extraData['birthday'] = "04/07/1994";

    //   if (user.extraData['birthday'] != null) {
    //     DateTime birthDate =
    //         dateFormatter.parse(user.extraData['birthday'].toString());
    //     int age = calculateAge(birthDate);

    //     return '${(age / 10).floor() * 10}代';
    //   }

    //   return '年代不明';
    // }

    return user.name;
  }

  static Widget buildReactionsList(BuildContext context, Message message) {
    final reactions = message.latestReactions ?? [];
    Map<String, int> results = {};

    for (final reaction in reactions) {
      int current = results[reaction.type] ?? 0;
      results[reaction.type] = current + reaction.score;
    }

    if (reactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final type in results.keys)
            CustomReactionIcon(
                reactionType: type,
                reactionScore: results[type],
                message: message,
                size: MediaQuery.of(context).size.width * 0.06),
        ],
      ),
    );
  }

  static void showMessageReactionsModalBottomSheet(
      BuildContext context, Message message, List<double> pos) {
    final channel = StreamChannel.of(context).channel;
    showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.2),
      builder: (context) => StreamChannel(
        channel: channel,
        child: CustomMessageActionsModal(
            message: message,
            showReactions: true,
            showReplyMessage: false,
            showThreadReplyMessage: false,
            showResendMessage: false,
            showEditMessage: false,
            showCopyMessage: false,
            showFlagButton: false,
            showPinButton: false,
            showWatchButton: false,
            showDeleteMessage: false,
            pos: pos),
      ),
    );
  }

  static String convertNumberWithPrefix(int? num) {
    final formatter = NumberFormat.compact();
    return formatter.format(num);
  }

  static void showMyCupertinoModalBottomSheet(BuildContext context,
      String topText, String bottomText, onPressTop, onPressBottom) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(topText,
                style: TextStyle(
                    color: Color(0xffFF4848),
                    fontFamily: 'M_PLUS',
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(bottomText,
                style: TextStyle(
                    color: Color(0xff1997F6),
                    fontFamily: 'M_PLUS',
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('キャンセル',
              style: TextStyle(
                  color: Color(0xff1997F6),
                  fontFamily: 'M_PLUS',
                  fontSize: 18,
                  fontWeight: FontWeight.normal)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  static String getPublishText(String publishScope) {
    switch (publishScope) {
      case 'followers':
        return 'フォロワーのみ';
      case 'private':
        return '自分のみ';
      case 'public':
      default:
        return '全体公開';
    }
  }

  static String getReasonText(String reason) {
    switch (reason) {
      case 'follow-up':
        return '経過観察';
      case 'report-symptom':
        return '症状の報告';
      case 'regular-checkup':
        return '定期健診';
      default:
        return 'その他';
    }
  }

  static String getEmotionText(String emotion) {
    switch (emotion) {
      case 'good':
        return '気分が良いです';
      case 'neutral':
        return '普通です';
      case 'bad':
        return '気分が悪いです';
      default:
        return '';
    }
  }
}
