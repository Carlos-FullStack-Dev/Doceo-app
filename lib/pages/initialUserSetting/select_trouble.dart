import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/pages/initialUserSetting/create_trouble_modal.dart';
import 'package:doceo_new/pages/myPage/my_page_screen.dart';
import 'package:doceo_new/pages/transitionToHome/transition.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;
import 'package:stream_feed/src/core/models/follow_relation.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Models;

class SelectTroublePage extends StatefulWidget {
  String? fromPage;
  List<UserTag?>? tags;
  SelectTroublePage({super.key, this.fromPage, this.tags});

  @override
  State<SelectTroublePage> createState() => _SelectTroublePage();
}

class _SelectTroublePage extends State<SelectTroublePage>
    with SingleTickerProviderStateMixin {
  bool _btnStatus = false;
  bool _isFilled = false;
  late TabController _tabController;
  List selectedTroubles = [];
  final newTrouble = TextEditingController();
  String? errorMessage;
  bool isNewTroubleFilled = false;
  List tags = [];
  bool loading = false;
  List<Models.Category?> categories = [];

  @override
  void initState() {
    setState(() {
      List selectedTags = widget.tags ?? [];
      tags = AppProviderPage.of(context, listen: false).tags.map((tag) {
        return {
          'id': tag.id,
          'name': tag.name,
          'category': tag.category?.id,
          'usersCount': tag.users != null ? tag.users!.length : 0,
          'feedsCount': tag.feedsCount ?? 0,
          'isSelected':
              selectedTags.indexWhere((elem) => elem.tag.id == tag.id) > -1
        };
      }).toList();
    });
    getInitialData();

    super.initState();
  }

  void getInitialData() async {
    setState(() {
      loading = true;
    });

    try {
      final request = ModelQueries.list(Models.Category.classType,
          authorizationMode: APIAuthorizationType.apiKey);
      final response = await Amplify.API.query(request: request).response;
      final res = response.data?.items;

      if (res != null) {
        setState(() {
          _tabController = TabController(length: 1 + res.length, vsync: this);
          loading = false;
          res.sort((a, b) => ((a!.order ?? 0) - (b!.order ?? 0)));
          categories = res;
        });
      }
    } catch (e) {
      safePrint('Categories: ${e}');
    }
  }

  List getCategpryTags(categoryId) {
    return tags.where((tag) => tag['category'] == categoryId).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> selectedTroubleItems = tags
        .where((trouble) => (trouble?['isSelected'] ?? false) as bool)
        .toList()
        .map<Widget>((trouble) => troubleItem(trouble))
        .toList();
    List userTags = [...tags];
    userTags.sort((a, b) => a['usersCount'].compareTo(b['usersCount']));
    userTags = userTags.length > 10 ? userTags.sublist(0, 10) : userTags;

    selectedTroubleItems.add(
      OutlinedButton(
          onPressed: () {
            _showMyModal();
          },
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              backgroundColor: const Color(0xffF2F2F2),
              shape: selectedTroubleItems.isEmpty
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.0))
                  : const CircleBorder()),
          child: selectedTroubleItems.isEmpty
              ? RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'M_PLUS',
                      fontStyle: FontStyle.normal,
                      color: Color(0xff4F5660),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '+',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: ' 悩み・疾病タグを作る',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              : const Text('＋',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontStyle: FontStyle.normal,
                    color: Color(0xff4F5660),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))),
    );

    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: const Text('悩み・疾病タグ',
                  style: TextStyle(
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontStyle: FontStyle.normal,
                      color: Colors.black)),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              )),
          body: loading
              ? const LoadingAnimation()
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      alignment: Alignment.topLeft,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.26,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xff636363),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(17.0),
                                      ),
                                      child: Scrollbar(
                                        child: ListView(
                                          children: [
                                            Wrap(
                                                spacing: 8.0,
                                                runSpacing: 4.0,
                                                children: selectedTroubleItems),
                                          ],
                                        ),
                                      )),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 10, left: 10),
                                    child: TabBar(
                                      isScrollable: true,
                                      controller: _tabController,
                                      indicatorColor: Colors.black,
                                      labelColor: Colors.black,
                                      unselectedLabelColor: Colors.black,
                                      enableFeedback: false,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      labelPadding: const EdgeInsets.only(
                                          right: 10, left: 10, bottom: 5),
                                      indicator: const UnderlineTabIndicator(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.0)),
                                          borderSide: BorderSide(width: 3.0)),
                                      labelStyle: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >=
                                                  390
                                              ? 20
                                              : 18,
                                          fontWeight: FontWeight.bold),
                                      unselectedLabelStyle: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      tabs: [
                                        const Text('ピックアップ'),
                                        for (int i = 0;
                                            i < categories.length;
                                            i++)
                                          Text(categories[i]!.name.toString())
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    height: MediaQuery.of(context).size.height *
                                        0.45,
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        Scrollbar(
                                          child: ListView(
                                            children: [
                                              Wrap(
                                                  spacing: 8.0,
                                                  runSpacing: 4.0,
                                                  children: tags
                                                      .map<Widget>((trouble) =>
                                                          troubleItem(trouble))
                                                      .toList()),
                                            ],
                                          ),
                                        ),
                                        for (Models.Category? cat in categories)
                                          Scrollbar(
                                            child: ListView(
                                              children: [
                                                Wrap(
                                                    spacing: 8.0,
                                                    runSpacing: 4.0,
                                                    children: getCategpryTags(
                                                            cat!.id)
                                                        .map<Widget>(
                                                            (trouble) =>
                                                                troubleItem(
                                                                    trouble))
                                                        .toList()),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.77),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!_btnStatus && _isFilled) {
                                    goToFeedList();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Ink(
                                  decoration: _isFilled
                                      ? BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xffB44DD9),
                                                Color(0xff70A4F2)
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(10))
                                      : BoxDecoration(
                                          color: const Color(0xffF2F2F2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: _btnStatus
                                        ? const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                            strokeWidth: 1)
                                        : Text(
                                            '完了',
                                            style: TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontWeight: FontWeight.bold,
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
                        )
                      ],
                    ),
                  ),
                ),
        ),
        onWillPop: () => Future.value(false));
  }

  Widget troubleItem(trouble) {
    bool isSelected = trouble?['isSelected'];

    return OutlinedButton(
      onPressed: () {
        setState(() {
          trouble['isSelected'] = !isSelected;
          _isFilled = tags.any((trouble) => trouble?['isSelected'] as bool);
        });
      },
      style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          backgroundColor: isSelected ? const Color(0xff63CEF0) : Colors.white,
          side: BorderSide(
              color: isSelected ? Colors.transparent : const Color(0xff4F5660)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17.0))),
      child: Text(trouble['name'],
          style: TextStyle(
              fontFamily: 'M_PLUS',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: isSelected ? Colors.white : const Color(0xff4F5660))),
    );
  }

  Future<void> _showMyModal() async {
    final Tag? newTag = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext bc) {
        return const CreateTroubleModal();
      },
    );

    if (newTag != null) {
      setState(() {
        tags.add({
          'id': newTag.id,
          'name': newTag.name,
          'usersCount': newTag.users != null ? newTag.users!.length : 0,
          'feedsCount': newTag.feedsCount ?? 0,
          'isSelected': false
        });
      });
    }
  }

  void goToFeedList() async {
    try {
      setState(() {
        _btnStatus = true;
      });
      final feedClient = context.feedClient;
      final currentUser = StreamChat.of(context).currentUser!;
      final userId =
          AuthenticateProviderPage.of(context, listen: false).user['sub'];
      final originTags = widget.tags ?? [];
      List selectedTags = tags.where((tag) {
        return (tag?['isSelected'] as bool) &&
            originTags.indexWhere((element) => element!.tag!.id == tag['id']) <
                0;
      }).map((e) {
        return {'userId': userId, 'tagId': e!['id']};
      }).toList();
      final removedTags = originTags
          .where((tag) {
            return tags.indexWhere((element) =>
                    (element['isSelected'] && element['id'] == tag!.tag!.id)) <
                0;
          })
          .map((e) => e!.id)
          .toList();

      String graphQLDocument =
          '''mutation batchCreateUserTag(\$tags: [BatchCreateUserTag], \$deleteIds: [ID!], \$newTagsExist: Boolean!, \$deleteTagsExist: Boolean!) {
          batchCreateUserTag(tags: \$tags) @include(if: \$newTagsExist){
            id
            tag {
              name
            }
          }
          batchDeleteUserTag(deleteIds: \$deleteIds) @include(if: \$deleteTagsExist) {
            id
          }
        }
        ''';
      var operation = Amplify.API.mutate(
          request:
              GraphQLRequest<String>(document: graphQLDocument, variables: {
        'tags': selectedTags,
        'deleteIds': removedTags,
        'newTagsExist': selectedTags.isNotEmpty,
        'deleteTagsExist': removedTags.isNotEmpty
      }));
      var response = await operation.response;

      if (response.errors.isNotEmpty) {
        safePrint(response.errors);
        setState(() {
          _btnStatus = false;
        });
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "エラーです。もう一度お試しください。");
        return;
      }

      if (selectedTags.isNotEmpty) {
        final follows = selectedTags
            .map((e) => FollowRelation(
                source: 'related:$userId', target: 'tag:${e['tagId']}'))
            .toList();
        await feedClient.batch.followMany(follows);
      }

      if (removedTags.isNotEmpty) {
        final related = feedClient.flatFeed('related', userId);
        final unfollows = originTags.where((tag) {
          return tags.indexWhere((element) =>
                  (element['isSelected'] && element['id'] == tag!.tag!.id)) <
              0;
        }).toList();
        for (final unfollow in unfollows) {
          final tag = feedClient.flatFeed('tag', unfollow!.tag!.id);
          await related.unfollow(tag);
        }
      }

      if (widget.fromPage != null) {
        setState(() {
          _btnStatus = false;
        });
        if (widget.fromPage != 'select-tag') {
          HomePage.index = TabItem.myPage;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          Navigator.pop(context, true);
        }
      } else {
        await feedClient.user(userId).getOrCreate({
          'name': currentUser.name,
          'avatar': currentUser.image,
          'gender': currentUser.extraData['sex'],
          'birthday': currentUser.extraData['birthday']
        });
        setState(() {
          _btnStatus = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TransitionPage()));
      }
    } catch (e) {
      safePrint(e);
      setState(() {
        _btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
