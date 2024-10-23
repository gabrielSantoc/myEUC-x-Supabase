import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/auth/reset_password.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';
import 'package:myeuc_x_supabase/shared/buttons.dart';
import 'package:myeuc_x_supabase/shared/textFields.dart';
import 'package:myeuc_x_supabase/shared/validators.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future _passwordReset() async {

    try {

      // await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      Alert.of(context).showSuccess('Password reset link sent! Check your email 🥰🥰🥰');

    } catch (error) {
      
      Alert.of(context).showError('An error occured, please try again 😢😢😢');
      

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9e0b0f),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),


              const Text(
                'Enter your email and we will send you a token to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300
                ),
              ),
          
              const SizedBox(height: 40),
          
              MyTextFormField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
                validator: Validator.of(context).validateEmail,
              ),
              
              const SizedBox(height: 20),
          
              MyButton(
                onTap: _passwordReset,
                buttonName: 'Send Reset Password Token'
              ),

              const SizedBox(height: 20),

              GestureDetector(

                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const ResetPassowrdScreen())
                  );
                },

                child: const Text(
                  'Already have a token? Reset Your Password',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9e0b0f)
                  ),
                  
                ),
              ),

            ],  
          
          ),
        ),
      ),

    );
  }
}