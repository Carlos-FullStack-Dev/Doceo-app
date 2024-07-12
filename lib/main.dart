import 'package:doceo_new/helper/awesome_notifications_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart';

import './app.dart';
import 'helper/fcm_helper.dart';
import 'helper/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  // print('Handling a background message ${message.messageId}');
}

const streamKey = "a6rmt92za3p7";
const streamSecret =
    "jx9tp9jcc3f4b6j8732zynqf7byu4tfbjjah266hskgz7h8vnwngfrpzcg2mddwg";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inti fcm services
  // await Firebase.initializeApp();
  // await FcmHelper.initFcm();

  // initialize local notifications service
  await AwesomeNotificationsHelper.init();

  // final chatPersistentClient = StreamChatPersistenceClient(
  //     logLevel: Level.INFO, connectionMode: ConnectionMode.background);

  final client = StreamChatClient(
    streamKey,
    logLevel: Level.INFO,
  );
  final feedClient = StreamFeedClient(streamKey,
      secret: streamSecret, appId: '1233962', runner: Runner.server);

  runApp(MyApp(client: client, feedClient: feedClient));
}
