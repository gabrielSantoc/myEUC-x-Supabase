import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myeuc_x_supabase/auth/login_page.dart';
import 'package:myeuc_x_supabase/components/nav_bar.dart';
import 'package:myeuc_x_supabase/main.dart';
import 'package:myeuc_x_supabase/shared/alert.dart';
import 'package:myeuc_x_supabase/shared/buttons.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';
import 'package:myeuc_x_supabase/shared/textFields.dart';
import 'package:myeuc_x_supabase/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';



class RegisterNew extends StatefulWidget {
  const RegisterNew({super.key});

  @override
  State<RegisterNew> createState() => _RegisterNewState();
}


class _RegisterNewState extends State<RegisterNew> {
  final registerFormKey = GlobalKey<FormState>();

  final _studentNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearLevelController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _birthDateController = TextEditingController();

  final double sizeBoxHeight = 20;


  @override
  void dispose() {
    _studentNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }
  

  bool isStudentBonafide = false;
  // Function to validate student if bonafide or not based on the enrollment records
  // Queries the database using the student's provided credentials.
  // If it has a result, `isStudentBonafide` will be set to true.
  Future<void> validateStudent() async{  

    try {
      final studentToSearch = await 
        Supabase.instance.client
        .from('tbl_bonafide_students')
        .select()
        .eq('student_number', _studentNumberController.text.trim().toUpperCase())
        .eq('first_name', _firstNameController.text.trim().toUpperCase())
        .eq('last_name', _lastNameController.text.trim().toUpperCase());
    
      if(studentToSearch.isNotEmpty) {
        print("STUDENT IS BONAFIDE");
        print("STUDENT TO SEARCH :::: $studentToSearch");
        setState(() {
          isStudentBonafide = true;
        });

      } 
      else {
        print("NOT BONAFIDE");
        print(" BONAFIDE");
        print("STUDENT TO SEARCH :::: $studentToSearch");
      } 
    } catch (e) {
      Alert.of(context).showError("$e");
    }
  }

  // add user details
  Future createUser(String studentNo, String firstName, String lastName, String yearLevel, String course, String birthDate, String email, String authId) async{

    await Supabase.instance.client
    .from('tbl_users')
    .insert({
      'student_number': studentNo,
      'first_name'  : firstName,
      'last_name'   : lastName,
      'year_level'  : yearLevel,
      'course'      : course,
      'birthdate'    : birthDate,
      'email'       : email,
      'auth_id'     : authId
    });

    print("USER CREATED SUCCESSFULLY");
  }

  
  // ANCHOR - FUNCTION TO SELECT COURSE
  final List<String> _levels = ['1', '2', '3', '4',];
  Future<void> selectYearLevel() async {
    // Show the Cupertino modal popup
    await showCupertinoModalPopup<String>(
      context: context,
      builder: (_) {
        return SizedBox(
          width: double.infinity,
          height: 250,
          child: CupertinoPicker(
            onSelectedItemChanged: (int value) {
              
              setState(() {
                _yearLevelController.text = _levels[value];
              });
              print('SECTION :::: ${_levels[value]}'); 
            },
            backgroundColor: Colors.white,
            itemExtent: 30,
            scrollController: FixedExtentScrollController(
              initialItem: 0, 
            ),
            children: _levels.map((course) => Text(course)).toList(),
          ),
        );
      },
    );
  }

  // ANCHOR - FUNCTION TO SELECT COURSE
  final List<String> _course = ['BSCS', 'BSCE', 'BSN', 'BSBA', 'BSA'];
  Future<void> selectSection() async {
    // Show the Cupertino modal popup
    await showCupertinoModalPopup<String>(
      context: context,
      builder: (_) {
        return SizedBox(
          width: double.infinity,
          height: 250,
          child: CupertinoPicker(
            onSelectedItemChanged: (int value) {
              
              setState(() {
                _courseController.text = _course[value];
              });
              print('SECTION :::: ${_course[value]}'); 
            },
            backgroundColor: Colors.white,
            itemExtent: 30,
            scrollController: FixedExtentScrollController(
              initialItem: 0, 
            ),
            children: _course.map((course) => Text(course)).toList(),
          ),
        );
      },
    );
  }


 // FUNCTION TO CREATE A NEW ACCOUNT
  void  registerAccount () async{
    await validateStudent();

    if(registerFormKey.currentState!.validate()) {

      if( isStudentBonafide ) {

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
            _studentNumberController.text.toString().trim(),
            _firstNameController.text.toString().trim(),
            _lastNameController.text.toString().trim(),
            _yearLevelController.text.toString().trim(),
            _courseController.text.toString().trim(),
            _birthDateController.text.toString().trim(),
            _emailController.text.toString().trim(),
            userId
          );
          
          LoadingDialog.hideLoading(context);
          print("NEW USER UIID::: $userId");
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NavBar())
          );


        } on AuthException catch(e) {
          LoadingDialog.hideLoading(context);
          Alert.of(context).showError(e.message);
          print("ERROR ::: ${e.code}");

        }

      } else {
          
        Alert.of(context).showError("Student not found, please retry");

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
                height: MediaQuery.of(context).size.height * 0.23,
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
                          fontSize: 34,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                  
                      Text(
                        "Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
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
                  padding: const EdgeInsets.symmetric(vertical: 34),
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
          
                      MyTextFormField(
                        controller: _studentNumberController,
                        hintText: "Student ID",
                        obscureText: false,
                        validator: Validator.of(context).validateStudentNumber,
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

                      // ANCHOR - COURSE AND DEPARTMENT
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                            children: [
                              Expanded(
                                child: MyTextFormFieldShortReadOnly(
                                  onTap: selectSection,
                                  controller: _courseController,
                                  hintText: "Course",
                                  obscureText: false,
                                  validator: (value)=> Validator.of(context).validateTextField(value, "Course"),
                                ),
                              ),

                              const SizedBox(width: 13),
                              
                              Expanded(
                                child: MyTextFormFieldShortReadOnly(
                                  onTap: selectYearLevel,
                                  controller: _yearLevelController,
                                  hintText: "Year Level",
                                  obscureText: false,
                                  validator: (value)=> Validator.of(context).validateYearLevel(value, "Year Level"),
                                ),
                              ),
                            ],
                          ),
                      ),
                  
                      SizedBox(height: sizeBoxHeight),
                      //Birth Date
                  
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
                          .validateConfirmEmail(value, _emailController.text);
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
                  
                          const Text("Already have an account? "),
                  
                          const SizedBox(width: 20),
                  
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LogIn()) //signup
                              );
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                color: Color(0xFF9e0b0f),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                        
                      ),
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