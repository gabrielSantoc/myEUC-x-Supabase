import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myeuc_x_supabase/auth/login_page.dart';
import 'package:myeuc_x_supabase/auth/register_page.dart';
import 'package:myeuc_x_supabase/components/nav_bar.dart';
import 'package:myeuc_x_supabase/main.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';
import 'package:myeuc_x_supabase/shared/buttons.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';
import 'package:myeuc_x_supabase/shared/textFields.dart';
import 'package:myeuc_x_supabase/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';



class RegisterTeacherScreen extends StatefulWidget {
  const RegisterTeacherScreen({super.key});

  @override
  State<RegisterTeacherScreen> createState() => RegisterTeacherScreenState();
}


class RegisterTeacherScreenState extends State<RegisterTeacherScreen> {
  final registerFormKey = GlobalKey<FormState>();

  final _idNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _birthDateController = TextEditingController();

  final double sizeBoxHeight = 15;


  @override
  void dispose() {
    _idNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }
  

  bool isTeacherBonafide = false;
  // Function to validate teacher if bonafide or not
  Future<void> validateTeacher() async{  

    try {
      final teacherToSearch = await 
        Supabase.instance.client
        .from('tbl_bonafide_teachers')
        .select()
        .eq('id_number', _idNumberController.text.trim().toUpperCase())
        .eq('first_name', _firstNameController.text.trim().toUpperCase())
        .eq('last_name', _lastNameController.text.trim().toUpperCase());
    
      if(teacherToSearch.isNotEmpty) {
        print("TEACHER IS BONAFIDE");
        print("TEACHER TO SEARCH :::: $teacherToSearch");
        setState(() {
          isTeacherBonafide = true;
        });

      } 
      else {
        print("NOT BONAFIDE");
        print(" BONAFIDE");
        print("TEACHER TO SEARCH :::: $teacherToSearch");
      } 
    } catch (e) {
      Alert.of(context).showError("$e");
    }
  }

  // add user details
  Future createUser(String studentNo, String firstName, String lastName, String birthDate, String email, String authId) async{

    await Supabase.instance.client
    .from('tbl_users')
    .insert({
      'student_number': studentNo,
      'first_name'  : firstName,
      'last_name'   : lastName,
      'year_level'  : null,
      'course'      : null,
      'birthdate'   : birthDate,
      'email'       : email,
      'auth_id'     : authId,
      'role'        : 'teacher'
    });

    print("USER CREATED SUCCESSFULLY");
  }


