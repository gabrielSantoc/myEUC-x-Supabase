import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/auth/auth.dart';
import 'package:myeuc_x_supabase/auth/update_password.dart';
import 'package:myeuc_x_supabase/components/manual.dart';
import 'package:myeuc_x_supabase/utils/markdown_utils.dart';
import 'package:myeuc_x_supabase/main.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';



class MyDrawer extends StatelessWidget {
  final VoidCallback? onUpdateComplete;

  const MyDrawer({Key? key,  this.onUpdateComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
        
          DrawerHeader(
            child: Image.asset('assets/logo.png')
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangePasswordScreen()))
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              leading: const Icon(Icons.book),
              title: const Text('User Manual'),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Manual()))
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
                Navigator.pushNamedAndRemoveUntil(context, '/authScreen', (Route<dynamic> route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}