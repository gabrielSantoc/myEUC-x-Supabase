import "package:flutter/material.dart";
import "package:hive_flutter/adapters.dart";
import "package:myeuc_x_supabase/auth/auth.dart";
import "package:myeuc_x_supabase/box/boxes.dart";
import "package:myeuc_x_supabase/features/calendar/model/eventModelHive.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import 'package:onesignal_flutter/onesignal_flutter.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://hnhrvnbwbgoxapeozfng.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhuaHJ2bmJ3YmdveGFwZW96Zm5nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg4MDkwNjEsImV4cCI6MjA0NDM4NTA2MX0.drUSk3I0LdhvtRAzNYJR66obrOMDgMC35a9-exKmBi4",
  );

  Hive.registerAdapter(EventModelHiveAdapter());
  await Hive.initFlutter();
  await Hive.openBox('customValues');
  boxEvents = await Hive.openBox<EventModelHive>('EventsBox');
  boxHeader = await Hive.openBox('HeaderBox');

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("69a54b3a-8ee1-46d9-92a4-2fe7cf38f772");
  OneSignal.Notifications.requestPermission(true);
  
  runApp(const MyApp());

}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return LoginPage();
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}
