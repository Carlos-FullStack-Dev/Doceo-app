import 'dart:async';
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_push_notifications_pinpoint/amplify_push_notifications_pinpoint.dart';
import 'package:doceo_new/amplifyconfiguration.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Models;
import 'package:doceo_new/pages/auth/signin_page.dart';
import 'package:doceo_new/pages/home/feed_screen.dart';
import 'package:doceo_new/pages/home/main_screen.dart';
import 'package:doceo_new/pages/myPage/my_page_screen.dart';
import 'package:doceo_new/pages/notification/notification_screen.dart';
import 'package:doceo_new/pages/search/search_screen.dart';
import 'package:doceo_new/pages/splash/splash_a.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/services/feed_provider.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter/material.dart' as Material;
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:stream_feed/stream_feed.dart' as StreamFeed;

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  MyApp({
    Key? key,
    required this.client,
    required this.feedClient,
  }) : super(key: key);
  final StreamChatClient client;
  final StreamFeed.StreamFeedClient feedClient;
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final StreamChatConfigurationData streamChatConfigData =
      StreamChatConfigurationData(reactionIcons: [
    StreamReactionIcon(
      type: 'okay',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/images/emo_1.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
    StreamReactionIcon(
      type: 'sad',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/images/emo_2.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
    StreamReactionIcon(
      type: 'think',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          child: SvgPicture.asset(
            'assets/images/emo_3.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
    StreamReactionIcon(
      type: 'good',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/images/emo_4.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
    StreamReactionIcon(
      type: 'thanks',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/images/emo_5.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
  ]);

  @override
  void initState() {
    super.initState();
    AppStyles.loadSelectedIndex();
  }

  @override
  void dispose() {
    // _authProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<AppService>(create: (_) => appService),
        ChangeNotifierProvider(
          create: (_) => AuthenticateProviderPage(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppProviderPage(),
        ),

        // Provider<AuthService>(create: (_) => authService),
      ],
      child: Builder(
        builder: (context) {
          // final _authProvider = AuthenticateProviderPage();
          // final _router = routerGenerator(_authProvider);

          return MaterialApp(
              supportedLocales: const [
                Locale('en'),
                Locale('hi'),
                Locale('fr'),
                Locale('it'),
                Locale('es'),
                Locale('ca'),
                Locale('ja'),
                Locale('ko'),
                Locale('pt'),
                Locale('de'),
                Locale('no')
              ],
              localizationsDelegates: GlobalStreamChatLocalizations.delegates,
              navigatorKey: MyApp.navigatorKey,
              builder: (context, child) {
                return StreamChat(
                  client: widget.client,
                  // streamChatThemeData: widget.streamChatThemeData,
                  streamChatConfigData: streamChatConfigData,
                  child: FeedProvider(
                      client: widget.feedClient,
                      child: AmplifyApp(child: child!)),
                );
              },
              routes: <String, WidgetBuilder>{
                '/HomeScreen': (BuildContext context) => const FeedScreen(),
                '/RoomScreen': (BuildContext context) => const SearchScreen(),
                '/NotificationScreen': (BuildContext context) =>
                    const NotificationScreen(),
                '/MypageScreen': (BuildContext context) => const MyPageScreen(),
                // Define other routes
              },
              home: SplashPageA());
          // SignInPage());
          // MyPageScreen());
        },
      ),
    );
  }
}

class AmplifyApp extends StatefulWidget {
  final Widget child;
  AmplifyApp({required this.child});
  @override
  _AmplifyApp createState() => _AmplifyApp();
}

class _AmplifyApp extends State<AmplifyApp> {
  void authEventListener(AuthHubEvent event) async {
    // print('AuthEvent: ${event.eventName} ${event.payload}');
    switch (event.type) {
      case AuthHubEventType.signedIn:
        try {
          final userData = await Amplify.Auth.fetchUserAttributes();
          Map userInfo = {};
          for (final element in userData) {
            userInfo.addAll(
                {element.userAttributeKey.key.toString(): element.value});
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
          var operation = Amplify.API.query(
              request: GraphQLRequest<String>(document: graphQLDocument));
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

            for (var item in publicRooms) {
              userNum =
                  item['members'].where((e) => e['user_id'] == userId).length;
              if (userNum > 0) {
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
              AuthenticateProviderPage.of(context, listen: false)
                  .getStreamToken,
            );

            AuthenticateProviderPage.of(context).joined = currentUser.createdAt;

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
          }
        } catch (e) {
          safePrint('Sigin Error: $e');
        }
        break;
      case AuthHubEventType.signedOut:
        await StreamChat.of(context).client.disconnectUser();
        break;
      case AuthHubEventType.sessionExpired:
        break;
      case AuthHubEventType.userDeleted:
        break;
    }
  }

  Future<void> configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito(
          secureStorageFactory: AmplifySecureStorage.factoryFrom());
      final api = AmplifyAPI(modelProvider: Models.ModelProvider.instance);
      final push = AmplifyPushNotificationsPinpoint();
      // await Amplify.addPlugin(auth);
      // await Amplify.addPlugin(analyticsPlugin);
      Amplify.Hub.listen(HubChannel.Auth, authEventListener);

      await Amplify.addPlugins([auth, api, push]);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
      // Amplify.Notifications.Push.onTokenReceived.listen((event) {
      //   print('Amplify token: ${event}');
      // });
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
