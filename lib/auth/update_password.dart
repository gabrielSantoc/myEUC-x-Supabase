import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/components/nav_bar.dart';
import 'package:myeuc_x_supabase/main.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';
import 'package:myeuc_x_supabase/shared/app_dialog.dart';
import 'package:myeuc_x_supabase/shared/buttons.dart';
import 'package:myeuc_x_supabase/shared/textFields.dart';
import 'package:myeuc_x_supabase/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final changePasswordFormKey = GlobalKey<FormState>();

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

  Future _passwordReset() async {

    if(changePasswordFormKey.currentState!.validate()) {
      try {

        final res = await supabase.auth.updateUser(
          UserAttributes(
            password: _passwordController.text.trim()
          )
        );
        
        AppDialog.showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Password updated sucessfully.',
          onConfirm: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const NavBar()),
              (Route<dynamic> route) => false
            );
          }
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
            key: changePasswordFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
            
            
                const Text(
                  'Update your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300
                  ),
                ),
            
                const SizedBox(height: 40),
            
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
                    .validateConirmPassword(value, _passwordController.text.trim());
                  }
                ),
            
                const SizedBox(height: 20),
            
                MyButton(
                  onTap: _passwordReset,
                  buttonName: 'Update'
                )
            
              ],  
            
            ),
          ),
        ),
      ),

    );
  }
}