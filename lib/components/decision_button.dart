import 'package:flutter/material.dart';

class DecisionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool btnStatus;
  final bool isActive;

  DecisionButton(
      {required this.onPressed,
      required this.buttonText,
      required this.isActive,
      required this.btnStatus});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (isActive) {
          onPressed();
        }
      },
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Ink(
        decoration: isActive
            ? BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xffB44DD9), Color(0xff70A4F2)]),
                borderRadius: BorderRadius.circular(30),
              )
            : BoxDecoration(
                color: Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(30),
              ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 40,
          alignment: Alignment.center,
          child: btnStatus
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 1)
              : Text(
                  buttonText,
                  style: TextStyle(
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontStyle: FontStyle.normal,
                      color: isActive ? Colors.white : Color(0xffB4BABF)),
                ),
        ),
      ),
    );
  }
}
