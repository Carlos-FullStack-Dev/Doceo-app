import 'dart:async';
import 'dart:ui';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Models;
import 'package:doceo_new/pages/auth/profile_page.dart';
import 'package:doceo_new/pages/home/main_screen.dart';
import 'package:doceo_new/pages/splash/sel_page.dart';
import 'package:doceo_new/pages/transitionToHome/transition.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;

class SplashPageA extends StatefulWidget {
  @override
  _SplashPageA createState() => _SplashPageA();
}

class _SplashPageA extends State<SplashPageA> {
  String error = '';
  bool status = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 4), () async {
      try {
        // Get tags
        try {
          final request = ModelQueries.list(Models.Tag.classType,
              authorizationMode: APIAuthorizationType.apiKey);
          final response = await Amplify.API.query(request: request).response;
          final tags = response.data?.items;

          AppProviderPage.of(context, listen: false).tags = tags;

          if (tags == null) {
            safePrint('errors: ${response.errors}');
          }
        } catch (e) {
          safePrint('Tags: ${e}');
        }

        // Get Hospitals
        try {
          final request = ModelQueries.list(Models.Hospital.classType,
              authorizationMode: APIAuthorizationType.apiKey);
          final response = await Amplify.API.query(request: request).response;
          final hospitals = response.data?.items;

          AppProviderPage.of(context, listen: false).hospitals = hospitals;

          if (hospitals == null) {
            safePrint('errors: ${response.errors}');
          }
        } catch (e) {
          safePrint('Hospitals: ${e}');
        }

        final userData = await Amplify.Auth.fetchUserAttributes();
        Map userInfo = {};
        for (final element in userData) {
          userInfo.addAll({"${element.userAttributeKey.key}": element.value});
        }
        AuthenticateProviderPage.of(context, listen: false).isAuthenticated =
            true;
        AuthenticateProviderPage.of(context, listen: false).user = userInfo;

        String userId = userInfo['sub'];
        String graphQLDocument = '''query createUserToken {
                CreateUserToken(id: "$userId"){
                  token
                  rooms{
                    channel{
                      id
                      name
                      description
                      image
                      feedsCount
                      doctorFeedsCount
                      questions
                      tags
                      owner
                      disabled
                    }
                    members{
                      role
                      user_id
                      user{
                        role
                        image
                        firstName
                        lastName
                      }
                    }
                  }
                }
              }''';

        var operation = Amplify.API
            .query(request: GraphQLRequest<String>(document: graphQLDocument));

        var response = await operation.response;

        var res = json.decode(response.data.toString());
        if (res['CreateUserToken']['token'].toString().isNotEmpty) {
          AuthenticateProviderPage.of(context, listen: false).getStreamToken =
              res['CreateUserToken']['token'].toString();
          List publicRooms = res['CreateUserToken']['rooms']
              .where((room) => room['channel']['disabled'] == false)
              .toList();
          AppProviderPage.of(context, listen: false).rooms = publicRooms;
          int userNum = 0;
          List roomSigned = [];
          // String roomNumber = '';

          for (var item in publicRooms) {
            userNum =
                item['members'].where((e) => e['user_id'] == userId).length;
            if (userNum > 0) {
              // roomNumber =
              //     (roomNumber == '' ? item['channel']['id'] : roomNumber);
              roomSigned.add({'status': true});
            } else {
              roomSigned.add({'status': false});
            }
            userNum = 0;
          }
          AppProviderPage.of(context, listen: false).roomSigned = roomSigned;

          final client = StreamChat.of(context).client;
          await client.disconnectUser();
          final currentUser = await client.connectUser(
            User(id: userId),
            AuthenticateProviderPage.of(context, listen: false).getStreamToken,
          );
          if (MainScreen.targetChannel.isNotEmpty) {
            final channel = await client.queryChannel(
                MainScreen.targetChannelType,
                channelId: MainScreen.targetChannel);

            AppProviderPage.of(context).selectedRoom =
                channel.channel!.extraData['room'].toString();
          }
          AuthenticateProviderPage.of(context).joined = currentUser.createdAt;

          if (currentUser.name.isEmpty) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          } else {
            // Feed
            final feedClient = context.feedClient;
            final userData = {
              'name': currentUser.name,
              'avatar': currentUser.image,
              'gender': currentUser.extraData['sex'],
              'birthday': currentUser.extraData['birthday'],
              'role': 'user'
            };

            try {
              await feedClient.updateUser(userId, userData);
            } catch (e) {
              await feedClient.user(userId).getOrCreate(userData);
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TransitionPage()));
          }
        }
      } catch (e) {
        safePrint('Error: ${e}');
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => SelPage(),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => SelPage()));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: const Scaffold(
          body: Center(
              child: Image(
            image: AssetImage('assets/images/splash.gif'),
            fit: BoxFit.cover,
          )),
        ),
        onWillPop: () => Future.value(false));
  }
}
