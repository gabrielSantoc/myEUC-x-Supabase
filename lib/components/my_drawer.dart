import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/auth/auth.dart';
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
      child: Column(children: [
        
        DrawerHeader(
          child: Image.asset('assets/logo.png')
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListTile(
            leading: Icon(Icons.book),
            title: Text('User Manual'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Manual()))
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListTile(
            leading: Icon(Icons.download),
            title: Text('Check for Updates'),
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