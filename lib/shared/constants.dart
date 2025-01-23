import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


const maroon = Color(0xFF9e0b0f);
const grayBackground = Color(0xF6F6F6);
const gray = Color(0XF545454);



const MAROON = Color(0xFF9e0b0f);
const GRAYBG = Color(0xF6F6F6);
const GRAY = Color(0XF545454);


class NoScheduleNotice extends StatelessWidget {
  const NoScheduleNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        children: [
          const SizedBox(height: 120),
          Image.asset('assets/red emoji.png', height: 210),
          const Text(
            "No events scheduled for this month ",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingDialog {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: MAROON,
            size: 60,
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog
  }
}

class PasswordGuide extends StatelessWidget {
  const PasswordGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric( horizontal: 25.0 ),
      child: Text.rich(
        TextSpan(
          text: 'For new users, ',
          children: <TextSpan>[
            TextSpan(
              text: 'your initial password ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: 'is your birthdate in this format ',
            ),
            TextSpan(
              text: 'YYYY-MM-DD.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}


class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});


  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Text.rich(
        TextSpan(
          text: 'By creating an account, you are agreeing to our ',
          children: <TextSpan>[
            TextSpan(
              text: 'Terms & Condition',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}