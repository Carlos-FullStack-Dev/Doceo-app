import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShowChannelIcon extends StatelessWidget {
  final String channelType;
  //NOTE: Size means height and width of icons
  // final double size;

  ShowChannelIcon({
    required this.channelType,
    // required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (channelType == 'channel-3') {
      return SizedBox(
        height: 50,
        width: 50,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 2,
              child: Image.asset('assets/images/avatars/avatar_0.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
            Positioned(
              top: 0,
              left: 2,
              child: Image.asset('assets/images/avatars/avatar_1.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
            Positioned(
              top: 21,
              right: 2,
              child: Image.asset('assets/images/avatars/avatar_5.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
            Positioned(
              top: 21,
              left: 2,
              child: Image.asset('assets/images/avatars/avatar_4.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
          ],
        ),
      );
    } else if (channelType == 'channel-1') {
      return SizedBox(
        height: 60,
        width: 50,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 2,
              child: Image.asset('assets/images/avatars/dr_avatar_1.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
            Positioned(
              top: 0,
              left: 2,
              child: Image.asset('assets/images/avatars/dr_avatar_0.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
            Positioned(
                top: 27,
                left: 20,
                child: SvgPicture.asset('assets/images/down-arrow.svg',
                    height: 10, width: 10)),
            Positioned(
              bottom: 0,
              right: 2,
              child: Image.asset('assets/images/avatars/avatar_5.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
            Positioned(
              bottom: 0,
              left: 2,
              child: Image.asset('assets/images/avatars/avatar_4.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 60,
        width: 50,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 2,
              child: Image.asset('assets/images/avatars/dr_avatar_1.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
            Positioned(
              top: 0,
              left: 2,
              child: Image.asset('assets/images/avatars/dr_avatar_0.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
            Positioned(
                top: 27,
                right: 20,
                child: SvgPicture.asset('assets/images/close-icon.svg',
                    height: 10, width: 10)),
            Positioned(
              bottom: 0,
              right: 2,
              child: Image.asset('assets/images/avatars/avatar_5.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
            Positioned(
              bottom: 0,
              left: 2,
              child: Image.asset('assets/images/avatars/avatar_4.png',
                  fit: BoxFit.cover, height: 25, width: 25),
            ),
          ],
        ),
      );
    }
  }
}
