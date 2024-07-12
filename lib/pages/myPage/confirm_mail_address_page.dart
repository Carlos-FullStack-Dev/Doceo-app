// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/myPage/accout_page.dart';
import 'package:doceo_new/pages/myPage/input_text.dart';
import 'package:doceo_new/pages/myPage/my_page_screen.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ConfirmMailAddressPage extends StatefulWidget {
  final String? email;
  final String? phoneNumber;
  const ConfirmMailAddressPage({super.key, this.email, this.phoneNumber});

  @override
  _ConfirmMailAddressPage createState() => _ConfirmMailAddressPage();
}

class _ConfirmMailAddressPage extends State<ConfirmMailAddressPage> {
  final TextEditingController _textEditingController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  void completeConfirmation() async {
    final confirmationNumber = _textEditingController.text;
    try {
      if (widget.email != null) {
        await Amplify.Auth.confirmUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.email,
          confirmationCode: confirmationNumber,
        );
        AuthenticateProviderPage.of(context, listen: false).user['email'] =
            widget.email;
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastSuccess("メールアドレスが変更されました。", context);
      } else if (widget.phoneNumber != null) {
        await Amplify.Auth.confirmUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.phoneNumber,
          confirmationCode: confirmationNumber,
        );
        AuthenticateProviderPage.of(context, listen: false)
            .user['phoneNumber'] = widget.phoneNumber;
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastSuccess("電話番号が変更されました。", context);
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AccountPage()));
    } catch (err) {
      print(err);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToast(message: "エラーです。認証番号を再度入力してください。");
    }
  }

  void resendConfirmation() async {
    try {
      final result = await Amplify.Auth.resendUserAttributeConfirmationCode(
        userAttributeKey: widget.email != null
            ? CognitoUserAttributeKey.email
            : CognitoUserAttributeKey.phoneNumber,
      );
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastSuccess('認証番号を再送しました', context);
    } catch (err) {
      print(err);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToast(message: "エラーが発生しました。\n少し時間をおいてお試しください。");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
          elevation: 0,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
                onPressed: () {
                  resendConfirmation();
                },
                child: const Text('再送する',
                    style: TextStyle(
                        fontFamily: 'M_PLUS',
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff1997F6))))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Text(widget.email != null ? '認証番号を入力してください' : '確認コードを入力してください',
                  style: const TextStyle(
                      fontFamily: 'M_PLUS',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Text(
                  widget.email != null
                      ? '${widget.email}に送信しました'
                      : '${widget.phoneNumber}に送信しました',
                  style: const TextStyle(
                      fontFamily: 'M_PLUS',
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Color(0xffB4BABF))),
              InputText(
                  title: '', textEditingController: _textEditingController),
              const SizedBox(height: 45),
              FractionallySizedBox(
                widthFactor: 1.0,
                child: OutlinedButton(
                    onPressed: () {
                      completeConfirmation();
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xff7369E4)),
                    child: const Text('完了',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              )
            ],
          ),
        ));
  }
}
