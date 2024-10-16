import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:myeuc_x_supabase/features/aichat/chatui.dart';
import 'package:myeuc_x_supabase/features/calendar/events.dart';
import 'package:myeuc_x_supabase/home/home.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  int index = 0;

  final screens = [
    const Home(),

    const Center(
      child: Text(
        '',
        style: TextStyle(fontSize: 80),
      )
    ),
    
    const MyEucEvents(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: screens[index],
        bottomNavigationBar: StyleProvider(
          style: Style(),
          child: ConvexAppBar(
            height: 45,
            style: TabStyle.fixed,
            color: Colors.black,
            curveSize: 60,
            top: -12,
            activeColor: maroon,
            initialActiveIndex: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatUI()),
                );
              } else {
                setState(() => this.index = index);
              }
            },
            items: [
              TabItem(
                  icon: Image.asset('assets/home.png'),
                  activeIcon: Image.asset('assets/home2.png'),
                  title: 'Home'
                ),

              TabItem(
                icon: Image.asset('assets/icon/iconmanuel.png'),
                title: 'Manuel AI',
              ),

              TabItem(
                icon: Image.asset(
                  'assets/calendar.png',
                ),
                activeIcon: Image.asset('assets/calendar2.png'),
                title: 'Calendar',
                
              ),

            ],
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 33;

  @override
  double get activeIconMargin => 13;

  @override
  double get iconSize => 19;

  @override
  TextStyle textStyle(Color color, String? s) {
    return TextStyle(fontSize: 12, color: color);
  }
}
