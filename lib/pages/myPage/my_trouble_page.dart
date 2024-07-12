// ignore_for_file: avoid_print

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/initialUserSetting/select_trouble.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';

class MyTroublePage extends StatefulWidget {
  bool isEditable;
  String userId;
  MyTroublePage({super.key, required this.isEditable, required this.userId});

  @override
  _MyTroublePage createState() => _MyTroublePage();
}

class _MyTroublePage extends State<MyTroublePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isEditable = widget.isEditable;
    return Scaffold(
        backgroundColor: Colors.white,
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
            centerTitle: true,
            title: const Text('悩み・疾病タグ',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: FutureBuilder(
            future: getUserTags(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Stack(children: [
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.88,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Scrollbar(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: snapshot.data!.map<Widget>((tag) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 7),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.50, color: Color(0xFF4F5660)),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              tag!.tag!.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF4F5660),
                                fontSize: 15,
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                if (isEditable)
                  Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: 45,
                      child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectTroublePage(
                                          fromPage: 'my_trouble',
                                          tags: snapshot.data!,
                                        )));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF4F5660),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: const Text(
                              '悩み・疾病タグを編集する',
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
                      ))
              ]);
            }));
  }

  Future<List<UserTag?>> getUserTags(userId) async {
    try {
      final query = UserTag.USERID.eq(userId);
      final request = ModelQueries.list(UserTag.classType, where: query);
      final response = await Amplify.API.query(request: request).response;
      if (response.data != null) {
        final userTags = response.data!.items;

        return userTags.where((userTag) => userTag!.tag != null).toList();
      }
      return [];
    } catch (e) {
      safePrint(e);
      return [];
    }
  }
}
