import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/auth/login_page.dart';
import 'package:myeuc_x_supabase/components/nav_bar.dart';
import 'package:myeuc_x_supabase/helper/helper_functions.dart';
import 'package:myeuc_x_supabase/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final authSubscription = supabase.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;
    final Session? session = data.session;

    print('event: $event, session: $session');

    switch (event) {
      case AuthChangeEvent.initialSession:
      // handle initial session
      case AuthChangeEvent.signedIn:
      // handle signed in
      case AuthChangeEvent.signedOut:
      // handle signed out
      case AuthChangeEvent.passwordRecovery:
      // handle password recovery
      case AuthChangeEvent.tokenRefreshed:
      // handle token refreshed
      case AuthChangeEvent.userUpdated:
      // handle user updated
      case AuthChangeEvent.userDeleted:
      // handle user deleted
      case AuthChangeEvent.mfaChallengeVerified:
      // handle mfa challenge verified
    }

  });
  
  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed to prevent memory leaks
    authSubscription.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: supabase.auth.onAuthStateChange,
        builder: (context, snapshot) {

          final AuthState? authState = snapshot.data;
          final Session? session = authState?.session;
          
          if(snapshot.hasData) {

            print("SESSION ::: $session");

            if(session != null) {

              updateAnalytics(session.user.id);
              
              return const NavBar();

            } else {

              return const LogInScreen();
            }

          } else if(snapshot.hasError) {

            return Center(child: Text('Error :: ${snapshot.error}'));
            
          } else {
            return const Center(child: CircularProgressIndicator());
          }

        }
      ),
    );
  }
}