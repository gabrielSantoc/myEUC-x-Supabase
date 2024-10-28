import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/components/nav_bar.dart';
import 'package:myeuc_x_supabase/main.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';
import 'package:myeuc_x_supabase/shared/buttons.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';
import 'package:myeuc_x_supabase/shared/textFields.dart';
import 'package:myeuc_x_supabase/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final loginFormKey = GlobalKey<FormState>();

  bool obscureTextFlag = true;
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();
  @override
  void dispose() {
    userEmailController.dispose();
    userPasswordController.dispose();
    super.dispose();
  }

  void login() async {


    if(loginFormKey.currentState!.validate()) {

      try {

        LoadingDialog.showLoading(context);
        await Future.delayed(const Duration(seconds: 3));
        
        final AuthResponse res = await supabase.auth.signInWithPassword(
          email: userEmailController.text.toString(),
          password: userPasswordController.text.toString(),
        );

        final User? user = res.user; // get authenticated user data object 
        final String userId = user!.id;  // get user id

        print("USER UIID::: $userId");

        LoadingDialog.hideLoading(context);
        Navigator.pushNamedAndRemoveUntil(context, '/homeScreen', (Route<dynamic> route) => false);

      } on AuthException catch(e) {
        
        Alert.of(context).showError(e.message);
        print("ERROR ::: ${e.code}");
        Navigator.pop(context);

      }
    }
  } 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFF9e0b0f),

      body: SingleChildScrollView(
        
        child: Stack(
          
          
          children: [

            Positioned(
              child: Container(
                height:  MediaQuery.of(context).size.height * 0.79,
                decoration: const BoxDecoration(
                  color:Color(0xFFe7e7e7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 1),
                      blurRadius: 15,
                      spreadRadius: 2.0,
                      color: Color.fromARGB(124, 0, 0, 0)
                    )
                  ]
                ),
              ),
            ),

            Center(
              child: Form(
                key: loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    
                    const SizedBox(height: 80),
                    
                    Image.asset('assets/logo.png', height: 285), //300
                      
                    const SizedBox(height: 35),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36,),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        margin: const EdgeInsets.only(bottom: 40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.16),
                              blurRadius: 6,
                              spreadRadius: 0,
                              offset: Offset(
                                0,
                                3,
                              ),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.23),
                              blurRadius: 6,
                              spreadRadius: 0,
                              offset: Offset(0, 3),
                            ),
                          ]

                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            MyTextFormField(
                              controller: userEmailController,
                              hintText: "Email",
                              obscureText: false,
                              validator: Validator.of(context).validateEmail
                            ),
                      
                            const SizedBox(height: 15),
                      
                            MyTextFormFieldPasword(
                                controller: userPasswordController,
                                hintText: 'Password',
                                obscureText: obscureTextFlag,
                                suffixIcon: GestureDetector(
                
                                  onTap: () {
                                    setState(() {
                                      obscureTextFlag = !obscureTextFlag;
                                      print("FLAGGGGGGG ${obscureTextFlag}");
                                    });
                                  },
                                  child: Icon( obscureTextFlag ?Icons.visibility_off :Icons.visibility )
                                ),
                                
                                validator: (value)=> Validator.of(context).validateTextField(value, "Password"),
                            ),
                        
                            const SizedBox(height: 20),
                        
                            const PasswordGuide(),
                        
                            const SizedBox(height: 15),
                        
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/forgotPasswordScreen');
                              },
                              child: const Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9e0b0f)
                                ),
                                
                              ),
                            ),
                        
                            const SizedBox(height: 20),
                        
                            Form(
                              child: Column(
                                children: [
                                  MyButton(
                                    onTap: login,
                                    buttonName: 'Login',
                                  ),
                                ],
                              ),
                            ),
                        
                            const SizedBox(height: 20),
                              
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                        
                                const Text("Don't have an account? ", style: TextStyle(fontSize: 11)),
                        
                                const SizedBox(width: 20),
                        
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/registerStudentScreen');
                                  },
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                      color: Color(0xFF9e0b0f),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}