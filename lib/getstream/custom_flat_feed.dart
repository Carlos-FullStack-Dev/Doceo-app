import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/extension.dart';
import 'package:doceo_new/getstream/custom_feed_card.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stream_feed/stream_feed.dart';

class CustomFlatFeed extends StatefulWidget {
  BuildContext context;
  String type;
  String id;
  Widget noItem;
  bool showUser;
  String? verbFilter;
  bool scrollable;
  CustomFlatFeed(
      {super.key,
      required this.context,
      required this.id,
      required this.type,
      this.verbFilter,
      this.showUser = true,
      this.scrollable = true,
      required this.noItem});
  @override
  _CustomFlatFeed createState() => _CustomFlatFeed();
}

class _CustomFlatFeed extends State<CustomFlatFeed> {
  final PagingController<int, GenericEnrichedActivity> _pagingController =
      PagingController(firstPageKey: 0);
  late FlatFeed feed;
  final _pageSize = 5;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final feedClient = context.feedClient;
      feed = feedClient.flatFeed(widget.type, widget.id);
      final newItems = await feed.getEnrichedActivities(
          offset: pageKey,
          limit: _pageSize,
          flags: EnrichmentFlags().withReactionCounts().withOwnReactions());
      List<GenericEnrichedActivity> filteredItems = newItems;
      if (widget.verbFilter != null) {
        filteredItems =
            newItems.where((item) => item.verb == widget.verbFilter).toList();
      }

      if (newItems.length < _pageSize) {
        _pagingController.appendLastPage(filteredItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(filteredItems, nextPageKey);
      }
    } catch (error) {
      safePrint(error);
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: PagedListView<int, GenericEnrichedActivity>(
          pagingController: _pagingController,
          padding: EdgeInsets.zero,
          physics:
              widget.scrollable ? null : const NeverScrollableScrollPhysics(),
          shrinkWrap: widget.scrollable ? false : true,
          builderDelegate: PagedChildBuilderDelegate<GenericEnrichedActivity>(
              itemBuilder: (context, item, index) {
                return CustomFeedCard(
                    key: GlobalKey(),
                    activity: item,
                    showUser: widget.showUser,
                    context: context);
              },
              // newPageErrorIndicatorBuilder: (_) => Container(),
              // firstPageErrorIndicatorBuilder: (_) => Container(),
              noItemsFoundIndicatorBuilder: (_) => widget.noItem),
        ),
        onRefresh: () async {
          _pagingController.refresh();
        });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
