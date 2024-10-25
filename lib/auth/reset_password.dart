import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/auth/auth.dart';
import 'package:myeuc_x_supabase/components/nav_bar.dart';
import 'package:myeuc_x_supabase/main.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';
import 'package:myeuc_x_supabase/shared/app_dialog.dart';
import 'package:myeuc_x_supabase/shared/buttons.dart';
import 'package:myeuc_x_supabase/shared/textFields.dart';
import 'package:myeuc_x_supabase/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPassowrdScreen extends StatefulWidget {
  const ResetPassowrdScreen({super.key});

  @override
  State<ResetPassowrdScreen> createState() => _ResetPassowrdScreenState();
}

class _ResetPassowrdScreenState extends State<ResetPassowrdScreen> {
  final resetPasswordFormKey = GlobalKey<FormState>();


  final TextEditingController _resetTokenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool obscureTextFlagForNewPassword = true;
  bool obscureTextFlagForConfirmNewPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }


  void showAlertDialog(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Sucess'),
        content: const Text('Password updated successfully.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () {
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const NavBar()),
                (route) => false,
              );

            },
            child: const Text('close'),
          ),
        ],
      ),
    );
  }

  Future resetPassword() async {

    if(resetPasswordFormKey.currentState!.validate()) {

      try {

        final recovery = await supabase.auth.verifyOTP(
          email: _emailController.text.toString().trim(),
          token: _resetTokenController.text.toString().trim(),
          type: OtpType.recovery,
        );

        print("Recovery ::: ${recovery}");

        final res = await supabase.auth.updateUser(
          UserAttributes(
            password: _passwordController.text.trim()
          )
        );

        AppDialog.showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Your password has been changed. You can now log in with your new credentials. 🥰🥰🥰',
          onConfirm: ()=> Navigator.pushNamedAndRemoveUntil(context, '/homeScreen', (Route<dynamic> route) => false)
        );

      } on AuthException catch (error) {
        
        Alert.of(context).showError('${error.message} 😢😢😢');
        
      }

    } else {

      Alert.of(context).showError("Make sure your password match");

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
          child: Form(
            key: resetPasswordFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
            
            
                const Text(
                  'Reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300
                  ),
                ),

                const SizedBox(height: 40),

                MyTextFormField(
                  controller: _resetTokenController,
                  hintText: "Reset Token",
                  obscureText: false,
                  validator: (value) => Validator.of(context).validateTextField(value, 'Reset Token'),
                ),

                const SizedBox(height: 10),

                MyTextFormField(
                  controller: _emailController,
                  hintText: "Email",
                  obscureText: false,
                  validator: Validator.of(context).validateEmail,
                ),

                const SizedBox(height: 10),
                
            
                MyTextFormFieldPasword(
                  controller: _passwordController,
                  hintText: 'New Password',
                  obscureText: obscureTextFlagForNewPassword,
                  suffixIcon: GestureDetector(
            
                    onTap: () {
                      setState(() {
                        obscureTextFlagForNewPassword = !obscureTextFlagForNewPassword;
                      });
                    },
                    child: Icon( obscureTextFlagForNewPassword ?Icons.visibility_off :Icons.visibility )
                  ),
                  
                  validator: (value)=> Validator.of(context).validateTextField(value, "New Password"),
                ),
                
                const SizedBox(height: 10),
            
                MyTextFormFieldPasword(
                  controller: _newPasswordController,
                  hintText: 'Confirm New Password',
                  obscureText: obscureTextFlagForConfirmNewPassword,
                  suffixIcon: GestureDetector(
            
                    onTap: () {
                      setState(() {
                        obscureTextFlagForConfirmNewPassword =! obscureTextFlagForConfirmNewPassword;
                      });
                    },
                    child: Icon( obscureTextFlagForConfirmNewPassword ?Icons.visibility_off :Icons.visibility )
                  ),
                  
                  validator: (value) {
                    return Validator.of(context)
                    .validateConfirmation(
                      value,
                      _passwordController.text.trim(),
                      'Password'
                    );
                  }
                ),
            
                const SizedBox(height: 20),
            
                MyButton(
                  onTap: resetPassword,
                  buttonName: 'Reset'
                )
            
              ],  
            
            ),
          ),
        ),
      ),

    );
  }
}