 // FUNCTION TO CREATE A NEW ACCOUNT
  void  registerAccount () async{
    await validateTeacher();

    if(registerFormKey.currentState!.validate()) {

      if( isTeacherBonafide ) {

        try{

          LoadingDialog.showLoading(context);
          await Future.delayed(const Duration(seconds: 2));

          final AuthResponse res = await supabase.auth.signUp(
            email: _emailController.text.trim(),
            password: _birthDateController.text.trim(),
          );

          final User? user = res.user; // get authenticated user data object 
          final String userId = user!.id;  // get user id

          await createUser(
            _idNumberController.text.toString().trim(),
            _firstNameController.text.toString().trim(),
            _lastNameController.text.toString().trim(),
            _birthDateController.text.toString().trim(),
            _emailController.text.toString().trim(),
            userId
          );
          
          LoadingDialog.hideLoading(context);
          print("NEW USER UIID::: $userId");
          
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NavBar()),
            (Route<dynamic> route) => false
          );


        } on AuthException catch(e) {
          
          LoadingDialog.hideLoading(context);
          Alert.of(context).showError(e.message);
          print("ERROR ::: ${e.code}");

        }

      } else {
          
        Alert.of(context).showError("User not found, please retry");

      }

    }

  }   

  DateTime birthDay = DateTime.now();
  selectDate() async{

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDay,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      birthDay = picked;
      
      var formattedBirthDay = DateFormat('yyyy-MM-dd');
      _birthDateController.text = formattedBirthDay.format(birthDay);

      print('BIRTHDAYYYY ::::: ${formattedBirthDay.format(birthDay)}'); 
    }
  }

  // TOGGLE BUTTON
  List<bool> isSelected = [ false, true ];
  List registerScreen = [
    const RegisterStudentScreen(),
    const RegisterTeacherScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFe7e7e7),

      body: SingleChildScrollView(
        
        child: Form(
          key: registerFormKey,
          child: Column(
            
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.22,
                decoration: const BoxDecoration(
                  color: Color(0xFF9e0b0f),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 15,
                      spreadRadius: 2.0,
                      color: Color.fromARGB(124, 0, 0, 0)
                    )
                  ]
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                  
                      Text(
                        "Create Your",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                  
                      Text(
                        "Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                  
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          
              const SizedBox(height: 20),
              
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.23),
                        blurRadius: 6,
                        spreadRadius: 0,
                        offset: Offset(0, 3)
                      ),
                    ]
                  ),
                  child: Column(

                    children: [
                      ToggleButtons(
                        onPressed: (int index) {
                          setState(() {
                            if(index == 0) {
                              Navigator.pushNamed(context, '/registerStudentScreen');
                            }
                          });
                        },
                        
                        isSelected: isSelected,
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: MAROON,
                        selectedColor: MAROON,
                        fillColor: GRAY,
                        constraints: const BoxConstraints(
                          minHeight: 25.0,
                          minWidth: 85.0,
                        ),
                        children: const [
                          Text("Student"),
                          Text("Teacher"),
                        ],

                      ),

                      const SizedBox(height: 5),
          
                      MyTextFormField(
                        controller: _idNumberController,
                        hintText: "ID Number",
                        obscureText: false,
                        validator: (value)=> Validator.of(context)
                        .validateWithRegex(
                          value,
                          'ID number cannot found',
                          'StudentNumber',
                          RegExp(r'^A\d{2}-\d{4}$')
                        ),
                      ),
                        
                      SizedBox(height: sizeBoxHeight),
                
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                            children: [
                              Expanded(
                                
                                child: MyTextFormFieldShort(
                                  controller: _firstNameController,
                                  hintText: "First Name",
                                  obscureText: false,
                                  validator: (value)=> Validator.of(context).validateTextField(value, "First name"),
                                ),
                              ),
                              
                              const SizedBox(width: 13),
                              
                              Expanded(
                                child: MyTextFormFieldShort(
                                  controller: _lastNameController,
                                  hintText: "Last Name",
                                  obscureText: false,
                                  validator: (value)=> Validator.of(context).validateTextField(value, "Last name"),
                                ),
                              )
                            ],
                          ),
                      ),

                      SizedBox(height: sizeBoxHeight),
                  
                      MyTextFieldFormBrithday(
                        onTap: selectDate,
                        controller: _birthDateController,
                        hintText: "Birth Date",
                        obscureText: false,
                        validator:(value)=> Validator.of(context).validateTextField(value, "Birth Date"),
                      ),
                      
                      SizedBox(height: sizeBoxHeight),
                          
                      // Email
                      MyTextFormField(
                        controller: _emailController,
                        hintText: "Email",
                        obscureText: false,
                        validator: Validator.of(context).validateEmail,
                      ),
                  
                      SizedBox(height: sizeBoxHeight),
                          
                      // Confirm Email
                      MyTextFormField(
                        controller: _confirmEmailController,
                        hintText: "Confirm Email",
                        obscureText: false,
                        validator: (value) {
                          return Validator.of(context)
                          .validateConfirmation(value, _emailController.text, 'Confirm Email');
                        }
                      ),
                  
                      const SizedBox(height: 20),
                
                      Form(
                        child: Column(
                          children: [
                            MyButton(
                              onTap: registerAccount,
                              buttonName: 'Create Account',
                            ),
                          ],
                        ),
                      ),
                  
                      const SizedBox(height: 20),
                        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                  
                          const Text("Already have an account? ", style: TextStyle(fontSize: 11),),
                  
                          const SizedBox(width: 20),
                  
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LogInScreen()) //signup
                              );
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                color: MAROON,
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                              ),
                            ),
                          ),
                        ],
                        
                      ),
                       const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
          
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}