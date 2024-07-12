import 'package:doceo_new/pages/home/add_feed_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddFeedDialog extends StatelessWidget {
  final String? selectedRoom;
  const AddFeedDialog({super.key, this.selectedRoom});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.1,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.42,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddFeedPage(
                                  postType: 'tweet',
                                  selectedRoom: selectedRoom,
                                )),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/tweet-icon.svg',
                          fit: BoxFit.contain,
                        ),
                        const Text('つぶやく',
                            style: TextStyle(
                                color: Color(0xff4F5660),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const Text('今日の体調',
                            style: TextStyle(
                                color: Color(0xffB4BABF),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.42,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddFeedPage(
                                  postType: 'diary',
                                  selectedRoom: selectedRoom,
                                )),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/diary-icon.svg',
                          fit: BoxFit.contain,
                        ),
                        const Text('診察レポート',
                            style: TextStyle(
                                color: Color(0xff4F5660),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const Text('診察を記録しよう',
                            style: TextStyle(
                                color: Color(0xffB4BABF),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
