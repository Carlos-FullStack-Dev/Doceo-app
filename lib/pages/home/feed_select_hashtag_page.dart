import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/initialUserSetting/create_trouble_modal.dart';
import 'package:doceo_new/pages/initialUserSetting/select_trouble.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';

class FeedSelectHashtagPage extends StatefulWidget {
  final String tag;
  const FeedSelectHashtagPage({Key? key, required this.tag}) : super(key: key);
  @override
  _FeedSelectHashtagPage createState() => _FeedSelectHashtagPage();
}

class _FeedSelectHashtagPage extends State<FeedSelectHashtagPage>
    with WidgetsBindingObserver {
  List<UserTag?> tags = [];
  int selectedIndex = -1;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getUserTags();
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
              title: const Text('関連するタグを選択',
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
              actions: [
                IconButton(
                  onPressed: () async {
                    if (!loading) {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectTroublePage(
                                  fromPage: 'select-tag',
                                  tags: tags.sublist(0, tags.length - 1))));
                      if (result) {
                        getUserTags();
                      }
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            body: loading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                        itemCount: tags.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = tags[index];

                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  Navigator.pop(context,
                                      item != null ? item.tag!.id : 'unknown');
                                });
                              });
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF4F5660),
                                      width: 0.2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  item != null
                                                      ? item.tag!.name
                                                      : 'その他病名不明',
                                                  style: const TextStyle(
                                                      color: Color(0xff4F5660),
                                                      fontFamily: 'M_PLUS',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      index == selectedIndex
                                          ? const Icon(Icons.check_circle,
                                              color: Color(0xff4F5660),
                                              size: 21)
                                          : const SizedBox()
                                    ])),
                          );
                        }),
                  )),
        onWillPop: () => Future.value(false));
  }

  void addNewTag() async {
    final Tag? newTag = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext bc) {
        return CreateTroubleModal();
      },
    );

    // if (newTag != null) {
    //   setState(() {
    //     tags.add(newTag);
    //   });
    // }
  }

  void getUserTags() async {
    setState(() {
      loading = true;
    });
    try {
      final userId = AuthenticateProviderPage.of(context).user['sub'];
      final query = UserTag.USERID.eq(userId);
      final request = ModelQueries.list(UserTag.classType, where: query);
      final response = await Amplify.API.query(request: request).response;
      if (response.data != null) {
        final userTags = response.data!.items;

        setState(() {
          loading = false;
          tags = userTags.where((userTag) => userTag!.tag != null).toList();
          tags.add(null);
          selectedIndex = tags.indexWhere((tag) => tag != null
              ? tag.tag!.id == widget.tag
              : widget.tag == 'unknown');
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      safePrint(e);
      setState(() {
        loading = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
