import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/auth/update_password.dart';
import 'package:myeuc_x_supabase/utils/markdown_utils.dart';
import 'package:myeuc_x_supabase/main.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';



class MyDrawer extends StatelessWidget {
  final VoidCallback? onUpdateComplete;

  const MyDrawer({Key? key,  this.onUpdateComplete}) : super(key: key);

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
            leading: const Icon(Icons.password),
            title: const Text('Change password'),
            onTap: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen())
              );
            } 
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListTile(
            leading: const Icon(Icons.question_mark_outlined),
            title: const Text('About & FAQ'),
            onTap: () => {
              
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Check for Updates'),
            onTap: () async{
              
              await MarkdownUtils.updateMarkdownFile();
              Alert.of(context).showSuccess('Handbook is already updated. 🥰🥰🥰');
              Navigator.pop(context);
              onUpdateComplete!();

            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async{
              await supabase.auth.signOut();
            },
          ),
        ),
      ],),
    );
  }
}