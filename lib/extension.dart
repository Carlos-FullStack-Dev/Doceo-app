import 'package:doceo_new/services/feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

//ignore: public_member_api_docs
extension ProviderX on BuildContext {
  //ignore: public_member_api_docs
  StreamFeedClient get feedClient => FeedProvider.of(this).client;
}
