import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/auth/auth.dart';
import 'package:myeuc_x_supabase/auth/update_password.dart';
import 'package:myeuc_x_supabase/components/FAQ_screen.dart';
import 'package:myeuc_x_supabase/components/about_dev_screen.dart';
import 'package:myeuc_x_supabase/components/manual.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';
import 'package:myeuc_x_supabase/utils/markdown_utils.dart';
import 'package:myeuc_x_supabase/main.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



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
              leading: const Icon(Icons.question_answer),
              title: const Text('FAQ'),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const FAQScreen()))
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              leading: const Icon(Icons.boy_outlined),
              title: const Text('About Developers'),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutDevelopersScreen()))
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () async{
                LoadingDialog.showLoading(context);
                await Future.delayed(const Duration(seconds: 2));
                LoadingDialog.hideLoading(context);
                await supabase.auth.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const AuthScreen()));
                print("Signed out successfully🥰");
              },
            ),
          ),
        ],
      ),
    );
  }
}