import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';

//  TILE DAY SECHDUE
class DaySchedule extends StatelessWidget {
  final String day;
  final String date;
  final String title;
  final String subtitle;

  const DaySchedule({
    required this.day,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4.0),
          width: 47,
          child: Column(
            children: [
              Text(
                day,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(width: 46),

        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xff808080),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),

        ),
      ],
    );
  }
}

// TODAY TILE DAY SECHDUE
class TodayDaySchedule extends StatelessWidget {
  final String day;
  final String date;
  final String title;
  final String subtitle;

  TodayDaySchedule({
    required this.day,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(3.5),
          width: 47,
          decoration: BoxDecoration(
            color: maroon,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                day,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,  color: Colors.white),
              ),
            ],
          ),
        ),

        const SizedBox(width: 46),
        
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: maroon,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}