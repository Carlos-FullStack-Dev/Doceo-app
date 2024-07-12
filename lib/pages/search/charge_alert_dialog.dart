import 'package:doceo_new/pages/myPage/coin_charge_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChargeAlertDialog extends StatelessWidget {
  const ChargeAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 60,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.35,
                padding: const EdgeInsets.only(
                    bottom: 20, top: 30, right: 20, left: 20),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'このグループチャットではポイントを利用して医師へ質問が行えます。参加するためには1ポイント以上のポイントを保有している必要があります。ポイントを購入しますか？',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4F5660),
                        fontSize: 17,
                        fontFamily: 'M_PLUS',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 45,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF2F2F2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.50),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'キャンセル',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF4F5660),
                                fontSize: 17,
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CoinChargePage()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 45,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFCC14C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.50),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '購入画面へ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: SizedBox(
                width: 120,
                height: 120,
                child: SvgPicture.asset('assets/images/coin-icon.svg',
                    fit: BoxFit.contain, height: 120, width: 120),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
