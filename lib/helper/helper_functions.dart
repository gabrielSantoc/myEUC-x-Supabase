import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/main.dart';

//display error
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
    ),
  );
}

void scrollDown(ScrollController scrollController, Duration delay ) async {
  await Future.delayed(delay);
  scrollController.animateTo(
    scrollController.position.maxScrollExtent,
    duration: delay,
    curve: Curves.easeInOut,
  );
}

void updateAnalytics(String uid) async {
    final today = DateTime.now().toUtc().toString().split(' ')[0]; //YYYY-MM-DD format

    // Check if there's already a record for the current day
    final existingRecord = await supabase
        .from('tbl_analytics')
        .select()
        .eq('uid', uid)
        .eq('last_opened', today)
        .maybeSingle();

    if (existingRecord == null) {
      // If no record exists for today, insert a new one
      await supabase.from('tbl_analytics').insert({
        'uid': uid,
        'last_opened': today,
      });
    }
    print('ANALYTICS SAVED');
}

void incrementChatsPerDay(String uid) async {
    final today = DateTime.now().toUtc().toString().split(' ')[0]; //YYYY-MM-DD format

    // Check if there's already a record for the current day
    final existingRecord = await supabase
        .from('tbl_analytics')
        .select()
        .eq('uid', uid)
        .eq('last_opened', today)
        .maybeSingle();

    if (existingRecord != null) {
      // If a record exists for today, increment the chats_per_day
      await supabase
          .from('tbl_analytics')
          .update({'total_chats_per_day': existingRecord['total_chats_per_day'] + 1})
          .eq('uid', uid)
          .eq('last_opened', today);
      print('CHATS PER DAY INCREMENTED');
    }
    
}