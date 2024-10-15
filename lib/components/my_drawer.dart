import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/auth/auth.dart';
import 'package:myeuc_x_supabase/main.dart';



class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        
        DrawerHeader(
          child: Image.asset('assets/logo.png')
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListTile(
            leading: Icon(Icons.question_mark_outlined),
            title: Text('About & FAQ'),
            onTap: () => {null
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListTile(
            leading: Icon(Icons.download),
            title: Text('Check for Updates'),
            onTap: () => {null
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () async{
              await supabase.auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ),



      ],),
    );
  }
}