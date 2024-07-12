import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  const FullScreenImageViewer(this.url, {Key? key}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, _) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          )),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
