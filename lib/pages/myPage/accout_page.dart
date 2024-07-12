// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/myPage/edit_mail_address_page.dart';
import 'package:doceo_new/pages/myPage/edit_password_page.dart';
import 'package:doceo_new/pages/splash/sel_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPage createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    var userName =
        AuthenticateProviderPage.of(context, listen: true).user['name'] ??
            'UserName';
    var email =
        AuthenticateProviderPage.of(context, listen: false).user['email'] ?? '';
    var phoneNumber = AuthenticateProviderPage.of(context, listen: false)
            .user['phoneNumber'] ??
        '';
    final List identities =
        AuthenticateProviderPage.of(context, listen: true).user['identities'] !=
                null
            ? jsonDecode(AuthenticateProviderPage.of(context, listen: true)
                .user['identities'])
            : [];

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
            elevation: 0,
            leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text('アカウント',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: 10),
                alignment: Alignment.centerLeft,
                child: const Text('アカウント情報',
                    style: TextStyle(
                        fontFamily: 'M_PLUS',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Color(0xffB4BABF))),
              ),
              // myPageItem('ユーザー名', const EditUserNamePage(), userName, false),
              // myPageItem('会員情報', null, '一般', false),
              myPageItem('メールアドレス', const EditMailAddressPage(), email, false),
              // myPageItem(
              //     '電話番号', const EditPhoneNumberPage(), phoneNumber, false),
              myPageItem('パスワード', const EditPasswordPage(), '', false),
              myPageItem(
                  'ログインした方法',
                  null,
                  identities.isNotEmpty ? identities[0]['providerType'] : '',
                  false),
              const SizedBox(height: 34),
              myPageItem('アカウントを削除する', Container(), '', true),
            ],
          ),
        ));
  }

  Widget myPageItem(
      String text, Widget? page, String subText, bool isDeleteButton) {
    double width = MediaQuery.of(context).size.width;
    return TextButton(
        style: TextButton.styleFrom(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.white,
            padding: EdgeInsets.zero),
        onPressed: () {
          if (page != null) {
            isDeleteButton
                ? showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: const Text("ユーザーを削除しますか？"),
                      content: const Text("一度削除すると復元することはできません。"),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            deleteAccount();
                          },
                          child: const Text("OK"),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("キャンセル"),
                        ),
                      ],
                    ),
                  )
                : Navigator.push(
                    context, MaterialPageRoute(builder: (context) => page));
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.2, color: Color(0xff4F5660)))),
            child: Row(children: [
              Padding(
                padding: EdgeInsets.only(right: width * 0.04),
                child: Text(
                  text,
                  style: TextStyle(
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: isDeleteButton ? Colors.red : Colors.black),
                ),
              ),
              if (!isDeleteButton)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            subText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color(0xffB4BABF)),
                          ),
                        ),
                      ),
                      if (page != null)
                        const Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                    ],
                  ),
                )
            ]),
          ),
        ));
  }

  void deleteAccount() async {
    try {
      await Amplify.Auth.deleteUser();
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastSuccess("削除に成功しました。", context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SelPage()),
        (route) => false,
      );
    } catch (err) {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToast(message: "削除に失敗しました。もう一度お試しください。");
    }
  }
}
